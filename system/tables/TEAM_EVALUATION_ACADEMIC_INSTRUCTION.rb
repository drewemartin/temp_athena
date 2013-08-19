#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_ACADEMIC_INSTRUCTION < Athena_Table
    
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
                "name"              => "team_evaluation_academic_instruction",
                "file_name"         => "team_evaluation_academic_instruction.csv",
                "file_location"     => "team_evaluation_academic_instruction",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["team_id"                          ] = {"data_type"=>"int",           "file_field"=>"team_id"                           } if field_order.push("team_id")
            structure_hash["fields"]["source_comprehensive_observation" ] = {"data_type"=>"bool",          "file_field"=>"source_comprehensive_observation"  } if field_order.push("source_comprehensive_observation")
            structure_hash["fields"]["source_lesson_recordings"         ] = {"data_type"=>"bool",          "file_field"=>"source_lesson_recordings"          } if field_order.push("source_lesson_recordings")
            structure_hash["fields"]["source_unannounced_observation"   ] = {"data_type"=>"bool",          "file_field"=>"source_unannounced_observation"    } if field_order.push("source_unannounced_observation")
            structure_hash["fields"]["score"                            ] = {"data_type"=>"decimal(10,2)", "file_field"=>"score"                             } if field_order.push("score")
            structure_hash["fields"]["team_member_comments"             ] = {"data_type"=>"text",          "file_field"=>"team_member_comments"              } if field_order.push("team_member_comments")
            structure_hash["fields"]["supervisor_comments"              ] = {"data_type"=>"text",          "file_field"=>"supervisor_comments"               } if field_order.push("supervisor_comments")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end