#!/usr/local/bin/ruby


class ATHENA_PROJECT_MANAGEMENT_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        @disabled = !(["athena-reports@agora.org", "jhalverson@agora.org", "kyoung@agora.org"].include?($kit.user))
        @qa_tester = ["1085"]
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def breakaway_caption
        return "Athena Projects"
    end
    
    def page_title
        return "Athena Projects"
    end
    
    def load
        
        tabs = Array.new
        tabs.push(["System/Module/Process",                     load_tab_1                                                              ]           )
        tabs.push(["Projects",                                  "Please Select the 'Projects' link in the 'Systems' tab."               ]           )
        tabs.push(["Project Requirements/Use Cases",            "Please Select the 'Use Cases' link in the 'Projects' tab."             ]           )
        tabs.push(["Technical Specifications",                  "Please Select the 'Technical Specs' link in the 'Requirements' tab."   ]           )
        tabs.push(["Bugs",                                      load_tab_5                                                              ]           )
        
        $kit.tools.tabs(tabs,0)
        
    end
    
    def response
        
        if $kit.params[:add_new_ATHENA_PROJECT_SYSTEMS]
            $kit.modify_tag_content("tabs-1", load_tab_1, "update")
            $kit.modify_tag_content("tabs-2", load_tab_2, "update")
        end
        
        if $kit.params[:add_new_ATHENA_PROJECT]
            $kit.modify_tag_content("tabs-2", load_tab_2($kit.params[:field_id____ATHENA_PROJECT__system_id])   , "update")
        end
        
        if $kit.params[:add_new_ATHENA_PROJECT_REQUIREMENTS]
            $kit.modify_tag_content("tabs-3", load_tab_3($kit.params[:field_id____ATHENA_PROJECT_REQUIREMENTS__project_id]), "update")
        end
        
        if $kit.params[:add_new_ATHENA_PROJECT_REQUIREMENTS_SPECS]
            $kit.modify_tag_content("tabs-4", load_tab_4($kit.params[:field_id____ATHENA_PROJECT_REQUIREMENTS_SPECS__requirement_id]), "update")
        end
        
        if $kit.params[:add_new_ATHENA_PROJECT_BUGS]
            $kit.modify_tag_content("tabs-5", load_tab_5, "update")
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load_tab_1(arg = nil)#SYSTEMS
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "ATHENA_PROJECT_SYSTEMS")
        
        tables_array = [
            
            #HEADERS
            [
                "Projects Link",
                "System/Module/Process Name",
                "Primary Contact",
                "Status"
                
            ]
            
        ]
     
        pids = $tables.attach("ATHENA_PROJECT_SYSTEMS").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("ATHENA_PROJECT_SYSTEMS").by_primary_id(pid)
            
            row = Array.new
            
            project_tot        = $tables.attach("ATHENA_PROJECT").primary_ids("WHERE system_id = '#{pid}'")
            project_complete   = $tables.attach("ATHENA_PROJECT").primary_ids("WHERE system_id = '#{pid}' AND development_phase = 'Production/Technical Support'")
            row.push($tools.button_load_tab(2, "Projects (#{project_tot ? "#{project_complete ? project_complete.length : "0"}/#{project_tot.length}" : "0/0"})",    pid))
            
            row.push(record.fields["system_name"               ].value)#web.default()              )
            row.push(record.fields["owner_team_id"             ].to_name(:full_name)    )
            row.push(record.fields["status"                    ].to_user()              )
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "athena_project_systems")
        
        output << $tools.newlabel("bottom")
        
    end

    def load_tab_2(system_id = nil)#PROJECTS
        
        #CLEAR TABS THAT MAY HAVE BEEN LOADED WITH OTHER PROJECTS'S DETAILS PREVIOUSLY.
        $kit.modify_tag_content("tabs-3", "Please Select the 'Requirement' link in the 'Projects' tab."     , "update")
        $kit.modify_tag_content("tabs-4", "Please Select the 'Specs' link in the 'Requirements' tab."       , "update")
        
        output = String.new
        
        output << "<input id='system_id' type='hidden' name='system_id' value='#{system_id}'/>"
        
        output << $tools.button_new_row(table_name = "ATHENA_PROJECT", "system_id")
        
        headers = Array.new
        
        headers.push("Use Cases"             )
        headers.push("System"                ) if system_id == "19"
        headers.push("Status"                )
        headers.push("Development Progress"  )
        headers.push("Project Name"          )
        headers.push("Description"           )
        headers.push("Requested Priority"    )
        headers.push("Requested ETA"         )
        headers.push("Size"                  )
        headers.push("Priority Level"        )
        headers.push("ETA"                   )
        headers.push("Requestor"             )
        headers.push("Date Submitted"        )
        
        tables_array = [
            
            headers
            
        ]
     
        pids = $tables.attach("ATHENA_PROJECT").primary_ids("WHERE system_id = '#{system_id}'")
        pids.each{|pid|
            
            record              = $tables.attach("ATHENA_PROJECT").by_primary_id(pid)
            
            row = Array.new
            
            #REQUESTER ENTERED
            requirements_tot        = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").primary_ids("WHERE project_id = '#{pid}'")
            requirements_complete   = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").primary_ids("WHERE project_id = '#{pid}' AND development_phase = 'Production/Technical Support'")
            row.push($tools.button_load_tab(3, "Use Cases (#{requirements_tot ? "#{requirements_complete ? requirements_complete.length : "0"}/#{requirements_tot.length}" : "0/0"})",    pid))
            
            row.push(record.fields["system_id"                  ].web.select(   :disabled=>@disabled, :dd_choices=>systems_dd           ) ) if system_id == "19"
            row.push(record.fields["status"                     ].web.select(   :disabled=>@disabled, :dd_choices=>project_status_dd    ) )
            row.push(record.fields["development_phase"          ].web.select(   :disabled=>@disabled, :dd_choices=>project_phase_dd     ) )
            row.push(record.fields["project_name"               ].web.text(                                                             ) )
            row.push(record.fields["brief_description"          ].web.default(  :disabled=>true                                         ) )
            row.push(record.fields["requested_priority_level"   ].web.label(                                                            ) )
            row.push(record.fields["requested_completion_date"  ].web.label(                                                            ) )
            
            #ASSIGNER ENTERED
            row.push(record.fields["project_type"               ].web.select(   :disabled=>@disabled, :dd_choices=>project_type_dd      ) )
            row.push(record.fields["priority_level"             ].web.select(   :disabled=>@disabled, :dd_choices=>priority_level_dd    ) )
            row.push(record.fields["estimated_completion_date"  ].web.default(  :disabled=>@disabled                                    ) )
            
            #SYSTEM DETERMINED
            row.push(record.fields["requester_team_id"          ].web.select(:dd_choices=>requestor_dd                                  ) )
            row.push(record.fields["created_date"               ].value                                                                   )
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "athena_projects")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_3(project_id = nil) #REQUIREMENTS
        
        #CLEAR TABS THAT MAY HAVE BEEN LOADED WITH OTHER PROJECTS'S DETAILS PREVIOUSLY.
        $kit.modify_tag_content("tabs-4", "Please Select the 'Specs' link in the 'Requirements' tab."       , "update")
        
        output = String.new
        
        output << $tools.newlabel("athena_project_requirements_header", $tables.attach("ATHENA_PROJECT").by_primary_id(project_id).fields["project_name"].value)
        
        output << "<input id='project_id' type='hidden' name='project_id' value='#{project_id}'/>"
        
        output << $tools.button_new_row(table_name = "ATHENA_PROJECT_REQUIREMENTS", "project_id")
        
        tables_array = [
            
            #HEADERS
            [
               
                "Technical Specs",
                "Requirement",
                "Type",
                "Priority Level",
                "Size",
                "Approval Status",
                "Progress",
                "Requested By",
                "Created Date"
            ]
            
        ]
     
        pids = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").primary_ids("WHERE project_id = '#{project_id}' ORDER BY created_date DESC")
        pids.each{|pid|
            
            record = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").by_primary_id(pid)
            
            row = Array.new
            
            row.push($tools.button_load_tab(4, "Technical Specs",    pid))
            row.push(record.fields["requirement"                ].web.default(:disabled=>true))
            
            type = String.new
            type << record.fields["automated_process"           ].web.default(:label_option=>"Automated Process"    )
            type << record.fields["pdf_template"                ].web.default(:label_option=>"PDF Template"         )
            type << record.fields["process_improvement"         ].web.default(:label_option=>"Process Improvement"  )
            type << record.fields["report"                      ].web.default(:label_option=>"Report"               )
            type << record.fields["system_interface"            ].web.default(:label_option=>"System Interface"     )
            type << record.fields["user_interface"              ].web.default(:label_option=>"User Interface"       )
            type << record.fields["change"                      ].web.default(:label_option=>"Change"               )
            
            row.push(type)
            row.push(record.fields["priority"                   ].web.select(:dd_choices=>priority_level_dd     ))
            row.push(record.fields["type"                       ].web.select(:dd_choices=>project_type_dd       )) 
            row.push(record.fields["status"                     ].web.select(:dd_choices=>project_status_dd     ))
            row.push(record.fields["development_phase"          ].web.select(   :disabled=>@disabled, :dd_choices=>project_phase_dd     ) )
            row.push(record.fields["requester_team_id"          ].web.select(:dd_choices=>requestor_dd                                  ) )
            row.push(record.fields["created_date"               ].to_user)
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "ATHENA_PROJECT_REQUIREMENTS")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_4(requirement_id = nil)
        
        output = String.new
        
        project_id = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").by_primary_id(requirement_id).fields["project_id"].value
        
        req_name        = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").by_primary_id(requirement_id).fields["requirement"].value
        project_name    = $tables.attach("ATHENA_PROJECT").by_primary_id(project_id).fields["project_name"].value
        output << $tools.newlabel("athena_project_requirements_header", "#{project_name} - #{req_name}")
        
        output << "<input id='requirement_id' type='hidden' name='requirement_id' value='#{requirement_id}'/>"
        
        output << $tools.button_new_row(table_name = "ATHENA_PROJECT_REQUIREMENTS_SPECS", "requirement_id")
        
        tables_array = [
            
            #HEADERS
            [
                
                "Specification",
                "Created Date",
                "Assigned",
                "Completion Order",
                "Completed"
                
            ]
            
        ]
     
        pids = $tables.attach("ATHENA_PROJECT_REQUIREMENTS_SPECS").primary_ids("WHERE requirement_id = '#{requirement_id}' ORDER BY created_date DESC")
       
        if pids
            
            range_end = pids.length
            
            pids.each{|pid|
                
                record = $tables.attach("ATHENA_PROJECT_REQUIREMENTS_SPECS").by_primary_id(pid)
                
                row = Array.new
                
                row.push(record.fields["specification"      ].web.default     )
                row.push(record.fields["created_date"       ].to_user   )
                row.push(record.fields["team_id"            ].web.select(:dd_choices=>$dd.team_members(:department_category => "Software")))
                row.push(record.fields["completion_order"   ].web.select(:dd_choices=>$dd.range(1,range_end))     )
                row.push(record.fields["completed"          ].web.default     )
                
                tables_array.push(row)
                
            } 
            
        end
        
        output << $kit.tools.data_table(tables_array, "ATHENA_PROJECT_REQUIREMENTS_SPECS")
        
        output << $tools.newlabel("bottom")
        
    end
    
    def load_tab_5
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "ATHENA_PROJECT_BUGS")
        
        tables_array = [
            
            #HEADERS
            [
               
                "Ticket ID",
                "Status",
                "System",
                "Project",
                "Server",
                "Location Found",
                "Error Message",
                "Description",
                "Notes",
                "Date Submitted"
                
            ]
            
        ]
     
        pids = $tables.attach("ATHENA_PROJECT_BUGS").primary_ids("ORDER BY created_date DESC")
        pids.each{|pid|
            
            record = $tables.attach("ATHENA_PROJECT_BUGS").by_primary_id(pid)
            
            row = Array.new
            
            if record.fields["status"].value == "Closed"
                
                row.push(record.fields["primary_id"].value)
                row.push(record.fields["status"    ].value)
                
                if !record.fields["system_id"].value.nil?
                    aps_db = $tables.attach("athena_project_systems").data_base
                    row.push(
                        record.fields["system_id"].set(
                            $db.get_data_single(
                                "SELECT
                                    system_name
                                FROM #{aps_db}.athena_project_systems
                                WHERE primary_id = #{record.fields["system_id"].value}"
                            )[0]
                        ).value
                    )
                    
                else
                    
                    row.push("")
                    
                end
                p = record.fields["project_id"]
                ap_db = $tables.attach("athena_project").data_base
                projectname = p.value.nil? ? "" : $db.get_data_single("SELECT project_name FROM #{ap_db}.athena_project WHERE primary_id = #{p.value}")[0]
                row.push(projectname)
                row.push(record.fields["server"         ].value)
                row.push(record.fields["location_found" ].value)
                row.push(record.fields["error_message"  ].value)
                row.push(record.fields["description"    ].value)
                row.push(record.fields["notes"          ].value)
                row.push(record.fields["created_date"   ].to_user) 
                
            else
                
                row.push(record.fields["primary_id"     ].to_user)
                row.push(record.fields["status"         ].web.select(   :disabled=>@disabled, :dd_choices=>status_of_bug_dd       ) )
                
                row.push(record.fields["system_id"].web.select(
                    :disabled       => @disabled, 
                    :onchange       => "fill_select_option('#{record.fields["project_id" ].web.field_id}', this  );",
                    :dd_choices     => systems_dd
                ))
                
                row.push(record.fields["project_id"     ].web.select(   :disabled=>@disabled, :dd_choices=>existing_projects_dd(record.fields["system_id"].value) ) )
                row.push(record.fields["server"         ].web.select(   :disabled=>@disabled, :dd_choices=>server_dd ) )
                row.push(record.fields["location_found" ].web.default(  :disabled=>@disabled ) )
                row.push(record.fields["error_message"  ].web.default(  :disabled=>@disabled ) )
                row.push(record.fields["description"    ].web.default(  :disabled=>@disabled ) )
                row.push(record.fields["notes"          ].web.default(  :disabled=>@disabled ) )
                row.push(record.fields["created_date"   ].to_user)
                
            end
            
            tables_array.push(row)
            
        } if pids
        
        output << $kit.tools.data_table(tables_array, "ATHENA_PROJECT_BUGS")
        
        output << $tools.newlabel("bottom")
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_athena_project()
        
        output = String.new
        
        output << $tools.div_open("athena_project_container", "athena_project_container")
        
        row = $tables.attach("ATHENA_PROJECT").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Project Details")
        
            output << fields["project_name"].web.text(:label_option=>"Project Name:")
            output << fields["brief_description"].web.textarea(:label_option=>"Description:", :resizable=>true)
            output << fields["requested_priority_level"].web.select(:label_option=>"Requested Priority:", :dd_choices=>priority_level_dd)
            output << fields["requested_completion_date"].web.default(:label_option=>"Requested ETA:")
            
            output << fields["system_id"].set($kit.params[:system_id]).web.hidden
            output << fields["requester_team_id" ].set($team_member.primary_id.value ).web.hidden
            output << fields["status"            ].set("Approval - Pending"          ).web.hidden
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end

    def add_new_record_athena_project_bugs
        
        output = String.new
        
        output << $tools.div_open("athena_project_bugs_container", "athena_project_bugs_container")
        
        row = $tables.attach("ATHENA_PROJECT_BUGS").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Bug Details")
        
            output << fields["system_id"        ].web.select( :label_option=>"System:"      ,:onchange=>"fill_select_option('#{fields["project_id"].web.field_id}', this  );",:dd_choices=>systems_dd)
            output << fields["project_id"       ].web.select( :label_option=>"Project:"     ,:dd_choices=>existing_projects_dd)
            output << fields["server"           ].web.select( :label_option=>"Server:"      ,:dd_choices=>server_dd)
            output << fields["location_found"   ].web.default(:label_option=>"Location Found:")
            output << fields["description"      ].web.default(:label_option=>"Description:")
            output << fields["error_message"    ].web.default(:label_option=>"Error Message:")
            output << fields["notes"            ].web.default(:label_option=>"Notes:")
            
            output << fields["status"].set("New").web.hidden
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_athena_project_requirements
        
        output = String.new
        
        output << $tools.div_open("athena_project_requirements_container", "athena_project_requirements_container")
        
        row = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Requirement Description")
        
        output << fields["requirement"          ].web.default()
        
        output << fields["automated_process"    ].web.default(:label_option=>"Automated Process"    )
        output << fields["pdf_template"         ].web.default(:label_option=>"PDF Template"         )
        output << fields["process_improvement"  ].web.default(:label_option=>"Process Improvement"  )
        output << fields["report"               ].web.default(:label_option=>"Report"               )
        output << fields["system_interface"     ].web.default(:label_option=>"System Interface"     )
        output << fields["user_interface"       ].web.default(:label_option=>"User Interface"       )
        output << fields["change"               ].web.default(:label_option=>"Change"               )
        output << fields["requester_team_id"    ].web.select( :label_option=>"Requested By", :dd_choices=>requestor_dd              )
        
        output << fields["priority"             ].web.select(:dd_choices=>priority_level_dd, :label_option=>"Priority Level")
        
        output << fields["project_id"           ].set($kit.params[:project_id]).web.hidden
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_athena_project_requirements_specs
        
        output = String.new
        
        output << $tools.div_open("athena_project_requirements_specs_container", "athena_project_requirements_specs_container")
        
        row = $tables.attach("ATHENA_PROJECT_REQUIREMENTS_SPECS").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "Technical Specifications")
        
            output << fields["specification"].web.default()
            
            output << fields["requirement_id"].set($kit.params[:requirement_id]).web.hidden
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end

    def add_new_record_athena_project_systems()
        
        output = String.new
        
        output << $tools.div_open("systems_container", "systems_container")
        
        row = $tables.attach("ATHENA_PROJECT_SYSTEMS").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "System Details")
        
            output << fields["system_name"].web.text(:label_option=>"System Name:")
            output << fields["owner_team_id"].web.select(:label_option=>"Primary Contact:", :dd_choices=>requestor_dd)
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def existing_projects_dd(system_id = nil)
        
        where_clause = system_id ? "WHERE system_id = #{system_id}" : nil
        
        return $tables.attach("ATHENA_PROJECT").dd_choices(
            "project_name",
            "primary_id",
            " #{where_clause} ORDER BY project_name ASC "
        )
        
    end
    
    def phase_dd(project_id = nil)
        
        highest_planned_phase = $tables.attach("ATHENA_PROJECT_REQUIREMENTS").find_field(
            "development_phase",
            "WHERE development_phase IS NOT NULL
            AND project_id = '#{project_id}'
            ORDER BY development_phase DESC"
        )
        
        if highest_planned_phase
            return $dd.range(1,(highest_planned_phase.value.to_i+5))
        else
            return $dd.range(1,5)
        end
        
    end

    def priority_level_dd
        
        return [
            {:name=>"Low",      :value=>"Low"       },
            {:name=>"Medium",   :value=>"Medium"    },
            {:name=>"High",     :value=>"High"      },
            {:name=>"Urgent",   :value=>"Urgent"    }
        ]
        
    end
    
    def project_type_dd
        
        return [
            {:name=>"Small"    ,   :value=>"Small"    },
            {:name=>"Medium"   ,   :value=>"Medium"   },
            {:name=>"Large"    ,   :value=>"Large"    } 
        ]
        
    end
    
    def requestor_dd
        
        ap_db = $tables.attach("ATHENA_PROJECT_SYSTEMS").data_base
        
        return $tables.attach("TEAM").dd_choices(
            "CONCAT(legal_first_name,' ',legal_last_name)",
            "team.primary_id",
            "LEFT JOIN #{ap_db}.athena_project_systems ON athena_project_systems.owner_team_id = team.primary_id
            WHERE (
                athena_project_systems.owner_team_id IS NOT NULL
                OR employee_type = 'Principal'
                OR employee_type = 'Director'
            )
            GROUP BY team.primary_id
            ORDER BY CONCAT(legal_first_name,' ',legal_last_name) ASC "
        )
        
    end
    
    def server_dd
        
        return [
            {:name=>"Production Server" ,    :value=>"Production Server"     },
            {:name=>"Test Server"       ,    :value=>"Test Server"           },
            {:name=>"All Servers"       ,    :value=>"All Servers"           }
        ]
        
    end
    
    def project_phase_dd(project_type = nil)
        
        dd_options = Array.new
        
        dd_options.push({:name=>"Requirements Gathering"        , :value=>"Requirements Gathering"         })
        dd_options.push({:name=>"Requirements Analysis"         , :value=>"Requirements Analysis"          })
        dd_options.push({:name=>"Design & Prototype"            , :value=>"Design & Prototype"             })
        dd_options.push({:name=>"Demo/Develop Iterations"       , :value=>"Demo/Develop Iterations"        })
        dd_options.push({:name=>"Quality Assurance"             , :value=>"Quality Assurance"              })
        dd_options.push({:name=>"Production/Technical Support"  , :value=>"Production/Technical Support"   })
        dd_options.push({:name=>"No Longer Used/Deprecated"     , :value=>"No Longer Used/Deprecated"      })
        
        return dd_options
        
    end
    
    def project_status_dd(project_type = nil)
        
        dd_options = Array.new
        
        dd_options.push({:name=>"Approval - Pending"        , :value=>"Approval - Pending"          })
        dd_options.push({:name=>"Approval - Received"       , :value=>"Approval - Received"         })
        dd_options.push({:name=>"Approval - Denied"         , :value=>"Approval - Denied"           })
        dd_options.push({:name=>"Approval - Not Required"   , :value=>"Approval - Not Required"     })
        
        return dd_options
        
    end 
    
    def status_of_bug_dd
        
        bug_dd = Array.new
        
        bug_dd.push({:name=>"New"       ,:value=>"New"      })
        bug_dd.push({:name=>"Open"      ,:value=>"Open"     })
        bug_dd.push({:name=>"Test"      ,:value=>"Test"     })
        bug_dd.push({:name=>"Verified"  ,:value=>"Verified" })
        bug_dd.push({:name=>"Deferred"  ,:value=>"Deferred" })
        bug_dd.push({:name=>"Reopened"  ,:value=>"Reopened" }) 
        bug_dd.push({:name=>"Duplicate" ,:value=>"Duplicate"}) 
        bug_dd.push({:name=>"Rejected"  ,:value=>"Rejected" })
        bug_dd.push({:name=>"Closed"    ,:value=>"Closed"   })
        
        return bug_dd
        
    end
    
    def systems_dd
        
        return $tables.attach("ATHENA_PROJECT_SYSTEMS").dd_choices(
            "system_name",
            "primary_id",
            " ORDER BY system_name ASC "
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def fill_select_option_project_id(field_name, field_value, pid)
        
        output      = String.new
        record      = pid.empty? ? $tables.attach("ATHENA_PROJECT_BUGS").new_row : $tables.attach("ATHENA_PROJECT_BUGS").by_primary_id(pid)
        
        record.fields["project_id"].web.select_replacement(
            {
                :dd_choices     => existing_projects_dd(system_id = field_value)
            },
            true
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            div.ATHENA_PROJECT_SYSTEMS__system_name         {margin-bottom: 2px;}
            div.ATHENA_PROJECT_SYSTEMS__owner_team_id       {margin-bottom: 2px;}
            
            div.ATHENA_PROJECT_SYSTEMS__system_name         label{display: inline-block; width: 120px;}
            div.ATHENA_PROJECT_SYSTEMS__owner_team_id       label{display: inline-block; width: 120px;}
            
            div.ATHENA_PROJECT_SYSTEMS__system_name         input{width: 235px;}
            
            
            div.ATHENA_PROJECT__project_name                {margin-bottom: 2px;}
            div.ATHENA_PROJECT__brief_description           {margin-bottom: 2px;}
            div.ATHENA_PROJECT__requested_priority_level    {margin-bottom: 2px;}
            div.ATHENA_PROJECT__requested_completion_date   {margin-bottom: 2px;}
            
            div.ATHENA_PROJECT__project_name                label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT__brief_description           label{display: inline-block; width: 130px; vertical-align: top;}
            div.ATHENA_PROJECT__requested_priority_level    label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT__requested_completion_date   label{display: inline-block; width: 130px;}
            
            div.ATHENA_PROJECT__project_name                input{width: 350px;}
            div.ATHENA_PROJECT__brief_description        textarea{width: 350px; overflow-y: scroll; resize: none;}
            
            div.ATHENA_PROJECT__feature_requested                               { min-width:160px; }
            div.ATHENA_PROJECT__requester_team_id                               { min-width:150px; }
            div.ATHENA_PROJECT__project_module                          textarea{ width:200px; resize:none;}
            
            
            div.ATHENA_PROJECT_REQUIREMENTS__requirement    textarea{width: 500px; height: 200px; resize: none; overflow-y: scroll;}
            
            div.ATHENA_PROJECT_REQUIREMENTS__automated_process                       {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__automated_process                  label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__automated_process                  input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__pdf_template                            {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__pdf_template                       label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__pdf_template                       input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__process_improvement                     {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__process_improvement                label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__process_improvement                input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__report                                  {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__report                             label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__report                             input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__system_interface                        {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__system_interface                   label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__system_interface                   input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__user_interface                          {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__user_interface                     label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__user_interface                     input{width: 25px;}
            div.ATHENA_PROJECT_REQUIREMENTS__change                                  {width: 200px;}
            div.ATHENA_PROJECT_REQUIREMENTS__change                             label{display: inline-block; width: 130px;}
            div.ATHENA_PROJECT_REQUIREMENTS__change                             input{width: 25px;}
            
            div.ATHENA_PROJECT_REQUIREMENTS_SPECS__specification    textarea{width: 500px; height: 200px; resize: none; overflow-y: scroll;}
            
            div.ATHENA_PROJECT_BUGS__system_id          {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__project_id         {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__server             {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__location_found     {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__description        {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__error_message      {margin-bottom: 2px;}
            div.ATHENA_PROJECT_BUGS__notes              {margin-bottom: 2px;}
            
            div.ATHENA_PROJECT_BUGS__system_id          label{display: inline-block; width: 120px;}
            div.ATHENA_PROJECT_BUGS__project_id         label{display: inline-block; width: 120px;}
            div.ATHENA_PROJECT_BUGS__server             label{display: inline-block; width: 120px;}
            div.ATHENA_PROJECT_BUGS__location_found     label{display: inline-block; width: 120px; vertical-align: top;}
            div.ATHENA_PROJECT_BUGS__description        label{display: inline-block; width: 120px; vertical-align: top;}
            div.ATHENA_PROJECT_BUGS__error_message      label{display: inline-block; width: 120px; vertical-align: top;}
            div.ATHENA_PROJECT_BUGS__notes              label{display: inline-block; width: 120px; vertical-align: top;}
            
            div.ATHENA_PROJECT_BUGS__project_id                           select{width: 405px;}
            div.ATHENA_PROJECT_BUGS__location_found                     textarea{width: 400px; resize: none; overflow-y: scroll;}
            div.ATHENA_PROJECT_BUGS__description                        textarea{width: 400px; resize: none; overflow-y: scroll;}
            div.ATHENA_PROJECT_BUGS__error_message                      textarea{width: 400px; resize: none; overflow-y: scroll;}
            div.ATHENA_PROJECT_BUGS__notes                              textarea{width: 400px; resize: none; overflow-y: scroll;}
            
            
            div.ATHENA_PROJECT_FEATURES__brief_description              textarea{ width:500px; resize:none;}
            
            #search_dialog_button{visibility:hidden;}
            div.athena_project_requirements_header                         { margin-bottom:10px; font-size: 1.5em;}
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