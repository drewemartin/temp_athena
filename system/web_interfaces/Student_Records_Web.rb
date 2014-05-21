#!/usr/local/bin/ruby


class STUDENT_RECORDS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_record_button = ""
        

        
        "Student Records#{new_record_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        
        if field = $kit.rows.first[1].fields["serial_number"]
            if !field.updated
                student_id = $tables.attach("TEST_PACKETS").field_value("student_id", "WHERE serial_number = '#{field.value}'")
                $kit.web_error.duplicate_assignment_error(
                    additional_message="This test packet is already assigned to the student with ID# #{student_id}. You must unassign this packet first."
                )
            end
        end
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        tabs = Array.new
        
        tabs.push(["Outgoing", outgoing_records])
        tabs.push(["Incoming", ""])
        
        return $kit.tools.tabs(
            
            tabs,
            selected_tab    = 0,
            tab_id          = "records",
            search          = false
            
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_student_rro_required_documents()
        
        tables_array = [
            
            #HEADERS
            [
                "StudentID",
                "Record Type",
                "Status"
            ]
            
        ]
        
        row = Array.new
        
        record = $focus_student.rro_required_documents.new_record
        
        row.push( record.fields["student_id"           ].web.label() + record.fields["student_id"].web.hidden()) 
        row.push( record.fields["record_type_id"       ].web.select(:dd_choices=>document_types_dd($focus_student.student_id.value), :validate => true) )
        row.push( record.fields["status"               ].web.select(:dd_choices=>status_dd,         :validate => true) )  
        
        tables_array.push(row)
      
        return $kit.tools.data_table(tables_array, "new_record", type = "NewRecord")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def document_types_dd(sid)
        
        pids = $tables.attach("RRO_DOCUMENT_TYPES").required_documents(sid)
        
        $tables.attach("RRO_DOCUMENT_TYPES").dd_choices("document_name", "primary_id", "WHERE primary_id IN(#{pids.join(",")}) ORDER BY document_name")
        
    end
    
    def status_dd
        return [
            {:name=>"Request",                              :value=>"Request"                               },
            {:name=>"Received",                             :value=>"Received"                              },
            {:name=>"Received - Incomplete",                :value=>"Received - Incomplete"                 },
            {:name=>"Document Not Available",               :value=>"Document Not Available"                },
            {:name=>"Not Available - Financial Obligation", :value=>"Not Available - Financial Obligation"  },
            {:name=>"Cancelled",                            :value=>"Cancelled"                             }
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def outgoing_records
        
        output = String.new
        
        output << $tools.button_new_row(
            table_name              = "STUDENT_RRO_REQUIRED_DOCUMENTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        tables_array = [
            
            #HEADERS
            [
                "Record Type",
                "Status",
                "Received Date",
                "Notes",
                "Created Date"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        if record_pids
            
            record_pids.each{|pid|
                
                row            = Array.new
                
                record_record  = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").by_primary_id(pid)
                
                sid            = record_record.fields["student_id"    ].value
                
                record_type_id = record_record.fields["record_type_id"].value
                
                row.push($tables.attach("RRO_DOCUMENT_TYPES").field_value("document_name", "WHERE primary_id = '#{record_type_id}'"))
                row.push(record_record.fields["status"         ].web.select(:dd_choices=>status_dd)   )
                row.push(record_record.fields["received_date"  ].web.default())
                row.push(record_record.fields["notes"          ].web.default())
                row.push(record_record.fields["created_date"   ].to_user())
                
                tables_array.push(row)
                
            }
            
            output << $kit.tools.data_table(tables_array, "record_students")
            
        else
            
            output << $tools.newlabel("no_record", "There are not contacts entered for this student.")
            
        end
        
        return output
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            #new_row_button_STUDENT_RRO_REQUIRED_DOCUMENTS                   { float:right; font-size: xx-small !important; margin-bottom:10px;}
            
        "
        
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end