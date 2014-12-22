#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ATTENDANCE < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def cumulative_and_consecutive_absence_mailer(cumulative_or_consecutive_mode)
    
        #method has two parts: a case statement and a loop phrase that sends off emails w/ CSVs
        sid_date_hash = Hash.new #this hash is populated in the first case statement
        
        active_sids = $tables.attach('student').field_values("student_id", "WHERE active = '1'")
        
        
        case cumulative_or_consecutive_mode
        
        when "cumulative"
            if Time.now.strftime("%A").match(/Monday|Thursday/)
                cumulative_reference_date = $tables.attach("school_days").field_values("date", "WHERE date <= '#{Time.now.strftime("%Y-%m-%d")}' ORDER BY date ASC")[-5]
                #date used to find cumulative absences and add info to generated emails
                cumulative_absence_sids = $tables.attach('student_attendance').field_values("student_id", "WHERE official_code
                                                                                IN ('u', 'ur', 'uap', 'ut')
                                                                                AND student_id
                                                                                IN (#{active_sids.join(',')})
                                                                                AND date <= '#{cumulative_reference_date}'
                                                                                GROUP BY student_id
                                                                                HAVING COUNT(student_id) > 2")
                tep_sids = $tables.attach("student_tep_agreement").field_values("student_id", "WHERE date_conducted IS NOT NULL GROUP BY student_id")
                if cumulative_absence_sids
                    cumulative_absence_sids = cumulative_absence_sids.uniq
                    cumulative_absence_sids.each do |sid|
                        if !tep_sids.include?(sid)
                            sid_date_hash[sid] = $tables.attach('student_attendance').field_values('date',"WHERE student_id = '#{sid}'
                                                                                                                    AND official_code
                                                                                                                    IN ('u', 'ur', 'uap', 'ut')
                                                                                                                    AND date <= '#{cumulative_reference_date}'
                                                                                                                    GROUP BY date
                                                                                                                    ORDER BY date ASC")
                        end
                    end
                end
            end
        when "consecutive"
            if Time.now.strftime("%A").match(/Monday|Tuesday|Wednesday|Thursday|Friday/)
                consecutive_end_date = $tables.attach("school_days").field_values("date", "WHERE date <= '#{Time.now.strftime("%Y-%m-%d")}' ORDER BY date ASC").last
                consecutive_start_date = $tables.attach("school_days").field_values("date", "WHERE date <= '#{Time.now.strftime("%Y-%m-%d")}' ORDER BY date ASC")[-7]
                #dates provide range in which consecutive absnences can be determined
                
                consecutive_absence_sids = $tables.attach('student_attendance').field_values('student_id',"WHERE date > '#{consecutive_start_date}'
                                                                                                AND date < '#{consecutive_end_date}'
                                                                                                AND student_id
                                                                                                IN (#{active_sids.join(',')})
                                                                                                AND official_code 
                                                                                                IN ('u', 'ur', 'uap', 'ut')
                                                                                                GROUP BY student_id
                                                                                                HAVING COUNT(student_id) > 4")
                                                                                                
                if consecutive_absence_sids
                    school_days = $tables.attach('school_days').field_values('date',"ORDER BY date ASC")
                    consecutive_dates_five_past = $tables.attach('school_days').field_values('date',"WHERE date > '#{consecutive_start_date}'
                                                                                                AND date < '#{consecutive_end_date}'
                                                                                                ORDER BY date DESC")
                    consecutive_absence_sids.each do |sid|
                        
                        #at this point, consecutive_absence_dates only contains the 5 dates required to be considered consecutive, more dates will be 'pushed' in if valid
                        consecutive_absence_dates = Array.new
                        consecutive_dates_five_past.each do |ele|
                            consecutive_absence_dates << ele
                        end
                        older_absence_dates = $tables.attach('student_attendance').field_values('date',"WHERE date < '#{consecutive_absence_dates.last}'
                                                                                                        AND student_id = #{sid}
                                                                                                        AND official_code
                                                                                                        IN ('u', 'ur', 'uap', 'ut')
                                                                                                        ORDER BY date DESC")
                        if older_absence_dates
                            older_absence_dates.each_with_index do |older_absence, index|
                                if school_days.index(consecutive_absence_dates.last) - school_days.index(older_absence) == 1
                                    consecutive_absence_dates << older_absence
                                else
                                    break
                                end
                                
                            end
                        end 
                        
                        sid_date_hash[sid] = consecutive_absence_dates
                    end
                end
            end
        else  ##from the case statement
            return
        end
        
        if !sid_date_hash.empty?
            track_for_email_duplicates = Array.new
            team_members_with_students = Hash.new
            #this hash contains Team_ID as keys and multidimensional arrays containing SIDs as values; it will be used to mail family coaches
            sid_date_hash.each do |sid, dates|  
                team_id = $tables.attach("STUDENT_RELATE").team_ids("WHERE role = 'Family Teacher Coach' AND active IS TRUE AND studentid = '#{sid}'")      
                if team_id
                    team_id = team_id.first
                    if team_id    
                        student_info = Array.new #this array contains [sid, last_name, first_name, and a string that contains all absence dates] in this order
                        student_info << sid
                        student_info << last_name = $tables.attach('student').field_value("studentlastname","WHERE student_id = '#{sid}'")
                        student_info << first_name = $tables.attach('student').field_value("studentfirstname","WHERE student_id = '#{sid}'")                        
                        dates_string = String.new
                        dates = dates.uniq
                        dates.each_with_index do |date, index|
                            split_date = date.split("-")
                            dates_string << "#{split_date[1]}/#{split_date[2]}/#{split_date[0]}, "    
                        end
                        student_info << dates_string
                        if team_members_with_students.has_key?(team_id.to_sym)
                            team_members_with_students[team_id.to_sym] << student_info
                        else
                            team_members_with_students[team_id.to_sym] = Array.new
                            team_members_with_students[team_id.to_sym] << student_info
                        end        
                    end
                end
            end
            
            rows = [["team member","student id","last name","first name","absences"]]
            team_members_with_students.each do |team_id, student_info_arrays|
                student_info_arrays.each do |indv_student_array|
                    indv_student_array = indv_student_array.unshift($team.get(team_id).full_name)
                    if !rows.include?(indv_student_array)
                        rows << indv_student_array
                    end
                end
            end
            
            file_name = "#{cumulative_or_consecutive_mode}_absence_report_for_your_family_coaches_#{Time.now.strftime("%m-%d-%Y")}"
            file_path = $reports.csv("temp", file_name, rows)
            subject_line = String.new
            body_text = String.new
            email_list = ['fcps@agora.org']
            email_list += $sys_admin_email
            
            
            if cumulative_or_consecutive_mode == "cumulative"
                subject_line = "3 or more unexcused absences and no TEP complete - family coaches report"
                body_text = "<p>These students currently have 3 or more unexcused absences and do not have a completed TEP documented in Athena.
                    At least three days have passed since the third unexcused absence to allow for the family to submit an excuse.</p>
                    
                    <p>Thank you for your attention to this matter.</p>"
            else
                subject_line = "5 or more consecutive unexcused absences - family coaches report"
                body_text = "<p>These students currently have 5 or more <b><em>consecutive</em></b> unexcused absences.</p>
                    
                    <p>Thank you for your attention to this matter.</p>"
            end
            
            $base.email.athena_smtp_email(
                recipients = email_list,
                subject = subject_line,
                content = body_text,
                attachments = file_path
            )
            
            puts "Mass absence reports sent to #{email_list.join(', ')}"
            
            team_members_with_students.each do |team_id, student_info_arrays|
                body_text = String.new
                file_name = String.new
                subject_line = String.new
                rows = Array.new
                rows = [["student id","last name","first name","absences"]]
                student_info_arrays.each do |indv_student_array|
                    rows << indv_student_array
                end
                if cumulative_or_consecutive_mode == "cumulative"
                    subject_line = "3 or more unexcused absences and no TEP complete"
                    body_text = "<p>These students currently have 3 or more unexcused absences and do not have a completed TEP documented in Athena.
                                At least three days have passed since the third unexcused absence to allow for the family to submit an excuse.
                                At this time, you should:</p>
                                <ul> 
                                <li>Initiate a TEP with the family (This can be done via the phone or virtual meeting) within 2 weeks of the 3rd absence.</li>
                                <li>Incorporate this into your conference meeting as much as possible.</li> 
                                
                                <li>If you cannot reach the family, please complete a TEP draft
                                (start the TEP, but leave the date blank until you discuss the TEP with the family).
                                Future absent dates can be documented in TEP notes (check the TEP follow-up reason for contact).</li>
                                </ul>
                                
                                <p>
                                Thank you for your attention to this matter.
                                </p>"
                    
                    file_name = "#{team_id}_3_cumulative_absences"
                else
                    subject_line = "5 or more consecutive unexcused absences"
                    body_text = "<p>These students currently have 5 or more <b><em>consecutive</em></b> unexcused absences.  At this time, you should:</p>
                                <ul>
                                <li>Contact family immediately.</li>
                                <li>Consider a face to face meeting if needed.</li>
                                </ul>
                                
                                <p>Thank you for your attention to this matter.</p>"
                    file_name = "#{team_id}_5_consecutive_absences"        
                end
                file_path = $reports.csv("temp", file_name, rows)
                team_member = $team.get(team_id)
                if team_member && !track_for_email_duplicates.include?(team_id)
                    team_member.send_email({:subject => subject_line, :content => body_text, :attachment_path => file_path})
                    track_for_email_duplicates << team_id
                    puts "email for #{cumulative_or_consecutive_mode} absences sent to team_id: #{team_id}"
                elsif team_member = $team.get(team_id) && track_for_email_duplicates.include?(team_id)
                    puts "email for #{cumulative_or_consecutive_mode} absences NOT sent to team_id: #{team_id}. DUPLICATE"
                else
                    puts "team member not found"
                end
                team_members_with_students.delete(team_id)
                next
            end
            if !track_for_email_duplicates.empty?
              puts "TOTAL EMAILS SENT: #{track_for_email_duplicates.size}"
            end
        end
    end


    def daily_attendance_statistics
        school_days = $tables.attach("school_days").field_values("date")
        date = (Time.now - 86400).strftime("%Y-%m-%d")
        
        if school_days.include?(date)
            
            daily_stats = $db.get_data("SELECT CONCAT('Code: ',official_code) 'Code/Mode',
                                    COUNT(official_code) 'Total Number'
                                    FROM `student_attendance`
                                    WHERE date = '#{date}'
                                    GROUP BY official_code
                                    UNION ALL
                                    SELECT CONCAT('Mode: ',mode),
                                    COUNT(mode) FROM `student_attendance`
                                    WHERE date = '#{date}'
                                    GROUP BY mode")
            
            if daily_stats
                table_html = "
                <style>
                    table, td, th {
                    border: 1px solid #B1D4F5;
                    }
                    
                    td,th {
                    text-align: left;
                    }
                    
                    th {
                    height: 50px;
                    }
                </style>
                
                <table>
                    <tr>
                    <th>&nbsp;Code/Mode&nbsp;</th>
                    <th>&nbsp;Total Number&nbsp;</th>
                    </tr>"
                
                daily_stats.each do |ele|
                next if ele.include?(nil) || ele.include?(false) || ele.include?("0")
                table_html << "<tr><td>&nbsp;#{ele.first}&nbsp;</td><td>&nbsp;#{ele.last}&nbsp;</td></tr>"
                end
                
                table_html << "</table>"
                
                date = date.split('-').map!{|ele| ele.to_i}
                date = Time.gm(date[0], date[1], date[2]).strftime('%A, %B %d %Y')
                
                email_html = "
                <p>Hello,
                <br>
                <br>
                    Below are the daily attendance statistics for #{date}.
                </p><br>
                #{table_html}"
                
                email_list = ["crivera@agora.org","apickens@agora.org"]
                email_list += $software_team
                
                $base.email.athena_smtp_email(
                recipients = email_list,
                subject = "Daily Attendance Statistics",
                content = email_html,
                attachments = nil
                )                
                
            end
            
        end
        
    end


    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def before_load_student_attendance #BE SURE TO SCHEDULE THIS IS DB CONFIG
        
        report_name = "k12_attendance_summary"
        
        request_record  = $tables.attach("TEAM_REQUESTED_REPORTS").new_row
        request_record.fields["team_id"        ].value = $team.find(:legal_first_name=>"ATHENA-SIS").primary_id.value
        request_record.fields["report_name"    ].value = report_name
        request_record.fields["status"         ].value = "Requested"
        request_record.fields["expiration_date"].value = (DateTime.now+(2.0/24)).strftime("%Y-%m-%d %H:%M:%S")
        
        requested_pid   = request_record.save
        
        $base.queue_process(
            "Requested_Reports"     ,
            report_name             ,
            requested_pid           , 
            "0"
        )
        
        cumulative_and_consecutive_absence_mailer("cumulative")
        cumulative_and_consecutive_absence_mailer("consecutive")
        
        return false
        
    end
    
    def DISABLED_after_load_k12_ecollege_activity
        
        source  = "LMS"
        pids    = $tables.attach("K12_ECOLLEGE_ACTIVITY").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_ECOLLEGE_ACTIVITY").by_primary_id(pid)
            date    = record.fields["activitydate" ].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_elluminate_session
        
        source  = "Blackboard"
        pids    = $tables.attach("K12_ELLUMINATE_SESSION").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_ELLUMINATE_SESSION").by_primary_id(pid)
            date    = record.fields["attendee_start_time"   ].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_hs_activity
        
        source  = "LMS - Manual"
        pids    = $tables.attach("K12_HS_ACTIVITY").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_HS_ACTIVITY").by_primary_id(pid)
            date    = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_lessons_count_daily
        
        source  = "OLS"
        pids    = $tables.attach("K12_LESSONS_COUNT_DAILY").primary_ids
        
        pids.primary_ids.each{|pid|
            
            record  = $tables.attach("K12_LESSONS_COUNT_DAILY").by_primary_id(pid)
            date    = record.fields["total_last_lesson" ].iso_date
            
            if $field.is_schoolday?(date)
                
                if !date.nil?
                    
                    student = $students.get(record.fields["student_id"].value)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                end
                
            end
           
        } if pids
        
    end
    
    def DISABLE_after_load_k12_logins
        
        #THE STUDENT LOGGED IN
        source  = "K12 Logins"
        pids    = $tables.attach("K12_LOGINS").primary_ids("WHERE role = '1001' AND last_login IS NOT NULL AND last_login REGEXP '2013-09-03'")
        
        pids.each{|pid|
            
            record      = $tables.attach("K12_LOGINS").by_primary_id(pid)
            date        = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
              
                identity_id = record.fields["identityid"].value
                
                if sid = $tables.attach("STUDENT").find_field("student_id", "WHERE identityid = '#{identity_id}'")
                    
                    student = $students.get(sid.value)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                end
                
            end
            
        } if pids
        
        #THE LEARNING COACH LOGGED IN
        source  = "K12 Logins - LC"
        pids    = $tables.attach("K12_LOGINS").primary_ids("WHERE role = '1000' AND last_login IS NOT NULL AND last_login REGEXP '2013-09-03'")
        
        pids.each{|pid|
            
            record      = $tables.attach("K12_LOGINS").by_primary_id(pid)
            date        = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
                
                family_id   = record.fields["familyid"  ].value
                regkey      = record.fields["regkey"    ].value         
                sids        = $tables.attach("STUDENT").student_ids("WHERE (familyid = '#{family_id}' OR lcregistrationid REGEXP '#{regkey}')")
                
                
                sids.each{|sid|
                    
                    student = $students.get(sid)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                } if sids
                
            end
            
        } if pids
        
    end

    def create_new_attendance_records(eval_date = nil)
        
        over_ride_mode = $tables.attach("ATTENDANCE_SETTINGS_OVERRIDE_DAILY_MODE").field_value("override_mode", "WHERE '#{eval_date}' BETWEEN start_date AND end_date")
        
        eval_date = $base.created_date ? DateTime.parse($base.created_date).strftime("%Y-%m-%d") : ($instance_DateTime - 1).strftime("%Y-%m-%d") if !eval_date
        
        if $field.is_schoolday?(eval_date)
            
            sa_db = $tables.attach("STUDENT_ATTENDANCE").data_base
            
            sids = $students.list(
                :currently_enrolled => true,
                :join_addon         => " LEFT JOIN #{sa_db}.student_attendance ON student_attendance.student_id = student.student_id ",
                :where_clause_addon => " AND student.student_id NOT IN(
                    SELECT
                        student_id
                    FROM #{sa_db}.student_attendance
                    WHERE student_attendance.date = '#{eval_date}'
                ) "
            )
            
            focus_sid = nil
            
            begin
                
                sids.each{|sid|
                    
                    focus_sid   = sid
                    
                    student     = $students.get(sid)
                    
                    #CREATE A DAILY ATTENDANCE MASTER RECORD IF ONE DOES NOT EXIST
                    student.attendance_master.existing_record || student.attendance_master.new_record.save
                    
                    #CREATE A DAILY ATTENDANCE RECORD IF ONE DOES NOT EXIST
                    if !student.attendance.existing_records("WHERE date = '#{eval_date}'")
                        
                        #CREATE A MODE RECORD WITH THE DEFAULT SETTING IF ONE DOES NOT EXIST
                        if !student.attendance_mode.existing_record
                            record = student.attendance_mode.new_record
                            record.fields["attendance_mode"].set("Synchronous")
                            record.save
                        end
                        
                        overall_mode    = student.attendance_mode.attendance_mode.value
                        mode            = (over_ride_mode ? (overall_mode.match(/exempt/i) ? overall_mode : over_ride_mode) : overall_mode)
                        procedure_type  = $tables.attach("ATTENDANCE_MODES").field_value("procedure_type", "WHERE mode = '#{mode}'")
                        code            = procedure_type.match(/Manual/) ? (procedure_type.match(/(default p)/) ? "p" : "u") : "u"
                        
                        record  = student.attendance.new_record
                        record.fields["date"            ].value = eval_date
                        record.fields["mode"            ].value = mode
                        record.fields["official_code"   ].value = code
                        record.save
                        
                    end
                    
                } if sids
                
            rescue=>e
                
                $base.system_notification(
                    
                    subject = "Student Attendance - Create Record Failed!",
                    content = "FOCUS SID AT TIME OF ERROR: #{focus_sid}",
                    caller[0],
                    e
                    
                )
                
            end
            
        end
        
    end

    def after_load_k12_withdrawal
        
        sids = $tables.attach("k12_withdrawal").students_with_records
        sids.each{|sid|
            
            attendance_mode_record = $tables.attach("student_attendance_mode").by_studentid(sid)
            if attendance_mode_record
                attendance_mode_record.fields["attendance_mode"].value = "Withdrawn"
                attendance_mode_record.save
            end
            
            wd_effective_date = $tables.attach("k12_withdrawal").by_studentid_old(sid).fields["schoolwithdrawdate"].value
            records = $tables.attach("student_attendance").records("WHERE date >= '#{wd_effective_date}' AND student_id = '#{sid}'")
            records.each{|record|
                record.fields["mode"         ].value = "Withdrawn"
                record.fields["official_code"].value = nil
                record.save
            } if records
            #MARK ALL SCHOOL DAYS AFTER THE WITHDRAW EFFECTIVE DATE AS NULL
            att_mast_record = $tables.attach("student_attendance_master").by_studentid(sid)
            if att_mast_record
                school_days = $school.school_days_after(wd_effective_date)
                if school_days
                    school_days.each{|date|
                        att_mast_record.fields["code_#{date}"    ].value = nil
                    }
                    att_mast_record.save
                end
            end
        } if sids
        
    end
    
    def DISABLED_after_load_student_sapphire_period_attendance
        
        #start = Time.new
        
        source  = "Sapphire Period Attendance"
        pids    = $tables.attach("STUDENT_SAPPHIRE_PERIOD_ATTENDANCE").primary_ids
        
        pids.each{|pid|
            
            record              = $tables.attach("STUDENT_SAPPHIRE_PERIOD_ATTENDANCE").by_primary_id(pid)
            sid                 = record.fields["student_id"    ].value
            date                = record.fields["calendar_day"  ].value
            student             = $students.get(sid)
            
            student_activity    = String.new
            
            day_codes = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").find_fields(
                "CONCAT(school,':',day_code)",
                "WHERE date = '#{date}' GROUP BY CONCAT(school,':',day_code)",
                {:value_only=>true}
            )
            
            qualifying_periods = Array.new
            
            day_codes.each{|day_code|
                
                school      = day_code.split(":")[0]
                day_code    = day_code.split(":")[1]
                
                pattern_fields = $tables.attach("STUDENT_SAPPHIRE_CLASS_ROSTER").find_fields(
                    "pattern",
                    "WHERE active IS TRUE
                    AND `pattern` REGEXP '\\\\(.*#{day_code}.*\\\\)'
                    AND school_id = '#{school}'
                    AND student_id = '#{sid}'
                    GROUP BY pattern",
                    {:value_only=>true}
                )
                
                if pattern_fields
                    
                    pattern_fields.each{|pattern_field|
                        
                        pattern_field.split(/\r?\n/).each{|pattern|
                            
                            if period_code = pattern.match(/^(.*?)\W/).to_s
                                
                                qualifying_periods.push("period_#{period_code.strip}")
                              
                            end
                          
                        }
                        
                    }
                    
                    qualifying_periods.each{|period_code|
                        
                        #STUDENT MARKED PRESENT OR THE TEACHER FORGOT TO MARK ATTENDANCE (Forgetting to mark = present per Christina)
                        code            = record.fields[period_code.downcase].value
                        activity_code   = (code.nil? ||  code.downcase=="p") ? "p" : (code.downcase=="a" ? "u" : code.downcase)
                        
                        if (
                            
                            period_code.match(/period_elo|period_mo|period_orn/)    &&
                            activity_code == "p"                                    &&
                            student.grade.match(/K|1st|2nd|3rd|4th|5th/)
                            
                        )
                            
                            related_students = $students.list(:familyid=>student.family_id.value, :grade=>"/K|1st|2nd|3rd|4th|5th/")
                            
                            related_students.each{|related_sid|
                                
                                $student.get(related_sid).log_attendance_activity(
                                    :date      => date,
                                    :source    => "#{source}: #{period_code} - #{activity_code}"
                                ) if !(related_sid == sid)
                                
                            } 
                            
                        end
                        
                        activity            = "#{source}: #{period_code} - #{activity_code}"
                        student_activity    = attendance_activity(:activity=>activity, :activity_string=>student_activity)
                        
                    } if qualifying_periods
                    
                end
                
            } if day_codes
            
            student.log_attendance_activity(
                :date      => date,
                :source    => student_activity
            ) if !student_activity.empty?
            
        } if pids
        
        #puts "completed in #{(Time.new - start)/60} minutes"
        
    end

    def after_change_field_mode(obj)
        process_attendance(obj)
    end
    
    def after_change_field_code(obj)
        process_attendance(obj)
    end
    
    def after_insert(obj)
        process_attendance(obj)
    end
    
    #def after_save(obj)
    #    process_attendance(obj)
    #end
    
    def process_attendance(obj)
        unless caller.find{|x|x.match(/Attendance_Processing/)}
            record = by_primary_id(obj.primary_id)
            $students.process_attendance(:student_id=>record.fields["student_id"].value,:date=>record.fields["date"].value)
        end
    end
    

    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_attendance",
                "file_name"         => "student_attendance.csv",
                "file_location"     => "student_attendance",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"student_id"    } if field_order.push("student_id"      )
            structure_hash["fields"]["date"             ] = {"data_type"=>"date", "file_field"=>"date"          } if field_order.push("date"            )
            structure_hash["fields"]["mode"             ] = {"data_type"=>"text", "file_field"=>"mode"          } if field_order.push("mode"            )
            structure_hash["fields"]["code"             ] = {"data_type"=>"text", "file_field"=>"code"          } if field_order.push("code"            )
            structure_hash["fields"]["official_code"    ] = {"data_type"=>"text", "file_field"=>"official_code" } if field_order.push("official_code"   )
            structure_hash["fields"]["sources"          ] = {"data_type"=>"text", "file_field"=>"sources"       } if field_order.push("sources"         )
            structure_hash["fields"]["complete"         ] = {"data_type"=>"bool", "file_field"=>"complete"      } if field_order.push("complete"        )
            structure_hash["fields"]["logged"           ] = {"data_type"=>"bool", "file_field"=>"logged"        } if field_order.push("logged"          )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end