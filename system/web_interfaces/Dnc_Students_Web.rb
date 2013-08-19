#!/usr/local/bin/ruby


class DNC_STUDENTS_WEB
    #---------------------------------------------------------------------------
    def initialize()
        @level_dd = [{:name=>"1", :value=>"1"}, {:name=>"2", :value=>"2"}, {:name=>"3", :value=>"3"}]
    end
    #---------------------------------------------------------------------------
    
    def load
        $kit.student_data_entry
    end
    
    def page_title
        
        how_to_button  = $tools.button_how_to("How To: No Call Requests")
        add_new_button = $students.attach($focus_student.student_id.value).dnc_record ? "" : $tools.button_new_row(table_name = "DNC_STUDENTS", additional_params_str = "sid")
        
        "DNC Students #{how_to_button}#{add_new_button}"
        
    end
    
    def response
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
    end
    
    def student_record()
        output     = String.new
        student    = $students.attach($focus_student.student_id.value)
        dnc_record = student.dnc_record
        output    << $kit.tools.div_open("dnc_div", "dnc_div")
        if dnc_record
            fields  = dnc_record.fields
            output << fields["reason"].web.text({:label_option=>"Reason:"})
            output << fields["category"].web.select({:label_option=>"Level:", :dd_choices=>@level_dd})
            output << fields["authorizer"].web.text({:label_option=>"Authorizer:"})
            output << $kit.tools.div_close()
            output << $tools.newlabel("bottom")
        else
            output << $tools.newlabel("no_record", "There is no record for this student.")
        end

        return output
    end
    
    def add_new_record_dnc_students()
        output  = String.new
        
        output << $tools.div_open("dnc_students_container", "dnc_students_container")
        
        student = $students.attach($focus_student.student_id.value)
        fields  = student.new_row("Dnc_Students").fields
        
        output << $tools.legend_open("sub", "New No Call Request")
        
            output << fields["studentid"].web.hidden()
            output << fields["reason"].web.text({:label_option=>"Reason:"})
            output << fields["category"].web.select({:label_option=>"Level:", :dd_choices=>@level_dd})
            output << fields["authorizer"].web.text({:label_option=>"Authorizer:"})
            output << $tools.newlabel("bottom")
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        #new_row_button_DNC_STUDENTS{       float:right; font-size: xx-small !important;}        
        div.DNC_STUDENTS__reason{           float:left; margin-left:10px; margin-top:5px; margin-bottom:5px; clear:left;}
        div.DNC_STUDENTS__reason input{     width:400px;}
        div.DNC_STUDENTS__category{         float:left; margin-left:25px; margin-bottom:5px; margin-top:5px;}
        div.DNC_STUDENTS__authorizer{       float:left; margin-left:25px; margin-bottom:5px; margin-top:5px;}
        "
        output << "</style>"
        return output
    end
end