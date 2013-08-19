#!/usr/local/bin/ruby


class TESTS_ADMIN_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.output = $tools.tab_identifier(1)
        $kit.output = $kit.tools.tabs([
            ["Sites",   sites_tab     ],
            ["Events",  events_tab    ]
        ])
    end
    
    def response
        
    end
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DEFAULT_TABS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def sites_tab
        
        output      = String.new
        sites_table = $tables.attach("test_sites")
        
        output  << $tools.button_new_row(table_name = "TEST_SITES")
        
        if pids = sites_table.primary_ids
            
            tables_array = [
                
                #HEADERS
                ["Region","Name","Address","City","State","Zip Code","Site URL","Directions","Contact Name","Contact Phone","Contact Email","Available Hours"]
                
            ]
            
            pids.each{|pid|
                
                record = sites_table.by_primary_id(pid)
                
                row = Array.new
                row.push(record.fields["region"           ].web.default())
                row.push(record.fields["facility_name"    ].web.default())
                row.push(record.fields["address"          ].web.default())
                row.push(record.fields["city"             ].web.default())
                row.push(record.fields["state"            ].web.default())
                row.push(record.fields["zip_code"         ].web.default())
                row.push(record.fields["site_url"         ].web.default())
                row.push(record.fields["directions"       ].web.default())
                row.push(record.fields["contact_name"     ].web.default())
                row.push(record.fields["contact_phone"    ].web.default())
                row.push(record.fields["contact_email"    ].web.default())
                row.push(record.fields["available_hours"  ].web.default())
                
                tables_array.push(row)
                
            }
            
           output << $kit.tools.data_table(tables_array, "existing_sites")
           
        end
        
        return output
        
    end
    
    def events_tab
        
        output  = String.new
        table   = $tables.attach("test_events")
        
        output  << $tools.button_new_row(table_name = "TEST_EVENTS")
        
        if pids = table.primary_ids
            
            tables_array = [
                
                #HEADERS
                ["Event Name","Start Date","End Date"]
                
            ]
            
            pids.each{|pid|
                
                record = table.by_primary_id(pid)
                
                row = Array.new
                row.push(record.fields["name"           ].web.default())
                row.push(record.fields["start_date"     ].web.default())
                row.push(record.fields["end_date"       ].web.default())
                
                tables_array.push(row)
                
            }
            
            output << $kit.tools.data_table(tables_array, "existing_events")
           
        end
        
        return output
        
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_test_sites
        
        output  = String.new
        
        fields  = $tables.attach("test_sites").new_row.fields
        
        output << $tools.div_open("test_site_container", "test_site_container")
            
            output << fields["region"           ].web.default(:label_option=>"Region")
            output << fields["site_name"        ].web.default(:label_option=>"Site Name")
            output << fields["address"          ].web.default(:label_option=>"Address")
            output << fields["city"             ].web.default(:label_option=>"City")
            output << fields["state"            ].web.default(:label_option=>"State")
            output << fields["zip_code"         ].web.default(:label_option=>"Zip Code")
            output << fields["site_url"         ].web.default(:label_option=>"Site URL")
            output << fields["directions"       ].web.default(:label_option=>"Directions")
            output << fields["contact_name"     ].web.default(:label_option=>"Contact Name")
            output << fields["contact_phone"    ].web.default(:label_option=>"Phone")
            output << fields["contact_email"    ].web.default(:label_option=>"Email Address")
            output << fields["available_hours"  ].web.default(:label_option=>"Available Hours")
            
        output << $tools.div_close()
        
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
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
        output << "#search_dialog_button{   display:none;}"
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