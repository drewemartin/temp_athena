#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_EMAIL < Athena_Table
    
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
    
    def by_email(email_address, team_id = nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("email_address",  "=", email_address  ) )
        params.push( Struct::WHERE_PARAMS.new("team_id",        "=", team_id        ) ) if team_id
        where_clause = $db.where_clause(params)
        record(where_clause)
        
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
                "name"              => "team_email",
                "file_name"         => "team_email.csv",
                "file_location"     => "team_email.csv",
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
            structure_hash["fields"]["email_address"] = {"data_type"=>"text", "file_field"=>"email_address" } if field_order.push("email_address")
            structure_hash["fields"]["email_type"   ] = {"data_type"=>"text", "file_field"=>"email_type"    } if field_order.push("email_type")
            structure_hash["fields"]["preferred"    ] = {"data_type"=>"bool", "file_field"=>"preferred"     } if field_order.push("preferred")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end