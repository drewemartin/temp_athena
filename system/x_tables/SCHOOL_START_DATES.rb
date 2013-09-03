#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCHOOL_START_DATES < Athena_Table
    
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

    ##sample->
    #def sample_record(arg) #call when search results should be a single row.
    #    params = Array.new
    #    params.push( Struct::WHERE_PARAMS.new("field_name", "evaluator", arg) )
    #    where_clause = $db.where_clause(params)
    #    record(where_clause) 
    #end
    #
    ##sample->
    #def sample_records(arg) #call when search results can be more than a single row.
    #    params = Array.new
    #    params.push( Struct::WHERE_PARAMS.new("field_name", "evaluator", arg) )
    #    where_clause = $db.where_clause(params)
    #    records(where_clause) 
    #end
    #
    ##sample->
    #def sample_type_with_records
    #    $db.get_data_single("SELECT column_name FROM #{table_name}") 
    #end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
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
                "name"              => "school_start_dates",
                "file_name"         => "school_start_dates.csv",
                "file_location"     => "school_start_dates",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["start_date"]                  = {"data_type"=>"date", "file_field"=>"start_date"}                 if field_order.push("start_date")
            structure_hash["fields"]["grade_range"]                 = {"data_type"=>"text", "file_field"=>"grade_range"}                if field_order.push("grade_range")
            structure_hash["fields"]["deadline_without_computer"]   = {"data_type"=>"date", "file_field"=>"deadline_without_computer"}  if field_order.push("deadline_without_computer")
            structure_hash["fields"]["deadline_with_computer"]      = {"data_type"=>"date", "file_field"=>"deadline_with_computer"}     if field_order.push("deadline_with_computer")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end