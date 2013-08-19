#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports", "base")}/base"

class Evaluation_Report_Ftc < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        
        $team.family_teacher_coaches.each{|ftc_name|
            eval_template(ftc_name)
        }
        
    end
    #---------------------------------------------------------------------------
    
    def eval_template(ftc_name)
        ftc         = $team.by_k12_name(ftc_name)
        record      = ftc.evaluation_record("Family Teacher Coach")
        dep_record  = $team.department_evaluation_record("Family Teacher Coach")
        dep_record  = $team.department_evaluation_record("Family Teacher Coach", ftc.peer_group)
        
        replace = Hash.new
        replace["[ftc]"] = "#{ftc.k12_first_name.value} #{ftc.k12_last_name.value}"
        record.fields.each_pair{|field_name, details|
            replace["[#{field_name}]"] = details.to_user
        }
        dep_record.fields.each_pair{|field_name, details|
            replace["[dep_#{field_name}]"] = details.to_user
        }
        
        #FNORD - THIS NEED TO BE GENERALIZED AND MOVED!!!!
        location        = "#{$paths.reports_path}FTC_Evaluations"
        filename        = "#{replace["[ftc]"]}"
        word_doc_path   = "#{location}/#{filename}.docx"
        
        word = $base.word
        doc  = word.Documents.Open("#{$paths.templates_path}ftc_evals.docx")
        replace.each_pair{|f,r|
            #footer
            word.ActiveWindow.View.Type = 3
            word.ActiveWindow.ActivePane.View.SeekView = 10
            word.Selection.HomeKey(unit=6)
            find = word.Selection.Find
            find.Text = f
            while word.Selection.Find.Execute
                if r.nil? || r == ""
                    rvalue = " "
                elsif r.class == Field
                    rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                else
                    rvalue = r.to_s
                end
                word.Selection.TypeText(text=rvalue.gsub("’","'"))
            end
            
            #main body
            word.ActiveWindow.ActivePane.View.SeekView = 0
            word.Selection.HomeKey(unit=6)
            find = word.Selection.Find
            find.Text = f
            while word.Selection.Find.Execute
                if r.nil? || r == ""
                    rvalue = " "
                elsif r.class == Field
                    rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                else
                    rvalue = r.to_s
                end
                word.Selection.TypeText(text=rvalue.gsub("’","'"))
            end
        }
        doc.SaveAs(word_doc_path.gsub("/","\\"))
        #doc.SaveAs(pdf_doc_path.gsub("/","\\"),17)
        doc.close
        word.quit
        
    end
end

Evaluation_Report_Ftc.new