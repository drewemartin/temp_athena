#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class RECORD_REQUESTS_RECEIVED < Athena_Table
    
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

    def by_studentid_old(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",  "=", sid   ) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY `created_date` DESC"
        records(where_clause) 
    end
    
    def by_primaryid(pid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id",  "=", pid   ) )
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
                "name"              => "record_requests_received",
                "file_name"         => "record_requests_received.csv",
                "file_location"     => "record_requests_received",
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
            structure_hash["fields"]["student_id"]  = {"data_type"=>"int",  "file_field"=>"student_id"} if field_order.push("student_id")
            structure_hash["fields"]["type"]        = {"data_type"=>"text", "file_field"=>"type"} if field_order.push("type")
            structure_hash["fields"]["school_year"] = {"data_type"=>"text", "file_field"=>"school_year"} if field_order.push("school_year")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end