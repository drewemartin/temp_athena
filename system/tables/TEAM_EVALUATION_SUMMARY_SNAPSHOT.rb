#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_SUMMARY_SNAPSHOT < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def by_team_id(team_id, snapshot_date = nil) #Returns either the most recent or the record for snapshot date if passed
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("team_id",        "=",         team_id) )
        params.push( Struct::WHERE_PARAMS.new("created_date",   "REGEXP",    snapshot_date) ) if snapshot_date
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY created_date DESC"
        record(where_clause)
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def before_load_team_evaluation_summary_snapshot(tids = nil, summary_data_points = nil) 
        
        start = Time.new
        
        notify_samsids = Array.new
        
        require "#{File.dirname(__FILE__).gsub("tables","data_processing")}/team_evaluations_summary_update"
        p = Team_Evaluations_Summary_Update.new
        
        tids = $team.filter(:active_students=>true,:where_addon=>"AND department_id IS NOT NULL") if !tids
        
        #UPDATE EVERYONE'S SUMMARY AND TAKE SNAPSHOTS OF EVERYTHING OTHER THAN METRICS
        tids.each{|tid|
            
            t = $team.get(tid)
            if t && t.department_record && !t.peer_group_id.value.nil?
                
                puts "PROCESSING SUMMARY AND SNAPSHOTS: #{tid}"
                
                p.summary_update(t, summary_data_points)
                #p.snapshot(team_member_object = t, table_name = "team"                                          )
                p.snapshot(team_member_object = t, table_name = "team_evaluation_summary"                       )
                p.snapshot(team_member_object = t, table_name = "team_evaluation_aab"                           )
                
                if t.department_record.fields["type"].value == "Engagement"
                    
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_engagement_observation"    )
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_engagement_professionalism")
                    
                elsif t.department_record.fields["type"].value == "Academic"
                    
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_academic_instruction"      )
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_academic_professionalism"  )
                    
                end
                
            else
                
                notify_samsids.push(tid)
                
            end
            
        } if tids
        
        #UPDATE EVERYONE'S METRICS AND TAKE A METRICS SNAPSHOT
        tids.each{|tid|
            
            t = $team.get(tid)
            if t && t.department_record && !t.peer_group_id.value.nil?
                
                puts "PROCESSING METRICS AND METRICS SNAPSHOT: #{tid}"
                
                if t.department_record.fields["type"].value == "Engagement"
                    
                    p.engagement_metrics_update(t)
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_engagement_metrics"        )
                    
                elsif t.department_record.fields["type"].value == "Academic"
                    
                    p.academic_metrics_update(t)
                    p.snapshot(team_member_object = t, table_name = "team_evaluation_academic_metrics"          )
                    
                end
                
            else
                
                notify_samsids.push(tid)
                
            end
            
        } if tids
        
        p.peer_group_evaluation_summary_snapshot
        p.department_evaluation_summary_snapshot
        
        if !notify_samsids.empty?
            
            $base.system_notification(
                subject = "Team Evaluations Issue",
                content = $base.web_tools.table(
                    :table_array    => notify_samsids.insert(0,["Issue","SAMS ID"]),
                    :unique_name    => "team_evaluation_issues",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
            )
            
        end
        
        puts "#TEAM EVALUATION UPDATE COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
        continue_with_load = false
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "team_evaluation_summary_snapshot",
                "file_name"         => "team_evaluation_summary_snapshot.csv",
                "file_location"     => "team_evaluation_summary_snapshot",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["team_id"                                  ] = {"data_type"=>"int",                "file_field"=>"team_id"                                 } if field_order.push("team_id")
            structure_hash["fields"]["students"                                 ] = {"data_type"=>"int",                "file_field"=>"students"                                } if field_order.push("students")
            structure_hash["fields"]["all_students"                             ] = {"data_type"=>"int",                "file_field"=>"all_students"                            } if field_order.push("all_students")
            structure_hash["fields"]["new"                                      ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"new"                                     } if field_order.push("new")
            structure_hash["fields"]["in_year"                                  ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"in_year"                                 } if field_order.push("in_year")
            structure_hash["fields"]["low_income"                               ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"low_income"                              } if field_order.push("low_income")
            structure_hash["fields"]["tier_23"                                  ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"tier_23"                                 } if field_order.push("tier_23")
            structure_hash["fields"]["special_ed"                               ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"special_ed"                              } if field_order.push("special_ed")
            structure_hash["fields"]["grades_712"                               ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"grades_712"                              } if field_order.push("grades_712")
            structure_hash["fields"]["scantron_participation_fall"              ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"scantron_participation_fall"             } if field_order.push("scantron_participation_fall")
            structure_hash["fields"]["scantron_participation_spring"            ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"scantron_participation_spring"           } if field_order.push("scantron_participation_spring")
            structure_hash["fields"]["scantron_growth_overall"                  ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"scantron_growth_overall"                 } if field_order.push("scantron_growth_overall")
            structure_hash["fields"]["scantron_growth_math"                     ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"scantron_growth_math"                    } if field_order.push("scantron_growth_math")
            structure_hash["fields"]["scantron_growth_reading"                  ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"scantron_growth_reading"                 } if field_order.push("scantron_growth_reading")
            structure_hash["fields"]["aims_participation_fall"                  ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"aims_participation_fall"                 } if field_order.push("aims_participation_fall")
            structure_hash["fields"]["aims_participation_spring"                ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"aims_participation_spring"               } if field_order.push("aims_participation_spring")
            structure_hash["fields"]["aims_growth_overall"                      ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"aims_growth_overall"                     } if field_order.push("aims_growth_overall")
            structure_hash["fields"]["study_island_participation"               ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"study_island_participation"              } if field_order.push("study_island_participation")
            structure_hash["fields"]["study_island_participation_tier_23"       ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"study_island_participation_tier_23"      } if field_order.push("study_island_participation_tier_23")
            structure_hash["fields"]["study_island_achievement"                 ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"study_island_achievement"                } if field_order.push("study_island_achievement")
            structure_hash["fields"]["study_island_achievement_tier_23"         ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"study_island_achievement_tier_23"        } if field_order.push("study_island_achievement_tier_23")
            structure_hash["fields"]["define_u_participation"                   ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"define_u_participation"                  } if field_order.push("define_u_participation")
            structure_hash["fields"]["pssa_participation"                       ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"pssa_participation"                      } if field_order.push("pssa_participation")
            structure_hash["fields"]["keystone_participation"                   ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"keystone_participation"                  } if field_order.push("keystone_participation")
            structure_hash["fields"]["attendance_rate"                          ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"attendance_rate"                         } if field_order.push("attendance_rate")
            structure_hash["fields"]["retention_rate"                           ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"retention_rate"                          } if field_order.push("retention_rate")
            structure_hash["fields"]["engagement_level"                         ] = {"data_type"=>"decimal(10,2)",      "file_field"=>"engagement_level"                        } if field_order.push("engagement_level")
            structure_hash["fields"]["course_passing_rate"                      ] = {"data_type"=>"decimal(10,2)",      "file_field"=>"course_passing_rate"                     } if field_order.push("course_passing_rate")
            structure_hash["fields"]["score"                                    ] = {"data_type"=>"decimal(10,2)",      "file_field"=>"score"                                   } if field_order.push("score")
            structure_hash["fields"]["goal_1"                                   ] = {"data_type"=>"text",               "file_field"=>"goal_1"                                  } if field_order.push("goal_1")
            structure_hash["fields"]["goal_2"                                   ] = {"data_type"=>"text",               "file_field"=>"goal_2"                                  } if field_order.push("goal_2")
            structure_hash["fields"]["goal_3"                                   ] = {"data_type"=>"text",               "file_field"=>"goal_3"                                  } if field_order.push("goal_3")
            structure_hash["fields"]["team_member_comments"                     ] = {"data_type"=>"text",               "file_field"=>"team_member_comments"                    } if field_order.push("team_member_comments")
            structure_hash["fields"]["supervisor_comments"                      ] = {"data_type"=>"text",               "file_field"=>"supervisor_comments"                     } if field_order.push("supervisor_comments")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end