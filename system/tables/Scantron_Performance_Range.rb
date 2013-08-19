#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCANTRON_PERFORMANCE_RANGE < Athena_Table
    
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
    
    def by_subject_grade(arg1,arg2)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("subject", "=", arg1) )
        params.push( Struct::WHERE_PARAMS.new("grade",   "=", arg2) )
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
                "name"              => "scantron_performance_range",
                "file_name"         => "scantron_performance_range.csv",
                "file_location"     => "scantron_performance_range",
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
        structure_hash["fields"]["grade"]       = {"data_type"=>"text", "file_field"=>"grade"}       if field_order.push("grade")
        structure_hash["fields"]["subject"]     = {"data_type"=>"text", "file_field"=>"subject"}     if field_order.push("subject")
        structure_hash["fields"]["range_start"] = {"data_type"=>"date", "file_field"=>"range_start"} if field_order.push("range_start")
        structure_hash["fields"]["range_end"]   = {"data_type"=>"date", "file_field"=>"range_end"}   if field_order.push("range_end")
        structure_hash["fields"]["target_min"]  = {"data_type"=>"int",  "file_field"=>"target_min"}  if field_order.push("target_min")
        structure_hash["fields"]["target_max"]  = {"data_type"=>"int",  "file_field"=>"target_max"}  if field_order.push("target_max")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end