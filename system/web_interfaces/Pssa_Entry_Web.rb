#!/usr/local/bin/ruby


class PSSA_ENTRY_WEB
    #---------------------------------------------------------------------------
    def initialize()
        @testing = false
    end
    #---------------------------------------------------------------------------
    def load
        $kit.student_data_entry
    end
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "PSSA",
            additional_params_str   = "sid"
        )
        
        how_to_button = $tools.button_how_to("How To: PSSA Records")
        
        "PSSA Entry #{how_to_button}#{new_contact_button}"
        
    end
    
    def response
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
    end
    
    def student_record()
        output  = ""
        student = $students.attach($focus_student.student_id.value)
        output << $tools.div_open("pssa_results", "pssa_results")
        pssa_records = student.pssa_records
        if pssa_records
            pssa_records.each do |record|
                pid     = record.primary_id
                year    = record.fields["test_school_year"].value
                output << $tools.expandable_section("PSSA #{year}", "", pid)
            end
        else
            output << $kit.tools.newlabel("no_record", "No Documents Received For This Student")
        end
        output << $tools.div_close()
        output << $tools.newlabel("bottom")
        return output
    end
    
    def expand_pssa(pid)
        output = ""
        pssa_record  = $school.pssa_record_by_pid(pid)
        fields       = pssa_record.fields
        pssa_year    = fields["test_school_year"].value
        agora_tested = fields["agora_tested"].value == "1" ? "YES" : "NO"
        output << $kit.tools.div_open("pssa_container")
        output << fields["test_school_year"  ].web.select( :label_option=>"Test Year:",   :dd_choices=>school_year_dd)
        output << fields["grade_when_tested" ].web.select( :label_option=>"Grade:",       :dd_choices=>grade_dd)
        output << $kit.tools.newlabel(                     "test_type_header",            "Test Type")
        output << $kit.tools.newlabel(                     "subject_header",              "Subject")
        output << $kit.tools.newlabel(                     "pl_header",                   "Performance Level")
        output << $kit.tools.newlabel(                     "score_header",                "Score")
        output << fields["math_test_type"    ].web.select( :dd_choices=>type_dd)
        output << $kit.tools.newlabel(                     "subject_label",               "Math")
        output << fields["math_perf_level"   ].web.select( :dd_choices=>perf_dd)
        output << fields["math_score"].web.text()          
        output << fields["reading_test_type" ].web.select( :dd_choices=>type_dd)
        output << $kit.tools.newlabel(                     "subject_label",               "Reading")
        output << fields["reading_perf_level"].web.select( :dd_choices=>perf_dd)
        output << fields["reading_score"     ].web.text()  
        output << fields["science_test_type" ].web.select( :dd_choices=>type_dd)
        output << $kit.tools.newlabel(                     "subject_label",               "Science")
        output << fields["science_perf_level"].web.select( :dd_choices=>perf_dd)
        output << fields["science_score"     ].web.text()  
        output << fields["writing_test_type" ].web.select( :dd_choices=>type_dd)
        output << $kit.tools.newlabel(                     "subject_label",               "Writing")
        output << fields["writing_perf_level"].web.select( :dd_choices=>perf_dd)
        output << fields["writing_score"].web.text()
        output << $kit.tools.newlabel(                     "Pssa__agora_tested",          "Agora Tested: #{agora_tested}")
        output << $tools.newlabel("bottom")
        output << $kit.tools.div_close()
        output << $tools.newlabel("bottom")
        return output
    end
    
    def add_new_record_pssa()
        
        output    = String.new
        
        output << $tools.div_open("new_pssa_record_container", "new_pssa_record_container")
        
        student   = $students.attach($focus_student.student_id.value)
        fields    = student.new_row("Pssa").fields
        pssa_year = fields["test_school_year"].value
        
        output << $tools.legend_open("sub", "New PSSA Record")
        
            output << fields["studentid"].web.hidden()
            output << fields["test_school_year"].web.select({:dd_choices=>school_year_dd, :label_option=>"Test Year:"})
            output << fields["grade_when_tested"].web.select({:label_option=>"Grade:", :dd_choices=>grade_dd})
            output << $kit.tools.newlabel("test_type_header",     "Test Type")
            output << $kit.tools.newlabel("subject_header",       "Subject")
            output << $kit.tools.newlabel("pl_header",            "Performance Level")
            output << $kit.tools.newlabel("score_header",         "Score")
            output << fields["math_test_type"].web.select({:dd_choices=>type_dd})
            output << $kit.tools.newlabel("subject_label",        "Math")
            output << fields["math_perf_level"].web.select({:dd_choices=>perf_dd})
            output << fields["math_score"].web.text()
            output << fields["reading_test_type"].web.select({:dd_choices=>type_dd})
            output << $kit.tools.newlabel("subject_label",        "Reading")
            output << fields["reading_perf_level"].web.select({:dd_choices=>perf_dd})
            output << fields["reading_score"].web.text()
            output << fields["science_test_type"].web.select({:dd_choices=>type_dd})
            output << $kit.tools.newlabel("subject_label",        "Science")
            output << fields["science_perf_level"].web.select({:dd_choices=>perf_dd})
            output << fields["science_score"].web.text()
            output << fields["writing_test_type"].web.select({:dd_choices=>type_dd})
            output << $kit.tools.newlabel("subject_label",        "Writing")
            output << fields["writing_perf_level"].web.select({:dd_choices=>perf_dd})
            output << fields["writing_score"].web.text()
            agora_tested = fields["agora_tested"].value == "1" ? "YES" : "NO"
            output << $kit.tools.newlabel("Pssa__agora_tested", "Agora Tested: #{agora_tested}")
            output << $tools.newlabel("bottom")
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
    end
    
    def perf_dd
        return [{:name=>"Below Basic", :value=>"Below Basic"},{:name=>"Basic", :value=>"Basic"},{:name=>"Proficient", :value=>"Proficient"},{:name=>"Advanced", :value=>"Advanced"},{:name=>"No Score", :value=>"No Score"}]
    end
    
    def type_dd
        return [{:name=>"PSSA", :value=>"PSSA"},{:name=>"PSSA-M", :value=>"PSSA-M"},{:name=>"PASA", :value=>"PASA"},{:name=>"RETEST", :value=>"RETEST"},{:name=>"N/A", :value=>"N/A"}]
    end
    
    def grade_dd
        return [{:name=>"K", :value=>"K"},{:name=>"1", :value=>"1"},{:name=>"2", :value=>"2"},{:name=>"3", :value=>"3"},{:name=>"4", :value=>"4"},{:name=>"5", :value=>"5"},{:name=>"6", :value=>"6"},{:name=>"7", :value=>"7"},{:name=>"8", :value=>"8"},{:name=>"9", :value=>"9"},{:name=>"10", :value=>"10"},{:name=>"11", :value=>"11"},{:name=>"12", :value=>"12"}]
    end
    
    def school_year_dd()
        output = []
        current_sy = $school.current_school_year.split("-")[1].to_i
        i = current_sy-20
        while i <= current_sy
            output.push({:name=>"#{i}", :value=>"#{i}"})
            i+=1
        end
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        div.pssa_container{                 display:block; margin-left:auto; margin-right:auto; width:540px; margin-top:15px; margin-bottom:15px;}
                
        div.PSSA__test_school_year{         float:left; width:420px; padding:5px;}
        div.PSSA__grade_when_tested{        float:left; }
        div.test_type_header{               float:left; width:130px; padding:5px; text-decoration:underline; font-weight:bold; clear:left;}
        div.subject_header{                 float:left; width:120px; padding:5px; text-decoration:underline; font-weight:bold;}
        div.pl_header{                      float:left; width:180px; padding:5px; text-decoration:underline; font-weight:bold;}
        div.score_header{                   float:left; width:60px;  padding:5px; text-decoration:underline; font-weight:bold;}
        div.subject_label{                  float:left; width:120px; padding:5px;}
        div.PSSA__math_test_type{           float:left; width:130px; padding:5px; clear:left;}
        div.PSSA__math_perf_level{          float:left; width:180px; padding:5px;}
        div.PSSA__math_score{               float:left; width:60px; padding:5px;}
        div.PSSA__reading_test_type{        float:left; width:130px; padding:5px; clear:left;}
        div.PSSA__reading_perf_level{       float:left; width:180px; padding:5px;}
        div.PSSA__reading_score{            float:left; width:60px; padding:5px;}
        div.PSSA__writing_test_type{        float:left; width:130px; padding:5px; clear:left;}
        div.PSSA__writing_perf_level{       float:left; width:180px; padding:5px;}
        div.PSSA__writing_score{            float:left; width:60px; padding:5px;}
        div.PSSA__science_test_type{        float:left; width:130px; padding:5px; clear:left;}
        div.PSSA__science_perf_level{       float:left; width:180px; padding:5px;}
        div.PSSA__science_score{            float:left; width:60px; padding:5px;}
        div.PSSA__agora_tested{             float:left; padding:5px; margin-top:4px; clear:left;}
        
        .PSSA__math_score input{            width:60px;}
        .PSSA__reading_score input{         width:60px;}
        .PSSA__science_score input{         width:60px;}
        .PSSA__writing_score input{         width:60px;}
        
        #new_row_button_PSSA{               float:right; font-size: xx-small !important;}
        "
        output << "</style>"
        return output
    end
end