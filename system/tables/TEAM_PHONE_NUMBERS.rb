#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_PHONE_NUMBERS < Athena_Table
    
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
    
    def by_phone_number(phone_number, team_id = nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("phone_number",   "=", phone_number   ) )
        params.push( Struct::WHERE_PARAMS.new("team_id",        "=", team_id        ) ) if team_id
        where_clause = $db.where_clause(params)
        record(where_clause)
        
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
                "name"              => "team_phone_numbers",
                "file_name"         => "team_phone_numbers.csv",
                "file_location"     => "team_phone_numbers.csv",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["team_id"      ] = {"data_type"=>"int",  "file_field"=>"team_id"       } if field_order.push("team_id")
            structure_hash["fields"]["phone_number" ] = {"data_type"=>"text", "file_field"=>"phone_number"  } if field_order.push("phone_number")
            structure_hash["fields"]["type"         ] = {"data_type"=>"text", "file_field"=>"type"          } if field_order.push("type")
            structure_hash["fields"]["preferred"    ] = {"data_type"=>"bool", "file_field"=>"preferred"     } if field_order.push("preferred")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end