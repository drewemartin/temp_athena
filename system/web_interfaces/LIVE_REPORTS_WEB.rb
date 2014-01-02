#!/usr/local/bin/ruby


class LIVE_REPORTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    
    def breakaway_caption
        return "Live Reports"
    end
    
    def page_title
        "Live Reports"
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        output = "<div id='student_container'>"
        
        tables_array = Array.new
     
        #HEADERS
        tables_array.push([
            "Action",
            "Title",
            "Description"
        ])
        
        #ACADEMIC PLAN ATTENDANCE DETAIL
        tables_array.push([
            $tools.button_new_csv("student_attendance_ap", additional_params_str = nil),
            "Academic Plan Attendance Detail",
            "This report includes all AP Attendance records that exist."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_attendance_ap.is_true?
        
        #ATHENA PROJECTS
        tables_array.push([
            $tools.button_new_csv("athena_project", additional_params_str = nil),
            "Athena Projects",
            "This report includes all Athena Projects."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_athena_project.is_true?
        
        #ATHENA PROJECT REQUIREMENTS
        tables_array.push([
            $tools.button_new_csv("athena_project_requirements", additional_params_str = nil),
            "Athena Project Requirements",
            "This report includes all Requirements for Athena Projects."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_athena_project.is_true?
        
        #ATTENDANCE CONSECUTIVE UNEXCUSED ABSENCES
        tables_array.push([
            $tools.button_new_csv("attendance_by_code", additional_params_str = nil),
            "Attendance By Code",
            "This report includes all a code breakdown for all schooldays that have attendance marked."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_attendance_master.is_true?
        
        #ATTENDANCE CONSECUTIVE UNEXCUSED ABSENCES
        select_absences = Array.new
        (1..20).each{|x| select_absences.push({:name=>x.to_s,:value=>x.to_s})}
        tables_array.push([
            $tools.button_new_csv("attendance_consecutive_absences", additional_params_str = nil, send_field_names = "consecutive_days,consecutive_target_date")+
            $field.new("type"=>"date","value"=>$base.yesterday.iso_date).web.select(:label_option=>"Target Date",:add_class=>"no_save",:field_id=>"consecutive_target_date",:field_name=>"consecutive_target_date",:dd_choices=>school_days_dd)+
            $field.new("type"=>"int", "value"=>"1"                     ).web.select(:label_option=>"Consecutive Absences",:add_class=>"no_save",:field_id=>"consecutive_days",:field_name=>"consecutive_days",:dd_choices=>select_absences),
            "Attendance Consecutive Absences",
            "This report includes students with the number of selected unexcused absences relative to the selected target school date."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_attendance_consecutive_absences.is_true?
        
        #ATTENDANCE ACTIVITY
        tables_array.push([
            $tools.button_new_csv("attendance_activity", additional_params_str = nil, send_field_names = "date_attendance_activity")+
            $field.new("type"=>"date","value"=>$base.yesterday.iso_date).web.select(:label_option=>"Date",:add_class=>"no_save",:field_id=>"date_attendance_activity",:field_name=>"date_attendance_activity",:dd_choices=>school_days_dd),
            "Attendance Activity",
            "This report includes all activity for the selected schoolday."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_attendance_activity.is_true?
        
        #ATTENDANCE MASTER
        tables_array.push([
            $tools.button_new_csv("attendance_master", additional_params_str = nil),
            "Attendance Master",
            "This report includes all students who have had any attendance records created this school year."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_attendance_master.is_true?
        
        #Ink Orders
        tables_array.push([
            $tools.button_new_csv("ink_orders", additional_params_str = nil),
            "Ink Orders",
            "This report includes all ink orders entered into Athena."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_ink_orders.is_true?
        
        #Ink Orders Manual Shipping
        tables_array.push([
            $tools.button_new_csv("ink_orders_manual", additional_params_str = nil),
            "Ink Orders Manual Shipping Mail Merge",
            "This is a mail merge csv for making shipping labels for ink orders who don't have a staples id yet."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_ink_orders_manual.is_true?
        
        #ALL CONTACTS REPORT
        tables_array.push([
            $tools.button_new_csv("student_contacts", additional_params_str = "complete"),
            "Student Contacts - Complete",
            "This report includes all contact records that exist. Only students with contacts will be included."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_contacts.is_true?
        
        #MY CONTACTS REPORT
        tables_array.push([
            $tools.button_new_csv("my_student_contacts", additional_params_str = nil),
            "My Student Contacts",
            "This report includes all contact records that you created."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_my_student_contacts.is_true?
        
        #ILP SURVEY COMPLETION
        tables_array.push([
            $tools.button_new_csv("student_ilp", additional_params_str = nil),
            "Student ILP",
            "This report includes an ILP Entries for all active students."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_ilp.is_true?
        
        #ILP SURVEY COMPLETION
        tables_array.push([
            $tools.button_new_csv("student_ilp_survey_completion", additional_params_str = nil),
            "Student ILP Survey Completion",
            "This report includes an ILP Survey count (completed/total) for all active students."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_ilp.is_true?
        
        #RTII BEHAVIOR REPORT
        tables_array.push([
            $tools.button_new_csv("student_rtii_behavior", additional_params_str = nil),
            "Student RTII Behavior",
            "This report includes all RTII Behavior records that exist. Only students with contacts will be included."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_rtii_behavior.is_true?
        
        #MY STUDENTS GENERAL
        tables_array.push([
            $tools.button_new_csv("my_students_general", additional_params_str = nil),
            "My Students General",
            "This report includes general information about your students."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_my_students_general.is_true?
        
        #MY STUDENTS TESTS
        tables_array.push([
            $tools.button_new_csv("my_students_tests", additional_params_str = nil),
            "My Students Tests",
            "This report includes all test records for only your related students."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_my_students_tests.is_true?
        
        #STUDENT ASSESSMENT EXEMPTIONS
        tables_array.push([
            $tools.button_new_csv("student_assessment_exemptions", additional_params_str = nil),
            "Student Assessment Exemptions",
            "This report includes all exemptions records for active students."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_assessment_exemptions.is_true?
        
        #STUDENT_SCANTRON_PARTICIPATION
        tables_array.push([
            $tools.button_new_csv("student_scantron_participation", additional_params_str = nil),
            "Student Scantron Participation",
            "This report includes all currently enrolled students who are Scantron eligible."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_scantron_participation.is_true?
        
        #SITE TEST STUDENTS ATTENDANCE
        tables_array.push([
            $tools.button_new_csv("student_testing_events_attendance", additional_params_str = nil),
            "Student Testing Events - Attendance",
            "This report includes all test site attendance records."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_testing_events_attendance.is_true?
        
        #SITE TEST STUDENTS
        tables_array.push([
            $tools.button_new_csv("student_testing_events_tests", additional_params_str = nil),
            "Student Testing Events - Tests",
            "This report includes all test records."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_testing_events_tests.is_true?
        
        #TEAM_MEMBER_EVALUATIONS_ACADEMIC
        tables_array.push([
            $tools.button_new_csv("team_member_evaluations_academic", additional_params_str = nil),
            "Team Member Evaluations - Academic",
            "This report includes all evaluations data entered into Athena for 'Academic' category Team Members"
        ]) if $team_member.super_user? || $team_member.rights.live_reports_team_member_evaluations_academic.is_true?
        
        #TEAM_MEMBER_EVALUATIONS_ENGAGEMENT
        tables_array.push([
            $tools.button_new_csv("team_member_evaluations_engagement", additional_params_str = nil),
            "Team Member Evaluations - Engagement",
            "This report includes all evaluations data entered into Athena for 'Engagement' category Team Members"
        ]) if $team_member.super_user? || $team_member.rights.live_reports_team_member_evaluations_engagement.is_true?
        
        #TEAM MEMBER TEST EVENT SITE ATTENDANCE
        tables_array.push([
            $tools.button_new_csv("team_member_testing_events_attendance", additional_params_str = nil),
            "Team Member Testing Events - Attendance",
            "This report includes all team member's test site attendance records."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_team_member_testing_events_attendance.is_true?
        
        #TRANSCRIPTS_RECEIVED
        tables_array.push([
            $tools.button_new_csv("transcripts_received", additional_params_str = nil),
            "Transcripts Received",
            "This report includes all transcript recieved records entered into Athena"
        ]) if $team_member.super_user? || $team_member.rights.live_reports_transcripts_received.is_true?
        
        #Attendance Codes
        tables_array.push([
            $tools.button_new_csv("attendance_code_stats", additional_params_str = nil),
            "Attendance Code Statistics",
            "The count and percentage of each attendance code for each student."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_attendance_code_stats.is_true?
        
        output << $kit.tools.data_table(tables_array, "leadership_reports")
        output << "</div>"
        
    end
    
    def response
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_CSV
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def add_new_csv_student_attendance_ap(options = nil)
        
        s_db     = $tables.attach("student").data_base
        saap_db  = $tables.attach("student_attendance_ap").data_base
        tsids_db = $tables.attach("team_sams_ids").data_base
        t_db     = $tables.attach("team").data_base
        
        sql_str =
        "SELECT
            student_attendance_ap.primary_id,
            student_attendance_ap.date,
            student_attendance_ap.student_id,
            student.studentfirstname,
            student.studentlastname,
            student_attendance_ap.staff_id,
            team.legal_first_name,
            team.legal_last_name,
            student_attendance_ap.live_session_attended_required,
            student_attendance_ap.live_session_attended_engaged,
            student_attendance_ap.live_session_participated_required,
            student_attendance_ap.live_session_participated_engaged,
            student_attendance_ap.help_session_required,
            student_attendance_ap.help_session_engaged,
            student_attendance_ap.office_hours_required,
            student_attendance_ap.office_hours_engaged,
            student_attendance_ap.assignment_completion_required,
            student_attendance_ap.assignment_completion_engaged,
            student_attendance_ap.assessment_completion_requied,
            student_attendance_ap.assessment_completion_engaged,
            student_attendance_ap.attended,
            student_attendance_ap.notes
        FROM #{saap_db}.student_attendance_ap
        LEFT JOIN #{s_db}.student
            ON #{saap_db}.student_attendance_ap.student_id = #{s_db}.student.student_id
        LEFT JOIN #{tsids_db}.team_sams_ids
            ON #{saap_db}.student_attendance_ap.staff_id = #{tsids_db}.team_sams_ids.sams_id
        LEFT JOIN #{t_db}.team
            ON #{tsids_db}.team_sams_ids.team_id = #{t_db}.team.primary_id
        WHERE (
            student_attendance_ap.student_id != '5555'
            AND
            student_attendance_ap.student_id != '5552'
        )"
        
        headers =
        [
            "AP Attendance Record ID",
            "date",
            "student_id",
            "student_first_name",
            "student_last_name",
            "teacher_staff_id",
            "teacher_first_name",
            "teacher_last_name",
            "live_session_attended_required",
            "live_session_attended_engaged",
            "live_session_participated_required",
            "live_session_participated_engaged",
            "help_session_required",
            "help_session_engaged",
            "office_hours_required",
            "office_hours_engaged",
            "assignment_completion_required",
            "assignment_completion_engaged",
            "assessment_completion_requied",
            "assessment_completion_engaged",
            "attended",
            "notes"
          
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_athena_project(options = nil)
        ap_db  = $tables.attach("athena_project").data_base
        apr_db = $tables.attach("athena_project_requirements").data_base
        aps_db = $tables.attach("athena_project_systems").data_base
        t_db   = $tables.attach("team").data_base
        sql_str =
        "SELECT
            (SELECT system_name FROM #{aps_db}.athena_project_systems WHERE athena_project_systems.primary_id = athena_project.system_id),
            athena_project.status,
            athena_project.development_phase,
            CONCAT(
                (SELECT COUNT(primary_id) FROM #{apr_db}.athena_project_requirements WHERE project_id = athena_project.primary_id AND development_phase = 'Production/Technical Support'),
                '/',
                (SELECT COUNT(primary_id) FROM #{apr_db}.athena_project_requirements WHERE project_id = athena_project.primary_id)
            ),
            athena_project.project_name,                       
            athena_project.brief_description,
            athena_project.requested_priority_level,
            athena_project.requested_completion_date,   
            
            (SELECT system_name FROM #{aps_db}.athena_project_systems WHERE athena_project_systems.primary_id = athena_project.system_id),
            athena_project.priority_level,           
            athena_project.estimated_completion_date,
            (SELECT CONCAT(legal_first_name,' ',legal_last_name) FROM #{t_db}.team WHERE team.primary_id = athena_project.requester_team_id),
            athena_project.created_date
            
        FROM #{ap_db}.athena_project"
        
        headers = [
            "System/Module/Process Name"        ,
            "Project Status"                    ,
            "Development Progress"              ,
            "Requirements"                      ,
            "Project/Module/Process Name"       ,
            "Description"                       ,
            "Requested Priority"                ,
            "Requested ETA"                     ,
            "System"                            ,
            "Priority Level"                    ,
            "ETA"                               ,
            "Requestor"                         ,
            "Date Submitted"                    
            
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_athena_project_requirements(options = nil)
        
        ap_db  = $tables.attach("athena_project"                ).data_base
        apr_db = $tables.attach("athena_project_requirements"   ).data_base
        aps_db = $tables.attach("athena_project_systems"        ).data_base
        t_db   = $tables.attach("team"                          ).data_base
        
        sql_str =
        "SELECT
            
            athena_project.project_name,
            
            (SELECT system_name FROM #{aps_db}.athena_project_systems WHERE athena_project_systems.primary_id = athena_project.system_id),
            athena_project.status,
            athena_project.development_phase,
            CONCAT(
                (SELECT COUNT(primary_id) FROM #{apr_db}.athena_project_requirements WHERE project_id = athena_project.primary_id AND development_phase = 'Production/Technical Support'),
                'of',
                (SELECT COUNT(primary_id) FROM #{apr_db}.athena_project_requirements WHERE project_id = athena_project.primary_id)
            ),
            athena_project.project_name,                       
            athena_project.brief_description,
            athena_project.requested_priority_level,
            athena_project.requested_completion_date,   
            
            (SELECT system_name FROM #{aps_db}.athena_project_systems WHERE athena_project_systems.primary_id = athena_project.system_id),
            athena_project.priority_level,           
            athena_project.estimated_completion_date,
            (SELECT CONCAT(legal_first_name,' ',legal_last_name) FROM #{t_db}.team WHERE team.primary_id = athena_project.requester_team_id),
            athena_project.created_date,
            
            athena_project_systems.system_name,
            athena_project_requirements.requirement,
            athena_project_requirements.priority,
            athena_project_requirements.status,
            athena_project_requirements.development_phase,
            athena_project_requirements.automated_process,
            athena_project_requirements.pdf_template,
            athena_project_requirements.process_improvement,
            athena_project_requirements.report,
            athena_project_requirements.system_interface,
            athena_project_requirements.user_interface,
            athena_project_requirements.change,
            (SELECT CONCAT(legal_first_name,' ',legal_last_name) FROM #{t_db}.team WHERE primary_id = athena_project_requirements.requester_team_id)
            
        FROM #{         apr_db  }.athena_project
        LEFT JOIN #{    ap_db   }.athena_project_requirements   ON athena_project_requirements.project_id   = athena_project.primary_id
        LEFT JOIN #{    aps_db  }.athena_project_systems        ON athena_project.system_id                 = athena_project_systems.primary_id"
        
        headers = [
            
            "System Name",
            
            "System/Module/Process Name"        ,
            "Project Status"                    ,
            "Development Progress"              ,
            "Requirements"                      ,
            "Project/Module/Process Name"       ,
            "Description"                       ,
            "Requested Priority"                ,
            "Requested ETA"                     ,
            "System"                            ,
            "Priority Level"                    ,
            "ETA"                               ,
            "Requestor"                         ,
            "Date Submitted",
            
            "Project Name",
            "Requirement",
            "Priority Level",
            "Status",
            "Development Progress",
            "Automation?",
            "PDF Template?",
            "Process Improvement?",
            "Report?",
            "System Interface",
            "User Interface?",
            "Change?",
            "Requestor"
            
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_attendance_by_code
        
        headers =
        [
            "Date",
            "(me) excused - medical",
            "(e) excused",
            "(t) excused - technical",
            "(p) present",
            "(pap) present - academic plan",
            "(pr) present - requested",
            "(pt) present - test event",
            "(ur) unexcused - requested",
            "(u) unexcused",
            "(uap) unexcused - academic plan",
            "(ut) unexcused - test event",
            "total enrolled"
        ]
        
        sql_str =
        "SELECT
            student_attendance.date,
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'me'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'e'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 't'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'p'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'pap'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'pr'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'pt'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'ur'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'u'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'uap'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code = 'ut'
            ),
            (
               SELECT COUNT(student_id) FROM student_attendance WHERE student_attendance.date = school_days.date AND official_code IS NOT NULL
            )
            
        FROM `student_attendance`
        LEFT JOIN school_days ON school_days.date = student_attendance.date
        GROUP BY student_attendance.date"
        
        results = $db.get_data(sql_str)
        
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_attendance_consecutive_absences(options = nil)
        
        codes       = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'unexcused'", {:value_only=>true})
        codes_str   = "'#{codes.join("','")}'"
        
        target_date = $kit.params[:consecutive_target_date]
        target_date = $base.yesterday.iso_date if target_date == ""
        
        x =  $kit.params[:consecutive_days].to_i
        x += 1 if $school.school_days(target_date).length > x
        
        return false if $school.school_days(target_date).length < x
        
        prev_x_schooldays = $school.school_days(target_date).slice(-x, x)
        
        where_str = String.new
        
        headers =
        [
            
            "Student ID",
            "First Name",
            "Last Name",
            "Grade",
            "Family Coach"
            
        ]
        
        prev_x_schooldays.each_with_index do |school_day,i|
            
            if i==0 && $school.school_days(target_date).length > x
                
                where_str << "(`code_#{school_day}` NOT IN(#{codes_str}) OR `code_#{school_day}` IS NULL) "
                
            else
                
                where_str << "`code_#{school_day}` IN(#{codes_str}) "
                
                headers.insert(-1,school_day)
                
            end
            
            where_str << "AND " if i != prev_x_schooldays.length-1
            
        end if prev_x_schooldays
        
        sam_db   = $tables.attach("student_attendance_master"   ).data_base
        s_db     = $tables.attach("student"                     ).data_base
        t_db     = $tables.attach("team"                        ).data_base
        sr_db    = $tables.attach("student_relate"              ).data_base
        
        if $school.school_days(target_date).length > x
            
            school_days_sql = prev_x_schooldays[1..-1].map{|x| "`code_" + x + "`"}.join(",")
            
        else
            
            school_days_sql = prev_x_schooldays.map{|x| "`code_" + x + "`"}.join(",")
            
        end
        
        sql_str = String.new
        sql_str << "
        SELECT
            student.student_id,
            student.studentfirstname,
            student.studentlastname,
            student.grade,
            (
                SELECT
                    CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        team_id
                    FROM #{sr_db}.student_relate
                    WHERE studentid = student_attendance_master.student_id
                    AND role = 'Family Teacher Coach'
                    AND active IS TRUE
                    GROUP BY team.primary_id
                )
                GROUP BY team.primary_id
            ),
            #{school_days_sql}
            
        FROM #{sam_db}.student_attendance_master
        LEFT JOIN #{s_db}.student
        ON #{s_db}.student.student_id = #{sam_db}.student_attendance_master.student_id
        WHERE #{where_str}
        ORDER BY student_id DESC
        "
        
        results = $db.get_data(sql_str)
        
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_attendance_activity(options = nil)
        
        headers =
        [
            
            "Student ID",
            "Date",
            "Source",
            "Period",
            "Class",
            "Code",
            "Team ID",
            "Team Name",
            "Logged",
            "Created Date"
            
        ]
        
        saa_db   = $tables.attach("student_attendance_activity").data_base
        t_db     = $tables.attach("team").data_base
        tsids_db = $tables.attach("team_sams_ids").data_base
        
        date = $kit.params[:date_attendance_activity]
        
        sql_str = String.new
        sql_str << "
        SELECT
            student_id,
            date,
            source,
            period,
            class,
            code,
            team_id,
            CONCAT(legal_first_name, ' ', legal_last_name),
            logged,
            student_attendance_activity.created_date
        FROM #{saa_db}.student_attendance_activity
        LEFT JOIN #{t_db}.team
        ON #{t_db}.team.primary_id = #{saa_db}.student_attendance_activity.team_id
        WHERE date = '#{date}'
        ORDER BY student_id DESC
        "
        
        results = $db.get_data(sql_str)
        
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_attendance_master(options = nil)
        
        headers =
        [
            
            "Student ID",
            "Last Name",
            "First Name",
            "Grade Level",
            "Family ID",
            "Birthday",
            "Age",
            
            "Learning Center Classroom Coach",
            "Teacher/Guidance",
            
            "Family Coach/Comm Cord",
            "Scantron entrance math",
            "Scantron exit math",
            "Scantron entrance reading",
            "Scantron exit reading",
            
            "LEAP Level",
            
            #"Program Support",
            
            "Family Coach Support",
            "Truancy Prevention",
            "Advisor",
            
            "Enroll Date",
            "Withdraw Date",
            "Special Ed Teacher",
            "Attendance Mode",
            "District of Residence",
            
            "Enrolled",
            "Present",
            "Excused",
            "Unexcused",
            
            "att_master_id",
            "student_id"
            
        ]
        
        date_headers = $tables.attach("STUDENT_ATTENDANCE_MASTER").field_order
        date_headers.delete("primary_id")
        date_headers.delete("student_id")
        date_headers.delete("created_date")
        date_headers.delete("created_by")
        
        headers.concat(date_headers)
        
        t_db        = $tables.attach("team"             ).data_base
        tsids_db    = $tables.attach("team_sams_ids"    ).data_base
        relate_db   = $tables.attach("STUDENT_RELATE"   ).data_base
        
        sql_str = String.new
        sql_str << "
        SELECT 
            
            student.student_id,
            student.studentlastname,
            student.studentfirstname,
            student.grade,
            student.familyid,
            student.birthday,
            
            #STUDENT AGE
            (YEAR(CURDATE())-YEAR(student.birthday)) - (RIGHT(CURDATE(),5)<RIGHT(student.birthday,5)),
            
            #LEARNING CENTER CLASSROOM COACH
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM agora_master.team
                WHERE team.primary_id = (
                    SELECT
                        team_id
                    FROM #{relate_db}.student_relate
                    WHERE studentid = student.student_id
                    AND role = 'Learning Center Classroom Coach'
                    AND active IS TRUE
                    LIMIT 0, 1
                )
            ),
            
            #FAMILY TEACHER COACH
            (
                SELECT
                    CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        team_id
                    FROM #{tsids_db}.team_sams_ids
                    WHERE team_sams_ids.sams_id = student.primaryteacherid
                    LIMIT 0, 1
                )
            ),
            
            student.title1teacher,
            student_scantron_performance_level.stron_ent_perf_m,
            student_scantron_performance_level.stron_ext_perf_m,
            student_scantron_performance_level.stron_ent_perf_r,
            student_scantron_performance_level.stron_ext_perf_r,
            IFNULL(student_leap.leap_level,'0'),
            
            #FAMILY TEACHER COACH SUPPORT
            (
                SELECT
                    CONCAT(team.legal_first_name,' ',team.legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        supervisor_team_id
                    FROM #{t_db}.team
                    LEFT JOIN #{tsids_db}.team_sams_ids ON team.primary_id = team_sams_ids.team_id
                    WHERE team_sams_ids.sams_id = student.primaryteacherid
                    LIMIT 0, 1
                )
            ),
            
            #TRUANCY PREVENTION COORDINATOR
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM agora_master.team
                WHERE team.primary_id = (
                    SELECT
                        team_id
                    FROM #{relate_db}.student_relate
                    WHERE studentid = student.student_id
                    AND role = 'Truancy Prevention Coordinator'
                    AND active IS TRUE
                    LIMIT 0, 1
                )
            ),
            
            (
                SELECT
                    GROUP_CONCAT(CONCAT(team.legal_first_name,' ',team.legal_last_name))
                FROM #{t_db}.team
                WHERE department_id = (
                    SELECT
                        primary_id
                    FROM #{$tables.attach("DEPARTMENT").data_base}.department
                    WHERE name = 'Advisors'
                    LIMIT 0, 1
                )
                AND region = student.region
            ),
            
            student.schoolenrolldate,
            student.schoolwithdrawdate,
            student.specialedteacher,
            student_attendance_mode.attendance_mode,
            student.districtofresidence,"
        
        sa_db = $tables.attach("student_attendance").data_base
        
        sql_str << "#ENROLLED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND official_code IS NOT NULL
            ),"
        
        sql_str << "#PRESENT DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("present")})
            ),"
        
        sql_str << "#EXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("excused")})
            ),"
        
        sql_str << "#UNEXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("unexcused")})
            ),"
        
        sql_str << "student_attendance_master.*"
        
        sam_db      = $tables.attach("STUDENT_ATTENDANCE_MASTER"            ).data_base
        s_db        = $tables.attach("STUDENT"                              ).data_base
        sspl_db     = $tables.attach("STUDENT_SCANTRON_PERFORMANCE_LEVEL"   ).data_base
        samo_db     = $tables.attach("STUDENT_ATTENDANCE_MODE"              ).data_base
        leap_db     = $tables.attach("STUDENT_LEAP"                         ).data_base
        
        sql_str << " FROM #{sam_db}.student_attendance_master
            LEFT JOIN #{s_db}.student                                ON student.student_id                              = student_attendance_master.student_id                       
            LEFT JOIN #{sspl_db}.student_scantron_performance_level  ON student_scantron_performance_level.student_id   = student_attendance_master.student_id
            LEFT JOIN #{samo_db}.student_attendance_mode             ON student_attendance_mode.student_id              = student_attendance_master.student_id
            LEFT JOIN #{leap_db}.student_leap                        ON student_leap.student_id                         = student_attendance_master.student_id"
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_ink_orders(options = nil)
        
        io_db = $tables.attach("ink_orders").data_base
        
        sql_str =
        "SELECT
            studentid,
            request_date,
            order_date,
            ship_date,
            status,
            school_year,
            printer,
            ink,
            DATEDIFF( DATE(order_date), DATE(request_date) ),
            DATEDIFF( DATE(ship_date),  DATE(request_date) ),
            created_date,
            created_by
        FROM #{io_db}.ink_orders
        ORDER BY created_date DESC"
        
        headers =
        [
            "Student ID",
            "Request Date",
            "Order Date",
            "Ship Date",
            "Current Status",
            "School Year",
            "Printer",
            "Ink",
            "Days to Order",
            "Days to Ship",
            "Entered DateTime",
            "Created By"
        ]
        
        results = $db.get_data(sql_str)
        
        if results
            
            return results.insert(0, headers)
            
        else
            
            return false
            
        end
        
    end
    def add_new_csv_ink_orders_manual(options = nil)
        
        s_db  = $tables.attach("student").data_base
        io_db = $tables.attach("ink_orders").data_base
        
        sql_str =
        "SELECT
            ink_orders.studentid,
            ink_orders.request_date,
            ink_orders.ink,
            student.studentfirstname,
            student.studentlastname,
            student.mailingaddress1,
            student.mailingaddress2,
            student.mailingcity,
            student.mailingstate,
            student.mailingzip
            
        FROM #{io_db}.ink_orders
        LEFT JOIN #{s_db}.STUDENT
        ON #{io_db}.ink_orders.studentid = #{s_db}.student.student_id
        WHERE ink_orders.status = 'No Staples Id'"
        
        headers =
        [
            "Student ID",
            "Request Date",
            "Ink",
            "First Name",
            "Last Name",
            "Mailing Address 1",
            "Mailing Address 2",
            "Mailing City",
            "Mailing State",
            "Mailing Zip"
        ]
        
        results = $db.get_data(sql_str)
        
        if results
            
            return results.insert(0, headers)
            
        else
            
            return false
            
        end
        
    end

    def add_new_csv_student_contacts(options = nil)
        
        sc_db = $tables.attach("student_contacts").data_base
        s_db  = $tables.attach("student").data_base
        t_db  = $tables.attach("team").data_base
        
        sql_str =
        "SELECT
            student_contacts.student_id,
            student.studentlastname,
            student.studentfirstname,
            student_contacts.datetime,
            student_contacts.successful,
            student_contacts.notes,
            student_contacts.contact_type,
            student_contacts.tep_initial,
            student_contacts.tep_followup,
            student_contacts.attendance,
            student_contacts.rtii_behavior_id,
            student_contacts.test_site_selection,
            student_contacts.scantron_performance,
            student_contacts.study_island_assessments,
            student_contacts.course_progress,
            student_contacts.work_submission,
            student_contacts.grades,
            student_contacts.communications,
            student_contacts.retention_risk,
            student_contacts.escalation,
            student_contacts.welcome_call,
            student_contacts.initial_home_visit,
            student_contacts.tech_issue,
            student_contacts.low_engagement,
            student_contacts.ilp_conference,
            student_contacts.truancy_court_outcome,
            student_contacts.court_preparation,
            student_contacts.residency,
            student_contacts.ses,
            student_contacts.sap_invitation,
            student_contacts.sap_followup,
            student_contacts.evaluation_request_psych,
            student_contacts.ell,
            student_contacts.phlote_identification,
            student_contacts.cys,
            student_contacts.homeless,
            student_contacts.aircard,
            student_contacts.court_district_go,
            student_contacts.counselor_one_on_one,
            student_contacts.counselor_face_to_face,
            student_contacts.counselor_graduation_meeting,
            student_contacts.counselor_intervention,
            student_contacts.504_conference,
            student_contacts.progress_monitoring,
            student_contacts.target_time,
            student_contacts.win,
            student_contacts.other,
            student_contacts.other_description,
            team.legal_last_name,
            team.legal_first_name,
            student_contacts.created_by,
            team.department,
            team.title,
            student_contacts.created_date,
            TIMESTAMPDIFF(DAY,student_contacts.datetime,student_contacts.created_date)
        FROM #{sc_db}.student_contacts
        LEFT JOIN #{s_db}.student
        ON #{sc_db}.student_contacts.student_id = #{s_db}.student.student_id
        LEFT JOIN #{t_db}.team_email
        ON #{t_db}.team_email.email_address = #{sc_db}.student_contacts.created_by
        LEFT JOIN #{t_db}.team
        ON #{t_db}.team.primary_id = #{t_db}.team_email.team_id"
        
        headers =
        [
            "Student ID",
            "Student Last Name",
            "Student First Name",
            "Contact Datetime",
            "successful",
            "notes",
            "contact_type",
            "tep_initial",
            "tep_followup",
            "attendance",
            "rtii_behavior_id",
            "test_site_selection",
            "scantron_performance",
            "study_island_assessments",
            "course_progress",
            "work_submission",
            "grades",
            "communications",
            "retention_risk",
            "escalation",
            "welcome_call",
            "initial_home_visit",
            "tech_issue",
            "low_engagement",
            "ilp_conference",
            "truancy_court_outcome",
            "court_preparation",
            "residency",
            "ses",
            "sap_invitation",
            "sap_followup",
            "evaluation_request_psych",
            "ell",
            "phlote_identification",
            "cys",
            "homeless",
            "aircard",
            "court_district_go",
            "counselor_one_on_one",
            "counselor_face_to_face",
            "counselor_graduation_meeting",
            "counselor_intervention",
            "504_conference",
            "progress_monitoring",
            "Target Time",
            "WIN",
            "other",
            "other_description",
            "Created By Last Name",
            "Created By First Name",
            "Created By Email",
            "Created By Department",
            "Created By Title",
            "Created Date",
            "Days Between Contact And Entry"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_my_student_contacts(options = nil)
        
        sc_db = $tables.attach("student_contacts").data_base
        s_db  = $tables.attach("student").data_base
        t_db  = $tables.attach("team").data_base
        
        sql_str =
        "SELECT
            student_contacts.student_id,
            student.studentlastname,
            student.studentfirstname,
            student_contacts.datetime,
            student_contacts.successful,
            student_contacts.notes,
            student_contacts.contact_type,
            student_contacts.tep_initial,
            student_contacts.tep_followup,
            student_contacts.attendance,
            student_contacts.rtii_behavior_id,
            student_contacts.test_site_selection,
            student_contacts.scantron_performance,
            student_contacts.study_island_assessments,
            student_contacts.course_progress,
            student_contacts.work_submission,
            student_contacts.grades,
            student_contacts.communications,
            student_contacts.retention_risk,
            student_contacts.escalation,
            student_contacts.welcome_call,
            student_contacts.initial_home_visit,
            student_contacts.tech_issue,
            student_contacts.low_engagement,
            student_contacts.ilp_conference,
            student_contacts.truancy_court_outcome,
            student_contacts.court_preparation,
            student_contacts.residency,
            student_contacts.ses,
            student_contacts.sap_invitation,
            student_contacts.sap_followup,
            student_contacts.evaluation_request_psych,
            student_contacts.ell,
            student_contacts.phlote_identification,
            student_contacts.cys,
            student_contacts.homeless,
            student_contacts.aircard,
            student_contacts.court_district_go,
            student_contacts.counselor_one_on_one,
            student_contacts.counselor_face_to_face,
            student_contacts.counselor_graduation_meeting,
            student_contacts.counselor_intervention,
            student_contacts.504_conference,
            student_contacts.progress_monitoring,
            student_contacts.target_time,
            student_contacts.win,
            student_contacts.other,
            student_contacts.other_description,
            team.legal_last_name,
            team.legal_first_name,
            student_contacts.created_by,
            team.department,
            team.title,
            student_contacts.created_date,
            TIMESTAMPDIFF(DAY,student_contacts.datetime,student_contacts.created_date)
        FROM #{sc_db}.student_contacts
        LEFT JOIN #{s_db}.student
        ON #{sc_db}.student_contacts.student_id = #{s_db}.student.student_id
        LEFT JOIN #{t_db}.team_email
        ON #{t_db}.team_email.email_address = #{sc_db}.student_contacts.created_by
        LEFT JOIN #{t_db}.team
        ON #{t_db}.team.primary_id = #{t_db}.team_email.team_id
        WHERE student_contacts.created_by = '#{$user.email_address_k12.value||$user}'"
        
        headers =
        [
            "Student ID",
            "Student Last Name",
            "Student First Name",
            "Contact Datetime",
            "successful",
            "notes",
            "contact_type",
            "tep_initial",
            "tep_followup",
            "attendance",
            "rtii_behavior_id",
            "test_site_selection",
            "scantron_performance",
            "study_island_assessments",
            "course_progress",
            "work_submission",
            "grades",
            "communications",
            "retention_risk",
            "escalation",
            "welcome_call",
            "initial_home_visit",
            "tech_issue",
            "low_engagement",
            "ilp_conference",
            "truancy_court_outcome",
            "court_preparation",
            "residency",
            "ses",
            "sap_invitation",
            "sap_followup",
            "evaluation_request_psych",
            "ell",
            "phlote_identification",
            "cys",
            "homeless",
            "aircard",
            "court_district_go",
            "counselor_one_on_one",
            "counselor_face_to_face",
            "counselor_graduation_meeting",
            "counselor_intervention",
            "504_conference",
            "progress_monitoring",
            "Target Time",
            "WIN",
            "other",
            "other_description",
            "Created By Last Name",
            "Created By First Name",
            "Created By Email",
            "Created By Department",
            "Created By Title",
            "Created Date",
            "Days Between Contact And Entry"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_my_students_general(options = nil)
        
        s_db  = $tables.attach("student").data_base
        sr_db = $tables.attach("student_relate").data_base
        
        sql_str =
        "SELECT
            IF(
                (
                    SELECT
                        primary_id
                    FROM #{sr_db}.student_relate
                    WHERE team_id = '#{$team_member.primary_id.value}'
                    AND student_relate.studentid = student.student_id
                    AND active IS TRUE
                    GROUP BY team_id
                ),
                'Yes',
                'No'
            ),
            (
                SELECT
                    created_date
                FROM #{sr_db}.student_relate
                WHERE team_id = '#{$team_member.primary_id.value}'
                AND student_relate.studentid = student.student_id
                GROUP BY team_id
                ORDER BY created_date ASC
            ),
            student_id,
            studentlastname,
            studentfirstname,
            studentmiddlename,
            studentgender,
            districtofresidence,
            grade,
            birthday,
            mailingaddress1,
            mailingaddress2,
            mailingcity,
            mailingzip,
            mailingstate,
            studenthomephone,
            shippingaddress1,
            shippingaddress2,
            shippingcity,
            shippingzip,
            shippingstate,
            physicaladdress1,
            physicaladdress2,
            physicalregion,
            physicalcity,
            pcounty,
            physicalzip,
            physicalstate,
            lclastname,
            lcfirstname,
            lcrelationship,
            lcemail,
            lglastname,
            lgfirstname,
            lgrelationship,
            lgemail,
            studentemail
        FROM #{s_db}.student
        LEFT JOIN #{sr_db}.student_relate
            ON #{s_db}.student.student_id = #{sr_db}.student_relate.studentid
        WHERE (
            student_relate.team_id = '#{$team_member.primary_id.value}'
        )
        GROUP BY student.student_id"
        
        headers =
        [
            "Active?",
            "1st Assigned Date",
            "student_id",
            "studentlastname",
            "studentfirstname",
            "studentmiddlename",
            "studentgender",
            "districtofresidence",
            "grade",
            "birthday",
            "mailingaddress1",
            "mailingaddress2",
            "mailingcity",
            "mailingzip",
            "mailingstate",
            "studenthomephone",
            "shippingaddress1",
            "shippingaddress2",
            "shippingcity",
            "shippingzip",
            "shippingstate",
            "physicaladdress1",
            "physicaladdress2",
            "physicalregion",
            "physicalcity",
            "pcounty",
            "physicalzip",
            "physicalstate",
            "lclastname",
            "lcfirstname",
            "lcrelationship",
            "lcemail",
            "lglastname",
            "lgfirstname",
            "lgrelationship",
            "lgemail",
            "studentemail"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_my_students_tests(options = nil)
        
        s_db     = $tables.attach("student").data_base
        sr_db    = $tables.attach("student_relate").data_base
        st_db    = $tables.attach("student_tests").data_base
        tst_db   = $tables.attach("tests").data_base
        te_db    = $tables.attach("test_events").data_base
        ts_db    = $tables.attach("test_subjects").data_base
        tes_db   = $tables.attach("test_event_sites").data_base
        tsids_db = $tables.attach("team_sams_ids").data_base
        t_db     = $tables.attach("team").data_base
        sat_db   = $tables.attach("student_aims_tests").data_base
        
        sql_str =
        "SELECT
            student_tests.student_id,
            studentfirstname,
            studentlastname,
            tests.name,
            test_events.name,
            test_subjects.name,
            test_event_sites.site_name,
            student_tests.assigned,
            student_tests.checked_in,
            student_tests.serial_number,
            student_tests.completed,
            CONCAT(team.legal_first_name,' ',team.legal_last_name),
            student_tests.test_results,
            student_tests.drop_off,
            student_tests.pick_up,
            student_aims_tests.k2_skill_check_complete,     
            student_aims_tests.writing_sample_received,   
            student_aims_tests.35_math_open_prompt_complete,
            student_aims_tests.core_phonics_letter_names_upper,          
            student_aims_tests.core_phonics_letter_names_lower,          
            student_aims_tests.core_phonics_consonant,                   
            student_aims_tests.core_phonics_long_vowel,                  
            student_aims_tests.core_phonics_short_vowel,                 
            student_aims_tests.core_phonics_short_vowel_cvc,
            student_aims_tests.core_phonics_short_vowel_digraph,
            student_aims_tests.core_phonics_consonant_blend,
            student_aims_tests.core_phonics_long_vowel_spelling,
            student_aims_tests.core_phonics_rl_control,
            student_aims_tests.core_phonics_variant_vowels,
            student_aims_tests.core_phonics_multisyllabic,
            student_aims_tests.core_phonics_spelling_a,
            student_aims_tests.core_phonics_spelling_b,
            student_aims_tests.core_phonics_spelling_c,
            student_aims_tests.reading_comprehension,
            student_aims_tests.reading_comprehension_who_read,
            student_aims_tests.lnf,                                      
            student_aims_tests.lnf_errors,                               
            student_aims_tests.lsf,                                      
            student_aims_tests.lsf_errors,                               
            student_aims_tests.psf,                                      
            student_aims_tests.psf_errors,                               
            student_aims_tests.nwf,                                      
            student_aims_tests.nwf_errors,                               
            student_aims_tests.rcbm,                                     
            student_aims_tests.rcbm_errors,                              
            student_aims_tests.reading_instructional_recommendation,     
            student_aims_tests.ocm,                                      
            student_aims_tests.ocm_errors,                               
            student_aims_tests.nim,                                      
            student_aims_tests.nim_errors,                               
            student_aims_tests.qdm,                                      
            student_aims_tests.qdm_errors,                               
            student_aims_tests.mnm,                                      
            student_aims_tests.mnm_errors,                               
            student_aims_tests.mcap,                                     
            student_aims_tests.math_instructional_recommendation,        
            student_aims_tests.notes
            
        FROM #{st_db}.student_tests
        LEFT JOIN #{s_db}.student              ON #{st_db}.student_tests.student_id         = #{s_db}.student.student_id
        LEFT JOIN #{tst_db}.tests              ON #{st_db}.student_tests.test_id            = #{tst_db}.tests.primary_id
        LEFT JOIN #{te_db}.test_events         ON #{st_db}.student_tests.test_event_id      = #{te_db}.test_events.primary_id
        LEFT JOIN #{ts_db}.test_subjects       ON #{st_db}.student_tests.test_subject_id    = #{ts_db}.test_subjects.primary_id
        LEFT JOIN #{tes_db}.test_event_sites   ON #{st_db}.student_tests.test_event_site_id = #{tes_db}.test_event_sites.primary_id
        LEFT JOIN #{tsids_db}.team_sams_ids    ON #{st_db}.student_tests.test_administrator = #{tsids_db}.team_sams_ids.sams_id
        LEFT JOIN #{t_db}.team                 ON #{tsids_db}.team_sams_ids.team_id         = #{t_db}.team.primary_id
        LEFT JOIN #{sat_db}.student_aims_tests ON #{sat_db}.student_aims_tests.test_id      = #{st_db}.student_tests.primary_id
        LEFT JOIN #{sr_db}.student_relate      ON #{s_db}.student.student_id                = #{sr_db}.student_relate.studentid
        
        WHERE
            student_relate.team_id = '#{$team_member.primary_id.value}'
            
        GROUP BY student.student_id"
        
        headers = [
            "Student ID",
            "First Name",
            "Last Name",
            "Test Type",
            "Event",
            "Subject",
            "Site",
            "Site Assigned by Office?",
            "Check In Date",
            "Serial Number",
            "Completed?",
            "Test Administrator",
            "Test Results",
            "Notes 1",
            "Notes 2",
            "K-2 Skill Check Completed",
            "Writing Sample Received",
            "3rd - 5th Math Open-Ended Prompt Completed",
            "AIMS-CORE Phonics- Letter Names Upper Case (_/26)",
            "AIMS-CORE Phonics- Letter Names Lower Case (_/26)",
            "AIMS-CORE Phonics- Consonant Sounds (_/23)",
            "AIMS-CORE Phonics- Long Vowel Sounds (_/5)",
            "AIMS-CORE Phonics- Short Vowel Sounds (_/5)",
            "AIMS-CORE PHONICS- Short Vowels in CVC Words (_/10)",
            "AIMS-CORE PHONICS- Short Vowels, Digraphs, and -tch trigraph (_/10)",
            "AIMS-CORE PHONICS- Consonant Blends with Short Vowels (_/20)",
            "AIMS-CORE PHONICS- Long Vowel Spelling (_/10)",
            "AIMS-CORE PHONICS- R- and L- Controlled Words (_/10)",
            "AIMS-CORE PHONICS- Variant Vowels and Dipthongs (_/10)",
            "AIMS-CORE PHONICS- Multisyllabic Words (_/24)",
            "AIMS-CORE-PHONICS- Spelling A First Sounds (_/5)",
            "AIMS-CORE-PHONICS- Spelling B Last Sounds (_/5)",
            "AIMS-CORE-PHONICS- Spelling C Whole Words (_/10)",
            "AIMS-Reading Comprehension (correct/total)",
            "AIMS-Reading Comprehension (Student Read or Teacher Read)",
            "AIMS-LNF",
            "AIMS-LNF Errors",
            "AIMS-LSF",
            "AIMS-LSF Errors",
            "AIMS-PSF",
            "AIMS-PSF Errors",
            "AIMS-NWF",
            "AIMS-NWF Errors",
            "AIMS-R-CBM",
            "AIMS-R-CBM Errors",
            "AIMS-Reading Instructional Recommendation (K - 2)",
            "AIMS-OCM",
            "AIMS-OCM Errors",
            "AIMS-NIM",
            "AIMS-NIM Errors",
            "AIMS-QDM",
            "AIMS-QDM Errors",
            "AIMS-MNM",
            "AIMS-MNM Errors",
            "AIMS-M-COMP", #Still M-CAP field
            "AIMS-Math Instructional Recommendation (K - 2)",
            "AIMS-Notes"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_student_assessment_exemptions(options = nil)
        
        s_db        = $tables.attach("STUDENT"              ).data_base
        sa_db       = $tables.attach("STUDENT_ASSESSMENT"   ).data_base
        
        sql_str =
        "SELECT
            
            student.student_id,
            student_assessment.aims_exempt,           
            student_assessment.scantron_exempt_ent_m, 
            student_assessment.scantron_exempt_ent_r, 
            student_assessment.scantron_exempt_ext_m, 
            student_assessment.scantron_exempt_ext_r, 
            student_assessment.study_island_exempt,   
            student_assessment.pasa_eligible,         
            student_assessment.tier_level_math,       
            student_assessment.tier_level_reading,    
            student_assessment.engagement_level,      
            student_assessment.religious_exempt     
          
        FROM #{s_db}.student
        
        LEFT JOIN   #{sa_db}.student_assessment ON student_assessment.student_id = student.student_id
        
        WHERE student.active IS TRUE"
        
        headers =
        [
            
            "student_id",
            "aims_exempt",          
            "scantron_exempt_ent_m",
            "scantron_exempt_ent_r",
            "scantron_exempt_ext_m",
            "scantron_exempt_ext_r",
            "study_island_exempt",  
            "pasa_eligible",        
            "tier_level_math",      
            "tier_level_reading",   
            "engagement_level",     
            "religious_exempt"    
           
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_student_ilp(options = nil)
        
        s_db        = $tables.attach("STUDENT"              ).data_base
        silp_db     = $tables.attach("STUDENT_ILP"          ).data_base
        ilp_cat_db  = $tables.attach("ILP_ENTRY_CATEGORY"   ).data_base
        ilp_typ_db  = $tables.attach("ILP_ENTRY_TYPE"       ).data_base
        
        sql_str =
        "SELECT
            
            student.student_id,
            ilp_entry_category.name,
            ilp_entry_type.name,
            student_ilp.description,
            student_ilp.solution,
            student_ilp.completed,
            student_ilp.progress,
            student_ilp.monday,
            student_ilp.tuesday,
            student_ilp.wednesday,
            student_ilp.thursday,
            student_ilp.friday,
            student_ilp.day1,
            student_ilp.day2,
            student_ilp.day3,
            student_ilp.day4,
            student_ilp.day5,
            student_ilp.day6,
            student_ilp.day7,
            student_ilp.expiration_date,
            student_ilp.pdf_excluded,
            student_ilp.created_date,
            student_ilp.created_by
            
        FROM #{s_db}.student
        
        LEFT JOIN   #{silp_db   }.student_ilp           ON student.student_id                   =  student_ilp.student_id  
        LEFT JOIN   #{ilp_cat_db}.ilp_entry_category    ON student_ilp.ilp_entry_category_id    =  ilp_entry_category.primary_id
        LEFT JOIN   #{ilp_typ_db}.ilp_entry_type        ON student_ilp.ilp_entry_type_id        =  ilp_entry_type.primary_id
        
        WHERE student.active IS TRUE"
        
        headers =
        [
            
            "student_id",
            "ilp_entry_category.name",
            "ilp_entry_type.name",
            "student_ilp.description",
            "solution",
            "completed",
            "progress",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "day1",
            "day2",
            "day3",
            "day4",
            "day5",
            "day6",
            "day7",
            "expiration_date",
            "pdf_excluded",
            "student_ilp.created_date",
            "student_ilp.created_by"
           
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_student_ilp_survey_completion(options = nil)
        
        s_db    = $tables.attach("STUDENT"      ).data_base
        silp_db = $tables.attach("STUDENT_ILP"  ).data_base
        
        sql_str =
        "SELECT
            student_id,
            CONCAT(
                
                '(',
                
                (
                    SELECT
                        count(primary_id)
                    FROM #{silp_db}.student_ilp
                    WHERE student_ilp.student_id = student.student_id
                    AND description IS NOT NULL
                    AND `ilp_entry_category_id` = '7'
                ),
                
                '/',
                
                (
                    SELECT
                        count(primary_id)
                    FROM #{silp_db}.student_ilp
                    WHERE student_ilp.student_id = student.student_id
                    AND `ilp_entry_category_id` = '7'
                ),
                
                ')'
                
            ) 
        FROM #{s_db}.`student`
        WHERE student.active IS TRUE"
        
        headers =
        [
            "student_id",
            "survey_completion"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_student_rtii_behavior(options = nil)
        
        srtiib_db = $tables.attach("student_rtii_behavior").data_base
        
        sql_str =
        "SELECT
            student_id,
            targeted_behavior,
            skill_group,
            intervention,
            intervention_details,
            results,
            proof,
            created_by,
            created_date
        FROM #{srtiib_db}.student_rtii_behavior
        WHERE student_id IS NOT NULL"
        
        headers =
        [
            "student_id",
            "targeted_behavior",
            "skill_group",
            "intervention",
            "intervention_details",
            "results",
            "proof",
            "created_by",
            "created_date"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_student_scantron_participation(options = nil)
        
        spe_db = $tables.attach("scantron_performance_extended").data_base
        sspl_db = $tables.attach("student_scantron_performance_level").data_base
        s_db  = $tables.attach("student").data_base
        k12_db  = $tables.attach("k12_omnibus").data_base
        
        sql_str =
        "SELECT
            student.student_id,
            student.studentfirstname,
            student.studentlastname,
            student.primaryteacher,
            student_scantron_performance_level.`stron_ent_perf_m`,
            student_scantron_performance_level.`stron_ent_score_m`,
            student_scantron_performance_level.`stron_ext_perf_m`,
            student_scantron_performance_level.`stron_ext_score_m`,
            student_scantron_performance_level.`stron_ent_perf_r`,
            student_scantron_performance_level.`stron_ent_score_r`,
            student_scantron_performance_level.`stron_ext_perf_r`,
            student_scantron_performance_level.`stron_ext_score_r`,
            (
                SELECT
                    modified_date
                FROM    #{sspl_db}.zz_student_scantron_performance_level
                WHERE   modified_pid = student_scantron_performance_level.primary_id
                GROUP BY modified_pid
                ORDER BY modified_date DESC
                
            ),
            (
                SELECT
                    created_date
                FROM #{spe_db}.scantron_performance_extended
                WHERE primary_id =1
                
            )
        FROM #{s_db}.student
        LEFT JOIN #{sspl_db}.student_scantron_performance_level ON #{sspl_db}.student_scantron_performance_level.student_id = #{s_db}.student.student_id
        LEFT JOIN #{k12_db}.k12_omnibus ON #{k12_db}.k12_omnibus.student_id = #{s_db}.student.student_id
        WHERE k12_omnibus.schoolenrolldate IS NOT NULL
        AND k12_omnibus.schoolenrolldate <= CURDATE()
        AND k12_omnibus.enrollapproveddate IS NOT NULL
        AND student.grade NOT REGEXP 'K|1st|2nd'"
        
        headers =
        [
            "student_id",
            "studentfirstname",
            "studentlastname",
            "primaryteacher",
            "stron_ent_perf_m",
            "stron_ent_score_m",
            "stron_ext_perf_m",
            "stron_ext_score_m",
            "stron_ent_perf_r",
            "stron_ent_score_r",
            "stron_ext_perf_r",
            "stron_ext_score_r",
            "last student update",
            "last scantron update"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_student_testing_events_tests(options = nil)
        
        headers = [
            "Student ID",
            "First Name",
            "Last Name",
            "Test Type",
            "Event",
            "Subject",
            "Site",
            "Site Assigned by Office?",
            "Check In Date",
            "Serial Number",
            "Completed?",
            "Test Administrator",
            "Test Results",
            "Notes 1",
            "Notes 2",
            "K-2 Skill Check Completed",
            "Writing Sample Received",
            "3rd - 5th Math Open-Ended Prompt Completed",
            "AIMS-CORE Phonics- Letter Names Upper Case (_/26)",
            "AIMS-CORE Phonics- Letter Names Lower Case (_/26)",
            "AIMS-CORE Phonics- Consonant Sounds (_/23)",
            "AIMS-CORE Phonics- Long Vowel Sounds (_/5)",
            "AIMS-CORE Phonics- Short Vowel Sounds (_/5)",
            "AIMS-CORE PHONICS- Short Vowels in CVC Words (_/10)",
            "AIMS-CORE PHONICS- Short Vowels, Digraphs, and -tch trigraph (_/10)",
            "AIMS-CORE PHONICS- Consonant Blends with Short Vowels (_/20)",
            "AIMS-CORE PHONICS- Long Vowel Spelling (_/10)",
            "AIMS-CORE PHONICS- R- and L- Controlled Words (_/10)",
            "AIMS-CORE PHONICS- Variant Vowels and Dipthongs (_/10)",
            "AIMS-CORE PHONICS- Multisyllabic Words (_/24)",
            "AIMS-CORE-PHONICS- Spelling A First Sounds (_/5)",
            "AIMS-CORE-PHONICS- Spelling B Last Sounds (_/5)",
            "AIMS-CORE-PHONICS- Spelling C Whole Words (_/10)",
            "AIMS-Reading Comprehension (correct/total)",
            "AIMS-Reading Comprehension (Student Read or Teacher Read)",
            "AIMS-LNF",
            "AIMS-LNF Errors",
            "AIMS-LSF",
            "AIMS-LSF Errors",
            "AIMS-PSF",
            "AIMS-PSF Errors",
            "AIMS-NWF",
            "AIMS-NWF Errors",
            "AIMS-R-CBM",
            "AIMS-R-CBM Errors",
            "AIMS-Reading Instructional Recommendation (K - 2)",
            "AIMS-OCM",
            "AIMS-OCM Errors",
            "AIMS-NIM",
            "AIMS-NIM Errors",
            "AIMS-QDM",
            "AIMS-QDM Errors",
            "AIMS-MNM",
            "AIMS-MNM Errors",
            "AIMS-M-COMP", #Still M-CAP field
            "AIMS-Math Instructional Recommendation (K - 2)",
            "AIMS-Notes"
        ]
        
        s_db     = $tables.attach("student").data_base
        st_db    = $tables.attach("student_tests").data_base
        tst_db   = $tables.attach("tests").data_base
        te_db    = $tables.attach("test_events").data_base
        ts_db    = $tables.attach("test_subjects").data_base
        tes_db   = $tables.attach("test_event_sites").data_base
        tsids_db = $tables.attach("team_sams_ids").data_base
        t_db     = $tables.attach("team").data_base
        sat_db   = $tables.attach("student_aims_tests").data_base
        
        sql_str =
        "SELECT
            student_tests.student_id,
            studentfirstname,
            studentlastname,
            tests.name,
            test_events.name,
            test_subjects.name,
            test_event_sites.site_name,
            student_tests.assigned,
            student_tests.checked_in,
            student_tests.serial_number,
            student_tests.completed,
            CONCAT(team.legal_first_name,' ',team.legal_last_name),
            student_tests.test_results,
            student_tests.drop_off,
            student_tests.pick_up,
            student_aims_tests.k2_skill_check_complete,     
            student_aims_tests.writing_sample_received,   
            student_aims_tests.35_math_open_prompt_complete,
            student_aims_tests.core_phonics_letter_names_upper,          
            student_aims_tests.core_phonics_letter_names_lower,          
            student_aims_tests.core_phonics_consonant,                   
            student_aims_tests.core_phonics_long_vowel,                  
            student_aims_tests.core_phonics_short_vowel,                 
            student_aims_tests.core_phonics_short_vowel_cvc,
            student_aims_tests.core_phonics_short_vowel_digraph,
            student_aims_tests.core_phonics_consonant_blend,
            student_aims_tests.core_phonics_long_vowel_spelling,
            student_aims_tests.core_phonics_rl_control,
            student_aims_tests.core_phonics_variant_vowels,
            student_aims_tests.core_phonics_multisyllabic,
            student_aims_tests.core_phonics_spelling_a,
            student_aims_tests.core_phonics_spelling_b,
            student_aims_tests.core_phonics_spelling_c,
            student_aims_tests.reading_comprehension,
            student_aims_tests.reading_comprehension_who_read,
            student_aims_tests.lnf,                                      
            student_aims_tests.lnf_errors,                               
            student_aims_tests.lsf,                                      
            student_aims_tests.lsf_errors,                               
            student_aims_tests.psf,                                      
            student_aims_tests.psf_errors,                               
            student_aims_tests.nwf,                                      
            student_aims_tests.nwf_errors,                               
            student_aims_tests.rcbm,                                     
            student_aims_tests.rcbm_errors,                              
            student_aims_tests.reading_instructional_recommendation,     
            student_aims_tests.ocm,                                      
            student_aims_tests.ocm_errors,                               
            student_aims_tests.nim,                                      
            student_aims_tests.nim_errors,                               
            student_aims_tests.qdm,                                      
            student_aims_tests.qdm_errors,                               
            student_aims_tests.mnm,                                      
            student_aims_tests.mnm_errors,                               
            student_aims_tests.mcap,                                     
            student_aims_tests.math_instructional_recommendation,        
            student_aims_tests.notes
            
        FROM #{st_db}.student_tests
        LEFT JOIN #{s_db}.student              ON #{st_db}.student_tests.student_id         = #{s_db}.student.student_id
        LEFT JOIN #{tst_db}.tests              ON #{st_db}.student_tests.test_id            = #{tst_db}.tests.primary_id
        LEFT JOIN #{te_db}.test_events         ON #{st_db}.student_tests.test_event_id      = #{te_db}.test_events.primary_id
        LEFT JOIN #{ts_db}.test_subjects       ON #{st_db}.student_tests.test_subject_id    = #{ts_db}.test_subjects.primary_id
        LEFT JOIN #{tes_db}.test_event_sites   ON #{st_db}.student_tests.test_event_site_id = #{tes_db}.test_event_sites.primary_id
        LEFT JOIN #{tsids_db}.team_sams_ids    ON #{st_db}.student_tests.test_administrator = #{tsids_db}.team_sams_ids.sams_id
        LEFT JOIN #{t_db}.team                 ON #{tsids_db}.team_sams_ids.team_id         = #{t_db}.team.primary_id
        LEFT JOIN #{sat_db}.student_aims_tests ON #{sat_db}.student_aims_tests.test_id      = #{st_db}.student_tests.primary_id"
        
        results = $db.get_data(sql_str)
        if results
            
            return results.insert(0, headers)
            
        else
            
            return [headers]
            
        end
        
    end
    
    def add_new_csv_student_testing_events_attendance(options = nil)
        
        std_db  = $tables.attach("student_test_dates").data_base
        tes_db  = $tables.attach("test_event_sites").data_base
        s_db    = $tables.attach("student").data_base
        
        sql_str =
        "SELECT
            student_test_dates.student_id,
            studentlastname,
            studentfirstname,
            site_name,
            date,
            attendance_code
        FROM #{std_db}.student_test_dates
        LEFT JOIN #{tes_db}.test_event_sites ON #{std_db}.student_test_dates.test_event_site_id = #{tes_db}.test_event_sites.primary_id
        LEFT JOIN #{s_db}.student ON #{s_db}.student.student_id = #{std_db}.student_test_dates.student_id"
        
        headers =
        [
           
           "student_id",
           "studentlastname",
           "studentfirstname",
           "site_name",
           "date",
           "attendance_code"
            
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_team_member_evaluations_academic
        
        t_db     = $tables.attach("team").data_base
        d_db     = $tables.attach("department").data_base
        tes_db   = $tables.attach("team_evaluation_summary").data_base
        team_db  = $tables.attach("team_evaluation_academic_metrics").data_base
        teai_db  = $tables.attach("team_evaluation_academic_instruction").data_base
        teap_db  = $tables.attach("team_evaluation_academic_professionalism").data_base
        teaab_db = $tables.attach("team_evaluation_aab").data_base
        
        sql_str =
        "SELECT
            team.primary_id AS team_id,
            team.legal_first_name,
            team.legal_last_name,
            team.department_id,
            department.name AS 'department_name',
            team.peer_group_id,
            /* SUMMARY */
            team_evaluation_summary.students,
            team_evaluation_summary.all_students,
            team_evaluation_summary.new,
            team_evaluation_summary.in_year,
            team_evaluation_summary.low_income,
            team_evaluation_summary.tier_23,
            team_evaluation_summary.special_ed,
            team_evaluation_summary.grades_712,
            team_evaluation_summary.scantron_participation_fall,
            team_evaluation_summary.scantron_participation_spring,
            team_evaluation_summary.scantron_growth_overall,
            team_evaluation_summary.scantron_growth_math,
            team_evaluation_summary.scantron_growth_reading,
            team_evaluation_summary.aims_participation_fall,
            team_evaluation_summary.aims_participation_spring,
            team_evaluation_summary.aims_growth_overall,
            team_evaluation_summary.study_island_participation,
            team_evaluation_summary.study_island_participation_tier_23,
            team_evaluation_summary.study_island_achievement,
            team_evaluation_summary.study_island_achievement_tier_23,
            team_evaluation_summary.define_u_participation,
            team_evaluation_summary.pssa_participation,
            team_evaluation_summary.keystone_participation,
            team_evaluation_summary.attendance_rate,
            team_evaluation_summary.retention_rate,
            team_evaluation_summary.engagement_level,
            team_evaluation_summary.score,
            team_evaluation_summary.goal_1,
            team_evaluation_summary.goal_2,
            team_evaluation_summary.goal_3,
            team_evaluation_summary.team_member_comments,
            team_evaluation_summary.supervisor_comments,
            /* METRICS */
            team_evaluation_academic_metrics.assessment_performance,                   
            team_evaluation_academic_metrics.assessment_performance_attainable,        
            team_evaluation_academic_metrics.assessment_participation_fall,                 
            team_evaluation_academic_metrics.assessment_participation_fall_attainable,
            team_evaluation_academic_metrics.assessment_participation_spring,                 
            team_evaluation_academic_metrics.assessment_participation_spring_attainable, 
            team_evaluation_academic_metrics.course_passing_rate,                      
            team_evaluation_academic_metrics.course_passing_rate_attainable,           
            team_evaluation_academic_metrics.study_island_participation,               
            team_evaluation_academic_metrics.study_island_participation_attainable,    
            team_evaluation_academic_metrics.study_island_achievement,                 
            team_evaluation_academic_metrics.study_island_achievement_attainable,      
            team_evaluation_academic_metrics.score,
            team_evaluation_academic_metrics.team_member_comments,
            team_evaluation_academic_metrics.supervisor_comments,
            /* INSTRUCTION */
            team_evaluation_academic_instruction.source_comprehensive_observation,
            team_evaluation_academic_instruction.source_lesson_recordings,        
            team_evaluation_academic_instruction.source_unannounced_observation,  
            team_evaluation_academic_instruction.score,
            team_evaluation_academic_instruction.team_member_comments,
            team_evaluation_academic_instruction.supervisor_comments,
            /* PROFESSIONALISM */
            team_evaluation_academic_professionalism.source_conduct,              
            team_evaluation_academic_professionalism.source_record_keeping,        
            team_evaluation_academic_professionalism.source_communication,         
            team_evaluation_academic_professionalism.source_professional_growth,   
            team_evaluation_academic_professionalism.score,
            team_evaluation_academic_professionalism.team_member_comments,
            team_evaluation_academic_professionalism.supervisor_comments,
            /* ABOVE AND BEYOND */
            team_evaluation_aab.source_mentoring,
            team_evaluation_aab.source_recruitment_team,
            team_evaluation_aab.source_committee,
            team_evaluation_aab.source_testing,
            team_evaluation_aab.source_after_hours,
            team_evaluation_aab.source_leading_pd,
            team_evaluation_aab.source_program_admin,
            team_evaluation_aab.source_local_club,
            team_evaluation_aab.source_subsitute_no_pay,
            team_evaluation_aab.source_parent_training,
            team_evaluation_aab.source_distinguished_aims,
            team_evaluation_aab.source_distinguished_define_u,
            team_evaluation_aab.source_other,
            team_evaluation_aab.team_member_comments,
            team_evaluation_aab.supervisor_comments
            
        FROM #{t_db}.team
        LEFT JOIN #{d_db}.department                                   ON #{d_db}.department.primary_id                               = #{t_db}.team.department_id
        LEFT JOIN #{tes_db}.team_evaluation_summary                    ON #{tes_db}.team_evaluation_summary.team_id                   = #{t_db}.team.primary_id
        LEFT JOIN #{team_db}.team_evaluation_academic_metrics          ON #{team_db}.team_evaluation_academic_metrics.team_id         = #{t_db}.team.primary_id
        LEFT JOIN #{teai_db}.team_evaluation_academic_instruction      ON #{teai_db}.team_evaluation_academic_instruction.team_id     = #{t_db}.team.primary_id
        LEFT JOIN #{teap_db}.team_evaluation_academic_professionalism  ON #{teap_db}.team_evaluation_academic_professionalism.team_id = #{t_db}.team.primary_id
        LEFT JOIN #{teaab_db}.team_evaluation_aab                      ON #{teaab_db}.team_evaluation_aab.team_id                     = #{t_db}.team.primary_id
        WHERE department_category = 'Academic'
        GROUP BY team.primary_id"
        
        headers =
        [
            "team_id",
            "legal_first_name",
            "legal_last_name",
            "department_id",
            "department_name",
            "peer_group_id",
            "summary students",
            "summary all_students",
            "summary new",
            "summary in_year",
            "summary low_income",
            "summary tier_23",
            "summary special_ed",
            "summary grades_712",
            "summary scantron_participation_fall",
            "summary scantron_participation_spring",
            "summary scantron_growth_overall",
            "summary scantron_growth_math",
            "summary scantron_growth_reading",
            "summary aims_participation_fall",
            "summary aims_participation_spring",
            "summary aims_growth_overall",
            "summary study_island_participation",
            "summary study_island_participation_tier_23",
            "summary study_island_achievement",
            "summary study_island_achievement_tier_23",
            "summary define_u_participation",
            "summary pssa_participation",
            "summary keystone_participation",
            "summary attendance_rate",
            "summary retention_rate",
            "summary engagement_level",
            "summary score",
            "summary goal_1",
            "summary goal_2",
            "summary goal_3",
            "summary team_member_comments",
            "summary supervisor_comments",
            
            "metrics assessment_performance",                             
            "metrics assessment_performance_attainable",        
            "metrics assessment_participation_fall",                 
            "metrics assessment_participation_fall_attainable",
            "metrics assessment_participation_spring",                 
            "metrics assessment_participation_spring_attainable",  
            "metrics course_passing_rate",                            
            "metrics course_passing_rate_attainable",           
            "metrics study_island_participation",               
            "metrics study_island_participation_attainable",    
            "metrics study_island_achievement",                    
            "metrics study_island_achievement_attainable",      
            "metrics score",                                    
            "metrics team_member_comments",                     
            "metrics supervisor_comments",                      
            
            "instruction source_comprehensive_observation",
            "instruction source_lesson_recordings",        
            "instruction source_unannounced_observation",  
            "instruction score",
            "instruction team_member_comments",
            "instruction supervisor_comments",
           
            "professionalism source_conduct",
            "professionalism source_record_keeping",
            "professionalism source_communication",
            "professionalism source_professional_growth",
            "professionalism score",
            "professionalism team_member_comments",
            "professionalism supervisor_comments",
           
            "aab source_mentoring",
            "aab source_recruitment_team",
            "aab source_committee",
            "aab source_testing",
            "aab source_after_hours",
            "aab source_leading_pd",
            "aab source_program_admin",
            "aab source_local_club",
            "aab source_subsitute_no_pay",
            "aab source_parent_training",
            "aab source_distinguished_aims",
            "aab source_distinguished_define_u",
            "aab source_other",
            "aab team_member_comments",
            "aab supervisor_comments"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_team_member_evaluations_engagement
        
        t_db     = $tables.attach("team").data_base
        d_db     = $tables.attach("department").data_base
        tes_db   = $tables.attach("team_evaluation_summary").data_base
        teem_db  = $tables.attach("team_evaluation_engagement_metrics").data_base
        teeo_db  = $tables.attach("team_evaluation_engagement_observation").data_base
        teep_db  = $tables.attach("team_evaluation_engagement_professionalism").data_base
        teaab_db = $tables.attach("team_evaluation_aab").data_base
        
        sql_str =
        "SELECT
            team.primary_id AS team_id,
            team.legal_first_name,
            team.legal_last_name,
            team.department_id,
            department.name AS 'department_name',
            team.peer_group_id,
            /* SUMMARY */
            team_evaluation_summary.students,
            team_evaluation_summary.all_students,
            team_evaluation_summary.new,
            team_evaluation_summary.in_year,
            team_evaluation_summary.low_income,
            team_evaluation_summary.tier_23,
            team_evaluation_summary.special_ed,
            team_evaluation_summary.grades_712,
            team_evaluation_summary.scantron_participation_fall,
            team_evaluation_summary.scantron_participation_spring,
            team_evaluation_summary.scantron_growth_overall,
            team_evaluation_summary.scantron_growth_math,
            team_evaluation_summary.scantron_growth_reading,
            team_evaluation_summary.aims_participation_fall,
            team_evaluation_summary.aims_participation_spring,
            team_evaluation_summary.aims_growth_overall,
            team_evaluation_summary.study_island_participation,
            team_evaluation_summary.study_island_participation_tier_23,
            team_evaluation_summary.study_island_achievement,
            team_evaluation_summary.study_island_achievement_tier_23,
            team_evaluation_summary.define_u_participation,
            team_evaluation_summary.pssa_participation,
            team_evaluation_summary.keystone_participation,
            team_evaluation_summary.attendance_rate,
            team_evaluation_summary.retention_rate,
            team_evaluation_summary.engagement_level,
            team_evaluation_summary.score,
            team_evaluation_summary.goal_1,
            team_evaluation_summary.goal_2,
            team_evaluation_summary.goal_3,
            team_evaluation_summary.team_member_comments,
            team_evaluation_summary.supervisor_comments,
            /* METRICS */
            team_evaluation_engagement_metrics.scantron_participation_fall,
            team_evaluation_engagement_metrics.scantron_participation_fall_attainable,
            team_evaluation_engagement_metrics.scantron_participation_fall_sd,
            team_evaluation_engagement_metrics.scantron_participation_fall_dfn,
            team_evaluation_engagement_metrics.scantron_participation_spring,
            team_evaluation_engagement_metrics.scantron_participation_spring_attainable,
            team_evaluation_engagement_metrics.scantron_participation_spring_sd,
            team_evaluation_engagement_metrics.scantron_participation_spring_dfn,
            team_evaluation_engagement_metrics.attendance,
            team_evaluation_engagement_metrics.attendance_attainable,
            team_evaluation_engagement_metrics.attendance_sd,
            team_evaluation_engagement_metrics.attendance_dfn,
            team_evaluation_engagement_metrics.truancy_prevention,
            team_evaluation_engagement_metrics.truancy_prevention_attainable,
            team_evaluation_engagement_metrics.truancy_prevention_sd,
            team_evaluation_engagement_metrics.truancy_prevention_dfn,
            team_evaluation_engagement_metrics.keystone_participation,
            team_evaluation_engagement_metrics.keystone_participation_attainable,
            team_evaluation_engagement_metrics.keystone_participation_sd,
            team_evaluation_engagement_metrics.keystone_participation_dfn,
            team_evaluation_engagement_metrics.pssa_participation,
            team_evaluation_engagement_metrics.pssa_participation_attainable,
            team_evaluation_engagement_metrics.pssa_participation_sd,
            team_evaluation_engagement_metrics.pssa_participation_dfn,
            team_evaluation_engagement_metrics.quality_documentation,
            team_evaluation_engagement_metrics.feedback,
            team_evaluation_engagement_metrics.score,
            team_evaluation_engagement_metrics.team_member_comments,
            team_evaluation_engagement_metrics.supervisor_comments,
            /* OBSERVATION */
            team_evaluation_engagement_observation.rapport,
            team_evaluation_engagement_observation.knowledge,
            team_evaluation_engagement_observation.goal,
            team_evaluation_engagement_observation.narrative,
            team_evaluation_engagement_observation.obtaining_commitment,
            team_evaluation_engagement_observation.communication,
            team_evaluation_engagement_observation.documentation_followup,
            team_evaluation_engagement_observation.score,
            team_evaluation_engagement_observation.team_member_comments,
            team_evaluation_engagement_observation.supervisor_comments,
            /* PROFESSIONALISM */
            team_evaluation_engagement_professionalism.source_addresses_concerns,
            team_evaluation_engagement_professionalism.source_collaboration,
            team_evaluation_engagement_professionalism.source_communication,
            team_evaluation_engagement_professionalism.source_execution,
            team_evaluation_engagement_professionalism.source_professional_development,
            team_evaluation_engagement_professionalism.source_meeting_contributions,
            team_evaluation_engagement_professionalism.source_issue_escalation,
            team_evaluation_engagement_professionalism.source_sti,
            team_evaluation_engagement_professionalism.source_meets_deadlines,
            team_evaluation_engagement_professionalism.source_attends_events,
            team_evaluation_engagement_professionalism.score,
            team_evaluation_engagement_professionalism.team_member_comments,
            team_evaluation_engagement_professionalism.supervisor_comments,
            /* ABOVE AND BEYOND */
            team_evaluation_aab.source_mentoring,
            team_evaluation_aab.source_recruitment_team,
            team_evaluation_aab.source_committee,
            team_evaluation_aab.source_testing,
            team_evaluation_aab.source_after_hours,
            team_evaluation_aab.source_leading_pd,
            team_evaluation_aab.source_program_admin,
            team_evaluation_aab.source_local_club,
            team_evaluation_aab.source_subsitute_no_pay,
            team_evaluation_aab.source_parent_training,
            team_evaluation_aab.source_distinguished_aims,
            team_evaluation_aab.source_distinguished_define_u,
            team_evaluation_aab.source_other,
            team_evaluation_aab.team_member_comments,
            team_evaluation_aab.supervisor_comments
            
        FROM #{t_db}.team
        LEFT JOIN #{d_db    }.department                                    ON #{d_db    }.department.primary_id                                = #{t_db}.team.department_id
        LEFT JOIN #{tes_db  }.team_evaluation_summary                       ON #{tes_db  }.team_evaluation_summary.team_id                      = #{t_db}.team.primary_id
        LEFT JOIN #{teem_db }.team_evaluation_engagement_metrics            ON #{teem_db }.team_evaluation_engagement_metrics.team_id           = #{t_db}.team.primary_id
        LEFT JOIN #{teeo_db }.team_evaluation_engagement_observation        ON #{teeo_db }.team_evaluation_engagement_observation.team_id       = #{t_db}.team.primary_id
        LEFT JOIN #{teep_db }.team_evaluation_engagement_professionalism    ON #{teep_db }.team_evaluation_engagement_professionalism.team_id   = #{t_db}.team.primary_id
        LEFT JOIN #{teaab_db}.team_evaluation_aab                           ON #{teaab_db}.team_evaluation_aab.team_id                          = #{t_db}.team.primary_id
        WHERE department_category = 'Engagement'
        GROUP BY team.primary_id"
        
        headers =
        [
            "team_id",
            "legal_first_name",
            "legal_last_name",
            "department_id",
            "department_name",
            "peer_group_id",
            
            "summary students",
            "summary all_students",
            "summary new",
            "summary in_year",
            "summary low_income",
            "summary tier_23",
            "summary special_ed",
            "summary grades_712",
            "summary scantron_participation_fall",
            "summary scantron_participation_spring",
            "summary scantron_growth_overall",
            "summary scantron_growth_math",
            "summary scantron_growth_reading",
            "summary aims_participation_fall",
            "summary aims_participation_spring",
            "summary aims_growth_overall",
            "summary study_island_participation",
            "summary study_island_participation_tier_23",
            "summary study_island_achievement",
            "summary study_island_achievement_tier_23",
            "summary define_u_participation",
            "summary pssa_participation",
            "summary keystone_participation",
            "summary attendance_rate",
            "summary retention_rate",
            "summary engagement_level",
            "summary score",
            "summary goal_1",
            "summary goal_2",
            "summary goal_3",
            "summary team_member_comments",
            "summary supervisor_comments",
            "metrics scantron_participation_fall",
            "metrics scantron_participation_fall_attainable",
            "metrics scantron_participation_fall_sd",
            "metrics scantron_participation_fall_dfn",
            "metrics scantron_participation_spring",
            "metrics scantron_participation_spring_attainable",
            "metrics scantron_participation_spring_sd",
            "metrics scantron_participation_spring_dfn",
            "metrics attendance",
            "metrics attendance_attainable",
            "metrics attendance_sd",
            "metrics attendance_dfn",
            "metrics truancy_prevention",
            "metrics truancy_prevention_attainable",
            "metrics truancy_prevention_sd",
            "metrics truancy_prevention_dfn",
            "metrics evaluation_keystone_participation",
            "metrics evaluation_keystone_participation_attainable",
            "metrics evaluation_keystone_participation_sd",
            "metrics evaluation_keystone_participation_dfn",
            "metrics evaluation_pssa_participation",
            "metrics evaluation_pssa_participation_attainable",
            "metrics evaluation_pssa_participation_sd",
            "metrics evaluation_pssa_participation_dfn",
            "metrics quality_documentation",
            "metrics feedback",
            "metrics score",
            "metrics team_member_comments",
            "metrics supervisor_comments",
            "observation rapport",
            "observation knowledge",
            "observation goal",
            "observation narrative",
            "observation obtaining_commitment",
            "observation communication",
            "observation documentation_followup",
            "observation score",
            "observation team_member_comments",
            "observation supervisor_comments",
            "professionalism source_addresses_concerns",
            "professionalism source_collaboration",
            "professionalism source_communication",
            "professionalism source_execution",
            "professionalism source_professional_development",
            "professionalism source_meeting_contributions",
            "professionalism source_issue_escalation",
            "professionalism source_sti",
            "professionalism source_meets_deadlines",
            "professionalism source_attends_events",
            "professionalism score",
            "professionalism team_member_comments",
            "professionalism supervisor_comments",
            "aab source_mentoring",
            "aab source_recruitment_team",
            "aab source_committee",
            "aab source_testing",
            "aab source_after_hours",
            "aab source_leading_pd",
            "aab source_program_admin",
            "aab source_local_club",
            "aab source_subsitute_no_pay",
            "aab source_parent_training",
            "aab source_distinguished_aims",
            "aab source_distinguished_define_u",
            "aab source_other",
            "aab team_member_comments",
            "aab supervisor_comments"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_team_member_testing_events_attendance(options = nil)
        
        att_db   = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE" ).data_base
        team_db  = $tables.attach("TEAM"                            ).data_base
        event_db = $tables.attach("TEST_EVENT_SITES"                ).data_base
        
        sql_str =
        "SELECT
            team_test_event_site_attendance.team_id,
            team.legal_first_name,
            team.legal_last_name,
            test_event_sites.site_name,
            team_test_event_site_attendance.date,
            team_test_event_site_attendance.status
            
        FROM #{att_db}.team_test_event_site_attendance
        LEFT JOIN #{team_db }.team                  ON team.primary_id = team_test_event_site_attendance.team_id
        LEFT JOIN #{event_db}.test_event_sites      ON test_event_sites.primary_id = test_event_sites.test_site_id"
        
        headers =
        [
           
           "Team ID",
           "First Name",
           "Last Name",
           "Test Event Site",
           "Date",
           "Status"
            
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_transcripts_received(options = nil)
        
        rrr_db = $tables.attach("record_requests_received").data_base
        s_db   = $tables.attach("student").data_base
        
        sql_str =
        "SELECT
            record_requests_received.student_id,
            student.studentfirstname,
            student.studentlastname,
            student.grade,
            record_requests_received.type,
            record_requests_received.school_year,
            record_requests_received.created_by,
            record_requests_received.created_date
        FROM #{rrr_db}.record_requests_received
        LEFT JOIN #{s_db}.student ON #{rrr_db}.record_requests_received.student_id = #{s_db}.student.student_id
        WHERE record_requests_received.type REGEXP 'transcript'
        ORDER BY student_id, school_year"
        
        headers =
        [
            "Student ID",
            "First Name",
            "Last Name",
            "Grade",
            "Type",
            "School Year",
            "Received By",
            "Received Datetime"
        ]
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
    def add_new_csv_attendance_code_stats(options = nil)
        
        results = Array.new
        
        headers =
        [
            "Student ID",
            "Last Name",
            "First Name",
            "Grade",
            "Family ID",
            "Birthday",
            "Family Coach",
            "Enroll Date",
            "Withdraw Date",
            "District of Residence",
            "Enrolled Days",
            "Present Days",
            "Unexcused Days",
            "Excused Days",
        ]
        
        attendance_codes_table = $tables.attach("Attendance_Codes")
        
        pRegex = attendance_codes_table.find_fields("code", "WHERE code_type = 'present'", {:value_only=>true}).join("|")
        uRegex = attendance_codes_table.find_fields("code", "WHERE code_type = 'present'", {:value_only=>true}).join("|")
        eRegex = attendance_codes_table.find_fields("code", "WHERE code_type = 'present'", {:value_only=>true}).join("|")
        
        sql_str = "SELECT student_attendance_master.student_id,
                   student.studentlastname,
                   student.studentfirstname,
                   student.grade,
                   student.familyid,
                   student.birthday,
                   student.primaryteacher,
                   student.schoolenrolldate,
                   student.schoolwithdrawdate,
                   student.districtofresidence,
                   COUNT(official_code),
                   COUNT(case when official_code REGEXP '#{pRegex}' then 1 else NULL end),
                   COUNT(case when official_code REGEXP '#{uRegex}' then 1 else NULL end),
                   COUNT(case when official_code REGEXP '#{eRegex}' then 1 else NULL end),"
        
        codes = attendance_codes_table.find_fields("code", "WHERE code IS NOT NULL ORDER BY code_type DESC", {:value_only=>true})
        
        ac_db = $tables.attach("attendance_codes").data_base
        
        codes.each do |code|
            
            code_type  = $db.get_data_single("SELECT code_type FROM #{ac_db}.attendance_codes WHERE code = '#{code}'").first
            code_regex = attendance_codes_table.find_fields("code", "WHERE code_type = '#{code_type}'", {:value_only=>true}).join("|")
            
            headers.insert(-1, "#{code} -% of Enrolled Days")
            headers.insert(-1, "#{code} -% of #{code_type.capitalize}")
            headers.insert(-1, "#{code} -Count")
            
            sql_str << "COUNT(case when official_code='#{code}' then 1 else NULL end)/COUNT(official_code),
                        COUNT(case when official_code='#{code}' then 1 else NULL end)/COUNT(case when official_code REGEXP '#{code_regex}' then 1 else NULL end),
                        COUNT(case when official_code='#{code}' then 1 else NULL end),"
                        
        end
        
        sql_str.chop!
        
        sam_db = $tables.attach("student_attendance_master").data_base
        sa_db  = $tables.attach("student_attendance").data_base
        s_db   = $tables.attach("student").data_base
        
        sql_str << " FROM #{sam_db}.student_attendance_master
                     LEFT JOIN #{sa_db}.student_attendance
                     ON #{sa_db}.student_attendance.student_id = #{sam_db}.student_attendance_master.student_id
                     LEFT JOIN #{s_db}.student
                     ON #{s_db}.student.student_id = #{sam_db}.student_attendance_master.student_id
                     group by student_attendance_master.student_id"
        
        results = $db.get_data(sql_str)
        
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def official_code_sql(code_type)
        
        code_sql_string = String.new
        
        ac_db = $tables.attach("attendance_codes").data_base
        
        codes = $db.get_data_single(
            "SELECT
                code
            FROM #{ac_db}.attendance_codes
            WHERE code_type = '#{code_type}'"
        )
        
        codes.each{|code|
            code_sql_string << (code_sql_string.empty? ? "official_code = '#{code}'" : " OR official_code = '#{code}'")
        }
        
        return code_sql_string
        
    end
    
    def school_days_dd
        
        addable_days_dd     = Array.new
        
        addable_days = $school.school_days($base.yesterday.iso_date, "DESC") || []
        
        if !addable_days.empty?
            addable_days.each do |day|
                addable_days_dd << {:name=>"#{Date.parse(day).strftime('%m/%d/%Y')}",:value=>day}
            end
            return addable_days_dd
        else
            return false
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "#search_dialog_button{display: none;}"
        output << "table.dataTable td.column_0{text-align: center;}"
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end