#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EVALUATION_AAB < Athena_Table
    
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
                "name"              => "team_evaluation_aab",
                "file_name"         => "team_evaluation_aab.csv",
                "file_location"     => "team_evaluation_aab",
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
            structure_hash["fields"]["team_id"                       ] = {"data_type"=>"int",           "file_field"=>"team_id"                       } if field_order.push("team_id")                       
            structure_hash["fields"]["source_mentoring"              ] = {"data_type"=>"bool",          "file_field"=>"source_mentoring"              } if field_order.push("source_mentoring")              
            structure_hash["fields"]["source_recruitment_team"       ] = {"data_type"=>"bool",          "file_field"=>"source_recruitment_team"       } if field_order.push("source_recruitment_team")       
            structure_hash["fields"]["source_committee"              ] = {"data_type"=>"bool",          "file_field"=>"source_committee"              } if field_order.push("source_committee")              
            structure_hash["fields"]["source_testing"                ] = {"data_type"=>"bool",          "file_field"=>"source_testing"                } if field_order.push("source_testing")                
            structure_hash["fields"]["source_after_hours"            ] = {"data_type"=>"bool",          "file_field"=>"source_after_hours"            } if field_order.push("source_after_hours")            
            structure_hash["fields"]["source_leading_pd"             ] = {"data_type"=>"bool",          "file_field"=>"source_leading_pd"             } if field_order.push("source_leading_pd")             
            structure_hash["fields"]["source_program_admin"          ] = {"data_type"=>"bool",          "file_field"=>"source_program_admin"          } if field_order.push("source_program_admin")          
            structure_hash["fields"]["source_local_club"             ] = {"data_type"=>"bool",          "file_field"=>"source_local_club"             } if field_order.push("source_local_club")             
            structure_hash["fields"]["source_subsitute_no_pay"       ] = {"data_type"=>"bool",          "file_field"=>"source_subsitute_no_pay"       } if field_order.push("source_subsitute_no_pay")       
            structure_hash["fields"]["source_parent_training"        ] = {"data_type"=>"bool",          "file_field"=>"source_parent_training"        } if field_order.push("source_parent_training")        
            structure_hash["fields"]["source_distinguished_aims"     ] = {"data_type"=>"bool",          "file_field"=>"source_distinguished_aims"     } if field_order.push("source_distinguished_aims")        
            structure_hash["fields"]["source_distinguished_define_u" ] = {"data_type"=>"bool",          "file_field"=>"source_distinguished_define_u" } if field_order.push("source_distinguished_define_u")        
            structure_hash["fields"]["source_other"                  ] = {"data_type"=>"text",          "file_field"=>"source_other"                  } if field_order.push("source_other")        
            structure_hash["fields"]["team_member_comments"          ] = {"data_type"=>"text",          "file_field"=>"team_member_comments"          } if field_order.push("team_member_comments")          
            structure_hash["fields"]["supervisor_comments"           ] = {"data_type"=>"text",          "file_field"=>"supervisor_comments"           } if field_order.push("supervisor_comments")           
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end