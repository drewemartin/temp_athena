#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Team_Evaluations_Summary_Update < Base

    def initialize()
        super()
        
        @notify_samsids = Array.new
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUMMARY_SNAPSHOTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_evaluation_summary_snapshot
        
        department_ids = $tables.attach("DEPARTMENT").primary_ids(
            "WHERE name != 'Administration'
            AND focus REGEXP 'Elementary School|Middle School|High School'"
        )
        
        department_ids.each{|department_id|
            
            snapshot_pid = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").primary_ids(
                "WHERE created_date REGEXP '#{$idate}'
                AND department_id = '#{department_id}'"
            )
            if snapshot_pid
                summary_snapshot = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").by_primary_id(snapshot_pid)
            else
                summary_snapshot = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").new_row
                summary_snapshot.fields["department_id"].value = department_id
                summary_snapshot.save
            end
            
            summary_snapshot.fields["students"                                 ].to_department_group_average!
            summary_snapshot.fields["all_students"                             ].to_department_group_average!
            summary_snapshot.fields["new"                                      ].to_department_group_average!
            summary_snapshot.fields["in_year"                                  ].to_department_group_average!
            summary_snapshot.fields["low_income"                               ].to_department_group_average!
            summary_snapshot.fields["tier_23"                                  ].to_department_group_average!
            summary_snapshot.fields["special_ed"                               ].to_department_group_average!
            summary_snapshot.fields["grades_712"                               ].to_department_group_average!
            summary_snapshot.fields["scantron_participation_fall"              ].to_department_group_average!
            summary_snapshot.fields["scantron_participation_spring"            ].to_department_group_average!
            summary_snapshot.fields["scantron_growth_overall"                  ].to_department_group_average!
            summary_snapshot.fields["scantron_growth_math"                     ].to_department_group_average!
            summary_snapshot.fields["scantron_growth_reading"                  ].to_department_group_average!
            summary_snapshot.fields["aims_participation_fall"                  ].to_department_group_average!
            summary_snapshot.fields["aims_participation_spring"                ].to_department_group_average!
            summary_snapshot.fields["aims_growth_overall"                      ].to_department_group_average!
            summary_snapshot.fields["study_island_participation"               ].to_department_group_average!
            summary_snapshot.fields["study_island_participation_tier_23"       ].to_department_group_average!
            summary_snapshot.fields["study_island_achievement"                 ].to_department_group_average!
            summary_snapshot.fields["study_island_achievement_tier_23"         ].to_department_group_average!
            summary_snapshot.fields["define_u_participation"                   ].to_department_group_average!
            summary_snapshot.fields["pssa_participation"                       ].to_department_group_average!
            summary_snapshot.fields["keystone_participation"                   ].to_department_group_average!
            summary_snapshot.fields["attendance_rate"                          ].to_department_group_average!
            summary_snapshot.fields["retention_rate"                           ].to_department_group_average!
            summary_snapshot.fields["engagement_level"                         ].to_department_group_average!
            summary_snapshot.fields["score"                                    ].to_department_group_average!
            
            summary_snapshot.save
            
        } if department_ids
        
    end

    def peer_group_evaluation_summary_snapshot
      
        department_ids = $tables.attach("DEPARTMENT").primary_ids
        
        department_ids.each{|department_id|
            
            peer_group_ids = $tables.attach("team").find_fields(
                "peer_group_id",
                "WHERE department_id = '#{department_id}'
                AND peer_group_id IS NOT NULL
                GROUP BY peer_group_id",
                {:value_only=>true}
            )
            
            peer_group_ids.each{|peer_group_id|
                
                snapshot_pid = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").primary_ids(
                    "WHERE created_date REGEXP '#{$idate}'
                    AND department_id = '#{department_id}'
                    AND peer_group_id = '#{peer_group_id}'"
                )
                if snapshot_pid
                    summary_snapshot = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").by_primary_id(snapshot_pid)
                else
                    summary_snapshot = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").new_row
                    summary_snapshot.fields["department_id"].value = department_id
                    summary_snapshot.fields["peer_group_id"].value = peer_group_id
                    summary_snapshot.save
                end
                
                summary_snapshot.fields["students"                                 ].to_peer_group_average!
                summary_snapshot.fields["all_students"                             ].to_peer_group_average!
                summary_snapshot.fields["new"                                      ].to_peer_group_average!
                summary_snapshot.fields["in_year"                                  ].to_peer_group_average!
                summary_snapshot.fields["low_income"                               ].to_peer_group_average!
                summary_snapshot.fields["tier_23"                                  ].to_peer_group_average!
                summary_snapshot.fields["special_ed"                               ].to_peer_group_average!
                summary_snapshot.fields["grades_712"                               ].to_peer_group_average!
                summary_snapshot.fields["scantron_participation_fall"              ].to_peer_group_average!
                summary_snapshot.fields["scantron_participation_spring"            ].to_peer_group_average!
                summary_snapshot.fields["scantron_growth_overall"                  ].to_peer_group_average!
                summary_snapshot.fields["scantron_growth_math"                     ].to_peer_group_average!
                summary_snapshot.fields["scantron_growth_reading"                  ].to_peer_group_average!
                summary_snapshot.fields["aims_participation_fall"                  ].to_peer_group_average!
                summary_snapshot.fields["aims_participation_spring"                ].to_peer_group_average!
                summary_snapshot.fields["aims_growth_overall"                      ].to_peer_group_average!
                summary_snapshot.fields["study_island_participation"               ].to_peer_group_average!
                summary_snapshot.fields["study_island_participation_tier_23"       ].to_peer_group_average!
                summary_snapshot.fields["study_island_achievement"                 ].to_peer_group_average!
                summary_snapshot.fields["study_island_achievement_tier_23"         ].to_peer_group_average!
                summary_snapshot.fields["define_u_participation"                   ].to_peer_group_average!
                summary_snapshot.fields["pssa_participation"                       ].to_peer_group_average!
                summary_snapshot.fields["keystone_participation"                   ].to_peer_group_average!
                summary_snapshot.fields["attendance_rate"                          ].to_peer_group_average!
                summary_snapshot.fields["retention_rate"                           ].to_peer_group_average!
                summary_snapshot.fields["engagement_level"                         ].to_peer_group_average!
                summary_snapshot.fields["score"                                    ].to_peer_group_average!
                
                summary_snapshot.save
                
            } if peer_group_ids
            
        } if department_ids
        
    end
    
    def team_evaluation_summary_snapshot(team_member_object)
        
        t = team_member_object
        
        summary = t.evaluation_summary.existing_record
        
        if !(summary_snapshot = $tables.attach("TEAM_EVALUATION_SUMMARY_SNAPSHOT").by_team_id(t.primary_id.value, snapshot_date = $idate))
            summary_snapshot = t.evaluation_summary_snapshot.new_record
        end
        
        summary_snapshot.fields["students"                                 ].value = summary.fields["students"                                 ].value 
        summary_snapshot.fields["all_students"                             ].value = summary.fields["all_students"                             ].value 
        summary_snapshot.fields["new"                                      ].value = summary.fields["new"                                      ].value 
        summary_snapshot.fields["in_year"                                  ].value = summary.fields["in_year"                                  ].value 
        summary_snapshot.fields["low_income"                               ].value = summary.fields["low_income"                               ].value 
        summary_snapshot.fields["tier_23"                                  ].value = summary.fields["tier_23"                                  ].value 
        summary_snapshot.fields["special_ed"                               ].value = summary.fields["special_ed"                               ].value 
        summary_snapshot.fields["grades_712"                               ].value = summary.fields["grades_712"                               ].value 
        summary_snapshot.fields["scantron_participation_fall"              ].value = summary.fields["scantron_participation_fall"              ].value 
        summary_snapshot.fields["scantron_participation_spring"            ].value = summary.fields["scantron_participation_spring"            ].value 
        summary_snapshot.fields["scantron_growth_overall"                  ].value = summary.fields["scantron_growth_overall"                  ].value 
        summary_snapshot.fields["scantron_growth_math"                     ].value = summary.fields["scantron_growth_math"                     ].value 
        summary_snapshot.fields["scantron_growth_reading"                  ].value = summary.fields["scantron_growth_reading"                  ].value 
        summary_snapshot.fields["aims_participation_fall"                  ].value = summary.fields["aims_participation_fall"                  ].value 
        summary_snapshot.fields["aims_participation_spring"                ].value = summary.fields["aims_participation_spring"                ].value 
        summary_snapshot.fields["aims_growth_overall"                      ].value = summary.fields["aims_growth_overall"                      ].value 
        summary_snapshot.fields["study_island_participation"               ].value = summary.fields["study_island_participation"               ].value 
        summary_snapshot.fields["study_island_participation_tier_23"       ].value = summary.fields["study_island_participation_tier_23"       ].value 
        summary_snapshot.fields["study_island_achievement"                 ].value = summary.fields["study_island_achievement"                 ].value 
        summary_snapshot.fields["study_island_achievement_tier_23"         ].value = summary.fields["study_island_achievement_tier_23"         ].value 
        summary_snapshot.fields["define_u_participation"                   ].value = summary.fields["define_u_participation"                   ].value 
        summary_snapshot.fields["pssa_participation"                       ].value = summary.fields["pssa_participation"                       ].value 
        summary_snapshot.fields["keystone_participation"                   ].value = summary.fields["keystone_participation"                   ].value 
        summary_snapshot.fields["attendance_rate"                          ].value = summary.fields["attendance_rate"                          ].value 
        summary_snapshot.fields["retention_rate"                           ].value = summary.fields["retention_rate"                           ].value 
        summary_snapshot.fields["engagement_level"                         ].value = summary.fields["engagement_level"                         ].value 
        summary_snapshot.fields["score"                                    ].value = summary.fields["score"                                    ].value
        
        summary_snapshot.save
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TEAM_MEMBER_DETAIL_SNAPSHOTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def snapshot(team_member_object, table_name)
        
        table_function_name = table_name.split("team_")[1]
        
        team_member_object.send(table_function_name).existing_record || team_member_object.send(table_function_name).new_record.save
        
        snapshot = nil
        
        snapshot_table_name = "#{table_name}_snapshot"
        snapshot_pid = $tables.attach(snapshot_table_name).primary_ids(
            "WHERE created_date REGEXP '#{$idate}'
            AND team_id = '#{team_member_object.primary_id.value}'"
        )
        
        if snapshot_pid
            snapshot = $tables.attach(snapshot_table_name).by_primary_id(snapshot_pid[0])
        else
            snapshot = $tables.attach(snapshot_table_name).new_row
        end
        
        snapshot.table.field_order.each{|field_name|
            
            snapshot.fields[field_name].value = team_member_object.send(table_function_name).send(field_name).value
            
        }   
        
        snapshot.save
        
    end
    
    def team_evaluation_aab_snapshot(team_member_object)
        
        t = team_member_object
        
        t.evaluation_aab.existing_record || t.evaluation_aab.new_record.save
        
        snapshot_pid = $tables.attach("TEAM_EVALUATION_AAB_SNAPSHOT").primary_ids(
            "WHERE created_date REGEXP '#{$idate}'
            AND team_id = '#{t.primary_id.value}'"
        )
        
        if snapshot_pid
            snapshot = $tables.attach("TEAM_EVALUATION_AAB_SNAPSHOT").by_primary_id(snapshot_pid)
        else
            snapshot = $tables.attach("TEAM_EVALUATION_AAB_SNAPSHOT").new_row
        end
        
        snapshot.fields["team_id"                     ].value = t.evaluation_aab.team_id.value                 
        snapshot.fields["source_mentoring"            ].value = t.evaluation_aab.source_mentoring.value        
        snapshot.fields["source_recruitment_team"     ].value = t.evaluation_aab.source_recruitment_team.value 
        snapshot.fields["source_committee"            ].value = t.evaluation_aab.source_committee.value        
        snapshot.fields["source_testing"              ].value = t.evaluation_aab.source_testing.value          
        snapshot.fields["source_after_hours"          ].value = t.evaluation_aab.source_after_hours.value      
        snapshot.fields["source_leading_pd"           ].value = t.evaluation_aab.source_leading_pd.value       
        snapshot.fields["source_program_admin"        ].value = t.evaluation_aab.source_program_admin.value    
        snapshot.fields["source_local_club"           ].value = t.evaluation_aab.source_local_club.value       
        snapshot.fields["source_subsitute_no_pay"     ].value = t.evaluation_aab.source_subsitute_no_pay.value 
        snapshot.fields["source_parent_training"      ].value = t.evaluation_aab.source_parent_training.value  
        snapshot.fields["source_other"                ].value = t.evaluation_aab.source_other.value            
        snapshot.fields["team_member_comments"        ].value = t.evaluation_aab.team_member_comments.value    
        snapshot.fields["supervisor_comments"         ].value = t.evaluation_aab.supervisor_comments.value     
        
        snapshot.save
        
    end
    
    def team_evaluation_engagement_metrics_snapshot(team_member_object)
        
        t = team_member_object
        
        t.evaluation_engagement_metrics.existing_record || t.evaluation_engagement_metrics.new_record.save
        
        snapshot_pid = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS_SNAPSHOT").primary_ids(
            "WHERE created_date REGEXP '#{$idate}'
            AND team_id = '#{t.primary_id.value}'"
        )
        
        if snapshot_pid
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS_SNAPSHOT").by_primary_id(snapshot_pid)
        else
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS_SNAPSHOT").new_row
        end
        
        snapshot.fields["team_id"                              ].value = t.evaluation_engagement_metrics.team_id.value 
        snapshot.fields["scantron_participation"               ].value = t.evaluation_engagement_metrics.scantron_participation.value 
        snapshot.fields["scantron_participation_sd"            ].value = t.evaluation_engagement_metrics.scantron_participation_sd.value 
        snapshot.fields["scantron_participation_dfn"           ].value = t.evaluation_engagement_metrics.scantron_participation_dfn.value 
        snapshot.fields["scantron_participation_attainable"    ].value = t.evaluation_engagement_metrics.scantron_participation_attainable.value 
        snapshot.fields["scantron_participation_comments"      ].value = t.evaluation_engagement_metrics.scantron_participation_comments.value 
        snapshot.fields["attendance"                           ].value = t.evaluation_engagement_metrics.attendance.value 
        snapshot.fields["attendance_sd"                        ].value = t.evaluation_engagement_metrics.attendance_sd.value 
        snapshot.fields["attendance_dfn"                       ].value = t.evaluation_engagement_metrics.attendance_dfn.value 
        snapshot.fields["attendance_attainable"                ].value = t.evaluation_engagement_metrics.attendance_attainable.value 
        snapshot.fields["attendance_comments"                  ].value = t.evaluation_engagement_metrics.attendance_comments.value 
        snapshot.fields["truancy_prevention"                   ].value = t.evaluation_engagement_metrics.truancy_prevention.value 
        snapshot.fields["truancy_prevention_sd"                ].value = t.evaluation_engagement_metrics.truancy_prevention_sd.value 
        snapshot.fields["truancy_prevention_dfn"               ].value = t.evaluation_engagement_metrics.truancy_prevention_dfn.value 
        snapshot.fields["truancy_prevention_attainable"        ].value = t.evaluation_engagement_metrics.truancy_prevention_attainable.value
        snapshot.fields["truancy_prevention_comments"          ].value = t.evaluation_engagement_metrics.truancy_prevention_comments.value
        snapshot.fields["evaluation_participation"             ].value = t.evaluation_engagement_metrics.evaluation_participation.value
        snapshot.fields["evaluation_participation_sd"          ].value = t.evaluation_engagement_metrics.evaluation_participation_sd.value
        snapshot.fields["evaluation_participation_dfn"         ].value = t.evaluation_engagement_metrics.evaluation_participation_dfn.value
        snapshot.fields["evaluation_participation_attainable"  ].value = t.evaluation_engagement_metrics.evaluation_participation_attainable.value
        snapshot.fields["evaluation_participation_comments"    ].value = t.evaluation_engagement_metrics.evaluation_participation_comments.value
        snapshot.fields["quality_documentation"                ].value = t.evaluation_engagement_metrics.quality_documentation.value
        snapshot.fields["quality_documentation_comments"       ].value = t.evaluation_engagement_metrics.quality_documentation_comments.value
        snapshot.fields["feedback"                             ].value = t.evaluation_engagement_metrics.feedback.value
        snapshot.fields["feedback_comments"                    ].value = t.evaluation_engagement_metrics.feedback_comments.value
        snapshot.fields["score"                                ].value = t.evaluation_engagement_metrics.score.value
        snapshot.fields["team_member_comments"                 ].value = t.evaluation_engagement_metrics.team_member_comments.value
        snapshot.fields["supervisor_comments"                  ].value = t.evaluation_engagement_metrics.supervisor_comments.value 
        
        snapshot.save
        
    end
    
    def team_evaluation_engagement_observation_snapshot(team_member_object)
        
        t = team_member_object
        
        t.evaluation_engagement_observation.existing_record || t.evaluation_engagement_observation.new_record.save
        
        snapshot_pid = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION_SNAPSHOT").primary_ids(
            "WHERE created_date REGEXP '#{$idate}'
            AND team_id = '#{t.primary_id.value}'"
        )
        
        if snapshot_pid
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION_SNAPSHOT").by_primary_id(snapshot_pid)
        else
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION_SNAPSHOT").new_row
        end
        
        snapshot.fields["team_id"                 ].value = t.evaluation_engagement_observation.team_id.value 
        snapshot.fields["rapport"                 ].value = t.evaluation_engagement_observation.rapport.value 
        snapshot.fields["knowledge"               ].value = t.evaluation_engagement_observation.knowledge.value 
        snapshot.fields["goal"                    ].value = t.evaluation_engagement_observation.goal.value 
        snapshot.fields["narrative"               ].value = t.evaluation_engagement_observation.narrative.value 
        snapshot.fields["obtaining_commitment"    ].value = t.evaluation_engagement_observation.obtaining_commitment.value 
        snapshot.fields["communication"           ].value = t.evaluation_engagement_observation.communication.value 
        snapshot.fields["documentation_followup"  ].value = t.evaluation_engagement_observation.documentation_followup.value 
        snapshot.fields["score"                   ].value = t.evaluation_engagement_observation.score.value 
        snapshot.fields["team_member_comments"    ].value = t.evaluation_engagement_observation.team_member_comments.value 
        snapshot.fields["supervisor_comments"     ].value = t.evaluation_engagement_observation.supervisor_comments.value 
        
        snapshot.save
        
    end
    
    def team_evaluation_engagement_professionalism_snapshot(team_member_object)
        
        t = team_member_object
        
        t.evaluation_engagement_professionalism.existing_record || t.evaluation_engagement_professionalism.new_record.save
        
        snapshot_pid = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM_SNAPSHOT").primary_ids(
            "WHERE created_date REGEXP '#{$idate}'
            AND team_id = '#{t.primary_id.value}'"
        )
        
        if snapshot_pid
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM_SNAPSHOT").by_primary_id(snapshot_pid)
        else
            snapshot = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM_SNAPSHOT").new_row
        end
        
        snapshot.fields["team_id"                        ].value = t.evaluation_engagement_professionalism.team_id.value 
        snapshot.fields["source_addresses_concerns"      ].value = t.evaluation_engagement_professionalism.source_addresses_concerns.value 
        snapshot.fields["source_collaboration"           ].value = t.evaluation_engagement_professionalism.source_collaboration.value 
        snapshot.fields["source_communication"           ].value = t.evaluation_engagement_professionalism.source_communication.value 
        snapshot.fields["source_execution"               ].value = t.evaluation_engagement_professionalism.source_execution.value 
        snapshot.fields["source_professional_development"].value = t.evaluation_engagement_professionalism.source_professional_development.value 
        snapshot.fields["source_meeting_contributions"   ].value = t.evaluation_engagement_professionalism.source_meeting_contributions.value 
        snapshot.fields["source_issue_escalation"        ].value = t.evaluation_engagement_professionalism.source_issue_escalation.value 
        snapshot.fields["source_sti"                     ].value = t.evaluation_engagement_professionalism.source_sti.value 
        snapshot.fields["source_meets_deadlines"         ].value = t.evaluation_engagement_professionalism.source_meets_deadlines.value 
        snapshot.fields["source_attends_events"          ].value = t.evaluation_engagement_professionalism.source_attends_events.value 
        snapshot.fields["score"                          ].value = t.evaluation_engagement_professionalism.score.value 
        snapshot.fields["team_member_comments"           ].value = t.evaluation_engagement_professionalism.team_member_comments.value 
        snapshot.fields["supervisor_comments"            ].value = t.evaluation_engagement_professionalism.supervisor_comments.value 
        
        snapshot.save
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUMMARY_UPDATE_PROCESS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def summary_update(team_member_object, summary_data_points = [])
        
        @processing     = Hash.new
        @processing[:t] = team_member_object
        
        if summary_data_points.nil? || summary_data_points.empty?
            
            @summary_data_points = Array.new
            
            @summary_data_points.push(
                
                "students",
                "retention_rate",
                "new",
                "in_year",
                "low_income",
                "tier_23",
                "special_ed",
                "grades_712",
                "scantron_participation_fall",
                "scantron_participation_spring",
                "scantron_growth_overall",
                "scantron_growth_math",
                "scantron_growth_reading",
                "attendance_rate",
                "all_students",
                "engagement_level",
                "aims_participation_fall",
                "aims_participation_spring",
                "aims_growth_overall",
                "keystone_participation",
                "pssa_participation"
                
            )
            
        else
            
            if summary_data_points.class == String
                
                @summary_data_points = summary_data_points.split(",")
                
            elsif summary_data_points.class == Array
                
                @summary_data_points = summary_data_points
                
            end
            
        end
        
        #SETUP SNAPSHOT INCLUDES RECORD
        if @processing[:t].evaluation_summary_snapshot_includes.by_snapshot_date($idate)
            
            @includes = @processing[:t].evaluation_summary_snapshot_includes
            
        else
            
            @processing[:t].evaluation_summary_snapshot_includes.new_record.save
            @processing[:t].evaluation_summary_snapshot_includes.by_snapshot_date($idate)
            @includes = @processing[:t].evaluation_summary_snapshot_includes
            
        end    
        
        if @processing[:t].enrolled_students
            
            @processing[:t].evaluation_summary.existing_record || @processing[:t].evaluation_summary.new_record.save
            
            @summary_data_points.each{|summary_data_point|
                
                send(summary_data_point)
                
            }
            
        end
        
    end
    
    def academic_metrics_update(team_member_object)
        
        @processing     = Hash.new
        @processing[:t] = team_member_object
        
        @processing[:t].evaluation_academic_metrics.existing_record || @processing[:t].evaluation_academic_metrics.new_record.save
        
        case @processing[:t].department_id.value
            
        when "3"
            
            #ASSESSMENT PERFORMANCE
            growth = @processing[:t].evaluation_summary.aims_growth_overall
            
            @processing[:t].evaluation_academic_metrics.assessment_performance.set(          
            a = growth.deviation_from_peer_group_norm(      max_score = 10)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_sd.set(          
                growth.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_dfn.set(          
                growth.deviation_from_peer_group_norm
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_attainable.set(          
                growth.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
            ).save
            
            #ASSESSMENT PARTICIPATION
            fall = @processing[:t].evaluation_summary.aims_participation_fall
            spng = @processing[:t].evaluation_summary.aims_participation_spring
            
            #FALL
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall.set(          
                b = fall.deviation_from_peer_group_norm(max_score = 5)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_sd.set(          
                fall.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_dfn.set(
                fall.deviation_from_peer_group_norm
            ).save
            
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_attainable.set(          
                fall.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
            ).save
            
            #SPRING
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring.set(          
                c = spng.deviation_from_peer_group_norm(max_score = 5)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_sd.set(          
                spng.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_dfn.set(
                spng.deviation_from_peer_group_norm
            ).save
            
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_attainable.set(          
                spng.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
            ).save
            
        when "2","6"
            
            #ASSESSMENT PERFORMANCE
            growth = @processing[:t].evaluation_summary.scantron_growth_overall
            
            @processing[:t].evaluation_academic_metrics.assessment_performance.set(          
            a = growth.deviation_from_peer_group_norm(      max_score = 10)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_sd.set(          
                growth.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_dfn.set(          
                growth.deviation_from_peer_group_norm
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_attainable.set(          
                growth.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
            ).save
            
            #ASSESSMENT PARTICIPATION
            fall = @processing[:t].evaluation_summary.scantron_participation_fall  
            spng = @processing[:t].evaluation_summary.scantron_participation_spring
            
            #FALL
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall.set(          
                b = fall.deviation_from_peer_group_norm(max_score = 5)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_sd.set(          
                fall.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_dfn.set(
                fall.deviation_from_peer_group_norm
            ).save
            
            @processing[:t].evaluation_academic_metrics.assessment_participation_fall_attainable.set(          
                fall.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
            ).save
            
            #SPRING
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring.set(          
                c = spng.deviation_from_peer_group_norm(max_score = 5)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_sd.set(          
                spng.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_dfn.set(
                spng.deviation_from_peer_group_norm
            ).save
            
            @processing[:t].evaluation_academic_metrics.assessment_participation_spring_attainable.set(          
                spng.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
            ).save
            
        when "5"
            
            role_details = @processing[:t].role_details
            course_row   = $tables.attach("course_relate").by_course_name(role_details.first) if role_details
                
            if course_row && (course_row.fields["scantron_growth_math"].value == "1" || course_row.fields["scantron_growth_reading"].value == "1")
                
                growth = @processing[:t].evaluation_summary.scantron_growth_overall
                
                @processing[:t].evaluation_academic_metrics.assessment_performance.set(          
                a = growth.deviation_from_peer_group_norm(      max_score = 10)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_performance_sd.set(          
                    growth.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_performance_dfn.set(          
                    growth.deviation_from_peer_group_norm
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_performance_attainable.set(          
                    growth.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
                ).save
                
                b = 0
                
            else
                
                fall = @processing[:t].evaluation_summary.scantron_participation_fall  
                spng = @processing[:t].evaluation_summary.scantron_participation_spring 
                
                #FALL
                @processing[:t].evaluation_academic_metrics.assessment_participation_fall.set(          
                    a = fall.deviation_from_peer_group_norm(max_score = 5)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_participation_fall_sd.set(          
                    fall.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_participation_fall_dfn.set(
                    fall.deviation_from_peer_group_norm
                ).save
                
                @processing[:t].evaluation_academic_metrics.assessment_participation_fall_attainable.set(          
                    fall.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
                ).save
                
                #SPRING
                @processing[:t].evaluation_academic_metrics.assessment_participation_spring.set(          
                    b = spng.deviation_from_peer_group_norm(max_score = 5)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_participation_spring_sd.set(          
                    spng.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
                ).save
                @processing[:t].evaluation_academic_metrics.assessment_participation_spring_dfn.set(
                    spng.deviation_from_peer_group_norm
                ).save
                
                @processing[:t].evaluation_academic_metrics.assessment_participation_spring_attainable.set(          
                    spng.deviation_from_peer_group_norm(nil, max_score_attainable_requested = true)
                ).save
                
            end
                
            #COURSE PASSING RATE
            c = @processing[:t].evaluation_summary.course_passing_rate.deviation_from_peer_group_norm( max_score = 10)
            
            @processing[:t].evaluation_academic_metrics.course_passing_rate.set(          
                c ? c : 0
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_sd.set(          
                c ? @processing[:t].evaluation_summary.course_passing_rate.deviation_from_peer_group_norm(          nil, nil, sd_only = true) : nil
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_dfn.set(          
                c ? @processing[:t].evaluation_summary.course_passing_rate.deviation_from_peer_group_norm   : nil
            ).save
            @processing[:t].evaluation_academic_metrics.assessment_performance_attainable.set(          
                c ? @processing[:t].evaluation_summary.course_passing_rate.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true) : nil
            ).save
            
        end
        
        #STUDY ISLAND PARTICIPATION
        @processing[:t].evaluation_academic_metrics.study_island_participation.set(          
            d = @processing[:t].evaluation_summary.study_island_participation.deviation_from_peer_group_norm(      max_score = 10)
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_participation_sd.set(          
            @processing[:t].evaluation_summary.study_island_participation.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_participation_dfn.set(          
            @processing[:t].evaluation_summary.study_island_participation.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_participation_attainable.set(          
            @processing[:t].evaluation_summary.study_island_participation.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
        ).save
        
        #STUDY ISLAND ACHEIVEMENT
        @processing[:t].evaluation_academic_metrics.study_island_achievement.set(          
            e = @processing[:t].evaluation_summary.study_island_achievement.deviation_from_peer_group_norm(      max_score = 10)
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_achievement_sd.set(          
            @processing[:t].evaluation_summary.study_island_achievement.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_achievement_dfn.set(          
            @processing[:t].evaluation_summary.study_island_achievement.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_academic_metrics.study_island_achievement_attainable.set(          
            @processing[:t].evaluation_summary.study_island_achievement.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
        ).save
        
        begin
            
            metrics_score =
            
            (a||0)+
            (b||0)+
            (c||0)+
            (d||0)+
            (e||0)
            
            @processing[:t].evaluation_academic_metrics.score.set(metrics_score).save
            
        rescue=>e
            
            $base.system_notification(
                subject = "Team Member Engagement Metrics - Score not calculated Team Member ID: #{@processing[:t].primary_id.value}",
                content = "Team Evaluation Snapshot - #{__FILE__} #{__LINE__} ERROR: #{e}"
            )
            
        end
        
    end
    
    def engagement_metrics_update(team_member_object)
        
        @processing     = Hash.new
        @processing[:t] = team_member_object
        
        @processing[:t].evaluation_engagement_metrics.existing_record || @processing[:t].evaluation_engagement_metrics.new_record.save
       
        #SCANTRON_PARTICIPATION FALL
        @processing[:t].evaluation_engagement_metrics.scantron_participation_fall.set(          
            a = @processing[:t].evaluation_summary.scantron_participation_fall.deviation_from_peer_group_norm(      max_score = 5)
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_fall_sd.set(          
            @processing[:t].evaluation_summary.scantron_participation_fall.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_fall_dfn.set(          
            @processing[:t].evaluation_summary.scantron_participation_fall.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_fall_attainable.set(          
            @processing[:t].evaluation_summary.scantron_participation_fall.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
        ).save
        
        #SCANTRON_PARTICIPATION SPRING
        @processing[:t].evaluation_engagement_metrics.scantron_participation_spring.set(          
            b = @processing[:t].evaluation_summary.scantron_participation_spring.deviation_from_peer_group_norm(      max_score = 5)
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_spring_sd.set(          
            @processing[:t].evaluation_summary.scantron_participation_spring.deviation_from_peer_group_norm(          nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_spring_dfn.set(          
            @processing[:t].evaluation_summary.scantron_participation_spring.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_engagement_metrics.scantron_participation_spring_attainable.set(          
            @processing[:t].evaluation_summary.scantron_participation_spring.deviation_from_peer_group_norm(          nil, max_score_attainable_requested = true)
        ).save
        
        #FNORD - REMOVE THIS ONCE THE POINT CHANGE IS IMPLEMENTED.
        c = @processing[:t].evaluation_engagement_metrics.attendance.mathable
        #FNORD TEMPORARILY OVERRIDDEN IN ORDER TO ALLOW FOR A WIDER POINT PREAD.
        ##ATTENDANCE
        #@processing[:t].evaluation_engagement_metrics.attendance.set(          
        #    c = @processing[:t].evaluation_summary.attendance_rate.deviation_from_peer_group_norm(                  max_score = 25)
        #).save
        #@processing[:t].evaluation_engagement_metrics.attendance_sd.set(          
        #    @processing[:t].evaluation_summary.attendance_rate.deviation_from_peer_group_norm(                      nil, nil, sd_only = true)
        #).save
        #@processing[:t].evaluation_engagement_metrics.attendance_dfn.set(          
        #    @processing[:t].evaluation_summary.attendance_rate.deviation_from_peer_group_norm
        #).save
        #@processing[:t].evaluation_engagement_metrics.attendance_attainable.set(          
        #    @processing[:t].evaluation_summary.attendance_rate.deviation_from_peer_group_norm(                      nil, max_score_attainable_requested = true)
        #).save
        
        #RETENTION_RATE
        @processing[:t].evaluation_engagement_metrics.truancy_prevention.set(
            d = @processing[:t].evaluation_summary.retention_rate.deviation_from_peer_group_norm(                   max_score = 10)
        ).save
        @processing[:t].evaluation_engagement_metrics.truancy_prevention_sd.set(          
            @processing[:t].evaluation_summary.retention_rate.deviation_from_peer_group_norm(                       nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_engagement_metrics.truancy_prevention_dfn.set(          
            @processing[:t].evaluation_summary.retention_rate.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_engagement_metrics.truancy_prevention_attainable.set(          
            @processing[:t].evaluation_summary.retention_rate.deviation_from_peer_group_norm(                       nil, max_score_attainable_requested = true)
        ).save
        
        #KEYSTONE PARTICIPATION
        @processing[:t].evaluation_engagement_metrics.keystone_participation.set(
            e = @processing[:t].evaluation_summary.keystone_participation.deviation_from_peer_group_norm(         max_score = 5)
        ).save
        @processing[:t].evaluation_engagement_metrics.keystone_participation_sd.set(          
            @processing[:t].evaluation_summary.keystone_participation.deviation_from_peer_group_norm(             nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_engagement_metrics.keystone_participation_dfn.set(          
            @processing[:t].evaluation_summary.keystone_participation.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_engagement_metrics.keystone_participation_attainable.set(          
            @processing[:t].evaluation_summary.keystone_participation.deviation_from_peer_group_norm(             nil, max_score_attainable_requested = true)
        ).save
        
        #PSSA PARTICIPATION
        @processing[:t].evaluation_engagement_metrics.pssa_participation.set(
            f = @processing[:t].evaluation_summary.pssa_participation.deviation_from_peer_group_norm(         max_score = 5)
        ).save
        @processing[:t].evaluation_engagement_metrics.pssa_participation_sd.set(          
            @processing[:t].evaluation_summary.pssa_participation.deviation_from_peer_group_norm(             nil, nil, sd_only = true)
        ).save
        @processing[:t].evaluation_engagement_metrics.pssa_participation_dfn.set(          
            @processing[:t].evaluation_summary.pssa_participation.deviation_from_peer_group_norm
        ).save
        @processing[:t].evaluation_engagement_metrics.pssa_participation_attainable.set(          
            @processing[:t].evaluation_summary.pssa_participation.deviation_from_peer_group_norm(             nil, max_score_attainable_requested = true)
        ).save
        
        g = @processing[:t].evaluation_engagement_metrics.quality_documentation.mathable   || 0
        h = @processing[:t].evaluation_engagement_metrics.feedback.mathable                || 0
        
        begin
            
            metrics_score =
            
            a+
            b+
            c+
            d+
            e+
            f+
            g+
            h
            
            @processing[:t].evaluation_engagement_metrics.score.set(metrics_score).save
            
        rescue=>e
            
            $base.system_notification(
                subject = "Team Member Engagement Metrics - Score not calculated SAMSID: #{sams_id}",
                content = "Team Evaluation Snapshot - #{__FILE__} #{__LINE__} ERROR: #{e}"
            )
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_type
        
        @processing[:t].department_record.fields["type"].value
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUMMARY_DATA_POINTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def aims_growth_overall
     
        if !@processing[:aims_growth_overall]
            
            if aims_growth_overall_eligible
                
                spring = $db.get_data_single(
                    "SELECT
                        primary_id
                    FROM student_aims_growth
                    WHERE spring_growth_overall IS NOT NULL"
                )
                
                season = spring ? "spring" : "winter"
                
                @processing[:aims_growth_overall] = @processing[:t].enrolled_students(
                    :eval_eligible                      => department_type,
                    :aims_exempt                        => false,
                    :aims_growth_overall_eligible       => season,
                    :aims_growth_overall                => season
                )
                aims_growth_overall = @processing[:aims_growth_overall] ? @processing[:aims_growth_overall].length.to_f / aims_growth_overall_eligible.length.to_f : 0.0
                
                @includes.aims_growth_overall.set(
                    
                    @processing[:aims_growth_overall] ? @processing[:aims_growth_overall].join(",") : nil
                    
                ).save
                
            else
                aims_growth_overall = nil
            end
            
            @processing[:t].evaluation_summary.aims_growth_overall.set(
                
                aims_growth_overall
                
            ).save if @summary_data_points.include?("aims_growth_overall")
            
        end
        
        @processing[:aims_growth_overall]
        
    end
    
    def aims_growth_overall_eligible
        
        if !@processing[:aims_growth_overall_eligible]
            
            spring = $db.get_data_single(
                "SELECT
                    primary_id
                FROM student_aims_growth
                WHERE spring_growth_overall IS NOT NULL"
            )
            
            season = spring ? "spring" : "winter"
            
            @processing[:aims_growth_overall_eligible] = @processing[:t].enrolled_students(
                :eval_eligible                  => department_type,
                :aims_exempt                    => false,
                :aims_growth_overall_eligible   => season
            )
            
            @includes.aims_growth_overall_eligible.set(
               
                @processing[:aims_growth_overall_eligible] ? @processing[:aims_growth_overall_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:aims_growth_overall_eligible]
        
    end
    
    def aims_participation_fall
        
        if !@processing[:aims_participation_fall]
            
            test_id         = 4
            test_event_id   = $tables.attach("TEST_EVENTS").primary_ids(
                "WHERE test_id = #{test_id}
                AND name REGEXP 'Fall'"
            )
            
            if test_event_id
                
                #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
                #@processing[:aims_participation_fall] = @processing[:t].enrolled_students(
                #    :eval_eligible                      => department_type,
                #    :aims_exempt                        => false,
                #    :student_test                       => test_id,
                #    :student_test_event                 => test_event_id[0],
                #    :student_test_participated          => test_id
                #)
                
                @processing[:aims_participation_fall] = @processing[:t].enrolled_students(
                    :eval_eligible              => department_type,
                    :participation_eligible     => "aims_fall",
                    :participation              => "aims_fall"
                )
              
                @processing[:t].evaluation_summary.aims_participation_fall.set(
                    
                    aims_participation_fall_eligible ? (@processing[:aims_participation_fall] ? @processing[:aims_participation_fall].length.to_f / aims_participation_fall_eligible.length.to_f : 0) : nil
                    
                ).save if @summary_data_points.include?("aims_participation_fall")
             
                @includes.aims_participation_fall.set(
                   
                    @processing[:aims_participation_fall] ? @processing[:aims_participation_fall].join(",") : nil
                    
                ).save
                
            end
            
        end
        
        @processing[:aims_participation_fall]
        
    end

    def aims_participation_fall_eligible
        
        if !@processing[:aims_participation_fall_eligible]
            
            test_id         = 4
            test_event_id   = $tables.attach("TEST_EVENTS").primary_ids(
                "WHERE test_id = #{test_id}
                AND name REGEXP 'Fall'"
            )
            
            if test_event_id
                
                #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
                #@processing[:aims_participation_fall_eligible] = @processing[:t].enrolled_students(
                #    :eval_eligible                   => department_type,
                #    :aims_exempt                     => false,
                #    :student_test                    => test_id,
                #    :student_test_event              => test_event_id[0]
                #)
                
                @processing[:aims_participation_fall_eligible] = @processing[:t].enrolled_students(
                    :eval_eligible          => department_type,
                    :participation_eligible => "aims_fall"
                )
                
                @includes.aims_participation_fall_eligible.set(
                   
                    @processing[:aims_participation_fall_eligible] ? @processing[:aims_participation_fall_eligible].join(",") : nil
                    
                ).save
                
            end
            
        end
        
        @processing[:aims_participation_fall_eligible]
        
    end
    
    def aims_participation_spring
        
        if !@processing[:aims_participation_spring]
            
            test_id         = 4
            test_event_id   = $tables.attach("TEST_EVENTS").primary_ids(
                "WHERE test_id = #{test_id}
                AND name REGEXP 'Spring'"
            )
            
            if test_event_id
                
                #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
                #@processing[:aims_participation_spring] = @processing[:t].enrolled_students(
                #    :eval_eligible                   => department_type,
                #    :aims_exempt                     => false,
                #    :student_test                    => test_id,
                #    :student_test_event              => test_event_id[0],
                #    :student_test_participated       => test_id
                #)
                
                @processing[:aims_participation_spring] = @processing[:t].enrolled_students(
                    :eval_eligible              => department_type,
                    :participation_eligible     => "aims_spring",
                    :participation              => "aims_spring"
                )
                
                @processing[:t].evaluation_summary.aims_participation_spring.set(
                    
                    aims_participation_spring_eligible ? (@processing[:aims_participation_spring] ? @processing[:aims_participation_spring].length.to_f / aims_participation_spring_eligible.length.to_f : 0) : nil
                    
                ).save if @summary_data_points.include?("aims_participation_spring")
             
                @includes.aims_participation_spring.set(
                   
                    @processing[:aims_participation_spring] ? @processing[:aims_participation_spring].join(",") : nil
                    
                ).save
                
            end
            
        end
        
        @processing[:aims_participation_spring]
        
    end

    def aims_participation_spring_eligible
        
        if !@processing[:aims_participation_spring_eligible]
            
            test_id         = 4
            test_event_id   = $tables.attach("TEST_EVENTS").primary_ids(
                "WHERE test_id = #{test_id}
                AND name REGEXP 'Spring'"
            )
            
            if test_event_id
                
                #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
                #@processing[:aims_participation_spring_eligible] = @processing[:t].enrolled_students(
                #    :eval_eligible      => department_type,
                #    :aims_exempt        => false,
                #    :student_test       => test_id,
                #    :student_test_event => test_event_id[0]
                #)
                
                @processing[:aims_participation_spring_eligible] = @processing[:t].enrolled_students(
                    :eval_eligible          => department_type,
                    :participation_eligible => "aims_spring"
                )
                
                @includes.aims_participation_spring_eligible.set(
                   
                    @processing[:aims_participation_spring_eligible] ? @processing[:aims_participation_spring_eligible].join(",") : nil
                    
                ).save
                
            end
            
        end
        
        @processing[:aims_participation_spring_eligible]
        
    end
    
    def all_students
        
        if !@processing[:all_students]
            
            @processing[:all_students] = @processing[:t].assigned_students(
                :eval_eligible  => department_type
            )
            
            if @summary_data_points.include?("all_students")
                
                @processing[:t].evaluation_summary.all_students.set(
                    
                    @processing[:all_students] ? @processing[:all_students].length : nil
                    
                ).save 
                
                @includes.all_students.set(
                    
                    @processing[:all_students] ? @processing[:all_students].join(",") : nil
                    
                ).save
                
            end
            
        end
        
        @processing[:all_students]
        
    end
    
    def attendance_rate
        
        if !@processing[:attendance_rate]
            
            last_school_day = $school.school_days(cutoff_date = $base.yesterday.to_db, order_option = "desc")[0]
            enrolled_days = @processing[:t].assigned_students(
                :eval_eligible  => department_type,
                :student_table  => "student_attendance",
                :table_field    => "official_code",
                :value_only     => true,
                :where_clause   => "WHERE official_code IS NOT NULL
                AND date < '#{last_school_day}'"
            )
           
            present_days = @processing[:t].assigned_students(
                :eval_eligible  => department_type,
                :student_table  => "student_attendance",
                :table_field    => "official_code",
                :value_only     => true,
                :where_clause   => "WHERE official_code IN(SELECT code FROM attendance_codes WHERE code_type = 'present')
                AND date < '#{last_school_day}'"
            )
            
            @processing[:t].evaluation_summary.attendance_rate.set(
                
                (present_days && enrolled_days) ? present_days.length.to_f/enrolled_days.length.to_f : nil
                
            ).save if @summary_data_points.include?("attendance_rate")
         
        end
        
        @processing[:attendance_rate]
        
    end
    
    def engagement_level
        
        if !@processing[:engagement_level]
            
            @processing[:engagement_level] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :engagement_eligible    => true,
                :student_table          => "student_assessment",
                :table_field            => "engagement_level",
                :value_only             => true
            )
            
            @processing[:t].evaluation_summary.engagement_level.set(
                
                @processing[:engagement_level] ? eval("#{@processing[:engagement_level].join(".to_f+")}.to_f")/@processing[:engagement_level].length.to_f : nil
                
            ).save if @summary_data_points.include?("engagement_level")
         
        end
        
        @processing[:engagement_level]
        
    end
    
    def grades_712
        
        if !@processing[:grades_712]
            
            @processing[:grades_712] = @processing[:t].enrolled_students(
                :eval_eligible  => department_type,
                :grade          => "7th|8th|9th|10th|11th|12th"
            )
            
            @processing[:t].evaluation_summary.grades_712.set(
                
                @processing[:grades_712] ? @processing[:grades_712].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("grades_712")
            
            @includes.grades_712.set(
               
                @processing[:grades_712] ? @processing[:grades_712].join(",") : nil
                
            ).save
            
        end
        
        @processing[:grades_712]
        
    end
    
    def in_year
        
        if !@processing[:in_year]
            
            @processing[:in_year] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :enrolled_after_date    => $school.current_school_year_start.value
            )
            
            @processing[:t].evaluation_summary.in_year.set(
                
                @processing[:in_year] ? @processing[:in_year].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("in_year")
            
            @includes.in_year.set(
               
                @processing[:in_year] ? @processing[:in_year].join(",") : nil
                
            ).save
            
        end
        
        @processing[:in_year]
        
    end
    
    def keystone_participation_eligible
        
        if !@processing[:keystone_participation_eligible]
            
            test_id         = 1
            
            #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
            #@processing[:keystone_participation_eligible] = @processing[:t].enrolled_students(
            #    :eval_eligible      => department_type,
            #    :student_test       => test_id
            #)
            
            @processing[:keystone_participation_eligible] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :participation_eligible => "keystone"
            )
            
            @includes.keystone_participation_eligible.set(
               
                @processing[:keystone_participation_eligible] ? @processing[:keystone_participation_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:keystone_participation_eligible]
        
    end
    
    def keystone_participation
        
        if !@processing[:keystone_participation]
            
            test_id         = 1
            
            #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
            #@processing[:keystone_participation] = @processing[:t].enrolled_students(
            #    :eval_eligible              => department_type,
            #    :student_test               => test_id,
            #    :student_test_participated  => test_id
            #)
            
            @processing[:keystone_participation] = @processing[:t].enrolled_students(
                :eval_eligible              => department_type,
                :participation_eligible     => "keystone",
                :participation              => "keystone"
            )
            
            @processing[:t].evaluation_summary.keystone_participation.set(
                
                keystone_participation_eligible ? (@processing[:keystone_participation] ? @processing[:keystone_participation].length.to_f / keystone_participation_eligible.length.to_f : 0) : nil
                
            ).save if @summary_data_points.include?("keystone_participation")
         
            @includes.keystone_participation.set(
               
                @processing[:keystone_participation] ? @processing[:keystone_participation].join(",") : nil
                
            ).save
            
        end
        
        @processing[:keystone_participation]
        
    end
    
    def pssa_participation_eligible
        
        if !@processing[:pssa_participation_eligible]
            
            test_id         = 2
            
            #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
            #@processing[:pssa_participation_eligible] = @processing[:t].enrolled_students(
            #    :eval_eligible      => department_type,
            #    :student_test       => test_id
            #)
            
            @processing[:pssa_participation_eligible] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :participation_eligible => "pssa"
            )
            
            @includes.pssa_participation_eligible.set(
               
                @processing[:pssa_participation_eligible] ? @processing[:pssa_participation_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:pssa_participation_eligible]
        
    end
    
    def pssa_participation
        
        if !@processing[:pssa_participation]
            
            test_id         = 2
            
            #FNORD - TEMPORARILY REMOVED IN ORDER TO USE DAN's HAND PICK NUMBERS
            #@processing[:pssa_participation] = @processing[:t].enrolled_students(
            #    :eval_eligible              => department_type,
            #    :student_test               => test_id,
            #    :student_test_participated  => test_id
            #)
            
            @processing[:pssa_participation] = @processing[:t].enrolled_students(
                :eval_eligible              => department_type,
                :participation_eligible     => "pssa",
                :participation              => "pssa"
            )
            
            @processing[:t].evaluation_summary.pssa_participation.set(
                
                pssa_participation_eligible ? (@processing[:pssa_participation] ? @processing[:pssa_participation].length.to_f / pssa_participation_eligible.length.to_f : 0) : nil
                
            ).save if @summary_data_points.include?("pssa_participation")
            
            @includes.pssa_participation.set(
               
                @processing[:pssa_participation] ? @processing[:pssa_participation].join(",") : nil
                
            ).save if @summary_data_points.include?("pssa_participation")
            
        end
        
        @processing[:pssa_participation]
        
    end
    
    def low_income
        
        if !@processing[:low_income]
            
            @processing[:low_income] = @processing[:t].enrolled_students(
                :eval_eligible  => department_type,
                :free_reduced   => true
            )
            
            @processing[:t].evaluation_summary.low_income.set(
                
                @processing[:low_income] ? @processing[:low_income].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("low_income")
            
            @includes.low_income.set(
               
                @processing[:low_income] ? @processing[:low_income].join(",") : nil
                
            ).save
            
        end
        
        @processing[:low_income]
        
    end
    
    def new
        
        if !@processing[:new]
            
            @processing[:new] = @processing[:t].enrolled_students(
                :eval_eligible      => department_type,
                :new_students_only  => true
            )
            
            @processing[:t].evaluation_summary.new.set(
                
                @processing[:new] ? @processing[:new].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("new")
            
            @includes.new.set(
               
                @processing[:new] ? @processing[:new].join(",") : nil
                
            ).save
            
        end
        
        @processing[:new]
        
    end
    
    def retention_rate
        
        if !@processing[:retention_rate]
            
            if withdrawn_students
                
                not_qualifying                  = withdrawn_students_not_qualifying ? withdrawn_students_not_qualifying.length.to_f : 0.0
                retained_student_set            = not_qualifying+students.length.to_f
                complete_student_set            = not_qualifying+withdrawn_students.length.to_f+students.length.to_f
                @processing[:retention_rate]    = retained_student_set/complete_student_set
                
            else
                
                @processing[:retention_rate]    = 1
                
            end
            
            @processing[:t].evaluation_summary.retention_rate.set(
                
                @processing[:retention_rate]
                
            ).save if @summary_data_points.include?("retention_rate")
         
        end
        
        @processing[:retention_rate]
        
    end
    
    def scantron_growth_math
     
        if !@processing[:scantron_growth_math]
            
            subjects = ["math"]
            
            if scantron_growth_math_eligible
                
                @processing[:scantron_growth_math] = @processing[:t].enrolled_students(
                    :eval_eligible              => department_type,
                    :scantron_eligible          => ["ent_m","ext_m"],
                    :scantron_growth_eligible   => subjects,
                    :scantron_growth            => subjects
                )
                scantron_growth_avg = @processing[:scantron_growth_math] ? @processing[:scantron_growth_math].length.to_f / scantron_growth_math_eligible.length.to_f : 0.0
                
                @includes.scantron_growth_math.set(
                    
                    @processing[:scantron_growth_math] ? @processing[:scantron_growth_math].join(",") : nil
                    
                ).save
                
            else
                scantron_growth_avg = nil
            end
            
            @processing[:t].evaluation_summary.scantron_growth_math.set(
                
                scantron_growth_avg
                
            ).save if @summary_data_points.include?("scantron_growth_math")
            
        end
        
        @processing[:scantron_growth_math]
        
    end
    
    def scantron_growth_math_eligible
        
        if !@processing[:scantron_growth_math_eligible]
            
            @processing[:scantron_growth_math_eligible] = @processing[:t].enrolled_students(
                :eval_eligible              => department_type,
                :scantron_eligible          => ["ent_m","ext_m"],
                :scantron_growth_eligible   => ["math"]
            )
            
            @includes.scantron_growth_math_eligible.set(
               
                @processing[:scantron_growth_math_eligible] ? @processing[:scantron_growth_math_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_growth_math_eligible]
        
    end
    
    def scantron_growth_overall
     
        if !@processing[:scantron_growth_overall]
            
            subjects = ["math","reading"]
            
            if scantron_growth_overall_eligible
                
                @processing[:scantron_growth_overall] = @processing[:t].enrolled_students(
                    :eval_eligible              => department_type,
                    :scantron_eligible          => ["ent_m","ext_m","ent_r","ext_r"],
                    :scantron_growth_eligible   => subjects,
                    :scantron_growth            => subjects
                )
                scantron_growth_avg = @processing[:scantron_growth_overall] ? @processing[:scantron_growth_overall].length.to_f / scantron_growth_overall_eligible.length.to_f : 0.0
                
                @includes.scantron_growth_overall.set(
                    
                    @processing[:scantron_growth_overall] ? @processing[:scantron_growth_overall].join(",") : nil
                    
                ).save
                
            else
                scantron_growth_avg = nil
            end
            
            @processing[:t].evaluation_summary.scantron_growth_overall.set(
                
                scantron_growth_avg
                
            ).save if @summary_data_points.include?("scantron_growth_overall")
            
        end
        
        @processing[:scantron_growth_overall]
        
    end
    
    def scantron_growth_overall_eligible
        
        if !@processing[:scantron_growth_overall_eligible]
            
            @processing[:scantron_growth_overall_eligible] = @processing[:t].enrolled_students(
                :eval_eligible              => department_type,
                :scantron_eligible          => ["ent_m","ext_m","ent_r","ext_r"],
                :scantron_growth_eligible   => ["math","reading"]
            )
            
            @includes.scantron_growth_overall_eligible.set(
               
                @processing[:scantron_growth_overall_eligible] ? @processing[:scantron_growth_overall_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_growth_overall_eligible]
        
    end
    
    def scantron_growth_reading
     
        if !@processing[:scantron_growth_reading]
            
            subjects = ["reading"]
            
            if scantron_growth_reading_eligible
                
                @processing[:scantron_growth_reading] = @processing[:t].enrolled_students(
                    :eval_eligible              => department_type,
                    :scantron_eligible          => ["ent_r","ext_r"],
                    :scantron_growth_eligible   => subjects,
                    :scantron_growth            => subjects
                )
                scantron_growth_avg = @processing[:scantron_growth_reading] ? @processing[:scantron_growth_reading].length.to_f / scantron_growth_reading_eligible.length.to_f : 0.0
                
                @includes.scantron_growth_reading.set(
                    
                    @processing[:scantron_growth_reading] ? @processing[:scantron_growth_reading].join(",") : nil
                    
                ).save
                
            else
                scantron_growth_avg = nil
            end
            
            @processing[:t].evaluation_summary.scantron_growth_reading.set(
                
                scantron_growth_avg
                
            ).save if @summary_data_points.include?("scantron_growth_reading")
            
        end
        
        @processing[:scantron_growth_reading]
        
    end
    
    def scantron_growth_reading_eligible
        
        if !@processing[:scantron_growth_reading_eligible]
            
            @processing[:scantron_growth_reading_eligible] = @processing[:t].enrolled_students(
                :eval_eligible              => department_type,
                :scantron_eligible          => ["ent_r","ext_r"],
                :scantron_growth_eligible   => ["reading"]
            )
            
            @includes.scantron_growth_reading_eligible.set(
               
                @processing[:scantron_growth_reading_eligible] ? @processing[:scantron_growth_reading_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_growth_reading_eligible]
        
    end
    
    def scantron_participation_fall
     
    #FNORD - Temporarily override this process to keep Joel's numbers   
    unless department_type == "Academic"
        
        if !@processing[:scantron_participation_fall]
            
            @processing[:scantron_participation_fall] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :scantron_eligible      => ["ent_m","ent_r"],
                :scantron_participated  => ["stron_ent_perf_m","stron_ent_perf_r"]
            )
            
            @processing[:t].evaluation_summary.scantron_participation_fall.set(
                
                scantron_participation_fall_eligible ? (@processing[:scantron_participation_fall] ? @processing[:scantron_participation_fall].length.to_f / scantron_participation_fall_eligible.length.to_f : 0) : nil
                
            ).save if @summary_data_points.include?("scantron_participation_fall")
         
            @includes.scantron_participation_fall.set(
               
                @processing[:scantron_participation_fall] ? @processing[:scantron_participation_fall].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_participation_fall]
        
    end
        
    end
    
    def scantron_participation_fall_eligible
        
        if !@processing[:scantron_participation_fall_eligible]
            
            @processing[:scantron_participation_fall_eligible] = @processing[:t].enrolled_students(
                :eval_eligible      => department_type,
                :scantron_eligible  => ["ent_m","ent_r"]
            )
            
            @includes.scantron_participation_fall_eligible.set(
               
                @processing[:scantron_participation_fall_eligible] ? @processing[:scantron_participation_fall_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_participation_fall_eligible]
        
    end
    
    def scantron_participation_spring
        
        if !@processing[:scantron_participation_spring]
            
            @processing[:scantron_participation_spring] = @processing[:t].enrolled_students(
                :eval_eligible          => department_type,
                :scantron_eligible      => ["ext_m","ext_r"],
                :scantron_participated  => ["stron_ext_perf_m","stron_ext_perf_r"]
            )
            
            @processing[:t].evaluation_summary.scantron_participation_spring.set(
                
                scantron_participation_spring_eligible ? (@processing[:scantron_participation_spring] ? @processing[:scantron_participation_spring].length.to_f / scantron_participation_spring_eligible.length.to_f : 0) : nil
                
            ).save if @summary_data_points.include?("scantron_participation_spring")
         
            @includes.scantron_participation_spring.set(
               
                @processing[:scantron_participation_spring] ? @processing[:scantron_participation_spring].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_participation_spring]
        
    end

    def scantron_participation_spring_eligible
        
        if !@processing[:scantron_participation_spring_eligible]
            
            @processing[:scantron_participation_spring_eligible] = @processing[:t].enrolled_students(
                :eval_eligible      => department_type,
                :scantron_eligible  => ["ext_m","ext_r"]
            )
            
            @includes.scantron_participation_spring_eligible.set(
               
                @processing[:scantron_participation_spring_eligible] ? @processing[:scantron_participation_spring_eligible].join(",") : nil
                
            ).save
            
        end
        
        @processing[:scantron_participation_spring_eligible]
        
    end
    
    def state_test_participation_eligible
        
    end
    
    #def state_test_participation #FNORD - THIS IS A TEMPORARY MEASURE TO GET US THROUGH UNTIL TEST EVENT PARTICIPATION IS WORKED OUT.
    #    
    #    if !@processing[:state_test_participation]
    #        
    #        #@processing[:state_test_participation] = @processing[:t].enrolled_students(:keystone_eligible=>true, :keystone_participated=>true)
    #        
    #        @processing[:t].evaluation_summary.state_test_participation.set(
    #            
    #            keystone_eligible ? (keystone_participated ? keystone_participated.length.to_f / keystone_eligible.length.to_f : 0) : nil
    #            
    #        ).save if @summary_data_points.include?("state_test_participation")
    #     
    #    end
    #    
    #    @processing[:state_test_participation]
    #    
    #end
    
    def special_ed
        
        if !@processing[:special_ed]
            
            @processing[:special_ed] = @processing[:t].enrolled_students(
                :eval_eligible  => department_type,
                :special_ed     => true
            )
            
            @processing[:t].evaluation_summary.special_ed.set(
                
                @processing[:special_ed] ? @processing[:special_ed].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("special_ed")
            
            @includes.special_ed.set(
               
                @processing[:special_ed] ? @processing[:special_ed].join(",") : nil
                
            ).save
            
        end
        
        @processing[:special_ed]
        
    end
    
    def students
        
        if !@processing[:students]
            
            @processing[:students] = @processing[:t].enrolled_students(
                :eval_eligible  => department_type
            )
            
            @processing[:t].evaluation_summary.students.set(
                
                @processing[:students] ? @processing[:students].length : nil
                
            ).save if @summary_data_points.include?("students")
            
            @includes.students.set(
               
                @processing[:students] ? @processing[:students].join(",") : nil
                
            ).save
            
        end
        
        @processing[:students]
        
    end
    
    def tier_23
        
        if !@processing[:tier_23]
            
            @processing[:tier_23] = @processing[:t].enrolled_students(
                :eval_eligible  => department_type,
                :tier           => "Tier 2|Tier 3"
            )
            
            @processing[:t].evaluation_summary.tier_23.set(
                
                @processing[:tier_23] ? @processing[:tier_23].length.to_f/students.length.to_f : nil
                
            ).save if @summary_data_points.include?("tier_23")
            
            @includes.tier_23.set(
               
                @processing[:tier_23] ? @processing[:tier_23].join(",") : nil
                
            ).save
            
        end
        
        @processing[:tier_23]
        
    end
    
    def withdrawn_students_not_qualifying
        
        if !@processing[:withdrawn_students_not_qualifying]
            
            @processing[:withdrawn_students_not_qualifying] = @processing[:t].assigned_students(
                :eval_eligible              => department_type,
                :withdrawal_codes_excluded  => 
                [
                    
                    "6" ,        #Student illegally absent (10 consecutive days) & compulsory attendance is not being pursued	
                    "7" ,        #Issued General Employment Certificate	                                                        
                    "12",        #Committed to correctional institution	                                                        
                    "13",        #Enlisted in military service	                                                                
                    "17",        #Expelled	                                                                                        
                    "24",        #Over 17 and voluntarily leaving school after passing required attendance age (17 or older)	        
                    "25",        #Under 17 and not continuing education at this time and has discussed options with Agora Personnel	
                    "26",        #Plan to pursue GED	                                                                                
                    "27",        #Runaway or Student No Longer at Residence	                                                        
                    "28"         #Whereabouts of family unknown (Residency Compliance)   
                    
                ]
              
            )
         
        end
        
        @processing[:withdrawn_students_not_qualifying]
        
    end
    
    def withdrawn_students
        
        if !@processing[:withdrawn_students]
            
            @processing[:withdrawn_students] = @processing[:t].assigned_students(
                :eval_eligible              => department_type,
                :withdrawal_codes_included  => [  
                    "6" ,        #Student illegally absent (10 consecutive days) & compulsory attendance is not being pursued	
                    "7" ,        #Issued General Employment Certificate	                                                        
                    "12",        #Committed to correctional institution	                                                        
                    "13",        #Enlisted in military service	                                                                
                    "17",        #Expelled	                                                                                        
                    "24",        #Over 17 and voluntarily leaving school after passing required attendance age (17 or older)	        
                    "25",        #Under 17 and not continuing education at this time and has discussed options with Agora Personnel	
                    "26",        #Plan to pursue GED	                                                                                
                    "27",        #Runaway or Student No Longer at Residence	                                                        
                    "28"         #Whereabouts of family unknown (Residency Compliance)   
                    
                ]
            )
            
            @includes.withdrawn.set(
               
                @processing[:withdrawn_students] ? @processing[:withdrawn_students].join(",") : nil
                
            ).save
            
        end
        
        @processing[:withdrawn_students]
        
    end
    
end

##FNORD - MAKE SURE TO COMMENT THIS OUT AFTER TESTING
#p = Team_Evaluations_Summary_Update.new
#
#sams_ids             = nil
#summary_data_points  = nil
##[
##  "scantron_growth_overall",
##  "scantron_growth_math",
##  "scantron_growth_reading"
##]
#
#sams_ids = sams_ids || $team.related_to_students
#sams_ids.each{|sams_id|
#    
#    t = $team.by_sams_id(sams_id)
#    if t && t.department_record && !t.peer_group_id.value.nil?
#        
#        p.summary_update(t, summary_data_points)
#        
#        if t.department_record.fields["type"].value == "Engagement"
#            
#            p.engagement_metrics_update(t)
#            #p.team_evaluation_summary_snapshot(                     t)
#            #p.team_evaluation_aab_snapshot(              t)
#            #p.team_evaluation_engagement_metrics_snapshot(          t)
#            #p.team_evaluation_engagement_observation_snapshot(      t)
#            #p.team_evaluation_engagement_professionalism_snapshot(  t)
#            
#        end
#        
#    end
#    
#}
#
#p.peer_group_evaluation_summary_snapshot
#p.department_evaluation_summary_snapshot