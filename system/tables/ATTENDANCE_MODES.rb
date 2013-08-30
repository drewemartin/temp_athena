#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATTENDANCE_MODES < Athena_Table
    
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

    def sources_by_mode(mode)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("mode", "=", mode) )
        where_clause = $db.where_clause(params)
        find_field("sources", where_clause)
    end
    
    def modes_array
        return $db.get_data_single("SELECT mode FROM attendance_modes")
    end
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
                "name"              => "attendance_modes",
                "file_name"         => "attendance_modes.csv",
                "file_location"     => "attendance_modes",
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
            
            structure_hash["fields"]["mode"                     ] = {"data_type"=>"text", "file_field"=>"mode"                  } if field_order.push("mode"                )
            structure_hash["fields"]["sources"                  ] = {"data_type"=>"text", "file_field"=>"sources"               } if field_order.push("sources"             )
            structure_hash["fields"]["description"              ] = {"data_type"=>"text", "file_field"=>"description"           } if field_order.push("description"         )
            structure_hash["fields"]["procedure_type"           ] = {"data_type"=>"text", "file_field"=>"procedure_type"        } if field_order.push("procedure_type"      )
            
            #PRESENT REQUIREMENTS
            #structure_hash["fields"]["activity_only"            ] = {"data_type"=>"bool", "file_field"=>"activity_only"         } if field_order.push("activity_only"       )
            #structure_hash["fields"]["live_only"                ] = {"data_type"=>"bool", "file_field"=>"live_only"             } if field_order.push("live_only"           )
            #structure_hash["fields"]["activity_and_live"        ] = {"data_type"=>"bool", "file_field"=>"activity_and_live"     } if field_order.push("activity_and_live"   )
            #structure_hash["fields"]["activity_or_live"         ] = {"data_type"=>"bool", "file_field"=>"activity_or_live"      } if field_order.push("activity_or_live"    )
            #structure_hash["fields"]["no_activity"              ] = {"data_type"=>"bool", "file_field"=>"no_activity"           } if field_order.push("no_activity"         )
            #structure_hash["fields"]["custom_procedure"         ] = {"data_type"=>"bool", "file_field"=>"custom_procedure"      } if field_order.push("custom_procedure"    )
            #
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end