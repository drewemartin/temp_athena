#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class K8_Present_Report < Base
    #---------------------------------------------------------------------------    
    #DEPENDENCIES:
    #   K12_Logins
    #   K12_Lessons_Count_Daily
    #   K12_Elluminate_Session
    #---------------------------------------------------------------------------
    def initialize()
        super()
        attendance_day = (Date.today-1).strftime("%Y-%m-%d") #yesterday
        #attendance_day = "2012-03-23"
        is_att_day = $tables.attach("Attendance_Master").schooldays.include?(attendance_day)
        if is_att_day
            k8_present_students = Array.new
            i = 0
            $students.current_students.each{|sid|
                student                 = $students.attach(sid)
                logged_in               = false
                source                  = String.new
                supplemental_students   = $tables.attach("Supplemental_Students" ).current_students
                life_skills_students    = $tables.attach("Life_Skills_Students"  ).current_students
                eligible = student.grade.match(/K|1st|2nd|3rd|4th|5th|6th|7th|8th/) || supplemental_students.include?(sid) || life_skills_students.include?(sid)
                if eligible
                    i+=1
                    source = ""
                    lcd_checked             = false
                    login_familyid_checked  = false
                    login_lc_regids_checked = false
                    es_checked              = false
                    unless logged_in
                        logged_in = $tables.attach("K12_Logins").by_familyid(student.family_id.value, attendance_day, official_attendance = true)
                        source = "K12_Logins - Family ID" if logged_in
                        last_logged = logged_in[0].fields["last_login"].value if logged_in
                        login_familyid_checked = true
                    end
                    unless logged_in
                        lc_reg_ids = student.lc_registration_id
                        if lc_reg_ids && lc_reg_ids.value
                            lc_reg_ids.value.split(",").each{|regid|
                                logged_in = $tables.attach("K12_Logins").by_regkey(regid, attendance_day, official_attendance = true)
                            }
                        end
                        source = "K12_Logins - LC REGID" if logged_in
                        last_logged = logged_in[0].fields["last_login"].value if logged_in
                        login_lc_regids_checked = true
                    end
                    unless logged_in
                        logged_in = $tables.attach("K12_Lessons_Count_Daily").by_studentid_old(sid,  attendance_day)
                        source = "K12_Lessons_Count_Daily" if logged_in
                        last_logged = logged_in[0].fields["total_last_lesson"].value if logged_in
                        lcd_checked = true
                    end
                    unless logged_in
                        logged_in = $tables.attach("K12_Elluminate_Session").by_studentid_old(sid, attendance_day)
                        source = "K12_Elluminate_Session" if logged_in
                        last_logged = logged_in[0].fields["attendee_start_time"].value if logged_in
                        es_checked = true
                    end
                    if !logged_in || source != "K12_Logins" || (source == "K12_Logins" && logged_in[0].fields["last_login"].value.split(" ")[0] != "2012-01-09")
                        "stop"
                    else
                        "stop"
                    end
                    k8_present_students.push("#{sid},#{source},#{last_logged}") if logged_in
                end
                $students.detach(sid)
            }
            
            if k8_present_students
                file = $base.new_file("Attendance/k8_present", "k8_present_report")
                headers = '"Student ID","Source","Last Login Date"'
                file.puts headers
                k8_present_students.each do |sid|
                    file.puts sid
                end
                file.close
                recipient_array = ["jdelguzzo@agora.org", "apickens@agora.org"]
                subject = "K8 Present Report #{(Date.today-1).strftime('%m-%d-%Y')}"
                content = "You can haz K8 Present Report!"
                attachments = [file.path]
                recipient_array.each do |recipient|
                    $base.email.send(recipient, subject, content, 2, attachments)
                end
            end
            puts i
        end
    end
    #---------------------------------------------------------------------------
   
end

K8_Present_Report.new