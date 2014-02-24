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
        
        output << $tools.div_open("test_packets_record_container", "test_packets_record_container")
        output << $tools.legend_open("information", "Information")
        output << $tools.newlabel("no_info", "Please search for a test packet.")
        output << $tools.legend_close()
        output << $tools.legend_open("checkin", "Check-In History")
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
            "Edit",
            "Student ID",
            "Serial Number",
            "Status",
            "Verified",
            "Test Event",
            "Test Event Site",
            "Test Type",
            "Subject",
            "Admin Team Member",
            "Grade",
            "Large Print"
        ])
        
        pids = $tables.attach("TEST_PACKETS").primary_ids(where_clause)
        pids.each{|pid|
            
            record = $tables.attach("TEST_PACKETS").by_primary_id(pid)
            
            row = Array.new
            
            row.push("<button class='new_breakaway_button' id='load_test_packets_record_button_#{pid}' onclick='send\(\"load_test_packets_record_#{pid}\"\)\;setPreSpinner\(\"test_packets_record_container\"\);$\(\"#test_packets_search_dialog\"\).dialog\(\"close\"\)'>Edit</button><input id='load_test_packets_record_#{pid}' type='hidden' value='#{pid}' name='load_test_packets_record'")
            row.push(record.fields["student_id"            ].value)
            row.push(record.fields["serial_number"         ].value)
            row.push(record.fields["status"                ].web.select(:dd_choices=>status_dd))
            row.push(record.fields["verified"              ].web.checkbox())
            row.push($tables.attach("TEST_EVENTS"     ).field_value("name",      "WHERE primary_id = '#{record.fields["test_event_id"     ].value}'"))
            row.push($tables.attach("TEST_EVENT_SITES").field_value("site_name", "WHERE primary_id = '#{record.fields["test_event_site_id"].value}'"))
            row.push($tables.attach("TESTS"           ).field_value("name",      "WHERE primary_id = '#{record.fields["test_type_id"      ].value}'"))
            row.push(record.fields["subject"                ].value)
            row.push(record.fields["administrator_team_id" ].value)
            row.push(record.fields["grade_level"           ].value)
            row.push(record.fields["large_print"           ].web.checkbox({:disabled=>true}))
            
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
        
        if $kit.params[:load_test_packets_record] || $kit.params[:add_new_TEST_PACKET_LOCATION]
            
            output = String.new
            
            output << $tools.legend_open("information", "Information")
            
            pid = $kit.params[:load_test_packets_record] || $kit.params[:field_id____TEST_PACKET_LOCATION__test_packet_id]
            
            output << "<input id='test_packet_id_#{pid}' type='hidden' value='#{pid}' name='test_packet_id'>"
            
            school_record = $tables.attach("TEST_PACKETS").by_primary_id(pid)
            
            fields = school_record.fields
            
            fields["test_event_id"          ].value = $tables.attach("TEST_EVENTS"      ).find_field("name",        "WHERE primary_id = '#{fields["test_event_id"      ].value}'").value 
            fields["test_event_site_id"     ].value = $tables.attach("TEST_EVENT_SITES" ).find_field("site_name",   "WHERE primary_id = '#{fields["test_event_site_id" ].value}'").value 
            fields["test_type_id"           ].value = $tables.attach("TESTS"            ).find_field("name",        "WHERE primary_id = '#{fields["test_type_id"       ].value}'").value
            fields["subject"                ].value = $tables.attach("TEST_SUBJECTS"    ).find_field("name",        "WHERE primary_id = '#{fields["subject"            ].value}'").value
            
            output << fields["student_id"            ].web.label(   { :label_option=>"Student ID:"       })
            output << fields["serial_number"         ].web.label(   { :label_option=>"Serial Number:"    })
            output << fields["grade_level"           ].web.label(   { :label_option=>"Grade:"            })
            output << fields["subject"               ].web.label(   { :label_option=>"Subject:"          })
            output << fields["test_event_id"         ].web.label(   { :label_option=>"Test Event:"       })
            output << fields["test_type_id"          ].web.label(   { :label_option=>"Test Type:"        })
            output << fields["test_event_site_id"    ].web.label(   { :label_option=>"Test Event Site:", })
            output << fields["administrator_team_id" ].web.select(  { :label_option=>"Admin Team ID:",   :dd_choices=>staff_dd(fields["test_event_site_id"    ].value)})
            output << fields["status"                ].web.select(  { :label_option=>"Status:",          :dd_choices=>status_dd })
            output << fields["verified"              ].web.checkbox({ :label_option=>"Verified:"         })
            output << fields["large_print"           ].web.checkbox({ :label_option=>"Large Print:",     :disabled=>true })
            
            output << $tools.legend_close()
            
            output << $tools.legend_open("checkin", "Check-In History")
            
            output << $tools.button_new_row("TEST_PACKET_LOCATION", "test_packet_id_#{pid}", nil, "Check-In")
            
            tables_array = Array.new
     
            #HEADERS
            tables_array.push([
                "Test Event Site",
                "Team Member",
                "Check-in Status",
                "Check-in Date"
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
            
            output << $kit.tools.data_table(tables_array, "test_packet_check_in")
            
            output << $tools.legend_close()
            
            $kit.modify_tag_content("test_packets_record_container", output, "update")
            
        else
            
            search_hash = Hash.new            
            search_hash[:serial_number         ] = $kit.params[:serial_number         ] if $kit.params[:serial_number         ] && $kit.params[:serial_number         ] != ""
            search_hash[:grade_level           ] = $kit.params[:grade_level           ] if $kit.params[:grade_level           ] && $kit.params[:grade_level           ] != ""
            search_hash[:subject               ] = $kit.params[:subject               ] if $kit.params[:subject               ] && $kit.params[:subject               ] != ""
            search_hash[:large_print           ] = $kit.params[:large_print           ] if $kit.params[:large_print           ] && $kit.params[:large_print           ] != ""
            search_hash[:test_event_id         ] = $kit.params[:test_event_id         ] if $kit.params[:test_event_id         ] && $kit.params[:test_event_id         ] != ""
            search_hash[:student_id            ] = $kit.params[:student_id            ] if $kit.params[:student_id            ] && $kit.params[:student_id            ] != ""
            search_hash[:test_event_site_id    ] = $kit.params[:test_event_site_id    ] if $kit.params[:test_event_site_id    ] && $kit.params[:test_event_site_id    ] != ""
            search_hash[:administrator_team_id ] = $kit.params[:administrator_team_id ] if $kit.params[:administrator_team_id ] && $kit.params[:administrator_team_id ] != ""
            search_hash[:status                ] = $kit.params[:status                ] if $kit.params[:status                ] && $kit.params[:status                ] != ""
            search_hash[:verified              ] = $kit.params[:verified              ] if $kit.params[:verified              ] && $kit.params[:verified              ] != ""
            
            if search_hash.length >= 1
                
                where_clause = "WHERE "
                
                search_hash.each_with_index do |(k,v),i|
                    
                    where_clause << "AND " if i != 0
                    where_clause << "#{k.to_s} REGEXP '#{v}' "
                    
                end
                
                results = test_packet_results(where_clause)
                
                results = $tools.newlabel("no_results", "This search returned no results") if results == false
                
            else
                
                results = $tools.newlabel("no_results", "This search returned no results")
                
            end
            
            $kit.modify_tag_content("test_packets_search_results", results, "update") if search_hash.length >= 1
            
        end
        
    end
    
    def test_search
        
        output      = String.new
        search_params_arr =
        [
            "search__TEST_PACKETS__serial_number",
            #"search__TEST_PACKETS__grade_level",
            #"search__TEST_PACKETS__subject",
            #"search__TEST_PACKETS__large_print",
            #"search__TEST_PACKETS__test_event_id",
            "search__TEST_PACKETS__student_id"#,
            #"search__TEST_PACKETS__test_event_site_id",
            #"search__TEST_PACKETS__administrator_team_id",
            #"search__TEST_PACKETS__status",
            #"search__TEST_PACKETS__verified"
        ]
        
        search_params = search_params_arr.join(",")
        
        output << "<div id='test_packets_search_fields'>"
        
        output << $tools.blank_input("search__TEST_PACKETS__serial_number",             "serial_number",                "Serial Number:")
        #output << $tools.blank_input("search__TEST_PACKETS__grade_level",               "grade_level",                  "Grade:")
        #output << $tools.blank_input("search__TEST_PACKETS__subject",                   "subject",                      "Subject:")
        #output << $tools.blank_input("search__TEST_PACKETS__large_print",               "large_print",                  "Large Print:")
        #output << $tools.blank_input("search__TEST_PACKETS__test_event_id",             "test_event_id",                "Test Event ID:")
        output << $tools.blank_input("search__TEST_PACKETS__student_id",                "student_id",                   "Student ID:")
        #output << $tools.blank_input("search__TEST_PACKETS__test_event_site_id",        "test_event_site_id",           "Test Event Site ID:")
        #output << $tools.blank_input("search__TEST_PACKETS__administrator_team_id",     "administrator_team_id",        "Admin Team ID:")
        #output << $tools.blank_input("search__TEST_PACKETS__status",                    "status",                       "Status:")
        #output << $tools.blank_input("search__TEST_PACKETS__verified",                  "verified",                     "Verified:")
        
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
        
        output << $tools.legend_open("sub", "Check-In")
            
            fields = row.fields
            
            output << fields["test_packet_id"     ].set(test_packet_pid).web.hidden
            output << fields["test_event_site_id" ].web.select(:label_option=>"Location:",  :dd_choices=>test_event_sites_dd(   tp_fields[  "test_event_id"         ].value), :validate=>true)
            output << fields["team_id"            ].web.select(:label_option=>"Team Member",:dd_choices=>staff_dd(              fields[     "test_event_site_id"    ].value))
            #output << fields["checkin_status"     ].web.text(:label_option=>"Status"    )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
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
    
    def test_subjects_dd(test_id)
        
        $tables.attach("TEST_SUBJECTS").dd_choices("name", "primary_id", "WHERE test_id = '#{test_id}'")
        
    end
    
    def test_types_dd
        
        $tables.attach("TESTS").dd_choices("name", "primary_id")
        
    end
    
    def test_event_sites_dd(test_event_id=nil)
        
        where_clause = test_event_id ? "WHERE test_event_id = '#{test_event_id}'":nil
        
        $tables.attach("TEST_EVENT_SITES").dd_choices("site_name", "primary_id", where_clause)
        
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
            
            #test_packets_search_fields                     {width:400px; padding:10px; margin-bottom:10px; margin-left:auto; margin-right:auto;}
            #test_packets_search_dialog_button              {margin-bottom:10px;}
            #test_packets_search_submit                     {margin-top:5px;}
            #test_packets_search_results                    {min-height:450px; width:1000px; padding:10px; border:1px solid #3baae3; border-radius:5px;margin-left:auto; margin-right:auto; box-shadow:inset 0px 0px 10px #869bac; background-color:#EDF0F2;}
            
            input                                           {font-size:10px;}
            
            .serial_number                            label {width:130px; display:inline-block;}
            .grade_level                              label {width:130px; display:inline-block;}
            .subject                                  label {width:130px; display:inline-block;}
            .large_print                              label {width:130px; display:inline-block;}
            .test_event_id                            label {width:130px; display:inline-block;}
            .test_type_id                             label {width:130px; display:inline-block;}
            .student_id                               label {width:130px; display:inline-block;}
            .test_event_site_id                       label {width:130px; display:inline-block;}
            .administrator_team_id                    label {width:130px; display:inline-block;}
            .status                                   label {width:130px; display:inline-block;}
            .verified                                 label {width:130px; display:inline-block;}
            
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