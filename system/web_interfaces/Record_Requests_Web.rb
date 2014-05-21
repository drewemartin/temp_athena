#!/usr/local/bin/ruby


class RECORD_REQUESTS_WEB
    #---------------------------------------------------------------------------
    def load
        $kit.student_data_entry
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button1 = $tools.button_new_row(
            table_name              = "RECORD_REQUESTS_RECEIVED",
            additional_params_str   = "sid",
            save_params             = nil,
            button_text             = "Add New Record"
        )
        
        new_contact_button2 = $tools.button_new_row(
            table_name              = "RECORD_REQUESTS_NOTES",
            additional_params_str   = "sid",
            save_params             = nil,
            button_text             = "Add New Note"
        )
        
        "Record Requests#{new_contact_button1}#{new_contact_button2}"
        
    end
    
    def response
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
    end
    
    #---------------------------------------------------------------------------
    
    def student_record()
        
        output = String.new
        
        sid = $focus_student.student_id.value
        student = $students.attach(sid)
        
        records_required = student.records_required
        
        if !records_required
            
            student.new_row("Record_Requests_Required").save
            records_required = student.records_required
            
        end
        
        how_to_button_records_in_compliance = $tools.button_how_to("How To: Records In Compliance")
        
        output << $tools.legend_open("in_compliance", "In Compliance #{how_to_button_records_in_compliance}")
        
        fields = records_required.fields
        
        output << $tools.div_open("required_container")
        output << fields["report_card"  ].web.checkbox(:label_option=>"Report Card:"                    )
        output << fields["transcript"   ].web.checkbox(:label_option=>"Transcript:"                     )
        output << fields["pssa"         ].web.checkbox(:label_option=>"PSSA:"                           )
        output << fields["attendance"   ].web.checkbox(:label_option=>"Attendance:"                     )
        output << fields["discipline"   ].web.checkbox(:label_option=>"Discipline:"                     )
        output << fields["status"       ].web.select(  :label_option=>"Status:", :dd_choices=>status_dd )
        output << $tools.div_close
        output << $tools.legend_close
        
        how_to_button_records_received = $tools.button_how_to("How To: Records Received")
        
        output << $tools.legend_open("records_received", "Records Received #{how_to_button_records_received}")
        
        tables_array = [
            
            #HEADERS
            [
                "Document Type",
                "School Year",
                "Received Date"
            ]
            
        ]
        
        records_received = $tables.attach("RECORD_REQUESTS_RECEIVED").primary_ids("WHERE student_id = '#{sid}'")
        
        records_received.each do |pid|
            
            record = $tables.attach("RECORD_REQUESTS_RECEIVED").by_primary_id(pid)
            
            fields = record.fields
            
            row = Array.new
            
            row.push(fields["type"        ].to_user())
            row.push(fields["school_year" ].to_user())
            row.push(fields["created_date"].to_user())
            
            tables_array.push(row)
            
        end if records_received
        
        output << $tools.data_table(tables_array, "records_received")
        
        output << $tools.legend_close
        
        output << $tools.legend_open("notes", "Notes")
        
        tables_array = [
            
            #HEADERS
            [
                "Note",
                "Created Datetime",
                "Created By"
            ]
            
        ]
        
        notes = $tables.attach("RECORD_REQUESTS_NOTES").primary_ids("WHERE student_id = '#{sid}'")
        
        notes.each do |pid|
            
            record = $tables.attach("RECORD_REQUESTS_NOTES").by_primary_id(pid)
            
            fields = record.fields
            
            row = Array.new
            
            row.push(fields["note"         ].web.default(:disabled=>true))
            row.push(fields["created_date" ].to_user())
            row.push(fields["created_by"   ].to_user())
            
            tables_array.push(row)
            
        end if notes
        
        output << $tools.data_table(tables_array, "notes")
        
        output << $tools.legend_close
        
        return output
    end
    
    #---------------------------------------------------------------------------
    def add_new_record_record_requests_received()
        output = String.new
        student   = $students.attach($focus_student.student_id.value)
        fields    = student.new_row("Record_Requests_Received").fields
        output << fields["student_id"].web.hidden()
        output << fields["type"].web.select({:label_option=>"Document Type", :dd_choices=>type_dd})
        output << fields["school_year"].web.select({:label_option=>"School Year", :dd_choices=>school_years_dd})
        return output
    end
    #---------------------------------------------------------------------------
    def add_new_record_record_requests_notes()
        output = String.new
        student   = $students.attach($focus_student.student_id.value)
        fields    = student.new_row("Record_Requests_Notes").fields
        output << fields["student_id"].web.hidden()
        output << fields["note"].web.textarea()
        return output
    end
    #---------------------------------------------------------------------------

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________Drop_Downs
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def status_dd
        return [{:name=>"Compliant", :value=>"Compliant"},{:name=>"N/A - Financial Obligation", :value=>"N/A - Financial Obligation"},{:name=>"N/A - Records Forwarded", :value=>"N/A - Records Forwarded"},{:name=>"Needs Review", :value=>"Needs Review"},{:name=>"Not Compliant", :value=>"Not Compliant"},{:name=>"Other", :value=>"Other"},{:name=>"Withdrawn", :value=>"Withdrawn"}]
    end
    
    def type_dd
        return [{:name=>"Attendance", :value=>"Attendance"},{:name=>"Disciplinary Action", :value=>"Disciplinary Action"},{:name=>"PSSA", :value=>"PSSA"},{:name=>"Report Card", :value=>"Report Card"},{:name=>"Transcript - Official", :value=>"Transcript - Official"},{:name=>"Transcript - Unofficial", :value=>"Transcript - Unofficial"}]
    end
    
    def school_years_dd()
        output = []
        current_sy = $school.current_school_year
        temp = current_sy.split("-")
        max_year = temp[1].to_i
        i = max_year-20
        while i < max_year
            output.push({:name=>"#{i}-#{i+1}", :value=>"#{i}-#{i+1}"})
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
        
        div.required_container{                                 margin-left:auto; margin-right:auto; display:table;}
        div.RECORD_REQUESTS_REQUIRED__report_card{              float:left;}
        div.RECORD_REQUESTS_REQUIRED__transcript{               float:left; margin-left:20px;}
        div.RECORD_REQUESTS_REQUIRED__pssa{                     float:left; margin-left:20px;}
        div.RECORD_REQUESTS_REQUIRED__attendance{               float:left; margin-left:20px;}
        div.RECORD_REQUESTS_REQUIRED__discipline{               float:left; margin-left:20px;}
        div.RECORD_REQUESTS_REQUIRED__status{                   float:left; margin-left:20px;}
        
        div.received_container{                                 margin-left:auto; margin-right:auto; display:table;}
        div.RECORD_REQUESTS_RECEIVED__type{                     float:left; width:150px; min-height:1px; clear:left; margin-bottom:4px;}
        div.RECORD_REQUESTS_RECEIVED__school_year{              float:left; margin-left:20px; width:100px; min-height:1px; margin-bottom:4px;}
        div.RECORD_REQUESTS_RECEIVED__created_date{             float:left; margin-left:20px; margin-bottom:4px;}

        div.RECORD_REQUESTS_NOTES__note{                        float:left; border:2px solid #e1e1e1; clear:left;}
        div.RECORD_REQUESTS_NOTES__created_date{                float:left; font-size:.7em; width:200px; clear:left; margin-bottom:20px;}
        div.RECORD_REQUESTS_NOTES__created_by{                  float:left; font-size:.7em; margin-left:20px; width:200px; margin-bottom:20px;}
        
        div.records_received_header{                            float:left; clear:left; width:540px; padding:5px; padding-left:15px; border: 1px solid #3baae3; border-top-left-radius:5px; border-top-right-radius:5px;color:#2779aa; background-color:#d7ebf9;}
        div.records_received{                                   float:left; clear:left; width:560px; margin-top:-1px; height:200px; overflow-y:auto; border: 1px solid #3baae3; border-bottom-left-radius:5px; border-bottom-right-radius:5px;}
        div.bgdiv{                                              background:url('/athena/images/row_separator_25px.png') repeat left top; min-height:200px;}
        div.received_row{                                       float:left; clear:left; margin:5px 15px; height:15px;}

        div.new_div{                                            margin:10px; margin-left:20px;}
        div.no_docs{                                            float:left; clear:left; margin-left:20px;}
        textarea{                                               width:500px; height:120px; resize:none;}
        fieldset{                                               width:980px;}
        #new_row_button_RECORD_REQUESTS_RECEIVED{               float:right; font-size: xx-small !important;}
        #new_row_button_RECORD_REQUESTS_NOTES{                  float:right; font-size: xx-small !important;}
        "
        output << "</style>"
        return output
    end
end