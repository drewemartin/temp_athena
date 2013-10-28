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
        
        tabs.push(["Dictionaries",              load_tab_1  ])
        tabs.push(["Calendars",                 load_tab_2  ])
        tabs.push(["Auto Update - Sapphire",    load_tab_3  ])
        
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
        
        if $kit.params[:add_new_SAPPHIRE_INTERFACE_MAP]
            $kit.modify_tag_content("tabs-3", load_tab_3 , "update")
        end
        
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
    
    def add_new_record_sapphire_interface_map
        
        output = String.new
        
        table_array = Array.new
        
        table_array.push(
            
            #HEADERS
            [
             
                "Settings",
                "active"             
                
            ]
            
        )
        
        record = $tables.attach("SAPPHIRE_INTERFACE_MAP").new_row
        
        setting_field = "<DIV class='settings_container'>"
        setting_field << record.fields["sapphire_option_id"  ].web.select(
            :label_option   => "Sapphire Option",
            :dd_choices     => sapphire_options_dd
        )
        setting_field << record.fields["athena_table"        ].web.select(
            :label_option   => "Athena Table",
            :dd_choices     => $dd.from_array($tables.student_table_names),
            :onchange       => "fill_select_option('#{record.fields["athena_field" ].web.field_id}', this  );",
            :validate       => true
        )
        setting_field << record.fields["athena_field"        ].web.select(
            :label_option   => "Athena Field",
            :dd_choices     =>
                !record.fields["athena_table"].value.nil? ? $dd.from_array($tables.attach(record.fields["athena_table"].value).field_order) : nil,
            :validate       => true
        )
        setting_field << record.fields["trigger_event"       ].web.select(
            :label_option   => "Trigger Event",
            :dd_choices     => $dd.from_array(["after_change_field","after_insert"]))
        setting_field << "</DIV>"
        
        row = Array.new
        row.push(
            
            setting_field,
            record.fields["active"].set('1').web.select(:dd_choices=>$dd.bool)
            
        )
        
        table_array.push(row) 
        
        output << $kit.tools.data_table(table_array, "SAPPHIRE_INTERFACE_MAP", type = "NewRecord")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def expand_calendars
        
        output = String.new
        
        table_array = Array.new
        
        output << "<div class='table_container'>"
        
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
        
        output << "</div>"
       
        return output
        
    end

    def expand_periods
        
        output = String.new
        
        table_array = Array.new
        
        output << "<div class='table_container'>"
        
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
        
        output << "</div>"
       
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_FILL_SELECT_OPTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def fill_select_option_athena_field(field_name, field_value, pid)
        
        return $tables.attach("SAPPHIRE_INTERFACE_MAP").new_row.fields["athena_field"].web.select(:dd_choices=>$dd.from_array($tables.attach(field_value).field_order))
        
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
                "7",
                "M",
                "T",
                "W",
                "R",
                "F"
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
    
    def sapphire_options_dd
        
        $tables.attach("SAPPHIRE_INTERFACE_OPTIONS").dd_choices(
            "CONCAT(IFNULL(IF(module_name = 'Student Information System','SIS',module_name),''), ' - ', path, ' - ', option_name)",
            "primary_id",
            "WHERE standard IS TRUE"
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

    def load_tab_3(arg = nil)#AUTO UPDATE
        
        output = String.new
        
        table_array = Array.new
        
        output << "<div class='table_container'>"
        
        output << $tools.button_new_row(table_name = "SAPPHIRE_INTERFACE_MAP")
        
        table_array.push(
            
            #HEADERS
            [
             
                "Settings",
                "active"             
                
            ]
            
        )
        
        pids = $tables.attach("SAPPHIRE_INTERFACE_MAP").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("SAPPHIRE_INTERFACE_MAP").by_primary_id(pid)
            
            setting_field = "<DIV class='settings_container'>"
            setting_field << record.fields["sapphire_option_id"  ].web.select(
                :disabled       => true,
                :label_option   => "Sapphire Option",
                :dd_choices     => sapphire_options_dd
            )
            setting_field << record.fields["athena_table"        ].web.select(
                :disabled       => true,
                :label_option   => "Athena Table",
                :dd_choices     => $dd.from_array($tables.student_table_names),
                :onchange       => "fill_select_option('#{record.fields["athena_field" ].web.field_id}', this  );",
                :validate       => true
            )
            setting_field << record.fields["athena_field"        ].web.select(
                :disabled       => true,
                :label_option   => "Athena Field",
                :dd_choices     =>
                    !record.fields["athena_table"].value.nil? ? $dd.from_array($tables.attach(record.fields["athena_table"].value).field_order) : nil,
                :validate       => true
            )
            setting_field << record.fields["trigger_event"       ].web.select(
                :disabled       => true,
                :label_option   => "Trigger Event",
                :dd_choices     => $dd.from_array(["after_change_field","after_insert"]))
            setting_field << "</DIV>"
            
            row = Array.new
            row.push(
                
                setting_field,
                record.fields["active"].web.select(:dd_choices=>$dd.bool)
                
            )
            
            table_array.push(row)
            
        } if pids
        
        output << $tools.data_table(table_array, "sapphire_calendars_calendars")
        
        output << "</div>"
       
        return output
        
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
                margin-bottom:5px;
            }
            button.new_row_button_SAPPHIRE_DICTIONARY_PERIODS {
                margin-top: 10px;
                margin-bottom:5px;
            }
            .table_container{
                margin-bottom:25px;
            }
            div.settings_container  select{ width: 600px;}
            div.settings_container  label{  width: 100px; display: inline-block;}
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