#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_ENGAGEMENT_OBSERVATION_SNAPSHOT < Athena_Table
    
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
                "name"              => "team_evaluation_engagement_observation_snapshot",
                "file_name"         => "team_evaluation_engagement_observation_snapshot.csv",
                "file_location"     => "team_evaluation_engagement_observation_snapshot",
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
            structure_hash["fields"]["team_id"                  ] = {"data_type"=>"int",           "file_field"=>"team_id"                      } if field_order.push("team_id")
            structure_hash["fields"]["rapport"                  ] = {"data_type"=>"bool",           "file_field"=>"rapport"                      } if field_order.push("rapport")
            structure_hash["fields"]["knowledge"                ] = {"data_type"=>"bool",           "file_field"=>"knowledge"                    } if field_order.push("knowledge")
            structure_hash["fields"]["goal"                     ] = {"data_type"=>"bool",           "file_field"=>"goal"                         } if field_order.push("goal")
            structure_hash["fields"]["narrative"                ] = {"data_type"=>"bool",           "file_field"=>"narrative"                    } if field_order.push("narrative")
            structure_hash["fields"]["obtaining_commitment"     ] = {"data_type"=>"bool",           "file_field"=>"obtaining_commitment"         } if field_order.push("obtaining_commitment")
            structure_hash["fields"]["communication"            ] = {"data_type"=>"bool",           "file_field"=>"communication"                } if field_order.push("communication")
            structure_hash["fields"]["documentation_followup"   ] = {"data_type"=>"bool",           "file_field"=>"documentation_followup"       } if field_order.push("documentation_followup")
            structure_hash["fields"]["score"                    ] = {"data_type"=>"decimal(10,2)", "file_field"=>"score"                        } if field_order.push("score")
            structure_hash["fields"]["team_member_comments"     ] = {"data_type"=>"text",          "file_field"=>"team_member_comments"         } if field_order.push("team_member_comments")
            structure_hash["fields"]["supervisor_comments"      ] = {"data_type"=>"text",          "file_field"=>"supervisor_comments"          } if field_order.push("supervisor_comments")

        structure_hash["field_order"] = field_order
        return structure_hash
    end

end