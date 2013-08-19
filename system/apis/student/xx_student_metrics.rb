#!/usr/local/bin/ruby

class XX_Student_Metrics

    #---------------------------------------------------------------------------
    def initialize(student_object)
        @structure   = nil
        self.student = student_object
    end
    #---------------------------------------------------------------------------
    #Dependencies:
    #Attendance_Master
    #K12_All_Students
    #K12_Omnibus
    #K12_STI_Combined
    
#Jupiter_Grades
    #K12_Aggregate_Progress
    #K12_All_Students
#K12_Calms_Aggregate_Progress
#K12_Ecollege_Detail
    #K12_Omnibus
    #K12_Transcripts
    #K12_Withdrawal
    #Scantron_Performance
    #Withdrawing
    #Withdrawing_Truancy
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def address
        line_two = student.mailing_address_line_two ? " #{student.mailing_address_line_two.value}" : ""
        return "#{student.mailing_address.value}#{line_two}"
    end

    def age
        return student.age
    end
    
#def alp_start_date
#def alp_status
#def assess_avg_m
#def assess_avg_r
#def assess_part_m
#def assess_part_r
    
    def attendance_overall
        return student.attendance.exists? ? student.attendance.rate : nil
    end
    
    def attendance_recent
        return student.attendance.exists? ? student.attendance.rate_for_previous_x(x_schooldays = 10) : nil
    end
    
    def attendance_unexcused
        return student.attendance.exists? ? student.attendance.unexcused_absences.length : nil
    end
    
    def ayp_status
        default_value = false
        results = student.ayp_student?
        return results || default_value
    end

    def birthday
        return student.birthday.value
    end
    
    def city
        return student.mailing_city.value
    end
    
    def cohort_year
        default_value = "NULL"
        results = student.cohort_year
        return results ? results.value : default_value
    end
    
#def credit_recovery

    def credits_earned
        default_value = "NULL"
        results = student.credits_earned
        return results ? results.value : default_value
    end
    
    def credits_earned_unneeded
        default_value = "NULL"
        results = student.credits_earned_unneeded
        return results ? results.value : default_value
    end
    
    #def credits_needed
    #    default_value = "NULL"
    #    results = student.credits_needed
    #    return results ? results.value : default_value
    #end

    def days_enrolled
        return student.attendance.exists? ? student.attendance.enrolled_days.length : nil
    end
    
#def dora_doma_mcap_level
#def dora_doma_mcap_score
#def dora_doma_rcbm_level
#def dora_doma_rcbm_score
#def ell_end_date
#def ell_level
#def ell_start_date

    def ell_status
        results = student.ell_status
        return results.value ? true : false
    end

#NOTE!!!! This is very important. Engagement rate needs to be identifiable.
#IDEAS:
#Attendance may not be interesting in this catagory because a student can attend and not really be engaged
#Course Activity Time Compare
#Whether they took assessment tests or not
#def engage_rate

    def family_id
        return student.family_id.value
    end
    
    def family_teacher_coach
        default_value = "NULL"
        results = student.family_teacher_coach
        return results ? results.value : default_value
    end
    
    def first_name
        return student.first_name.value
    end
    
    #def freeandreducedmeals
    #    return student.freeandreducedmeals
    #end
    
    def gender
        return student.gender.value
    end
    
    def general_ed_teacher
        default_value = "NULL"
        results = student.title_one_teacher
        return results && student.grade.value.match(/K|1st|2nd|3rd|4th|5th|6th/) ? results.value : default_value
    end
    
    def grade_level
        return student.grade.value
    end
    
    def guardian
        return "#{student.lg_first_name.value} #{student.lg_last_name.value}"
    end
    
    def guardian_relation
        return student.lg_relationship.value
    end
    
    #def has_504
    #    default_value = false
    #    results = student.has_504?
    #    return results || default_value
    #end
    
#def iep_date

    #def iep_status
    #    default_value = false
    #    results = student.has_iep?
    #    return results || default_value
    #end
    
#def iri_grade_level
#def iri_tested
#
    #def is_special_ed
    #    return student.has_specialed_teacher?
    #end
    
    def last_name
        return student.last_name.value
    end
    
#def lcenter_start_date

    def lcenter_status
        return student.lc_student?
    end
    
    def learning_coach
        return "#{student.lc_first_name.value} #{student.lc_last_name.value}"
    end
  
    def learning_coach_relation
        return student.lc_relationship.value
    end
    
#def parent_training_status
#def passing_math
#def passing_rate
#def passing_reading

    def phone
        default_value = "Not Valid"
        results = student.phone_number.value.length == 10 ? student.phone_number.value.insert(3,"-").insert(7,"-") : false
        return results || default_value
    end
    
    def ppid
        default_value = "NULL"
        results = student.ppid
        return results ? results.value : default_value
    end
    
#def progress_average

    def pssa_grade_when_tested
        default_value = "NULL"
        results = student.pssa_grade_tested
        return results ? results.value : default_value
    end

    def pssa_on_file
        return student.has_pssa_record?
    end
    
    def pssa_perform_level_m
        default_value = "NULL"
        results = student.pssa_performance_level_math
        return results ? results.value : default_value
    end
    
    def pssa_perform_level_r
        default_value = "NULL"
        results = student.pssa_performance_level_reading
        return results ? results.value : default_value
    end
    
    def pssa_perform_level_s
        default_value = "NULL"
        results = student.pssa_performance_level_writing
        return results ? results.value : default_value
    end
    
    def pssa_perform_level_w
        default_value = "NULL"
        results = student.pssa_performance_level_writing
        return results ? results.value : default_value
    end

    def pssa_score_m
        default_value = "NULL"
        results = student.pssa_score_math
        return results ? results.value : default_value
    end
        
    def pssa_score_r
        default_value = "NULL"
        results = student.pssa_score_reading
        return results ? results.value : default_value
    end
        
    def pssa_score_s
        default_value = "NULL"
        results = student.pssa_score_science
        return results ? results.value : default_value
    end
    
    def pssa_score_w
        default_value = "NULL"
        results = student.pssa_score_writing
        return results ? results.value : default_value
    end

    def pssa_test_type_m
        default_value = "NULL"
        results = student.pssa_test_type_math
        return results ? results.value : default_value
    end

    def pssa_test_type_r
        default_value = "NULL"
        results = student.pssa_test_type_reading
        return results ? results.value : default_value
    end

    def pssa_test_type_s
        default_value = "NULL"
        results = student.pssa_test_type_science
        return results ? results.value : default_value
    end
  
    def pssa_test_type_w
        default_value = "NULL"
        results = student.pssa_test_type_writing
        return results ? results.value : default_value
    end

    def pssa_test_year
        default_value = "NULL"
        results = student.pssa_test_year
        return results ? results.value : default_value
    end
    
#def pte_date
#def pte_status
#def retention
#def risk_level
#def rtii_last_reviewed_m
#def rtii_last_reviewed_r

    def rtii_tier_level_m
        default_value = "NULL"
        results = student.tier_level_math
        return results ? results.value : default_value
    end
    
    def rtii_tier_level_r
        default_value = "NULL"
        results = student.tier_level_reading
        return results ? results.value : default_value
    end

#def rtii_total_actions_m
#def rtii_total_actions_r

#def sap_referral

    def school_enroll_date
        return student.school_enroll_date.value
    end

#def ses_en_date
#def ses_provider
#def ses_start_date
#def ses_status
#def si_aplus_tbd

    def specialed_teacher
        default_value = "NULL"
        results = student.specialed_teacher
        return results ? results.value : default_value
    end
#def specialist_last_contact_m
#def specialist_last_contact_r
#def specialist_m
#def specialist_r
#def specialist_start_date_m
#def specialist_start_date_r
#def sti_attended_hv
#def sti_attended_m

    def sti_attended_overall
        default_value = 0
        results = $tables.attach("K12_STI_Combined").field_bystudentid("total_interventions", student.studentid)
        return results ? results.value : default_value
    end
    
#def sti_attended_pc
#def sti_attended_r
#def sti_attended_s
#def sti_missed_hv
#def sti_missed_m

    def sti_missed_overall
        default_value = 0
        results = $tables.attach("K12_STI_Combined").field_bystudentid("total_missed_interventions", student.studentid)
        return results ? results.value : default_value
    end
    
#def sti_missed_pc
#def sti_missed_r
#def sti_missed_s
#def sti_offered_hv
#def sti_offered_m

    def sti_offered_overall
        return sti_missed_overall + sti_attended_overall
    end

#def sti_offered_pc
#def sti_offered_r
#def sti_offered_s

    def stron_ent_perf_m
        default_value = "NULL"
        results = $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_perf_m", student.studentid)
        return results ? results.value : default_value
    end

    def stron_ent_perf_r
        default_value = "NULL"
        results = $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_perf_r", student.studentid)
        return results ? results.value : default_value
    end
    
#def stron_ent_perf_s

    def stron_ent_score_m
        default_value = "NULL"
        results = $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_score_m", student.studentid)
        return results ? results.value : default_value
    end
    
    def stron_ent_score_r
        default_value = "NULL"
        results = $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_score_r", student.studentid)
        return results ? results.value : default_value
    end
    
#def stron_ent_score_s


#def stron_ext_perf_m
#def stron_ext_perf_r
#def stron_ext_perf_s
#def stron_ext_score_m
#def stron_ext_score_r
#def stron_ext_score_s
    
    def studentid
        return student.student_id
    end
    
#def summer_school
#def sync_instr_status_m
#def sync_instr_status_r
#def sync_instr_status_sci
#def sync_instr_status_soc
#def wapt_level
#def wapt_tested
#def wida_level
#def wida_score
#def wida_tested
    
    def zip_code
        return student.mailing_zip.value
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def snapshot
        metrics = $tables.attach("Metrics_Student")
        record = metrics.new_row
        record.fields["student_id"].value = studentid
        
        record.fields.each_pair{|field_name, details|
            metric = field_name
            details.value = send(metric) if respond_to?(metric)    
        }
        record.save
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
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

    def student
        structure["student"]
    end
    
    def student=(arg)
        structure["student"] = arg
    end
end