#!/usr/local/bin/ruby


class TEAM_MEMBER_EVALUATIONS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
       
        @temporary_summary_editors = ["jgowman@agora.org","esaddler@agora.org","jhalverson@agora.org"]
        
        if $focus_team_member
            
            $focus_team_member.evaluation_summary.existing_record || $focus_team_member.evaluation_summary.new_record
            
        end
        
        if !$kit.params[:date_selected] || $kit.params[:date_selected].empty?
            
            @snapshot_date  = false
            @disabled       = false
            
        else
            
            @snapshot_date  = $kit.params[:date_selected]
            @disabled       = true
            
        end   
      
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        selected_value      = @snapshot_date || "Live Record"
        snapshot_period_dd  = $field.new("value"=>selected_value).web.select(
            :dd_choices     => eval_dates_dd,
            :field_id       => "date_selected",
            :field_name     => "date_selected",
            :onchange       => "send('date_selected,tid')",
            :add_class      => "no_save",
            :select_on_name => true,
            :no_null        => true
            
        )
        
        document_id = "team_._#{$focus_team_member.primary_id.value}_._Evaluations_._TEAMID_#{$focus_team_member.primary_id.value}_EVALUATION_TIMESTAMP.pdf"
        create_pdf  = $tools.button_view_pdf(   "evaluation_document",  document_id, additional_params_str = $focus_team_member.primary_id.value, ["tid"])
        upload_pdf  = $tools.button_upload_doc( "evaluation_document",  "tid")
        
        if $focus_team_member.department_category.value == "Engagement"
            "#{create_pdf}#{upload_pdf}#{snapshot_period_dd}Evaluation"
        else
            "#{create_pdf}#{upload_pdf}#{snapshot_period_dd}Evaluation"
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
    end
    
    def response
        
        #if field_changed = $kit.fields.inspect.match(/TEAM_EVALUATION_ENGAGEMENT_METRICS__feedback|TEAM_EVALUATION_ENGAGEMENT_METRICS__quality_documentation/)
        #    
        #    case field_changed.to_s
        #    when "TEAM_EVALUATION_ENGAGEMENT_METRICS__feedback"
        #        
        #        if !$kit.rows.values[0].fields["feedback"].mathable.between?(0,5)
        #            record = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS").by_primary_id($kit.rows.values[0].fields["primary_id"].value)
        #            record.fields["feedback"].value = nil
        #            record.save
        #            $kit.web_error.invalid_entry(
        #                :value_entered =>$kit.rows.values[0].fields["feedback"].value,
        #                :error_details =>"Please enter a number between 0-5 for `Family and Peer Feedback`"
        #            )
        #        end
        #        
        #    when "TEAM_EVALUATION_ENGAGEMENT_METRICS__quality_documentation"
        #      
        #        if !$kit.rows.values[0].fields["quality_documentation"].mathable.between?(0,10)
        #            record = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS").by_primary_id($kit.rows.values[0].fields["primary_id"].value)
        #            record.fields["score"                   ].set(nil).save
        #            record.fields["quality_documentation"   ].set(nil).save
        #            $kit.web_error.invalid_entry(
        #                :value_entered =>$kit.rows.values[0].fields["quality_documentation"].value,
        #                :error_details =>"Please enter a number between 0-10 for `Quality Documentation`"
        #            )
        #        end
        #        
        #    end
        #    
        #    $kit.modify_tag_content("tabs-3", engagement_metrics, "update")
        #    
        #end
        
        #$kit.modify_tag_content("tabs-3", engagement_metrics, "update")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def team_member_record(tid = $kit.params[:tid])
        
        if $focus_team_member.department_record && (eval_type = $focus_team_member.department_record.fields["type"].value)
            
            tabs = Array.new
            tabs.push(["Summary",           evaluation_summary  ])
            tabs.push(["Goals",             evaluation_goals    ])
            
            if eval_type == "Engagement"
                
                tabs.push(["Metrics",           engagement_metrics           ]) 
                tabs.push(["Observation",       engagement_observation       ])
                tabs.push(["Professionalism",   engagement_professionalism   ])
                
            elsif eval_type == "Academic"
                
                tabs.push(["Metrics",           academic_metrics           ]) 
                tabs.push(["Instruction",       academic_instruction       ])
                tabs.push(["Professionalism",   academic_professionalism   ])
                
            end
            
            tabs.push(["Above & Beyond",    evaluation_above_and_beyond             ])
            tabs.push(["Uploads",           evaluation_uploads(tid)                 ])
            tabs.push(["Students Included", evaluation_summary_snapshot_includes    ]) if @snapshot_date
            
            $kit.tools.tabs(
                tabs,
                selected_tab    = 0,
                tab_id          = "evaluation",
                search          = false
            )
            
        else
            
            "#{$focus_team_member.legal_first_name.value} must be assigned to a department before you can use this feature."
            
        end
        
    end
    
    def academic_instruction
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_academic_instruction_snapshot.by_snapshot_date(@snapshot_date)
            instruction = $focus_team_member.evaluation_academic_instruction_snapshot
            
        else
            
            $focus_team_member.evaluation_academic_instruction.existing_record || $focus_team_member.evaluation_academic_instruction.new_record.save
            instruction = $focus_team_member.evaluation_academic_instruction
            
        end      
        
        tables_array.push(["Comprehensive observations" ,instruction.source_comprehensive_observation.web.default(:disabled=>@disabled)     ])                   
        tables_array.push(["Lesson recordings"          ,instruction.source_lesson_recordings.web.default(:disabled=>@disabled)             ])                 
        tables_array.push(["Unannounced observations"   ,instruction.source_unannounced_observation.web.default(:disabled=>@disabled)       ])                        
        tables_array.push(["Score"                      ,instruction.score.web.select(:disabled=>@disabled, :dd_choices=>score_dd(values=[unsatisfactory="10.00",progressing="20.00",proficient="30.00",distinguished="40.00"]))])                        
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "academic_instruction",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                instruction.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Teacher Comments" ),
                instruction.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments"  )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end

    def academic_metrics
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_academic_metrics_snapshot.by_snapshot_date(@snapshot_date)
            metrics = $focus_team_member.evaluation_academic_metrics_snapshot
            
        else
            
            $focus_team_member.evaluation_academic_metrics.existing_record || $focus_team_member.evaluation_academic_metrics.new_record.save
            metrics = $focus_team_member.evaluation_academic_metrics
            
        end
        
        tables_array.push(["Category"                                                                      ,"Score"                                                                                                        ]) 
        if $focus_team_member.department_id.value == "5"
            
            role_details = $focus_team_member.role_details
            course_row   = $tables.attach("course_relate").by_course_name(role_details.first) if role_details
            
            if course_row && (course_row.fields["scantron_growth_math"].value == "1" || course_row.fields["scantron_growth_reading"].value == "1")
                
                tables_array.push(["Scantron Performance (English, Math)"                                  ,metrics.assessment_performance.value            ?  metrics.assessment_performance.web.label             : "N/A"])   
                
            else
                
                tables_array.push(["Participation (Science,History,PE)"                                    ,(metrics.assessment_participation_fall.mathable || 0) + (metrics.assessment_participation_spring.mathable || 0)])
                
            end
            
            tables_array.push(["Course Passing Rate (All Subjects)"                                        ,metrics.course_passing_rate.value               ?  metrics.course_passing_rate.web.label                : "N/A"])
            
        else
            
            tables_array.push(["Scantron Performance and AIMSweb Achievement/Growth"                       ,metrics.assessment_performance.value            ?  metrics.assessment_performance.web.label             : "N/A"])   
            tables_array.push(["Benchmark Assessment Completion Fall"                                      ,metrics.assessment_participation_fall.value     ?  metrics.assessment_participation_fall.web.label      : "N/A"])
            tables_array.push(["Benchmark Assessment Completion Spring"                                    ,metrics.assessment_participation_spring.value   ?  metrics.assessment_participation_spring.web.label    : "N/A"])
            
        end
        
        tables_array.push(["Study Island Blue Ribbon Annual Achievement"                                   ,metrics.study_island_achievement.value          ?  metrics.study_island_achievement.web.label           : "N/A"])
        tables_array.push(["Study Island Blue Ribbon Monthly Participation"                                ,metrics.study_island_participation.value        ?  metrics.study_island_participation.web.label         : "N/A"])
        
        tables_array.push(["Total"                                                                         ,metrics.score.value                                          ])
        
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "academic_metrics",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                metrics.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Teacher Comments"     ),
                metrics.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def academic_professionalism
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_academic_professionalism_snapshot.by_snapshot_date(@snapshot_date)
            professionalism = $focus_team_member.evaluation_academic_professionalism_snapshot
            
        else
            
            $focus_team_member.evaluation_academic_professionalism.existing_record || $focus_team_member.evaluation_academic_professionalism.new_record.save
            professionalism = $focus_team_member.evaluation_academic_professionalism
            
        end
        
        tables_array.push(
            [
                "<strong><em>Conduct</em></strong>
                <ul>
                    <li><em>Demonstrates integrity and ethical practices</em></li>
                    <li><em>Advocacy</em></li>
                    <li><em>Decision making</em></li>
                    <li><em>Compliance with school policies and procedures</em></li>
                </ul>",
                professionalism.source_conduct.web.default(:disabled=>@disabled)
            ]
        )         
        tables_array.push(
            [
                "<strong><em>Maintaining accurate records</em></strong>
                <ul>
                    <li><em>Provides timely feedback on work assignments</em></li>
                    <li><em>Enters detailed and appropriate notes in Total View </em></li>
                    <li><em>Updates ILPs for students</em></li>
                </ul>",
                professionalism.source_record_keeping.web.default(:disabled=>@disabled)
            ]
        )              
        tables_array.push(
            [
                "<strong><em>Communicating with Families</em></strong>
                <ul>
                    <li><em>Responds to phone and K-Mail messages within 24 hours</em></li>
                    <li><em>Conference notes and ILPs </em></li>
                </ul>",
                professionalism.source_communication.web.default(:disabled=>@disabled)
            ]
        )              
        tables_array.push(
            [
                "<strong><em>Participating in PLCs and Professional Growth</em></strong>
                <ul>
                    <li><em>Relationships with colleagues</em></li>
                    <li><em>Service to the school</em></li>
                    <li><em>Enhancement of content knowledge and pedagogical skill</em></li>
                </ul>",
                professionalism.source_professional_growth.web.default(:disabled=>@disabled)
            ]
        )                  
        pro_score = professionalism.score.value
        tables_array.push(
            [
                "Total",
                professionalism.score.set(pro_score).web.select(
                    :disabled   =>@disabled,
                    :dd_choices =>score_dd(values=[unsatisfactory="5.00",progressing="10.00",proficient="15.00",distinguished="20.00"])
                )
            ]
        )
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "academic_professionalism",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                professionalism.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Teacher Comments"   ),
                professionalism.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def engagement_metrics
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_engagement_metrics_snapshot.by_snapshot_date(@snapshot_date)
            metrics = $focus_team_member.evaluation_engagement_metrics_snapshot
            
        else
            
            $focus_team_member.evaluation_engagement_metrics.existing_record || $focus_team_member.evaluation_engagement_metrics.new_record.save
            metrics = $focus_team_member.evaluation_engagement_metrics
            
        end
        
        tables_array.push(["Category"                                           ,"Score"                                                                                                    ]) 
        tables_array.push(["Scantron Participation Fall (0-5pts)"               ,metrics.scantron_participation_fall.value      ?  metrics.scantron_participation_fall.web.label    : "N/A" ])   
        tables_array.push(["Scantron Participation Spring (0-5pts)"             ,metrics.scantron_participation_spring.value    ?  metrics.scantron_participation_spring.web.label  : "N/A" ])   
        tables_array.push(["Attendance in Virtual School (0-25pts)"             ,metrics.attendance.value                       ?  metrics.attendance.web.label                     : "N/A" ])              
        tables_array.push(["Dropout/Truancy Prevention (0-10pts)"               ,metrics.truancy_prevention.value               ?  metrics.truancy_prevention.web.label             : "N/A" ])    
        #tables_array.push(["PSSA and Keystone Participation Rate (0-10pts)"    ,metrics.evaluation_participation.value         ?  metrics.evaluation_participation.web.label       : "N/A" ])
        
        tables_array.push(["Keystone Participation Rate (0-5pts)"               ,metrics.keystone_participation.value           ?  metrics.keystone_participation.web.label         : "N/A" ])
        tables_array.push(["PSSA Participation Rate (0-5pts)"                   ,metrics.pssa_participation.value               ?  metrics.pssa_participation.web.label             : "N/A" ])
        
        tables_array.push(["Quality Documentation (0-10pts)"                    ,metrics.quality_documentation.web.text(:disabled=>@disabled) ]) 
        tables_array.push(["Family and Peer Feedback (0-5pts)"                  ,metrics.feedback.web.text(:disabled=>@disabled)              ])
        
        tables_array.push(["Total"                                              ,metrics.score.value                                          ])
        
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "engagement_metrics",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                metrics.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Coach Comments"     ),
                metrics.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def engagement_observation
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_engagement_observation_snapshot.by_snapshot_date(@snapshot_date)
            observation = $focus_team_member.evaluation_engagement_observation_snapshot
            
        else
            
            $focus_team_member.evaluation_engagement_observation.existing_record || $focus_team_member.evaluation_engagement_observation.new_record.save
            observation = $focus_team_member.evaluation_engagement_observation
            
        end
        
        tables_array.push(["Rapport with the family - (leads to trust on the family's behalf)"                      ,observation.rapport.web.default(:disabled=>@disabled)               ])                   
        tables_array.push(["Basic knowledge when responding to questions, responses when information is not known"  ,observation.knowledge.web.default(:disabled=>@disabled)             ])                 
        tables_array.push(["Clear goal of desired outcome of visit or call with student/family"                     ,observation.goal.web.default(:disabled=>@disabled)                  ])                      
        tables_array.push(["Narrative - having a \"big picture\" conversation"                                      ,observation.narrative.web.default(:disabled=>@disabled)             ])                 
        tables_array.push(["Obtaining commitment from the student/family"                                           ,observation.obtaining_commitment.web.default(:disabled=>@disabled)  ])      
        tables_array.push(["Communication level - active listening, genuine interactions"                           ,observation.communication.web.default(:disabled=>@disabled)         ])             
        tables_array.push(["Documentation & Follow up"                                                              ,observation.documentation_followup.web.default(:disabled=>@disabled)])    
        #tables_array.push(["Score"                                                                                  ,observation.score.web.select(:disabled=>@disabled, :dd_choices=>score_dd(values=[unsatisfactory="5.00",progressing="10.00",proficient="15.00",distinguished="20.00"]))])                        
        tables_array.push(
            [
                "Score",
                $focus_team_member.evaluation_engagement_observation.score.web.select(
                    :dd_choices => score_dd(
                        [
                            "5.00"    ,
                            "7.5"     ,
                            "10.00"   ,
                            "12.5"    ,
                            "15.00"   ,
                            "17.5"    ,
                            "20.00"
                        ]
                    )
                )
            ]
        ) 
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "engagement_observation",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                $focus_team_member.evaluation_engagement_observation.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Coach Comments"     ),
                $focus_team_member.evaluation_engagement_observation.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def engagement_professionalism
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_engagement_professionalism_snapshot.by_snapshot_date(@snapshot_date)
            professionalism = $focus_team_member.evaluation_engagement_professionalism_snapshot
            
        else
            
            $focus_team_member.evaluation_engagement_professionalism.existing_record || $focus_team_member.evaluation_engagement_professionalism.new_record.save
            professionalism = $focus_team_member.evaluation_engagement_professionalism
            
        end
        
        tables_array.push(["Addresses parent concerns in a timely manner"                    ,professionalism.source_addresses_concerns.web.default(:disabled=>@disabled)       ])         
        tables_array.push(["Team Collaboration"                                              ,professionalism.source_collaboration.web.default(:disabled=>@disabled)            ])              
        tables_array.push(["Communication is professional(written and verbal)"               ,professionalism.source_communication.web.default(:disabled=>@disabled)            ])              
        tables_array.push(["Execution of engagement efforts"                                 ,professionalism.source_execution.web.default(:disabled=>@disabled)                ])                  
        tables_array.push(["Seeks and participates in individualized Prof Dev opportunities" ,professionalism.source_professional_development.web.default(:disabled=>@disabled) ])  
        tables_array.push(["Is an active and valued contributor in team meetings"            ,professionalism.source_meeting_contributions.web.default(:disabled=>@disabled)    ])      
        tables_array.push(["Timely escalation of engagement issues"                          ,professionalism.source_issue_escalation.web.default(:disabled=>@disabled)         ])           
        tables_array.push(["STI / Level of Engagement marked"                                ,professionalism.source_sti.web.default(:disabled=>@disabled)                      ])                        
        tables_array.push(["Consistently meets established timelines/deadlines"              ,professionalism.source_meets_deadlines.web.default(:disabled=>@disabled)          ])            
        tables_array.push(["Attends required school events"                                  ,professionalism.source_attends_events.web.default(:disabled=>@disabled)           ])
        pro_score = professionalism.score.value
        pro_score = pro_score.split(".")[0] if pro_score
        tables_array.push(["Total (0-10pts)"                                                 ,professionalism.score.set(pro_score).web.select(:disabled=>@disabled, :dd_choices=>$dd.range(0, 10)    )])
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "engagement_professionalism",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                professionalism.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Coach Comments"     ),
                professionalism.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def evaluation_above_and_beyond
        
        #ABOVE AND BEYOND
        if @snapshot_date
            
            $focus_team_member.evaluation_aab_snapshot.by_snapshot_date(@snapshot_date)
            aab = $focus_team_member.evaluation_aab_snapshot
            
        else
            
            $focus_team_member.evaluation_aab.existing_record || $focus_team_member.evaluation_aab.new_record.save
            aab = $focus_team_member.evaluation_aab
            
        end
        
        tables_array = Array.new
        tables_array.push(["Mentoring"                                  , aab.source_mentoring.web.default()                ])     
        tables_array.push(["Recruiting Team"                            , aab.source_recruitment_team.web.default()         ])  
        tables_array.push(["Committee Work"                             , aab.source_committee.web.default()                ])         
        tables_array.push(["Testing"                                    , aab.source_testing.web.default()                  ])           
        tables_array.push(["After Hours"                                , aab.source_after_hours.web.default()              ])       
        tables_array.push(["Leading PD"                                 , aab.source_leading_pd.web.default()               ])        
        tables_array.push(["Program Administrator/Expert"               , aab.source_program_admin.web.default()            ])     
        tables_array.push(["LOCAL Club Advisor"                         , aab.source_local_club.web.default()               ])        
        tables_array.push(["Substituting (no comp)"                     , aab.source_subsitute_no_pay.web.default()         ])  
        tables_array.push(["Parent Training Outside of work hours"      , aab.source_parent_training.web.default()          ])   
        tables_array.push(["Distinguished Aims Web participation"       , aab.source_distinguished_aims.web.default()       ])   
        tables_array.push(["Distinguished Define U Attendance"          , aab.source_distinguished_define_u.web.default()   ])   
        tables_array.push(["Other"                                      , aab.source_other.web.text()                       ])             
        
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "engagement_aab",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                aab.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Coach Comments"     ),
                aab.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end

    def evaluation_goals
        
        #SUMMARY GOALS
        if @snapshot_date
            
            $focus_team_member.evaluation_summary_snapshot.by_snapshot_date(@snapshot_date)
            goals = $focus_team_member.evaluation_summary_snapshot
            
        else
            
            $focus_team_member.evaluation_summary.existing_record || $focus_team_member.evaluation_summary.new_record.save
            goals = $focus_team_member.evaluation_summary
            
        end
        
        tables_array = Array.new
        tables_array.push(["Goal One"                           , goals.goal_1.web.default()                ])     
        tables_array.push(["Goal Two"                           , goals.goal_2.web.default()                ])  
        tables_array.push(["Goal Three"                         , goals.goal_3.web.default()                ])                            
        
        data = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "evaluation_goals",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        tables_array = Array.new
        tables_array.push(
            [
                goals.team_member_comments.web.default(:disabled=>@disabled, :label_option=>"Team Member Comments"     ),
                goals.supervisor_comments.web.default( :disabled=>@disabled, :label_option=>"Evaluator Comments" )
            ]
        )  
        comments = $tools.table(
            :table_array    => tables_array,
            :unique_name    => "comments",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        return data+comments
        
    end
    
    def evaluation_summary
        
        tables_array = Array.new
        
        if @snapshot_date
            
            $focus_team_member.evaluation_summary_snapshot.by_snapshot_date(@snapshot_date)
            summary = $focus_team_member.evaluation_summary_snapshot
            
        else
            
            $focus_team_member.evaluation_summary.existing_record || $focus_team_member.evaluation_summary.new_record.save
            summary = $focus_team_member.evaluation_summary
            
        end
        
        #PEER GROUP SUMMARY RECORD
        if !(
            pgsr = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").by_peer_group_id(
                $focus_team_member.peer_group_id.value,
                $focus_team_member.department_id.value,
                @snapshot_date
            )
        )
            pgsr = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").new_row
        end
        
        #DEPARTMENT SUMMARY RECORD
        if !(dsr = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").by_department_id($focus_team_member.department_id.value, @snapshot_date))
            dsr = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").new_row
        end
       
        tables_array.push(["Category"                             ,"Team Member"                                     ,"Peer Group"                                           ,"Department"                                                      ])
        tables_array.push(["Current Students"                     ,summary.students.to_user({:na=>true})                          ,pgsr.fields["students"                                 ].to_user({:na=>true}) ,dsr.fields["students"                              ].to_user({:na=>true})])                        
        tables_array.push(["All Students"                         ,summary.all_students.to_user({:na=>true})                      ,pgsr.fields["all_students"                             ].to_user({:na=>true}) ,dsr.fields["all_students"                          ].to_user({:na=>true})])   
        tables_array.push(["New Students"                         ,summary.new.to_user({:na=>true})                               ,pgsr.fields["new"                                      ].to_user({:na=>true}) ,dsr.fields["new"                                   ].to_user({:na=>true})]  )   
        tables_array.push(["Enrolled In Year"                     ,summary.in_year.to_user({:na=>true})                           ,pgsr.fields["in_year"                                  ].to_user({:na=>true}) ,dsr.fields["in_year"                               ].to_user({:na=>true})]  )   
        tables_array.push(["Grades 7-12"                          ,summary.grades_712.to_user({:na=>true})                        ,pgsr.fields["grades_712"                               ].to_user({:na=>true}) ,dsr.fields["grades_712"                            ].to_user({:na=>true})]  )   
        tables_array.push(["Economically Disadvantaged"           ,summary.low_income.to_user({:na=>true})                        ,pgsr.fields["low_income"                               ].to_user({:na=>true}) ,dsr.fields["low_income"                            ].to_user({:na=>true})]  )   
        tables_array.push(["Tier 2/3"                             ,summary.tier_23.to_user({:na=>true})                           ,pgsr.fields["tier_23"                                  ].to_user({:na=>true}) ,dsr.fields["tier_23"                               ].to_user({:na=>true})]  )   
        tables_array.push(["Special Education"                    ,summary.special_ed.to_user({:na=>true})                        ,pgsr.fields["special_ed"                               ].to_user({:na=>true}) ,dsr.fields["special_ed"                            ].to_user({:na=>true})]  )   
        tables_array.push(["Scantron Participation (fall)"        ,summary.scantron_participation_fall.to_user({:na=>true})       ,pgsr.fields["scantron_participation_fall"              ].to_user({:na=>true}) ,dsr.fields["scantron_participation_fall"           ].to_user({:na=>true})]  )   
        tables_array.push(["Scantron Participation (spring)"      ,summary.scantron_participation_spring.to_user({:na=>true})     ,pgsr.fields["scantron_participation_spring"            ].to_user({:na=>true}) ,dsr.fields["scantron_participation_spring"         ].to_user({:na=>true})]  )  
        tables_array.push(["Scantron Growth Overall"              ,summary.scantron_growth_overall.to_user({:na=>true})           ,pgsr.fields["scantron_growth_overall"                  ].to_user({:na=>true}) ,dsr.fields["scantron_growth_overall"               ].to_user({:na=>true})]  )   
        tables_array.push(["Scantron Growth Math"                 ,summary.scantron_growth_math.to_user({:na=>true})              ,pgsr.fields["scantron_growth_math"                     ].to_user({:na=>true}) ,dsr.fields["scantron_growth_math"                  ].to_user({:na=>true})]  )   
        tables_array.push(["Scantron Growth Reading"              ,summary.scantron_growth_reading.to_user({:na=>true})           ,pgsr.fields["scantron_growth_reading"                  ].to_user({:na=>true}) ,dsr.fields["scantron_growth_reading"               ].to_user({:na=>true})]  )   
        tables_array.push(["AIMS Participation (fall)"            ,summary.aims_participation_fall.to_user({:na=>true})           ,pgsr.fields["aims_participation_fall"                  ].to_user({:na=>true}) ,dsr.fields["aims_participation_fall"               ].to_user({:na=>true})]  )   
        tables_array.push(["AIMS Participation (spring)"          ,summary.aims_participation_spring.to_user({:na=>true})         ,pgsr.fields["aims_participation_spring"                ].to_user({:na=>true}) ,dsr.fields["aims_participation_spring"             ].to_user({:na=>true})]  )   
        tables_array.push(["AIMS Growth Overall"                  ,summary.aims_growth_overall.to_user({:na=>true})               ,pgsr.fields["aims_growth_overall"                      ].to_user({:na=>true}) ,dsr.fields["aims_growth_overall"                   ].to_user({:na=>true})]  )   
        tables_array.push(["DefineU Participation"                ,summary.define_u_participation.to_user({:na=>true})            ,pgsr.fields["define_u_participation"                   ].to_user({:na=>true}) ,dsr.fields["define_u_participation"                ].to_user({:na=>true})]  )   
        tables_array.push(["PSSA Participation"                   ,summary.pssa_participation.to_user({:na=>true})                ,pgsr.fields["pssa_participation"                       ].to_user({:na=>true}) ,dsr.fields["pssa_participation"                    ].to_user({:na=>true})]  )   
        tables_array.push(["Keystone Participation"               ,summary.keystone_participation.to_user({:na=>true})            ,pgsr.fields["keystone_participation"                   ].to_user({:na=>true}) ,dsr.fields["keystone_participation"                ].to_user({:na=>true})]  )     
        tables_array.push(["Attendance Rate"                      ,summary.attendance_rate.to_user({:na=>true})                   ,pgsr.fields["attendance_rate"                          ].to_user({:na=>true}) ,dsr.fields["attendance_rate"                       ].to_user({:na=>true})]  )   
        tables_array.push(["Retention Rate"                       ,summary.retention_rate.to_user({:na=>true})                    ,pgsr.fields["retention_rate"                           ].to_user({:na=>true}) ,dsr.fields["retention_rate"                        ].to_user({:na=>true})]  )   
        tables_array.push(["Engagement Level"                     ,summary.engagement_level.to_user({:na=>true})                  ,pgsr.fields["engagement_level"                         ].to_user({:na=>true}) ,dsr.fields["engagement_level"                      ].to_user({:na=>true})])     
        
        #MANUAL ENTRY AT THIS TIME
        temp_view = @temporary_summary_editors.include?($team_member.preferred_email.value) ? "web.text" : "round"
        tables_array.push(["Study Island Participation"           ,eval("summary.study_island_participation.#{temp_view}"          ) ,pgsr.fields["study_island_participation"               ].to_user({:na=>true}) ,dsr.fields["study_island_participation"            ].to_user({:na=>true})])   
        tables_array.push(["Study Island Participation (Tier 2/3)",eval("summary.study_island_participation_tier_23.#{temp_view}"  ) ,pgsr.fields["study_island_participation_tier_23"       ].to_user({:na=>true}) ,dsr.fields["study_island_participation_tier_23"    ].to_user({:na=>true})])   
        tables_array.push(["Study Island Achievement"             ,eval("summary.study_island_achievement.#{temp_view}"            ) ,pgsr.fields["study_island_achievement"                 ].to_user({:na=>true}) ,dsr.fields["study_island_achievement"              ].to_user({:na=>true})])   
        tables_array.push(["Study Island Achievement (Tier 2/3)"  ,eval("summary.study_island_achievement_tier_23.#{temp_view}"    ) ,pgsr.fields["study_island_achievement_tier_23"         ].to_user({:na=>true}) ,dsr.fields["study_island_achievement_tier_23"      ].to_user({:na=>true})])   
        tables_array.push(["Passing Rate"                         ,eval("summary.course_passing_rate.#{temp_view}"                 ) ,pgsr.fields["course_passing_rate"                      ].to_user({:na=>true}) ,dsr.fields["course_passing_rate"                   ].to_user({:na=>true})])   
        
        return $tools.table(
            :table_array    => tables_array,
            :unique_name    => "evaluation_summary",
            :footers        => false,
            :head_section   => false,
            :title          => true,
            :caption        => false
        )
        
    end

    def evaluation_summary_snapshot_includes #THIS IS ONLY INCLUDED WHEN VIEWING A SNAPSHOT
        
        tables_array = Array.new
        
        includes_hash = Hash.new {|h,k|
            
            h[k] = Hash.new
            includes_fields.each{|include_field|
                h[k][include_field]=nil
            }
            h[k]
            
        }
     
        $focus_team_member.assigned_students.each{|sid| includes_hash[sid]}
        
        $focus_team_member.evaluation_summary_snapshot_includes.by_snapshot_date(@snapshot_date)
        summary_snapshot_includes = $focus_team_member.evaluation_summary_snapshot_includes
        
        includes_fields.each{|field_name|
            
            sids_str = summary_snapshot_includes.send(field_name).value    
            if sids_str
                
                sids = sids_str.split(",")
                sids.each{|sid|
                    
                    includes_hash[sid][field_name] = "X"#"<span class='ui-icon ui-icon-check'></span>"
                    
                }
                
            end
            
        }
        
        tables_array.push( includes_headers )
        
        includes_hash.each_pair{|k, v|
            
            row_fields = Array.new
            row_fields.push(k)
            includes_fields.each{|include_field|
                row_fields.push(v[include_field])    
            }
            tables_array.push(row_fields)
        }
        
        #return $tools.table(
        #    :table_array    => tables_array,
        #    :unique_name    => "evaluation_summary_snapshot",
        #    :footers        => false,
        #    :head_section   => false,
        #    :title          => true,
        #    :legend         => includes_legend,
        #    :caption        => false
        #)
        
        return $tools.data_table(tables_array, "evaluation_summary_snapshot", "default", true, includes_legend)
        
    end

    def evaluation_uploads(tid)
        
        output  = String.new
        
        output << $tools.legend_open("sub", "Documents")
        
        category_id = $tables.attach("document_category").find_field("primary_id",  "WHERE name='Team Member Evaluations'").value
        
        type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Evaluation' AND category_id='#{category_id}'").value
        
        if @doc_pids = $tables.attach("DOCUMENTS").document_pids(type_id, "TEAM", "primary_id", tid)
            
            output << expand_documents
            
        else
            
            output << "No Results Found."
            
        end
        
        output << $tools.legend_close()
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def add_new_pdf_evaluation_document(tid)
        
        t   = $team.get(tid)
        
        template = String.new
        engagement_type = String.new
        
        case t.department_category.value
        when /Academic/
            
            case t.department_focus.value
            when /Elementary School/
                
                template        = "EVALUATION_PDF.rb"
                evaluation_type = "Elementary"
                
            when /Middle School/
                
                template        = "EVALUATION_PDF.rb"
                evaluation_type = "Middle School"
                
            end
            
        when /Engagement/
            
            template        = "EVALUATION_PDF.rb"
            evaluation_type = "Engagement"
            
        end
        
        if template != ""
            
            pdf = Prawn::Document.generate "#{$paths.htdocs_path}temp/eval_temp#{$ifilestamp}.pdf" do |pdf|
                require "#{$paths.templates_path}pdf_templates/#{template}"
                template = eval("#{template.gsub(".rb","")}.new")
                template.generate_pdf(tid, evaluation_type, pdf)
            end
            
        else
            
            return false
            
        end
        
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________UPLOAD_PDF_FORMS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def upload_doc_evaluation_document(tid)
        output = String.new
        
        output << "<form id='doc_upload_form' name='form' action='#{$config.code_set_name}.rb' method='POST' enctype='multipart/form-data' >"
        output << "<input id='tidref' name='tidref' value='#{tid}' type='hidden'>"
        output << $tools.document_upload2(self.class.name, "Team Member Evaluations", "Evaluation", "doc_upload_form", "pdf")
        output << "</form>"
        
        return output
    end 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def expand_documents
        
        output = "<div style='width:990px;'>"
        
        tables_array = [
            
            #HEADERS
            [
                "Action",
                "Document Type",
                "Date Uploaded",
                "Uploaded By"
            ]
        ]
        
        @doc_pids.each{|pid|
            
            document = $tables.attach("DOCUMENTS").by_primary_id(pid)
            
            tables_array.push([
                
                $tools.doc_secure_link(pid, "View or Download"),
                
                $tables.attach("document_type").field_by_pid("name", document.fields["type_id"].value).value,
                
                document.fields["created_date"].to_user,
                
                begin $team.by_team_email(document.fields["created_by"].value).full_name rescue "Unknown" end
                
            ])
            
        }
        
        output << $kit.tools.data_table(tables_array, "evaluation_documents")
        output << "</div>"
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def eval_dates_dd
        
        dd_choices = $tables.attach("TEAM_EVALUATION_SUMMARY_SNAPSHOT").dd_choices(
            "LEFT(created_date,10)",
            "LEFT(created_date,10)",
            " WHERE team_id = #{$focus_team_member.primary_id.value}
            GROUP BY LEFT(created_date,10)
            ORDER BY LEFT(created_date,10) DESC "
        )
        dd_choices ? dd_choices.insert(0,{:name=>"Live Record" , :value=>"" }) : [{:name=>"Live Record" , :value=>"" }]
    end
    
    def score_dd(values=[unsatisfactory="10",progressing="20",proficient="30",distinguished="40"])
        
        if values.length == 4
            return [
                {:name=>"Unsatisfactory (#{values[0]})" , :value=>values[0] },
                {:name=>"Progressing (#{values[1]})"    , :value=>values[1] },
                {:name=>"Proficient (#{values[2]})"     , :value=>values[2] },
                {:name=>"Distinguished (#{values[3]})"  , :value=>values[3] }
            ]
        elsif values.length == 7
            return [
                {:name=>"Unsatisfactory (#{values[0]})"     , :value=>values[0] },
                {:name=>"Unsatisfactory + (#{values[1]})"   , :value=>values[1] },
                {:name=>"Progressing (#{values[2]})"        , :value=>values[2] },
                {:name=>"Progressing + (#{values[3]})"      , :value=>values[3] },
                {:name=>"Proficient (#{values[4]})"         , :value=>values[4] },
                {:name=>"Proficient (#{values[5]})"         , :value=>values[5] },
                {:name=>"Distinguished (#{values[6]})"      , :value=>values[6] }
            ]
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def includes_fields
        [
         
            "students",     
            "all_students", 
            "withdrawn",    
            "new",          
            "in_year",      
            "low_income",   
            "tier_23",      
            "special_ed",   
            "grades_712",
            "scantron_participation_fall",
            "scantron_participation_fall_eligible",
            "scantron_participation_spring",
            "scantron_participation_spring_eligible",     
            "scantron_growth_overall",           
            "scantron_growth_overall_eligible",  
            "scantron_growth_math",              
            "scantron_growth_math_eligible",     
            "scantron_growth_reading",           
            "scantron_growth_reading_eligible",  
            "study_island", 
            "define_u",     
            "state_test",   
            "aims_growth_overall",
            "aims_growth_overall_eligible",
            "aims_participation_fall",
            "aims_participation_fall_eligible",
            "aims_participation_spring",
            "aims_participation_spring_eligible",
            "pssa_participation",
            "pssa_participation_eligible",
            "keystone_participation",
            "keystone_participation_eligible"
            
        ]
    end
    
    def includes_headers
        [
            "Student ID",
            "CE",
            "AA",
            "WD",
            "NTY",
            "EIY",
            "ED",
            "T23",
            "SED",
            "712",
            "SPF",
            "SPFE",
            "SPS",
            "SPSE",
            "SGO",
            "SGOE",
            "SGM",
            "SGME",
            "SGR",
            "SGRE",
            "SI",
            "DU",
            "ST",
            "AGO",
            "AGOE",
            "APF",
            "APFE",
            "APS",
            "APSE",
            "PSSA",
            "PSSAE",
            "KEY",
            "KEYE"
        ]
    end
    
    def includes_legend
        [
            "Student ID",
            "Currently Enrolled",
            "All Assigned",
            "Withdrawn",
            "New This Year",
            "Enrolled In Year",
            "Economically Disadvantaged",
            "Tier 2 or 3",
            "Special Education",
            "Grades 7 to 12",
            "Scantron Participation Fall", 
            "Scantron Participation Fall Eligible",
            "Scantron Participation Spring",
            "Scantron Participation Spring Eligible",     
            "Scantron Growth Overall",           
            "Scantron Growth Overall Eligible",  
            "Scantron Growth Math",              
            "Scantron Growth Math Eligible",     
            "Scantron Growth Reading",           
            "Scantron Growth Reading Eligible",
            "Study Island",
            "DefineU",
            "State Test",
            "AIMS Growth Overall",
            "AIMS Growth Overall Eligible",
            "AIMS Participation Fall",
            "AIMS Participation Fall Eligible",
            "AIMS Participation Spring",
            "AIMS Participation Spring Eligible",
            "PSSA Participation",
            "PSSA Eligible",
            "Keystone Participation",
            "Keystone Eligible"
        ]
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "#date_selected           {       margin-right: 10px; float:right; }"
        output << "#upload_doc_button       {       margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}"
        output << "#new_pdf_button          {       margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}"
        output << "iframe                   {       float:right; display:none;}"
        output << "div#tabs_evaluation .ui-tabs-nav {
            font-size: x-small;
        }"
        output << "table#user_input_section {
            width:100%;
        }"
        
        output << "table#user_input_section         input{ width:250px;  }"
        output << "table#user_input_section        select{ width:250px;  }"
        output << "table#user_input_section        checkbox{ width:25px;  }"
        
        #ACADEMIC
        output << "table#academic_instruction{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
        
            output << "table#academic_instruction                     td{ width:50%;                                          }"
            output << "table#academic_instruction            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#academic_instruction            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#academic_instruction            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#academic_instruction            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#academic_instruction             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#academic_instruction            td.even_row{ vertical-align:middle;                              }"
            output << "table#academic_instruction                     th{ width:300px; border-bottom: 1px solid #000000;      }"
         
        output << "table#academic_metrics{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#academic_metrics                     td{ width:50%;                                          }"
            output << "table#academic_metrics            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#academic_metrics            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#academic_metrics            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#academic_metrics            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#academic_metrics             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#academic_metrics            td.even_row{ vertical-align:middle;                              }"
            output << "table#academic_metrics                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "table#academic_professionalism{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#academic_professionalism                     td{ width:50%;                                          }"
            output << "table#academic_professionalism            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#academic_professionalism            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#academic_professionalism            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#academic_professionalism            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#academic_professionalism             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#academic_professionalism            td.even_row{ vertical-align:middle;                              }"
            output << "table#academic_professionalism                     th{ width:300px; border-bottom: 1px solid #000000;      }"
         
        #ENGAGEMENT
        output << "table#engagement_metrics{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            
            output << "table#engagement_metrics                     td{ width:50%;                                          }"
            output << "table#engagement_metrics            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#engagement_metrics            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#engagement_metrics            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#engagement_metrics            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#engagement_metrics             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#engagement_metrics            td.even_row{ vertical-align:middle;                              }"
            output << "table#engagement_metrics                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
            #comments section
            output << "table#comments{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#comments                   td{ width:50%;                                          }"
            
            output << "table#comments                     {  width:100%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}"
            output << "table#comments                label{  display:inline-block; width:100%;}"
            output << "table#comments             textarea{  width:96%; overflow-y: scroll; resize: none;}"
            
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__team_member_comments          {  width:100%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}"
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__team_member_comments     label{  display:inline-block; width:100%;}"
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__team_member_comments  textarea{  width:96%; overflow-y: scroll; resize: none;}"
            #
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__supervisor_comments           {  width:100%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}"
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__supervisor_comments      label{  display:inline-block; width:100%;}"
            #output << "div.TEAM_EVALUATION_ENGAGEMENT_METRICS__supervisor_comments   textarea{  width:96%; overflow-y: scroll; resize: none;}"
            
            
        output << "table#engagement_observation{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#engagement_observation                     td{ width:50%;                                          }"
            output << "table#engagement_observation            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#engagement_observation            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#engagement_observation            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#engagement_observation            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#engagement_observation             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#engagement_observation            td.even_row{ vertical-align:middle;                              }"
            output << "table#engagement_observation                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "table#engagement_professionalism{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#engagement_professionalism                     td{ width:50%;                                          }"
            output << "table#engagement_professionalism            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#engagement_professionalism            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#engagement_professionalism            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#engagement_professionalism            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#engagement_professionalism             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#engagement_professionalism            td.even_row{ vertical-align:middle;                              }"
            output << "table#engagement_professionalism                     th{ width:300px; border-bottom: 1px solid #000000;      }" 
         
        output << "table#evaluation_summary{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#evaluation_summary .even_row {
                background-color: #AED0EA;
            }"
            output << "table#evaluation_summary .row_0 {
                background-color: transparent !important;
                font-size       : small;
                font-weight     : bold;
                border-bottom   : 1px solid #000000 !important;
            }"
            
            output << "table#evaluation_summary                     td{ width:25%;}"
            
            output << "div.TEAM_EVALUATION_SUMMARY__goal_1   textarea{  width:800px; overflow-y: scroll; resize: none;}"
            output << "div.TEAM_EVALUATION_SUMMARY__goal_2   textarea{  width:800px; overflow-y: scroll; resize: none;}"
            output << "div.TEAM_EVALUATION_SUMMARY__goal_3   textarea{  width:800px; overflow-y: scroll; resize: none;}"
            #output << "table#evaluation_summary            td.column_0{ font-size:small; font-weight:bold; vertical-align:middle; text-align:left;             }"
            #output << "table#evaluation_summary            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            #output << "table#evaluation_summary            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            #output << "table#evaluation_summary            tr.row_0 td.column_1 { vertical-align:middle;    }"
            
            #output << "table#evaluation_summary             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            #output << "table#evaluation_summary            td.even_row{ vertical-align:middle;                              }"
            #output << "table#evaluation_summary                     th{ width:300px; border-bottom: 1px solid #000000;      }"
          
        output << "table#engagement_metrics_scores{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#engagement_metrics_scores                     td{ width:50%;                                          }"
            output << "table#engagement_metrics_scores            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#engagement_metrics_scores            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#engagement_metrics_scores            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#engagement_metrics_scores            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#engagement_metrics_scores             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#engagement_metrics_scores            td.even_row{ vertical-align:middle;                              }"
            output << "table#engagement_metrics_scores                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        #goals section
            output << "table#goals{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#goals                   td.column_0{ width:10%;}"
            output << "table#goals                   td.column_1{ width:90%;}"
            
            output << "table#goals                     {  width:100%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}"
            output << "table#goals                label{  display:inline-block; width:100%;}"
            output << "table#goals             textarea{  width:96%; overflow-y: scroll; resize: none;}"
            
        #overall score section
            output << "table#overall_score{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#overall_score                   td.column_0{ width:10%;}"
            output << "table#overall_score                   td.column_1{ width:90%;}"
            
            output << "table#overall_score                     {  width:100%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}"
            output << "table#overall_score                label{  display:inline-block; width:100%;}"
            output << "table#overall_score             textarea{  width:96%; overflow-y: scroll; resize: none;}"
         
        output << "table#engagement_aab{
                width       : 100%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#engagement_aab                     td{ width:50%;                                          }"
            output << "table#engagement_aab            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#engagement_aab            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#engagement_aab            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#engagement_aab            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#engagement_aab             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#engagement_aab            td.even_row{ vertical-align:middle;                              }"
            output << "table#engagement_aab                     th{ width:300px; border-bottom: 1px solid #000000;      }" 
            
        #EVALUATION SUMMARY SNAPSHOT    
        output << "table#evaluation_summary_snapshot{
                width       : 870px;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#evaluation_summary_snapshot .even_row {
                background-color: #AED0EA;
            }"
            output << "table#evaluation_summary_snapshot .row_0 {
                background-color: transparent !important;
                font-size       : x-small;
                font-weight     : bold;
                border-bottom   : 1px solid #000000 !important;
            }"
            
            output << "table#evaluation_summary_snapshot                     td{ width:20px;}"
            #output << "table#evaluation_summary_snapshot tr.row_0 td.column_0 {
            #    padding-top : 80px;
            #}"
           
            #left = 190
            #(1.. 16).each{|num|
            #    output << "table#evaluation_summary_snapshot tr.row_0 td.column_#{num} {
            #        transform:rotate(-75deg);
            #        -ms-transform:rotate(-75deg);     /* IE 9 */
            #        -moz-transform:rotate(-75deg);    /* Firefox */
            #        -webkit-transform:rotate(-75deg); /* Safari and Chrome */
            #        -o-transform:rotate(-75deg);      /* Opera */
            #        transform   : rotate(-75deg);
            #        position    : absolute;
            #        top         : 130px;
            #        left        : #{left}px;
            #        width       : 20px;
            #    }"
            #    left+=48
            #}
            
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