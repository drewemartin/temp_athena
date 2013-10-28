#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_INTERFACE_OPTIONS < Athena_Table
    
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
                "name"              => "sapphire_interface_options",
                "file_name"         => "sapphire_interface_options.csv",
                "file_location"     => "sapphire_interface_options",
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
            
            structure_hash["fields"]["module_name"              ] = {"data_type"=>"text", "file_field"=>"module_name"           } if field_order.push("module_name"             )
            structure_hash["fields"]["path"                     ] = {"data_type"=>"text", "file_field"=>"path"                  } if field_order.push("path"                    )
            structure_hash["fields"]["parent_option_id"         ] = {"data_type"=>"int",  "file_field"=>"parent_option_id"      } if field_order.push("parent_option_id"        )
            structure_hash["fields"]["option_name"              ] = {"data_type"=>"text", "file_field"=>"option_name"           } if field_order.push("option_name"             )
            structure_hash["fields"]["option_type"              ] = {"data_type"=>"text", "file_field"=>"option_type"           } if field_order.push("option_type"             )
            structure_hash["fields"]["option_value"             ] = {"data_type"=>"text", "file_field"=>"option_value"          } if field_order.push("option_value"            )
            structure_hash["fields"]["action"                   ] = {"data_type"=>"text", "file_field"=>"action"                } if field_order.push("action"                  )
            structure_hash["fields"]["standard"                 ] = {"data_type"=>"bool", "file_field"=>"standard"              } if field_order.push("standard"                )
            structure_hash["fields"]["active"                   ] = {"data_type"=>"bool", "file_field"=>"active"                } if field_order.push("active"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end