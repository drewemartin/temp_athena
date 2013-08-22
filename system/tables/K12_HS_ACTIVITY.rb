#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_HS_ACTIVITY < Athena_Table
    
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
                "name"              => "k12_hs_activity",
                "file_name"         => "k12_hs_activity.csv",
                "file_location"     => "k12_reports",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "High School Activity" 
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
           # structure_hash["fields"]["student_id"]          = {"data_type"=>"int",      "file_field"=>"Student ID"}             if field_order.push("student_id")
           # structure_hash["fields"]["last_login"]          = {"data_type"=>"date",      "file_field"=>"Last Login Date"}       if field_order.push("last_login")
            structure_hash["fields"]["student_id"] = {"data_type"=>"int", "file_field"=>"Student ID"} if field_order.push("student_id")
            structure_hash["fields"]["last_login"] = {"data_type"=>"date", "file_field"=>"Last Login Date"} if field_order.push("last_login")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end