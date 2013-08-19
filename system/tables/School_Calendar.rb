#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class SCHOOL_CALENDAR < Athena_Table
    
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

    def holidays
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("type", "=", "holiday") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def holiday_dates
        holiday_records = holidays
        if holiday_records
            holiday_dates = Array.new
            holiday_records.each do |record|
                holiday_dates.push(record.fields["date"].value)
            end
            return holiday_dates
        end
        return false
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "school_calendar",
                "file_name"         => "school_calendar.csv",
                "file_location"     => "school_calendar",
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
            structure_hash["fields"]["date"]    = {"data_type"=>"date", "file_field"=>"date"}       if field_order.push("date")
            structure_hash["fields"]["type"]    = {"data_type"=>"text", "file_field"=>"type"}       if field_order.push("type")
            structure_hash["fields"]["details"] = {"data_type"=>"text", "file_field"=>"details"}    if field_order.push("details")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end