#!/usr/local/bin/ruby

class Attendance_Processing

    def initialize(sid = nil, date = nil)
        
        super()
        
        #start = Time.new
        
        @excused_codes     = $tables.attach("ATTENDANCE_CODES"  ).code_array("WHERE code_type = 'excused'")
        @unexcused_codes   = $tables.attach("ATTENDANCE_CODES"  ).code_array("WHERE code_type = 'unexcused'")
        @activity_sources  = $tables.attach("ATTENDANCE_SOURCES").source_array("activity")
        @live_sources      = $tables.attach("ATTENDANCE_SOURCES").source_array("live")
        
        if sid && date
            
            temporarily_mark_as_flex(sid)
            
            finalize if set_student(sid, date)
            
        elsif !sid && !date
            
            temporarily_mark_as_flex
            
            $tables.attach("student_attendance").primary_ids(" WHERE complete IS FALSE ").each{|pid|
                
                fields = $tables.attach("student_attendance").by_primary_id(pid).fields
                
                finalize if set_student(fields["student_id"].value, fields["date"].value)
                
            }
            
        end
        
        #puts "completed in #{(Time.new - start)/60} minutes"
        
    end

    def finalize
        
        @override = attendance_department_override  unless @override
        @override = testing_day_override            unless @override
        @override = academic_plan_override          unless @override
        
        unless @override
            
            new_student_buffer
            
            case @stu_daily_mode
            when /Asynch/
                
                asychronous_attendance
                
            when /Synch/
                
                synchronous_attendance
                
            when /Flex|HS Senior Project/
                
                flex_attendance
                
            when /Withdrawn|SED/
                
                not_enrolled_attendance
                
            when /Exempt/
                
                exempt_attendance
                
            end
            
        end
        
        @stu_attendance_master_field.value = @finalize_code
        @stu_attendance_master_field.save
        
        @stu_student_attendance_record.fields["official_code"].value = @finalize_code
        @stu_student_attendance_record.save
        
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MARK_ATTENDANCE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def asychronous_attendance
        
        #STUDENT MUST HAVE ACTIVITY
        
        @finalize_code = "u"
        
        if @stu_student_attendance_record.fields["code"].value
            
            codes = @stu_student_attendance_record.fields["code"].value.split(",")
            
            codes.each{|code|
                
                this_code = code.gsub("p-","").gsub(" - LC","")
                
                if @this_days_sources.find{|x| x.match(/#{this_code}/)}
                
                @finalize_code = "p" if @activity_sources.include?(this_code)
                
                end
                
            }
            
        end
        
    end
  
    def exempt_attendance
        
        @finalize_code = "p"
        
    end
  
    def flex_attendance
        
        if !@stu_student_attendance_record.fields["code"].value.nil?
            
            @finalize_code = "p"
            
        else
            
            @finalize_code = "u"
            
        end
        
    end
  
    def not_enrolled_attendance
        
        @finalize_code = "NULL"
        
    end
  
    def synchronous_attendance
        
        #STUDENT MUST HAVE BOTH LIVE AND ACTIVITY
        
        @finalize_code = "u"
        
        attended_types = Array.new
        
        if @stu_student_attendance_record.fields["code"].value
            
            codes = @stu_student_attendance_record.fields["code"].value.split(",")
            
            codes.each{|code|
                
                this_code = code.gsub("p-","").gsub(" - LC","")
                
                if @this_days_sources.find{|x| x.match(/#{this_code}/)}
                    
                    attended_types.push("activity") if @activity_sources.include?(this_code )
                    attended_types.push("live"    ) if @live_sources.include?(this_code     )
                    
                end
                
            }
            
            if attended_types.include?("activity") && attended_types.include?("live")
                
                @finalize_code = "p"
                
            end
            
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OVERRIDE_ATTENDANCE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attendance_department_override
        
        override_codes = @excused_codes + ["pr","ur"]
        
        if override_codes.include?(@stu_attendance_master_field.value)
            
            @finalize_code = @stu_attendance_master_field.value
            
            return true
            
        else
            
            return false
            
        end
        
    end
  
    def academic_plan_override
        
        if @stu_daily_mode == "Academic Plan"
            
            if @stu_attendance_ap_records
                
                attended_values = Array.new
                
                @stu_attendance_ap_records.each{|record|
                    
                    attended_values.push(record.fields["attended"].value)
                    
                }
                
                if attended_values.include?("0") #if anyone marks them unexcused then they are "uap"
                    
                    @finalize_code = "uap"
                    
                else
                    
                    @finalize_code = "pap"
                    
                end
                
                return true
                
            else
                
                @stu_daily_mode = "Flex"
                @stu_student_attendance_record.fields["mode"].value = "Flex"
                @stu_student_attendance_record.save
                
                return false
                
            end
            
        else
            
            return false
            
        end
        
    end
  
    def testing_day_override
        
        if @stu_attendance_testing_records
            
            strict = true
            testing_day_att_code = nil
            
            @stu_attendance_testing_records.each{|test_record|
                
                if testing_day_att_code != "pt"
                    
                    if test_record.fields["attendance_code"].value != "Resched" && !test_record.fields["attendance_code"].value.nil?
                        
                        testing_day_att_code = test_record.fields["attendance_code"].value
                        
                        optional_events_site_ids = $tables.attach("TEST_EVENT_SITES").primary_ids("WHERE test_event_id REGEXP '2'")
                        
                        strict = false if optional_events_site_ids.include?(test_record.fields["test_event_site_id"].value)
                        
                    end
                    
                end
                
            }
            
            if !testing_day_att_code.nil?
                
                if strict || testing_day_att_code == "pt"
                    
                    @finalize_code = testing_day_att_code
                    
                    return true
                    
                else
                    
                    return false
                    
                end
                
            else
                
                return false
                
            end
            
        else
            
            return false
            
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
  
    def set_student(sid, date)
        
        @sid                            = sid
        @date                           = date
        
        @stu_attendance_master_field    = $tables.attach("STUDENT_ATTENDANCE_MASTER" ).field_bystudentid("code_#{@date}", @sid)
        @stu_student_attendance_record  = $tables.attach("STUDENT_ATTENDANCE").by_studentid_old(@sid, @date)
        
        if @stu_attendance_master_field && @stu_student_attendance_record
            
            @stu_daily_mode                 = @stu_student_attendance_record.fields["mode"].value
            sources                         = $tables.attach("ATTENDANCE_MODES").sources_by_mode(@stu_daily_mode)
            @this_days_sources              = (sources && sources.value) ? sources.value.split(",") : []
            
            @stu_attendance_testing_records = $tables.attach("STUDENT_TEST_DATES"   ).by_studentid_old(@sid, @date)
            @stu_attendance_ap_records      = $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(@sid, staff_id = nil, @date)
            
            @finalize_code                  = nil
            
            @override                       = false
            
            return true
            
        else
            
            return false
            
        end
        
    end
  
    def new_student_buffer
        
        #ALLOW THE STUDENT A 5 DAY BUFFER WHERE THEY ARE MARKED FLEX
        
        student_enroll_date   = $students.get(@sid).schoolenrolldate.mathable
        enroll_date_qualifies = student_enroll_date && (student_enroll_date >= (DateTime.now - 7)) && (student_enroll_date <= (student_enroll_date + 7))
        mode_qualifies        = ( @stu_daily_mode.match(/Synch/) || @stu_daily_mode.match(/Asynch/) )
        
        if enroll_date_qualifies && mode_qualifies
            
            att_date              = att_record.fields["date"].mathable
            att_date_qualifies    = (att_date >= (DateTime.now - 7)) && (att_date <= (student_enroll_date + 7))
            
            if att_date_qualifies
                
                @stu_student_attendance_record.fields["mode"].value = "Flex"
                @stu_student_attendance_record.save
                
            end
            
        end
        
    end
  
    def temporarily_mark_as_flex(sid = nil)
        
        query = "UPDATE `student_attendance`
            LEFT JOIN student ON student_attendance.student_id = student.student_id
            SET mode = 'Flex'
            WHERE date >= '2013-09-01'
            AND mode REGEXP 'HS|MS|K8'"
        
        if sid
            
            query << " AND student_attendance.student_id = '#{sid}'"
            
        end
        
        $db.query(query)
        
    end
  
    def attendance_master_report(cutoff_date = $base.yesterday.iso_date)
        
        require "#{$paths.system_path}reports/attendance_reports" 
        att_master_path     = Attendance_Reports.new.attendance_master(cutoff_date)
        
        zip_att_master_path = att_master_path.gsub(".csv",".zip")
        zip_file            = Zip::ZipFile.open(zip_att_master_path, Zip::ZipFile::CREATE)
        zip_file.add(att_master_path.split("/")[-1], att_master_path)
        zip_file.close
        
        $base.email.athena_smtp_email(
            
            recipients    = ["crivera@agora.org","jhalverson@agora.org","apickens@agora.org"],
            subject       = "Attendance Master Report",
            content       = "Please find the attached reports",
            attachments   = zip_att_master_path
            
        )
        
    end
  
    def truancy_report(cutoff_date = $base.yesterday.iso_date)
        
        require "#{$paths.system_path}reports/truancy_withdrawals_report"
        truancy_path      = Truancy_Withdrawals_Report.new.generate(cutoff_date)
        
        zip_truancy_path  = truancy_path.gsub(".csv",".zip")
        zip_file = Zip::ZipFile.open(zip_truancy_path, Zip::ZipFile::CREATE)
        zip_file.add(truancy_path.split("/")[-1], truancy_path)
        zip_file.close
        
        $base.email.athena_smtp_email(
            
            recipients    = ["crivera@agora.org","jhalverson@agora.org","apickens@agora.org"],
            subject       = "Truancy Report",
            content       = "Please find the attached reports",
            attachments   = zip_truancy_path
            
        )
        
    end
  
end