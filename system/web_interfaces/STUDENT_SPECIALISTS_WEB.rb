#!/usr/local/bin/ruby


class STUDENT_SPECIALISTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        how_to_button = $tools.button_how_to("How To: Specialists")
        
        "Specialists #{how_to_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record
        
        spec_array = Array.new
        
        ["math", "reading"].each{|subject|
            
            $focus_student.send("specialist_#{subject}").existing_record || $focus_student.send("specialist_#{subject}").new_record.save
            
            a1 = "<div class='day'>#{ $focus_student.send("specialist_#{subject}").monday.web.default(   :label_option=>"M")}   </div>"
            a2 = "<div class='day'>#{ $focus_student.send("specialist_#{subject}").tuesday.web.default(  :label_option=>"T")}   </div>"
            a3 = "<div class='day'>#{ $focus_student.send("specialist_#{subject}").wednesday.web.default(:label_option=>"W")}   </div>"
            a4 = "<div class='day'>#{ $focus_student.send("specialist_#{subject}").thursday.web.default( :label_option=>"TH")}   </div>"
            a5 = "<div class='day'>#{ $focus_student.send("specialist_#{subject}").friday.web.default(   :label_option=>"F")}   </div>"
            
            
            if spec_id = $focus_student.send("specialist_#{subject}").team_id.value
                
                t = $team.get(spec_id)
                
                tname   = t.legal_first_name.value + " " + t.legal_last_name.value
                mlink   = t.preferred_email.to_email_link(:text=>"#{subject.capitalize} Specialist:",:subject=>"Student ID: #{$focus_student.student_id.value}",:content=>"")
                
            end
            
            spec = $focus_student.send("specialist_#{subject}").team_id.web.select(:dd_choices=>$dd.team_members) 
            spec_array.push(["#{mlink || "#{subject.capitalize} Specialist:" }",spec || "Not Assigned"])
            spec_array.push(["",a1.to_s+a2.to_s+a3.to_s+a4.to_s+a5.to_s])
            
        }
        
        css = "<style>
        div.day        { height:25px;}
        div.day   input{ float:left;}
        div.day   label{ width:90%; display:inline-block;}
        </style>"
        return css + $tools.table(
            :table_array    => spec_array,
            :unique_name    => "specialists",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        #tables_array = [
        #    
        #    #HEADERS
        #    [          
        #        "Test Type",         
        #        "Test Event",
        #        "Test Subject",
        #        "Serial Number",        
        #        "Completed Date",            
        #        "Test Administrator",   
        #        "Assigned",             
        #        "Test Event Site",   
        #        "Drop Off Info",             
        #        "Pick Up Info"                
        #    ]
        #    
        #]
        #
        #tests = $focus_student.tests.existing_records("ORDER BY created_date DESC")
        #tests.each{|test|
        #    
        #    row = Array.new
        #    
        #    row.push(test.fields["test_id"              ].web.select(:dd_choices=>test_types_dd,  :disabled=>true) )  
        #    row.push(test.fields["test_event_id"        ].web.select(:dd_choices=>test_events_dd, :disabled=>true) )  
        #    row.push(test.fields["test_subject_id"      ].web.select(:dd_choices=>test_subjects_dd(test.fields["test_id"].value)) )          
        #    row.push(test.fields["serial_number"        ].web.text() )        
        #    row.push(test.fields["completed"            ].web.default() )            
        #    row.push(test.fields["test_administrator"   ].web.select({:dd_choices=>test_admin_dd}) )   if test_admin_dd #ELSE NO STAFF ASSIGNED
        #    row.push(test.fields["assigned"             ].web.default() )            
        #    row.push(test.fields["test_event_site_id"   ].web.select({:dd_choices=>event_sites_dd(test.fields["test_event_id"].value)}, true) )  
        #    row.push(test.fields["drop_off"             ].web.default() )             
        #    row.push(test.fields["pick_up"              ].web.default() )
        #    
        #    tables_array.push(row)
        #    
        #} if tests
        #
        #return $kit.tools.data_table(tables_array, "tests")            
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
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
        output << ""
        
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