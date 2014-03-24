#!/usr/local/bin/ruby


class TEST_EVENT_SITE_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        @kmail_hash         = Hash.new
        @test_event_site_id = nil
        @default_subject    = "Testing Reminder"
        @kmail_log          = $tables.attach("Kmail_Log").new_row
        @subject            = nil
        @administrators     = [
            "esaddler@agora.org",
            "jhalverson@agora.org",
            "dfeldhaus@agora.org"
        ]
        
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return $tables.attach("TEST_EVENT_SITES").field_by_pid("site_name", $kit.params[:test_event_site_id]).value
    end
    
    def page_title
        return $tables.attach("TEST_EVENT_SITES").field_by_pid("site_name", $kit.params[:test_event_site_id]).value
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load(test_event_site_id = $kit.params[:test_event_site_id])
        
        output = String.new
        
        @test_event_site_id = test_event_site_id
        
        user_roles = $tables.attach("TEST_EVENT_SITE_STAFF").field_values(
            "role",
            "WHERE test_event_site_id = '#{@test_event_site_id}'
            AND team_id = '#{$team_member.primary_id.value}'"
        ) || []
        
        tabs = Array.new
        
        #ROLES AVAILABLE
        #"Site Administrator"
        #"Site Coordinator"    
        #"Assistant"           
        #"General Education"   
        #"Special Education"   
        #"Test Administrator"  
        #"Spec. Ed. Acc. Org." 
        #"Primary Coder"       
        #"Attendance"          
        #"Support Staff"
        
        @all_access_tabs = [
            :load_tab_1, #ATTENDANCE
            :load_tab_2  #STUDENT TESTS
        ]
        
        @all_access_user = @administrators.include?($team_member.preferred_email.value)
        
        @tab_rights = {
            
            #ATTENDANCE
            :load_tab_1 => [
                #NO SPECIAL RIGHTS NEEDED TO SEE THIS TAB IF THE USER IS ASSIGNED TO THE SITE.
            ],
            
            #STUDENT TESTS
            :load_tab_2 => [
                #NO SPECIAL RIGHTS NEEDED TO SEE THIS TAB IF THE USER IS ASSIGNED TO THE SITE.
            ],
            
            #SE ACCOMMODATIONS
            :load_tab_3 => [
                "Site Coordinator",
                "Assistant",
                "Spec. Ed. Acc. Org."
            ],
            
            #REMINDERS
            :load_tab_4 => [
                "Site Coordinator",
            ],
            
            #SITE STAFF
            :load_tab_5 => [
                "Site Coordinator",
                "Assistant"
            ],
            
            #TEST PACKETS
            :load_tab_6 => [
                "Site Coordinator"
            ]
        }
        
        @tab_rights.keys.sort_by(&:to_s).each{|tab|
            
            tab_allowed = user_roles.select{|right|
                
                @tab_rights[tab].include?(right)
                
            }
            
            tabs.push( send(tab.to_s) ) if (@all_access_user || @all_access_tabs.include?(tab) || !tab_allowed.empty?)
            
        }
        
        
        #tabs = [
        #    ["Attendance",      test_event_site_attendance_tab    ],
        #    ["Student Tests",   test_event_site_student_tests_tab ]
        #]
        #
        #sams_ids = $team_member.sams_ids.existing_records
        #test_event_site_staff = false
        #sams_ids.each{|samsid_record|
        #    
        #    samsid = samsid_record.fields["sams_id"].value
        #    test_event_site_staff = true if $tables.attach("Test_Event_Site_Staff").is_site_coordinator?(samsid, @test_event_site_id)
        #    
        #}
        #
        #if @administrators.include?($team_member.preferred_email.value) || $team_member.preferred_email.value == "jrogers@agora.org" ||
        #    $tables.attach("TEST_EVENT_SITE_STAFF").primary_ids(
        #        "WHERE test_event_site_id = '#{@test_event_site_id}'
        #        AND team_id = #{$team_member.primary_id.value}
        #        AND role REGEXP 'Site Coordinatior|Spec. Ed. Acc. Org.'"
        #    )
        #    #NEEDS site cooredinator and special education accommodation organizer.
        #    tabs << ["SE Accommodations",   se_accommodations_tab   ]
        #end
        #
        #if @administrators.include?($team_member.preferred_email.value) || test_event_site_staff
        #    tabs << ["Reminders",           admin_kmail_queue       ]
        #    tabs << ["Site Staff",          site_staff_tab          ]
        #end
        
        output << "<input id='test_event_site_id' hidden='true' name='test_event_site_id' value='#{@test_event_site_id}'>"
        
        output << $kit.tools.tabs(tabs)
        
        return output
        
    end
    
    def response
        
        @test_event_site_id = $kit.params[:test_event_site_id]
        
        if !$kit.rows.empty? && field = $kit.rows.first[1].fields["serial_number"]
            if field.updated == false
                student_id = $tables.attach("TEST_PACKETS").field_value("student_id", "WHERE serial_number = '#{field.value}'")
                $kit.web_error.duplicate_assignment_error(
                    additional_message="This test packet is already assigned to the student with ID# #{student_id}. You must unassign this packet first.<BR>"
                )
            end
        end
        
        if $kit.params[:student_id] && $kit.params[:student_id] != ""
            sid = $kit.params[:student_id]
            output = student_record(sid)
            $kit.modify_tag_content("tabs-2", output, "update")
        elsif $kit.params[:test_event_site_id] && $kit.params[:kmail_body] && $kit.params[:kmail_subject]
            kmail_body          = $kit.params[:kmail_body]
            test_event_site_id  = $kit.params[:test_event_site_id]
            subject             = $kit.params[:kmail_subject]
            sample              = $kit.params[:sample] ? true : false
            queue_kmail_process(test_event_site_id, subject, kmail_body, sample)
        elsif $kit.params[:refresh]
            $kit.modify_tag_content($kit.params[:refresh], queue_history, type="update")
        end
        
        if $kit.rows && !$kit.rows.empty?
            
            this_row = $kit.rows.first[1]
            
            if this_row.fields.keys.include?("not_attending")
                
                event_site_id = $tables.attach("TEST_EVENT_SITE_STAFF").field_value("test_event_site_id", "WHERE primary_id = '#{this_row.primary_id}'")
                $kit.modify_tag_content("site_staff_tab", load_tab_5(event_site_id)[1], "update")
                
            end
            
        end
        
    end
    
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________INITIAL_TABS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load_tab_3()
        
        output = String.new
        
        tables_array = Array.new
        
        headers = [
            "Student ID"                ,
            "Last Name"                 ,
            "First Name"                ,
            "School ID"                 ,
            "Grade Level"              ,
            "Current IEP #"             ,
            "IEP Date"                  ,
            "IEP Implementation Date" 
            
        ]
        titles = headers.dup
        $tables.attach("STUDENT_SE_ACCOMMODATIONS").field_order.each{|field_name|
            
            unless field_name.match(/student_id|created_by|created_date/)
                
                headers.push(field_name)
                titles.push($tables.attach("SAPPHIRE_STUDENT_SE_ACCOMMODATIONS").field_value("accommodation_desc", "WHERE accommodation_code = '#{field_name.gsub('_','-')}' GROUP BY accommodation_desc"))
                
            end
            
        }
        
        test_event_type = $tables.attach("TESTS").field_value(
            "tests`.`name",
            "LEFT JOIN #{$tables.attach("test_events").data_base}.test_events
            ON test_events.test_id = tests.primary_id
            LEFT JOIN #{$tables.attach("test_event_sites").data_base}.test_event_sites ON test_event_sites.test_event_id = test_events.primary_id
            WHERE test_event_sites.primary_id = #{@test_event_site_id}"
        )
        
        sapp_se_db = $tables.attach("SAPPHIRE_STUDENT_SE_ACCOMMODATIONS").data_base
        
        acc_fields_sql = String.new
        $tables.attach("STUDENT_SE_ACCOMMODATIONS").field_order.each{|field_name|
            
            unless field_name.match(/student_id|created_by|created_date/)
                
                acc_fields_sql << "
                ,IF(
                    (
                        SELECT primary_id
                        FROM agora_sapphire.sapphire_student_se_accommodations
                        WHERE assessment_type_group = '#{test_event_type}'
                        AND accommodation_code REGEXP '#{field_name.gsub('_','-')}'
                        AND student_id = student_se_accommodations.student_id
                        GROUP BY student_id
                    ),
                    CONCAT(
                        'Yes',
                        ' (',
                        (SELECT GROUP_CONCAT(DISTINCT LEFT(assessment_type_code,3))
                        FROM agora_sapphire.sapphire_student_se_accommodations
                        WHERE student_id = student_se_accommodations.student_id
                        AND assessment_type_group = '#{test_event_type}'),
                        ')'
                    ),
                    ''
                ) AS #{field_name}"
                
            end
            
        }
        
        sql_strg = "
        SELECT
            student_se_accommodations.student_id                        , 
            sapphire_student_se_accommodations.last_name                , 
            sapphire_student_se_accommodations.first_name               , 
            sapphire_student_se_accommodations.school_id                , 
            sapphire_student_se_accommodations.grade_level              , 
            sapphire_student_se_accommodations.current_iep_no           , 
            sapphire_student_se_accommodations.iep_date                 , 
            sapphire_student_se_accommodations.iep_implementation_date
            #{acc_fields_sql}
            
        FROM        #{$tables.attach("STUDENT_SE_ACCOMMODATIONS"            ).data_base}.student_se_accommodations
        LEFT JOIN   #{$tables.attach("STUDENT_TESTS"                        ).data_base}.student_tests                      ON student_tests.student_id                         = student_se_accommodations.student_id
        LEFT JOIN   #{sapp_se_db                                            }.sapphire_student_se_accommodations ON sapphire_student_se_accommodations.student_id    = student_se_accommodations.student_id
        WHERE student_tests.test_event_site_id = #{@test_event_site_id}
        AND sapphire_student_se_accommodations.assessment_type_group = '#{test_event_type}'
        AND sapphire_student_se_accommodations.primary_id IS NOT NULL
        GROUP BY sapphire_student_se_accommodations.student_id"
        
        if tables_array = $db.get_data(sql_strg)
            
            output << $kit.tools.data_table(
                tables_array.insert(0, headers),
                "se_accommodations",
                "default",
                true,
                titles
            ) 
            
        else
            
            output << "No Data Found!"
            
        end
        
        return "SE Accommodations", output
        
    end

    def load_tab_5(test_event_site_id = @test_event_site_id)
        
        output = String.new
        
        output << $tools.div_open("site_staff_tab", "site_staff_tab")
        
        output << $tools.button_new_row(table_name = "TEST_EVENT_SITE_STAFF", "test_event_site_id")
        
        tables_array = Array.new
        
        headers = [
            "Not Attending",
            "Staff",
            "Staff ID",
            "Role"
        ]
        
        dates = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").field_values("date", "WHERE test_event_site_id  = '#{test_event_site_id}' GROUP BY date ORDER BY DATE ASC")
        headers.concat(dates) if dates
        
        records = $tables.attach("TEST_EVENT_SITE_STAFF").by_test_event_site_id(test_event_site_id)
        records.each{|record|
            
            row = Array.new
            
            row.push(record.fields["not_attending"].web.checkbox                                )
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
        
        output << $kit.tools.data_table(tables_array.insert(0, headers), "staff")
        
        output << $tools.div_close
        
        return "Site Staff", output
        
    end

    def load_tab_6
        
        tables_array = [
            
            #HEADERS
            [
                "Location Assignment"   ,
                "serial_number"         ,
                "grade_level"           ,
                "subject"               ,
                "large_print"           ,
                "status"                ,
                "verified"              ,
                "Returned to Warehouse (to be shipped)"
            ]
            
        ]
        
        pids = $tables.attach("TEST_PACKETS").primary_ids(" WHERE test_event_site_id = #{@test_event_site_id} ")
        pids.each{|pid|
            
            record  = $tables.attach("TEST_PACKETS").by_primary_id(pid)
            row     = Array.new
            
            row.push(!record.fields["returned_to_warehouse" ].is_true? ? $tools.button_new_row("TEST_PACKET_LOCATION", "test_packet_id_#{pid}=#{pid}", nil, "Re-Assign") : "")
            row.push(record.fields["serial_number"          ].web.label)
            row.push(record.fields["grade_level"            ].web.label)
            row.push(
                (
                    $tables.attach("TEST_SUBJECTS").field_value(
                       "name",
                       "WHERE primary_id = '#{record.fields["subject_id"].value}'"
                   ) ||
                   "Not Found"
                )
            )
            row.push(record.fields["large_print"            ].to_user)
            row.push(
                record.fields["status"                      ].web.select(
                    :dd_choices=>$dd.from_array(
                        [
                            "Completed",
                            "Unused",
                            "Do Not Score",
                            "Destroyed",
                            "In Progress"
                        ]
                    )
                )
            )
            row.push(record.fields["verified"               ].to_user)
            row.push(record.fields["returned_to_warehouse"  ].to_user)
            
            tables_array.push(row)
            
        } if pids
        
        return "Site Test Packets", $kit.tools.data_table(tables_array, "site_test_packets")     
       
    end
    
    def load_tab_1
        
        tables_array = [
            
            #HEADERS
            [
                "StudentID",
                "First Name",
                "Last Name",
                "Grade"
            ]
            
        ]
        
        test_dates_table    = $tables.attach("STUDENT_TEST_DATES")
        date_headers        = test_dates_table.test_event_site_dates(@test_event_site_id)
        dates_hash          = Hash.new
        date_headers.each{|date|
            tables_array[0].push(date)
            dates_hash[date] = nil
        } if date_headers
        
        sids        = $students.list(:test_event_site=>@test_event_site_id, :currently_enrolled=>true)#test_dates_table.sids_by_test_event_site_id(@test_event_site_id)
        
        sids.each{|sid|
            
            s = $students.get(sid)
            
            assigned_here       = $tables.attach("STUDENT_TESTS").by_studentid_old(sid, test_subject = nil, test_type = nil, @test_event_site_id)
            assignment_status   = assigned_here && s.active.is_true? ? "" : "*"
            
            row = Array.new
            dates_hash.each_key{|k|dates_hash[k]=nil}
            
            row.push(sid)
            row.push("#{assignment_status}#{s.studentfirstname.value}" )
            row.push("#{assignment_status}#{s.studentlastname.value}"  )
            row.push("#{assignment_status}#{s.grade.value}"            )
            pids = test_dates_table.pids_by_sid_test_event_site_id(sid, @test_event_site_id)
            pids.each{|pid|
                test_date_record        = test_dates_table.by_primary_id(pid)
                att_date                = test_date_record.fields["date"].value
                dates_hash[att_date]    = test_date_record.fields["attendance_code"]
            }
            date_headers.each{|att_date|
                
                if dates_hash[att_date].class == Field
                    row.push(dates_hash[att_date].web.select(:dd_choices=>att_codes_dd) )
                else
                    row.push("")
                end
                
            }
            #student_test_date_record = test_dates_table.by_primary_id(pid)
            
            tables_array.push(row)
            
        } if sids
        
        return "Attendance", $kit.tools.data_table(tables_array, "attendance")
        
    end
    
    def load_tab_2
        
        tables_array = [
            
            #HEADERS
            [
                "StudentID",
                "First Name",
                "Last Name",
                "Grade",
                "Test Subject",
                "Serial Number",      
                "Test Completed Date",          
                "Test Administrator",
                "Test Notes",
                "Assigned",           
                "Drop Off",           
                "Pick Up",
                "Active/Withdrawn",
                "Family Coach",
                "General Ed Teacher",
                "Special Ed Teacher",
            ]
            
        ]
        
        tests_pids = $tables.attach("STUDENT_TESTS").primary_ids(" WHERE test_event_site_id = #{@test_event_site_id} ")
        tests_pids.each{|pid|
            
            row         = Array.new
            test_record = $tables.attach("STUDENT_TESTS").by_primary_id(pid)
            sid         = test_record.fields["student_id"         ].value
            
            test_id = test_record.fields["test_id"].value
            
            status = $tables.attach("STUDENT").by_student_id(sid).fields["active"].value == "1" ? "Active":"Withdrawn" #FASTER
            #status = $students.get(sid).active.value == "1" ? "Active":"Withdrawn"  #SLOWER
            
            family_coach = String.new
            
            fc_relate = $tables.attach("STUDENT_RELATE").unique_student_role_records(sid, "Family Teacher Coach", "Family Coach", true)
            
            if fc_relate
                
                fc_relate.each_with_index do |record,i|
                    
                    family_coach << ", " if i != 0
                    team_row     = $tables.attach("team").by_primary_id(record.fields["team_id"].value)
                    family_coach << "#{team_row.fields['legal_first_name'].value} #{team_row.fields['legal_last_name'].value}" #FASTER
                    #family_coach << $team.get(record.fields["team_id"].value).full_name #SLOWER
                    
                end
                
            else
                
                family_coach = "N/A"
                
            end
            
            primary_teacher = String.new
            
            pt_relate = $tables.attach("STUDENT_RELATE").unique_student_role_records(sid, "Primary Teacher", "Primary Teacher", true)
            
            if pt_relate
                
                pt_relate.each_with_index do |record,i|
                    
                    primary_teacher << ", " if i != 0
                    team_row     = $tables.attach("team").by_primary_id(record.fields["team_id"].value)
                    primary_teacher << "#{team_row.fields['legal_first_name'].value} #{team_row.fields['legal_last_name'].value}" #FASTER
                    #primary_teacher << $team.get(record.fields["team_id"].value).full_name #SLOWER
                    
                end
                
            else
                
                primary_teacher = "N/A"
                
            end
            
            sed_teacher = String.new
            
            sed_relate = $tables.attach("STUDENT_RELATE").unique_student_role_records(sid, "Special Education Teachers", "Special Education Teachers", true)
            
            if sed_relate
                
                sed_relate.each_with_index do |record,i|
                    
                    sed_teacher << ", " if i != 0
                    team_row     = $tables.attach("team").by_primary_id(record.fields["team_id"].value)
                    sed_teacher << "#{team_row.fields['legal_first_name'].value} #{team_row.fields['legal_last_name'].value}" #FASTER
                    #sed_teacher << $team.get(record.fields["team_id"].value).full_name #SLOWER
                    
                end
                
            else
                
                sed_teacher = "N/A"
                
            end
            
            row.push(test_record.fields["student_id"         ].web.label()  )
            row.push($tables.attach("STUDENT").by_student_id(sid).fields["studentfirstname"].web.label()  )
            row.push($tables.attach("STUDENT").by_student_id(sid).fields["studentlastname"].web.label()  )
            row.push($tables.attach("STUDENT").by_student_id(sid).fields["grade"].web.label()  )
            row.push(test_record.fields["test_subject_id"    ].web.select(:disabled=>true, :dd_choices=>test_subjects_dd(test_id) )  )
            row.push(test_record.fields["serial_number"      ].web.select(:dd_choices=>$dd.test_events.test_packet_serial_numbers(:test_event_site_id=>@test_event_site_id,:grade=>$tables.attach("STUDENT").by_student_id(sid).fields["grade"].value,:subject=>test_record.fields["test_subject_id"].value)) )

            row.push(test_record.fields["completed"          ].web.default())
            row.push(test_record.fields["test_administrator" ].web.select(:dd_choices=>test_admin_dd(test_record.fields["test_administrator" ].value))  )
            
            id1 = $tables.attach("tests").find_field("primary_id", "WHERE name='AIMS'").value if $tables.attach("tests").find_field("primary_id", "WHERE name='AIMS'")
            id2 = $tables.attach("tests").find_field("primary_id", "WHERE name='K-6 Face To Face Assessment'").value if $tables.attach("tests").find_field("primary_id", "WHERE name='K-6 Face To Face Assessment'")
            id3 = $tables.attach("tests").find_field("primary_id", "WHERE name='May K-6 Face To Face Assessment'").value if $tables.attach("tests").find_field("primary_id", "WHERE name='May K-6 Face To Face Assessment'")
            
            if test_record.fields["test_id"].value == id1 ||
               test_record.fields["test_id"].value == id2 ||
               test_record.fields["test_id"].value == id3
                row.push(aims_scores(test_record.primary_id,sid))
            else
                row.push(test_record.fields["test_results"       ].web.default()  )
            end
            
            row.push(test_record.fields["assigned"           ].web.default()  )
            row.push(test_record.fields["drop_off"           ].web.text()  )
            row.push(test_record.fields["pick_up"            ].web.text()  ) 
            
            row.push(status)
            row.push(family_coach)
            row.push(primary_teacher)
            row.push(sed_teacher)
            
            tables_array.push(row)
            
        } if tests_pids
        
        return "Student Tests", $kit.tools.data_table(tables_array, "site_students")
        
    end
    
    def student_record(sid = $kit.params[:sid])
        
        output  = String.new
        
        output << $tools.newlabel("bottom")
        return output
        
    end
    
    def working_list
        
        working_list_css = "<style>
        .TEST_SITES__directions {
            height: 50px;
            overflow: auto;
            width: 300px;
        }
        .TEST_EVENT_SITES__special_notes {
            height: 50px;
            overflow: auto;
            width: 300px;
        }
        .TEST_SITES__facility_name {
            height: 50px;
            overflow: auto;
            width: 300px;
        }
        </style>"
        
        user_sams_ids_str = $team_member.sams_ids.field_values("sams_id", where_addon = nil)
        user_sams_ids_str = user_sams_ids_str ? user_sams_ids_str.join("','") : ""
        
        assigned_sites = $tables.attach("TEST_EVENT_SITE_STAFF").find_fields(
            field_name      = "test_event_site_id",
            where_clause    = "WHERE staff_id IN ('#{user_sams_ids_str}') AND not_attending IS NOT TRUE",
            options         = {:value_only=>true}
        )
        
        sites = $tables.attach("TEST_EVENT_SITES").primary_ids("WHERE all_staff IS TRUE")
        
        sites = (assigned_sites&&sites ? assigned_sites.concat(sites) : assigned_sites||sites)
        
        if sites
            
            output = Array.new
            
            output.push(
                :name       => "MyEvents (#{sites ? sites.length : 0})",
                :content    => working_list_css+expand_mytestevents
                
            )
            
            return output
            
        end
        
    end 
    
    def load_tab_4
        output = String.new
        test_event_site_date = $tables.attach("Test_Event_Sites").by_primary_id(@test_event_site_id).fields["start_date"].value
        output << "<div id='confirmation_dialog'></div>"
        output << "<input id='sample' hidden='true' name='sample' value=''>"
        output << $tools.kmailinput("kmail_subject", "Default Subject:", @default_subject)
        output << $tools.kmailtextarea("kmail_body", "Default Body:", File.read("#{$paths.templates_path}kmail/keystone_test_content.txt"))
        output << "<input class='submit_button' type='button' name='action' value='Send Reminder Kmails' onclick='confirmation_dialog_open();send(\"test_event_site_id,kmail_body,kmail_subject,sample\")'/>"
        output << $tools.newlabel("bottom")
        output << $tools.button_refresh("history_div", "test_event_site_id")
        output << $tools.div_open("history_div", "history_div")
        output << queue_history
        output << $tools.div_close()
        return "Reminders", output
    end
    
    def queue_history
        
        output = String.new
        
        kmail_log_records = $tables.attach("Kmail_Log").by_identifier("test_reminders__test_event_site_id__#{@test_event_site_id}")
        
        tables_array = [
            
            #HEADERS
            [
                "Queue Date",
                "Subject",
                "Body",
                "Other Info"
            ]
            
        ]
        
        kmail_log_records.each do |record|
            
            row = Array.new
            
            fields = record.fields
            
            row.push(fields["created_date" ].to_user)
            row.push(fields["subject"      ].value)
            row.push(fields["message"      ].web.textarea(:readonly=>true, :disabled=>true, :add_class=>"no_save"))
            
            total_kmails = fields["kmail_ids"].value.split(",")
            kmail_ids_sql_str = total_kmails.map{|x| "'#{x}'"}.join(",")
            
            duplicate_kmails = $db.get_data("SELECT primary_id FROM `kmail` WHERE primary_id IN(#{kmail_ids_sql_str}) AND error = 'DUPLICATE DETECTED'") || []
            
            if !duplicate_kmails.empty?
                
                row.push("#{duplicate_kmails.length} duplicate k-mail#{duplicate_kmails.length == 1 ? "":"s"} detected and was not sent.")
                
            else
                
                row.push("")
                
            end
            
            tables_array.push(row)
            
        end if kmail_log_records
        
        return $kit.tools.data_table(tables_array, "queue_history", "default", false, nil, nil, "desc")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
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

    def add_new_record_test_packet_location()
        
        output = String.new
        
        output << $tools.div_open("new_checkin_container", "new_checkin_container")
        
        test_packet_pid = ($kit.params.keys.find{|x|x.to_s.match(/test_packet_id/)}).to_s.split("_")[-1]
        
        tp_row    = $tables.attach("TEST_PACKETS").by_primary_id(test_packet_pid)
        tp_fields = tp_row.fields
        
        row = $tables.attach("TEST_PACKET_LOCATION").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Check-In")
            
            fields = row.fields
            
            output << fields["test_packet_id"     ].set(test_packet_pid).web.hidden
            output << fields["test_event_site_id" ].web.select(:label_option=>"Location:", :dd_choices=>test_event_sites_dd(tp_fields["test_event_id"].value), :validate=>true)
            output << fields["team_id"            ].web.select(:label_option=>"Team Member",:dd_choices=>staff_dd(              fields[     "test_event_site_id"    ].value))
            #output << fields["checkin_status"     ].web.text(:label_option=>"Status"    )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def expand_mytestevents
        
        tables_array = [
            
            #HEADERS
            [
                "Test Site Breakaway",
                "Event Name",
                "Region",         
                "Facility Name",      
                "Address",       
                "City",           
                "State",          
                "Zip Code",       
                "Site URL",       
                "Directions",     
                "Contact Name",   
                "Contact Phone", 
                "Contact Email",  
                "Available Hours",
                "Start Date",   
                "End Date",     
                "Special Notes",
                "Start Time",   
                "End Time"     
            ]
            
        ]
        
        user_sams_ids_str = $team_member.sams_ids.field_values("sams_id", where_addon = nil)
        user_sams_ids_str = user_sams_ids_str ? user_sams_ids_str.join("','") : ""
        
        pids = $tables.attach("TEST_EVENT_SITE_STAFF").find_fields(
            field_name      = "test_event_site_id",
            where_clause    = "WHERE staff_id IN ('#{user_sams_ids_str}')",
            options         = {:value_only=>true}
        )
        
        assigned_sites = $tables.attach("TEST_EVENT_SITE_STAFF").find_fields(
            field_name      = "test_event_site_id",
            where_clause    = "WHERE staff_id IN ('#{user_sams_ids_str}')",
            options         = {:value_only=>true}
        )
        
        sites = $tables.attach("TEST_EVENT_SITES").primary_ids("WHERE all_staff IS TRUE")
        
        pids = (assigned_sites&&sites ? assigned_sites.concat(sites) : assigned_sites||sites)
        
        pids.each{|pid|
            
            test_event_site_id      = pid #$tables.attach("TEST_EVENT_SITE_STAFF").by_primary_id(pid).fields["test_event_site_id"].value
            test_event_site_record  = $tables.attach("TEST_EVENT_SITES"     ).by_primary_id(test_event_site_id)
            
            test_site_id            = test_event_site_record.fields["test_site_id"].value
            test_site_record        = $tables.attach("TEST_SITES"           ).by_primary_id(test_site_id)
            
            test_event_id           = test_event_site_record.fields["test_event_id"].value
            test_event_record       = $tables.attach("TEST_EVENTS"          ).by_primary_id(test_event_id)
            
            test_event_site_students = $tables.attach("STUDENT_TESTS").students_by_event_site(test_event_site_id)
            
            row = Array.new
            
            row.push(
                
                $tools.breakaway_button(
                    :button_text        => test_event_site_record.fields["site_name"].value,
                    :page_name          => "Test_Event_Site_Web",
                    :additional_params  => {:test_event_site_id=>test_event_site_id},
                    :class              => nil
                )
                
            ) 
            
            row.push(test_event_record.fields["name"                    ].web.label()    )
            
            row.push(test_site_record ? test_site_record.fields["region"                   ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["facility_name"            ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["address"                  ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["city"                     ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["state"                    ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["zip_code"                 ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["site_url"                 ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["directions"               ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["contact_name"             ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["contact_phone"            ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["contact_email"            ].web.label() : "" )
            row.push(test_site_record ? test_site_record.fields["available_hours"          ].web.label() : "" )
            
            row.push(test_event_site_record.fields["start_date"         ].web.label()    ) 
            row.push(test_event_site_record.fields["end_date"           ].web.label()    ) 
            row.push(test_event_site_record.fields["special_notes"      ].web.label()    ) 
            row.push(test_event_site_record.fields["start_time"         ].web.label()    ) 
            row.push(test_event_site_record.fields["end_time"           ].web.label()    )
            
            tables_array.push(row)
            
        } if pids
      
        return $kit.tools.data_table(tables_array, "sites")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def event_sites_dd(test_event_id)
        
        $tables.attach("TEST_EVENT_SITES").dd_choices("site_name", "primary_id", "WHERE test_event_id = '#{test_event_id}' ORDER BY site_name ASC")
        
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
    
    def test_event_sites_dd(test_event_id=nil)
        
        where_clause = test_event_id ? "WHERE test_event_id = '#{test_event_id}'":nil
        
        $tables.attach("TEST_EVENT_SITES").dd_choices("site_name", "primary_id", where_clause)
        
    end
    
    def test_subjects_dd(test_id)
        
        $tables.attach("TEST_SUBJECTS").dd_choices("name", "primary_id", "WHERE test_id = '#{test_id}'")
        
    end
    
    def test_types_dd
        
        $tables.attach("TESTS").dd_choices("name", "primary_id")
        
    end
    
    def att_codes_dd
        return [
            {:name=>"ut",       :value=>"ut"        },
            {:name=>"pt",       :value=>"pt"        },
            {:name=>"Resched",  :value=>"Resched"   }
        ]
    end
    
    def test_admin_dd(assigned_staff_id = nil)
        
        k12_db = $tables.attach("k12_staff").data_base
        
        results =  $tables.attach("TEST_EVENT_SITE_STAFF").dd_choices(
            "CONCAT(k12_staff.firstname,' ',k12_staff.lastname)",
            "staff_id",
            " LEFT JOIN #{k12_db}.k12_staff ON staff_id = k12_staff.samspersonid WHERE test_event_site_id = '#{@test_event_site_id}' "
        )
        
        if assigned_staff_id && $tables.attach("K12_STAFF").primary_ids(" WHERE samspersonid = '#{assigned_staff_id}' ")
            assigned_staff_results =  $tables.attach("K12_STAFF").dd_choices(
                "CONCAT(firstname,' ',lastname)",
                "samspersonid",
                " WHERE samspersonid = '#{assigned_staff_id}' "
            )
            if results
                results.push(assigned_staff_results[0])
            else
                results = assigned_staff_results
            end
            
        end
        
        return results
        
    end
    
    def reading_comp_read_dd
        return [
            {:name=>"Student Read",       :value=>"Student Read"        },
            {:name=>"Teacher Read",       :value=>"Teacher Read"        }
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def aims_scores(test_id,sid)
        
        tables_array = [
            
            #HEADERS
            [
                "K-2 Skill Check Completed",
                "Writing Sample Received",
                "3rd - 5th Math Open-Ended Prompt Completed",
                "CORE Phonics- Letter Names Upper Case (_/26)",
                "CORE Phonics- Letter Names Lower Case (_/26)",
                "CORE Phonics- Consonant Sounds (_/23)",
                "CORE Phonics- Long Vowel Sounds (_/5)",
                "CORE Phonics- Short Vowel Sounds (_/5)",
                "CORE PHONICS- Short Vowels in CVC Words (_/10)",
                "CORE PHONICS- Short Vowels, Digraphs, and -tch trigraph (_/10)",
                "CORE PHONICS- Consonant Blends with Short Vowels (_/20)",
                "CORE PHONICS- Long Vowel Spelling (_/10)",
                "CORE PHONICS- R- and L- Controlled Words (_/10)",
                "CORE PHONICS- Variant Vowels and Dipthongs (_/10)",
                "CORE PHONICS- Multisyllabic Words (_/24)",
                "CORE-PHONICS- Spelling A First Sounds (_/5)",
                "CORE-PHONICS- Spelling B Last Sounds (_/5)",
                "CORE-PHONICS- Spelling C Whole Words (_/10)",
                "Reading Comprehension (correct/total)",
                "Reading Comprehension (Student Read or Teacher Read)",
                "LNF",
                "LNF Errors",
                "LSF",
                "LSF Errors",
                "PSF",
                "PSF Errors",
                "NWF",
                "NWF Errors",
                "R-CBM",
                "R-CBM Errors",
                "Reading Instructional Recommendation (K - 2)",
                "OCM",
                "OCM Errors",
                "NIM",
                "NIM Errors",
                "QDM",
                "QDM Errors",
                "MNM",
                "MNM Errors",
                "M-COMP", #Still M-CAP field
                "Math Instructional Recommendation (K - 2)",
                "Notes"
            ]
        ]
        
        if test = $students.get(sid).aims_tests.existing_records("WHERE test_id = '#{test_id}' ORDER BY created_date DESC")
            test = test[0]
        else
            test = $students.get(sid).aims_tests.new_record
            test.fields["test_id"].value = test_id
            test.save
        end
        
        row = Array.new
        row.push(test.fields["k2_skill_check_complete"                  ].web.default() )
        row.push(test.fields["writing_sample_received"                  ].web.default() )
        row.push(test.fields["35_math_open_prompt_complete"             ].web.default() )
        row.push(test.fields["core_phonics_letter_names_upper"          ].web.text() )
        row.push(test.fields["core_phonics_letter_names_lower"          ].web.text() )
        row.push(test.fields["core_phonics_consonant"                   ].web.text() )
        row.push(test.fields["core_phonics_long_vowel"                  ].web.text() )
        row.push(test.fields["core_phonics_short_vowel"                 ].web.text() )
        row.push(test.fields["core_phonics_short_vowel_cvc"             ].web.text() )
        row.push(test.fields["core_phonics_short_vowel_digraph"         ].web.text() )
        row.push(test.fields["core_phonics_consonant_blend"             ].web.text() )
        row.push(test.fields["core_phonics_long_vowel_spelling"         ].web.text() )
        row.push(test.fields["core_phonics_rl_control"                  ].web.text() )
        row.push(test.fields["core_phonics_variant_vowels"              ].web.text() )
        row.push(test.fields["core_phonics_multisyllabic"               ].web.text() )
        row.push(test.fields["core_phonics_spelling_a"                  ].web.text() )
        row.push(test.fields["core_phonics_spelling_b"                  ].web.text() )
        row.push(test.fields["core_phonics_spelling_c"                  ].web.text() )
        row.push(test.fields["reading_comprehension"                    ].web.text() )
        row.push(test.fields["reading_comprehension_who_read"           ].web.select(:dd_choices=>reading_comp_read_dd) )
        row.push(test.fields["lnf"                                      ].web.default() )
        row.push(test.fields["lnf_errors"                               ].web.default() )
        row.push(test.fields["lsf"                                      ].web.default() )
        row.push(test.fields["lsf_errors"                               ].web.default() )
        row.push(test.fields["psf"                                      ].web.default() )
        row.push(test.fields["psf_errors"                               ].web.default() )
        row.push(test.fields["nwf"                                      ].web.default() )
        row.push(test.fields["nwf_errors"                               ].web.default() )
        row.push(test.fields["rcbm"                                     ].web.default() )
        row.push(test.fields["rcbm_errors"                              ].web.default() )
        row.push(test.fields["reading_instructional_recommendation"     ].web.default() )
        row.push(test.fields["ocm"                                      ].web.default() )
        row.push(test.fields["ocm_errors"                               ].web.default() )
        row.push(test.fields["nim"                                      ].web.default() )
        row.push(test.fields["nim_errors"                               ].web.default() )
        row.push(test.fields["qdm"                                      ].web.default() )
        row.push(test.fields["qdm_errors"                               ].web.default() )
        row.push(test.fields["mnm"                                      ].web.default() )
        row.push(test.fields["mnm_errors"                               ].web.default() )
        row.push(test.fields["mcap"                                     ].web.default() )
        row.push(test.fields["math_instructional_recommendation"        ].web.default() )
        row.push(test.fields["notes"                                    ].web.default() )
        
        tables_array.push(row)
        
        return $kit.tools.table(
        :table_array    =>tables_array,
        :unique_name    => "aims_test",
        :footers        => false,
        :head_section   => false,
        :title          => false,
        :legend         => false,
        :caption        => false,
        :embedded_style => {
            :table  => "width:100%;",
            :th     => nil,
            :tr     => nil,
            :tr_alt => nil,
            :td     => nil
        }
        )
        
    end
    
    def queue_kmail_process(test_event_site_id, subject, message, sample = true)
        
        output = String.new
        
        sids = $tables.attach("STUDENT_TESTS").field_values("student_id", "WHERE test_event_site_id = '#{test_event_site_id}' GROUP BY student_id")
        
        if sids
            
            if sample
                
                sample_message = generate_sample(sids.first, message, test_event_site_id)
                output << $tools.div_open("sample_div")
                output << $tools.newlabel("message", "K-mail Preview: Does this look ok...?")
                output << $tools.newlabel("percent_alert", "Unsubstituted value detected") if sample_message.match(/%%/)
                output << $tools.newdisabledtextarea("kmail_body_sample", "", sample_message)
                
            else
                
                csv_path = $reports.save_document({:category_name=>"Athena",:type_name=>"Mass Kmail Students List",:csv_rows=>sids})
                
                $base.queue_process("Queue_Kmails", "testing_reminder", "#{test_event_site_id}<,>#{subject}<,>#{message}<,>#{csv_path}")
                
                output   = "#{sids.length.to_s} kmails successfully queued.<br>It can take up to 10 minutes for the log to display your k-mail.<br>Actual kmail delivery time to student's inbox varies depending on current queue volume."
                
                $kit.modify_tag_content("history_div", queue_history, "update")
                
            end
            
        else
            
            output   = "No students are assigned to this site."
            
        end
        
        $kit.modify_tag_content("confirmation_dialog", output, "update")
        
    end
    
    def generate_sample(sid, message, test_event_site_id)
        
        subjects = String.new
        
        test_subject_ids = $tables.attach("STUDENT_TESTS").field_values("test_subject_id", "WHERE student_id = '#{sid}' AND test_event_site_id = '#{test_event_site_id}' AND test_subject_id IS NOT NULL").each_with_index do |test_subject_id,i|
            
            subjects << " & " if i != 0
            subjects << $tables.attach("TEST_SUBJECTS").by_primary_id(test_subject_id).fields["name"].value
            
        end if test_subject_ids
        
        test_event_site_row = $tables.attach("Test_Event_Sites").by_primary_id(test_event_site_id)
        
        start_date          = test_event_site_row.fields["start_date"    ].to_user
        start_time          = test_event_site_row.fields["start_time"    ].value
        end_time            = test_event_site_row.fields["end_time"      ].value
        special_notes       = test_event_site_row.fields["special_notes" ].value || "N/A"
        site_id             = test_event_site_row.fields["test_site_id"  ].value
        
        site_row            = $tables.attach("Test_Sites").by_primary_id(site_id)
        
        site                = site_row.fields["region"                   ].value || ""
        facility            = site_row.fields["facility_name"            ].value || ""
        address             = site_row.fields["address"                  ].value || ""
        city                = site_row.fields["city"                     ].value || ""
        state               = site_row.fields["state"                    ].value || ""
        zip                 = site_row.fields["zip_code"                 ].value || ""
        site_address        = "#{address}
#{city}, #{state} #{zip}"
        site_url            = site_row.fields["site_url"                 ].value || ""
        directions          = site_row.fields["directions"               ].value || "N/A"
        
        message.gsub!("%%site%%",                    site         ) if site
        message.gsub!("%%subject%%",                 subjects     ) if subjects
        message.gsub!("%%site_date%%",               start_date   ) if start_date
        message.gsub!("%%start_time%%",              start_time   ) if start_time
        message.gsub!("%%est_end_time%%",            end_time     ) if end_time
        message.gsub!("%%name_of_facility%%",        facility     ) if facility
        message.gsub!("%%site_address%%",            site_address ) if site_address
        message.gsub!("%%site_url%%",                site_url     ) if site_url
        message.gsub!("%%Directions%%",              directions   ) if directions
        message.gsub!("%%Special Notes%%",           special_notes) if special_notes
        
        return message
        
    end
    
    def queue_kmails
        kmail_ids = Array.new
        sender  = "office_admin"
        @kmail_hash.each_pair do |k,v|
            student = $students.attach(k)
            content = v
            kmail_ids << student.queue_kmail(@subject, content, sender)
            $students.detach(k)
        end
        @kmail_log.fields["kmail_ids"].value = kmail_ids.join(",")
        @kmail_log.save
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            #search_dialog_button{  display:none;}
            
            div.kmail_subject{                  float:left; clear:left; margin-bottom:5px;}
            div.kmail_subject label{            display:inline-block; width:120px;}
            div.kmail_subject input{            width:900px;}
            
            div.kmail_body{                     float:left; clear:left; margin-bottom:5px;}
            div.kmail_body label{               display:inline-block; width:120px; vertical-align:top;}
            div.kmail_body textarea{            width:900px; height:300px; resize:none; overflow-y:scroll;}
            div.KMAIL_LOG__message textarea{    width:450px; height:70px; resize:none; overflow-y:scroll;}
            
            input.submit_button{                float:left; clear:left; margin-bottom:10px;}
            
            div.kmail_body_sample{              float:left; clear:left; margin-bottom:5px; margin-left:120px;}
            div.kmail_body_sample textarea{     width:900px; height:300px; resize:none; overflow-y:scroll; background:none; border:2px solid black;}
            
            div.message{                        float:left; clear:left; margin-left:120px; margin-top:5px; margin-bottom:10px; font-size:1.3em;}
            div.percent_alert{                  float:left; clear:left; color:red; margin-left:120px; margin-bottom:10px;}
            
            div.KMAIL_LOG__created_date{        float:left; clear:left; width:300px;}
            div.KMAIL_LOG__created_by{          float:left; }
            
            div.STUDENT_AIMS_TESTS__lnf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lnf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lsf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lsf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__psf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__psf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nwf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nwf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__ocm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__ocm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nim             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nim_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__qdm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__qdm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mnm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mnm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__rcbm            input{width: 50px;}
            div.STUDENT_AIMS_TESTS__rcbm_errors     input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mcap            input{width: 50px;}
            
            div.STUDENT_AIMS_TESTS__requirement_for_aims_benchmark  {text-align: center;}
            div.STUDENT_AIMS_TESTS__mcap_read_to_student            {text-align: center;}
            
            div.STUDENT_TESTS__assigned                             {text-align: center;}
            
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