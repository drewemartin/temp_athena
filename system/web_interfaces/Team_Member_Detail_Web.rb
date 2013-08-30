#!/usr/local/bin/ruby

class TEAM_MEMBER_DETAIL_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        directors   = $team.directors || []
        @director   = directors.include?($team_member.primary_id.value)
        @supervisor = ($team_member.primary_id.value == $focus_team_member.supervisor_team_id.value)
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Detail Record"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
    end
    
    def response
        
        #right_groups_changed = nil
        #right_groups = [
        #    
        #    "super_user_access"
        #    
        #]
        #right_groups.each{|right_group|
        #    
        #    right_groups_changed = true if $kit.field_changed?(
        #        :table_name => "TEAM_RIGHTS",
        #        :field_name => "super_user_access"
        #    )
        #    
        #}
        #if right_groups_changed
        #    
        #    $kit.modify_tag_content("interface_rights",         interface_rights)
        #    $kit.modify_tag_content("student_record_rights",    student_record_rights)
        #    $kit.modify_tag_content("team_member_record_rights",team_member_record_rights)
        #    
        #end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def team_member_record(tid = $kit.params[:tid])
        
        
        tabs = Array.new
        tabs.push(["Basic Information",     identity                ])
        tabs.push(["Team Assignement",      team_assignment         ])
        tabs.push(["Student Management",    student_management      ])
        tabs.push(["Team Member Students",  team_member_students    ])
        tabs.push(["Team",                  team                    ])
        tabs.push(["Athena Access",         rights                  ])
       
        $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            tab_id          = "details",
            search          = false
        )
        
    end

    def identity
        
        output      = String.new
        
        form_array  = Array.new
        
        section_1 = Array.new
        section_1.push(["Legal First Name"          ,$focus_team_member.legal_first_name.web.text(                    :disabled=>disabled)                                                     ])                          
        section_1.push(["Legal Middle Name"         ,$focus_team_member.legal_middle_name.web.text(                   :disabled=>disabled)                                                    ])               
        section_1.push(["Legal Last Name"           ,$focus_team_member.legal_last_name.web.text(                     :disabled=>disabled)                                                      ])      
        section_1.push(["Suffix"                    ,$focus_team_member.suffix.web.text(                              :disabled=>disabled)                                                               ])                  
        section_1.push(["Also Known As"             ,$focus_team_member.aka.web.text(                                 :disabled=>disabled)                                                                  ])         
        section_1.push(["PPID"                      ,$focus_team_member.ppid.web.text(                                :disabled=>disabled)                                                                 ])    
        section_1.push(["Social Security Number"    ,$focus_team_member.ssn.web.text(                                 :disabled=>disabled)                                                                  ])
        section_1.push(["Date of Birth"             ,$focus_team_member.dob.web.default(                              :disabled=>disabled)                                                               ])
        section_1.push(["Gender"                    ,$focus_team_member.gender.web.select(:dd_choices=>$kit.dd.gender,:disabled=>disabled)                                ])
        form_array.push(
            "Identity",
            [
                $tools.table(
                    :table_array    => section_1,
                    :unique_name    => "team_member_identity",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
            ]
        )
        
        output << $tools.table(
            :table_array    => form_array,
            :unique_name    => "team_member_detail_record",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return output
        
    end
    
    def rights
        
        $focus_team_member.rights.existing_record || $focus_team_member.rights.new_record.save
        
        tables_array = [
            [
                "<div id='right_groups'             >#{right_groups}                </div>"
            ],
            [
                "<div id='interface_rights'         >#{interface_rights}            </div>"
            ],
            [
                "<div id='student_record_rights'    >#{student_record_rights}       </div>"
            ],
            [
                "<div id='team_member_record_rights'>#{team_member_record_rights}   </div>"
            ],
            [
                "<div id='live_reports_rights'      >#{live_reports_rights}</div>"
            ]
        ]
        
        return $tools.table(
            :table_array    => tables_array,
            :unique_name    => "user_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
    end
    
    def student_management
        
        if department_record = $focus_team_member.department_record
            department_category = department_record.fields["type"].value
        else
            return false
        end
        
        if department_category == "Academic"
            
            eval_eligible_header    = "Eval Eligible (Academic)"
            
        elsif department_category == "Engagement"
            
            eval_eligible_header    = "Eval Eligible (Engagement)"
            
        end
        
        tables_array     = Array.new
        
        tables_array.push(
            
            [
                
                #HEADERS
                "Student ID",               
                "First Name",               
                "Last Name",
                "Grade",
                "Role",                     
                "Role Details",             
                "Active Relationship?",
                "Currently Enrolled?",
                eval_eligible_header
             
            ]
            
        )
        
        pids = Array.new
        relate_records = $focus_team_member.sams_ids.existing_records
        relate_records.each{|record|
            
            these_pids = $tables.attach("STUDENT_RELATE").primary_ids(
                "WHERE staff_id = '#{record.fields["sams_id"].value}'"
            )
            
            if these_pids
                pids.concat(these_pids)
            end
            
        }
        
        pids.each{|pid|
            
            r = $tables.attach("STUDENT_RELATE").by_primary_id(pid)
            s = $students.get(r.fields["studentid"].value)
            
            if s
                
                if department_category == "Academic"
                    
                    eval_eligible_value     = r.fields["eval_eligible_academic"  ].web.checkbox(:disabled=>disabled)
                    
                elsif department_category == "Engagement"
                    
                    tot_fcs_assigned        = $tables.attach("STUDENT_RELATE").primary_ids("WHERE studentid = '#{s.student_id.value}' AND role = 'Family Teacher Coach'")
                    eval_eligible_value     = r.fields["eval_eligible_engagement"].web.checkbox(
                        :label_option   => tot_fcs_assigned ? "(#{tot_fcs_assigned.length})" : "",
                        :disabled       => disabled
                    )
                    
                end
                
                tables_array.push(
                    
                    [
                     
                        s.student_id.value                               ,
                        s.studentfirstname.value                         ,
                        s.studentlastname.value                          ,
                        s.grade.value                                    ,
                        r.fields["role"                    ].value       ,
                        r.fields["role_details"            ].value       ,
                        r.fields["active"                  ].to_user     ,
                        (s.currently_enrolled? ? "Yes" : "No"           ),
                        eval_eligible_value
                      
                    ]
                    
                )
                
            end
            
        } if pids
        
        return $tools.data_table(tables_array, "my_students")
        
    end
    
    def team_member_students
        
        $focus_team_member.expand_mystudents_enrolled
        
    end

    def team
        
        tables_array = [
            
            #HEADERS
            [
                #BASIC INFORMATION
                "Team Member ID"                        ,
                "Last Name"                             ,
                "First Name"                            ,
                "Birthday"                              ,
                "Position"                              , 
                "Department"                            ,
                "Department Category"                   ,
                "Department Focus"                      ,
                "Supervisor"                            ,
                "Peer Group"                            ,
                
                #EVALUATION SUMMARY
                "Current Students"                      ,
                "All Students"                          ,
                "New Students"                          ,
                "In Year Enrolled"                      ,
                "Low Income"                            ,
                "Tier 2 or 3"                           ,
                "Special Ed"                            ,
                "Grades 7-12"                           ,
                "Scantron Fall Participation"           ,
                "Scantron Spring Participation"         ,
                "Scantron Growth Overall"               ,
                "Scantron Growth Math"                  ,
                "Scantron Growth Reading"               ,
                "AIMS Fall Participation"               ,
                "AIMS Spring Participation"             ,
                "AIMS Growth Overall"                   ,
                "SI Participation"                      ,
                "SI Participation Tier 2 or 3"          ,
                "SI Blue Ribbon"                        ,
                "SI Blue Ribbon Tier 2 or 3"            ,
                "Define U Participation"                ,
                "PSSA Participation"                    ,
                "Keystone Participation"                ,
                "Attendance Rate"                       ,
                "Retention Rate"                        ,
                "Engagement Level"                      ,
                "Course Passing Rate"                   
               
            ]
            
        ]
        
        tables_array[0] = tables_array[0] + 
        [
         
            #ACADEMIC
            "Assessment Performance"                        ,
            "Assessment Performance Attainable"             ,
            "Assessment Participation Fall"                 ,
            "Assessment Participation Fall Attainable"      ,
            "Assessment Participation Spring"               ,
            "Assessment Participation Spring Attainable"    ,  
            "Course Passing Rate"                           , 
            "Course Passing Rate Attainable"                ,
            "Study Island Participation"                    ,
            "Study Island participation Attainable"         ,
            "Study Island Achievement"                      ,
            "Study Island Achievement Attainable"           ,
            
            #ENGAGEMENT
            "Scantron Participation Fall"                   ,
            "Scantron Participation Attainable Fall"        ,
            "Scantron Participation Spring"                 ,
            "Scantron Participation Attainable Spring"      ,
            "Attendance"                                    ,
            "Attendance Attainable"                         ,
            "Truancy Prevention"                            ,
            "Truancy Prevention Attainable"                 ,
            "Evaluation Participation"                      ,
            "Evaluation Participation Attainable"           ,
            "Keystone Participation"                        ,
            "Keystone Participation Attainable"             ,
            "PSSA Participation"                            ,
            "PSSA Participation Attainable"                 ,
            "Quality Documentation"                         ,
            "Feedback"
        ]
        
        supervisor_of = $focus_team_member.supervisor_of
        supervisor_of.each{|team_id|
            
            t = $team.get(team_id)
            row = Array.new
            
            #BASIC INFORMATION
            row.push(t.primary_id.value                                                               ) 
            row.push(t.legal_last_name.value                                                          ) 
            row.push(t.legal_first_name.value                                                         ) 
            row.push(t.dob.value                                                                      )
            
            row.push(t.employee_type.value                                                            )                                                               
            row.push(t.department_id.value                                                            )     
            row.push(t.department_category.value                                                      )
            row.push(t.department_focus.value                                                         )
            
            row.push(t.supervisor_team_id.to_name(options=:full_name)                                 )
            row.push(t.peer_group_id.web.select(:disabled=>true,:dd_choices=>$kit.dd.peer_group_id )  )
            
            #EVALUATION SUMMARY
            eval_exists = t.evaluation_summary.existing_record
            row.push(eval_exists ? t.evaluation_summary.students.value                           : "" )
            row.push(eval_exists ? t.evaluation_summary.all_students.value                       : "" )
            row.push(eval_exists ? t.evaluation_summary.new.value                                : "" )
            row.push(eval_exists ? t.evaluation_summary.in_year.value                            : "" )
            row.push(eval_exists ? t.evaluation_summary.low_income.value                         : "" )
            row.push(eval_exists ? t.evaluation_summary.tier_23.value                            : "" )
            row.push(eval_exists ? t.evaluation_summary.special_ed.value                         : "" )
            row.push(eval_exists ? t.evaluation_summary.grades_712.value                         : "" ) 
            row.push(eval_exists ? t.evaluation_summary.scantron_participation_fall.value        : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_participation_spring.value      : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_overall.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_math.value               : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_reading.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_participation_fall.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_participation_spring.value          : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_growth_overall.value                : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_participation.value         : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_participation_tier_23.value : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_achievement.value           : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_achievement_tier_23.value   : "" )
            row.push(eval_exists ? t.evaluation_summary.define_u_participation.value             : "" )
            row.push(eval_exists ? t.evaluation_summary.pssa_participation.value                 : "" )
            row.push(eval_exists ? t.evaluation_summary.keystone_participation.value             : "" )
            row.push(eval_exists ? t.evaluation_summary.attendance_rate.value                    : "" )
            row.push(eval_exists ? t.evaluation_summary.retention_rate.value                     : "" )
            row.push(eval_exists ? t.evaluation_summary.engagement_level.value                   : "" )             
            row.push(eval_exists ? t.evaluation_summary.course_passing_rate.value                : "" )             
            
            #EVALUATION METRICS
            eval_exists = t.evaluation_academic_metrics.existing_record
            blank = t.department_category.value == "Engagement"
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_performance.value                           : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_performance_attainable.value                : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_fall.value                    : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_fall_attainable.value         : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_spring.value                  : "" ) 
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_spring_attainable.value       : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.course_passing_rate.value                              : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.course_passing_rate_attainable.value                   : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_participation.value                       : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_participation_attainable.value            : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_achievement.value                         : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_achievement_attainable.value              : "" )                   
            
            eval_exists = t.evaluation_engagement_metrics.existing_record
            blank = t.department_category.value == "Academic"
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_fall.value                    : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_fall_attainable.value         : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_spring.value                  : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_spring_attainable.value       : "" ) 
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.attendance.value                                     : "" )       
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.attendance_attainable.value                          : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.truancy_prevention.value                             : "" )       
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.truancy_prevention_attainable.value                  : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.evaluation_participation.value                       : "" )      
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.evaluation_participation_attainable.value            : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.keystone_participation.value                         : "" )     
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.keystone_participation_attainable.value              : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.pssa_participation.value                             : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.pssa_participation_attainable.value                  : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.quality_documentation.value                          : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.feedback.value                                       : "" )    
            
            tables_array.push(row)
            
        } if supervisor_of
        
        return $kit.tools.data_table(tables_array, "my_team")
        
    end

    def team_assignment
        
        output      = String.new
        
        form_array  = Array.new
        
        table_array = Array.new
        
        table_array.push(["Active?"                   ,$focus_team_member.active.web.checkbox(                                                      :disabled=>!$team_member.super_user?)])
        table_array.push(["Position"                  ,$focus_team_member.employee_type.web.select(:dd_choices=>$kit.dd.positions,                  :disabled=>disabled)])
        table_array.push(["Title"                     ,$focus_team_member.title.web.text(                                                           :disabled=>disabled)])
        table_array.push(["Department"                ,$focus_team_member.department_id.web.select(:dd_choices=>$kit.dd.departments,                :disabled=>disabled)])                          
        table_array.push(["Department Category"       ,$focus_team_member.department_category.web.select(:dd_choices=>$kit.dd.department_categories,:disabled=>disabled)])               
        table_array.push(["Department Focus"          ,$focus_team_member.department_focus.web.select(:dd_choices=>$kit.dd.department_focus,        :disabled=>disabled)])                        
        table_array.push(["Supervisor"                ,$focus_team_member.supervisor_team_id.web.select(:dd_choices=>$kit.dd.team_members,          :disabled=>disabled)])         
        table_array.push(["Peer Group"                ,$focus_team_member.peer_group_id.web.select(                                                 :disabled=>true,:dd_choices=>$kit.dd.peer_group_id)])    
        
        table_array.push(
            [
                "Region",
                $focus_team_member.region.web.select(
                    :disabled   => true,
                    :dd_choices => $dd.from_array(
                        [
                            "Central",
                            "Greater Philadelphia",
                            "Joshua Smith",
                            "Northeast",
                            "Southeast",
                            "Western"
                        ]
                    )
                )
            ]
        )    
        
        form_array.push(
            "Team Information",
            [
                $tools.table(
                    :table_array    => table_array,
                    :unique_name    => "team_member_team_info",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
            ]
        ) 
        
        output << $tools.table(
            :table_array    => form_array,
            :unique_name    => "team_member_detail_record",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return output
        
    end
    

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def right_groups
        
        table_array = [
            
            [
                $focus_team_member.rights.super_user_group.web.checkbox(
                    :label_option   => "Super User",
                    :disabled       => disabled("super_user_group")
                )
            ],
            [
                $focus_team_member.rights.student_search.web.checkbox(
                    :label_option   => "Search All Students",
                    :disabled       => disabled("student_search")
                )
            ],
            [
                $focus_team_member.rights.team_search.web.checkbox(
                    :label_option   => "Search All Team Members",
                    :disabled       => disabled("team_search")
                )
            ]
            
        ]
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "Admin Rights"
        )
        
    end
    
    def interface_rights
        
        table_array = [
            
            [
                (
                    this_field = $focus_team_member.rights.athena_projects_access
                    this_field.web.checkbox(
                        :label_option   => "Athena Projects",
                        :disabled       => disabled("athena_projects_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.attendance_admin_access
                    this_field.web.checkbox(
                        :label_option   => "Attendance Admin",
                        :disabled       => disabled("attendance_admin_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.course_relate_access
                    this_field.web.checkbox(
                        :label_option   => "Course Relate",
                        :disabled       => disabled("course_relate_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.districts_access
                    this_field.web.checkbox(
                        :label_option   => "Districts",
                        :disabled       => disabled("districts_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.enrollment_reports_access
                    this_field.web.checkbox(
                        :label_option   => "Enrollment Reports",
                        :disabled       => disabled("enrollment_reports_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.login_reminders_reports_access
                    this_field.web.checkbox(
                        :label_option   => "Login Reminders Reports",
                        :disabled       => disabled("login_reminders_reports_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.k12_reports_access
                    this_field.web.checkbox(
                        :label_option   => "K12 Reports",
                        :disabled       => disabled("k12_reports_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.live_reports_access
                    this_field.web.checkbox(
                        :label_option   => "Live Reports",
                        :disabled       => disabled("live_reports_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.kmail_access
                    this_field.web.checkbox(
                        :label_option   => "Mass Kmail",
                        :disabled       => disabled("kmail_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.rtii_behavior_vault_access
                    this_field.web.checkbox(
                        :label_option   => "RTII Vault",
                        :disabled       => disabled("rtii_behavior_vault_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.sapphire_data_management_access
                    this_field.web.checkbox(
                        :label_option   => "Sapphire Data Management",
                        :disabled       => disabled("sapphire_data_management_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.test_event_admin_access
                    this_field.web.checkbox(
                        :label_option   => "Test Event Site Admin",
                        :disabled       => disabled("test_event_admin_access")
                    )
                )
            ],
            [
                (
                    this_field = $focus_team_member.rights.withdrawal_processing_access
                    this_field.web.checkbox(
                        :label_option   => "Withdrawal Processing",
                        :disabled       => disabled("withdrawal_processing_access")
                    )
                )
            ]
            
        ]
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "Modules"
        )
        
    end
    
    def live_reports_rights
        
        table_array = [
            
            [$focus_team_member.rights.live_reports_athena_project.web.checkbox(                        :label_option=>"Athena Projects",                       :disabled=>disabled("live_reports_athena_project"))                     ],
            [$focus_team_member.rights.live_reports_attendance_code_stats.web.checkbox(                 :label_option=>"Attendance Code Stats",                 :disabled=>disabled("live_reports_attendance_code_stats"))              ],
            [$focus_team_member.rights.live_reports_ink_orders.web.checkbox(                            :label_option=>"Ink Orders",                            :disabled=>disabled("live_reports_ink_orders"))                         ],
            [$focus_team_member.rights.live_reports_student_attendance_ap.web.checkbox(                 :label_option=>"Student Attendance AP",                 :disabled=>disabled("live_reports_student_attendance_ap"))              ],
            [$focus_team_member.rights.live_reports_student_contacts.web.checkbox(                      :label_option=>"Student Contacts",                      :disabled=>disabled("live_reports_student_contacts"))                   ],
            [$focus_team_member.rights.live_reports_my_students_general.web.checkbox(                   :label_option=>"My Students General",                   :disabled=>disabled("live_reports_my_students_general"))                ],
            [$focus_team_member.rights.live_reports_student_rtii_behavior.web.checkbox(                 :label_option=>"Student RTII Behavior",                 :disabled=>disabled("live_reports_student_rtii_behavior"))              ],
            [$focus_team_member.rights.live_reports_student_scantron_participation.web.checkbox(        :label_option=>"Student Scantron Participation",        :disabled=>disabled("live_reports_student_scantron_participation"))     ],
            [$focus_team_member.rights.live_reports_student_testing_events_attendance.web.checkbox(     :label_option=>"Student Testing Events - Attendance",   :disabled=>disabled("live_reports_student_testing_events_attendance"))  ],
            [$focus_team_member.rights.live_reports_student_testing_events_tests.web.checkbox(          :label_option=>"Student Testing Events - Tests",        :disabled=>disabled("live_reports_student_testing_events_tests"))       ],
            [$focus_team_member.rights.live_reports_team_member_evaluations_academic.web.checkbox(      :label_option=>"Team Member Evaluations - Academic",    :disabled=>disabled("live_reports_team_member_evaluations_academic"))   ],
            [$focus_team_member.rights.live_reports_team_member_evaluations_engagement.web.checkbox(    :label_option=>"Team Member Evaluations - Engagement",  :disabled=>disabled("live_reports_team_member_evaluations_engagement")) ],
            [$focus_team_member.rights.live_reports_transcripts_received.web.checkbox(                  :label_option=>"Transcripts Received",                  :disabled=>disabled("live_reports_transcripts_received"))               ]
            
        ]
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "Live Reports"
        )
        
    end
    
    def student_record_rights
        
        student_attendance_ap = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_attendance_ap_edit.web.checkbox( :label_option=>"Edit", :disabled=>disabled("student_attendance_ap_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_attendance_ap.web.checkbox( :label_option=>"Attendance AP Module",    :disabled=>disabled("module_student_attendance_ap"))}"
        )
        student_contacts = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_contacts_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_contacts_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_contacts.web.checkbox( :label_option=>"Contacts Module",    :disabled=>disabled("module_student_contacts"))}"
        )
        student_ilp = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_ilp_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_ilp_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_ilp.web.checkbox( :label_option=>"Individual Learning Plan",    :disabled=>disabled("module_student_ilp"))}"
        )
        student_psych = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_psychological_evaluation_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_psychological_evaluation_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_psychological_evaluation.web.checkbox( :label_option=>"Psychological Evaluation",    :disabled=>disabled("module_student_psychological_evaluation"))}"
        )
        student_rtii = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_rtii_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_rtii_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_rtii.web.checkbox( :label_option=>"RTII Behavior Module",    :disabled=>disabled("module_student_rtii"))}"
        )
        tep_agreements = $tools.table(
            :table_array    => [
                $focus_team_member.rights.tep_agreements_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("tep_agreements_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_tep_agreements.web.checkbox( :label_option=>"TEP Agreements Module",    :disabled=>disabled("module_tep_agreements"))}"
        )
        withdraw_requests = $tools.table(
            :table_array    => [
                $focus_team_member.rights.withdraw_requests_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("withdraw_requests_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_withdraw_requests.web.checkbox( :label_option=>"Withdrawal Requests Module",    :disabled=>disabled("module_withdraw_requests"))}"
        )
        ink_orders = $tools.table(
            :table_array    => [
                $focus_team_member.rights.ink_orders_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("ink_orders_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_ink_orders.web.checkbox( :label_option=>"Ink Orders Module",    :disabled=>disabled("module_ink_orders"))}"
        )
        pssa_entry = $tools.table(
            :table_array    => [
                $focus_team_member.rights.pssa_entry_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("pssa_entry_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_pssa_entry.web.checkbox( :label_option=>"PSSA Records Module",    :disabled=>disabled("module_pssa_entry"))}"
        )
        record_requests = $tools.table(
            :table_array    => [
                $focus_team_member.rights.record_requests_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("record_requests_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_record_requests.web.checkbox( :label_option=>"Record Requests Module",    :disabled=>disabled("module_record_requests"))}"
        )
        dnc_students = $tools.table(
            :table_array    => [
                $focus_team_member.rights.dnc_students_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("dnc_students_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_dnc_students.web.checkbox( :label_option=>"DNC Requests Module",    :disabled=>disabled("module_dnc_students"))}"
        )
        student_attendance = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_attendance_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_attendance_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_attendance.web.checkbox( :label_option=>"Student Attendance Module",    :disabled=>disabled("module_student_attendance"))}"
        )
        student_tests = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_tests_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_tests_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_tests.web.checkbox( :label_option=>"Student Tests Module",    :disabled=>disabled("module_student_tests"))}"
        )
        student_specialists = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_specialists_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_specialists_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_specialists.web.checkbox( :label_option=>"Student Specialists Module",    :disabled=>disabled("module_student_specialists"))}"
        )
        student_assessments = $tools.table(
            :table_array    => [
                $focus_team_member.rights.student_specialists_edit.web.checkbox( :label_option=>"Edit",                         :disabled=>disabled("student_specialists_edit"))    
            ],
            :unique_name    => "module_rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "#{$focus_team_member.rights.module_student_assessments.web.checkbox( :label_option=>"Student Assessments Module",    :disabled=>disabled("module_student_assessments"))}"
        )
        table_array = [
            
            [student_attendance_ap],
            [student_contacts],
            [dnc_students],
            [student_ilp],
            [ink_orders],
            [student_psych],
            [pssa_entry],
            [student_assessments],
            [student_attendance],
            [student_specialists],
            [student_tests],
            [record_requests],
            [student_rtii],
            [tep_agreements],
            [withdraw_requests]
            
        ] 
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "Students"
        )
        
    end
    
    def team_member_record_rights
        
        table_array = [
            
            [blank]
            
        ]
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "rights",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "Team Members"
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def add_new_pdf_evaluation_document(tid)
        
        require "#{$paths.templates_path}pdf_templates/EVALUATION_PDF_ELEMENTARY.rb"
        template = EVALUATION_PDF_ELEMENTARY.new
        return template.generate_pdf(tid, pdf = nil)
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________UPLOAD_PDF_FORMS
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
    
    def score_dd(values=[unsatisfactory="10",progressing="20",proficient="30",distinguished="40"])
        
        return [
            {:name=>"Unsatisfactory (#{values[0]})" , :value=>values[0] },
            {:name=>"Progressing (#{values[1]})"    , :value=>values[1] },
            {:name=>"Proficient (#{values[2]})"     , :value=>values[2] },
            {:name=>"Distinguished (#{values[3]})"  , :value=>values[3] }
        ]
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
   
    def blank
        "<div style='color:#F2F5F7;'>test</div>"
    end
    
    def disabled(rights_name = nil)
        
        if @director
            
            return false
            
        elsif @supervisor && rights_name
            
            return ($team_member.rights.send(rights_name).is_true? ? false : true)
            
        elsif @supervisor
            
            return false
            
        else
            
            return true
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "div#tabs_details .ui-tabs-nav {
            font-size: x-small;
        }"
        output << "table#team_member_detail_record {
            width:100%;
   
        }"
        output << "table#team_member_detail_record         input{ width:300px;  }"
        output << "table#team_member_detail_record        select{ width:300px;  }"
        
        output << "table#team_member_identity{
                width       : 65%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#team_member_identity                     td{ width:50%;                                          }"
            output << "table#team_member_identity            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#team_member_identity            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#team_member_identity            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#team_member_identity            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#team_member_identity             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#team_member_identity            td.even_row{ vertical-align:middle;                              }"
            output << "table#team_member_identity                     th{ width:300px; border-bottom: 1px solid #000000;      }"
        
        output << "table#team_member_team_info{
                width       : 65%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#team_member_team_info                     td{ width:50%;                                          }"
            output << "table#team_member_team_info            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#team_member_team_info            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#team_member_team_info            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#team_member_team_info            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#team_member_team_info             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#team_member_team_info            td.even_row{ vertical-align:middle;                              }"
            output << "table#team_member_team_info                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "table#user_rights{
            width       : 100%;
            font-size   : x-small;
            text-align  : center;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#user_rights     td{ width:250px;}"
        
        output << "table#rights{
            width       : 100%;
            height      : 100%;
            font-size   : small;
            text-align  : left;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#rights caption{ font-size: medium; text-align:left;}"
        output << "table#rights      td{ height:30px; padding-left:20px;}"
        output << "table#rights     div{ float:left; width:100%; margin-bottom:2px;}"
        output << "table#rights   input{ float:left;}"
        output << "table#rights   label{ width:90%; display:inline-block;}"
        
        output << "table#module_rights{
            height      : 100%;
            font-size   : x-small;
            text-align  : left;
        }"
        output << "table#module_rights caption{ font-size: small; text-align:left;}"
        output << "table#module_rights      td{ padding-left:20px; height:30px;}"
        output << "table#module_rights     div{ float:left; width:100%; margin-bottom:2px;}"
        output << "table#module_rights   input{ float:left;}"
        output << "table#module_rights   label{ width:90%; display:inline-block;}"
        
        output << "table.dataTable {text-align: center;}"
        
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