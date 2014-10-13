#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Finalize_Attendance < Base

  def initialize()
    super()
    
    start = DateTime.now
    puts time_str(start)
    
    override_att_date = $base.yesterday.iso_date
    
################################################################################
#CHANGE HS|MS|K8 TO FLEX FOR NOW
puts "---> WARNING - UPDATING mode = 'Flex' for date >= 2012-10-19"
$db.query(
  "UPDATE `student_attendance`
  LEFT JOIN student ON student_attendance.student_id = student.student_id
  SET mode = 'Flex'
  WHERE
  (date >= '2012-10-19' AND mode REGEXP 'HS|MS|K8')
  OR
  (date >= '2013-01-25' AND date < '2013-02-11' AND mode = 'Academic Plan');"
)
puts "UPDATE COMPLETE <---"
################################################################################
    
    optional_events_site_ids = $tables.attach("TEST_EVENT_SITES").primary_ids("WHERE test_event_id REGEXP '2'")
    
    excused_codes     = $tables.attach("ATTENDANCE_CODES").code_array("WHERE code_type = 'excused' OR code_type = 'present'")
    unexcused_codes   = $tables.attach("ATTENDANCE_CODES").code_array("WHERE code_type = 'unexcused'")
    activity_sources  = $tables.attach("attendance_sources").source_array("activity")
    live_sources      = $tables.attach("attendance_sources").source_array("live")
    
    #GET ALL STUDENT_ATTENDANCE RECORDS
    pids = $tables.attach("student_attendance").primary_ids(" WHERE complete IS FALSE ")
    pids.each{|pid|
    #$tables.attach("student_attendance").primary_ids(" LEFT JOIN student_test_dates
    #  ON student_attendance.student_id = student_test_dates.student_id
    #  AND student_attendance.date = student_test_dates.date
    #  WHERE complete IS FALSE 
    #  AND student_test_dates.student_id IS NOT NULL ").each{|pid|
      
      this_days_code = nil
      attended_types = []
      
      att_record        = $tables.attach("student_attendance").by_primary_id(pid)
      mode              = att_record.fields["mode"      ].value
      sid               = att_record.fields["student_id"].value
      date              = att_record.fields["date"      ].iso_date
      if sid && date && mode
        
        attendance_master_field = $tables.attach("attendance_master").field_bystudentid(date, sid)
        current_code            = attendance_master_field.value
        
        ########################################################################
        # TESTING DAY ATTENDANCE ###############################################
        testing_date_overrides_attendance = false
        if test_records = $tables.attach("STUDENT_TEST_DATES").by_studentid_old(sid, date)
          
          if !($tables.attach("Attendance_Codes").override_codes.include?(current_code))
            
            strict = true
            
            testing_day_att_code = nil
            test_records.each{|test_record|
              
              if !(testing_day_att_code == "pt")
                
                if test_record.fields["attendance_code"].value != "Resched" && !test_record.fields["attendance_code"].value.nil?
                  testing_day_att_code = test_record.fields["attendance_code"].value
                  strict = false if optional_events_site_ids.include?(test_record.fields["test_event_site_id"].value)
                end
                
              end
              
            }
           
            if !testing_day_att_code.nil?
              
              if strict
                
                testing_date_overrides_attendance = true 
                
                attendance_master_field.value = testing_day_att_code
                attendance_master_field.save
                
              elsif testing_day_att_code == "pt"
                
                testing_date_overrides_attendance = true 
                
                attendance_master_field.value = testing_day_att_code
                attendance_master_field.save
                
              end
              
            end
            
          end
          
        end
        ########################################################################
        
        ########################################################################
        # ACADEMIC PLAN ATTENDANCE #############################################
        academic_plan_overrides_attendance = false
        if mode == "Academic Plan" && !testing_date_overrides_attendance
          
          if !($tables.attach("Attendance_Codes").override_codes.include?(current_code))
            
            @stu_attendance_ap_records = $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(sid, staff_id = nil, date)
            if @stu_attendance_ap_records
              
              academic_plan_overrides_attendance = true
              
              if date >= "2013-03-21" #Only evaluate in new way moving forward
                attended_values = Array.new
                @stu_attendance_ap_records.each{|record|
                  attended_values.push(record.fields["attended"].value)
                }
                if attended_values.include?("0") #if anyone marks them unexcused then they are "uap"
                  @finalize_code = "uap"
                else
                  @finalize_code = "pap"
                end
                
              else
                
                voters = @stu_attendance_ap_records.length
                votes  = 0
                
                @stu_attendance_ap_records.each{|record|
                  votes +=1 if record.fields["attended"].is_true?
                }
                
                @finalize_code = votes == voters ? "pap" : "uap"
              
              end
              
              attendance_master_field.value = @finalize_code
              attendance_master_field.save
              
            else
              
              mode = "Flex"
              att_record.fields["mode"].value = "Flex"
              att_record.save
              
            end
          
          end
          
          
        end
        ########################################################################
        
        if !testing_date_overrides_attendance && !academic_plan_overrides_attendance
          
          if current_code.nil? || (!excused_codes.include?(current_code) && !(current_code.match("pr|ur")) )
            
            #ALLOW THE STUDENT A 5 DAY BUFFER WHERE THEY ARE MARKED FLEX
            student_enroll_date   = $students.get(sid).schoolenrolldate.mathable
            enroll_date_qualifies = student_enroll_date && (student_enroll_date >= (DateTime.now - 7)) && (student_enroll_date <= (student_enroll_date + 7))
            mode_qualifies        = ( mode.match(/Synch/) || mode.match(/Asynch/) )
            
            if enroll_date_qualifies && mode_qualifies
              att_date              = att_record.fields["date"].mathable
              att_date_qualifies    = (att_date >= (DateTime.now - 7)) && (att_date <= (student_enroll_date + 7))
              if att_date_qualifies  
                puts "MARKED SID: #{sid} MODE = FLEX FOR student_attendance PID: #{att_record.primary_id}"
                mode = att_record.fields["mode"].value = "Flex"
                att_record.save
              end
            end
            
            this_days_sources = $tables.attach("ATTENDANCE_MODES").sources_by_mode(mode) ? $tables.attach("ATTENDANCE_MODES").sources_by_mode(mode).value : []
            
            #TUESDAYS AND THURSDAYS MAY HAVE NO LIVE SESSIONS FOR 7-12TH GRADERS - SO SWITCH TO ASYNCH
            #asynch_day = att_record.fields["date"].mathable.strftime("%A").match(/Tuesday|Thursday/)
            #if mode.match(/Synch/) && asynch_day
            #  if $students.get(sid).grade && $students.get(sid).grade.match(/7th|8th|9th|10th|11th|12th/)
            #    mode = "Asynchronous"
            #  end
            #end
            
            if mode.match(/Asynch/)
              #STUDENT MUST HAVE ACTIVITY
              if !att_record.fields["code"].value.nil?
                codes = att_record.fields["code"].value.split(",")
                codes.each{|code|
                  this_code = code.gsub("p-","").gsub(" - LC","")
                  attended_types.push("live") if live_sources.include?(this_code) && !attended_types.include?("live")
                  if this_days_sources.split(",").find{|x| x.match(/#{this_code}/)}
                    attended_types.push("activity") if activity_sources.include?(this_code) && !attended_types.include?("activity")
                  end
                }
                if attended_types.include?("activity")
                  this_days_code = "p"
                #elsif attended_types.include?("live")
                #  this_days_code = "ul"
                #elsif attended_types.empty?
                else
                  this_days_code = "u"
                end
                
              else
                this_days_code = "u"
                
              end
              
            elsif mode.match(/Synch/)
              #STUDENT MUST HAVE BOTH LIVE AND ACTIVITY
              if !att_record.fields["code"].value.nil?
                codes = att_record.fields["code"].value.split(",")
                codes.each{|code|
                  this_code = code.gsub("p-","").gsub(" - LC","")
                  attended_types.push("live") if live_sources.include?(this_code) && !attended_types.include?("live")
                  if this_days_sources.split(",").find{|x| x.match(/#{this_code}/)}
                    attended_types.push("activity") if activity_sources.include?(this_code) && !attended_types.include?("activity")
                  end
                }
                if attended_types.include?("activity") && attended_types.include?("live")
                  this_days_code = "p"
                  
                else
                  this_days_code = "u"
                  
                end
                
              else
                this_days_code = "u"
                
              end
              
            elsif mode.match(/Flex|HS Senior Project/)
              #STUDENT MUST HAVE EITHER LIVE OR AVTIVITY
              if !att_record.fields["code"].value.nil?
                this_days_code = "p"
                
              else
                this_days_code = "u"
                
              end
              
            elsif mode.match(/Withdrawn|SED/)
              #STUDENT'S ATTENDANCE MASTER RECORD SHOULD BE NULL FOR THIS DAY
              this_days_code = "NULL"
              
            elsif mode.match(/Exempt/)
              #STUDENT IS ASSUMED PRESENT
              this_days_code = "p"
              
            end
            
            attendance_master_field.value = this_days_code
            attendance_master_field.save
            
          end
          
        end
        
      else
        subject = "Student Attendance Record Error"
        content = "PRIMARY_ID: #{pid} has either no sid or no date."
        $base.system_notification(subject, content)
      end
    }
    
    #student_attendance_master_update
    
    puts "completed in #{(DateTime.new - start)/60} minutes"
    puts ">-------------------------------------------------------->"
    
    #RUN THE ATTENDANCE MASTER REPORT
    require "#{$paths.system_path}reports/attendance_reports" 
    att_master_path     = Attendance_Reports.new.attendance_master(override_att_date)
    #att_master_path    = "Q:/athena-sis/htdocs/athena_files/reports/Attendance_Master/attendance_master_D20121011T151247.csv"
    zip_att_master_path = att_master_path.gsub(".csv",".zip")
    zip_file            = Zip::ZipFile.open(zip_att_master_path, Zip::ZipFile::CREATE)
    zip_file.add(att_master_path.split("/")[-1], att_master_path)
    zip_file.close
    
    email_list = ["crivera@agora.org","apickens@agora.org","hammon@agora.org"]
    email_list += $software_team
    
    $base.email.athena_smtp_email(
      recipients    = email_list,
      subject       = "Attendance Master Report",
      content       = "Please find the attached reports",
      attachments   = zip_att_master_path
    )
    
    #RUN THE TRUANCY WITHDRAWAL REPORT
    require "#{$paths.system_path}reports/truancy_withdrawals_report"
    truancy_path      = Truancy_Withdrawals_Report.new.generate(override_att_date)
    #truancy_path     = "Q:/athena-sis/htdocs/athena_files/reports/Truancy_Withdrawal/truancy_withdrawal_D20121011T151247.csv"
    zip_truancy_path  = truancy_path.gsub(".csv",".zip")
    zip_file = Zip::ZipFile.open(zip_truancy_path, Zip::ZipFile::CREATE)
    zip_file.add(truancy_path.split("/")[-1], truancy_path)
    zip_file.close
    
    email_list = ["crivera@agora.org","apickens@agora.org","hammon@agora.org"]
    email_list += $software_team
    
    $base.email.athena_smtp_email(
      recipients    = email_list,
      subject       = "Truancy Report",
      content       = "Please find the attached reports",
      attachments   = zip_truancy_path
    )
    #$base.email.send(["crivera@agora.org","drowan@agora.org","apickens@agora.org"], "Finalize Attendance Results", "Please find the attached reports", priority = nil, attachments = [zip_att_master_path,zip_truancy_path])
  end
  
  def student_attendance_master_update
    
    $tables.attach("ATTENDANCE_MASTER").students_with_records.each{|sid|
      
      s = $students.attach(sid)
      
      if $tables.attach("STUDENT_ATTENDANCE_MASTER").by_studentid_old(sid)
        
        record = $tables.attach("STUDENT_ATTENDANCE_MASTER").by_studentid_old(sid)
        
      else
        
        record = $tables.attach("STUDENT_ATTENDANCE_MASTER").new_row
        
      end
      
      fields = record.fields
      fields["student_id"          ].value = sid         
      fields["attendance_rate"     ].value = s.attendance.rate_decimal         
      fields["tot_enrolled_days"   ].value = s.attendance.enrolled_days.length         
      fields["tot_attended_days"   ].value = s.attendance.attended_days.length         
      fields["tot_excused_days"    ].value = s.attendance.excused_absences.length         
      fields["tot_unexcused_days"  ].value = s.attendance.unexcused_absences.length         
      record.save
        
    }
    
  end

end