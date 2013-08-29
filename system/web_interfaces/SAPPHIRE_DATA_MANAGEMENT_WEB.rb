#!/usr/local/bin/ruby

class SAPPHIRE_DATA_MANAGEMENT_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return "Sapphire Data Management"
    end
    
    def page_title
        
        "Sapphire Data Management"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        tabs = Array.new
        
        tabs.push(["Dictionaries",  load_tab_1  ])
        tabs.push(["Calendars",     load_tab_2  ])
        
        output = $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            search          = false
        )
        
        "<div
            class='sapphire_data_management_container'
            id='sapphire_data_management'>
            #{output}
        </div>"
        
    end
    
    def response
        
        #if $kit.params[:add_new_SAPPHIRE_CALENDARS_CALENDARS]
        #    
        #    $kit.modify_tag_content("tabs-1", load_tab_1,   "update")
        #    
        #    tab_contents    = load_tab_2($kit.rows[:ILP_ENTRY_CATEGORY].primary_id)
        #    further_actions = "<eval_script>selectTab('2');</eval_script>"
        #    $kit.modify_tag_content("tabs-2", "#{tab_contents}#{further_actions}",           "update")
        #    
        #end
        #
        #if $kit.params[:add_new_SAPPHIRE_CALENDARS_CALENDARS]
        #    
        #    tab_contents    = load_tab_2($kit.params[:field_id____ILP_ENTRY_TYPE__category_id])
        #    further_actions = "<eval_script></eval_script>"  
        #    $kit.modify_tag_content("tabs-2", load_tab_2, "update")
        #    
        #end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_sapphire_calendars_calendars
        
        output = String.new
        
        table_array = [
            
            #HEADERS
            [
                "school"                ,
                "date"                  ,
                "day"                   ,
                "non_school_day_type"   ,
                "day_code"              ,
                "count_day"             ,
                "student_attend"         
            ]
            
        ]
      
        record = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").new_row
        
        row = Array.new
        row.push(record.fields["school"              ].web.select(:dd_choices=>schools_dd))
        row.push(record.fields["date"                ].web.default())
        row.push(record.fields["day"                 ].web.select(:dd_choices=>day_dd))
        row.push(record.fields["non_school_day_type" ].web.select(:dd_choices=>non_school_day_type_dd))
        row.push(record.fields["day_code"            ].web.select(:dd_choices=>day_code_dd))
        row.push(record.fields["count_day"           ].web.default())
        row.push(record.fields["student_attend"      ].web.select(:dd_choices=>student_attend_dd))
        
        table_array.push(row) 
        
        output << $kit.tools.data_table(table_array, "SAPPHIRE_CALENDARS_CALENDARS", type = "NewRecord")
        
        return output
        
    end

    def add_new_record_sapphire_dictionary_periods
        
        output = String.new
        
        table_array = [
            
            #HEADERS
            [
                "School"           ,
                "period_code"      ,
                "period_decription",
                "start_time"       ,
                "end_time"         ,
                "sequence"         ,
                "schedule"         ,
                "daily_attendance" ,
                "delete"            
            ]
            
        ]
      
        record = $tables.attach("SAPPHIRE_DICTIONARY_PERIODS").new_row
        
        row = Array.new
        row.push(record.fields["school_type"      ].web.select(:dd_choices=>schools_dd))
        row.push(record.fields["period_code"      ].web.text())
        row.push(record.fields["period_decription"].web.text())
        row.push(record.fields["start_time"       ].web.text())
        row.push(record.fields["end_time"         ].web.text())
        row.push(record.fields["sequence"         ].web.default())
        row.push(record.fields["schedule"         ].web.default())
        row.push(record.fields["daily_attendance" ].web.default())
        row.push(record.fields["delete"           ].web.default())
        
        table_array.push(row) 
        
        output << $kit.tools.data_table(table_array, "SAPPHIRE_DICTIONARY_PERIODS", type = "NewRecord")
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def expand_calendars
        
        output = String.new
        
        table_array = Array.new
        
        output << $tools.button_new_row(table_name = "SAPPHIRE_CALENDARS_CALENDARS")
        
        table_array.push(
            
            #HEADERS
            [
                "school"                ,
                "date"                  ,
                "day"                   ,
                "non_school_day_type"   ,
                "day_code"              ,
                "count_day"             ,
                "student_attend"                        
            ]
            
        )
        
        pids = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").primary_ids("ORDER BY school, date ASC")
        pids.each{|pid|
            
            record = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").by_primary_id(pid)
            
            table_array.push
            
            row = Array.new
            row.push(record.fields["school"              ].web.select(:dd_choices=>schools_dd))
            row.push(record.fields["date"                ].web.default())
            row.push(record.fields["day"                 ].web.select(:dd_choices=>day_dd))
            row.push(record.fields["non_school_day_type" ].web.select(:dd_choices=>non_school_day_type_dd))
            row.push(record.fields["day_code"            ].web.select(:dd_choices=>day_code_dd))
            row.push(record.fields["count_day"           ].web.default())
            row.push(record.fields["student_attend"      ].web.select(:dd_choices=>student_attend_dd))
            
            table_array.push(row)
            
        } if pids
        
        output << $tools.data_table(table_array, "sapphire_calendars_calendars")
       
        return output
        
    end

    def expand_periods
        
        output = String.new
        
        table_array = Array.new
        
        output << $tools.button_new_row(table_name = "SAPPHIRE_DICTIONARY_PERIODS")
        
        table_array.push(
            
            #HEADERS
            [
                "School"           ,
                "period_code"      ,
                "period_decription",
                "start_time"       ,
                "end_time"         ,
                "sequence"         ,
                "schedule"         ,
                "daily_attendance" ,
                "delete"            
            ]
            
        )
        
        pids = $tables.attach("SAPPHIRE_DICTIONARY_PERIODS").primary_ids("ORDER BY school_type, period_code ASC")
        pids.each{|pid|
            
            record = $tables.attach("SAPPHIRE_DICTIONARY_PERIODS").by_primary_id(pid)
            
            table_array.push
            
            row = Array.new
            row.push(record.fields["school_type"      ].web.select(:dd_choices=>schools_dd))
            row.push(record.fields["period_code"      ].web.text())
            row.push(record.fields["period_decription"].web.text())
            row.push(record.fields["start_time"       ].web.text())
            row.push(record.fields["end_time"         ].web.text())
            row.push(record.fields["sequence"         ].web.default())
            row.push(record.fields["schedule"         ].web.default())
            row.push(record.fields["daily_attendance" ].web.default())
            row.push(record.fields["delete"           ].web.default())
            
            table_array.push(row)
            
        } if pids
        
        output << $tools.data_table(table_array, "sapphire_dictionary_periods")
       
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def day_dd
        $dd.from_array(
            [
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat",
                "Sun"
            ]
        )
    end

    def day_code_dd
        $dd.from_array(
            [
                "N/A",
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7"
            ]
        )
    end
    
    def non_school_day_type_dd
        $dd.from_array(
            [
                "ACT 80 Day",
                "EMERGENCY DAY",
                "Holiday",
                "INSERVICE DAY",
                "PARENT CONFERENCE",
                "Saturday",
                "Snow Day",
                "Sunday",
                "XXX"
            ]
        )
    end
    
    def schools_dd
        $dd.from_array(
            [
             "HS",
             "MS",
             "EL"
            ]
        )
    end
    
    def student_attend_dd
        $dd.from_array(
            [
                "Full Day"      ,
                "Half Day (AM)" ,
                "Half Day (PM)" ,
                "No School"
            ]
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def load_tab_1(arg = nil)#DICTIONARIES
        
        $tools.expandable_section("Periods")
        
    end

    def load_tab_2(arg = nil)#CALENDARS
        
        $tools.expandable_section("Calendars")
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>
            button.new_row_button_SAPPHIRE_CALENDARS_CALENDARS {
                margin-top: 10px;
            }
            button.new_row_button_SAPPHIRE_DICTIONARY_PERIODS {
                margin-top: 10px;
            }
        </style>"
        
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