#!/usr/local/bin/ruby

class WITHDRAWAL_PROCESSING_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        @processors = [
            "epagan@agora.org",
            "sfields@agora.org",
            "kyoung@agora.org",
            "smcdonnell@agora.org"
        ]
        @processors += $software_team
        
        @school_wide_results = @processors.include?($kit.user)
        
    end
    
    def breakaway_caption
        
        return "Withdrawal Processing"
    
    end
    
    def page_title
        
        "Withdrawal Processing"
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        output = String.new
        
        output << $kit.tools.tabs(
            
            [
             
                ["Eligible",  eligible_students  ],
                ["Processed", processed_students ]
                
            ]
            
        )
        
        return output
    end
    
    def response
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STUDENT_LISTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def eligible_students
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID",
                "SID Copy",
                "Effective Date",
                "Processed",
                "Agora Reason",           
                "K12 Reason"     
            ]
            
        ]
        
        eligible_records = $tables.attach("Withdrawing").withdrawing_eligible_records#("ORDER BY created_date DESC")
        
        eligible_records.each do |record|
            
            s = $students.get(record.fields["student_id"].value)
            created_date = record.fields["created_date"].value
            row = Array.new
            
            row.push(s.student_id.value                                          )
            row.push(record.fields["student_id"        ]         .web.label()    )
            row.push(record.fields["effective_date"    ].to_user!.web.label()    )
            row.push(record.fields["processed"         ]         .web.checkbox   )
            row.push(record.fields["agora_reason"      ]         .web.select(:dd_choices=>agora_reason_dd)    )
            row.push(record.fields["k12_reason"        ]         .web.select(:dd_choices=>k12_reason_dd(created_date))    )
            
            tables_array.push(row)
            
        end if eligible_records
        
        return $kit.tools.data_table(tables_array, "elgible")
        
    end
    
    def processed_students
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID",
                "Effective Date",
                "Processed",
                "Processed Date",
                "Initated Date",
                "Initiator",         
                "Relationship",      
                "Method",       
                "Agora Reason",           
                "K12 Reason",          
                "Type",          
                "Transferring School",    
                "Truancy Dates"
            ]
            
        ]
        
        processed_records = $tables.attach("Withdrawing").withdrawing_processed_records
        
        processed_records.each do |record|
            
            s = $students.get(record.fields["student_id"].value)
            
            row = Array.new
            
            row.push(s.student_id.value                                               )
            row.push(record.fields["effective_date"         ].to_user!.web.label()    )
            row.push(record.fields["processed"              ]         .web.checkbox() )
            row.push(record.fields["processed_date"         ].to_user!.web.label()    )
            row.push(record.fields["initiated_date"         ].to_user!.web.label()    )
            row.push(record.fields["initiator"              ]         .web.label()    )
            row.push(record.fields["relationship"           ]         .web.label()    )
            row.push(record.fields["method"                 ]         .web.label()    )
            row.push(record.fields["agora_reason"           ]         .web.label()    )
            row.push(record.fields["k12_reason"             ]         .web.label()    )
            row.push(record.fields["type"                   ]         .web.label()    )
            row.push(record.fields["transferring_school"    ]         .web.label()    )
            row.push(record.fields["truancy_dates"          ]         .web.label()    )
            
            tables_array.push(row)
            
        end if processed_records
        
        return $kit.tools.data_table(tables_array, "processed")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def agora_reason_dd
        return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)",:value_field=>"code",:clause_string => "WHERE type = 'agora'"})
    end
    
    def k12_reason_dd(record_created_date_string)
        
        record_created_date = DateTime.parse(record_created_date_string)
        date_k12_codes_changed = DateTime.new(2014,9,18,16,30,0)
        
        if record_created_date >= date_k12_codes_changed
            return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)", :value_field=>"code",:clause_string => "WHERE type = 'k12' AND codes_to_use = 'Changed 9-12-2014'"})
        else
            return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)", :value_field=>"code",:clause_string => "WHERE type = 'k12' AND codes_to_use = 'Original'"})
        end
    end
        
    
    def method_dd
        return [
            {:name=>"Home Visit",           :value=>"Home Visit"},
            {:name=>"E-Mail",               :value=>"E-Mail"},
            {:name=>"K-Mail",               :value=>"K-Mail"},
            {:name=>"Letter",               :value=>"Letter"},
            {:name=>"Phone Call",           :value=>"Phone Call"},
            {:name=>"Attendance Procedure", :value=>"Attendance Procedure"}
        ]
    end
    
    def relationship_dd
        return [
            {:name=>"Legal Guardian",       :value=>"Legal Guardian"},
            {:name=>"Learning Coach",       :value=>"Learning Coach"},
            {:name=>"Self",                 :value=>"Self"},
            {:name=>"Admin - Attendance",   :value=>"Admin - Attendance"},
            {:name=>"Admin - Academic",     :value=>"Admin - Academic"},
            {:name=>"Admin - Compliancy",   :value=>"Admin - Compliancy"},
            {:name=>"Admin - Records",      :value=>"Admin - Records"}
        ]
    end
    
    def status_dd
        return [
            {:name=>"Requested",            :value=>"Requested"},
            {:name=>"Processed",            :value=>"Processed"},
            {:name=>"Withdraw Confirmed",   :value=>"Withdraw Confirmed"},
            {:name=>"Withdraw Retracted",   :value=>"Withdraw Retracted"}
        ]
    end
    
    def type_dd
        return [
            {:name=>"General Ed Truancy",   :value=>"General Ed Truancy"},
            {:name=>"Special Ed Truancy",   :value=>"Special Ed Truancy"},
            {:name=>"User Initiated",       :value=>"User Initiated"}
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
            
            div.WITHDRAWING__initiated_date             { width:140px;}
            div.WITHDRAWING__initiator                  { width:200px;}
            div.WITHDRAWING__relationship               { width:100px;}
            div.WITHDRAWING__method                     { width:110px;}
            div.WITHDRAWING__processed                  { width:21px; margin-left:auto; margin-right:auto;}
            
            div.WITHDRAWING__processed_date             { width:140px;}
            div.WITHDRAWING__type                       { width:100px;}
            div.WITHDRAWING__transferring_school        { width:250px;}
            
            div.WITHDRAWING__k12_reason select          { width:400px;}
            div.WITHDRAWING__agora_reason select        { width:400px;}
        "
        output << "</style>"
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    #def javascript
    #    output = "<script type=\"text/javascript\">"
    #    output << "YOUR CODE HERE"
    #    output << "</script>"
    #    return output
    #end
    
end