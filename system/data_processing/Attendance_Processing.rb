#!/usr/local/bin/ruby

class Attendance_Processing

    def initialize(sid = nil, date = nil)
        super()
        
        #start = Time.new
        
        @excused_codes     = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE code_type = 'excused'",          {:value_only=>true})
        @unexcused_codes   = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE code_type = 'unexcused'",        {:value_only=>true})
        @override_codes    = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE overrides_procedure IS TRUE",    {:value_only=>true})
        
        if sid && date
            
            finalize if set_student(sid, date)
            
        elsif !sid && !date
            
            $tables.attach("student_attendance").primary_ids(" WHERE complete IS FALSE ").each{|pid|
                
                fields = $tables.attach("student_attendance").by_primary_id(pid).fields
                
                finalize if set_student(fields["student_id"].value, fields["date"].value)
                
            }
            
        end
        
        #puts "completed in #{(Time.new - start)/60} minutes"
        
    end

    def finalize
        
        @override = attendance_department_override  unless @override
        @override = orientation_override            unless @override
        @override = testing_day_override            unless @override
        @override = academic_plan_override          unless @override
        
        unless @override
            
            case @stu_daily_procedure_type
            when "Activity"
                
                @finalize_code = has_activity ? "p" : "u"
                
            when "Activity AND Live Sessions"
                
                @finalize_code = (has_live && has_activity) ? "p" : "u"
                
            when "Activity OR Live Sessions"
                
                @finalize_code = (has_live || has_activity) ? "p" : "u"
                
            when "Live Sessions"
                
                @finalize_code = has_live ? "p" : "u"
                
            when "Classroom Activity (50% or more)"
                
                if (active = classrooms_active).length > 0
                    @finalize_code = (active.length.to_f/classrooms_total.length.to_f > 0.5 ? "p" : "u")
                else
                    @finalize_code = "u"
                end
                
            when "Not Enrolled"
                
                @finalize_code = "NULL"
                
            end
            
        end
        
        student_attendance_master_field.set(@finalize_code).save
        
        student_attendance_record.fields["official_code"].set(@finalize_code).save
        
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MARK_ATTENDANCE_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def classrooms_active
        
        active = Array.new
        @stu_daily_codes.each{|code|
            
            if @classroom_sources.find{|x|x.match(/#{code.split(":")[0]}/)}
                
                active.push(code) if (code.split(" - ")[-1] == "p")
                
            end
            
        }
        
        return active
        
    end
    
    def classrooms_total
        
        total = Array.new
        @stu_daily_codes.each{|code|
            
            total.push(code) if @classroom_sources.find{|x|x.match(/#{code.split(":")[0]}/)}
            
        }
        
        return total
        
    end
    
    def has_live
        
        has_live = false
        @live_sources.each{|live_source|
            
            has_live = true if @stu_daily_codes.include?(live_source)   
            
        }
        
        return has_live
        
    end
    
    def has_activity
        
        has_activity = false
        @activity_sources.each{|activity_source|
            
            has_activity = true if @stu_daily_codes.include?(activity_source)    
            
        }
        
        return has_activity
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OVERRIDE_ATTENDANCE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attendance_department_override
        
        master_code = student_attendance_master_field.value
        if @override_codes.include?(master_code)
            
            @finalize_code = master_code
            
            return true
            
        else
            
            return false
            
        end
        
    end
  
    def academic_plan_override
        
        if @stu_daily_mode == "Academic Plan"
            
            if @stu_attendance_ap_records
                
                source = "Academic Plan"
                
                attended_values = Array.new
                
                @stu_attendance_ap_records.each{|record|
                    
                    attended_values.push(record.fields["attended"].value)
                    
                }
                
                if attended_values.include?("0") #if anyone marks them unexcused then they are "uap"
                    
                    remove_attendance_activity(source)
                    @finalize_code = "uap"
                    
                else
                    
                    log_attendance_activity(source)
                    @finalize_code = "pap"
                    
                end
                
                return true
                
            else
                
                @stu_daily_mode = "Flex"
                student_attendance_record.fields["mode"].set("Flex").save
                
                return false
                
            end
            
        else
            
            return false
            
        end
        
    end
  
    def orientation_override
        
        student_enroll_date = $students.get(@sid).schoolenrolldate.mathable
        
        enrolled_in_orn     = true#MUST ALSO CURRENTLY BE ENROLLED IN ORIENTATION - Create check for this here
        
        if (enrolled_in_orn && student_enroll_date && (student_enroll_date >= (DateTime.now - 4)) && (student_enroll_date <= (student_enroll_date + 4)))
            
            att_date = att_record.fields["date"].mathable
            
            if (att_date >= (DateTime.now - 4)) && (att_date <= (student_enroll_date + 4))
                
                source = "Orientation"
                
                orn = Array.new
                orn.push(@stu_daily_sapphire_period_attendance.fields["PERIOD_ELO"   ].value)
                orn.push(@stu_daily_sapphire_period_attendance.fields["PERIOD_MO"    ].value)
                orn.push(@stu_daily_sapphire_period_attendance.fields["PERIOD_ORN"   ].value)
                orn.compact!
                
                orn = !orn.empty? ? orn[0] : "p"
                orn == "p" ? log_attendance_activity(source) : remove_attendance_activity(source)
                
                @finalize_code  = orn
                
                return true
                
            end
            
        else
            
            return false
            
        end
        
    end

    def testing_day_override
        
        if @stu_strict_attendance_testing_records
            
            test_site_event_id  = @stu_strict_attendance_testing_records[0].fields["test_event_site_id"].value
            test_event_id       = $tables.attach("TEST_EVENT_SITES").find_field("test_event_id", "WHERE primary_id = '#{test_site_event_id}'", {:value_only=>true})
            
            source              = "Test Event ID: #{test_event_id}"
            
            @stu_strict_attendance_testing_records.each{|test_date_record|
                
                @finalize_code = test_date_record.fields["attendance_code"].value
                if @finalize_code == "pt"
                    log_attendance_activity(source) 
                    return true
                end
                
            }
            
            remove_attendance_activity(source)
            
            return true
            
        elsif @stu_lenient_attendance_testing_records
            
            test_site_event_id  = @stu_strict_attendance_testing_records[0].fields["test_event_site_id"].value
            test_event_id       = $tables.attach("TEST_EVENT_SITES").find_field("test_event_id", "WHERE primary_id = '#{test_site_event_id}'", {:value_only=>true})
            
            source              = "Test Event ID: #{test_event_id}"
            
            attended_this_event = false
            @stu_lenient_attendance_testing_records.each{|test_date_record|
                
                if test_date_record.fields["attendance_code"].value == "pt"
                    
                    test_event_site_id  = test_date_record.fields["test_event_site_id"].value
                    test_event_id       = $tables.attach("TEST_EVENT_SITES" ).field_by_pid("test_event_id", test_event_site_id  ).value
                    test_name           = $tables.attach("TEST_EVENTS"      ).field_by_pid("name",          test_event_id       ).value
                    
                    attended_this_event = true
                    log_attendance_activity(source)
                    
                end
                
            }
            
            remove_attendance_activity(source) if !attended_this_event
            
            return false
            
        else
            
            return false
            
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
    
    def log_attendance_activity(source)
        $students.get(@sid).log_attendance_activity(:date=>@date, :source=>source)
        reset_activity(@sid, @date)
    end
    
    def remove_attendance_activity(source)
        $students.get(@sid).remove_attendance_activity(:date=>@date, :source=>source)
        reset_activity(@sid, @date)
    end
    
    def reset_activity(sid, date)
     
        att_record = student_attendance_record
        @stu_daily_codes = att_record.fields["code"].value.nil? ? [] : att_record.fields["code"].value.split(",")
        
    end

    def set_student(sid, date)
     
        @sid                            = sid
        @date                           = date
        @student                        = $students.get(@sid)
        
        if student_attendance_master_field && student_attendance_record
            
            @activity_sources                       = $tables.attach("ATTENDANCE_SOURCES").find_fields("source","WHERE type = 'Activity'            AND #{@student.grade.to_grade_field} IS TRUE", {:value_only=>true}) || []
            @classroom_sources                      = $tables.attach("ATTENDANCE_SOURCES").find_fields("source","WHERE type = 'Classroom Activity'  AND #{@student.grade.to_grade_field} IS TRUE", {:value_only=>true}) || []
            @live_sources                           = $tables.attach("ATTENDANCE_SOURCES").find_fields("source","WHERE type = 'Live'                AND #{@student.grade.to_grade_field} IS TRUE", {:value_only=>true}) || []
            
            att_record                              = student_attendance_record
            @stu_daily_mode                         = att_record.fields["mode"].value
            @stu_daily_codes                        = att_record.fields["code"].value.nil? ? [] : att_record.fields["code"].value.split(",")
            @stu_daily_procedure_type               = $tables.attach("ATTENDANCE_MODES").record("WHERE mode = '#{@stu_daily_mode}'").fields["procedure_type"].value 
            @stu_daily_sapphire_period_attendance   = @student.sapphire_period_attendance("WHERE calendar_day = '#{@date}'")
            
            @stu_strict_attendance_testing_records  = @student.test_dates.existing_records(
                "LEFT JOIN test_event_sites ON test_event_sites.primary_id  = student_test_dates.test_event_site_id
                LEFT JOIN test_events       ON test_events.primary_id       = test_event_sites.test_event_id
                WHERE date = '#{@date}'
                AND attendance_code IS NOT NULL
                AND attendance_code != 'Resched'
                AND test_events.override_attendance IS TRUE"
            )
            
            @stu_lenient_attendance_testing_records = @student.test_dates.existing_records(
                "LEFT JOIN test_event_sites ON test_event_sites.primary_id  = student_test_dates.test_event_site_id
                LEFT JOIN test_events       ON test_events.primary_id       = test_event_sites.test_event_id
                WHERE date = '#{@date}'
                AND attendance_code IS NOT NULL
                AND attendance_code != 'Resched'
                AND test_events.override_attendance IS NOT TRUE"
            )
            
            @stu_attendance_ap_records      = $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(@sid, staff_id = nil, @date)
            
            @finalize_code                  = nil
            
            @override                       = false
            
            return true
            
        else
            
            return false
            
        end
        
    end
  
    def student_attendance_master_field
        @student.attendance_master.send("code_#{@date.gsub("-","_")}")
    end
    
    def student_attendance_record
        attendance_record = @student.attendance.existing_records("WHERE date = '#{@date}'")
        return (attendance_record ? attendance_record[0] : false)
    end
    
end