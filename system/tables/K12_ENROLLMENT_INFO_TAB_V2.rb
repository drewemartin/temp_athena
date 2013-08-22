#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_ENROLLMENT_INFO_TAB_V2 < Athena_Table
    
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

    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_load_k12_enrollment_info_tab_v2
        require  File.dirname(__FILE__).gsub("tables","reports/enrollment_reports")
        Enrollment_Reports.new.flag_duplicates($base.yesterday.iso_date)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "k12_enrollment_info_tab_v2",
                "file_name"         => "agora_eitr_version2.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_eitr_version2.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "EITR V2"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_id"]                          = {"data_type"=>"int",  "file_field"=>"STUDENTID"}                      if field_order.push("student_id")
        structure_hash["fields"]["integrationid"]                       = {"data_type"=>"text", "file_field"=>"INTEGRATIONID"}                  if field_order.push("integrationid")
        structure_hash["fields"]["identityid"]                          = {"data_type"=>"int",  "file_field"=>"IDENTITYID"}                     if field_order.push("identityid")
        structure_hash["fields"]["familyid"]                            = {"data_type"=>"int",  "file_field"=>"FAMILYID"}                       if field_order.push("familyid")
        structure_hash["fields"]["online_enrollment"]                   = {"data_type"=>"text", "file_field"=>"Online Enrollment"}              if field_order.push("online_enrollment")
        structure_hash["fields"]["firstname"]                           = {"data_type"=>"text", "file_field"=>"FIRSTNAME"}                      if field_order.push("firstname")
        structure_hash["fields"]["middlename"]                          = {"data_type"=>"text", "file_field"=>"MIDDLENAME"}                     if field_order.push("middlename")
        structure_hash["fields"]["lastname"]                            = {"data_type"=>"text", "file_field"=>"LASTNAME"}                       if field_order.push("lastname")
        structure_hash["fields"]["preferredname"]                       = {"data_type"=>"text", "file_field"=>"PREFERREDNAME"}                  if field_order.push("preferredname")
        structure_hash["fields"]["birthday"]                            = {"data_type"=>"date", "file_field"=>"BIRTHDAY"}                       if field_order.push("birthday")
        structure_hash["fields"]["dateofentry"]                         = {"data_type"=>"date", "file_field"=>"DATEOFENTRY"}                    if field_order.push("dateofentry")
        structure_hash["fields"]["countryofbirth"]                      = {"data_type"=>"text", "file_field"=>"COUNTRYOFBIRTH"}                 if field_order.push("countryofbirth")
        structure_hash["fields"]["gradelevel_applying_for"]             = {"data_type"=>"text", "file_field"=>"Gradelevel Applying For"}        if field_order.push("gradelevel_applying_for")
        structure_hash["fields"]["sams_grade_level"]                    = {"data_type"=>"text", "file_field"=>"SAMS Grade Level"}               if field_order.push("sams_grade_level")
        structure_hash["fields"]["gender"]                              = {"data_type"=>"text", "file_field"=>"GENDER"}                         if field_order.push("gender")
        structure_hash["fields"]["homephone"]                           = {"data_type"=>"int",  "file_field"=>"HOMEPHONE"}                      if field_order.push("homephone")
        structure_hash["fields"]["school_name"]                         = {"data_type"=>"text", "file_field"=>"School Name"}                    if field_order.push("school_name")
        structure_hash["fields"]["school_district_of_residence"]        = {"data_type"=>"text", "file_field"=>"School District of Residence"}   if field_order.push("school_district_of_residence")
        structure_hash["fields"]["initenrollyear"]                      = {"data_type"=>"int",  "file_field"=>"INITENROLLYEAR"}                 if field_order.push("initenrollyear")
        structure_hash["fields"]["enrollreceiveddate"]                  = {"data_type"=>"date", "file_field"=>"ENROLLRECEIVEDDATE"}             if field_order.push("enrollreceiveddate")
        structure_hash["fields"]["days_old"]                            = {"data_type"=>"int",  "file_field"=>"Days Old"}                       if field_order.push("days_old")
        structure_hash["fields"]["enrollapproveddate"]                  = {"data_type"=>"date", "file_field"=>"ENROLLAPPROVEDDATE"}             if field_order.push("enrollapproveddate")
        structure_hash["fields"]["schoolenrolldate"]                    = {"data_type"=>"date", "file_field"=>"SCHOOLENROLLDATE"}               if field_order.push("schoolenrolldate")
        structure_hash["fields"]["enrollment_status"]                   = {"data_type"=>"text", "file_field"=>"Enrollment Status"}              if field_order.push("enrollment_status")
        structure_hash["fields"]["regular_ed_compliancy_status"]        = {"data_type"=>"text", "file_field"=>"Regular Ed. Compliancy Status"}  if field_order.push("regular_ed_compliancy_status")
        structure_hash["fields"]["testing_status"]                      = {"data_type"=>"text", "file_field"=>"Testing Status"}                 if field_order.push("testing_status")
        structure_hash["fields"]["courses"]                             = {"data_type"=>"text", "file_field"=>"Courses"}                        if field_order.push("courses")
        structure_hash["fields"]["registration_status"]                 = {"data_type"=>"text", "file_field"=>"Registration Status"}            if field_order.push("registration_status")
        structure_hash["fields"]["welcome_called_attempt_made"]         = {"data_type"=>"text", "file_field"=>"Welcome Called Attempt Made"}    if field_order.push("welcome_called_attempt_made")
        structure_hash["fields"]["welcome_email_sent"]                  = {"data_type"=>"text", "file_field"=>"Welcome Email Sent"}             if field_order.push("welcome_email_sent")
        structure_hash["fields"]["verify_student_information"]          = {"data_type"=>"text", "file_field"=>"Verify Student Information"}     if field_order.push("verify_student_information")
        structure_hash["fields"]["relay_school_policies"]               = {"data_type"=>"text", "file_field"=>"Relay School Policies"}          if field_order.push("relay_school_policies")
        structure_hash["fields"]["transcript_received"]                 = {"data_type"=>"text", "file_field"=>"Transcript Received"}            if field_order.push("transcript_received")
        structure_hash["fields"]["special_education_compliancy"]        = {"data_type"=>"text", "file_field"=>"Special Education Compliancy"}   if field_order.push("special_education_compliancy")
        structure_hash["fields"]["student_testing_completed"]           = {"data_type"=>"text", "file_field"=>"Student Testing Completed"}      if field_order.push("student_testing_completed")
        structure_hash["fields"]["placement_conference_held"]           = {"data_type"=>"text", "file_field"=>"Placement Conference Held"}      if field_order.push("placement_conference_held")
        structure_hash["fields"]["course_assignment_completed"]         = {"data_type"=>"text", "file_field"=>"Course Assignment Completed"}    if field_order.push("course_assignment_completed")
        structure_hash["fields"]["tuition_paid"]                        = {"data_type"=>"text", "file_field"=>"Tuition Paid"}                   if field_order.push("tuition_paid")
        structure_hash["fields"]["required_iep"]                        = {"data_type"=>"text", "file_field"=>"Required IEP"}                   if field_order.push("required_iep")
        structure_hash["fields"]["iep_received_date"]                   = {"data_type"=>"date", "file_field"=>"IEP Received Date"}              if field_order.push("iep_received_date")
        structure_hash["fields"]["ent_iep_witten_date"]                 = {"data_type"=>"date", "file_field"=>"Ent. IEP Witten Date"}           if field_order.push("ent_iep_witten_date")
        structure_hash["fields"]["ent_iep_meeting_held"]                = {"data_type"=>"date", "file_field"=>"Ent. IEP Meeting Held"}          if field_order.push("ent_iep_meeting_held")
        structure_hash["fields"]["last_communication_day"]              = {"data_type"=>"date", "file_field"=>"Last Communication Day"}         if field_order.push("last_communication_day")
        structure_hash["fields"]["number_of_communications"]            = {"data_type"=>"int",  "file_field"=>"Number of Communications"}       if field_order.push("number_of_communications")
        structure_hash["fields"]["days_since_last_communication"]       = {"data_type"=>"int",  "file_field"=>"Days Since Last Communication"}  if field_order.push("days_since_last_communication")
        structure_hash["fields"]["ei_gifted_and_talented"]              = {"data_type"=>"text", "file_field"=>"EI Gifted and Talented"}         if field_order.push("ei_gifted_and_talented")
        structure_hash["fields"]["ei_has_504_plan"]                     = {"data_type"=>"text", "file_field"=>"EI Has 504 Plan"}                if field_order.push("ei_has_504_plan")
        structure_hash["fields"]["ei_special_ed"]                       = {"data_type"=>"text", "file_field"=>"EI Special Ed"}                  if field_order.push("ei_special_ed")
        structure_hash["fields"]["ei_has_an_iep"]                       = {"data_type"=>"text", "file_field"=>"EI Has An IEP"}                  if field_order.push("ei_has_an_iep")
        structure_hash["fields"]["ei_esl"]                              = {"data_type"=>"text", "file_field"=>"EI ESL"}                         if field_order.push("ei_esl")
        structure_hash["fields"]["ei_title_i_chapter_i"]                = {"data_type"=>"text", "file_field"=>"EI Title I/Chapter I"}           if field_order.push("ei_title_i_chapter_i")
        structure_hash["fields"]["ei_ilp"]                              = {"data_type"=>"text", "file_field"=>"EI ILP"}                         if field_order.push("ei_ilp")
        structure_hash["fields"]["parent_gifted"]                       = {"data_type"=>"text", "file_field"=>"Parent Gifted"}                  if field_order.push("parent_gifted")
        structure_hash["fields"]["parent_esl"]                          = {"data_type"=>"text", "file_field"=>"Parent ESL"}                     if field_order.push("parent_esl")
        structure_hash["fields"]["parent_title_1"]                      = {"data_type"=>"text", "file_field"=>"Parent Title 1"}                 if field_order.push("parent_title_1")
        structure_hash["fields"]["parent_504_plan"]                     = {"data_type"=>"text", "file_field"=>"Parent 504 Plan"}                if field_order.push("parent_504_plan")
        structure_hash["fields"]["parent_sed_iep"]                      = {"data_type"=>"text", "file_field"=>"Parent SED IEP"}                 if field_order.push("parent_sed_iep")
        structure_hash["fields"]["parent_ilp"]                          = {"data_type"=>"text", "file_field"=>"Parent ILP"}                     if field_order.push("parent_ilp")
        structure_hash["fields"]["parent_speech_service"]               = {"data_type"=>"text", "file_field"=>"Parent Speech Service"}          if field_order.push("parent_speech_service")
        structure_hash["fields"]["parent_rti"]                          = {"data_type"=>"text", "file_field"=>"Parent RTI"}                     if field_order.push("parent_rti")
        structure_hash["fields"]["ethnicity"]                           = {"data_type"=>"text", "file_field"=>"Ethnicity"}                      if field_order.push("ethnicity")
        structure_hash["fields"]["primary_adult_firstname"]             = {"data_type"=>"text", "file_field"=>"PRIMARY_ADULT_FIRSTNAME"}        if field_order.push("primary_adult_firstname")
        structure_hash["fields"]["primary_adult_lastname"]              = {"data_type"=>"text", "file_field"=>"PRIMARY_ADULT_LASTNAME"}         if field_order.push("primary_adult_lastname")
        structure_hash["fields"]["primary_adult_email_address"]         = {"data_type"=>"text", "file_field"=>"PRIMARY_ADULT_EMAIL_ADDRESS"}    if field_order.push("primary_adult_email_address")
        structure_hash["fields"]["previous_type_of_school"]             = {"data_type"=>"text", "file_field"=>"Previous Type of School"}        if field_order.push("previous_type_of_school")
        structure_hash["fields"]["prevdistrict"]                        = {"data_type"=>"text", "file_field"=>"PREVDISTRICT"}                   if field_order.push("prevdistrict")
        structure_hash["fields"]["prevschoolname"]                      = {"data_type"=>"text", "file_field"=>"PREVSCHOOLNAME"}                 if field_order.push("prevschoolname")
        structure_hash["fields"]["stufulltime"]                         = {"data_type"=>"text", "file_field"=>"STUFULLTIME"}                    if field_order.push("stufulltime")
        structure_hash["fields"]["assignedpaldate"]                     = {"data_type"=>"date", "file_field"=>"ASSIGNEDPALDATE"}                if field_order.push("assignedpaldate")
        structure_hash["fields"]["pal_assigned_firstname"]              = {"data_type"=>"text", "file_field"=>"PAL Assigned Firstname"}         if field_order.push("pal_assigned_firstname")
        structure_hash["fields"]["pal_assigned_lastname"]               = {"data_type"=>"text", "file_field"=>"PAL Assigned Lastname"}          if field_order.push("pal_assigned_lastname")
        structure_hash["fields"]["palriskassessment"]                   = {"data_type"=>"text", "file_field"=>"PALRISKASSESSMENT"}              if field_order.push("palriskassessment")
        structure_hash["fields"]["teachriskassessment"]                 = {"data_type"=>"text", "file_field"=>"TEACHRISKASSESSMENT"}            if field_order.push("teachriskassessment")
        structure_hash["fields"]["ei_comments"]                         = {"data_type"=>"text", "file_field"=>"EI Comments"}                    if field_order.push("ei_comments")
        structure_hash["fields"]["pc_assigned"]                         = {"data_type"=>"text", "file_field"=>"PC Assigned"}                    if field_order.push("pc_assigned")
        structure_hash["fields"]["assigned_date"]                       = {"data_type"=>"date", "file_field"=>"Assigned Date"}                  if field_order.push("assigned_date")
        structure_hash["fields"]["placement_conf_complete_date"]        = {"data_type"=>"date", "file_field"=>"Placement Conf Complete Date"}   if field_order.push("placement_conf_complete_date")
        structure_hash["fields"]["declined_computer"]                   = {"data_type"=>"text", "file_field"=>"Declined Computer"}              if field_order.push("declined_computer")
        structure_hash["fields"]["sortable_comment"]                    = {"data_type"=>"text", "file_field"=>"Sortable Comment"}               if field_order.push("sortable_comment")
        structure_hash["fields"]["sortable_id_comment"]                 = {"data_type"=>"int",  "file_field"=>"Sortable ID Comment"}            if field_order.push("sortable_id_comment")
        structure_hash["fields"]["sortable_comment_date"]               = {"data_type"=>"date", "file_field"=>"Sortable Comment Date"}          if field_order.push("sortable_comment_date")
        structure_hash["fields"]["admn_conf_completed"]                 = {"data_type"=>"text", "file_field"=>"Admn Conf Completed"}            if field_order.push("admn_conf_completed")
        structure_hash["fields"]["admn_conf_completed_date"]            = {"data_type"=>"date", "file_field"=>"Admn Conf Completed Date"}       if field_order.push("admn_conf_completed_date")
        structure_hash["fields"]["admn_conf_completed_id"]              = {"data_type"=>"int",  "file_field"=>"Admn Conf Completed ID"}         if field_order.push("admn_conf_completed_id")
        structure_hash["fields"]["aag"]                                 = {"data_type"=>"text", "file_field"=>"AAG"}                            if field_order.push("aag")
        structure_hash["fields"]["previouslyapplied"]                   = {"data_type"=>"text", "file_field"=>"PREVIOUSLYAPPLIED"}              if field_order.push("previouslyapplied")
        structure_hash["fields"]["directory_acceptance"]                = {"data_type"=>"text", "file_field"=>"Directory Acceptance"}           if field_order.push("directory_acceptance")
        structure_hash["fields"]["photo_video_release_acceptance"]      = {"data_type"=>"text", "file_field"=>"Photo/Video Release Acceptance"} if field_order.push("photo_video_release_acceptance")
        structure_hash["fields"]["primary_language"]                    = {"data_type"=>"text", "file_field"=>"Primary Language"}               if field_order.push("primary_language")
        structure_hash["fields"]["ever_expelled"]                       = {"data_type"=>"text", "file_field"=>"Ever Expelled"}                  if field_order.push("ever_expelled")
        structure_hash["fields"]["stu_lang_most_often_spoken"]          = {"data_type"=>"text", "file_field"=>"Stu Lang Most Often Spoken"}     if field_order.push("stu_lang_most_often_spoken")
        structure_hash["fields"]["stu_lang_first_acquired"]             = {"data_type"=>"text", "file_field"=>"Stu Lang First Acquired"}        if field_order.push("stu_lang_first_acquired")
        structure_hash["fields"]["school_attended_oct_1st"]             = {"data_type"=>"text", "file_field"=>"School Attended Oct 1ST"}        if field_order.push("school_attended_oct_1st")
        structure_hash["fields"]["district_attended_oct_1st"]           = {"data_type"=>"text", "file_field"=>"District Attended Oct 1ST"}      if field_order.push("district_attended_oct_1st")
        structure_hash["fields"]["attended_co_pub_sch_3_yrs"]           = {"data_type"=>"text", "file_field"=>"Attended CO Pub Sch 3 YRS"}      if field_order.push("attended_co_pub_sch_3_yrs")
        structure_hash["fields"]["date_first_enrolled_co_pub_sch"]      = {"data_type"=>"text", "file_field"=>"Date First Enrolled CO Pub Sch"} if field_order.push("date_first_enrolled_co_pub_sch")
        structure_hash["fields"]["attended_us_pub_sch_3_yrs"]           = {"data_type"=>"text", "file_field"=>"Attended US Pub Sch 3 YRS"}      if field_order.push("attended_us_pub_sch_3_yrs")
        structure_hash["fields"]["date_first_enrolled_us_pub_sch"]      = {"data_type"=>"text", "file_field"=>"Date First Enrolled US Pub Sch"} if field_order.push("date_first_enrolled_us_pub_sch")
        structure_hash["fields"]["expelled_pub_sch_in_365_days"]        = {"data_type"=>"text", "file_field"=>"Expelled Pub Sch In 365 Days"}   if field_order.push("expelled_pub_sch_in_365_days")
        structure_hash["fields"]["oct_10_school"]                       = {"data_type"=>"text", "file_field"=>"Oct 10 School"}                  if field_order.push("oct_10_school")
        structure_hash["fields"]["feb_10_school"]                       = {"data_type"=>"text", "file_field"=>"Feb 10 School"}                  if field_order.push("feb_10_school")
        structure_hash["fields"]["school_attended_previous_10_1"]       = {"data_type"=>"text", "file_field"=>"School Attended previous 10/1"}  if field_order.push("school_attended_previous_10_1")
        structure_hash["fields"]["district_previous_10_1"]              = {"data_type"=>"text", "file_field"=>"District previous 10/1"}         if field_order.push("district_previous_10_1")
        structure_hash["fields"]["out_of_district_waiver_check"]        = {"data_type"=>"text", "file_field"=>"Out of District Waiver Check"}   if field_order.push("out_of_district_waiver_check")
        structure_hash["fields"]["out_of_district_waiver_comment"]      = {"data_type"=>"text", "file_field"=>"Out of District Waiver Comment"} if field_order.push("out_of_district_waiver_comment")
        structure_hash["fields"]["report_card_transcript_check"]        = {"data_type"=>"text", "file_field"=>"Report Card/Transcript Check"}   if field_order.push("report_card_transcript_check")
        structure_hash["fields"]["report_card_transcript_comment"]      = {"data_type"=>"text", "file_field"=>"Report Card/Transcript Comment"} if field_order.push("report_card_transcript_comment")
        structure_hash["fields"]["birth_certificate_checkbox"]          = {"data_type"=>"text", "file_field"=>"Birth Certificate Checkbox"}     if field_order.push("birth_certificate_checkbox")
        structure_hash["fields"]["birth_certificate_comment_box"]       = {"data_type"=>"text", "file_field"=>"Birth Certificate Comment Box"}  if field_order.push("birth_certificate_comment_box")
        structure_hash["fields"]["immunization_card_checkbox"]          = {"data_type"=>"text", "file_field"=>"Immunization Card Checkbox"}     if field_order.push("immunization_card_checkbox")
        structure_hash["fields"]["immunization_card_comment_box"]       = {"data_type"=>"text", "file_field"=>"Immunization Card Comment Box"}  if field_order.push("immunization_card_comment_box")
        structure_hash["fields"]["proof_of_residency_checkbox"]         = {"data_type"=>"text", "file_field"=>"Proof of Residency Checkbox"}    if field_order.push("proof_of_residency_checkbox")
        structure_hash["fields"]["proof_of_residency_comment_box"]      = {"data_type"=>"text", "file_field"=>"Proof of Residency Comment Box"} if field_order.push("proof_of_residency_comment_box")
        structure_hash["fields"]["family_income_10-11_check"]           = {"data_type"=>"text", "file_field"=>"Family Income 10-11 Check"}      if field_order.push("family_income_10-11_check")
        structure_hash["fields"]["family_income_10-11_comment"]         = {"data_type"=>"text", "file_field"=>"Family Income 10-11 Comment"}    if field_order.push("family_income_10-11_comment")
        structure_hash["fields"]["family_income_11-12_check"]           = {"data_type"=>"text", "file_field"=>"Family Income 11-12 Check"}      if field_order.push("family_income_11-12_check")
        structure_hash["fields"]["family_income_11-12_comment"]         = {"data_type"=>"text", "file_field"=>"Family Income 11-12 Comment"}    if field_order.push("family_income_11-12_comment")
        structure_hash["fields"]["enroll_acceptance_10-11_check"]       = {"data_type"=>"text", "file_field"=>"Enroll Acceptance 10-11 Check"}  if field_order.push("enroll_acceptance_10-11_check")
        structure_hash["fields"]["enroll_accept_10-11_comment"]         = {"data_type"=>"text", "file_field"=>"Enroll Accept 10-11 Comment"}    if field_order.push("enroll_accept_10-11_comment")
        structure_hash["fields"]["instructional_property_10-11"]        = {"data_type"=>"text", "file_field"=>"Instructional Property 10-11"}   if field_order.push("instructional_property_10-11")
        structure_hash["fields"]["instruct_prop_10-11_comment"]         = {"data_type"=>"text", "file_field"=>"Instruct Prop 10-11 Comment"}    if field_order.push("instruct_prop_10-11_comment")
        structure_hash["fields"]["ferpa_consent_checkbox"]              = {"data_type"=>"text", "file_field"=>"FERPA Consent Checkbox"}         if field_order.push("ferpa_consent_checkbox")
        structure_hash["fields"]["ferpa_consent_comment_box"]           = {"data_type"=>"text", "file_field"=>"FERPA Consent Comment Box"}      if field_order.push("ferpa_consent_comment_box")
        structure_hash["fields"]["proof_of_prior_public_checkbox"]      = {"data_type"=>"text", "file_field"=>"Proof of Prior Public Checkbox"} if field_order.push("proof_of_prior_public_checkbox")
        structure_hash["fields"]["proof_of_prior_public_comment"]       = {"data_type"=>"text", "file_field"=>"Proof of Prior Public Comment"}  if field_order.push("proof_of_prior_public_comment")
        structure_hash["fields"]["release_of_records_checkbox"]         = {"data_type"=>"text", "file_field"=>"Release of Records Checkbox"}    if field_order.push("release_of_records_checkbox")
        structure_hash["fields"]["release_of_records_comment_box"]      = {"data_type"=>"text", "file_field"=>"Release of Records Comment Box"} if field_order.push("release_of_records_comment_box")
        structure_hash["fields"]["phlote_checkbox"]                     = {"data_type"=>"text", "file_field"=>"PHLOTE Checkbox"}                if field_order.push("phlote_checkbox")
        structure_hash["fields"]["phlote_comment_box"]                  = {"data_type"=>"text", "file_field"=>"PHLOTE Comment Box"}             if field_order.push("phlote_comment_box")
        structure_hash["fields"]["transcript_high_school_check"]        = {"data_type"=>"text", "file_field"=>"Transcript High School Check"}   if field_order.push("transcript_high_school_check")
        structure_hash["fields"]["transcript_high_school_comment"]      = {"data_type"=>"text", "file_field"=>"Transcript High School Comment"} if field_order.push("transcript_high_school_comment")
        structure_hash["fields"]["enrollment_form_complete_check"]      = {"data_type"=>"text", "file_field"=>"Enrollment Form Complete Check"} if field_order.push("enrollment_form_complete_check")
        structure_hash["fields"]["enroll_form_complete_comment"]        = {"data_type"=>"text", "file_field"=>"Enroll Form Complete Comment"}   if field_order.push("enroll_form_complete_comment")
        structure_hash["fields"]["guardianship_checkbox"]               = {"data_type"=>"text", "file_field"=>"Guardianship Checkbox"}          if field_order.push("guardianship_checkbox")
        structure_hash["fields"]["guardianship_comment_box"]            = {"data_type"=>"text", "file_field"=>"Guardianship Comment Box"}       if field_order.push("guardianship_comment_box")
        structure_hash["fields"]["charter_school_enroll_check"]         = {"data_type"=>"text", "file_field"=>"Charter School Enroll Check"}    if field_order.push("charter_school_enroll_check")
        structure_hash["fields"]["charter_school_enroll_comment"]       = {"data_type"=>"text", "file_field"=>"Charter School Enroll Comment"}  if field_order.push("charter_school_enroll_comment")
        structure_hash["fields"]["stupermrec"]                          = {"data_type"=>"text", "file_field"=>"StuPermRec"}                     if field_order.push("stupermrec")
        structure_hash["fields"]["stupermreccomment"]                   = {"data_type"=>"text", "file_field"=>"StuPermRecComment"}              if field_order.push("stupermreccomment")
        structure_hash["fields"]["noteoffence"]                         = {"data_type"=>"text", "file_field"=>"NoteOffence"}                    if field_order.push("noteoffence")
        structure_hash["fields"]["noteoffencecom"]                      = {"data_type"=>"text", "file_field"=>"NoteOffenceCom"}                 if field_order.push("noteoffencecom")
        structure_hash["fields"]["homelangsurv"]                        = {"data_type"=>"bool", "file_field"=>"HomeLangSurv"}                   if field_order.push("homelangsurv")
        structure_hash["fields"]["homelangsurvcom"]                     = {"data_type"=>"text", "file_field"=>"HomeLangSurvCom"}                if field_order.push("homelangsurvcom")
        structure_hash["fields"]["eval_report_check"]                   = {"data_type"=>"text", "file_field"=>"Eval Report Check"}              if field_order.push("eval_report_check")
        structure_hash["fields"]["eval_report_comment"]                 = {"data_type"=>"text", "file_field"=>"Eval Report Comment"}            if field_order.push("eval_report_comment")
        structure_hash["fields"]["proof_of_guardianship_check"]         = {"data_type"=>"text", "file_field"=>"Proof of Guardianship Check"}    if field_order.push("proof_of_guardianship_check")
        structure_hash["fields"]["proof_of_guardianship_comment"]       = {"data_type"=>"text", "file_field"=>"Proof of Guardianship Comment"}  if field_order.push("proof_of_guardianship_comment")
        structure_hash["fields"]["homeless_check"]                      = {"data_type"=>"text", "file_field"=>"Homeless Check"}                 if field_order.push("homeless_check")
        structure_hash["fields"]["homeless_comment"]                    = {"data_type"=>"text", "file_field"=>"Homeless Comment"}               if field_order.push("homeless_comment")
        structure_hash["fields"]["reinstated_check"]                    = {"data_type"=>"text", "file_field"=>"Reinstated Check"}               if field_order.push("reinstated_check")
        structure_hash["fields"]["reinstated_comment"]                  = {"data_type"=>"text", "file_field"=>"Reinstated Comment"}             if field_order.push("reinstated_comment")
        structure_hash["fields"]["enrollment_call_check"]               = {"data_type"=>"text", "file_field"=>"Enrollment Call Check"}          if field_order.push("enrollment_call_check")
        structure_hash["fields"]["enrollment_call_comment"]             = {"data_type"=>"text", "file_field"=>"Enrollment Call Comment"}        if field_order.push("enrollment_call_comment")
        structure_hash["fields"]["face_to_face_check"]                  = {"data_type"=>"text", "file_field"=>"Face to Face Check"}             if field_order.push("face_to_face_check")
        structure_hash["fields"]["face_to_face_comment"]                = {"data_type"=>"text", "file_field"=>"Face to Face Comment"}           if field_order.push("face_to_face_comment")
        structure_hash["fields"]["emancpt_y_check"]                     = {"data_type"=>"text", "file_field"=>"Emancpt Y Check"}                if field_order.push("emancpt_y_check")
        structure_hash["fields"]["emancpt_y_comment"]                   = {"data_type"=>"text", "file_field"=>"Emancpt Y Comment"}              if field_order.push("emancpt_y_comment")
        structure_hash["fields"]["hispanic_latino"]                     = {"data_type"=>"text", "file_field"=>"Hispanic Latino"}                if field_order.push("hispanic_latino")
        structure_hash["fields"]["when_move_to_pa_1"]                   = {"data_type"=>"text", "file_field"=>"When move to PA:1"}              if field_order.push("when_move_to_pa_1")
        structure_hash["fields"]["where_if_born_in_pa_2"]               = {"data_type"=>"text", "file_field"=>"Where if born in PA:2"}          if field_order.push("where_if_born_in_pa_2")
        structure_hash["fields"]["enrolled_in_this_school"]             = {"data_type"=>"text", "file_field"=>"Enrolled in this school"}        if field_order.push("enrolled_in_this_school")
        structure_hash["fields"]["local_public_school"]                 = {"data_type"=>"text", "file_field"=>"Local public school"}            if field_order.push("local_public_school")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end