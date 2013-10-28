#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_INTERFACE_QUEUE < Athena_Table
    
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
                "name"              => "sapphire_interface_queue",
                "file_name"         => "sapphire_interface_queue.csv",
                "file_location"     => "sapphire_interface_queue",
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
            
            structure_hash["fields"]["map_id"               ] = {"data_type"=>"int",        "file_field"=>"map_id"              } if field_order.push("map_id"              )
            structure_hash["fields"]["athena_pid"           ] = {"data_type"=>"int",        "file_field"=>"athena_pid"          } if field_order.push("athena_pid"          )
            
            structure_hash["fields"]["started_datetime"     ] = {"data_type"=>"datetime",   "file_field"=>"started_datetime"    } if field_order.push("started_datetime"    )
            structure_hash["fields"]["completed_datetime"   ] = {"data_type"=>"datetime",   "file_field"=>"completed_datetime"  } if field_order.push("completed_datetime"  )
            
            structure_hash["fields"]["confirmed_datetime"   ] = {"data_type"=>"datetime",   "file_field"=>"confirmed_datetime"  } if field_order.push("confirmed_datetime"  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end