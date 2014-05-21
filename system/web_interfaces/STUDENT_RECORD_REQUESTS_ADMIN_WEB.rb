#!/usr/local/bin/ruby


class STUDENT_RECORD_REQUESTS_ADMIN_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        $kit.tools.tabs([
            ["Document Types",  load_tab_1],
            ["Settings",        load_tab_2]
        ],0)
        
    end
    
    def breakaway_caption
        
        how_to_button = $tools.button_how_to("STUDENT_TEST_EVENTS_ADMIN_WEB", "How To: Manage Test Events")
        
        return "Record Requests Admin"
        
    end

    def response
        
        if $kit.params[:add_new_RRO_DOCUMENT_TYPES]
            $kit.modify_tag_content("tabs-1", load_tab_1, "update")
        end
        
        if $kit.params[:add_new_RRO_SETTINGS_STATUS]
            $kit.modify_tag_content("tabs-2", load_tab_2, "update")
        end
        
    end
    
    def page_title
        
        return "Record Requests Admin"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load_tab_1(arg = nil)#DOCUMENT TYPES
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "RECORD_REQUESTS_OUTGOING_DOCUMENT_TYPES")
        
        tables_array = [
            
            #HEADERS
            [
                
                "Document Category"     , 
                "Document Name"         ,
                "Eligible Grades"       ,
                "In State?"             ,
                "Out of State?"         ,
                "General Education"     ,
                "Special Education?"    ,
                "Active?"
            ]
            
        ]
     
        pids = $tables.attach("RRO_DOCUMENT_TYPES").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("RRO_DOCUMENT_TYPES").by_primary_id(pid)
            
            row = Array.new
            
            row.push(record.fields["document_category"  ].web.text      )
            row.push(record.fields["document_name"      ].web.textarea  )
            
            grades = Array.new
            grades.push(["K","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th"])  
            grades.push(
                [
                    record.fields["grade_k"       ].web.default(),
                    record.fields["grade_1st"     ].web.default(),
                    record.fields["grade_2nd"     ].web.default(),
                    record.fields["grade_3rd"     ].web.default(),
                    record.fields["grade_4th"     ].web.default(),
                    record.fields["grade_5th"     ].web.default(),
                    record.fields["grade_6th"     ].web.default(),
                    record.fields["grade_7th"     ].web.default(),
                    record.fields["grade_8th"     ].web.default(),
                    record.fields["grade_9th"     ].web.default(),
                    record.fields["grade_10th"    ].web.default(),
                    record.fields["grade_11th"    ].web.default(),
                    record.fields["grade_12th"    ].web.default()
                ]
            )
            
            row.push(
                $tools.table(
                    :table_array    => grades,
                    :unique_name    => "eligible_grades",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
            )
            
            row.push(record.fields["in_state"           ].web.default())
            row.push(record.fields["out_of_state"       ].web.default())
            row.push(record.fields["general_education"  ].web.default())
            row.push(record.fields["special_education"  ].web.default())
            row.push(record.fields["active"             ].web.default())
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(
            tables_array,
            unique_name     = "RRO_DOCUMENT_TYPES",
            table_type      = "default"
        )
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_2(arg = nil)#Batch Request Settings
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "expiration_interval_unit"     , 
                "expiration_interval_number"        
            ]
            
        ]
     
        rro_settings = $tables.attach("RRO_SETTINGS_DOC_EXPIRATION")
        record = rro_settings.by_primary_id(1) || rro_settings.by_primary_id(rro_settings.new_row.save)
        
        row = Array.new
        
        row.push(record.fields["expiration_interval_unit"   ].web.select(:dd_choices=>$dd.mysql_intervals)     )
        row.push(record.fields["expiration_interval_number" ].web.text   )
        
        tables_array.push(row)
        
        output << $kit.tools.table(
            :table_array => tables_array,
            :unique_name => "RRO_SETTINGS_DOC_EXPIRATION"
        )
        
        output << "<div style='padding:10px;clear:both;'><hr></div>"
        
        #STATUSES AVAILABLE FOR THE RECEIVING DROPDOWN
        output << $tools.button_new_row(table_name = "RRO_SETTINGS_STATUS")
        
        tables_array = [
            
            #HEADERS
            [
                
                "Status Name",
                "Auto Send?"
            ]
            
        ]
     
        pids = $tables.attach("RRO_SETTINGS_STATUS").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("RRO_SETTINGS_STATUS").by_primary_id(pid)
            
            row = Array.new
            
            row.push(record.fields["status_name"].web.text  )
            row.push(record.fields["auto_send"  ].web.default  )
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(
            tables_array,
            unique_name     = "RRO_SETTINGS_DOC_EXPIRATION",
            table_type      = "default"
        )   
        
        output << $tools.newlabel("bottom")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_record_requests_document_types()
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "Document Category"     ,
                "Document Type/Name"    , 
                "Eligible Grades"       ,
                "In State?"             ,
                "Out of State?"         ,
                "General Education"     ,
                "Special Education?"    
              
            ]
            
        ]
        
        record = $tables.attach("RRO_DOCUMENT_TYPES").new_row
        
        grades = Array.new
        grades.push(["K","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th"])  
        grades.push(
            [
                record.fields["grade_k"       ].set(true).web.default(),
                record.fields["grade_1st"     ].set(true).web.default(),
                record.fields["grade_2nd"     ].set(true).web.default(),
                record.fields["grade_3rd"     ].set(true).web.default(),
                record.fields["grade_4th"     ].set(true).web.default(),
                record.fields["grade_5th"     ].set(true).web.default(),
                record.fields["grade_6th"     ].set(true).web.default(),
                record.fields["grade_7th"     ].set(true).web.default(),
                record.fields["grade_8th"     ].set(true).web.default(),
                record.fields["grade_9th"     ].set(true).web.default(),
                record.fields["grade_10th"    ].set(true).web.default(),
                record.fields["grade_11th"    ].set(true).web.default(),
                record.fields["grade_12th"    ].set(true).web.default()
            ]
        )
        
        eligible_grades = $tools.table(
            
            :table_array    => grades,
            :unique_name    => "eligible_grades",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
            
        )
        
        tables_array.push(
            
            [
                record.fields["document_name"       ].web.text,
                "#{record.fields["document_name"    ].web.textarea(:validate=>true)}#{record.fields["active"].set(true).web.hidden}",
                eligible_grades,
                record.fields["in_state"           ].set(true).web.default(),
                record.fields["out_of_state"       ].set(true).web.default(),
                record.fields["general_education"  ].set(true).web.default(),
                record.fields["special_education"  ].set(true).web.default()
            ]
            
        )
        
        output << $kit.tools.data_table(
            tables_array,
            unique_name     = "NEW_RECORD_REQUESTS_DOCUMENT_TYPES",
            table_type      = "NewRecord"
        )
        
        output << $tools.newlabel("bottom")
        
        return output
        
    end
    
    def add_new_record_rro_settings_status()
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "Status Name",
                "Auto Send"
              
            ]
            
        ]
        
        record = $tables.attach("RRO_SETTINGS_STATUS").new_row
        
        tables_array.push(
            
            [
                record.fields["status_name"     ].web.text,
                record.fields["auto_send"       ].set(0).web.default
            ]
            
        )
        
        output << $kit.tools.data_table(
            tables_array,
            unique_name     = "add_new_RRO_SETTINGS_STATUS",
            table_type      = "NewRecord"
        )
        
        output << $tools.newlabel("bottom")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_CSV
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        
        output << ".RECORD_REQUESTS_DOCUMENT_TYPES__document_name  textarea{
            width:  200px;
            height: 50px;
        }"
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