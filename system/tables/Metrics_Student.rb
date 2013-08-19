#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class METRICS_STUDENT < Athena_Table
    
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

    def by_studentid_old(arg, created_date = nil) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("created_date", "REGEXP", "#{created_date}.*") ) if created_date
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "metrics_student",
                "file_name"         => "metrics_student.csv",
                "file_location"     => "metrics_student",
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
            structure_hash["fields"]["student_id"]                      = {"data_type"=>"int",          "file_field"=>"student_id"} if field_order.push("student_id")
            structure_hash["fields"]["family_id"]                       = {"data_type"=>"int",          "file_field"=>"family_id"} if field_order.push("family_id")
            structure_hash["fields"]["first_name"]                      = {"data_type"=>"text",         "file_field"=>"first_name"} if field_order.push("first_name")
            structure_hash["fields"]["last_name"]                       = {"data_type"=>"text",         "file_field"=>"last_name"} if field_order.push("last_name")
            structure_hash["fields"]["birthday"]                        = {"data_type"=>"date",         "file_field"=>"birthday"} if field_order.push("birthday")
            structure_hash["fields"]["age"]                             = {"data_type"=>"int",          "file_field"=>"age"} if field_order.push("age")
            structure_hash["fields"]["phone"]                           = {"data_type"=>"text",         "file_field"=>"phone"} if field_order.push("phone")
            structure_hash["fields"]["address"]                         = {"data_type"=>"text",         "file_field"=>"address"} if field_order.push("address")
            structure_hash["fields"]["city"]                            = {"data_type"=>"text",         "file_field"=>"city"} if field_order.push("city")
            structure_hash["fields"]["zip_code"]                        = {"data_type"=>"text",         "file_field"=>"zip_code"} if field_order.push("zip_code")
            structure_hash["fields"]["learning_coach"]                  = {"data_type"=>"text",         "file_field"=>"learning_coach"} if field_order.push("learning_coach")
            structure_hash["fields"]["learning_coach_relation"]         = {"data_type"=>"text",         "file_field"=>"learning_coach_relation"} if field_order.push("learning_coach_relation")
            structure_hash["fields"]["guardian"]                        = {"data_type"=>"text",         "file_field"=>"guardian"} if field_order.push("guardian")
            structure_hash["fields"]["guardian_relation"]               = {"data_type"=>"text",         "file_field"=>"guardian_relation"} if field_order.push("guardian_relation")
            structure_hash["fields"]["grade_level"]                     = {"data_type"=>"text",         "file_field"=>"grade_level"} if field_order.push("grade_level")
            structure_hash["fields"]["school_enroll_date"]              = {"data_type"=>"date",         "file_field"=>"school_enroll_date"} if field_order.push("school_enroll_date")
            structure_hash["fields"]["is_special_ed"]                   = {"data_type"=>"bool",         "file_field"=>"is_special_ed"} if field_order.push("is_special_ed")
            structure_hash["fields"]["freeandreducedmeals"]             = {"data_type"=>"bool",         "file_field"=>"freeandreducedmeals"} if field_order.push("freeandreducedmeals")
            structure_hash["fields"]["engage_rate"]                     = {"data_type"=>"decimal(5,4)", "file_field"=>"engage_rate"} if field_order.push("engage_rate")
            structure_hash["fields"]["attendance_unexcused"]            = {"data_type"=>"int",          "file_field"=>"attendance_unexcused"} if field_order.push("attendance_unexcused")
            structure_hash["fields"]["attendance_recent"]               = {"data_type"=>"decimal(5,4)", "file_field"=>"attendance_recent"} if field_order.push("attendance_recent")
            structure_hash["fields"]["attendance_overall"]              = {"data_type"=>"decimal(5,4)", "file_field"=>"attendance_overall"} if field_order.push("attendance_overall")
            structure_hash["fields"]["days_enrolled"]                   = {"data_type"=>"int",          "file_field"=>"days_enrolled"} if field_order.push("days_enrolled")
            structure_hash["fields"]["lcenter_status"]                  = {"data_type"=>"bool",         "file_field"=>"lcenter_status"} if field_order.push("lcenter_status")
            structure_hash["fields"]["lcenter_start_date"]              = {"data_type"=>"date",         "file_field"=>"lcenter_start_date"} if field_order.push("lcenter_start_date")
            structure_hash["fields"]["iep_status"]                      = {"data_type"=>"bool",         "file_field"=>"iep_status"} if field_order.push("iep_status")
            structure_hash["fields"]["iep_date"]                        = {"data_type"=>"date",         "file_field"=>"iep_date"} if field_order.push("iep_date")
            structure_hash["fields"]["alp_status"]                      = {"data_type"=>"bool",         "file_field"=>"alp_status"} if field_order.push("alp_status")
            structure_hash["fields"]["alp_start_date"]                  = {"data_type"=>"date",         "file_field"=>"alp_start_date"} if field_order.push("alp_start_date")
            structure_hash["fields"]["cohort_year"]                     = {"data_type"=>"year",         "file_field"=>"cohort_year"} if field_order.push("cohort_year")
            structure_hash["fields"]["ppid"]                            = {"data_type"=>"int",          "file_field"=>"ppid"} if field_order.push("ppid")
            structure_hash["fields"]["gender"]                          = {"data_type"=>"text",         "file_field"=>"gender"} if field_order.push("gender")
            structure_hash["fields"]["has_504"]                         = {"data_type"=>"bool",         "file_field"=>"has_504"} if field_order.push("has_504")
            structure_hash["fields"]["retention"]                       = {"data_type"=>"decimal(5,4)", "file_field"=>"retention"} if field_order.push("retention")
            structure_hash["fields"]["academic_risk_level"]             = {"data_type"=>"int",          "file_field"=>"academic_risk_level"} if field_order.push("academic_risk_level")
            structure_hash["fields"]["engagement_risk_level"]           = {"data_type"=>"int",          "file_field"=>"engagement_risk_level"} if field_order.push("engagement_risk_level")
            structure_hash["fields"]["overall_risk_level"]              = {"data_type"=>"int",          "file_field"=>"overall_risk_level"} if field_order.push("overall_risk_level")
            structure_hash["fields"]["assess_part_m"]                   = {"data_type"=>"decimal(5,4)", "file_field"=>"assess_part_m"} if field_order.push("assess_part_m")
            structure_hash["fields"]["assess_avg_m"]                    = {"data_type"=>"decimal(5,4)", "file_field"=>"assess_avg_m"} if field_order.push("assess_avg_m")
            structure_hash["fields"]["assess_part_r"]                   = {"data_type"=>"decimal(5,4)", "file_field"=>"assess_part_r"} if field_order.push("assess_part_r")
            structure_hash["fields"]["assess_avg_r"]                    = {"data_type"=>"decimal(5,4)", "file_field"=>"assess_avg_r"} if field_order.push("assess_avg_r")
            structure_hash["fields"]["sti_offered_m"]                   = {"data_type"=>"int",          "file_field"=>"sti_offered_m"} if field_order.push("sti_offered_m")
            structure_hash["fields"]["sti_missed_m"]                    = {"data_type"=>"int",          "file_field"=>"sti_missed_m"} if field_order.push("sti_missed_m")
            structure_hash["fields"]["sti_attended_m"]                  = {"data_type"=>"int",          "file_field"=>"sti_attended_m"} if field_order.push("sti_attended_m")
            structure_hash["fields"]["sti_offered_r"]                   = {"data_type"=>"int",          "file_field"=>"sti_offered_r"} if field_order.push("sti_offered_r")
            structure_hash["fields"]["sti_missed_r"]                    = {"data_type"=>"int",          "file_field"=>"sti_missed_r"} if field_order.push("sti_missed_r")
            structure_hash["fields"]["sti_attended_r"]                  = {"data_type"=>"int",          "file_field"=>"sti_attended_r"} if field_order.push("sti_attended_r")
            structure_hash["fields"]["sti_offered_s"]                   = {"data_type"=>"int",          "file_field"=>"sti_offered_s"} if field_order.push("sti_offered_s")
            structure_hash["fields"]["sti_missed_s"]                    = {"data_type"=>"int",          "file_field"=>"sti_missed_s"} if field_order.push("sti_missed_s")
            structure_hash["fields"]["sti_attended_s"]                  = {"data_type"=>"int",          "file_field"=>"sti_attended_s"} if field_order.push("sti_attended_s")
            structure_hash["fields"]["sti_offered_overall"]             = {"data_type"=>"int",          "file_field"=>"sti_offered_overall"} if field_order.push("sti_offered_overall")
            structure_hash["fields"]["sti_missed_overall"]              = {"data_type"=>"int",          "file_field"=>"sti_missed_overall"} if field_order.push("sti_missed_overall")
            structure_hash["fields"]["sti_attended_overall"]            = {"data_type"=>"int",          "file_field"=>"sti_attended_overall"} if field_order.push("sti_attended_overall")
            structure_hash["fields"]["sti_offered_hv"]                  = {"data_type"=>"int",          "file_field"=>"sti_offered_hv"} if field_order.push("sti_offered_hv")
            structure_hash["fields"]["sti_missed_hv"]                   = {"data_type"=>"int",          "file_field"=>"sti_missed_hv"} if field_order.push("sti_missed_hv")
            structure_hash["fields"]["sti_attended_hv"]                 = {"data_type"=>"int",          "file_field"=>"sti_attended_hv"} if field_order.push("sti_attended_hv")
            structure_hash["fields"]["sti_offered_pc"]                  = {"data_type"=>"int",          "file_field"=>"sti_offered_pc"} if field_order.push("sti_offered_pc")
            structure_hash["fields"]["sti_missed_pc"]                   = {"data_type"=>"int",          "file_field"=>"sti_missed_pc"} if field_order.push("sti_missed_pc")
            structure_hash["fields"]["sti_attended_pc"]                 = {"data_type"=>"int",          "file_field"=>"sti_attended_pc"} if field_order.push("sti_attended_pc")
            structure_hash["fields"]["rtii_tier_level_m"]               = {"data_type"=>"text",         "file_field"=>"rtii_tier_level_m"} if field_order.push("rtii_tier_level_m")
            structure_hash["fields"]["rtii_last_reviewed_m"]            = {"data_type"=>"date",         "file_field"=>"rtii_last_reviewed_m"} if field_order.push("rtii_last_reviewed_m")
            structure_hash["fields"]["rtii_total_actions_m"]            = {"data_type"=>"int",          "file_field"=>"rtii_total_actions_m"} if field_order.push("rtii_total_actions_m")
            structure_hash["fields"]["rtii_tier_level_r"]               = {"data_type"=>"text",         "file_field"=>"rtii_tier_level_r"} if field_order.push("rtii_tier_level_r")
            structure_hash["fields"]["rtii_last_reviewed_r"]            = {"data_type"=>"date",         "file_field"=>"rtii_last_reviewed_r"} if field_order.push("rtii_last_reviewed_r")
            structure_hash["fields"]["rtii_total_actions_r"]            = {"data_type"=>"int",          "file_field"=>"rtii_total_actions_r"} if field_order.push("rtii_total_actions_r")
            structure_hash["fields"]["specialist_r"]                    = {"data_type"=>"bool",         "file_field"=>"specialist_r"} if field_order.push("specialist_r")
            structure_hash["fields"]["specialist_start_date_r"]         = {"data_type"=>"date",         "file_field"=>"specialist_start_date_r"} if field_order.push("specialist_start_date_r")
            structure_hash["fields"]["specialist_last_contact_r"]       = {"data_type"=>"date",         "file_field"=>"specialist_last_contact_r"} if field_order.push("specialist_last_contact_r")
            structure_hash["fields"]["specialist_m"]                    = {"data_type"=>"bool",         "file_field"=>"specialist_m"} if field_order.push("specialist_m")
            structure_hash["fields"]["specialist_start_date_m"]         = {"data_type"=>"date",         "file_field"=>"specialist_start_date_m"} if field_order.push("specialist_start_date_m")
            structure_hash["fields"]["specialist_last_contact_m"]       = {"data_type"=>"date",         "file_field"=>"specialist_last_contact_m"} if field_order.push("specialist_last_contact_m")
            structure_hash["fields"]["pte_status"]                      = {"data_type"=>"bool",         "file_field"=>"pte_status"} if field_order.push("pte_status")
            structure_hash["fields"]["pte_date"]                        = {"data_type"=>"date",         "file_field"=>"pte_date"} if field_order.push("pte_date")
            structure_hash["fields"]["sync_instr_status_m"]             = {"data_type"=>"bool",         "file_field"=>"sync_instr_status_m"} if field_order.push("sync_instr_status_m")
            structure_hash["fields"]["sync_instr_status_r"]             = {"data_type"=>"bool",         "file_field"=>"sync_instr_status_r"} if field_order.push("sync_instr_status_r")
            structure_hash["fields"]["sync_instr_status_soc"]           = {"data_type"=>"bool",         "file_field"=>"sync_instr_status_soc"} if field_order.push("sync_instr_status_soc")
            structure_hash["fields"]["sync_instr_status_sci"]           = {"data_type"=>"bool",         "file_field"=>"sync_instr_status_sci"} if field_order.push("sync_instr_status_sci")
            structure_hash["fields"]["parent_training_status"]          = {"data_type"=>"bool",         "file_field"=>"parent_training_status"} if field_order.push("parent_training_status")
            structure_hash["fields"]["sap_referral"]                    = {"data_type"=>"bool",         "file_field"=>"sap_referral"} if field_order.push("sap_referral")
            structure_hash["fields"]["credit_recovery"]                 = {"data_type"=>"bool",         "file_field"=>"credit_recovery"} if field_order.push("credit_recovery")
            structure_hash["fields"]["summer_school"]                   = {"data_type"=>"bool",         "file_field"=>"summer_school"} if field_order.push("summer_school")
            structure_hash["fields"]["ses_status"]                      = {"data_type"=>"text",         "file_field"=>"ses_status"} if field_order.push("ses_status")
            structure_hash["fields"]["ses_provider"]                    = {"data_type"=>"text",         "file_field"=>"ses_provider"} if field_order.push("ses_provider")
            structure_hash["fields"]["ses_start_date"]                  = {"data_type"=>"date",         "file_field"=>"ses_start_date"} if field_order.push("ses_start_date")
            structure_hash["fields"]["ses_en_date"]                     = {"data_type"=>"date",         "file_field"=>"ses_en_date"} if field_order.push("ses_en_date")
            structure_hash["fields"]["credits_earned"]                  = {"data_type"=>"decimal(4,2)",          "file_field"=>"credits_earned"} if field_order.push("credits_earned")
            structure_hash["fields"]["credits_needed"]                  = {"data_type"=>"decimal(4,2)",          "file_field"=>"credits_needed"} if field_order.push("credits_needed")
            structure_hash["fields"]["credits_earned_unneeded"]         = {"data_type"=>"decimal(4,2)",          "file_field"=>"credits_earned_unneeded"} if field_order.push("credits_earned_unneeded")
            structure_hash["fields"]["pssa_on_file"]                    = {"data_type"=>"bool",         "file_field"=>"pssa_on_file"} if field_order.push("pssa_on_file")
            structure_hash["fields"]["pssa_test_year"]                  = {"data_type"=>"text",         "file_field"=>"pssa_test_year"} if field_order.push("pssa_test_year")
            structure_hash["fields"]["pssa_grade_when_tested"]          = {"data_type"=>"text",         "file_field"=>"pssa_grade_when_tested"} if field_order.push("pssa_grade_when_tested")
            structure_hash["fields"]["pssa_test_type_m"]                = {"data_type"=>"text",         "file_field"=>"pssa_test_type_m"} if field_order.push("pssa_test_type_m")
            structure_hash["fields"]["pssa_perform_level_m"]            = {"data_type"=>"text",         "file_field"=>"pssa_perform_level_m"} if field_order.push("pssa_perform_level_m")
            structure_hash["fields"]["pssa_score_m"]                    = {"data_type"=>"int",          "file_field"=>"pssa_score_m"} if field_order.push("pssa_score_m")
            structure_hash["fields"]["pssa_test_type_r"]                = {"data_type"=>"text",         "file_field"=>"pssa_test_type_r"} if field_order.push("pssa_test_type_r")
            structure_hash["fields"]["pssa_perform_level_r"]            = {"data_type"=>"text",         "file_field"=>"pssa_perform_level_r"} if field_order.push("pssa_perform_level_r")
            structure_hash["fields"]["pssa_score_r"]                    = {"data_type"=>"int",          "file_field"=>"pssa_score_r"} if field_order.push("pssa_score_r")
            structure_hash["fields"]["pssa_test_type_s"]                = {"data_type"=>"text",         "file_field"=>"pssa_test_type_s"} if field_order.push("pssa_test_type_s")
            structure_hash["fields"]["pssa_perform_level_s"]            = {"data_type"=>"text",         "file_field"=>"pssa_perform_level_s"} if field_order.push("pssa_perform_level_s")
            structure_hash["fields"]["pssa_score_s"]                    = {"data_type"=>"int",          "file_field"=>"pssa_score_s"} if field_order.push("pssa_score_s")
            structure_hash["fields"]["pssa_test_type_w"]                = {"data_type"=>"text",         "file_field"=>"pssa_test_type_w"} if field_order.push("pssa_test_type_w")
            structure_hash["fields"]["pssa_perform_level_w"]            = {"data_type"=>"text",         "file_field"=>"pssa_perform_level_w"} if field_order.push("pssa_perform_level_w")
            structure_hash["fields"]["pssa_score_w"]                    = {"data_type"=>"int",          "file_field"=>"pssa_score_w"} if field_order.push("pssa_score_w")
            structure_hash["fields"]["dora_doma_rcbm_level"]            = {"data_type"=>"text",         "file_field"=>"dora_doma_rcbm_level"} if field_order.push("dora_doma_rcbm_level")
            structure_hash["fields"]["dora_doma_rcbm_score"]            = {"data_type"=>"int",          "file_field"=>"dora_doma_rcbm_score"} if field_order.push("dora_doma_rcbm_score")
            structure_hash["fields"]["dora_doma_mcap_level"]            = {"data_type"=>"text",         "file_field"=>"dora_doma_mcap_level"} if field_order.push("dora_doma_mcap_level")
            structure_hash["fields"]["dora_doma_mcap_score"]            = {"data_type"=>"int",          "file_field"=>"dora_doma_mcap_score"} if field_order.push("dora_doma_mcap_score")
            structure_hash["fields"]["stron_ent_perf_m"]                = {"data_type"=>"text",         "file_field"=>"stron_ent_perf_m"} if field_order.push("stron_ent_perf_m")
            structure_hash["fields"]["stron_ent_score_m"]               = {"data_type"=>"int",          "file_field"=>"stron_ent_score_m"} if field_order.push("stron_ent_score_m")
            structure_hash["fields"]["stron_ext_perf_m"]                = {"data_type"=>"text",         "file_field"=>"stron_ext_perf_m"} if field_order.push("stron_ext_perf_m")
            structure_hash["fields"]["stron_ext_score_m"]               = {"data_type"=>"int",          "file_field"=>"stron_ext_score_m"} if field_order.push("stron_ext_score_m")
            structure_hash["fields"]["stron_ent_perf_r"]                = {"data_type"=>"text",         "file_field"=>"stron_ent_perf_r"} if field_order.push("stron_ent_perf_r")
            structure_hash["fields"]["stron_ent_score_r"]               = {"data_type"=>"int",          "file_field"=>"stron_ent_score_r"} if field_order.push("stron_ent_score_r")
            structure_hash["fields"]["stron_ext_perf_r"]                = {"data_type"=>"text",         "file_field"=>"stron_ext_perf_r"} if field_order.push("stron_ext_perf_r")
            structure_hash["fields"]["stron_ext_score_r"]               = {"data_type"=>"int",          "file_field"=>"stron_ext_score_r"} if field_order.push("stron_ext_score_r")
            structure_hash["fields"]["stron_ent_perf_s"]                = {"data_type"=>"text",         "file_field"=>"stron_ent_perf_s"} if field_order.push("stron_ent_perf_s")
            structure_hash["fields"]["stron_ent_score_s"]               = {"data_type"=>"int",          "file_field"=>"stron_ent_score_s"} if field_order.push("stron_ent_score_s")
            structure_hash["fields"]["stron_ext_perf_s"]                = {"data_type"=>"text",         "file_field"=>"stron_ext_perf_s"} if field_order.push("stron_ext_perf_s")
            structure_hash["fields"]["stron_ext_score_s"]               = {"data_type"=>"int",          "file_field"=>"stron_ext_score_s"} if field_order.push("stron_ext_score_s")
            structure_hash["fields"]["si_aplus_tbd"]                    = {"data_type"=>"int",          "file_field"=>"si_aplus_tbd"} if field_order.push("si_aplus_tbd")
            structure_hash["fields"]["iri_tested"]                      = {"data_type"=>"bool",         "file_field"=>"iri_tested"} if field_order.push("iri_tested")
            structure_hash["fields"]["iri_grade_level"]                 = {"data_type"=>"text",         "file_field"=>"iri_grade_level"} if field_order.push("iri_grade_level")
            structure_hash["fields"]["passing_rate"]                    = {"data_type"=>"decimal(5,4)", "file_field"=>"passing_rate"} if field_order.push("passing_rate")
            structure_hash["fields"]["passing_reading"]                 = {"data_type"=>"bool",         "file_field"=>"passing_reading"} if field_order.push("passing_reading")
            structure_hash["fields"]["passing_math"]                    = {"data_type"=>"bool",         "file_field"=>"passing_math"} if field_order.push("passing_math")
            structure_hash["fields"]["progress_average"]                = {"data_type"=>"decimal(5,4)", "file_field"=>"progress_average"} if field_order.push("progress_average")
            structure_hash["fields"]["wida_tested"]                     = {"data_type"=>"bool",         "file_field"=>"wida_tested"} if field_order.push("wida_tested")
            structure_hash["fields"]["wida_score"]                      = {"data_type"=>"int",          "file_field"=>"wida_score"} if field_order.push("wida_score")
            structure_hash["fields"]["wida_level"]                      = {"data_type"=>"text",         "file_field"=>"wida_level"} if field_order.push("wida_level")
            structure_hash["fields"]["ell_status"]                      = {"data_type"=>"bool",         "file_field"=>"ell_status"} if field_order.push("ell_status")
            structure_hash["fields"]["ell_level"]                       = {"data_type"=>"text",         "file_field"=>"ell_level"} if field_order.push("ell_level")
            structure_hash["fields"]["ell_start_date"]                  = {"data_type"=>"date",         "file_field"=>"ell_start_date"} if field_order.push("ell_start_date")
            structure_hash["fields"]["ell_end_date"]                    = {"data_type"=>"date",         "file_field"=>"ell_end_date"} if field_order.push("ell_end_date")
            structure_hash["fields"]["wapt_tested"]                     = {"data_type"=>"bool",         "file_field"=>"wapt_tested"} if field_order.push("wapt_tested")
            structure_hash["fields"]["wapt_level"]                      = {"data_type"=>"text",         "file_field"=>"wapt_level"} if field_order.push("wapt_level")
            structure_hash["fields"]["family_teacher_coach"]            = {"data_type"=>"text",         "file_field"=>"family_teacher_coach"} if field_order.push("family_teacher_coach")
            structure_hash["fields"]["specialed_teacher"]               = {"data_type"=>"text",         "file_field"=>"specialed_teacher"} if field_order.push("specialed_teacher")
            structure_hash["fields"]["general_ed_teacher"]               = {"data_type"=>"text",         "file_field"=>"general_ed_teacher"} if field_order.push("general_ed_teacher")
            structure_hash["fields"]["ayp_status"]                      = {"data_type"=>"bool",         "file_field"=>"ayp_status"} if field_order.push("ayp_status")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end