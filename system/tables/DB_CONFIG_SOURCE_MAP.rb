#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DB_CONFIG_SOURCE_MAP < Athena_Table
    
    #This table holds all the information needed to move imported data into native tables.
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
    
    def by_source_table(source_table)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("source_table",   "=", source_table) )
        params.push( Struct::WHERE_PARAMS.new("active",         "=", "1") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
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
                "name"              => "db_config_source_map",
                "file_name"         => "db_config_source_map.csv",
                "file_location"     => "db_config_source_map",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["source_table"                     ]   = {"data_type"=>"text", "file_field"=>"source_table"                        } if field_order.push("source_table")
            structure_hash["fields"]["source_field"                     ]   = {"data_type"=>"text", "file_field"=>"source_field"                        } if field_order.push("source_field")
            structure_hash["fields"]["source_key_field"                 ]   = {"data_type"=>"text", "file_field"=>"source_key_field"                    } if field_order.push("source_key_field")
            
            structure_hash["fields"]["destination_table"                ]   = {"data_type"=>"text", "file_field"=>"destination_table"                   } if field_order.push("destination_table")
            structure_hash["fields"]["destination_field"                ]   = {"data_type"=>"text", "file_field"=>"destination_field"                   } if field_order.push("destination_field")
            structure_hash["fields"]["destination_key_field"            ]   = {"data_type"=>"text", "file_field"=>"destination_key_field"               } if field_order.push("destination_key_field")
            structure_hash["fields"]["update_active_record_only"        ]   = {"data_type"=>"bool", "file_field"=>"update_active_record_only"           } if field_order.push("update_active_record_only")
            structure_hash["fields"]["update_with_null_values_allowed"  ]   = {"data_type"=>"bool", "file_field"=>"update_with_null_values_allowed"     } if field_order.push("update_with_null_values_allowed")
            
            structure_hash["fields"]["active"                           ]   = {"data_type"=>"bool", "file_field"=>"active"                              } if field_order.push("active")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end