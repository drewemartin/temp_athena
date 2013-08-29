#!/usr/local/bin/ruby

################################################################################
#Created By: Jenifer Halverson
################################################################################
class Student
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #---------------------------------------------------------------------------
    def initialize(student_id = nil)
        @structure = nil
        self.student_id = student_id
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def active
        $tables.attach("STUDENT").field_bystudentid("active", studentid)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def academic_progress
        if !structure.has_key?("academic_progress")
            header   = ["SUBJECT","PERCENTAGE"]
            progress = [header]
            
            if grade.match(/K|1st|2nd|3rd|4th|5th|6th/)
                #Check CALMS
                results = $tables.attach("K12_Calms_Aggregate_Progress").by_studentid_old(studentid)
                if results
                    results.each{|result|
                        fields = result.fields
                        if percentage  = fields["percent_progress"].value
                            subject     = fields["coursename"].value
                            percentage  = fields["percent_progress"].to_user
                            progress.push([ subject, percentage ])
                        end  
                    }
                end
            end
            
            if grade.match(/K|1st|2nd|3rd|4th|5th|6th/)
                #Check OLS
                results = $tables.attach("K12_Aggregate_Progress").by_studentid_old(studentid)
                if results
                    result = results[0]
                    fields = result.fields
                    fields.each_pair{|field,details|
                        if field.match(/progress_percent/) && details.value && details.value.to_f > 0
                            subject     = field.gsub("_progress_percent","").upcase
                            percentage  = details.to_user
                            progress.push([ subject, percentage ])
                        end
                    }
                end
            end
            
            #Check Jupiter
            records = $tables.attach("Jupiter_Grades").by_studentid_old(studentid)
            if records
                records.each{|record|
                    fields = record.fields
                    unless fields["subject"].match(/Algebra 1|Geom|LAC/) || !fields["percent"].value
                        progress.push([ fields["subject"].value, fields["percent"].to_user ])
                    end
                }   
            end
            #Check LMS
            records = $tables.attach("K12_Ecollege_Detail").by_studentid_old(studentid)
            if records
                records.each{|record|
                    fields      = record.fields
                    if fields["course_average_to_date"].value
                        subject     = fields["ecollege_course_name"].value
                        percentage  = fields["course_average_to_date"].to_user
                        progress.push([ subject, percentage ])
                    end
                }   
            end
            structure["academic_progress"] = progress
        end
        structure["academic_progress"]
    end
    
    def academic_progress_q1
    end
    
    def active?
        if !structure.has_key?("active")
            if $db.get_data_single("SELECT primary_id FROM k12_omnibus WHERE student_id = '#{studentid}'")
                structure["active"] = true
            else
                structure["active"] = false
            end
        end
        structure["active"]
    end
    
    def annual_assessment_growth_math
        $tables.attach("ANNUAL_ASSESSMENT_GROWTH").field_bystudentid("math", studentid)
    end
    
    def annual_assessment_growth_reading
        $tables.attach("ANNUAL_ASSESSMENT_GROWTH").field_bystudentid("reading", studentid)
    end
    
    def ayp_student?
        if !structure.has_key?("ayp_student")
            if grade.match(/3rd|4th|5th|6th|7th|8th|11th/)
                if school_enroll_date.mathable <= $tables.attach("School_Year_Detail").current.fields["ayp_cutoff_date"].mathable
                    structure["ayp_student"] = true
                else
                    structure["ayp_student"] = false
                end
            else
                structure["ayp_student"] = false
            end
        end
        structure["ayp_student"]
    end
    
    def cohort_year
        if active? && grade.match(/9|10|11|12/) && !structure.has_key?("cohort_year")
            results = $tables.attach("Student").field_bystudentid("cohort_year", studentid)
            structure["cohort_year"] = results
            structure["cohort_year"]
        else
            return false
        end   
    end
    
    def credits_earned
        if !structure.has_key?("credits_earned")
            results = $tables.attach("K12_Transcripts").field_bystudentid("total_credits", studentid)
            structure["credits_earned"] = results if results
        end
        structure["credits_earned"]
    end
    
    def credits_earned_unneeded
        if !structure.has_key?("credits_earned")
            results = $tables.attach("K12_Transcripts").field_bystudentid("earned_but_not_needed_credits", studentid)
            structure["credits_earned"] = results if results
        end
        structure["credits_earned"]
    end
    
    def credits_needed
        if !structure.has_key?("credits_needed")
            results = $tables.attach("K12_Transcripts").field_bystudentid("credits_needed_to_graduate", studentid)
            structure["credits_needed"] = results if results
        end
        structure["credits_needed"]
    end
    
    def districtofresidence(pid=nil)
        return $tables.attach("student").field_bystudentid("districtofresidence", studentid)
    end
    
    def dnc_record
        return $tables.attach("Dnc_Students").by_studentid_old(student_id)
    end
    
    def dora_exam_date_fall
        $tables.attach("DORA_DOMA_PARTICIPATION_FALL").field_bystudentid("dora_test_date", studentid)
    end
    
    def doma_exam_date_fall
        $tables.attach("DORA_DOMA_PARTICIPATION_FALL").field_bystudentid("doma_test_date", studentid)
    end
    
    def dora_exam_date_spring
        $tables.attach("DORA_DOMA_PARTICIPATION_SPRING").field_bystudentid("dora_test_date", studentid)
    end
    
    def doma_exam_date_spring
        $tables.attach("DORA_DOMA_PARTICIPATION_SPRING").field_bystudentid("doma_test_date", studentid)
    end
    
    def dora_doma_participated_fall?
        doma_participated_fall? || dora_participated_fall?
    end
    
    def dora_doma_participated_spring?
        doma_participated_spring? || dora_participated_spring?
    end
    
    def dora_doma_participated_math?
        doma_participated_spring? || doma_participated_fall?
    end
    
    def dora_doma_participated_reading?
        dora_participated_spring? || dora_participated_fall?
    end
    
    def doma_participated_fall?
        (doma_exam_date_fall && !doma_exam_date_fall.value.nil?)
    end
    
    def doma_participated_spring?
        (doma_exam_date_spring && !doma_exam_date_spring.value.nil?)
    end
    
    def dora_participated_fall?
        (dora_exam_date_fall && !dora_exam_date_fall.value.nil?)
    end
    
    def dora_participated_spring?
        (dora_exam_date_spring && !dora_exam_date_spring.value.nil?)
    end
    
    def ell_status
        if !structure.has_key?("ell_status")
            results = $tables.attach("Student").field_bystudentid("haseslprogram", studentid)
            structure["ell_status"] = results if results
        end
        structure["ell_status"]
    end
    
    def emergency_contacts #returns Array of Rows
        $tables.attach("Student_Emergency_Contacts").by_studentid_old(studentid)
    end
    
    def engagement_level
        $tables.attach("K12_PAL_ASSESSMENT").field_bystudentid("engagm_level", studentid)
    end
    
    def family_id
        if !structure.has_key?("family_id")
            results = $tables.attach("Student").field_bystudentid("familyid", studentid)
            structure["family_id"] = results if results
        end
        structure["family_id"]
    end
    
    def freeandreducedmeals
        if !structure.has_key?("freeandreducedmeals")
            results = $tables.attach("Student").field_bystudentid("freeandreducedmeals", studentid)
            status = false
            if results
                status = results.value
                if status.match(/Free & Reduced Lunch Eligible|Free Lunch Eligible|Reduced Lunch Eligible/)
                    status = true
                elsif status.match(/Not Eligible|Unknown Eligibility/)
                    status = false
                end
                structure["freeandreducedmeals"] = status
            end
        end
        structure["freeandreducedmeals"]
    end
    
    def lc_first_name
        if !structure.has_key?("lc_first_name")
            results = $tables.attach("Student").field_bystudentid("lcfirstname", studentid)
            structure["lc_first_name"] = results if results
        end
        structure["lc_first_name"]
    end
    
    def lc_last_name
        if !structure.has_key?("lc_last_name")
            results = $tables.attach("Student").field_bystudentid("lclastname", studentid)
            structure["lc_last_name"] = results if results
        end
        structure["lc_last_name"]
    end
    
    def lc_registration_id
        if !structure.has_key?("lc_registration_id")
            results = $tables.attach("Student").field_bystudentid("lcregistrationid", studentid)
            structure["lc_registration_id"] = results if results
        end
        structure["lc_registration_id"]
    end
    
    def lc_relationship
        if !structure.has_key?("lc_relationship")
            results = $tables.attach("Student").field_bystudentid("lcrelationship", studentid)
            structure["lc_relationship"] = results if results
        end
        structure["lc_relationship"]
    end
    
    def lg_first_name
        if !structure.has_key?("lg_first_name")
            results = $tables.attach("Student").field_bystudentid("lgfirstname", studentid)
            structure["lg_first_name"] = results if results
        end
        structure["lg_first_name"]
    end
    
    def lg_last_name
        if !structure.has_key?("lg_last_name")
            results = $tables.attach("Student").field_bystudentid("lglastname", studentid)
            structure["lg_last_name"] = results if results
        end
        structure["lg_last_name"]
    end
    
    def lg_relationship
        if !structure.has_key?("lg_relationship")
            results = $tables.attach("Student").field_bystudentid("lgrelationship", studentid)
            structure["lg_relationship"] = results if results
        end
        structure["lg_relationship"]
    end
    
    def mailing_address
        if !structure.has_key?("mailing_address")
            results = $tables.attach("Student").field_bystudentid("mailingaddress1", studentid)
            structure["mailing_address"] = results if results
        end
        structure["mailing_address"]
    end
    
    def mailing_address_line_two
        if !structure.has_key?("mailingaddress2")
            results = $tables.attach("Student").field_bystudentid("mailingaddress2", studentid)
            structure["mailingaddress2"] = results if results
        end
        structure["mailingaddress2"]
    end
    
    def mailing_city
        if !structure.has_key?("mailingcity")
            results = $tables.attach("Student").field_bystudentid("mailingcity", studentid)
            structure["mailingcity"] = results if results
        end
        structure["mailingcity"]
    end
    
    def mailing_state
        if !structure.has_key?("mailingstate")
            results = $tables.attach("Student").field_bystudentid("mailingstate", studentid)
            structure["mailingstate"] = results if results
        end
        structure["mailingstate"]
    end
    
    def mailing_zip
        if !structure.has_key?("mailingzip")
            results = $tables.attach("Student").field_bystudentid("mailingzip", studentid)
            structure["mailingzip"] = results if results
        end
        structure["mailingzip"]
    end
    
    def monthly_assessment_growth_overall_math
        $tables.attach("MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY").field_bystudentid("avg_math", studentid)
    end
    
    def monthly_assessment_growth_overall_reading
        $tables.attach("MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY").field_bystudentid("avg_reading", studentid)
    end
    
    def monthly_assessment_participation_avg
        $tables.attach("MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY").field_bystudentid("avg_total", studentid)
    end
    
    def monthly_assessment_participation_avg_math
        $tables.attach("MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY").field_bystudentid("avg_math", studentid)
    end
    
    def monthly_assessment_participation_avg_reading
        $tables.attach("MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY").field_bystudentid("avg_reading", studentid)
    end
    
    def monthly_assessment_participated?
        x = monthly_assessment_participation_avg
        return (x && !x.value.nil? && x.mathable > 0.0) ? true : false
    end
    
    def monthly_assessment_participated_math?
        x = monthly_assessment_participation_avg_math
        return (x && !x.value.nil? && x.mathable > 0.0) ? true : false
    end
    
    def monthly_assessment_participated_reading?
        x = monthly_assessment_participation_avg_reading
        return (x && !x.value.nil? && x.mathable > 0.0) ? true : false
    end
    
    def passing_records(term)
        $tables.attach("STUDENT_PASSING").by_studentid_old(studentid, term)
    end
    
    def age
        if !structure.has_key?("age")
            structure["age"] = $db.get_data_single("SELECT (YEAR(CURDATE())-YEAR(birthday)) - (RIGHT(CURDATE(),5)<RIGHT(birthday,5)) FROM Student WHERE Student.student_id = '#{student_id}'")[0]
        end
        structure["age"]
    end
    
    def attendance_rate
        if !structure.has_key?("attendance_rate")
            structure["attendance_rate"] = attendance.exists? ? attendance.rate : nil
        end
        structure["attendance_rate"]
    end
    
    def birthday
        $tables.attach("Student").field_bystudentid("birthday", studentid)
    end
    
    def emergency_contacts
        return $tables.attach("Student_Emergency_Contacts").by_studentid_old(student_id)
    end  
    
    def emergency_contacts_by_pid(pid)
        return $tables.attach("Student_Emergency_Contacts").by_primary_id(pid)
    end
    
    def exists?
        if !structure.has_key?("exists")
            results = $tables.attach("Student").field_bystudentid("primary_id", studentid)
            structure["exists"] = results ? true : false
        end
        structure["exists"]
    end
    
    def family_teacher_coach
        if !structure.has_key?("family_teacher_coach")
            results = $tables.attach("Student").field_bystudentid("primaryteacher", studentid)
            structure["family_teacher_coach"] = results if results
        end
        return structure["family_teacher_coach"].value if output_type == "value"
        structure["family_teacher_coach"]
    end
    
    def first_name
        if !structure.has_key?("studentfirstname")
            results = $tables.attach("Student").field_bystudentid("studentfirstname", studentid)
            structure["studentfirstname"] = results if results
        end
        return structure["studentfirstname"].value if output_type == "value"
        structure["studentfirstname"]
    end
    
    def fullname
        if !structure.has_key?("fullname") && first_name && last_name
            structure["fullname"] = $field.new({"type" => "text", "field" => "search_field", "value"=>"#{last_name.value}, #{first_name.value}"})
        end
        structure["fullname"]
    end
    
    def gender
        if !structure.has_key?("studentgender")
            results = $tables.attach("Student").field_bystudentid("studentgender", studentid)
            structure["studentgender"] = results if results
        end
        return structure["studentgender"].value if output_type == "value"
        structure["studentgender"]
    end
    
    def grade
        $tables.attach("Student").find_field("grade", "WHERE student_id = '#{student_id}'")
    end
    
    def has_504?
        if !structure.has_key?("has_504")
            results = $tables.attach("Student").field_bystudentid("sped504plan", studentid)
            structure["has_504"] = results.value ? true : false
        end
        structure["has_504"]
    end
    
    def has_iep?
        if !structure.has_key?("has_iep")
            results = $tables.attach("Student").field_bystudentid("hasiep", studentid)
            structure["has_iep"] = results.value ? true : false
        end
        structure["has_iep"]
    end
    
    def has_pssa_record?
        if !structure.has_key?("has_pssa_record")
            results = $tables.attach("Pssa").field_bystudentid("primary_id", studentid)
            structure["has_pssa_record"] = results ? true : false
        end
        structure["has_pssa_record"]
    end
    
    def has_rtii_record?
        if !structure.has_key?("has_rtii_record")
            results = $tables.attach("Rtii_Tier_Levels").field_bystudentid("primary_id", studentid)
            structure["has_rtii_record"] = results ? true : false
        end
        structure["has_rtii_record"]
    end
    
    def has_specialed_teacher?
        if !structure.has_key?("has_specialed_teacher")
            results = $tables.attach("Student").field_bystudentid("specialedteacher", studentid)
            if results && results.value
                structure["has_specialed_teacher"] = true
            else
                structure["has_specialed_teacher"] = false
            end
        end
        structure["has_specialed_teacher"]
    end
    alias :is_specialed :has_specialed_teacher?
    
    def ink_records
        return $tables.attach("Ink_Orders").by_studentid_old(student_id)
    end
    
    def ink_check
        return $tables.attach("Ink_Orders").ink_check(student_id)
    end
    
    def lc_student?
        if !structure.has_key?("lc_student")
            results = $tables.attach("Learning_Center_Students").current_students(studentid)
            structure["lc_student"] = results ? true : false
        end
        structure["lc_student"]
    end
    
    def last_name
        if !structure.has_key?("studentlastname")
            results = $tables.attach("Student").field_bystudentid("studentlastname", studentid)
            structure["studentlastname"] = results if results
        end
        return structure["studentlastname"].value if output_type == "value"
        structure["studentlastname"]
    end
    
    def middle_name
        if !structure.has_key?("studentmiddlename")
            results = $tables.attach("Student").field_bystudentid("studentmiddlename", studentid)
            structure["studentmiddlename"] = results if results
        end
        return structure["studentmiddlename"].value if output_type == "value"
        structure["studentmiddlename"]
    end
    
    def output_type
        structure["output_type"]
    end
    
    def phone_number
        if !structure.has_key?("phone_number")
            results = $tables.attach("Student").field_bystudentid("studenthomephone", studentid)
            structure["phone_number"] = results if results
        end
        structure["phone_number"]
    end
    
    def ppid
        if !structure.has_key?("ppid")
            results = $tables.attach("Student").field_bystudentid("ssid", studentid)
            structure["ppid"] = results if results
        end
        structure["ppid"]
    end
    
    def pssa_records
        return $tables.attach("Pssa").by_studentid_desc(student_id)
    end
    
    def primary_teacher
        if !structure.has_key?("primary_teacher")
            results = $tables.attach("Student").field_bystudentid("primaryteacher", studentid)
            structure["primary_teacher"] = results if results
        end
        return structure["primary_teacher"].value if output_type == "value"
        structure["primary_teacher"]
    end
    
    def pssa_performance_level_math
        if has_pssa_record? && !structure.has_key?("pssa_performance_level_math")
            results = $tables.attach("Pssa").field_bystudentid("math_perf_level", studentid)
            structure["pssa_performance_level_math"] = results
        end
        structure["pssa_performance_level_math"]
    end
    
    def pssa_grade_tested
        if has_pssa_record? && !structure.has_key?("pssa_grade_tested")
            results = $tables.attach("Pssa").field_bystudentid("grade_when_tested", studentid)
            structure["pssa_grade_tested"] = results
        end
        structure["pssa_grade_tested"]
    end
    
    def pssa_performance_level_reading
        if has_pssa_record? && !structure.has_key?("pssa_performance_level_reading")
            results = $tables.attach("Pssa").field_bystudentid("reading_perf_level", studentid)
            structure["pssa_performance_level_reading"] = results
        end
        structure["pssa_performance_level_reading"]
    end
    
    def pssa_performance_level_science
        if has_pssa_record? && !structure.has_key?("pssa_performance_level_science")
            results = $tables.attach("Pssa").field_bystudentid("science_perf_level", studentid)
            structure["pssa_performance_level_science"] = results
        end
        structure["pssa_performance_level_science"]
    end
    
    def pssa_performance_level_writing
        if has_pssa_record? && !structure.has_key?("pssa_performance_level_writing")
            results = $tables.attach("Pssa").field_bystudentid("writing_perf_level", studentid)
            structure["pssa_performance_level_writing"] = results
        end
        structure["pssa_performance_level_writing"]
    end
    
    def pssa_score_math
        if has_pssa_record? && !structure.has_key?("pssa_score_math")
            results = $tables.attach("Pssa").field_bystudentid("math_score", studentid)
            structure["pssa_score_math"] = results
        end
        structure["pssa_score_math"]
    end
    
    def pssa_score_reading
        if has_pssa_record? && !structure.has_key?("pssa_score_reading")
            results = $tables.attach("Pssa").field_bystudentid("reading_score", studentid)
            structure["pssa_score_reading"] = results
        end
        structure["pssa_score_reading"]
    end
    
    def pssa_score_science
        if has_pssa_record? && !structure.has_key?("pssa_score_science")
            results = $tables.attach("Pssa").field_bystudentid("science_score", studentid)
            structure["pssa_score_science"] = results
        end
        structure["pssa_score_science"]
    end
    
    def pssa_score_writing
        if has_pssa_record? && !structure.has_key?("pssa_score_writing")
            results = $tables.attach("Pssa").field_bystudentid("writing_score", studentid)
            structure["pssa_score_writing"] = results
        end
        structure["pssa_score_writing"]
    end
    
    def pssa_test_type_math
        if has_pssa_record? && !structure.has_key?("pssa_test_type_math")
            results = $tables.attach("Pssa").field_bystudentid("math_test_type", studentid)
            structure["pssa_test_type_math"] = results
        end
        structure["pssa_test_type_math"]
    end
    
    def pssa_test_type_reading
        if has_pssa_record? && !structure.has_key?("pssa_test_type_reading")
            results = $tables.attach("Pssa").field_bystudentid("reading_test_type", studentid)
            structure["pssa_test_type_reading"] = results
        end
        structure["pssa_test_type_reading"]
    end
    
    def pssa_test_type_science
        if has_pssa_record? && !structure.has_key?("pssa_test_type_science")
            results = $tables.attach("Pssa").field_bystudentid("science_test_type", studentid)
            structure["pssa_test_type_science"] = results
        end
        structure["pssa_test_type_science"]
    end
    
    def pssa_test_type_writing
        if has_pssa_record? && !structure.has_key?("pssa_test_type_writing")
            results = $tables.attach("Pssa").field_bystudentid("writing_test_type", studentid)
            structure["pssa_test_type_writing"] = results
        end
        structure["pssa_test_type_writing"]
    end
    
    def pssa_test_year
        if has_pssa_record? && !structure.has_key?("pssa_test_year")
            results = $tables.attach("Pssa").field_bystudentid("test_school_year", studentid)
            structure["pssa_test_year"] = results
        end
        structure["pssa_test_year"]
    end
    
    def records_received
        return $tables.attach("Record_Requests_Received").by_studentid_old(student_id)
    end
    
    def records_received_by_pid(pid)
        return $tables.attach("Record_Requests_Received").by_primaryid(pid)
    end
    
    def records_required
        return $tables.attach("Record_Requests_Required").by_studentid_old(student_id)
    end
    
    def record_requests_notes
        return $tables.attach("Record_Requests_Notes").by_studentid_old(studentid)
    end
    
    def record_requests_notes_by_pid(pid)
        return $tables.attach("Record_Requests_Notes").by_primaryid(pid)
    end
    
    def school_enroll_date
        results = $tables.attach("student").field_bystudentid("schoolenrolldate", studentid)
    end
    
    def school_withdraw_date
        if !structure.has_key?("schoolwithdrawdate")
            results = $tables.attach("Student").field_bystudentid("schoolwithdrawdate", studentid)
            structure["schoolwithdrawdate"] = results if results
        end
        return structure["schoolwithdrawdate"].value if structure["schoolwithdrawdate"] && output_type == "value"
        structure["schoolwithdrawdate"]
    end
    
    def sid
        $tables.attach("Student").field_bystudentid("student_id", studentid)
    end
    
    def specialed_teacher
        if !structure.has_key?("specialed_teacher")
            results = $tables.attach("Student").field_bystudentid("specialedteacher", studentid)
            structure["specialed_teacher"] = results if results
        end
        return structure["specialed_teacher"].value if output_type == "value"
        structure["specialed_teacher"]
    end
    
    def staples_id(concat_id)
        return $tables.attach("Ink_Staples_Ids").staples_id(concat_id)
    end
    
    def sti_attended_overall
        if !structure.has_key?("sti_attended_overall")
            results = $tables.attach("K12_STI_Combined").field_bystudentid("total_interventions", studentid)
            structure["sti_attended_overall"] = results if results
        end
        return structure["sti_attended_overall"].value if output_type == "value"
        structure["sti_attended_overall"]
    end
    
    def sti_missed_overall
        if !structure.has_key?("sti_missed_overall")
            results = $tables.attach("K12_STI_Combined").field_bystudentid("total_missed_interventions", studentid)
            structure["sti_missed_overall"] = results if results
        end
        return structure["sti_missed_overall"].value if output_type == "value"
        structure["sti_missed_overall"]
    end
    
    def sti_offered_overall
        missed = sti_missed_overall ? sti_missed_overall.value : 0
        attended = sti_attended_overall ? sti_attended_overall.value : 0
        return missed + attended
    end
    
    def studentid
        structure["student_id"]
    end
    
    def student_id
        structure["student_id"]
    end
    
    def tep_records
        return $tables.attach("Tep_Students").by_studentid_old(student_id)
    end
    
    def tier_level_math
        if has_rtii_record? && !structure.has_key?("tier_level_math")
            results = $tables.attach("Rtii_Tier_Levels").field_bystudentid("math_tier", studentid)
            structure["tier_level_math"] = results
        end
        structure["tier_level_math"]
    end
    
    def tier_level_reading
        if has_rtii_record? && !structure.has_key?("tier_level_reading")
            results = $tables.attach("Rtii_Tier_Levels").field_bystudentid("reading_tier", studentid)
            structure["tier_level_reading"] = results
        end
        structure["tier_level_reading"]
    end
    
    def title_one_teacher
        if !structure.has_key?("title_one_teacher")
            if active?
                results = $tables.attach("Student").field_bystudentid("title1teacher", studentid)
            else
                results = $tables.attach("Student").field_bystudentid("title1teacher", studentid)
            end
            structure["title_one_teacher"] = results if results
        end
        structure["title_one_teacher"]
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def queue_kmail(subject, content, sender)
        params = Hash.new
        params[:sender              ] = "#{sender}:tv"
        params[:subject             ] = subject
        params[:content             ] = content
        params[:recipient_studentid ] = studentid
        return $base.queue_kmail(params)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def output_type=(arg)
        structure["output_type"] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attendance
        if !structure.has_key?(:attendance)
            require "#{File.dirname(__FILE__)}/student_attendance"
            structure[:attendance] = Student_Attendance.new(self)
        end
        structure[:attendance]
    end
    
    def enrollment
        if !structure.has_key?(:enrollment)
            require "#{File.dirname(__FILE__)}/student_enrollment"
            structure[:enrollment] = STUDENT_ENROLLMENT.new(self)
        end
        structure[:enrollment]
    end
    
    def metrics
        if !structure.has_key?(:metrics)
            if active?
                require "#{File.dirname(__FILE__)}/student_metrics"
                structure[:metrics] = Student_Metrics.new(self)
            else
                structure[:metrics] = false
            end
        end
        structure[:metrics]
    end
    
    def progress
        if !structure.has_key?(:progress)
            if grade.value.match(/K|1st|2nd|3rd|4th|5th|6th/i)
                require "#{File.dirname(__FILE__)}/student_progress_k6"
                structure[:progress] = Student_Progress_K6.new(self)
            end
        end
        structure[:progress]
    end
    
    def pssa_assignments
        if !structure.has_key?(:pssa_assignments)
            require "#{File.dirname(__FILE__)}/student_pssa_assignments"
            structure[:pssa_assignments] = Student_Pssa_Assignments.new(self)
        end
        structure[:pssa_assignments]
    end
  
    def report_card
        if !structure.has_key?(:report_card)  
            require "#{File.dirname(__FILE__).gsub("tables", "system")}/student_report_card"
            structure[:report_card] = Student_Report_Card.new(self)
        end
        structure[:report_card]
    end
    
    def scantron
        if !structure.has_key?(:scantron)  
            require "#{File.dirname(__FILE__).gsub("tables", "system")}/student_scantron"
            structure[:scantron] = Student_Scantron.new(self)
        end
        structure[:scantron]
    end
    
    def withdrawal
        if !structure.has_key?(:withdrawal)
            require "#{File.dirname(__FILE__)}/student_withdrawal"
            structure[:withdrawal] = Student_Withdrawal.new(self)
        end
        structure[:withdrawal]
    end
    
    def web
        if !structure.has_key?(:web)
            require "#{File.dirname(__FILE__)}/web/student_web"
            structure[:web] = Student_Web.new(self)
        end
        structure[:web]
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def new_row(table_name)
        this_row = $tables.attach(table_name).new_row
        this_row.fields["student_id" ].value = student_id if this_row.fields["student_id" ]
        this_row.fields["studentid"  ].value = student_id if this_row.fields["studentid"  ]
        return this_row
    end
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def student_id=(arg)
        structure["student_id"] = arg
    end
end