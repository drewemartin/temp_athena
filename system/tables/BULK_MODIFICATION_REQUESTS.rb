#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class BULK_MODIFICATION_REQUESTS < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=", sid   ) )
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
                "name"              => "bulk_modification_requests",
                "file_name"         => "bulk_modification_requests.csv",
                "file_location"     => "bulk_modification_requests",
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
            structure_hash["fields"]["table"]         = {"data_type"=>"text", "file_field"=>"table"}         if field_order.push("table")
            structure_hash["fields"]["field"]         = {"data_type"=>"text", "file_field"=>"field"}         if field_order.push("field")
            structure_hash["fields"]["reason"]        = {"data_type"=>"text", "file_field"=>"reason"}        if field_order.push("reason")
            structure_hash["fields"]["authorized_by"] = {"data_type"=>"text", "file_field"=>"authorized_by"} if field_order.push("authorized_by")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end