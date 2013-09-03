#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DORA_DOMA_PARTICIPATION_FALL < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{table_name}") 
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
                "name"              => "dora_doma_participation_fall",
                "file_name"         => "dora_doma_participation_fall.csv",
                "file_location"     => "dora_doma_participation_fall",
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
            structure_hash["fields"]["teacher_logins"] = {"data_type"=>"text", "file_field"=>"Teacher Login"} if field_order.push("teacher_logins")
            structure_hash["fields"]["lgl_id"] = {"data_type"=>"int", "file_field"=>"LGL ID"} if field_order.push("lgl_id")
            structure_hash["fields"]["student_id"] = {"data_type"=>"int", "file_field"=>"STU ID"} if field_order.push("student_id")
            structure_hash["fields"]["first_name"] = {"data_type"=>"text", "file_field"=>"Fname"} if field_order.push("first_name")
            structure_hash["fields"]["last_name"] = {"data_type"=>"text", "file_field"=>"LName"} if field_order.push("last_name")
            structure_hash["fields"]["birthday"] = {"data_type"=>"date", "file_field"=>"DOB"} if field_order.push("birthday")
            structure_hash["fields"]["grade"] = {"data_type"=>"int", "file_field"=>"Grade"} if field_order.push("grade")
            structure_hash["fields"]["doma_test_date"] = {"data_type"=>"date", "file_field"=>"DOMA BMS"} if field_order.push("doma_test_date")
            structure_hash["fields"]["dora_test_date"] = {"data_type"=>"date", "file_field"=>"DORA"} if field_order.push("dora_test_date")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end