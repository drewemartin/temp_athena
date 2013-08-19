#!/usr/local/bin/ruby

class Attendance_Reports

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def attendance_master(cutoff_date = $base.yesterday.iso_date)
        location    = "Attendance_Master"
        filename    = "attendance_master"
        rows        = Array.new
        headers     = String.new
     
        headers << "Student ID,"
        headers << "Last Name,"
        headers << "First Name,"
        headers << "Grade Level,"
        headers << "Family ID,"
        headers << "Birthday,"
        headers << "Family Coach,"
        headers << "Teacher,"
        
        headers << "Scantron entrance math,"
        headers << "Scantron exit math,"
        headers << "Scantron entrance reading,"
        headers << "Scantron exit reading,"
        
        headers << "Program Support,"
        
        headers << "Region,"
        #headers << "Family Coach,"
        headers << "Family Coach Program Support,"
        headers << "Truancy Prevention,"
        headers << "Advisor,"
        
        headers << "Enroll Date,"
        headers << "Withdraw Date,"
        headers << "Special Ed Teacher,"
        headers << "Attendance Mode,"
        headers << "District of Residence,"
        headers << "Enrolled,"
        headers << "Present,"
        headers << "Excused,"
        headers << "Unexcused"
        
        #ADD SCHOOL DAYS TO HEADERS - CODE AND MODE
        school_days = $school.school_days(cutoff_date, "DESC")
        school_days.each{|day|
            headers     << ",#{day} Code,#{day} Activity"  
        }
        
        ##ADD SCHOOL DAYS TO HEADERS - CODE ONLY
        #school_days = $school.school_days($idate, "DESC")
        #school_days.each{|day|
        #    headers     << ",#{day} Code"  
        #}
        
        ##ADD SCHOOL DAYS TO HEADERS - CODE AND MODE
        #school_days = $school.schooldays_by_range("2013-01-01", "2013-01-31", "DESC")
        #school_days.each{|day|
        #    headers     << ",#{day} Code,#{day} Activity"  
        #}
        
        excused_codes   = $db.get_data_single("SELECT code FROM attendance_codes WHERE code_type = 'excused'")
        unexcused_codes = $db.get_data_single("SELECT code FROM attendance_codes WHERE code_type = 'unexcused'")
        present_codes   = $db.get_data_single("SELECT code FROM attendance_codes WHERE code_type = 'present'")
        
        students = $tables.attach("attendance_master").students_with_records
        students.each{|sid|
            
            sql_string = String.new
            sql_string << "SELECT"                                      
            sql_string << " attendance_master.student_id,"                
            sql_string << " student.studentlastname,"                     
            sql_string << " student.studentfirstname,"                    
            sql_string << " student.grade,"                               
            sql_string << " student.familyid,"                            
            sql_string << " student.birthday,"                            
            sql_string << " student.primaryteacher,"   
            sql_string << " student.title1teacher,"
            
            sql_string << " scantron_performance_level.stron_ent_perf_m,"
            sql_string << " scantron_performance_level.stron_ext_perf_m,"
            sql_string << " scantron_performance_level.stron_ent_perf_r,"
            sql_string << " scantron_performance_level.stron_ext_perf_r,"
            
            sql_string << " (SELECT CONCAT(k12_staff.firstname,' ',k12_staff.lastname) FROM k12_staff where k12_staff.samspersonid = team_relate_grade_level.sams_id and team_relate_grade_level.role = \"Program Support\"),"
            
            sql_string << " team_relate_region.region,"
            #sql_string << " (SELECT CONCAT(k12_staff.firstname,' ',k12_staff.lastname) FROM k12_staff WHERE samspersonid = team_relate_region.family_coach_id),"
            sql_string << " (SELECT CONCAT(k12_staff.firstname,' ',k12_staff.lastname) FROM k12_staff WHERE samspersonid = team_relate_region.family_coach_program_support_id),"
            sql_string << " (SELECT CONCAT(k12_staff.firstname,' ',k12_staff.lastname) FROM k12_staff WHERE samspersonid = team_relate_region.truancy_prevention_id),"
            
            #################################################################### TIE IN ADVISORS
            advisor_arr = Array.new
            
            advisor_1 = $db.get_data_single(
              "SELECT
              CONCAT (k12_staff.firstname,' ',k12_staff.lastname) 
              FROM k12_staff,team_relate_region,student
              WHERE k12_staff.samspersonid = SUBSTRING_INDEX( team_relate_region.advisor_id, ',', 1 )
              and team_relate_region.family_coach_id = student.primaryteacherid
              and student.student_id = #{sid}" 
            )
            if advisor_1
              advisor_arr.push( advisor_1[0])  if !advisor_arr.include?(advisor_1[0])
            end
            
            advisor_2 = $db.get_data_single(
              "SELECT
              CONCAT (k12_staff.firstname,' ',k12_staff.lastname)
              FROM k12_staff,team_relate_region,student
              WHERE k12_staff.samspersonid = SUBSTRING_INDEX( SUBSTRING_INDEX( team_relate_region.advisor_id, ',', 2 ) , ',' , -1 )
              and team_relate_region.family_coach_id = student.primaryteacherid
              and student.student_id = #{sid}" 
            )
            if advisor_2
              advisor_arr.push(advisor_2[0] ) if !advisor_arr.include?(advisor_2[0])
            end
            
            advisor_3 = $db.get_data_single(
              "SELECT
              CONCAT (k12_staff.firstname,' ',k12_staff.lastname)
              FROM k12_staff,team_relate_region,student
              WHERE k12_staff.samspersonid = SUBSTRING_INDEX( SUBSTRING_INDEX( team_relate_region.advisor_id, ',', 3 ) , ',', -1 )
              and team_relate_region.family_coach_id = student.primaryteacherid
              and student.student_id = #{sid}" 
            )
            if advisor_3
              advisor_arr.push( advisor_3[0]  ) if !advisor_arr.include?(advisor_3[0])
            end
            
            sql_string << "'#{advisor_arr.join(",")}',"
            ####################################################################
            
            sql_string << " k12_all_students.schoolenrolldate,"           
            sql_string << " k12_withdrawal.schoolwithdrawdate,"         
            sql_string << " student.specialedteacher,"                    
            sql_string << " student_attendance_mode.attendance_mode,"            
            sql_string << " student.districtofresidence,"
            
            #TOTALS COUNT
            t = 0 #Enrolled  
            p = 0 #Present   
            e = 0 #Excused   
            u = 0 #Unexcused 
            att_dates = $db.get_data("SELECT date
                FROM student_attendance
                WHERE student_id = '#{sid}'
                AND date IN ('#{school_days.join("','")}')
                AND mode != 'Withdrawn'
                AND mode != 'SED-Changed'")
            att_dates.each{|att_date|
                this_day_code = $db.get_data_single("SELECT `#{att_date}` FROM attendance_master WHERE student_id = '#{sid}'")[0]
                
                if present_codes.include?(this_day_code)
                    p += 1
                    t += 1    
                elsif excused_codes.include?(this_day_code)
                    e += 1
                    t += 1    
                elsif unexcused_codes.include?(this_day_code)
                    u += 1
                    t += 1    
                end
                
            } if att_dates
            sql_string << "#{t}," 
            sql_string << "#{p}," 
            sql_string << "#{e}," 
            sql_string << "#{u}"  
            
            ##FOR BOTH MODE AND CODE
            #school_days.each{|day|
            #    sql_string  << ",`#{day}`,(SELECT CONCAT(  mode, ' (',code,')') FROM student_attendance WHERE student_id = '#{sid}' AND date = '#{day}')"    
            #}
            
            #FOR BOTH ACTIVITY AND CODE
            school_days.each{|day|
                sql_string  << ",`#{day}`,(SELECT code FROM student_attendance WHERE student_id = '#{sid}' AND date = '#{day}')"    
            }
            
            ##FOR JUST CODE
            #school_days.each{|day|
            #    sql_string  << ",`#{day}`"    
            #}
            
            sql_string      << " FROM attendance_master "
            sql_string      << " LEFT JOIN student                    ON student.student_id                     = attendance_master.student_id"
            sql_string      << " LEFT JOIN student_attendance_mode    ON student_attendance_mode.student_id     = attendance_master.student_id"
            sql_string      << " LEFT JOIN k12_withdrawal             ON k12_withdrawal.student_id              = attendance_master.student_id"
            sql_string      << " LEFT JOIN k12_all_students           ON k12_all_students.student_id            = attendance_master.student_id"
            sql_string      << " LEFT JOIN team_relate_region         ON team_relate_region.family_coach_id     = student.primaryteacherid"
            sql_string      << " LEFT JOIN team_relate_grade_level    ON team_relate_grade_level.grade          = student.grade"
            sql_string      << " LEFT JOIN scantron_performance_level ON scantron_performance_level.student_id  = attendance_master.student_id"
            sql_string      << " WHERE attendance_master.student_id = '#{sid}' GROUP BY attendance_master.student_id"
            results = $db.get_data(sql_string)
            
            if results
                
                #CLEAN UP ATTENDANCE CODES FOR THE USERS
                results[0].each{|x|
                    x.gsub!("p-k12_elluminate_session",  "Blackboard") if x
                    x.gsub!("p-k12_lessons_count_daily", "OLS"       ) if x
                    x.gsub!("p-k12_hs_activity",         "LMS"       ) if x
                    x.gsub!("p-k12_logins",              "Logged In" ) if x
                    x.gsub!("p-k12_ecollege_activity",   "LMS 2"     ) if x
                }
                rows.push(results[0])
                
            end
            
        }
        
        if rows
            file_path = $reports.csv(location, filename, rows.insert(0,headers))
            #$reports.move_to_athena_reports(file_path)
            return file_path
        else
            return false
        end
        
    end

    def current_students_monthly_attendance_kmail(start_date, end_date)
        $students.list(:currently_enrolled=>true).each{|sid|
            monthly_attendance_kmail(sid, start_date, end_date) 
        }
    end
    
    def individual_monthly_attendance_kmail(student_id, start_date, end_date)
        if $students.attach(student_id).attendance.enrolled_days_by_range(start_date, end_date).length > 0
            absences = $students.attach(student_id).attendance.unexcused_absences_by_range(start_date, end_date)
            
            if absences.empty?
              
                subject = "Congratulations for your Perfect Attendance between #{date_usr(start_date)} and #{date_usr(end_date)}"
                content =
"Congratulations! Agora Cyber Charter School is writing to notify you that |student.firstname| achieved perfect attendance between #{date_usr(start_date)} and #{date_usr(end_date)}.
Please know every Agora staff member is here to assist you as we partner for a wonderful educational experience for |student.firstname|.
Thank you very much for your attention to ensuring your student is attending school on a daily basis. 
Agora’s Attendance Office"
                $students.attach(student_id).queue_kmail(subject, content, sender = "attendance_reports")
                
            else
                
                date_values = absences.keys
                
                usr_frndly_dates = Array.new
                date_values.each{ |datee|
                    newdate = date_usr(datee)
                    usr_frndly_dates.push(newdate)
                }
                
                joined_dates = usr_frndly_dates.join(", ")
                subject = "Attendance Report from #{date_usr(start_date)} to #{date_usr(end_date)}"
                content =
"Hello,

We are writing to inform you of the attendance record for |student.firstname|. From #{date_usr(start_date)} to #{date_usr(end_date)} the following was recorded as unexcused:  #{joined_dates} 
Thank you very much for your attention to ensuring your student is attending school on a daily basis.  If a written excuse is not received within three days of the absence, the absence is permanently added to the student's file.  However if you believe these dates are in error, please feel free to contact the Attendance Office and we will be happy to review the specifics with you.

A few reminders about attendance:

-You can contact the Attendance Office by sending a kmail to Attendance Office under the administrator account or call 610-263-8541.  Please know we can not adjust attendance over the phone.

-A Synchronous Learner is expected to log into their online courses and live sessions each school day.

-An Asynchronous Learner is expected to login in their online courses each school day.

-In grades 9-12 the student must log in under their own student id to be considered present for online courses and live sessions.

-When sending in a kmail to excuse dates, please include your child's first and last name. If you have it readily available, please also include your child's student ID#.

-If a student accumulates three unexcused absences, you will be invited to a Truancy Elimination Prevention (TEP) meeting by your Family Coach and Agora must notify the school district which in turn may notify the magisterial district judge. 

-At 10 consecutive unexcused days we are required to withdraw a student from Agora. 

Our school wants to help you avoid any further absences or clear up any concerns.
We have supports that are available to you and your family, please contact us if we can assist you. We share a common goal to ensure that your child reaches their full potential.

If you have any questions, please contact kmail Attendance Office (under the Administrator account).

"
                $students.attach(student_id).queue_kmail(subject, content, sender = "attendance_reports")
            end
        end 
    end
end