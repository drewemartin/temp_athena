#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DNC_STUDENTS < Athena_Table
    
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
    
    def students_with_records
        $db.get_data_single("SELECT studentid FROM #{data_base}.#{table_name}") 
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
                "name"              => "dnc_students",
                "file_name"         => "dnc_students.csv",
                "file_location"     => "dnc_students",
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
            structure_hash["fields"]["studentid"]   = {"data_type"=>"int",  "file_field"=>"student_id"}  if field_order.push("studentid")
            structure_hash["fields"]["reason"]      = {"data_type"=>"text", "file_field"=>"reason"}      if field_order.push("reason")
            structure_hash["fields"]["category"]    = {"data_type"=>"int",  "file_field"=>"category"}    if field_order.push("category")
            structure_hash["fields"]["authorizer"]  = {"data_type"=>"text", "file_field"=>"authorizer"}  if field_order.push("authorizer")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end