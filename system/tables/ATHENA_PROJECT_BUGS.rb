#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATHENA_PROJECT_BUGS < Athena_Table
    
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
                "name"              => "athena_project_bugs",
                "file_name"         => "athena_project_bugs.csv",
                "file_location"     => "athena_project_bugs",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true#,
                #:relationship       => :one_to_many,
                #:relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["system_id"        ] = {"data_type"=>"int",  "file_field"=>"system_id"         } if field_order.push("system_id")
            structure_hash["fields"]["project_id"       ] = {"data_type"=>"int",  "file_field"=>"project_id"        } if field_order.push("project_id")
            structure_hash["fields"]["server"           ] = {"data_type"=>"text", "file_field"=>"server"            } if field_order.push("server")
            structure_hash["fields"]["location_found"   ] = {"data_type"=>"text", "file_field"=>"location_found"    } if field_order.push("location_found")
            structure_hash["fields"]["description"      ] = {"data_type"=>"text", "file_field"=>"description"       } if field_order.push("description")
            structure_hash["fields"]["error_message"    ] = {"data_type"=>"text", "file_field"=>"error_message"     } if field_order.push("error_message")
            structure_hash["fields"]["status"           ] = {"data_type"=>"text", "file_field"=>"status"            } if field_order.push("status")
            structure_hash["fields"]["notes"            ] = {"data_type"=>"text", "file_field"=>"notes"             } if field_order.push("notes")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end