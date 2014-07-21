#!/usr/local/bin/ruby

class ILP_VAULT_WEB

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return "ILP Vault"
    end
    
    def page_title
        return "ILP Vault"
    end
    
    def load
        
        tabs = Array.new
        
        tabs.push(["ILP Categories",    load_tab_1  ])
        tabs.push(["ILP Types",         ""          ])
        
        output = $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            search          = false
        )
        
        "<div
            class='student_container'
            id='student_container'>
            #{output}
        </div>"
        
    end
    
    def response
        
        if $kit.params[:add_new_ILP_ENTRY_CATEGORY]
            
            $kit.modify_tag_content("tabs-1", load_tab_1,   "update")
            
            tab_contents    = load_tab_2($kit.rows[:ILP_ENTRY_CATEGORY].primary_id)
            further_actions = "<eval_script>selectTab('2');</eval_script>"
            $kit.modify_tag_content("tabs-2", "#{tab_contents}#{further_actions}",           "update")
            
        end
        
        if $kit.params[:add_new_ILP_ENTRY_TYPE]
            
            tab_contents    = load_tab_2($kit.params[:field_id____ILP_ENTRY_TYPE__category_id])
            further_actions = "<eval_script></eval_script>"  
            $kit.modify_tag_content("tabs-2", "#{tab_contents}#{further_actions}", "update")
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def load_tab_1(arg = nil)#ILP_ENTRY_CATEGORY
        
        output = String.new
        
        table_array = Array.new
        
        output << $tools.button_new_row(table_name = "ILP_ENTRY_CATEGORY")
        
        table_array.push(
            
            #HEADERS
            [
                "Related Types",
                "Name",
                "Setting"
            ]
            
        )
        
        pids = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids("ORDER BY name ASC")
        pids.each{|pid|
            
            record = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(pid)
            
            this_description    = record.fields["description"   ].web.default(:label_option=>"Description:")
            this_manual         = record.fields["manual"        ].web.default(:label_option=>"Manual Entry Allowed?")
            this_max_entries    = record.fields["max_entries"   ].web.default(:label_option=>"Max Entries:")
            this_display        = record.fields["display_type"  ].web.select(:label_option=>"Display Type:",:dd_choices=>display_type_dd)
            this_pdf_order      = record.fields["pdf_order"     ].web.select(:label_option=>"PDF Display Order:",:dd_choices=>$dd.range(1,pids.length))
            
            include_fields_array = [
                
                ["<b>Field Name</b>",       "<b>Custom Field Label</b>",                                          "<b>Interface?</b>",                                           "<b>PDF?</b>",                                          "<b>Order</b>"                                          ],
                ["Category",                record.fields["label_ilp_entry_category_id" ].web.text,record.fields["interface_ilp_entry_category_id" ].web.default, record.fields["pdf_ilp_entry_category_id"].web.default, record.fields["order_ilp_entry_category_id"].web.select(:dd_choices=>$dd.range(1,20))],
                ["Type",                    record.fields["label_ilp_entry_type_id"     ].web.text,record.fields["interface_ilp_entry_type_id"     ].web.default, record.fields["pdf_ilp_entry_type_id"    ].web.default, record.fields["order_ilp_entry_type_id"    ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Goal Type",               record.fields["label_goal_type"             ].web.text,record.fields["interface_goal_type"             ].web.default, record.fields["pdf_goal_type"            ].web.default, record.fields["order_goal_type"            ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Description",             record.fields["label_description"           ].web.text,record.fields["interface_description"           ].web.default, record.fields["pdf_description"          ].web.default, record.fields["order_description"          ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Solution",                record.fields["label_solution"              ].web.text,record.fields["interface_solution"              ].web.default, record.fields["pdf_solution"             ].web.default, record.fields["order_solution"             ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Completed?",              record.fields["label_completed"             ].web.text,record.fields["interface_completed"             ].web.default, record.fields["pdf_completed"            ].web.default, record.fields["order_completed"            ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Progress",                record.fields["label_progress"              ].web.text,record.fields["interface_progress"              ].web.default, record.fields["pdf_progress"             ].web.default, record.fields["order_progress"             ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Monday",                  record.fields["label_monday"                ].web.text,record.fields["interface_monday"                ].web.default, record.fields["pdf_monday"               ].web.default, record.fields["order_monday"               ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Tuesday",                 record.fields["label_tuesday"               ].web.text,record.fields["interface_tuesday"               ].web.default, record.fields["pdf_tuesday"              ].web.default, record.fields["order_tuesday"              ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Wednesday",               record.fields["label_wednesday"             ].web.text,record.fields["interface_wednesday"             ].web.default, record.fields["pdf_wednesday"            ].web.default, record.fields["order_wednesday"            ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Thursday",                record.fields["label_thursday"              ].web.text,record.fields["interface_thursday"              ].web.default, record.fields["pdf_thursday"             ].web.default, record.fields["order_thursday"             ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Friday",                  record.fields["label_friday"                ].web.text,record.fields["interface_friday"                ].web.default, record.fields["pdf_friday"               ].web.default, record.fields["order_friday"               ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 1",                   record.fields["label_day1"                  ].web.text,record.fields["interface_day1"                  ].web.default, record.fields["pdf_day1"                 ].web.default, record.fields["order_day1"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 2",                   record.fields["label_day2"                  ].web.text,record.fields["interface_day2"                  ].web.default, record.fields["pdf_day2"                 ].web.default, record.fields["order_day2"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 3",                   record.fields["label_day3"                  ].web.text,record.fields["interface_day3"                  ].web.default, record.fields["pdf_day3"                 ].web.default, record.fields["order_day3"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 4",                   record.fields["label_day4"                  ].web.text,record.fields["interface_day4"                  ].web.default, record.fields["pdf_day4"                 ].web.default, record.fields["order_day4"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 5",                   record.fields["label_day5"                  ].web.text,record.fields["interface_day5"                  ].web.default, record.fields["pdf_day5"                 ].web.default, record.fields["order_day5"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 6",                   record.fields["label_day6"                  ].web.text,record.fields["interface_day6"                  ].web.default, record.fields["pdf_day6"                 ].web.default, record.fields["order_day6"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Day 7",                   record.fields["label_day7"                  ].web.text,record.fields["interface_day7"                  ].web.default, record.fields["pdf_day7"                 ].web.default, record.fields["order_day7"                 ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Re-Eval Date",            record.fields["label_expiration_date"       ].web.text,record.fields["interface_expiration_date"       ].web.default, record.fields["pdf_expiration_date"      ].web.default, record.fields["order_expiration_date"      ].web.select(:dd_choices=>$dd.range(1,20))],
                ["PDF Excluded?",           record.fields["label_pdf_excluded"          ].web.text,record.fields["interface_pdf_excluded"          ].web.default, record.fields["pdf_pdf_excluded"         ].web.default, record.fields["order_pdf_excluded"         ].web.select(:dd_choices=>$dd.range(1,20))],
                ["Responsible Parties",     record.fields["label_responsible_parties"   ].web.text,record.fields["interface_responsible_parties"   ].web.default, record.fields["pdf_responsible_parties"  ].web.default, record.fields["order_responsible_parties"  ].web.select(:dd_choices=>$dd.range(1,20))]
               
            ]
            
            include_fields_table = $tools.table(
                
                :table_array    => include_fields_array,
                :unique_name    => "related_classes",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
                
            )
            
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
            
            grades_included = $tools.table(
                :table_array    => grades,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Eligible Grades"
            )
            
            table_array.push(
                
                [
                    $tools.button_load_tab(2, "Types", pid),
                    record.fields["name"                    ].web.text,
                    "#{grades_included}#{this_description}<div id='group_container'>#{this_manual}#{this_max_entries}#{this_pdf_order}#{this_display}</div>#{include_fields_table}"
                    
                ]
                
            )
            
        } if pids
        
        output << $tools.data_table(table_array, "ilp_entry_category")
       
        return output
        
    end
    
    def load_tab_2(category_id = nil)#ILP_ENTRY_TYPE
        
        output = String.new
        
        output << $tools.newlabel("ilp_entry_type_header", "Types for the '#{$tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(category_id).fields["name"].value}' category.")
        
        output << "<input id='category_id' type='hidden' name='category_id' value='#{category_id}'/>"
        
        table_array = Array.new
        
        output << $tools.button_new_row(table_name = "ILP_ENTRY_TYPE", "category_id")
        
        table_array.push(
            
            #HEADERS
            [
             
                "Name",
                "Default Description",
                "Default Solution",
                "Required",
                "Maximum Entries",
                "Manual Entry Allowed?",
                "Grades to Include"
                
            ]
            
        )
        
        pids = $tables.attach("ILP_ENTRY_TYPE").primary_ids("WHERE category_id = '#{category_id}' ORDER BY name ASC")
        pids.each{|pid|
            
            record = $tables.attach("ILP_ENTRY_TYPE").by_primary_id(pid)
            
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
            
            grades_included = $tools.table(
                :table_array    => grades,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            table_array.push(
                [
                    
                    record.fields["name"                    ].web.text,
                    record.fields["default_description"     ].web.default,
                    record.fields["default_solution"        ].web.default,
                    record.fields["required"                ].web.default,
                    record.fields["max_entries"             ].web.select(:dd_choices=>$dd.range(1,10)),
                    record.fields["manual"                  ].web.default,
                    grades_included
                    
                ]
            )
            
        } if pids
        
        output << $tools.data_table(table_array, "ilp_entry_type")
       
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_ilp_entry_category
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "General Info",
                "Fields to Include",
                "Grades Included"
                
            ]
            
        ]
      
        record = $tables.attach("ILP_ENTRY_CATEGORY").new_row
        
        include_fields_array = [
           
            ["<b>Field Name</b>",       "<b>Custom Field Label</b>",                            "<b>Interface?</b>",                                           "<b>PDF?</b>",                                          "<b>Order</b>"                                                                       ],
            ["Goal Type",               record.fields["label_goal_type"             ].web.text, record.fields["interface_goal_type"             ].web.default, record.fields["pdf_goal_type"            ].web.default, record.fields["order_goal_type"            ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Description",             record.fields["label_description"           ].web.text, record.fields["interface_description"           ].web.default, record.fields["pdf_description"          ].web.default, record.fields["order_description"          ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Solution",                record.fields["label_solution"              ].web.text, record.fields["interface_solution"              ].web.default, record.fields["pdf_solution"             ].web.default, record.fields["order_solution"             ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Completed?",              record.fields["label_completed"             ].web.text, record.fields["interface_completed"             ].web.default, record.fields["pdf_completed"            ].web.default, record.fields["order_completed"            ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Progress",                record.fields["label_progress"              ].web.text, record.fields["interface_progress"              ].web.default, record.fields["pdf_progress"             ].web.default, record.fields["order_progress"             ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Monday",                  record.fields["label_monday"                ].web.text, record.fields["interface_monday"                ].web.default, record.fields["pdf_monday"               ].web.default, record.fields["order_monday"               ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Tuesday",                 record.fields["label_tuesday"               ].web.text, record.fields["interface_tuesday"               ].web.default, record.fields["pdf_tuesday"              ].web.default, record.fields["order_tuesday"              ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Wednesday",               record.fields["label_wednesday"             ].web.text, record.fields["interface_wednesday"             ].web.default, record.fields["pdf_wednesday"            ].web.default, record.fields["order_wednesday"            ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Thursday",                record.fields["label_thursday"              ].web.text, record.fields["interface_thursday"              ].web.default, record.fields["pdf_thursday"             ].web.default, record.fields["order_thursday"             ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Friday",                  record.fields["label_friday"                ].web.text, record.fields["interface_friday"                ].web.default, record.fields["pdf_friday"               ].web.default, record.fields["order_friday"               ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 1",                   record.fields["label_day1"                  ].web.text, record.fields["interface_day1"                  ].web.default, record.fields["pdf_day1"                 ].web.default, record.fields["order_day1"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 2",                   record.fields["label_day2"                  ].web.text, record.fields["interface_day2"                  ].web.default, record.fields["pdf_day2"                 ].web.default, record.fields["order_day2"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 3",                   record.fields["label_day3"                  ].web.text, record.fields["interface_day3"                  ].web.default, record.fields["pdf_day3"                 ].web.default, record.fields["order_day3"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 4",                   record.fields["label_day4"                  ].web.text, record.fields["interface_day4"                  ].web.default, record.fields["pdf_day4"                 ].web.default, record.fields["order_day4"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 5",                   record.fields["label_day5"                  ].web.text, record.fields["interface_day5"                  ].web.default, record.fields["pdf_day5"                 ].web.default, record.fields["order_day5"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 6",                   record.fields["label_day6"                  ].web.text, record.fields["interface_day6"                  ].web.default, record.fields["pdf_day6"                 ].web.default, record.fields["order_day6"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Day 7",                   record.fields["label_day7"                  ].web.text, record.fields["interface_day7"                  ].web.default, record.fields["pdf_day7"                 ].web.default, record.fields["order_day7"                 ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Re-Eval Date",            record.fields["label_expiration_date"       ].web.text, record.fields["interface_expiration_date"       ].web.default, record.fields["pdf_expiration_date"      ].web.default, record.fields["order_expiration_date"      ].web.select(:dd_choices=>$dd.range(1,20))],
            ["PDF Excluded?",           record.fields["label_pdf_excluded"          ].web.text, record.fields["interface_pdf_excluded"          ].web.default, record.fields["pdf_pdf_excluded"         ].web.default, record.fields["order_pdf_excluded"         ].web.select(:dd_choices=>$dd.range(1,20))],
            ["Responsible Parties",     record.fields["label_responsible_parties"   ].web.text, record.fields["interface_responsible_parties"   ].web.default, record.fields["pdf_responsible_parties"  ].web.default, record.fields["order_responsible_parties"  ].web.select(:dd_choices=>$dd.range(1,20))]
           
        ]
        
        include_fields_table = $tools.table(
            
            :table_array    => include_fields_array,
            :unique_name    => "related_classes",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
            
        )
        
        categories = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids
        
        this_name           = record.fields["name"                      ].web.text(     :label_option=>"Name:")
        this_description    = record.fields["description"               ].web.default(  :label_option=>"Description:")
        this_manual         = record.fields["manual"                    ].set(true).web.default(  :label_option=>"Manual Entry Allowed?")
        this_max_entries    = record.fields["max_entries"               ].web.select(   :label_option=>"Max Entries:",:dd_choices=>$dd.range(1,10))
        this_display        = record.fields["display_type"              ].web.select(   :label_option=>"Display Type:",:dd_choices=>display_type_dd)
        this_pdf_order      = record.fields["pdf_order"                 ].web.select(   :label_option=>"PDF Display Order:",:dd_choices=>$dd.range(1,(categories ? categories.length+1 : 1)))
        
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
        
        grades_included = $tools.table(
            :table_array    => grades,
            :unique_name    => "eligible_grades",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array.push(
            
            [
                
                "#{this_name}#{this_description}#{this_manual}#{this_max_entries}#{this_pdf_order}#{this_display}",
                include_fields_table,
                grades_included
                
            ]
            
        )
        
        output << $kit.tools.data_table(tables_array, "ILP_ENTRY_CATEGORY", type = "NewRecord")
        
        return output
        
    end

    def add_new_record_ilp_entry_type
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "Name",
                "Default Description",
                "Default Solution",
                "Required",
                "Maximum Entries",
                "Manual Entry Allowed?",
                "Grades Included"
                
            ]
            
        ]
      
        record = $tables.attach("ILP_ENTRY_TYPE").new_row
        
        output << record.fields["category_id"].set($kit.params[:category_id]).web.hidden
        
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
        
        grades_included = $tools.table(
            :table_array    => grades,
            :unique_name    => "eligible_grades",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array.push(
            
            [
                
                record.fields["name"                    ].web.text,
                record.fields["default_description"     ].web.default,
                record.fields["default_solution"        ].web.default,
                record.fields["required"                ].set(false).web.default,
                record.fields["max_entries"             ].web.select(:dd_choices=>$dd.range(1,10)),
                record.fields["manual"                  ].set(true).web.default,
                grades_included
                
            ]
            
        )
        
        output << $kit.tools.data_table(tables_array, "ILP_ENTRY_TYPE", type = "NewRecord")
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def category_dd
        
        $tables.attach("ILP_ENTRY_CATEGORY").dd_choices(
            "name",
            "primary_id",
            "ORDER BY name ASC"
        )
    end
    
    def display_type_dd
        $dd.from_array(["Default","Table","Table 2","Schedule - Weekly","Schedule - 6 Day","Schedule - 7 Day"])
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def css
        
        output = "<style>
        
        #eligible_grades_container > table {
            margin-left: auto;
            margin-right: auto;
        }
        #related_classes_container{
            float: right;
        }
        #group_container{
            display: inline-block;
            width:295px;
        }
        div.ilp_entry_type_header{
            margin-bottom:10px;
            font-size: 1.5em;
        }
        
        div.ILP_ENTRY_TYPE__default_description     textarea{ clear: left; display: block; width: 350px; height: 100px; resize: none; overflow-y: scroll;}
        div.ILP_ENTRY_TYPE__default_solution        textarea{ clear: left; display: block; width: 350px; height: 100px; resize: none; overflow-y: scroll;}
        div.ILP_ENTRY_TYPE__required                        {text-align: center;}
        div.ILP_ENTRY_TYPE__max_entries                     {text-align: center;}
        div.ILP_ENTRY_TYPE__manual                          {text-align: center;}
        
        div.ILP_ENTRY_CATEGORY__name                        {margin-top: 2px; margin-bottom: 2px;}
        div.ILP_ENTRY_CATEGORY__description                 {margin-top: 2px; margin-bottom: 2px; width: 100%;}
        div.ILP_ENTRY_CATEGORY__manual                      {margin-top: 2px; margin-bottom: 2px;width: 290px;}
        div.ILP_ENTRY_CATEGORY__pdf_order                   {margin-top: 2px; margin-bottom: 2px;width: 290px;}
        div.ILP_ENTRY_CATEGORY__max_entries                 {margin-top: 2px; margin-bottom: 2px;width: 290px;}
        div.ILP_ENTRY_CATEGORY__display_type                {margin-top: 2px; margin-bottom: 2px;width: 290px;}
        
        div.ILP_ENTRY_CATEGORY__name                        label{font-size: 1.2em; }
        div.ILP_ENTRY_CATEGORY__description                 label{font-size: 1.2em; margin-bottom: 3px; }
        div.ILP_ENTRY_CATEGORY__manual                      label{font-size: 1.2em; margin-right:26px;}
        div.ILP_ENTRY_CATEGORY__max_entries                 label{font-size: 1.2em; margin-right:36px;}
        div.ILP_ENTRY_CATEGORY__display_type                label{font-size: 1.2em; margin-right:29px;}
        div.ILP_ENTRY_CATEGORY__pdf_order                   label{font-size: 1.2em; margin-right:-2px;}
        
        div.ILP_ENTRY_CATEGORY__description  textarea{display: block; width: 99.5%; height: 100px; resize: none; overflow-y: scroll;}
        
        div.ILP_ENTRY_CATEGORY__interface_solution              {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_completed             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_goal_type             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_progress              {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_expiration_date       {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_responsible_parties   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_solution                    {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_completed                   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_goal_type                   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_progress                    {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_expiration_date             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_responsible_parties         {text-align: center;}
        
        div.ILP_ENTRY_CATEGORY__interface_ilp_entry_category_id {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_ilp_entry_type_id     {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_goal_type             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_description           {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_solution              {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_completed             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_progress              {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_monday                {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_tuesday               {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_wednesday             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_thursday              {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_friday                {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day1                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day2                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day3                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day4                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day5                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day6                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_day7                  {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_expiration_date       {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_pdf_excluded          {text-align: center;}
        div.ILP_ENTRY_CATEGORY__interface_responsible_parties   {text-align: center;}
        
        div.ILP_ENTRY_CATEGORY__pdf_ilp_entry_category_id       {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_ilp_entry_type_id           {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_goal_type                   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_description                 {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_solution                    {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_completed                   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_progress                    {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_monday                      {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_tuesday                     {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_wednesday                   {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_thursday                    {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_friday                      {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day1                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day2                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day3                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day4                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day5                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day6                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_day7                        {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_expiration_date             {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_pdf_excluded                {text-align: center;}
        div.ILP_ENTRY_CATEGORY__pdf_responsible_parties         {text-align: center;}
        
        div.related_classes_container {height:165px; overflow-y: scroll; resize: none; width: 460px;}
        
        input.ILP_ENTRY_CATEGORY__name                          {width:150px;}
        
        </style>"
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type='text/javascript'>"
        output << "</script>"
        return output
    end
    
end