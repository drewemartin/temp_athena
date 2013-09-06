#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Login_Reminders_Report #< Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        pssa_students = $db.get_data_single("SELECT student_id FROM `pssa_attendance` WHERE attendance_code IS NOT NULL AND attendance_date = CURDATE()")
        
        #FNORD - THIS WILL NEED TO BE FIXED ONCE DNC LIST IS IN V.03
        dnc = $tables.attach("DNC_STUDENTS").students_with_records || []
        
        attendance_day = (Date.today).strftime("%Y-%m-%d") #today
        
        excused_codes     = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE code_type = 'excused' OR code_type = 'present'", {:value_only=>true})
        is_att_day = $tables.attach("Attendance_Master").schooldays.include?(attendance_day)
        if is_att_day
            students = $students.current_students
            students_not_logged_in = Array.new
            students.each{|sid|
                student = $students.attach(sid)
                logged_in = false
                logged_in = true if dnc.include?(sid)
                unless logged_in
                    day_code = $tables.attach("attendance_master").field_bystudentid(attendance_day, sid)
                    current_code = day_code ? day_code.value : false
                    logged_in = true if excused_codes.include?(current_code)
                end
                unless logged_in
                    logged_in = $tables.attach("K12_Logins").by_familyid(student.family_id.value, attendance_day, official_attendance = true)
                end
                unless logged_in
                    lc_reg_ids = student.lc_registration_id
                    if lc_reg_ids && lc_reg_ids.value
                        lc_reg_ids.value.split(",").each{|regid|
                            logged_in = $tables.attach("K12_Logins").by_regkey(regid, attendance_day, official_attendance = true)
                        }
                    end
                end
                unless logged_in
                    if pssa_students
                        logged_in = true if pssa_students.include?(sid)
                    end    
                end
                
                unless logged_in
                    
                    test_date_records = $tables.attach("STUDENT_TEST_DATES").by_studentid_old(sid, attendance_day)
                    test_date_records.each{|test_date_record|
                        
                        if test_date_record.fields["attendance_code"].value == "pt"
                            logged_in = true
                        end
                        
                    } if test_date_records
                    
                end
                
                students_not_logged_in.push(sid) if !logged_in
                $students.detach(sid)
            }
            if students_not_logged_in
                headers     = "ReferenceCode"
                location    = "Login_Reminders"
                filename    = "login_reminders"
                
                file_path = $reports.save_document({:csv_rows=>students_not_logged_in.insert(0,headers), :category_name=>"Attendance", :type_name=>"Login Reminders Report"})
                $reports.move_to_athena_reports_from_docs(file_path, location, filename, false)
                
                tot = students_not_logged_in.length
                if tot > 3000 || tot < 1000
                    subject = "LOGIN REMINDERS - ALERT: Unexpected Results!"
                    content = "Please verify results"
                    $base.system_notification(subject, content)
                end
                
                return file_path
            else
                return false
            end
            
        end
    end
    #---------------------------------------------------------------------------
   
end

#Login_Reminders_Report.new