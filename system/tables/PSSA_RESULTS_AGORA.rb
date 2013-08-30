#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class PSSA_RESULTS_AGORA < Athena_Table
    
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

    def by_studentid_old(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("local_student_id", "=", sid ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def students_with_records(created_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("created_date", "REGEXP", created_date ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT local_student_id FROM #{data_base}.#{table_name} #{where_clause} GROUP BY local_student_id") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
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
                "name"              => "pssa_results_agora",
                "file_name"         => "pssa_results_agora.csv",
                "file_location"     => "pssa_results_agora",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["subject"]                                                 = {"data_type"=>"text", "file_field"=>"subject"} if field_order.push("subject")
            structure_hash["fields"]["attributed_district_aun"]                                 = {"data_type"=>"int", "file_field"=>"attributed_district_aun"} if field_order.push("attributed_district_aun")
            structure_hash["fields"]["attributed_district_name"]                                = {"data_type"=>"text", "file_field"=>"attributed_district_name"} if field_order.push("attributed_district_name")
            structure_hash["fields"]["attributed_school_code"]                                  = {"data_type"=>"int", "file_field"=>"attributed_school_code"} if field_order.push("attributed_school_code")
            structure_hash["fields"]["attributed_school_name"]                                  = {"data_type"=>"text", "file_field"=>"attributed_school_name"} if field_order.push("attributed_school_name")
            structure_hash["fields"]["drc_record_number"]                                       = {"data_type"=>"text", "file_field"=>"drc_record_number"} if field_order.push("drc_record_number")
            structure_hash["fields"]["unique_matching_id"]                                      = {"data_type"=>"int", "file_field"=>"unique_matching_id"} if field_order.push("unique_matching_id")
            structure_hash["fields"]["pasecureid"]                                              = {"data_type"=>"int", "file_field"=>"pasecureid"} if field_order.push("pasecureid")
            structure_hash["fields"]["local_student_id"]                                        = {"data_type"=>"int", "file_field"=>"local_student_id"} if field_order.push("local_student_id")
            structure_hash["fields"]["id_check"]                                                = {"data_type"=>"int", "file_field"=>"id_check"} if field_order.push("id_check")
            structure_hash["fields"]["student_last_name"]                                       = {"data_type"=>"text", "file_field"=>"student_last_name"} if field_order.push("student_last_name")
            structure_hash["fields"]["last_check"]                                              = {"data_type"=>"text", "file_field"=>"last_check"} if field_order.push("last_check")
            structure_hash["fields"]["student_first_name"]                                      = {"data_type"=>"text", "file_field"=>"student_first_name"} if field_order.push("student_first_name")
            structure_hash["fields"]["first_check"]                                             = {"data_type"=>"text", "file_field"=>"first_check"} if field_order.push("first_check")
            structure_hash["fields"]["student_middle_initial"]                                  = {"data_type"=>"text", "file_field"=>"student_middle_initial"} if field_order.push("student_middle_initial")
            structure_hash["fields"]["birthdate"]                                               = {"data_type"=>"text", "file_field"=>"birthdate"} if field_order.push("birthdate")
            structure_hash["fields"]["override_flag"]                                           = {"data_type"=>"bool", "file_field"=>"override_flag"} if field_order.push("override_flag")
            structure_hash["fields"]["grade"]                                                   = {"data_type"=>"int", "file_field"=>"grade"} if field_order.push("grade")
            structure_hash["fields"]["tested_year"]                                             = {"data_type"=>"year", "file_field"=>"tested_year"} if field_order.push("tested_year")
            structure_hash["fields"]["math_tested_flag"]                                        = {"data_type"=>"bool", "file_field"=>"math_tested_flag"} if field_order.push("math_tested_flag")
            structure_hash["fields"]["reading_tested_flag"]                                     = {"data_type"=>"bool", "file_field"=>"reading_tested_flag"} if field_order.push("reading_tested_flag")
            structure_hash["fields"]["science_tested_flag"]                                     = {"data_type"=>"bool", "file_field"=>"science_tested_flag"} if field_order.push("science_tested_flag")
            structure_hash["fields"]["writing_tested_flag"]                                     = {"data_type"=>"bool", "file_field"=>"writing_tested_flag"} if field_order.push("writing_tested_flag")
            structure_hash["fields"]["pasa_record"]                                             = {"data_type"=>"bool", "file_field"=>"pasa_record"} if field_order.push("pasa_record")
            structure_hash["fields"]["pssa_m_record"]                                           = {"data_type"=>"bool", "file_field"=>"pssa_m_record"} if field_order.push("pssa_m_record")
            structure_hash["fields"]["schl_attribution_flag"]                                   = {"data_type"=>"bool", "file_field"=>"schl_attribution_flag"} if field_order.push("schl_attribution_flag")
            structure_hash["fields"]["dist_attribution_flag"]                                   = {"data_type"=>"bool", "file_field"=>"dist_attribution_flag"} if field_order.push("dist_attribution_flag")
            structure_hash["fields"]["state_attribution_flag"]                                  = {"data_type"=>"bool", "file_field"=>"state_attribution_flag"} if field_order.push("state_attribution_flag")
            structure_hash["fields"]["school_performance_school_flag"]                          = {"data_type"=>"bool", "file_field"=>"school_performance_school_flag"} if field_order.push("school_performance_school_flag")
            structure_hash["fields"]["district_performance_district_flag"]                      = {"data_type"=>"bool", "file_field"=>"district_performance_district_flag"} if field_order.push("district_performance_district_flag")
            structure_hash["fields"]["state_performance_state_flag"]                            = {"data_type"=>"bool", "file_field"=>"state_performance_state_flag"} if field_order.push("state_performance_state_flag")
            structure_hash["fields"]["ctc_schl_attribution_flag"]                               = {"data_type"=>"bool", "file_field"=>"ctc_schl_attribution_flag"} if field_order.push("ctc_schl_attribution_flag")
            structure_hash["fields"]["ctc_dist_attribution_flag"]                               = {"data_type"=>"bool", "file_field"=>"ctc_dist_attribution_flag"} if field_order.push("ctc_dist_attribution_flag")
            structure_hash["fields"]["ctc_state_attribution_flag"]                              = {"data_type"=>"bool", "file_field"=>"ctc_state_attribution_flag"} if field_order.push("ctc_state_attribution_flag")
            structure_hash["fields"]["ctc_schl_performance_flag"]                               = {"data_type"=>"bool", "file_field"=>"ctc_schl_performance_flag"} if field_order.push("ctc_schl_performance_flag")
            structure_hash["fields"]["ctc_dist_performance_flag"]                               = {"data_type"=>"bool", "file_field"=>"ctc_dist_performance_flag"} if field_order.push("ctc_dist_performance_flag")
            structure_hash["fields"]["ctc_state_performance_flag"]                              = {"data_type"=>"bool", "file_field"=>"ctc_state_performance_flag"} if field_order.push("ctc_state_performance_flag")
            structure_hash["fields"]["ethnicity_code"]                                          = {"data_type"=>"int", "file_field"=>"ethnicity_code"} if field_order.push("ethnicity_code")
            structure_hash["fields"]["iep_not_gifted"]                                          = {"data_type"=>"bool", "file_field"=>"iep_not_gifted"} if field_order.push("iep_not_gifted")
            structure_hash["fields"]["iep_exited"]                                              = {"data_type"=>"bool", "file_field"=>"iep_exited"} if field_order.push("iep_exited")
            structure_hash["fields"]["ell_not_in_1st_yr"]                                       = {"data_type"=>"bool", "file_field"=>"ell_not_in_1st_yr"} if field_order.push("ell_not_in_1st_yr")
            structure_hash["fields"]["ell_in_1st_yr"]                                           = {"data_type"=>"bool", "file_field"=>"ell_in_1st_yr"} if field_order.push("ell_in_1st_yr")
            structure_hash["fields"]["ell_exited_esl_prgm_1st_yr"]                              = {"data_type"=>"bool", "file_field"=>"ell_exited_esl_prgm_1st_yr"} if field_order.push("ell_exited_esl_prgm_1st_yr")
            structure_hash["fields"]["ell_exited_esl_prgm_2nd_yr"]                              = {"data_type"=>"bool", "file_field"=>"ell_exited_esl_prgm_2nd_yr"} if field_order.push("ell_exited_esl_prgm_2nd_yr")
            structure_hash["fields"]["ell_former"]                                              = {"data_type"=>"bool", "file_field"=>"ell_former"} if field_order.push("ell_former")
            structure_hash["fields"]["economically_disadvantaged"]                              = {"data_type"=>"bool", "file_field"=>"economically_disadvantaged"} if field_order.push("economically_disadvantaged")
            structure_hash["fields"]["schl_participation_documents_returned"]                   = {"data_type"=>"bool", "file_field"=>"schl_participation_documents_returned"} if field_order.push("schl_participation_documents_returned")
            structure_hash["fields"]["schl_participation_documents_scored"]                     = {"data_type"=>"bool", "file_field"=>"schl_participation_documents_scored"} if field_order.push("schl_participation_documents_scored")
            structure_hash["fields"]["dist_participation_documents_returned"]                   = {"data_type"=>"bool", "file_field"=>"dist_participation_documents_returned"} if field_order.push("dist_participation_documents_returned")
            structure_hash["fields"]["dist_participation_documents_scored"]                     = {"data_type"=>"bool", "file_field"=>"dist_participation_documents_scored"} if field_order.push("dist_participation_documents_scored")
            structure_hash["fields"]["state_participation_documents_returned"]                  = {"data_type"=>"bool", "file_field"=>"state_participation_documents_returned"} if field_order.push("state_participation_documents_returned")
            structure_hash["fields"]["state_participation_documents_scored"]                    = {"data_type"=>"bool", "file_field"=>"state_participation_documents_scored"} if field_order.push("state_participation_documents_scored")
            structure_hash["fields"]["scaled_score"]                                            = {"data_type"=>"int", "file_field"=>"scaled_score"} if field_order.push("scaled_score")
            structure_hash["fields"]["performance_level_code"]                                  = {"data_type"=>"int", "file_field"=>"performance_level_code"} if field_order.push("performance_level_code")
            structure_hash["fields"]["performance_level_name"]                                  = {"data_type"=>"text", "file_field"=>"performance_level_name"} if field_order.push("performance_level_name")
            structure_hash["fields"]["projected_performance_level"]                             = {"data_type"=>"int", "file_field"=>"projected_performance_level"} if field_order.push("projected_performance_level")
            structure_hash["fields"]["ayp_performance_level"]                                   = {"data_type"=>"int", "file_field"=>"ayp_performance_level"} if field_order.push("ayp_performance_level")
            structure_hash["fields"]["redistribution_flag"]                                     = {"data_type"=>"bool", "file_field"=>"redistribution_flag"} if field_order.push("redistribution_flag")
            structure_hash["fields"]["tested_district_aun"]                                     = {"data_type"=>"int", "file_field"=>"tested_district_aun"} if field_order.push("tested_district_aun")
            structure_hash["fields"]["tested_school_code"]                                      = {"data_type"=>"int", "file_field"=>"tested_school_code"} if field_order.push("tested_school_code")
            structure_hash["fields"]["tested_school_name"]                                      = {"data_type"=>"text", "file_field"=>"tested_school_name"} if field_order.push("tested_school_name")
            structure_hash["fields"]["exclusion_medical_emergency"]                             = {"data_type"=>"int", "file_field"=>"exclusion_medical_emergency"} if field_order.push("exclusion_medical_emergency")
            structure_hash["fields"]["exclusion_parental_request"]                              = {"data_type"=>"int", "file_field"=>"exclusion_parental_request"} if field_order.push("exclusion_parental_request")
            structure_hash["fields"]["exclusion_extended_absence"]                              = {"data_type"=>"int", "file_field"=>"exclusion_extended_absence"} if field_order.push("exclusion_extended_absence")
            structure_hash["fields"]["exclusion_other"]                                         = {"data_type"=>"int", "file_field"=>"exclusion_other"} if field_order.push("exclusion_other")
            structure_hash["fields"]["student_was_absent_w_o_makeup"]                           = {"data_type"=>"int", "file_field"=>"student_was_absent_w_o_makeup"} if field_order.push("student_was_absent_w_o_makeup")
            structure_hash["fields"]["exclusion_codes"]                                         = {"data_type"=>"int", "file_field"=>"exclusion_codes"} if field_order.push("exclusion_codes")
            structure_hash["fields"]["total_raw_score"]                                         = {"data_type"=>"int", "file_field"=>"total_raw_score"} if field_order.push("total_raw_score")
            structure_hash["fields"]["multiple_choice_raw_score"]                               = {"data_type"=>"int", "file_field"=>"multiple_choice_raw_score"} if field_order.push("multiple_choice_raw_score")
            structure_hash["fields"]["open_ended_raw_score"]                                    = {"data_type"=>"int", "file_field"=>"open_ended_raw_score"} if field_order.push("open_ended_raw_score")
            structure_hash["fields"]["prompt_1_composition_score"]                              = {"data_type"=>"int", "file_field"=>"prompt_1_composition_score"} if field_order.push("prompt_1_composition_score")
            structure_hash["fields"]["prompt_1_revise_edit_score"]                              = {"data_type"=>"int", "file_field"=>"prompt_1_revise_edit_score"} if field_order.push("prompt_1_revise_edit_score")
            structure_hash["fields"]["prompt_3_composition_score"]                              = {"data_type"=>"int", "file_field"=>"prompt_3_composition_score"} if field_order.push("prompt_3_composition_score")
            structure_hash["fields"]["prompt_3_revise_edit_score"]                              = {"data_type"=>"int", "file_field"=>"prompt_3_revise_edit_score"} if field_order.push("prompt_3_revise_edit_score")
            structure_hash["fields"]["reporting_category_a_raw_score"]                          = {"data_type"=>"int", "file_field"=>"reporting_category_a_raw_score"} if field_order.push("reporting_category_a_raw_score")
            structure_hash["fields"]["reporting_category_b_raw_score"]                          = {"data_type"=>"int", "file_field"=>"reporting_category_b_raw_score"} if field_order.push("reporting_category_b_raw_score")
            structure_hash["fields"]["reporting_category_c_raw_score"]                          = {"data_type"=>"int", "file_field"=>"reporting_category_c_raw_score"} if field_order.push("reporting_category_c_raw_score")
            structure_hash["fields"]["reporting_category_d_raw_score"]                          = {"data_type"=>"int", "file_field"=>"reporting_category_d_raw_score"} if field_order.push("reporting_category_d_raw_score")
            structure_hash["fields"]["reporting_category_e_raw_score"]                          = {"data_type"=>"int", "file_field"=>"reporting_category_e_raw_score"} if field_order.push("reporting_category_e_raw_score")
            structure_hash["fields"]["reporting_category_a_strength_profile"]                   = {"data_type"=>"text", "file_field"=>"reporting_category_a_strength_profile"} if field_order.push("reporting_category_a_strength_profile")
            structure_hash["fields"]["reporting_category_b_strength_profile"]                   = {"data_type"=>"text", "file_field"=>"reporting_category_b_strength_profile"} if field_order.push("reporting_category_b_strength_profile")
            structure_hash["fields"]["reporting_category_c_strength_profile"]                   = {"data_type"=>"text", "file_field"=>"reporting_category_c_strength_profile"} if field_order.push("reporting_category_c_strength_profile")
            structure_hash["fields"]["reporting_category_d_strength_profile"]                   = {"data_type"=>"text", "file_field"=>"reporting_category_d_strength_profile"} if field_order.push("reporting_category_d_strength_profile")
            structure_hash["fields"]["reporting_category_e_strength_profile"]                   = {"data_type"=>"text", "file_field"=>"reporting_category_e_strength_profile"} if field_order.push("reporting_category_e_strength_profile")
            structure_hash["fields"]["gender"]                                                  = {"data_type"=>"text", "file_field"=>"gender"} if field_order.push("gender")
            structure_hash["fields"]["title_i"]                                                 = {"data_type"=>"text", "file_field"=>"title_i"} if field_order.push("title_i")
            structure_hash["fields"]["migratory_child"]                                         = {"data_type"=>"text", "file_field"=>"migratory_child"} if field_order.push("migratory_child")
            structure_hash["fields"]["title_iii"]                                               = {"data_type"=>"int", "file_field"=>"title_iii"} if field_order.push("title_iii")
            structure_hash["fields"]["foreign_exchange_student"]                                = {"data_type"=>"bool", "file_field"=>"foreign_exchange_student"} if field_order.push("foreign_exchange_student")
            structure_hash["fields"]["enrolled_after_oct_1_2010_schl"]                          = {"data_type"=>"bool", "file_field"=>"enrolled_after_oct_1_2010_schl"} if field_order.push("enrolled_after_oct_1_2010_schl")
            structure_hash["fields"]["enrolled_after_oct_1_2010_dist"]                          = {"data_type"=>"bool", "file_field"=>"enrolled_after_oct_1_2010_dist"} if field_order.push("enrolled_after_oct_1_2010_dist")
            structure_hash["fields"]["pa_resident_after_oct_1_2010"]                            = {"data_type"=>"bool", "file_field"=>"pa_resident_after_oct_1_2010"} if field_order.push("pa_resident_after_oct_1_2010")
            structure_hash["fields"]["enrol_after_oct_1_2009_on_or_before_oct_1_2010_sch"]      = {"data_type"=>"bool", "file_field"=>"enrol_after_oct_1_2009_on_or_before_oct_1_2010_sch"} if field_order.push("enrol_after_oct_1_2009_on_or_before_oct_1_2010_sch")
            structure_hash["fields"]["enrol_after_oct_1_2009_on_or_before_oct_1_2010_dist"]     = {"data_type"=>"bool", "file_field"=>"enrol_after_oct_1_2009_on_or_before_oct_1_2010_dist"} if field_order.push("enrol_after_oct_1_2009_on_or_before_oct_1_2010_dist")
            structure_hash["fields"]["attrb_court_agency_placed_participated"]                  = {"data_type"=>"bool", "file_field"=>"attrb_court_agency_placed_participated"} if field_order.push("attrb_court_agency_placed_participated")
            structure_hash["fields"]["ctc_district_of_residence"]                               = {"data_type"=>"text", "file_field"=>"ctc_district_of_residence"} if field_order.push("ctc_district_of_residence")
            structure_hash["fields"]["braille_format"]                                          = {"data_type"=>"bool", "file_field"=>"braille_format"} if field_order.push("braille_format")
            structure_hash["fields"]["audio_cd"]                                                = {"data_type"=>"bool", "file_field"=>"audio_cd"} if field_order.push("audio_cd")
            structure_hash["fields"]["large_print_format"]                                      = {"data_type"=>"bool", "file_field"=>"large_print_format"} if field_order.push("large_print_format")
            structure_hash["fields"]["large_print_format_electronic_screen_reader"]             = {"data_type"=>"bool", "file_field"=>"large_print_format_electronic_screen_reader"} if field_order.push("large_print_format_electronic_screen_reader")
            structure_hash["fields"]["test_directions_read_aloud"]                              = {"data_type"=>"bool", "file_field"=>"test_directions_read_aloud"} if field_order.push("test_directions_read_aloud")
            structure_hash["fields"]["test_directions_signed_or_recorded"]                      = {"data_type"=>"bool", "file_field"=>"test_directions_signed_or_recorded"} if field_order.push("test_directions_signed_or_recorded")
            structure_hash["fields"]["test_items_questions_read_aloud"]                         = {"data_type"=>"bool", "file_field"=>"test_items_questions_read_aloud"} if field_order.push("test_items_questions_read_aloud")
            structure_hash["fields"]["test_items_questions_signed_or_recorded"]                 = {"data_type"=>"bool", "file_field"=>"test_items_questions_signed_or_recorded"} if field_order.push("test_items_questions_signed_or_recorded")
            structure_hash["fields"]["writing_prompts_read_aloud"]                              = {"data_type"=>"bool", "file_field"=>"writing_prompts_read_aloud"} if field_order.push("writing_prompts_read_aloud")
            structure_hash["fields"]["writing_prompts_signed_or_recorded"]                      = {"data_type"=>"bool", "file_field"=>"writing_prompts_signed_or_recorded"} if field_order.push("writing_prompts_signed_or_recorded")
            structure_hash["fields"]["amplification_device"]                                    = {"data_type"=>"bool", "file_field"=>"amplification_device"} if field_order.push("amplification_device")
            structure_hash["fields"]["magnification_device"]                                    = {"data_type"=>"bool", "file_field"=>"magnification_device"} if field_order.push("magnification_device")
            structure_hash["fields"]["reading_windows_reading_guides"]                          = {"data_type"=>"bool", "file_field"=>"reading_windows_reading_guides"} if field_order.push("reading_windows_reading_guides")
            structure_hash["fields"]["reading_windows_reading_guides_other"]                    = {"data_type"=>"bool", "file_field"=>"reading_windows_reading_guides_other"} if field_order.push("reading_windows_reading_guides_other")
            structure_hash["fields"]["spanish_version"]                                         = {"data_type"=>"bool", "file_field"=>"spanish_version"} if field_order.push("spanish_version")
            structure_hash["fields"]["hospital_home_setting"]                                   = {"data_type"=>"bool", "file_field"=>"hospital_home_setting"} if field_order.push("hospital_home_setting")
            structure_hash["fields"]["tested_in_separate_room"]                                 = {"data_type"=>"bool", "file_field"=>"tested_in_separate_room"} if field_order.push("tested_in_separate_room")
            structure_hash["fields"]["small_group_testing"]                                     = {"data_type"=>"bool", "file_field"=>"small_group_testing"} if field_order.push("small_group_testing")
            structure_hash["fields"]["small_group_testing_other"]                               = {"data_type"=>"bool", "file_field"=>"small_group_testing_other"} if field_order.push("small_group_testing_other")
            structure_hash["fields"]["test_administrator_marks_test"]                           = {"data_type"=>"bool", "file_field"=>"test_administrator_marks_test"} if field_order.push("test_administrator_marks_test")
            structure_hash["fields"]["test_administrator_scribed_oe"]                           = {"data_type"=>"bool", "file_field"=>"test_administrator_scribed_oe"} if field_order.push("test_administrator_scribed_oe")
            structure_hash["fields"]["test_administrator_transcribed"]                          = {"data_type"=>"bool", "file_field"=>"test_administrator_transcribed"} if field_order.push("test_administrator_transcribed")
            structure_hash["fields"]["qualified_interpreter_translated"]                        = {"data_type"=>"bool", "file_field"=>"qualified_interpreter_translated"} if field_order.push("qualified_interpreter_translated")
            structure_hash["fields"]["typewriter_word_processor_or_computer_used"]              = {"data_type"=>"bool", "file_field"=>"typewriter_word_processor_or_computer_used"} if field_order.push("typewriter_word_processor_or_computer_used")
            structure_hash["fields"]["brailler_note_taker"]                                     = {"data_type"=>"bool", "file_field"=>"brailler_note_taker"} if field_order.push("brailler_note_taker")
            structure_hash["fields"]["augmentative_communication_device"]                       = {"data_type"=>"bool", "file_field"=>"augmentative_communication_device"} if field_order.push("augmentative_communication_device")
            structure_hash["fields"]["audio_recording"]                                         = {"data_type"=>"bool", "file_field"=>"audio_recording"} if field_order.push("audio_recording")
            structure_hash["fields"]["audio_recording_electronic_screen_reader"]                = {"data_type"=>"bool", "file_field"=>"audio_recording_electronic_screen_reader"} if field_order.push("audio_recording_electronic_screen_reader")
            structure_hash["fields"]["manipulative_device"]                                     = {"data_type"=>"bool", "file_field"=>"manipulative_device"} if field_order.push("manipulative_device")
            structure_hash["fields"]["translation_dictionary"]                                  = {"data_type"=>"bool", "file_field"=>"translation_dictionary"} if field_order.push("translation_dictionary")
            structure_hash["fields"]["translation_dictionary_other"]                            = {"data_type"=>"bool", "file_field"=>"translation_dictionary_other"} if field_order.push("translation_dictionary_other")
            structure_hash["fields"]["scheduled_extended_time"]                                 = {"data_type"=>"bool", "file_field"=>"scheduled_extended_time"} if field_order.push("scheduled_extended_time")
            structure_hash["fields"]["student_requested_extended_time"]                         = {"data_type"=>"bool", "file_field"=>"student_requested_extended_time"} if field_order.push("student_requested_extended_time")
            structure_hash["fields"]["multiple_test_sessions"]                                  = {"data_type"=>"bool", "file_field"=>"multiple_test_sessions"} if field_order.push("multiple_test_sessions")
            structure_hash["fields"]["changed_test_schedule"]                                   = {"data_type"=>"bool", "file_field"=>"changed_test_schedule"} if field_order.push("changed_test_schedule")
            structure_hash["fields"]["home_school_student"]                                     = {"data_type"=>"bool", "file_field"=>"home_school_student"} if field_order.push("home_school_student")
            structure_hash["fields"]["home_school_receives_public_education"]                   = {"data_type"=>"bool", "file_field"=>"home_school_receives_public_education"} if field_order.push("home_school_receives_public_education")
            structure_hash["fields"]["anchor_a_1"]                                              = {"data_type"=>"int", "file_field"=>"anchor_a_1"} if field_order.push("anchor_a_1")
            structure_hash["fields"]["anchor_a_2"]                                              = {"data_type"=>"int", "file_field"=>"anchor_a_2"} if field_order.push("anchor_a_2")
            structure_hash["fields"]["anchor_a_3"]                                              = {"data_type"=>"int", "file_field"=>"anchor_a_3"} if field_order.push("anchor_a_3")
            structure_hash["fields"]["anchor_b_1"]                                              = {"data_type"=>"int", "file_field"=>"anchor_b_1"} if field_order.push("anchor_b_1")
            structure_hash["fields"]["anchor_b_2"]                                              = {"data_type"=>"int", "file_field"=>"anchor_b_2"} if field_order.push("anchor_b_2")
            structure_hash["fields"]["anchor_b_3"]                                              = {"data_type"=>"int", "file_field"=>"anchor_b_3"} if field_order.push("anchor_b_3")
            structure_hash["fields"]["anchor_c_1"]                                              = {"data_type"=>"int", "file_field"=>"anchor_c_1"} if field_order.push("anchor_c_1")
            structure_hash["fields"]["anchor_c_2"]                                              = {"data_type"=>"int", "file_field"=>"anchor_c_2"} if field_order.push("anchor_c_2")
            structure_hash["fields"]["anchor_c_3"]                                              = {"data_type"=>"int", "file_field"=>"anchor_c_3"} if field_order.push("anchor_c_3")
            structure_hash["fields"]["anchor_d_1"]                                              = {"data_type"=>"int", "file_field"=>"anchor_d_1"} if field_order.push("anchor_d_1")
            structure_hash["fields"]["anchor_d_2"]                                              = {"data_type"=>"int", "file_field"=>"anchor_d_2"} if field_order.push("anchor_d_2")
            structure_hash["fields"]["anchor_d_3"]                                              = {"data_type"=>"int", "file_field"=>"anchor_d_3"} if field_order.push("anchor_d_3")
            structure_hash["fields"]["anchor_d_4"]                                              = {"data_type"=>"int", "file_field"=>"anchor_d_4"} if field_order.push("anchor_d_4")
            structure_hash["fields"]["anchor_e_1"]                                              = {"data_type"=>"int", "file_field"=>"anchor_e_1"} if field_order.push("anchor_e_1")
            structure_hash["fields"]["anchor_e_2"]                                              = {"data_type"=>"int", "file_field"=>"anchor_e_2"} if field_order.push("anchor_e_2")
            structure_hash["fields"]["anchor_e_3"]                                              = {"data_type"=>"int", "file_field"=>"anchor_e_3"} if field_order.push("anchor_e_3")
            structure_hash["fields"]["anchor_e_4"]                                              = {"data_type"=>"int", "file_field"=>"anchor_e_4"} if field_order.push("anchor_e_4")
            structure_hash["fields"]["optional_field_1"]                                        = {"data_type"=>"bool", "file_field"=>"optional_field_1"} if field_order.push("optional_field_1")
            structure_hash["fields"]["optional_field_2"]                                        = {"data_type"=>"bool", "file_field"=>"optional_field_2"} if field_order.push("optional_field_2")
            structure_hash["fields"]["optional_field_3"]                                        = {"data_type"=>"bool", "file_field"=>"optional_field_3"} if field_order.push("optional_field_3")
            structure_hash["fields"]["optional_field_4"]                                        = {"data_type"=>"bool", "file_field"=>"optional_field_4"} if field_order.push("optional_field_4")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end