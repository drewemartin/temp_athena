#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATHENA_PROJECT_FEATURES < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "athena_project_features",
                "file_name"         => "athena_project_features.csv",
                "file_location"     => "athena_project_features",
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
            structure_hash["fields"]["related_project"          ] = {"data_type"=>"int",  "file_field"=>"related_project"           } if field_order.push("related_project")
            structure_hash["fields"]["feature_requested"        ] = {"data_type"=>"text", "file_field"=>"feature_requested"         } if field_order.push("feature_requested")
            structure_hash["fields"]["brief_description"        ] = {"data_type"=>"text", "file_field"=>"brief_description"         } if field_order.push("brief_description")
            structure_hash["fields"]["department"               ] = {"data_type"=>"text", "file_field"=>"department"                } if field_order.push("department")
            structure_hash["fields"]["requester"                ] = {"data_type"=>"text", "file_field"=>"requester"                 } if field_order.push("requester")
            structure_hash["fields"]["requested_priority_level" ] = {"data_type"=>"text", "file_field"=>"requested_priority_level"  } if field_order.push("requested_priority_level")
            structure_hash["fields"]["requested_completion_date"] = {"data_type"=>"date", "file_field"=>"requested_completion_date" } if field_order.push("requested_completion_date")
            structure_hash["fields"]["priority_level"           ] = {"data_type"=>"text", "file_field"=>"priority_level"            } if field_order.push("priority_level")
            structure_hash["fields"]["estimated_completion_date"] = {"data_type"=>"date", "file_field"=>"estimated_completion_date" } if field_order.push("estimated_completion_date")
            structure_hash["fields"]["status"                   ] = {"data_type"=>"text", "file_field"=>"status"                    } if field_order.push("status")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end