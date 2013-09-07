#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class RECORD_REQUESTS_REQUIRED < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "record_requests_required",
                "file_name"         => "record_requests_required.csv",
                "file_location"     => "record_requests_required",
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
            structure_hash["fields"]["report_card"] = {"data_type"=>"bool", "file_field"=>"report_card"} if field_order.push("report_card")
            structure_hash["fields"]["transcript"]  = {"data_type"=>"bool", "file_field"=>"transcript"} if field_order.push("transcript")
            structure_hash["fields"]["pssa"]        = {"data_type"=>"bool", "file_field"=>"pssa"} if field_order.push("pssa")
            structure_hash["fields"]["attendance"]  = {"data_type"=>"bool", "file_field"=>"attendance"} if field_order.push("attendance")
            structure_hash["fields"]["discipline"]  = {"data_type"=>"bool", "file_field"=>"discipline"} if field_order.push("discipline")
            structure_hash["fields"]["status"]      = {"data_type"=>"text", "file_field"=>"status"} if field_order.push("status")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end