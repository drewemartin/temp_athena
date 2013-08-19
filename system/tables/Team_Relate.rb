#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class TEAM_RELATE < Athena_Table
    
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
    
    def by_ids(arg1, arg2, arg3)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id", "=", arg1 ) )
        params.push( Struct::WHERE_PARAMS.new("lead_staff_id", "=", arg2 ) )
        params.push( Struct::WHERE_PARAMS.new("role", "=", arg3 ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def ftcm_by_staffid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id", "=", arg ) )
        params.push( Struct::WHERE_PARAMS.new("role", "=", "Family Teacher Coach Mentor" ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_staff_id(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id", "=", arg ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_lead_sams_id(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("lead_sams_id", "=", arg ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def roles
        select_sql =
            "SELECT
                name,
                description,
                name
            FROM static_value
            WHERE table_name = 'team_relate_role_type'"
        results = $db.get_data(select_sql)
    end
    
    def true_to_null(source_name)
        update_sql =
            "UPDATE team_relate
             SET active = null
             WHERE source = '#{source_name}' AND active = true"
        $db.query(update_sql)   
    end
    
    def null_to_false(source_name)
        update_sql =
            "UPDATE team_relate
             SET active = false
             WHERE source = '#{source_name}' AND active = null"
        $db.query(update_sql)   
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "team_relate",
                "file_name"         => "team_relate.csv",
                "file_location"     => "team_relate",
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
            structure_hash["fields"]["sams_id"] = {"data_type"=>"int", "file_field"=>"sams_id"} if field_order.push("sams_id")
            structure_hash["fields"]["lead_sams_id"] = {"data_type"=>"int", "file_field"=>"lead_sams_id"} if field_order.push("lead_sams_id")
            structure_hash["fields"]["role"] = {"data_type"=>"text", "file_field"=>"role"} if field_order.push("role")
            structure_hash["fields"]["source"] = {"data_type"=>"text", "file_field"=>"source"} if field_order.push("source")
            structure_hash["fields"]["active"] = {"data_type"=>"bool", "file_field"=>"active"} if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end