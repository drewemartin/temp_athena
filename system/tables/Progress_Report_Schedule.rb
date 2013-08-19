#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class PROGRESS_REPORT_SCHEDULE < Athena_Table
    
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

    def active_terms()
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("opened_datetime", "IS NOT", "NULL"  ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_term(term)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("term", "=", term ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def current_term
        where_clause = " WHERE CURDATE() BETWEEN opened_datetime AND closed_datetime ORDER BY term DESC "
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
                "name"              => "progress_report_schedule",
                "file_name"         => "progress_report_schedule.csv",
                "file_location"     => "progress_report_schedule",
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
            structure_hash["fields"]["term"]            = {"data_type"=>"text",     "file_field"=>"term"}            if field_order.push("term")
            structure_hash["fields"]["opened_datetime"] = {"data_type"=>"datetime", "file_field"=>"opened_datetime"} if field_order.push("opened_datetime")
            structure_hash["fields"]["closed_datetime"] = {"data_type"=>"datetime", "file_field"=>"closed_datetime"} if field_order.push("closed_datetime")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end