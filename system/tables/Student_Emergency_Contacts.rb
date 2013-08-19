#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_EMERGENCY_CONTACTS < Athena_Table
    
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

    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("deleted", "!=", "1") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def max_contacts_per_student
        select_sql =
        "SELECT COUNT(student_id)
        FROM `student_emergency_contacts`
        GROUP BY student_id
        HAVING COUNT(student_id) > 1
        ORDER BY COUNT(student_id) DESC"
        $db.get_data_single(select_sql)[0]
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
                "name"              => "student_emergency_contacts",
                "file_name"         => "student_emergency_contacts.csv",
                "file_location"     => "student_emergency_contacts",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]       = {"data_type"=>"int",  "file_field"=>"student_id"}        if field_order.push("student_id")
            structure_hash["fields"]["first_name"]       = {"data_type"=>"text", "file_field"=>"first_name"}        if field_order.push("first_name")
            structure_hash["fields"]["last_name"]        = {"data_type"=>"text", "file_field"=>"last_name"}         if field_order.push("last_name")
            structure_hash["fields"]["phone_number"]     = {"data_type"=>"text", "file_field"=>"phone_number"}      if field_order.push("phone_number")
            structure_hash["fields"]["alt_phone_number"] = {"data_type"=>"text", "file_field"=>"alt_phone_number"}  if field_order.push("alt_phone_number")
            structure_hash["fields"]["comments"]         = {"data_type"=>"text", "file_field"=>"comments"}          if field_order.push("comments")
            structure_hash["fields"]["deleted"]          = {"data_type"=>"bool", "file_field"=>"deleted"}           if field_order.push("deleted")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end