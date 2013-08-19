#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Metrics_Student_Report < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        i = 3
        
        excel = WIN32OLE::new('excel.Application')
        book  = excel.Workbooks.Open("#{$paths.templates_path}student_metrics_report.xlsx")
        sheet = book.worksheets("student_metrics")
        
        $students.current_students.each{|sid|
            record = $tables.attach("Metrics_Student").by_studentid_old(sid,$idate)
            if record
                fields = record.fields
                    sheet.range("a#{i}").value = fields["student_id"                    ].to_user
                    sheet.range("b#{i}").value = fields["first_name"                    ].to_user
                    sheet.range("c#{i}").value = fields["last_name"                     ].to_user
                    sheet.range("d#{i}").value = fields["grade_level"                   ].to_user
                    sheet.range("e#{i}").value = fields["freeandreducedmeals"           ].to_user
                    sheet.range("f#{i}").value = fields["ayp_status"                    ].to_user
                    sheet.range("g#{i}").value = fields["age"                           ].to_user
                    sheet.range("h#{i}").value = fields["gender"                        ].to_user
                    sheet.range("i#{i}").value = fields["birthday"                      ].to_user
                    sheet.range("j#{i}").value = fields["phone"                         ].to_user
                    sheet.range("k#{i}").value = fields["address"                       ].to_user
                    sheet.range("l#{i}").value = fields["city"                          ].to_user
                    sheet.range("m#{i}").value = fields["zip_code"                      ].to_user
                    sheet.range("n#{i}").value = fields["family_id"                     ].to_user
                    sheet.range("o#{i}").value = fields["guardian"                      ].to_user
                    sheet.range("p#{i}").value = fields["guardian_relation"             ].to_user
                    sheet.range("q#{i}").value = fields["learning_coach"                ].to_user
                    sheet.range("r#{i}").value = fields["learning_coach_relation"       ].to_user
                    sheet.range("s#{i}").value = fields["school_enroll_date"            ].to_user
                    sheet.range("t#{i}").value = fields["ppid"                          ].to_user
                    
                    sheet.range("v#{i}").value = fields["has_504"                       ].to_user
                    sheet.range("w#{i}").value = fields["iep_status"                    ].to_user
                    sheet.range("x#{i}").value = fields["is_special_ed"                 ].to_user
                    sheet.range("y#{i}").value = fields["lcenter_status"                ].to_user
                    sheet.range("z#{i}").value = fields["ell_status"                    ].to_user
                    
                    sheet.range("ab#{i}").value = fields["attendance_overall"           ].to_user
                    sheet.range("ac#{i}").value = fields["attendance_recent"            ].to_user
                    sheet.range("ad#{i}").value = fields["attendance_unexcused"         ].to_user
                    sheet.range("ae#{i}").value = fields["days_enrolled"                ].to_user
                    
                    sheet.range("ag#{i}").value = fields["cohort_year"                  ].to_user
                    sheet.range("ah#{i}").value = fields["credits_earned"               ].to_user
                    sheet.range("ai#{i}").value = fields["credits_needed"               ].to_user
                    sheet.range("aj#{i}").value = fields["credits_earned_unneeded"      ].to_user
                    
                    sheet.range("al#{i}").value = fields["stron_ent_perf_m"             ].to_user
                    sheet.range("am#{i}").value = fields["stron_ent_score_m"            ].to_user
                    sheet.range("an#{i}").value = fields["stron_ent_perf_r"             ].to_user
                    sheet.range("ao#{i}").value = fields["stron_ent_score_r"            ].to_user
                    
                    sheet.range("aq#{i}").value = fields["pssa_on_file"                 ].to_user
                    sheet.range("ar#{i}").value = fields["pssa_test_year"               ].to_user
                    sheet.range("as#{i}").value = fields["pssa_grade_when_tested"       ].to_user
                    sheet.range("at#{i}").value = fields["pssa_test_type_m"             ].to_user
                    sheet.range("au#{i}").value = fields["pssa_perform_level_m"         ].to_user
                    sheet.range("av#{i}").value = fields["pssa_score_m"                 ].to_user
                    sheet.range("aw#{i}").value = fields["pssa_test_type_r"             ].to_user
                    sheet.range("ax#{i}").value = fields["pssa_perform_level_r"         ].to_user
                    sheet.range("ay#{i}").value = fields["pssa_score_r"                 ].to_user
                    sheet.range("az#{i}").value = fields["pssa_test_type_s"             ].to_user
                    sheet.range("ba#{i}").value = fields["pssa_perform_level_s"         ].to_user
                    sheet.range("bb#{i}").value = fields["pssa_score_s"                 ].to_user
                    sheet.range("bc#{i}").value = fields["pssa_test_type_w"             ].to_user
                    sheet.range("bd#{i}").value = fields["pssa_perform_level_w"         ].to_user
                    sheet.range("be#{i}").value = fields["pssa_score_w"                 ].to_user
                    
                    sheet.range("bg#{i}").value = fields["rtii_tier_level_m"            ].to_user
                    sheet.range("bh#{i}").value = fields["rtii_tier_level_r"            ].to_user
                    
                    sheet.range("bj#{i}").value = fields["sti_offered_overall"          ].to_user
                    sheet.range("bk#{i}").value = fields["sti_attended_overall"         ].to_user
                    sheet.range("bl#{i}").value = fields["sti_missed_overall"           ].to_user
                    
                    sheet.range("bn#{i}").value = fields["family_teacher_coach"         ].to_user
                    sheet.range("bo#{i}").value = fields["specialed_teacher"            ].to_user
                    sheet.range("bp#{i}").value = fields["general_ed_teacher"           ].to_user
            end
            
            #break if i == 6
            i+=1  
        }
        
        file_path = $config.init_path("#{$paths.reports_path}Metrics/Student_Metrics")   
        save_path = "#{file_path}STUDENT_METRICS_#{$ifilestamp}.xlsx"
        book.SaveAs(save_path.gsub("/","\\"))
        excel.Quit
        $team.email_senior_team("Student Metrics #{$idate}", "Please find the attached student metrics report", priority = nil, attachments = save_path)
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
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

end

Metrics_Student_Report.new