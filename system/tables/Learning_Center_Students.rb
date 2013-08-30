#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class LEARNING_CENTER_STUDENTS < Athena_Table
    
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

    def by_studentid_old(arg) #call when search results should be a single row.
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def current_students(studentid = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",  "=",      studentid    ) ) if studentid
        params.push( Struct::WHERE_PARAMS.new("active", "=", "1"       ) )
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
        $db.get_data_single("SELECT column_name FROM #{data_base}.#{table_name}") 
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
                "name"              => "learning_center_students",
                "file_name"         => "learning_center_students.csv",
                "file_location"     => "learning_center_students",
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
        structure_hash["fields"]["student_id"]  = {"data_type"=>"int", "file_field"=>"student_id"} if field_order.push("student_id")
        structure_hash["fields"]["active"]      = {"data_type"=>"bool", "file_field"=>"active"} if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end