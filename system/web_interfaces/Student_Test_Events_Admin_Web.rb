#!/usr/local/bin/ruby


class STUDENT_TEST_EVENTS_ADMIN_WEB
    
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
            ["Tests",              load_tab_1                                                   ],
            ["Facilities",         load_tab_2                                                   ],
            ["Events",             load_tab_3                                                   ],
            ["Event Sites",        "Please Select 'Site List' in the 'Events' tab."             ],
            ["Event Site Staff",   "Please Select 'Staff List' in the 'Event Sites' tab."       ]
        ],2)
        
    end
    
    def breakaway_caption
        
        how_to_button = $tools.button_how_to("STUDENT_TEST_EVENTS_ADMIN_WEB", "How To: Manage Test Events")
        
        return "Test Event Administration #{how_to_button}"
        
    end
    
    def test_function
        $tools.chart(
            :target_element    =>"test", #string
            :data_points       =>[
                ["this",    "2","3","4","10","2"],
                ["that",    "3","3","5","20","2"],
                ["theother","5","3","1","10","4"]
            ], #array of arrays
            :class             =>"test", #string
            :title             =>"test", #string
            :subtitle          =>"test", #string
            :xAxis_categories  =>["a","b","c","d","e"], #array
            :yAxis_title       =>"test"  #string
        )
    end

    def response
        
        if $kit.params[:add_new_TEST_SUBJECTS] || $kit.params[:add_new_TEST_SUBJECT_CLASSES]
            $kit.modify_tag_content("tabs-1", load_tab_1, "update")
        end
        
        if $kit.params[:add_new_TEST_SITES]
            $kit.modify_tag_content("tabs-2", load_tab_2, "update")
        end
        
        if $kit.params[:add_new_TEST_EVENTS]
            $kit.modify_tag_content("tabs-3", load_tab_3, "update")
        end
        
        if $kit.params[:add_new_TEST_EVENT_SITES]
            event_id = $kit.params[:field_id____TEST_EVENT_SITES__test_event_id]
            $kit.modify_tag_content("tabs-5", load_tab_5(event_id), "update")
            $kit.modify_tag_content("tabs-4", load_tab_4(event_id), "update")
        end
        
        if $kit.params[:add_new_TEST_EVENT_SITE_STAFF]
            event_site_id = $kit.params[:field_id____TEST_EVENT_SITE_STAFF__test_event_site_id]
            $kit.modify_tag_content("tabs-5", load_tab_5(event_site_id), "update")
        end
        
        if $kit.rows && !$kit.rows.empty?
            
            this_row = $kit.rows.first[1]
            
            if this_row.fields.keys.include?("not_attending")
                
                event_site_id = $tables.attach("TEST_EVENT_SITE_STAFF").field_value("test_event_site_id", "WHERE primary_id = '#{this_row.primary_id}'")
                $kit.modify_tag_content("tabs-5", load_tab_5(event_site_id), "update")
                
            end
            
        end
        
    end
    
    def page_title
        
        return "Test Event Admin"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load_tab_1(arg = nil)#TESTS
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "TEST_SUBJECTS")
        
        tables_array = [
            
            #HEADERS
            [
                
                "Subject ID"                     ,
                "Subject"                        ,
                "Test Type"                      ,
                "Eligible Grades"                ,
                "Only PASA Eligible Students"    ,
                "Exclude PASA Eligible Students" ,
                "Eligible Classes"
              
            ]
            
        ]
     
        pids = $tables.attach("TEST_SUBJECTS").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("TEST_SUBJECTS").by_primary_id(pid)
            
            row = Array.new
            
            row.push(record.primary_id)
            row.push(record.fields["name"        ].web.select(:dd_choices=>subjects_dd,  :disabled=>true) )
            row.push(record.fields["test_id"     ].web.select(:dd_choices=>test_type_dd, :disabled=>true) )
            
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
            
            row.push(record.fields["only_pasa"    ].web.default())
            row.push(record.fields["exclude_pasa" ].web.default())
            
            related_classes = Array.new
            class_pids = $tables.attach("TEST_SUBJECT_CLASSES").primary_ids("WHERE test_subject_id = '#{pid}'")
            if class_pids
                class_pids.each{|class_pid|
                    related_classes.push([$tables.attach("TEST_SUBJECT_CLASSES").by_primary_id(class_pid).fields["class_name"].value])
                }
                related_classes = $tools.table(
                    :table_array    => related_classes,
                    :unique_name    => "related_classes",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
            end
            
            edit_button = $tools.button_get_row(
                :table_name 	=> "TEST_SUBJECT_CLASSES",
                :dialog_title	=> "Related Class",
                :params		=> "argv=#{pid}",
                :button_title   => "Add New"
            )
            row.push("#{edit_button}#{related_classes}")
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "test_subjects")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_2(arg = nil)#FACILITIES
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "TEST_SITES")
        
        tables_array = [
            
            #HEADERS
            [
                "Region",
                "Name",
                "Address",
                "City",
                "State",
                "Zip",
                "Site URL",
                "Directions",
                "Contact Name",
                "Contact Phone",
                "Contact E-mail",
                "Available Hours"
            ]
            
        ]
     
        pids = $tables.attach("TEST_SITES").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("TEST_SITES").by_primary_id(pid)
            
            row = Array.new
            
            row.push(record.fields["region"           ].web.text() )
            row.push(record.fields["facility_name"    ].web.text() )
            row.push(record.fields["address"          ].web.text() )
            row.push(record.fields["city"             ].web.text() )
            row.push(record.fields["state"            ].web.text() )
            row.push(record.fields["zip_code"         ].web.text() )
            row.push(record.fields["site_url"         ].web.text() )
            row.push(record.fields["directions"       ].web.textarea() )
            row.push(record.fields["contact_name"     ].web.text() )
            row.push(record.fields["contact_phone"    ].web.text() )
            row.push(record.fields["contact_email"    ].web.text() )
            row.push(record.fields["available_hours"  ].web.text() )
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "test_sites")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_3(arg = nil)#EVENTS
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "TEST_EVENTS")
        
        tables_array = [
            
            #HEADERS
            [
                "Ready?",
                "Event ID",
                "Load Event Sites",
                "Students Report",
                "Name",
                "Test Type ID",
                "Test Type",
                "Start Date",
                "End Date",
                "Strict Attendance?"
            ]
            
        ]
        
        records = $tables.attach("TEST_EVENTS").records
        records.each{|record|
            
            row = Array.new
            
            test_event_id = record.fields["primary_id"].value
            
            event_sites_button      = $tools.button_load_tab(4, "Event Sites",    test_event_id)
            event_students_button   = $tools.button_new_csv(
                csv_name                = "test_event_students",
                additional_params_str   = test_event_id,
                send_field_name         = nil,
                button_title            = "Students Report"
            )
            
            if record.fields["ready"].is_true?
                color   = "green"
                title   = "Test Selection Last Updated - #{record.fields["selection_last_run_date"].to_user}"
            else
                color   = "red"
                title   = "Test Selection In Progress"
            end
            
            row.push("<img src='/athena/images/#{color}.png' title='#{title}' width='32' height='32'/>"                 )
            row.push(record.primary_id)
            row.push(event_sites_button                                                                                 )  
            row.push(event_students_button                                                                              )          
            row.push(record.fields["name"                   ].web.text()                                                )
            row.push(record.fields["test_id"                ].value                                                     )
            row.push(record.fields["test_id"                ].web.select(:disabled=>true,:dd_choices=>test_type_dd)     )
            row.push(record.fields["start_date"             ].web.date(:defaultDate_throw=>"1")                         )
            row.push(record.fields["end_date"               ].web.date(:defaultDate_catch=>"1")                         )
            row.push(record.fields["override_attendance"    ].web.checkbox                                              )
            
            tables_array.push(row)
            
        } if records
        
        output << $kit.tools.data_table(tables_array, "test_events")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_4(arg = nil)#EVENT SITES
        
        test_event_id = arg
        
        output = String.new
        
        output << $tools.newlabel("test_event_sites_header", $tables.attach("TEST_EVENTS").by_primary_id(test_event_id).fields["name"].value)
        
        output << "<input id='test_event_id' name='test_event_id' value='#{test_event_id}'/>"
        
        output << $tools.button_new_row(table_name = "TEST_EVENT_SITES", "test_event_id")
        
        tables_array = [
            
            #HEADERS
            [
                "Link",
                "Event Site ID",
                "Site Name",
                "Test Site",
                "Start Date",
                "End Date",
                "Special Notes",
                "Start Time",
                "End Time"
            ]
            
        ]
     
        sites_dd_this = sites_dd
        pids = $tables.attach("TEST_EVENT_SITES").primary_ids("WHERE test_event_id = #{test_event_id}")
        pids.each{|pid|
            
            record  = $tables.attach("TEST_EVENT_SITES").by_primary_id(pid) 
            row     = Array.new
            
            row.push($tools.button_load_tab(5, "Staff List", record.fields["primary_id"].value)  )
            row.push(record.primary_id)
            row.push(record.fields["site_name"           ].web.text()                            )
            row.push(record.fields["test_site_id"        ].web.select(:dd_choices=>sites_dd_this))
            row.push(record.fields["start_date"          ].web.date()                            )
            row.push(record.fields["end_date"            ].web.date()                            )
            row.push(record.fields["special_notes"       ].web.textarea()                        )
            row.push(record.fields["start_time"          ].web.text()                            )
            row.push(record.fields["end_time"            ].web.text()                            )
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "test_event_sites")
        
        output << $tools.newlabel("bottom")
        
        $kit.modify_tag_content("tabs-5", "Please Choose an Event Site", "update")
        
        return output
        
    end
    
    def load_tab_5(arg = nil)#EVENT SITE STAFF
        
        test_event_site_id = arg
        
        output = String.new
        
        output << $tools.newlabel("test_event_site_staff_header", $tables.attach("TEST_EVENT_SITES").by_primary_id(test_event_site_id).fields["site_name"].value)
        
        output << "<input id='test_event_site_id' name='test_event_site_id' value='#{test_event_site_id}'/>"
        
        output << $tools.button_new_row(table_name = "TEST_EVENT_SITE_STAFF", "test_event_site_id")
        
        tables_array = Array.new
        
        headers = [
            "Not Attending",
            "Staff",
            "Staff_ID",
            "Role"
        ]
        
        dates   = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").field_values("date", "WHERE test_event_site_id  = '#{test_event_site_id}' GROUP BY date ORDER BY DATE ASC")
        headers.concat(dates) if dates
        
        records = $tables.attach("TEST_EVENT_SITE_STAFF").by_test_event_site_id(test_event_site_id)
        records.each{|record|
            
            row = Array.new
            
            row.push(record.fields["not_attending"].web.checkbox)
            row.push($team.get(record.fields["team_id"].value).full_name                        )
            row.push(record.fields["staff_id"].value                                            )
            row.push(record.fields["role"               ].web.select(:dd_choices=>role_dd  )    )
            
            test_dates = String.new
            pids = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").primary_ids(
                
                "WHERE team_id          = '#{record.fields["team_id"].value             }'
                AND test_event_site_id  = '#{record.fields["test_event_site_id"].value  }'"
             
            )
            
            dates.each{|date|
                
                att_date_record = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").record(
                    
                    "WHERE team_id          = '#{record.fields["team_id"].value             }'
                    AND test_event_site_id  = '#{record.fields["test_event_site_id"].value  }'
                    AND date                = '#{date}'"
                 
                )
                
                if !att_date_record
                    
                    row.push("No Record Found")
                    
                elsif att_date_record.fields["status"].match(/Test Date Canceled|Not Attending/)
                    
                    row.push(att_date_record.fields["status"].value)
                    
                else
                    
                    row.push(att_date_record.fields["status"].web.select(:dd_choices=>$dd.from_array(["Attended", "Scheduled"])))
                    
                end
                
            } if dates
            
            tables_array.push(row)
            
        } if records
        
        output << $kit.tools.data_table(tables_array.insert(0, headers), "test_event_site_staff")
        
        output << $tools.newlabel("bottom")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_test_events()
        
        output  = String.new
        
        output << $tools.div_open("test_events_container", "test_events_container")
        
        row  = $tables.attach("test_events").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Event Details")
        
            output << fields["name"                     ].web.text(:label_option=>"Name:")
            output << fields["test_id"                  ].web.select(:label_option=>"Test ID:",:dd_choices=>test_type_dd)
            output << fields["start_date"               ].web.date(:label_option=>"Start Date:",:defaultDate_throw=>"1")
            output << fields["end_date"                 ].web.date(:label_option=>"End Date:",:defaultDate_catch=>"1")
            output << fields["override_attendance"      ].web.checkbox(:label_option=>"Strict Attendance?")
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
    end
    
    def add_new_record_test_event_sites()
        
        output = String.new
        
        output << $tools.div_open("test_event_sites_container", "test_event_sites_container")
        
        row = $tables.attach("test_event_sites").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Event Site Details")
        
            output << fields["site_name"].web.text(:label_option=>"Site Name:")
            output << fields["test_site_id"].web.select(:label_option=>"Facility:", :dd_choices=>sites_dd())
            output << fields["start_date"].web.date(:label_option=>"Start Date:")
            output << fields["end_date"].web.date(:label_option=>"End Date:")
            output << fields["special_notes"].web.textarea(:label_option=>"Special Notes:")
            output << fields["start_time"].web.text(:label_option=>"Start Time:")
            output << fields["end_time"].web.text(:label_option=>"End Time:")
            fields["test_event_id"].value = $kit.params[:test_event_id]
            output << fields["test_event_id"       ].web.hidden()
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_test_event_site_staff()
        
        output = String.new
        
        output << $tools.div_open("test_event_site_staff_container", "test_event_site_staff_container")
        
        row = $tables.attach("test_event_site_staff").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Staff Details")
        
            output << fields["team_id"].web.select(:label_option=>"Staff:", :dd_choices=>staff_dd($kit.params[:test_event_site_id]))
            output << fields["role"].web.select(:label_option=>"Role:", :dd_choices=>role_dd)
            fields["test_event_site_id"].value = $kit.params[:test_event_site_id]
            output << fields["test_event_site_id" ].web.hidden()
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_test_sites #FACILITIES
        
        output = String.new
        
        output << $tools.div_open("test_sites_container", "test_sites_container")
        
        row = $tables.attach("test_sites").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Facility Details")
        
            output << fields["region"].web.text(:label_option=>"Region:")
            output << fields["facility_name"].web.text(:label_option=>"Facility Name:")
            output << fields["address"].web.text(:label_option=>"Address:")
            output << fields["city"].web.text(:label_option=>"City:")
            output << fields["state"].web.text(:label_option=>"State:")
            output << fields["zip_code"].web.text(:label_option=>"Zip Code:")
            output << fields["site_url"].web.text(:label_option=>"Site URL:")
            output << fields["directions"].web.default(:label_option=>"Directions:")
            output << fields["contact_name"].web.text(:label_option=>"Contact Name:")
            output << fields["contact_phone"].web.text(:label_option=>"Contact Phone:")
            output << fields["contact_email"].web.text(:label_option=>"Contact Email:")
            output << fields["available_hours"].web.text(:label_option=>"Available Hours:")
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_test_subjects(arg = nil)
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                
                "General Info", 
                "Eligible Grades"
              
            ]
            
        ]
        
        record = $tables.attach("TEST_SUBJECTS").new_row
        
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
        
        include_fields_table = $tools.table(
            
            :table_array    => grades,
            :unique_name    => "eligible_grades",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
            
        )
        
        this_name               = record.fields["name"          ].web.select(:label_option=>"Name:", :dd_choices=>subjects_dd)
        this_test_id            = record.fields["test_id"       ].web.select(:label_option=>"Test Type:", :dd_choices=>test_type_dd)
        this_only_pasa          = record.fields["only_pasa"     ].web.default(:label_option=>"Only PASA Eligible Students")
        this_pasa_excluded      = record.fields["exclude_pasa"  ].web.default(:label_option=>"Exclude PASA Eligible Students")
        
        tables_array.push(
            
            [
                "#{this_name}#{this_test_id}#{this_only_pasa}#{this_pasa_excluded}",
                include_fields_table
            ]
            
        )
        
        output << $kit.tools.data_table(tables_array, "TEST_SUBJECTS", type = "NewRecord")
        
        output << $tools.newlabel("bottom")
        
        return output
        
    end
    
    def get_row_test_subject_classes(arg = nil)
        
        output = String.new
        
        record = $tables.attach("TEST_SUBJECT_CLASSES").new_row
        
        exception_fields = $tables.attach("TEST_SUBJECT_CLASSES").find_fields("class_name", " WHERE test_subject_id = '#{arg}'")
        
        exceptions = Array.new
        
        exception_fields.each do |field|
            
           exceptions.push(field.value)
           
        end if exception_fields
        
        output << record.fields["test_subject_id"].set(arg).web.hidden
        output << record.fields["class_name"].web.select(:label_option=>"Class", :dd_choices=>class_list_dd(exceptions))
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_CSV
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_csv_test_event_students(test_event_id = nil)
        
        s_db     = $tables.attach("student"         ).data_base
        tst_db   = $tables.attach("tests"           ).data_base
        te_db    = $tables.attach("test_events"     ).data_base
        ts_db    = $tables.attach("test_subjects"   ).data_base
        tes_db   = $tables.attach("test_event_sites").data_base
        tsids_db = $tables.attach("team_sams_ids"   ).data_base
        t_db     = $tables.attach("team"            ).data_base
        st_db    = $tables.attach("student_tests"   ).data_base
        
        headers = [
            "Student-ID",
            "First Name",
            "Last Name",
            "Test Type",
            "Event",
            "Subject",
            "Site",
            "Site Assigned by Office?",
            "Serial Number",
            "Completed?",
            "Test Administrator",
            "Test Results",
            "Notes 1",
            "Notes 2"
        ]
        
        sql_str =
        "SELECT
            student_tests.student_id,
            studentfirstname,
            studentlastname,
            tests.name,
            test_events.name,
            test_subjects.name,
            test_event_sites.site_name,
            student_tests.assigned,
            student_tests.serial_number,
            student_tests.completed,
            CONCAT(team.legal_first_name,' ',team.legal_last_name),
            student_tests.test_results,
            student_tests.drop_off,
            student_tests.pick_up
            
        FROM #{st_db}.student_tests
        LEFT JOIN #{s_db    }.student           ON #{st_db}.student_tests.student_id         = #{s_db    }.student.student_id
        LEFT JOIN #{tst_db  }.tests             ON #{st_db}.student_tests.test_id            = #{tst_db  }.tests.primary_id
        LEFT JOIN #{te_db   }.test_events       ON #{st_db}.student_tests.test_event_id      = #{te_db   }.test_events.primary_id
        LEFT JOIN #{ts_db   }.test_subjects     ON #{st_db}.student_tests.test_subject_id    = #{ts_db   }.test_subjects.primary_id
        LEFT JOIN #{tes_db  }.test_event_sites  ON #{st_db}.student_tests.test_event_site_id = #{tes_db  }.test_event_sites.primary_id
        LEFT JOIN #{tsids_db}.team_sams_ids     ON #{st_db}.student_tests.test_administrator = #{tsids_db}.team_sams_ids.sams_id
        LEFT JOIN #{t_db    }.team              ON team_sams_ids.team_id                     = #{t_db    }.team.primary_id
        
        WHERE student_tests.test_event_id = '#{test_event_id}'"
        
        results = $db.get_data(sql_str)
        if results
            
            return results.insert(0, headers)
            
        else
            
            return [headers]
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def class_list_dd(exceptions=nil)
        
        where_clause = String.new
        
        if !exceptions.empty?
            
            where_clause = "WHERE"
            
            i=1
            
            exceptions.each do |exception|
                
                where_clause << " course_name != '#{exception}'"
                
                where_clause << " AND" if i < exceptions.length
                
                i+=1
                
            end
            
        end
        
        return $tables.attach("STUDENT_ACADEMIC_PROGRESS").dd_choices(
            "CONCAT\(course_code, ' - ', course_name\)",
            "course_name",
            "#{where_clause} GROUP BY course_name ORDER BY course_code ASC"
        )
        
    end
    
    def sites_dd
        
        return $tables.attach("TEST_SITES").dd_choices(
            "CONCAT(region,' -- ',facility_name)",
            "primary_id",
            "WHERE region IS NOT NULL AND facility_name IS NOT NULL ORDER BY region ASC"
        )
        
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
    
    def test_events_dd
        
        $tables.attach("TEST_EVENTS").dd_choices("name", "primary_id")
        
    end
    
    def test_subjects_dd(test_id)
        
        $tables.attach("TEST_SUBJECTS").dd_choices("name", "primary_id", "WHERE test_id = '#{test_id}'")
        
    end
    
    def test_type_dd
        
        return $tables.attach("TESTS").dd_choices(
            "name",
            "primary_id",
            " ORDER BY name ASC "
        )
        
    end
    
    def role_dd
        
        return [
            
            {:name=>"Site Coordinator"      , :value=>"Site Coordinator"   },
            {:name=>"Site Administrator"    , :value=>"Site Administrator" },
            {:name=>"Assistant"             , :value=>"Assistant"          },
            {:name=>"General Education"     , :value=>"General Education"  },
            {:name=>"Special Education"     , :value=>"Special Education"  },
            {:name=>"Test Administrator"    , :value=>"Test Administrator" },
            {:name=>"Spec. Ed. Acc. Org."   , :value=>"Spec. Ed. Acc. Org."},
            {:name=>"Primary Coder"         , :value=>"Primary Coder"      },
            {:name=>"Attendance"            , :value=>"Attendance"         },
            {:name=>"Support Staff"         , :value=>"Support Staff"      }
            
        ]
        
    end
    
    def subjects_dd
        
        return [
            
            {:name=>"Literature"        , :value=>"Literature"          },          
            {:name=>"Algebra I"         , :value=>"Algebra I"           },
            {:name=>"Biology"           , :value=>"Biology"             },
            {:name=>"General"           , :value=>"General"             },
            {:name=>"Math and Reading"  , :value=>"Math and Reading"    },
            {:name=>"Science"           , :value=>"Science"             },
            {:name=>"Writing"           , :value=>"Writing"             }
            
        ]
        
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
        
        output = String.new
        output << "<style>"
        output << "
            
            #search_dialog_button                               { visibility:hidden;}
            
            div.pid_link                                        { min-width:100px;}
            input#test_event_id                                 { display:none;}
            input#test_event_site_id                            { display:none;}
            
            div.test_event_students_header                      { margin-bottom:10px; font-size: 1.5em;}
            div.test_event_sites_header                         { margin-bottom:10px; font-size: 1.5em;}
            div.test_event_site_staff_header                    { margin-bottom:10px; font-size: 1.5em;}
            
            button#get_row_button_TEST_SUBJECT_CLASSES          { margin-left:10px; float:none !important;}
            div.related_classes_container                       { width:300px;}
            
            table#related_classes                             tr{ height:10px;}
            
            
            div.TEST_EVENTS__name               {margin-bottom: 2px;}
            div.TEST_EVENTS__test_id            {margin-bottom: 2px;}
            div.TEST_EVENTS__start_date         {margin-bottom: 2px;}
            div.TEST_EVENTS__end_date           {margin-bottom: 2px;}
            
            div.TEST_EVENTS__name               label{display: inline-block; width: 80px;}
            div.TEST_EVENTS__test_id            label{display: inline-block; width: 80px;}
            div.TEST_EVENTS__start_date         label{display: inline-block; width: 80px;}
            div.TEST_EVENTS__end_date           label{display: inline-block; width: 80px;}
            
            div.TEST_EVENTS__name               input{width: 232px;}
            div.TEST_EVENTS__start_date         input{width: 80px;}
            div.TEST_EVENTS__end_date           input{width: 80px;}
            
            
            div.TEST_SITES__region              {margin-bottom: 2px;}
            div.TEST_SITES__facility_name       {margin-bottom: 2px;}
            div.TEST_SITES__address             {margin-bottom: 2px;}
            div.TEST_SITES__city                {margin-bottom: 2px;}
            div.TEST_SITES__state               {margin-bottom: 2px;}
            div.TEST_SITES__zip_code            {margin-bottom: 2px;}
            div.TEST_SITES__site_url            {margin-bottom: 2px;}
            div.TEST_SITES__directions          {margin-bottom: 2px;}
            div.TEST_SITES__contact_name        {margin-bottom: 2px;}
            div.TEST_SITES__contact_phone       {margin-bottom: 2px;}
            div.TEST_SITES__contact_email       {margin-bottom: 2px;}
            div.TEST_SITES__available_hours     {margin-bottom: 2px;}
            
            div.TEST_SITES__region              label{display: inline-block; width: 120px;}
            div.TEST_SITES__facility_name       label{display: inline-block; width: 120px;}
            div.TEST_SITES__address             label{display: inline-block; width: 120px;}
            div.TEST_SITES__city                label{display: inline-block; width: 120px;}
            div.TEST_SITES__state               label{display: inline-block; width: 120px;}
            div.TEST_SITES__zip_code            label{display: inline-block; width: 120px;}
            div.TEST_SITES__site_url            label{display: inline-block; width: 120px;}
            div.TEST_SITES__directions          label{display: inline-block; width: 120px; vertical-align: top;}
            div.TEST_SITES__contact_name        label{display: inline-block; width: 120px;}
            div.TEST_SITES__contact_phone       label{display: inline-block; width: 120px;}
            div.TEST_SITES__contact_email       label{display: inline-block; width: 120px;}
            div.TEST_SITES__available_hours     label{display: inline-block; width: 120px;}
            
            div.TEST_SITES__region              input{width: 250px;}
            div.TEST_SITES__facility_name       input{width: 250px;}
            div.TEST_SITES__address             input{width: 250px;}
            div.TEST_SITES__city                input{width: 250px;}
            div.TEST_SITES__state               input{width: 250px;}
            div.TEST_SITES__zip_code            input{width: 250px;}
            div.TEST_SITES__site_url            input{width: 250px;}
            div.TEST_SITES__directions       textarea{width: 250px; height: 50px; resize: none;}
            div.TEST_SITES__contact_name        input{width: 250px;}
            div.TEST_SITES__contact_phone       input{width: 250px;}
            div.TEST_SITES__contact_email       input{width: 250px;}
            div.TEST_SITES__available_hours     input{width: 250px;}
            
            
            div.TEST_SUBJECTS__name             {margin-bottom: 2px; margin-top: 10px;}
            div.TEST_SUBJECTS__test_id          {margin-bottom: 2px; margin-top: 10px;}
            div.TEST_SUBJECTS__pasa_included    {margin-bottom: 10px; margin-top: 10px;}
            
            div.TEST_SUBJECTS__name             label{font-size: 1.2em;}
            div.TEST_SUBJECTS__test_id          label{font-size: 1.2em;}
            div.TEST_SUBJECTS__pasa_included    label{vertical-align: middle; font-size: 1.2em;}
            
            div.TEST_SUBJECTS__pasa_included    input{vertical-align: middle;}
            
            
            div.TEST_EVENT_SITES__site_name             {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__test_site_id          {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__start_date            {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__end_date              {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__start_time            {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__end_time              {margin-bottom: 2px;}
            div.TEST_EVENT_SITES__special_notes         {margin-bottom: 2px;}
            
            div.TEST_EVENT_SITES__site_name             label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__test_site_id          label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__start_date            label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__end_date              label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__start_time            label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__end_time              label{display: inline-block; width: 100px;}
            div.TEST_EVENT_SITES__special_notes         label{display: inline-block; width: 100px; vertical-align: top;}
            
            div.TEST_EVENT_SITES__site_name             input{width: 300px;}
            div.TEST_EVENT_SITES__start_date            input{width: 80px;}
            div.TEST_EVENT_SITES__end_date              input{width: 80px;}
            div.TEST_EVENT_SITES__start_time            input{width: 80px;}
            div.TEST_EVENT_SITES__end_time              input{width: 80px;}
            div.TEST_EVENT_SITES__special_notes      textarea{width: 200px; height: 64px; resize: none; overflow-y: scroll;}
            
            
            div.TEST_EVENT_SITE_STAFF__staff_id         {margin-bottom: 2px;}
            div.TEST_EVENT_SITE_STAFF__role             {margin-bottom: 2px;}
            
            div.TEST_EVENT_SITE_STAFF__staff_id         label{display: inline-block;}
            div.TEST_EVENT_SITE_STAFF__role             label{display: inline-block;}
            
            table.dataTable td {padding:3px 6px !important;}
            
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