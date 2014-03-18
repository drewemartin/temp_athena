#!/usr/local/bin/ruby


class TEST_PACKETS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    
    def breakaway_caption
        return "Test Packets Management"
    end
    
    def page_title
        "Test Packets Management"
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        output = "<div id='student_container'>"
        
        output << test_search
        
        output << "<button class='new_breakaway_button' id='test_packets_search_dialog_button'>Test Packet Search</button>"
        output << $tools.button_upload_table("TEST_PACKETS", nil, "Upload Test Packets")
        
        output << $tools.div_open("test_packets_record_container", "test_packets_record_container")
        output << $tools.legend_open("information", "Information")
        output << $tools.newlabel("no_info", "Please search for a test packet.")
        output << $tools.legend_close()
        output << $tools.legend_open("checkin", "Location Assignment History")
        output << $tools.newlabel("no_info", "")
        output << $tools.legend_close()
        output << $tools.div_close()
        
        return output
        
    end
    
    def search_results
        
        output = String.new
        
        output << $tools.div_open("search_results", "search_results")
        output << $tools.newlabel("no_search", "Please Search For Tests")
        output << $tools.div_close()
    
    end
    
    def test_packet_results(where_clause)
        
        output = String.new
        
        tables_array = Array.new
     
        #HEADERS
        tables_array.push([
            "Select",
            "Edit",
            "Student ID",
            "First Name",
            "Last Name",
            "Serial Number",
            "Status",
            "Verified",
            "Returned to Warehouse (to be shipped)",
            "Test Event",
            "Test Event Site",
            "Subject",
            "Test Type",
            "Admin Team Member",
            "Grade",
            "Large Print"
        ])
        
        pids = $tables.attach("TEST_PACKETS").primary_ids(where_clause)
        
        if pids
            
            output << $tools.button_batch_update(
                
                :batch_action       => "batch_update_location"              ,
                :button_text        => "Location Assignment"                ,
                :select_values      => test_event_sites_dd(test_event_id=1)#remove this parameter after testing
                
            )
            
        end
        
        search_limit = 700
        
        if pids && pids.length >= search_limit
            
            pids = pids.first(search_limit)
            
            output << "<div id='too_many'>More than #{search_limit.to_s} results found. Please refine your search results.</div>"
            
        end
        
        pids.each{|pid|
            
            record = $tables.attach("TEST_PACKETS").by_primary_id(pid)
            
            row = Array.new
            
            row.push(record.batch_checkbox  )
            row.push("<button class='new_breakaway_button' id='load_test_packets_record_button_#{pid}' onclick='send\(\"load_test_packets_record_#{pid}\"\)\;setPreSpinner\(\"test_packets_record_container\"\);$\(\"#test_packets_search_dialog\"\).dialog\(\"close\"\)'>Edit</button><input id='load_test_packets_record_#{pid}' type='hidden' value='#{pid}' name='load_test_packets_record'")
            row.push(record.fields["student_id"            ].value||"N/A")
            row.push($tables.attach("STUDENT").field_value("studentfirstname", "WHERE student_id = '#{record.fields["student_id"].value}'")||"N/A")
            row.push($tables.attach("STUDENT").field_value("studentlastname",  "WHERE student_id = '#{record.fields["student_id"].value}'")||"N/A")
            row.push(record.fields["serial_number"         ].value)
            row.push(record.fields["status"                ].web.select(:dd_choices=>status_dd))
            row.push(record.fields["verified"              ].web.checkbox())
            row.push(record.fields["returned_to_warehouse" ].web.checkbox())
            row.push($tables.attach("TEST_EVENTS"     ).field_value("name",      "WHERE primary_id = '#{record.fields["test_event_id"     ].value}'"))
            row.push($tables.attach("TEST_EVENT_SITES").field_value("site_name", "WHERE primary_id = '#{record.fields["test_event_site_id"].value}'"))
            row.push($tables.attach("TEST_SUBJECTS"   ).field_value("name",      "WHERE primary_id = '#{record.fields["subject_id"        ].value}'"))
            row.push($tables.attach("TESTS"           ).field_value("name",      "WHERE primary_id = '#{record.fields["test_type_id"      ].value}'")||"Not Selected")
            row.push(record.fields["administrator_team_id" ].to_name(:full_name))
            row.push(record.fields["grade_level"           ].value)
            row.push(record.fields["large_print"           ].to_user)
            
            tables_array.push(row)
            
        } if pids
        
        if tables_array.length > 1
            output << $kit.tools.data_table(tables_array, "test_packets")
            output << "</div>"
            return output
        else
            return false
        end
        
    end
    
    def response
        
        if !$kit.rows.first.nil? && field = $kit.rows.first[1].fields["returned_to_warehouse"]
            
            test_packet_record(pid = field.primary_id)
            
        end
        
        if $kit.params[:load_test_packets_record] || $kit.params[:add_new_TEST_PACKET_LOCATION]
            
            test_packet_record(pid = $kit.params[:load_test_packets_record] || $kit.params[:field_id____TEST_PACKET_LOCATION__test_packet_id])
            
        elsif $kit.params[:table_upload]
            
            output = $tools.table_upload($kit.params[:table_upload], self.class.name, "test_packets_upload", size='50')
            $kit.modify_tag_content("upload_new_table_TEST_PACKETS", output, "update")
            
        elsif $kit.params[:table_upload_file]
            
            return_message = "File Upload is queued for processing."
            
            existing = $tables.attach("PROCESS_LOG").primary_ids("
                WHERE class_name = 'Load_Table_From_Csv'
                AND function_name = 'load_table'
                AND args = '#{$kit.params[:table_upload_name]}'
                AND (status IS NULL OR status = 'Processing')
            ")
            
            if !existing
                
                file_path = $reports.csv("import", $kit.params[:table_upload_name].downcase(), $kit.params[:table_upload_file], false)
                
                $base.queue_process("Load_Table_From_Csv", "load_table", $kit.params[:table_upload_name])
                
            else
                
                return_message = "You can not upload a file for this table until the previous upload is completed."
                
            end
            
            $kit.output=return_message
            
        elsif $kit.params[:packet_search]
            
            @range_included = false
            
            search_hash = Hash.new            
            search_hash[:serial_number          ] = $kit.params[:serial_number          ] if $kit.params[:serial_number         ] && $kit.params[:serial_number         ] != ""
            search_hash[:serial_number1         ] = $kit.params[:serial_number1         ] if $kit.params[:serial_number1        ] && $kit.params[:serial_number1        ] != ""
            search_hash[:serial_number2         ] = $kit.params[:serial_number2         ] if $kit.params[:serial_number2        ] && $kit.params[:serial_number2        ] != ""
            search_hash[:grade_level            ] = $kit.params[:grade_level            ] if $kit.params[:grade_level           ] && $kit.params[:grade_level           ] != ""
            search_hash[:subject_id             ] = $kit.params[:subject_id             ] if $kit.params[:subject_id            ] && $kit.params[:subject_id            ] != ""
            search_hash[:large_print            ] = $kit.params[:large_print            ] if $kit.params[:large_print           ] && $kit.params[:large_print           ] != ""
            search_hash[:test_event_id          ] = $kit.params[:test_event_id          ] if $kit.params[:test_event_id         ] && $kit.params[:test_event_id         ] != ""
            search_hash[:student_id             ] = $kit.params[:student_id             ] if $kit.params[:student_id            ] && $kit.params[:student_id            ] != ""
            search_hash[:test_event_site_id     ] = $kit.params[:test_event_site_id     ] if $kit.params[:test_event_site_id    ] && $kit.params[:test_event_site_id    ] != ""
            search_hash[:administrator_team_id  ] = $kit.params[:administrator_team_id  ] if $kit.params[:administrator_team_id ] && $kit.params[:administrator_team_id ] != ""
            search_hash[:status                 ] = $kit.params[:status                 ] if $kit.params[:status                ] && $kit.params[:status                ] != ""
            search_hash[:verified               ] = $kit.params[:verified               ] if $kit.params[:verified              ] && $kit.params[:verified              ] != ""
            search_hash[:returned_to_warehouse  ] = $kit.params[:returned_to_warehouse  ] if $kit.params[:returned_to_warehouse ] && $kit.params[:returned_to_warehouse ] != ""
            
            if search_hash.length >= 1
                
                where_clause = "WHERE "
                
                search_hash.each_with_index do |(k,v),i|
                    
                    if k.to_s.match(/serial_number1|serial_number2/)
                        
                        if !@range_included
                            
                            where_clause << " AND " if i != 0
                            
                            where_clause << "serial_number >= #{search_hash[:serial_number1] || 0} AND serial_number <= #{search_hash[:serial_number2] || 0}"
                            @range_included = true
                            
                        end
                        
                    else
                        
                        where_clause << " AND " if i != 0
                        
                        where_clause << "#{k.to_s} REGEXP '#{v}' "
                       
                    end
                    
                end
                
                results = test_packet_results(where_clause)
                
                results = $tools.newlabel("no_results", "This search returned no results") if results == false
                
            else
                
                results = $tools.newlabel("no_results", "This search returned no results")
                
            end
            
            $kit.modify_tag_content("test_packets_search_results", results, "update")
            
        end
        
    end
    
    def test_search
        
        output      = String.new
        search_params_arr =
        [
            "packet_search",
            "search__TEST_PACKETS__serial_number",
            "search__TEST_PACKETS__serial_number1",
            "search__TEST_PACKETS__serial_number2",
            #"search__TEST_PACKETS__grade_level",
            #"search__TEST_PACKETS__subject_id",
            #"search__TEST_PACKETS__large_print",
            #"search__TEST_PACKETS__test_event_id",
            "search__TEST_PACKETS__student_id",
            "search__TEST_PACKETS__test_event_site_id"#,
            #"search__TEST_PACKETS__administrator_team_id",
            #"search__TEST_PACKETS__status",
            #"search__TEST_PACKETS__verified"
            #"search__TEST_PACKETS__returned_to_warehouse"
        ]
        
        search_params = search_params_arr.join(",")
        
        output << "<div id='test_packets_search_fields'>"
        
        output << "<input id='packet_search' type='hidden' value='' name='packet_search'>"
        
        output << $tools.blank_input("search__TEST_PACKETS__serial_number",             "serial_number",                "Serial Number (omit leading '0's):")
        output << $tools.blank_input("search__TEST_PACKETS__serial_number1",             "serial_number1",                "Serial Number Range Start:"  )
        output << $tools.blank_input("search__TEST_PACKETS__serial_number2",             "serial_number2",                "Serial Number Range End:"    )
        #output << $tools.blank_input("search__TEST_PACKETS__grade_level",               "grade_level",                  "Grade:")
        #output << $tools.blank_input("search__TEST_PACKETS__subject_id",                   "subject_id",                      "Subject:")
        #output << $tools.blank_input("search__TEST_PACKETS__large_print",               "large_print",                  "Large Print:")
        #output << $tools.blank_input("search__TEST_PACKETS__test_event_id",             "test_event_id",                "Test Event ID:")
        output << $tools.blank_input("search__TEST_PACKETS__student_id",                "student_id",                   "Student ID:")
        output << $tools.newselect2("search__TEST_PACKETS__test_event_site_id",      "test_event_site_id",           test_event_sites_dd,           "Test Event Site:")
        #output << $tools.blank_input("search__TEST_PACKETS__administrator_team_id",     "administrator_team_id",        "Administrator:")
        #output << $tools.blank_input("search__TEST_PACKETS__status",                    "status",                       "Status:")
        #output << $tools.blank_input("search__TEST_PACKETS__verified",                  "verified",                     "Verified:")
        #output << $tools.blank_input("search__TEST_PACKETS__returned_to_warehouse",     "returned_to_warehouse",        "Returned to Warehouse (to be shipped):")
        
        output << "<button id='student_search_button' type='button' onclick=\"send('#{search_params}');setPreSpinner('test_packets_search_results');\"></button>"
        output << "</div>"
        output << "<div id='test_packets_search_results'></div>"
        output << "</div>"
        output.insert(0, "<div id='test_packets_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_CSV
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    def add_new_record_test_packet_location()
        
        output = String.new
        
        output << $tools.div_open("new_checkin_container", "new_checkin_container")
        
        test_packet_pid = $kit.params[:test_packet_id]
        
        tp_row    = $tables.attach("TEST_PACKETS").by_primary_id(test_packet_pid)
        tp_fields = tp_row.fields
        
        row = $tables.attach("TEST_PACKET_LOCATION").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Location Assignment")
            
            fields = row.fields
            
            output << fields["test_packet_id"     ].set(test_packet_pid).web.hidden
            output << fields["test_event_site_id" ].web.select(:label_option=>"Location:",  :dd_choices=>test_event_sites_dd(   tp_fields[  "test_event_id"         ].value), :validate=>true)
            output << fields["team_id"            ].web.select(:label_option=>"Team Member:",:dd_choices=>staff_dd(              fields[     "test_event_site_id"    ].value))
            #output << fields["checkin_status"     ].web.text(:label_option=>"Status"    )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________BATCH_UPDATES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def batch_update_location(batch_ids, batch_value = nil)
        
        if !batch_value.empty?
            
            batch_ids.split(",").each{|id|
                
                record = $tables.attach("TEST_PACKETS").by_primary_id(id)
                record.fields["test_event_site_id"].value = batch_value
                record.save
                
            }
            
            $kit.output << "<eval_script>$('#test_packets_search_submit').trigger( 'click' )</eval_script>"
            
        else
            
            $kit.output << "<eval_script>alert('Please select a location from the dropdown and try again.')</eval_script>"
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def status_dd
        
        return [
            {:name=>"Complete",         :value=>"Complete"     },
            {:name=>"Unused",           :value=>"Unused"       },
            {:name=>"Do Not Score",     :value=>"Do Not Score" },
            {:name=>"Destroyed",        :value=>"Destroyed"    },
            {:name=>"In Progress",      :value=>"In Progress"  }
        ]
        
    end
    
    def test_events_dd
        
        $tables.attach("TEST_EVENTS").dd_choices("name", "primary_id")
        
    end
    
    def test_types_dd
        
        $tables.attach("TESTS").dd_choices("name", "primary_id")
        
    end
    
    def test_event_sites_dd(test_event_id=3) #using pssa as default event id for now 
        
        where_clause = test_event_id ? "WHERE test_event_id = '#{test_event_id}'":nil
        
        $tables.attach("TEST_EVENT_SITES").dd_choices("site_name", "primary_id", "#{where_clause} ORDER BY site_name ASC")
        
    end
    
    def staff_dd(test_event_site_id)
        
        tess_db = $tables.attach("TEST_EVENT_SITE_STAFF").data_base
        
        return $tables.attach("TEAM").dd_choices(
            "CONCAT(legal_first_name,' ',legal_last_name)",
            "primary_id",
            "WHERE primary_id NOT IN(
                SELECT team_id
                FROM #{tess_db}.test_event_site_staff
                WHERE test_event_site_id = '#{test_event_site_id}'
            )
            GROUP BY CONCAT(legal_first_name,' ',legal_last_name)
            ORDER BY CONCAT(legal_first_name,' ',legal_last_name) ASC "
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def test_packet_record(pid)
        
        output = String.new
        
        output << $tools.legend_open("information", "Information")
        
        output << "<input id='test_packet_id_#{pid}' type='hidden' value='#{pid}' name='test_packet_id'>"
        
        school_record = $tables.attach("TEST_PACKETS").by_primary_id(pid)
        
        fields = school_record.fields
        
        test_event      = $tables.attach("TEST_EVENTS"      ).field_value("name",        "WHERE primary_id = '#{fields["test_event_id"      ].value}'")
        test_event_site = $tables.attach("TEST_EVENT_SITES" ).field_value("site_name",   "WHERE primary_id = '#{fields["test_event_site_id" ].value}'")
        test_type       = $tables.attach("TESTS"            ).field_value("name",        "WHERE primary_id = '#{fields["test_type_id"       ].value}'")
        
        output << $tools.table(
            :table_array=>[
                [
                    "Student ID",
                    "First Name",
                    "Last Name",
                    "Grade",
                    "Administrator",
                    ""
                ],
                [
                    fields["student_id"].value||"Not Assigned",
                    $tables.attach("STUDENT").field_value("studentfirstname", "WHERE student_id = '#{fields["student_id"].value}'")||"Not Assigned",
                    $tables.attach("STUDENT").field_value("studentlastname",  "WHERE student_id = '#{fields["student_id"].value}'")||"Not Assigned",
                    fields["grade_level"].value,
                    fields["administrator_team_id" ].set(fields["administrator_team_id" ].to_name(:full_name)).value,
                    ""
                ],
            ],
            :embedded_style => {
                :table  => "width:100%;",
                :th     => "text-align:center;",
                :tr     => nil,
                :tr_alt => nil,
                :td     => "text-align:center;width:16%;"
            },:head_section   => true
        )
        
        output << $tools.table(
            :table_array=>[
                [
                    "Serial Number",
                    "Subject",
                    "Test Event",
                    "Test Type",
                    "Test Event Site",
                    "Large Print"
                ],
                [
                    fields["serial_number"      ].value,
                    $tables.attach("TEST_SUBJECTS").field_value("name", "WHERE primary_id = '#{fields["subject_id"].value}'"),
                    test_event,
                    test_type,
                    test_event_site,
                    fields["large_print"        ].to_user
                ],
            ],
            :embedded_style => {
                :table  => "width:100%;",
                :th     => "text-align:center;",
                :tr     => nil,
                :tr_alt => nil,
                :td     => "text-align:center;width:16%;"
            },:head_section   => true
        )
        
        output << $tools.table(
            :table_array=>[
                [
                    "Status",
                    "Verified",
                    "Returned to Warehouse (to be shipped)",
                    "",
                    "",
                    ""
                ],
                [
                   fields["status"].web.select(:dd_choices=>status_dd),
                   fields["verified"].web.checkbox,
                   fields["returned_to_warehouse" ].web.checkbox,
                   "",
                   "",
                   ""
                ]
            ],
            :embedded_style => {
                :table  => "width:100%;",
                :th     => "text-align:center;",
                :tr     => nil,
                :tr_alt => nil,
                :td     => "text-align:center;width:16%;"
            },:head_section   => true
        )
        
        output << $tools.legend_close()
        
        output << $tools.legend_open("checkin", "Location Assignment History")
        
        output << $tools.button_new_row("TEST_PACKET_LOCATION", "test_packet_id_#{pid}", nil, "Re-Assign") if !fields["returned_to_warehouse" ].is_true?
        
        tables_array = Array.new
        
        #HEADERS
        tables_array.push([
            "Test Event Site",
            "Team Member",
            "Location Status",
            "Date Assigned"
        ])
        
        tpc_pids = $tables.attach("TEST_PACKET_LOCATION").primary_ids("WHERE test_packet_id = '#{pid}' ORDER BY primary_id DESC")
        tpc_pids.each{|tpc_pid|
            
            tpc_record = $tables.attach("TEST_PACKET_LOCATION").by_primary_id(tpc_pid)
            
            row = Array.new
            
            row.push($tables.attach("TEST_EVENT_SITES").find_field("site_name", "WHERE primary_id = '#{tpc_record.fields["test_event_site_id" ].value}'").value)
            row.push("#{tpc_record.fields['team_id'].to_name(:full_name)}")
            row.push(tpc_record.fields["checkin_status"     ].value)
            row.push(tpc_record.fields["checkin_date"       ].to_user)
            
            tables_array.push(row)
            
        } if tpc_pids
        
        output << $kit.tools.data_table(tables_array, "test_packet_check_in", table_type = "default", titles = false, custom_titles = nil, sort_col_header="Date Assigned", sort_dir='desc')
        
        output << $tools.legend_close()
        
        $kit.modify_tag_content("test_packets_record_container", output, "update")
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = "
        <style>
            
            #search_dialog_button                           {display: none;}
            table.dataTable td.column_0                     {text-align: center;}
            #student_container fieldset                     {width:97%}
            .no_info                                        {height:100px;}
            #upload_iframe_test_packets_upload              {position:fixed; top:0; left:0; z-index:-999999999999;}
            #upload_new_table_TEST_PACKETS                  {overflow:hidden;}
            
            #test_packets_search_fields                     {width:450px; padding:10px; margin-bottom:10px; margin-left:auto; margin-right:auto;}
            #test_packets_search_dialog_button              {margin-bottom:10px;}
            #test_packets_search_submit                     {margin-top:5px;}
            #test_packets_search_results                    {min-height:450px; width:1000px; padding:10px; border:1px solid #3baae3; border-radius:5px;margin-left:auto; margin-right:auto; box-shadow:inset 0px 0px 10px #869bac; background-color:#EDF0F2;}
            
            input                                           {font-size:10px;}
            
            .serial_number                            label {width:190px; display:inline-block;}
            .grade_level                              label {width:190px; display:inline-block;}
            .subject                                  label {width:190px; display:inline-block;}
            .large_print                              label {width:190px; display:inline-block;}
            .test_event_id                            label {width:190px; display:inline-block;}
            .test_type_id                             label {width:190px; display:inline-block;}
            .student_id                               label {width:190px; display:inline-block;}
            .test_event_site_id                       label {width:190px; display:inline-block;}
            .administrator_team_id                    label {width:190px; display:inline-block;}
            .status                                   label {width:190px; display:inline-block;}
            .verified                                 label {width:190px; display:inline-block;}
            .serial_number1                           label {width:190px; display:inline-block;}
            .serial_number2                           label {width:190px; display:inline-block;}
            
            .serial_number                            input {width:250px;}
            .grade_level                              input {width:250px;}
            .subject                                  input {width:250px;}
            .large_print                              input {width:250px;}
            .test_event_id                            input {width:250px;}
            .test_type_id                             input {width:250px;}
            .student_id                               input {width:250px;}
            .test_event_site_id                       input {width:250px;}
            .administrator_team_id                    input {width:250px;}
            .status                                   input {width:250px;}
            .verified                                 input {width:250px;}
            .serial_number1                           input {width:250px;}
            .serial_number2                           input {width:250px;}
            
            .TEST_PACKETS__serial_number              input {width:800px;}
            .TEST_PACKETS__grade_level                input {width:800px;}
            .TEST_PACKETS__subject                    input {width:800px;}
            .TEST_PACKETS__test_event_id              input {width:800px;}
            .TEST_PACKETS__test_type_id               input {width:800px;}
            .TEST_PACKETS__student_id                 input {width:800px;}
            .TEST_PACKETS__test_event_site_id         input {width:800px;}
            .TEST_PACKETS__administrator_team_id      input {width:800px;}
            .TEST_PACKETS__status                     input {width:800px;}
            
            .TEST_PACKETS__serial_number              label {width:110px; display:inline-block;}
            .TEST_PACKETS__grade_level                label {width:110px; display:inline-block;}
            .TEST_PACKETS__subject                    label {width:110px; display:inline-block;}
            .TEST_PACKETS__large_print                label {width:110px; display:inline-block;}
            .TEST_PACKETS__test_event_id              label {width:110px; display:inline-block;}
            .TEST_PACKETS__test_type_id               label {width:110px; display:inline-block;}
            .TEST_PACKETS__student_id                 label {width:110px; display:inline-block;}
            .TEST_PACKETS__test_event_site_id         label {width:110px; display:inline-block;}
            .TEST_PACKETS__administrator_team_id      label {width:110px; display:inline-block;}
            .TEST_PACKETS__status                     label {width:110px; display:inline-block;}
            .TEST_PACKETS__verified                   label {width:110px; display:inline-block;}
            
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