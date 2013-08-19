#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DISTRICT_NOTIFICATIONS < Athena_Table
    
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

    def by_studentid_old(student_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_notification_type(type, sid, most_recent = false)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("notification_type", "=", type) )
        where_clause = $db.where_clause(params)
        if most_recent
            where_clause << "ORDER BY created_date"
            record(where_clause)
        else
            records(where_clause)
        end  
    end
    
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
                "name"              => "district_notifications",
                "file_name"         => "district_notifications.csv",
                "file_location"     => "district_notifications",
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
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int", "file_field"=>"student_id"}          if field_order.push("student_id")
            structure_hash["fields"]["notification_type"]   = {"data_type"=>"text", "file_field"=>"notification_type"}  if field_order.push("notification_type")
            structure_hash["fields"]["district"]            = {"data_type"=>"text", "file_field"=>"district"}           if field_order.push("district")
            structure_hash["fields"]["sent_to_email"]       = {"data_type"=>"text", "file_field"=>"sent_to_email"}      if field_order.push("sent_to_email")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end