#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEP_STUDENTS < Athena_Table
    
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
        where_clause << " ORDER BY `invite_date` DESC"
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
                "name"              => "tep_students",
                "file_name"         => "tep_students.csv",
                "file_location"     => "tep_students",
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
            structure_hash["fields"]["studentid"] = {"data_type"=>"int", "file_field"=>"studentid"} if field_order.push("studentid")
            structure_hash["fields"]["tep_report_id"] = {"data_type"=>"int", "file_field"=>"tep_report_id"} if field_order.push("tep_report_id")
            structure_hash["fields"]["kmail_id"] = {"data_type"=>"int", "file_field"=>"kmail_id"} if field_order.push("kmail_id")
            structure_hash["fields"]["invite_date"] = {"data_type"=>"date", "file_field"=>"invite_date"} if field_order.push("invite_date")
            structure_hash["fields"]["attended_meeting"] = {"data_type"=>"bool", "file_field"=>"attended_meeting"} if field_order.push("attended_meeting")
            structure_hash["fields"]["attended_meeting_date"] = {"data_type"=>"date", "file_field"=>"attended_meeting_date"} if field_order.push("attended_meeting_date")
            structure_hash["fields"]["tep_returned"] = {"data_type"=>"bool", "file_field"=>"tep_returned"} if field_order.push("tep_returned")
            structure_hash["fields"]["tep_returned_date"] = {"data_type"=>"date", "file_field"=>"tep_returned_date"} if field_order.push("tep_returned_date")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end