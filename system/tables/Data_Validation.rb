#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DATA_VALIDATION < Athena_Table
    
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

    def unreported
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("reported", "IS", "NULL" ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
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
                "name"              => "data_validation",
                "file_name"         => "data_validation.csv",
                "file_location"     => "data_validation",
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
            structure_hash["fields"]["table_name"]      = {"data_type"=>"text", "file_field"=>"table_name"}     if field_order.push("table_name")
            structure_hash["fields"]["row_id"]          = {"data_type"=>"int",  "file_field"=>"row_id"}         if field_order.push("row_id")
            structure_hash["fields"]["field_name"]      = {"data_type"=>"text", "file_field"=>"field_name"}     if field_order.push("field_name")
            structure_hash["fields"]["data_type"]       = {"data_type"=>"text", "file_field"=>"data_type"}      if field_order.push("data_type")
            structure_hash["fields"]["failed_value"]    = {"data_type"=>"text", "file_field"=>"failed_value"}   if field_order.push("failed_value")
            structure_hash["fields"]["failed_reason"]   = {"data_type"=>"text", "file_field"=>"failed_reason"}  if field_order.push("failed_reason")
            structure_hash["fields"]["reported"]        = {"data_type"=>"bool", "file_field"=>"reported"}       if field_order.push("reported") 
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end