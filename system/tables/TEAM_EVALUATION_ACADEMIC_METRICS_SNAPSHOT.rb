#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_ACADEMIC_METRICS_SNAPSHOT < Athena_Table
    
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
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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
                "name"              => "team_evaluation_academic_metrics_snapshot",
                "file_name"         => "team_evaluation_academic_metrics_snapshot.csv",
                "file_location"     => "team_evaluation_academic_metrics_snapshot",
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
        
            structure_hash["fields"]["team_id"                                          ] = {"data_type"=>"int",            "file_field"=>"team_id"                                             } if field_order.push("team_id"                                 )
            
            structure_hash["fields"]["source_data"                                      ] = {"data_type"=>"bool",           "file_field"=>"source_data"                                         } if field_order.push("source_data"                                     )
            
            structure_hash["fields"]["assessment_performance"                           ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_performance"                              } if field_order.push("assessment_performance"                          )
            structure_hash["fields"]["assessment_performance_sd"                        ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_performance_sd"                           } if field_order.push("assessment_performance_sd"                       )
            structure_hash["fields"]["assessment_performance_dfn"                       ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_performance_dfn"                          } if field_order.push("assessment_performance_dfn"                      )
            structure_hash["fields"]["assessment_performance_attainable"                ] = {"data_type"=>"bool",           "file_field"=>"assessment_performance_attainable"                   } if field_order.push("assessment_performance_attainable"               )
            
            structure_hash["fields"]["assessment_participation_fall"                    ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_fall"                       } if field_order.push("assessment_participation_fall"                   )
            structure_hash["fields"]["assessment_participation_fall_sd"                 ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_fall_sd"                    } if field_order.push("assessment_participation_fall_sd"                )
            structure_hash["fields"]["assessment_participation_fall_dfn"                ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_fall_dfn"                   } if field_order.push("assessment_participation_fall_dfn"               )
            structure_hash["fields"]["assessment_participation_fall_attainable"         ] = {"data_type"=>"bool",           "file_field"=>"assessment_participation_fall_attainable"            } if field_order.push("assessment_participation_fall_attainable"        )
          
            structure_hash["fields"]["assessment_participation_spring"                  ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_spring"                     } if field_order.push("assessment_participation_spring"                 )
            structure_hash["fields"]["assessment_participation_spring_sd"               ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_spring_sd"                  } if field_order.push("assessment_participation_spring_sd"              )
            structure_hash["fields"]["assessment_participation_spring_dfn"              ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"assessment_participation_spring_dfn"                 } if field_order.push("assessment_participation_spring_dfn"             )
            structure_hash["fields"]["assessment_participation_spring_attainable"       ] = {"data_type"=>"bool",           "file_field"=>"assessment_participation_spring_attainable"          } if field_order.push("assessment_participation_spring_attainable"      )
            
            structure_hash["fields"]["course_passing_rate"                              ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"course_passing_rate"                                 } if field_order.push("course_passing_rate"                             )
            structure_hash["fields"]["course_passing_rate_sd"                           ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"course_passing_rate_sd"                              } if field_order.push("course_passing_rate_sd"                          )
            structure_hash["fields"]["course_passing_rate_dfn"                          ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"course_passing_rate_dfn"                             } if field_order.push("course_passing_rate_dfn"                         )
            structure_hash["fields"]["course_passing_rate_attainable"                   ] = {"data_type"=>"bool",           "file_field"=>"course_passing_rate_attainable"                      } if field_order.push("course_passing_rate_attainable"                  )
         
            structure_hash["fields"]["study_island_participation"                       ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_participation"                        } if field_order.push("study_island_participation"                      )
            structure_hash["fields"]["study_island_participation_sd"                    ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_participation_sd"                     } if field_order.push("study_island_participation_sd"                   )
            structure_hash["fields"]["study_island_participation_dfn"                   ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_participation_dfn"                    } if field_order.push("study_island_participation_dfn"                  )
            structure_hash["fields"]["study_island_participation_attainable"            ] = {"data_type"=>"bool",           "file_field"=>"student_island_participation_attainable"             } if field_order.push("study_island_participation_attainable"           )
         
            structure_hash["fields"]["study_island_achievement"                         ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_achievement"                          } if field_order.push("study_island_achievement"                        )
            structure_hash["fields"]["study_island_achievement_sd"                      ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_achievement_sd"                       } if field_order.push("study_island_achievement_sd"                     )
            structure_hash["fields"]["study_island_achievement_dfn"                     ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"student_island_achievement_dfn"                      } if field_order.push("study_island_achievement_dfn"                    )
            structure_hash["fields"]["study_island_achievement_attainable"              ] = {"data_type"=>"bool",           "file_field"=>"student_island_achievement_attainable"               } if field_order.push("study_island_achievement_attainable"             )
          
            structure_hash["fields"]["score"                                            ] = {"data_type"=>"decimal(10,2)",  "file_field"=>"score"                                               } if field_order.push("score"                                           )
           
            structure_hash["fields"]["team_member_comments"                             ] = {"data_type"=>"text",           "file_field"=>"team_member_comments"                                } if field_order.push("team_member_comments"                            )
            structure_hash["fields"]["supervisor_comments"                              ] = {"data_type"=>"text",           "file_field"=>"supervisor_comments"                                 } if field_order.push("supervisor_comments"                             )
            
        structure_hash["field_order"] = field_order
        return structure_hash
        
    end

end