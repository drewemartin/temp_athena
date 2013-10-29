#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_INTERFACE_MAP < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_sapphire",
                "name"              => "sapphire_interface_map",
                "file_name"         => "sapphire_interface_map.csv",
                "file_location"     => "sapphire_interface_map",
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
            
            structure_hash["fields"]["sapphire_option_id"   ] = {"data_type"=>"int",  "file_field"=>"sapphire_option_id"    } if field_order.push("sapphire_option_id"      )
            structure_hash["fields"]["sapphire_table"       ] = {"data_type"=>"text", "file_field"=>"sapphire_table"        } if field_order.push("sapphire_table"          )
            structure_hash["fields"]["sapphire_field"       ] = {"data_type"=>"text", "file_field"=>"sapphire_field"        } if field_order.push("sapphire_field"          )
            structure_hash["fields"]["athena_table"         ] = {"data_type"=>"text", "file_field"=>"athena_table"          } if field_order.push("athena_table"            )
            structure_hash["fields"]["athena_field"         ] = {"data_type"=>"text", "file_field"=>"athena_field"          } if field_order.push("athena_field"            )
            structure_hash["fields"]["trigger_event"        ] = {"data_type"=>"text", "file_field"=>"trigger_event"         } if field_order.push("trigger_event"           )
            structure_hash["fields"]["active"               ] = {"data_type"=>"bool", "file_field"=>"active"                } if field_order.push("active"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end