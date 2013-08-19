#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEP_SCHEDULE < Athena_Table
    
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

    def record(arg) #call when search results should be a single row.
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("field_name", "evaluator", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def records(arg) #call when search results can be more than a single row.
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("field_name", "evaluator", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def type_with_records
        $db.get_data_single("SELECT column_name FROM #{table_name}") 
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
                "name"              => "tep_schedule",
                "file_name"         => "tep_schedule.csv",
                "file_location"     => "tep_schedule",
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
            structure_hash["fields"]["staff_id"]            = {"data_type"=>"int", "file_field"=>"staff_id"} if field_order.push("staff_id")
            structure_hash["fields"]["schedule_datetime"]   = {"data_type"=>"datetime", "file_field"=>"schedule_datetime"} if field_order.push("schedule_datetime")
            structure_hash["fields"]["notifications_sent"]  = {"data_type"=>"bool", "file_field"=>"notifications_sent"} if field_order.push("notifications_sent")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end