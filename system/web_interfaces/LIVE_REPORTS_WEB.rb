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
        
        #ATTENDANCE MASTER
        tables_array.push([
            $tools.button_new_csv("attendance_master", additional_params_str = nil),
            "Attendance Master",
            "This report includes all students who have had any attendance records created this school year."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_attendance_ap.is_true?
        
        #Ink Orders
        tables_array.push([
            $tools.button_new_csv("ink_orders", additional_params_str = nil),
            "Ink Orders",
            "This report includes all ink orders entered into Athena."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_ink_orders.is_true?
        
        #TRACKER REPORT
        tables_array.push([
            $tools.button_new_csv("student_contacts", additional_params_str = "complete"),
            "Student Contacts - Complete",
            "This report includes all contact records that exist. Only students with contacts will be included."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_contacts.is_true?
        
        #RTII BEHAVIOR REPORT
        tables_array.push([
            $tools.button_new_csv("student_rtii_behavior", additional_params_str = nil),
            "Student RTII Behavior",
            "This report includes all RTII Behavior records that exist. Only students with contacts will be included."
        ]) if $team_member.super_user? || $team_member.rights.live_reports_student_rtii_behavior.is_true?
        
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
        FROM student_attendance_ap
        LEFT JOIN student
            ON student_attendance_ap.student_id = student.student_id
        LEFT JOIN team_sams_ids
            ON student_attendance_ap.staff_id = team_sams_ids.sams_id
        LEFT JOIN team
            ON team_sams_ids.team_id = team.primary_id
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
        
        sql_str =
        "SELECT
            athena_project.primary_id,               
            athena_project.project_name,                       
            athena_project.brief_description,
            athena_project.requested_priority_level,
            athena_project.requested_completion_date,
            athena_project.status,    
            athena_project.development_phase,
            (SELECT system_name FROM athena_project_systems WHERE athena_project_systems.primary_id = athena_project.system_id),
            athena_project.priority_level,           
            athena_project.estimated_completion_date,
            (SELECT CONCAT(legal_first_name,' ',legal_last_name) FROM team WHERE team.primary_id = athena_project.requester_team_id),
            athena_project.created_date
            
        FROM athena_project
        "
        
        headers = [
            "Project ID"        ,
            "Project Name"      ,
            "Description"       ,
            "Requested Priority",
            "Requested ETA"     ,
            "Status"            ,
            "Development Phase" ,
            "System"            ,
            "Priority Level"    ,
            "ETA"               ,
            "Requestor"         ,
            "Date Submitted"
            
        ]
        
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
            
            "Family Coach",
            
            "Teacher",
            "Scantron entrance math",
            "Scantron exit math",
            "Scantron entrance reading",
            "Scantron exit reading",
            
            #"Program Support",
            
            "Region",
            
            "Family Coach Program Support",
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
            "Unexcused"
            
        ]
        
        date_headers = $tables.attach("STUDENT_ATTENDANCE_MASTER").field_order
        date_headers.delete("primary_id")
        date_headers.delete("student_id")
        date_headers.delete("created_date")
        date_headers.delete("created_by")
        
        headers.concat(date_headers)
        
        sql_str = String.new
        sql_str << "
        SELECT 
            
            student.student_id,
            student.studentlastname,
            student.studentfirstname,
            student.grade,
            student.familyid,
            student.birthday,
            (SELECT CONCAT(legal_first_name,' ',legal_last_name) FROM team WHERE team.primary_id = ( SELECT team_id FROM team_sams_ids WHERE team_sams_ids.sams_id = student.primaryteacherid ) ),
            
            student.title1teacher,
            student_scantron_performance_level.stron_ent_perf_m,
            student_scantron_performance_level.stron_ext_perf_m,
            student_scantron_performance_level.stron_ent_perf_r,
            student_scantron_performance_level.stron_ext_perf_r,
            
            student.region,
            
            (SELECT CONCAT(team.legal_first_name,' ',team.legal_last_name) FROM team WHERE team.primary_id = (SELECT supervisor_team_id FROM team_sams_ids WHERE team_sams_ids.sams_id = student.primaryteacherid ) ),
            (SELECT  GROUP_CONCAT(CONCAT(team.legal_first_name,' ',team.legal_last_name)) FROM team WHERE department_id = (SELECT primary_id FROM department WHERE name = 'Truancy Prevention') AND region = student.region ),
            (SELECT  GROUP_CONCAT(CONCAT(team.legal_first_name,' ',team.legal_last_name)) FROM team WHERE department_id = (SELECT primary_id FROM department WHERE name = 'Advisors') AND region = student.region ),
            
            student.schoolenrolldate,
            student.schoolwithdrawdate,
            student.specialedteacher,
            student_attendance_mode.attendance_mode,
            student.districtofresidence,"
      
        sql_str << "#ENROLLED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND official_code IS NOT NULL
            ),"
        
        sql_str << "#PRESENT DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("present")})
            ),"
        
        sql_str << "#EXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("excused")})
            ),"
        
        sql_str << "#UNEXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("unexcused")})
            ),"
        
        sql_str << "student_attendance_master.*"
       
        sql_str << " FROM student_attendance_master
            LEFT JOIN student                             ON student.student_id                             = student_attendance_master.student_id                       
            LEFT JOIN student_scantron_performance_level  ON student_scantron_performance_level.student_id  = student_attendance_master.student_id
            LEFT JOIN student_attendance_mode             ON student_attendance_mode.student_id             = student_attendance_master.student_id"
        
        results = $db.get_data(sql_str)
        if results
            return results.insert(0, headers)
            
        else
            return false
            
        end
        
    end

    def add_new_csv_ink_orders(options = nil)
        
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
        FROM ink_orders
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

    def add_new_csv_student_contacts(options = nil)
        
        sql_str =
        "SELECT
            student_id,
            datetime,
            successful,
            notes,
            contact_type,
            tep_initial,
            tep_followup,
            attendance,
            rtii_behavior_id,
            test_site_selection,
            scantron_performance,
            study_island_assessments,
            course_progress,
            work_submission,
            grades,
            communications,
            retention_risk,
            escalation,
            welcome_call,
            initial_home_visit,
            tech_issue,
            low_engagement,
            ilp_conference,
            other,
            other_description,
            created_by,
            created_date
        FROM student_contacts"
        
        headers =
        [
            "student_id",
            "datetime",
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
            "other",
            "other_description",
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
    
    def add_new_csv_student_rtii_behavior(options = nil)
        
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
        FROM student_rtii_behavior
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
            (SELECT created_date FROM scantron_performance_extended WHERE primary_id =1) AS 'Last Updated'
        FROM `student`
        LEFT JOIN student_scantron_performance_level ON student_scantron_performance_level.student_id = student.student_id
        LEFT JOIN k12_omnibus ON k12_omnibus.student_id = student.student_id
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
            "last updated"
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
            "Notes 2"
        ]
        
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
            student_tests.pick_up
            
        FROM `student_tests`
        LEFT JOIN student           ON student_tests.student_id         = student.student_id
        LEFT JOIN tests             ON student_tests.test_id            = tests.primary_id
        LEFT JOIN test_events       ON student_tests.test_event_id      = test_events.primary_id
        LEFT JOIN test_subjects     ON student_tests.test_subject_id    = test_subjects.primary_id
        LEFT JOIN test_event_sites  ON student_tests.test_event_site_id = test_event_sites.primary_id
        LEFT JOIN team_sams_ids     ON student_tests.test_administrator = team_sams_ids.sams_id
        LEFT JOIN team              ON team_sams_ids.team_id            = team.primary_id"
        
        results = $db.get_data(sql_str)
        if results
            
            return results.insert(0, headers)
            
        else
            
            return [headers]
            
        end
        
    end
    
    def add_new_csv_student_testing_events_attendance(options = nil)
        
        sql_str =
        "SELECT
            student_test_dates.student_id,
            studentlastname,
            studentfirstname,
            site_name,
            date,
            attendance_code
        FROM student_test_dates
        LEFT JOIN test_event_sites ON test_event_site_id = test_event_sites.primary_id
        LEFT JOIN student ON student.student_id = student_test_dates.student_id"
        
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
        FROM `team`
        LEFT JOIN department                                ON department.primary_id                            = team.department_id
        LEFT JOIN team_evaluation_summary                   ON team_evaluation_summary.team_id                  = team.primary_id
        LEFT JOIN team_evaluation_academic_metrics          ON team_evaluation_academic_metrics.team_id         = team.primary_id
        LEFT JOIN team_evaluation_academic_instruction      ON team_evaluation_academic_instruction.team_id     = team.primary_id
        LEFT JOIN team_evaluation_academic_professionalism  ON team_evaluation_academic_professionalism.team_id = team.primary_id
        LEFT JOIN team_evaluation_aab                       ON team_evaluation_aab.team_id                      = team.primary_id
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
        FROM `team`
        LEFT JOIN department                                    ON department.primary_id                                = team.department_id
        LEFT JOIN team_evaluation_summary                       ON team_evaluation_summary.team_id                      = team.primary_id
        LEFT JOIN team_evaluation_engagement_metrics            ON team_evaluation_engagement_metrics.team_id           = team.primary_id
        LEFT JOIN team_evaluation_engagement_observation        ON team_evaluation_engagement_observation.team_id       = team.primary_id
        LEFT JOIN team_evaluation_engagement_professionalism    ON team_evaluation_engagement_professionalism.team_id   = team.primary_id
        LEFT JOIN team_evaluation_aab                           ON team_evaluation_aab.team_id                          = team.primary_id
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
    
    def add_new_csv_transcripts_received(options = nil)
        
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
        FROM record_requests_received
        LEFT JOIN student ON record_requests_received.student_id = student.student_id
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
        
        pRegex = attendance_codes_table.code_array("WHERE code_type = 'present'"  ).join("|")
        uRegex = attendance_codes_table.code_array("WHERE code_type = 'unexcused'").join("|")
        eRegex = attendance_codes_table.code_array("WHERE code_type = 'excused'"  ).join("|")
        
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
        
        codes = attendance_codes_table.code_array("WHERE code IS NOT NULL ORDER BY code_type DESC")
        
        codes.each do |code|
            
            code_type  = $db.get_data_single("SELECT code_type FROM attendance_codes WHERE code = '#{code}'").first
            code_regex = attendance_codes_table.code_array("WHERE code_type = '#{code_type}'").join("|")
            
            headers.insert(-1, "#{code} -% of Enrolled Days")
            headers.insert(-1, "#{code} -% of #{code_type.capitalize}")
            headers.insert(-1, "#{code} -Count")
            
            sql_str << "COUNT(case when official_code='#{code}' then 1 else NULL end)/COUNT(official_code),
                        COUNT(case when official_code='#{code}' then 1 else NULL end)/COUNT(case when official_code REGEXP '#{code_regex}' then 1 else NULL end),
                        COUNT(case when official_code='#{code}' then 1 else NULL end),"
                        
        end
        
        sql_str.chop!
        
        sql_str << " FROM `student_attendance_master`
                     LEFT JOIN student_attendance
                     ON student_attendance.student_id = student_attendance_master.student_id
                     LEFT JOIN student
                     ON student.student_id = student_attendance_master.student_id
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
        
        codes = $db.get_data_single(
            "SELECT
                code
            FROM attendance_codes
            WHERE code_type = '#{code_type}'"
        )
        
        codes.each{|code|
            code_sql_string << (code_sql_string.empty? ? "official_code = '#{code}'" : " OR official_code = '#{code}'")
        }
        
        return code_sql_string
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "#search_dialog_button{display: none;}"
        output << "table.dataTable td.sorting_1{text-align: center;}"
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