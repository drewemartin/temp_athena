#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_ENGAGEMENT_METRICS_SNAPSHOT < Athena_Table
    
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
                "name"              => "team_evaluation_engagement_metrics_snapshot",
                "file_name"         => "team_evaluation_engagement_metrics_snapshot.csv",
                "file_location"     => "team_evaluation_engagement_metrics_snapshot",
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
            
            structure_hash["fields"]["team_id"                                          ] = {"data_type"=>"int",               "file_field"=>"team_id"                                          } if field_order.push("team_id"                                         )
            
            structure_hash["fields"]["scantron_participation_fall"                      ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_fall"                      } if field_order.push("scantron_participation_fall"                     )
            structure_hash["fields"]["scantron_participation_fall_sd"                   ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_fall_sd"                   } if field_order.push("scantron_participation_fall_sd"                  )
            structure_hash["fields"]["scantron_participation_fall_dfn"                  ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_fall_dfn"                  } if field_order.push("scantron_participation_fall_dfn"                 )
            structure_hash["fields"]["scantron_participation_fall_attainable"           ] = {"data_type"=>"bool",              "file_field"=>"scantron_participation_fall_attainable"           } if field_order.push("scantron_participation_fall_attainable"          )
         
            structure_hash["fields"]["scantron_participation_spring"                    ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_spring"                    } if field_order.push("scantron_participation_spring"                   )
            structure_hash["fields"]["scantron_participation_spring_sd"                 ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_spring_sd"                 } if field_order.push("scantron_participation_spring_sd"                )
            structure_hash["fields"]["scantron_participation_spring_dfn"                ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"scantron_participation_spring_dfn"                } if field_order.push("scantron_participation_spring_dfn"               )
            structure_hash["fields"]["scantron_participation_spring_attainable"         ] = {"data_type"=>"bool",              "file_field"=>"scantron_participation_spring_attainable"         } if field_order.push("scantron_participation_spring_attainable"        )
            
            structure_hash["fields"]["attendance"                                       ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"attendance"                                       } if field_order.push("attendance"                                      )
            structure_hash["fields"]["attendance_sd"                                    ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"attendance_sd"                                    } if field_order.push("attendance_sd"                                   )
            structure_hash["fields"]["attendance_dfn"                                   ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"attendance_dfn"                                   } if field_order.push("attendance_dfn"                                  )
            structure_hash["fields"]["attendance_attainable"                            ] = {"data_type"=>"bool",              "file_field"=>"attendance_attainable"                            } if field_order.push("attendance_attainable"                           )
         
            structure_hash["fields"]["truancy_prevention"                               ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"truancy_prevention"                               } if field_order.push("truancy_prevention"                              )
            structure_hash["fields"]["truancy_prevention_sd"                            ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"truancy_prevention_sd"                            } if field_order.push("truancy_prevention_sd"                           )
            structure_hash["fields"]["truancy_prevention_dfn"                           ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"truancy_prevention_dfn"                           } if field_order.push("truancy_prevention_dfn"                          )
            structure_hash["fields"]["truancy_prevention_attainable"                    ] = {"data_type"=>"bool",              "file_field"=>"truancy_prevention_attainable"                    } if field_order.push("truancy_prevention_attainable"                   )
         
            structure_hash["fields"]["evaluation_participation"                         ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"evaluation_participation"                         } if field_order.push("evaluation_participation"                        )
            structure_hash["fields"]["evaluation_participation_sd"                      ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"evaluation_participation_sd"                      } if field_order.push("evaluation_participation_sd"                     )
            structure_hash["fields"]["evaluation_participation_dfn"                     ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"evaluation_participation_dfn"                     } if field_order.push("evaluation_participation_dfn"                    )
            structure_hash["fields"]["evaluation_participation_attainable"              ] = {"data_type"=>"bool",              "file_field"=>"evaluation_participation_attainable"              } if field_order.push("evaluation_participation_attainable"             )
        
            structure_hash["fields"]["keystone_participation"                           ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"keystone_participation"                           } if field_order.push("keystone_participation"                          )   
            structure_hash["fields"]["keystone_participation_sd"                        ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"keystone_participation_sd"                        } if field_order.push("keystone_participation_sd"                       )   
            structure_hash["fields"]["keystone_participation_dfn"                       ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"keystone_participation_dfn"                       } if field_order.push("keystone_participation_dfn"                      )   
            structure_hash["fields"]["keystone_participation_attainable"                ] = {"data_type"=>"bool",              "file_field"=>"keystone_participation_attainable"                } if field_order.push("keystone_participation_attainable"               )   
          
            structure_hash["fields"]["pssa_participation"                               ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"pssa_participation"                               } if field_order.push("pssa_participation"                              )   
            structure_hash["fields"]["pssa_participation_sd"                            ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"pssa_participation_sd"                            } if field_order.push("pssa_participation_sd"                           )   
            structure_hash["fields"]["pssa_participation_dfn"                           ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"pssa_participation_dfn"                           } if field_order.push("pssa_participation_dfn"                          )   
            structure_hash["fields"]["pssa_participation_attainable"                    ] = {"data_type"=>"bool",              "file_field"=>"pssa_participation_attainable"                    } if field_order.push("pssa_participation_attainable"                   )   
          
            structure_hash["fields"]["quality_documentation"                            ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"quality_documentation"                            } if field_order.push("quality_documentation"                           )
            structure_hash["fields"]["feedback"                                         ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"feedback"                                         } if field_order.push("feedback"                                        )
         
            structure_hash["fields"]["score"                                            ] = {"data_type"=>"decimal(10,2)",     "file_field"=>"score"                                            } if field_order.push("score"                                           )
            
            structure_hash["fields"]["team_member_comments"                             ] = {"data_type"=>"text",              "file_field"=>"team_member_comments"                             } if field_order.push("team_member_comments"                            )
            structure_hash["fields"]["supervisor_comments"                              ] = {"data_type"=>"text",              "file_field"=>"supervisor_comments"                              } if field_order.push("supervisor_comments"                             )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end