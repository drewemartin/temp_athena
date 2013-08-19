#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM < Athena_Table
    
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
                "name"              => "team_evaluation_engagement_professionalism",
                "file_name"         => "team_evaluation_engagement_professionalism.csv",
                "file_location"     => "team_evaluation_engagement_professionalism",
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
            structure_hash["fields"]["source_addresses_concerns"        ] = {"data_type"=>"bool",          "file_field"=>"source_addresses_concerns"         } if field_order.push("source_addresses_concerns")
            structure_hash["fields"]["source_collaboration"             ] = {"data_type"=>"bool",          "file_field"=>"source_collaboration"              } if field_order.push("source_collaboration")
            structure_hash["fields"]["source_communication"             ] = {"data_type"=>"bool",          "file_field"=>"source_communication"              } if field_order.push("source_communication")
            structure_hash["fields"]["source_execution"                 ] = {"data_type"=>"bool",          "file_field"=>"source_execution"                  } if field_order.push("source_execution")
            structure_hash["fields"]["source_professional_development"  ] = {"data_type"=>"bool",          "file_field"=>"source_professional_development"   } if field_order.push("source_professional_development")
            structure_hash["fields"]["source_meeting_contributions"     ] = {"data_type"=>"bool",          "file_field"=>"source_meeting_contributions"      } if field_order.push("source_meeting_contributions")
            structure_hash["fields"]["source_issue_escalation"          ] = {"data_type"=>"bool",          "file_field"=>"source_issue_escalation"           } if field_order.push("source_issue_escalation")
            structure_hash["fields"]["source_sti"                       ] = {"data_type"=>"bool",          "file_field"=>"source_sti"                        } if field_order.push("source_sti")
            structure_hash["fields"]["source_meets_deadlines"           ] = {"data_type"=>"bool",          "file_field"=>"source_meets_deadlines"            } if field_order.push("source_meets_deadlines")
            structure_hash["fields"]["source_attends_events"            ] = {"data_type"=>"bool",          "file_field"=>"source_attends_events"             } if field_order.push("source_attends_events")
            structure_hash["fields"]["score"                            ] = {"data_type"=>"decimal(10,2)", "file_field"=>"score"                             } if field_order.push("score")
            structure_hash["fields"]["team_member_comments"             ] = {"data_type"=>"text",          "file_field"=>"team_member_comments"              } if field_order.push("team_member_comments")
            structure_hash["fields"]["supervisor_comments"              ] = {"data_type"=>"text",          "file_field"=>"supervisor_comments"               } if field_order.push("supervisor_comments")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end