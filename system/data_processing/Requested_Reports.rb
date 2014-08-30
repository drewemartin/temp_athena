#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Requested_Reports < Base

    def initialize()
        
    end
    
    def attendance_master(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
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
                FROM #{t_db}.team
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
            
            #PRIMARY TEACHER
            student.primaryteacher,
            #(
            #    SELECT
            #        GROUP_CONCAT(legal_first_name,' ',legal_last_name)
            #    FROM #{t_db}.team
            #    WHERE team.primary_id = (
            #        SELECT
            #            team_id
            #        FROM #{relate_db}.student_relate
            #        WHERE studentid = student.student_id
            #        AND role = 'Primary Teacher'
            #        AND active IS TRUE
            #        LIMIT 0, 1
            #    )
            #),
            
            #FAMILY TEACHER COACH
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        team_id
                    FROM #{relate_db}.student_relate
                    WHERE studentid = student.student_id
                    AND role = 'Family Teacher Coach'
                    AND active IS TRUE
                    LIMIT 0, 1
                )
            ),
            student_scantron_performance_level.stron_ent_perf_m,
            student_scantron_performance_level.stron_ext_perf_m,
            student_scantron_performance_level.stron_ent_perf_r,
            student_scantron_performance_level.stron_ext_perf_r,
            IFNULL(student_leap.leap_level,'0'),
            
            #FAMILY TEACHER COACH SUPPORT
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        supervisor_team_id
                    FROM #{relate_db}.student_relate
                    LEFT JOIN #{t_db}.team
                    ON team.primary_id = student_relate.team_id
                    WHERE studentid = student.student_id
                    AND role = 'Family Teacher Coach'
                    AND student_relate.active IS TRUE
                    LIMIT 0, 1
                )
            ),
            
            #TRUANCY PREVENTION COORDINATOR
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
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
            
            file_name = "#{request_pid}__requested_reports__attendance_master"
            file_path = $reports.csv("temp", file_name, results.insert(0, headers))
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = file_path.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end
    
    def k12_attendance_summary(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
        headers =
        [
            
            "student_id"                ,
            "sum_days_enrolled"         ,
            "sum_days_present"          ,
            "sum_days_excused"          ,
            "sum_days_unexcused"        ,
            "dates_absent"              ,
            "dates_excused"             ,
            "dates_unexcused"           ,
            "rundate"
            
        ]
        
        sa_db   = $tables.attach("STUDENT_ATTENDANCE"       ).data_base
        sam_db  = $tables.attach("STUDENT_ATTENDANCE_MASTER").data_base
        
        sql_str = "
        SELECT 
            
            #{sam_db}.student_attendance_master.student_id,
            
        #ENROLLED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND official_code IS NOT NULL
            ),
            
        #PRESENT DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("present")})
            ),
            
        #EXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("excused")})
            ),
            
        #UNEXCUSED DAYS
            (
                SELECT
                    COUNT(student_id)
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (#{official_code_sql("unexcused")})
            ),
            
        #DATES ABSENT
            (
                SELECT
                    GROUP_CONCAT(DATE_FORMAT(date,'%m/%d/%Y'))
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (
                    #{official_code_sql("excused"   )} OR
                    #{official_code_sql("unexcused" )}
                )
                
            ),
            
        #DATES EXCUSED
            (
                SELECT
                    GROUP_CONCAT(DATE_FORMAT(date,'%m/%d/%Y'))
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (
                    #{official_code_sql("excused"   )}
                )
                
            ),
            
        #DATES UNEXCUSED
            (
                SELECT
                    GROUP_CONCAT(DATE_FORMAT(date,'%m/%d/%Y'))
                FROM #{sa_db}.student_attendance
                WHERE student_id = student_attendance_master.student_id
                AND (
                    #{official_code_sql("unexcused"   )}
                )
                
            ),
            DATE_FORMAT(NOW(),'%m/%d/%Y %H:%i')
        "
        
        sql_str << " FROM #{sam_db}.student_attendance_master"
        
        sql_str << " WHERE student_attendance_master.student_id IN('81353','931068','1424940','548481','1338965')"
        
        results = $db.get_data(sql_str)
        
        if results
            
            file_name   = "#{request_pid}__requested_reports__attendance_summary_k12"
            local_file  = $reports.save_document({:csv_rows=>results.insert(0, headers), :category_name=>"Attendance", :type_name=>"K12 Attendance Summary"})
            remote_file = "k12_agora_attendance_summary_#{DateTime.now.strftime("%m%d%Y")}.csv"
            
            $reports.move_to_k12(local_file, remote_file)
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = local_file.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end

    def student_contacts_complete(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
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
            student_contacts.small_group_session,
            student_contacts.iep_meeting,
            student_contacts.conference,
            student_contacts.fc_conference,
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
            "Small Group Session",
            "IEP Meeting",
            "Conference",
            "Family Coach Conference",
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
            
            file_name = "#{request_pid}__requested_reports__student_contacts_complete"
            file_path = $reports.csv("temp", file_name, results.insert(0, headers))
            
            transfer_to_athena_temp(file_path, file_name) 
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = file_path.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end
    
    def student_testing_events_attendance(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
        std_db  = $tables.attach("student_test_dates").data_base
        tes_db  = $tables.attach("test_event_sites").data_base
        s_db    = $tables.attach("student").data_base
        tess_db = $tables.attach("test_event_site_staff").data_base
        t_db    = $tables.attach("team").data_base
        
        sql_str =
        "SELECT
            student_test_dates.student_id,
            studentlastname,
            studentfirstname,
            site_name,
            date,
            attendance_code,
            (
                SELECT
                    GROUP_CONCAT(legal_first_name,' ',legal_last_name)
                FROM #{t_db}.team
                WHERE team.primary_id = (
                    SELECT
                        test_event_site_staff.team_id
                    FROM #{tess_db}.test_event_site_staff
                    WHERE test_event_site_staff.test_event_site_id = test_event_sites.primary_id
                    AND role = 'Site Coordinator'
                    AND not_attending IS NOT TRUE
                    LIMIT 0, 1
                )
            )
        FROM #{std_db}.student_test_dates
        LEFT JOIN #{tes_db}.test_event_sites ON #{std_db}.student_test_dates.test_event_site_id = #{tes_db}.test_event_sites.primary_id
        LEFT JOIN #{s_db}.student ON #{s_db}.student.student_id = #{std_db}.student_test_dates.student_id
        LEFT JOIN #{tess_db}.test_event_site_staff ON #{tess_db}.test_event_site_staff.test_event_site_id = #{tes_db}.test_event_sites.primary_id"
        
        headers =
        [
           
           "student_id",
           "studentlastname",
           "studentfirstname",
           "site_name",
           "date",
           "attendance_code",
           "Site Coordinator"
            
        ]
        
        results = $db.get_data(sql_str)
        
        if results
            
            file_name = "#{request_pid}__requested_reports__student_testing_events_attendance"
            file_path = $reports.csv("temp", file_name, results.insert(0, headers))
            
            transfer_to_athena_temp(file_path, file_name) 
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = file_path.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end
    
    def unverified_previous_school(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
        eitr_db  = $tables.attach("K12_ENROLLMENT_INFO_TAB_V2").data_base
        sps_db   = $tables.attach("STUDENT_PREVIOUS_SCHOOL").data_base
        s_db     = $tables.attach("STUDENT").data_base
        
        sql_str =
        "SELECT
            k12_enrollment_info_tab_v2.student_id,
            student.studentfirstname,
            student.studentlastname,
            student.grade,
            student_previous_school.previous_school,
            student_previous_school.previous_district,
            student_previous_school.previous_school_state
        FROM #{eitr_db}.k12_enrollment_info_tab_v2
        LEFT JOIN #{sps_db}.student_previous_school
        ON student_previous_school.student_id = k12_enrollment_info_tab_v2.student_id
        LEFT JOIN #{s_db}.student
        ON student.student_id = k12_enrollment_info_tab_v2.student_id
        WHERE student_previous_school.verified IS FALSE
        AND student.grade != 'Kindergarten'"
        
        headers =
        [
           
            "Student ID",
            "First Name",
            "Last Name",
            "Grade",
            "Previous School",
            "Previous District",
            "Previous School State"
            
        ]
        
        results = $db.get_data(sql_str)
        
        if results
            
            file_name = "#{request_pid}__requested_reports__unverified_previous_school"
            file_path = $reports.csv("temp", file_name, results.insert(0, headers))
            
            transfer_to_athena_temp(file_path, file_name) 
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = file_path.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end
    
    def k12_student_welcome_activites_report(request_pid)
        
        record = $tables.attach("TEAM_REQUESTED_REPORTS").by_primary_id(request_pid)
        
        record.fields["status"].value = "Generating"
        
        record.save
        
        headers =
        [
            
            "Student ID",
            "Date of Contact",
            "Note",
            "Successful",
            "Contact Type",
            "Created Date",
            "Created By"
            
        ]
        
        sc_db   = $tables.attach("STUDENT_CONTACTS").data_base
        
        sql_str = "
        SELECT 
            
            student_id,
            datetime,
            notes,
            IFNULL(successful,0),
            contact_type,
            created_date,
            created_by
            
        FROM #{sc_db}.student_contacts
        
        WHERE notes REGEXP 'Student Welcome Activities'
        AND welcome_call = '1'
        "
        
        results = $db.get_data(sql_str)
        
        if results
            
            file_name   = "student_welcome_activites_report_k12"
            file_path  = $reports.save_document({:csv_rows=>results.insert(0, headers), :category_name=>"Athena", :type_name=>"Student Welcome Activities Report"})
            
            $base.email.athena_smtp_email(
                ["amymoore@k12.com","nhofmann@k12.com","kayoung@k12.com"],
                "Agora Student Welcome Activities Notes Bi-Weekly Report",
                "Please find the attached report",
                file_path,
                nil,
                "#{file_name}_#{$ifilestamp}.csv"
            )
            
            
            record.fields["status"].value    = "Ready"
            record.fields["file_name"].value = file_path.split("/").last
            
            record.save
            
            return true
            
        else
            
            record.fields["status"].value    = "Failed"
            
            record.save
            
            return false
            
        end
        
    end
    
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
        } if codes
        
        return codes ? code_sql_string : "official_code IS FALSE"
        
    end
    
    def transfer_to_athena_temp(file_path, file_name)
        
        begin
            
            out_file_path = "M:/#{file_name}.csv"
            
            if !File.directory?( "M:/" )
                require 'win32ole'
                net = WIN32OLE.new('WScript.Network')
                user_name = "Athena"
                password  = "YEree77d3ysPQhYE"
                net.MapNetworkDrive( 'M:', "\\\\10.1.10.254\\temp", nil,  user_name, password )
            end
            
            FileUtils.cp(file_path, out_file_path)
            
        rescue=>e
            
            $base.system_notification(
                subject = "Intact - all_students.csv Transfer Failed!",
                content = "Do something about it. Here's the error:
                #{e.message}"
            )
            
        end    
        
    end
  
end