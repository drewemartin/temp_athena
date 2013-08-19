#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_SUMMARY_SNAPSHOT_INCLUDES < Athena_Table
    
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
                "name"              => "team_evaluation_summary_snapshot_includes",
                "file_name"         => "team_evaluation_summary_snapshot_includes.csv",
                "file_location"     => "team_evaluation_summary_snapshot_includes",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => false,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["team_id"                                  ] = {"data_type"=>"int",  "file_field"=>"team_id"                                } if field_order.push("team_id"                                )
            structure_hash["fields"]["students"                                 ] = {"data_type"=>"text", "file_field"=>"students"                               } if field_order.push("students"                               )
            structure_hash["fields"]["all_students"                             ] = {"data_type"=>"text", "file_field"=>"all_students"                           } if field_order.push("all_students"                           )
            structure_hash["fields"]["withdrawn"                                ] = {"data_type"=>"text", "file_field"=>"withdrawn"                              } if field_order.push("withdrawn"                              )
            structure_hash["fields"]["new"                                      ] = {"data_type"=>"text", "file_field"=>"new"                                    } if field_order.push("new"                                    )
            structure_hash["fields"]["in_year"                                  ] = {"data_type"=>"text", "file_field"=>"in_year"                                } if field_order.push("in_year"                                )
            structure_hash["fields"]["low_income"                               ] = {"data_type"=>"text", "file_field"=>"low_income"                             } if field_order.push("low_income"                             )
            structure_hash["fields"]["tier_23"                                  ] = {"data_type"=>"text", "file_field"=>"tier_23"                                } if field_order.push("tier_23"                                )
            structure_hash["fields"]["special_ed"                               ] = {"data_type"=>"text", "file_field"=>"special_ed"                             } if field_order.push("special_ed"                             )
            structure_hash["fields"]["grades_712"                               ] = {"data_type"=>"text", "file_field"=>"grades_712"                             } if field_order.push("grades_712"                             )
            structure_hash["fields"]["scantron_participation_fall"              ] = {"data_type"=>"text", "file_field"=>"scantron_participation_fall"            } if field_order.push("scantron_participation_fall"            )
            structure_hash["fields"]["scantron_participation_fall_eligible"     ] = {"data_type"=>"text", "file_field"=>"scantron_participation_fall_eligible"   } if field_order.push("scantron_participation_fall_eligible"   )
            structure_hash["fields"]["scantron_participation_spring"            ] = {"data_type"=>"text", "file_field"=>"scantron_participation_spring"          } if field_order.push("scantron_participation_spring"          )
            structure_hash["fields"]["scantron_participation_spring_eligible"   ] = {"data_type"=>"text", "file_field"=>"scantron_participation_spring_eligible" } if field_order.push("scantron_participation_spring_eligible" )
            structure_hash["fields"]["scantron_growth_overall"                  ] = {"data_type"=>"text", "file_field"=>"scantron_growth_overall"                } if field_order.push("scantron_growth_overall"                )
            structure_hash["fields"]["scantron_growth_overall_eligible"         ] = {"data_type"=>"text", "file_field"=>"scantron_growth_overall_eligible"       } if field_order.push("scantron_growth_overall_eligible"       )
            structure_hash["fields"]["scantron_growth_math"                     ] = {"data_type"=>"text", "file_field"=>"scantron_growth_math"                   } if field_order.push("scantron_growth_math"                   )
            structure_hash["fields"]["scantron_growth_math_eligible"            ] = {"data_type"=>"text", "file_field"=>"scantron_growth_math_eligible"          } if field_order.push("scantron_growth_math_eligible"          )
            structure_hash["fields"]["scantron_growth_reading"                  ] = {"data_type"=>"text", "file_field"=>"scantron_growth_reading"                } if field_order.push("scantron_growth_reading"                )
            structure_hash["fields"]["scantron_growth_reading_eligible"         ] = {"data_type"=>"text", "file_field"=>"scantron_growth_reading_eligible"       } if field_order.push("scantron_growth_reading_eligible"       )
            structure_hash["fields"]["aims_growth_overall"                      ] = {"data_type"=>"text", "file_field"=>"aims_growth_overall"                    } if field_order.push("aims_growth_overall"                    )
            structure_hash["fields"]["aims_growth_overall_eligible"             ] = {"data_type"=>"text", "file_field"=>"aims_growth_overall_eligible"           } if field_order.push("aims_growth_overall_eligible"           )
            structure_hash["fields"]["aims_participation_fall"                  ] = {"data_type"=>"text", "file_field"=>"aims_participation_fall"                } if field_order.push("aims_participation_fall"                )
            structure_hash["fields"]["aims_participation_fall_eligible"         ] = {"data_type"=>"text", "file_field"=>"aims_participation_fall_eligible"       } if field_order.push("aims_participation_fall_eligible"       )
            structure_hash["fields"]["aims_participation_spring"                ] = {"data_type"=>"text", "file_field"=>"aims_participation_spring"              } if field_order.push("aims_participation_spring"              )
            structure_hash["fields"]["aims_participation_spring_eligible"       ] = {"data_type"=>"text", "file_field"=>"aims_participation_spring_eligible"     } if field_order.push("aims_participation_spring_eligible"     )
            structure_hash["fields"]["study_island"                             ] = {"data_type"=>"text", "file_field"=>"study_island"                           } if field_order.push("study_island"                           )
            structure_hash["fields"]["define_u"                                 ] = {"data_type"=>"text", "file_field"=>"define_u"                               } if field_order.push("define_u"                               )
            structure_hash["fields"]["state_test"                               ] = {"data_type"=>"text", "file_field"=>"state_test"                             } if field_order.push("state_test"                             )
            structure_hash["fields"]["aims"                                     ] = {"data_type"=>"text", "file_field"=>"aims"                                   } if field_order.push("aims"                                   )
            structure_hash["fields"]["pssa_participation"                       ] = {"data_type"=>"text", "file_field"=>"pssa_participation"                     } if field_order.push("pssa_participation"                     )
            structure_hash["fields"]["pssa_participation_eligible"              ] = {"data_type"=>"text", "file_field"=>"pssa_participation_eligible"            } if field_order.push("pssa_participation_eligible"            )
            structure_hash["fields"]["keystone_participation"                   ] = {"data_type"=>"text", "file_field"=>"keystone_participation"                 } if field_order.push("keystone_participation"                 )
            structure_hash["fields"]["keystone_participation_eligible"          ] = {"data_type"=>"text", "file_field"=>"keystone_participation_eligible"        } if field_order.push("keystone_participation_eligible"        )
            
        structure_hash["field_order"] = field_order
        
        return structure_hash
        
    end

end