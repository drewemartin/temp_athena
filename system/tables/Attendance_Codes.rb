#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATTENDANCE_CODES < Athena_Table
    
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

    def code_array(where_clause = nil)
        $db.get_data_single("SELECT code FROM #{data_base}.#{table_name} #{where_clause}")
    end
    
    def override_codes
        $db.get_data_single("SELECT code FROM #{data_base}.attendance_codes WHERE code IN ('e','me','pr','ur','t')")
    end
    
    def present
        $db.get_data_single("SELECT code FROM #{data_base}.#{table_name} WHERE code_type REGEXP 'present'")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "attendance_codes",
                "file_name"         => "attendance_codes.csv",
                "file_location"     => "attendance_codes",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["code"                     ] = {"data_type"=>"text", "file_field"=>"code"                  } if field_order.push("code"                    )
            structure_hash["fields"]["code_type"                ] = {"data_type"=>"text", "file_field"=>"code_type"             } if field_order.push("code_type"               )
            structure_hash["fields"]["description"              ] = {"data_type"=>"text", "file_field"=>"description"           } if field_order.push("description"             )
            structure_hash["fields"]["overrides_procedure"      ] = {"data_type"=>"bool", "file_field"=>"overrides_procedure"   } if field_order.push("overrides_procedure"     )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end