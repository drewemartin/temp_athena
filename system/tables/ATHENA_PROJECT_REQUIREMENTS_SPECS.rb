#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATHENA_PROJECT_REQUIREMENTS_SPECS < Athena_Table
    
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
                "name"              => "athena_project_requirements_specs",
                "file_name"         => "athena_project_requirements_specs.csv",
                "file_location"     => "athena_project_requirements_specs",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["project_id"       ] = {"data_type"=>"int",    "file_field"=>"project_id"      } if field_order.push("project_id")
            structure_hash["fields"]["requirement_id"   ] = {"data_type"=>"int",    "file_field"=>"requirement_id"  } if field_order.push("requirement_id")
            structure_hash["fields"]["specification"    ] = {"data_type"=>"text",   "file_field"=>"specification"   } if field_order.push("specification")
            structure_hash["fields"]["team_id"          ] = {"data_type"=>"int",    "file_field"=>"team_id"         } if field_order.push("team_id")
            structure_hash["fields"]["completion_order" ] = {"data_type"=>"int",    "file_field"=>"completion_order"} if field_order.push("completion_order")
            structure_hash["fields"]["completed"        ] = {"data_type"=>"bool",   "file_field"=>"completed"       } if field_order.push("completed")
            
        structure_hash["field_order"] = field_order
        
        return structure_hash
        
    end

end