#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_PASSING < Athena_Table
    
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

    def by_studentid_old(studentid, term = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        params.push( Struct::WHERE_PARAMS.new("term",       "=", term) ) if term
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid, term = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        params.push( Struct::WHERE_PARAMS.new("term",       "=", term) ) if term
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
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
                "name"              => "student_passing",
                "file_name"         => "student_passing.csv",
                "file_location"     => "student_passing",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"] = {"data_type"=>"int", "file_field"=>"student_id"} if field_order.push("student_id")
            structure_hash["fields"]["course_code"] = {"data_type"=>"text", "file_field"=>"course_code"} if field_order.push("course_code")
            structure_hash["fields"]["subject"] = {"data_type"=>"text", "file_field"=>"subject"} if field_order.push("subject")
            structure_hash["fields"]["term"] = {"data_type"=>"text", "file_field"=>"term"} if field_order.push("term")
            structure_hash["fields"]["mark"] = {"data_type"=>"text", "file_field"=>"mark"} if field_order.push("mark")
            structure_hash["fields"]["passing"] = {"data_type"=>"bool", "file_field"=>"passing"} if field_order.push("passing")
            structure_hash["fields"]["percent"] = {"data_type"=>"decimal(5,4)", :file_data_type=>:percent_number, "file_field"=>"percent"} if field_order.push("percent")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end