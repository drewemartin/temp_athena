#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_PEER_RELATE < Athena_Table
    
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

    def by_staff_role(staff_id, role, peer_group)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",   "=", staff_id   ) )
        params.push( Struct::WHERE_PARAMS.new("role",       "=", role       ) )
        params.push( Struct::WHERE_PARAMS.new("peer_group", "=", peer_group  ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_by_samsid(field_name, sams_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id", "=", sams_id) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def peer_groups_by_role(role) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("role",   "=", role) )
        params.push( Struct::WHERE_PARAMS.new("active", "=", "1") )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT peer_group FROM #{data_base}.#{table_name} #{where_clause} GROUP BY peer_group") 
    end
    
    def peer_group_members_by_role_group(role, peer_group)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("role",       "=", role       ) )
        params.push( Struct::WHERE_PARAMS.new("peer_group", "=", peer_group ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT staff_id FROM #{data_base}.#{table_name} #{where_clause}")
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
                "name"              => "team_peer_relate",
                "file_name"         => "team_peer_relate.csv",
                "file_location"     => "team_peer_relate",
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
            structure_hash["fields"]["staff_id"] = {"data_type"=>"int", "file_field"=>"staff_id"} if field_order.push("staff_id")
            structure_hash["fields"]["role"] = {"data_type"=>"text", "file_field"=>"role"} if field_order.push("role")
            structure_hash["fields"]["peer_group"] = {"data_type"=>"text", "file_field"=>"peer_group"} if field_order.push("peer_group")
            structure_hash["fields"]["source"] = {"data_type"=>"text", "file_field"=>"source"} if field_order.push("source")
            structure_hash["fields"]["active"] = {"data_type"=>"bool", "file_field"=>"active"} if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end