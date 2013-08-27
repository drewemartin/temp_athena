#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_ELLUMINATE_SESSION < Athena_Table
    
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

    def by_studentid_old(arg, session_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("attendee_start_time", "REGEXP", "#{session_date}.*") ) if session_date
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
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_elluminate_session",
                "file_name"         => "agora_elluminate_session.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_elluminate_session_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Elluminate Session"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["session_owner"]       = {"data_type"=>"text",     "file_field"=>"Session Owner"}                  if field_order.push("session_owner")
            structure_hash["fields"]["attendee_name"]       = {"data_type"=>"text",     "file_field"=>"Attendee Name"}                  if field_order.push("attendee_name")
            structure_hash["fields"]["name_of_session"]     = {"data_type"=>"text",     "file_field"=>"Name of Session"}                if field_order.push("name_of_session")
            structure_hash["fields"]["display_name"]        = {"data_type"=>"text",     "file_field"=>"Display Name"}                   if field_order.push("display_name")
            structure_hash["fields"]["attendee_role"]       = {"data_type"=>"text",     "file_field"=>"Attendee Role"}                  if field_order.push("attendee_role")
            structure_hash["fields"]["invitee_role"]        = {"data_type"=>"text",     "file_field"=>"Invitee Role"}                   if field_order.push("invitee_role")
            structure_hash["fields"]["attendee_id"]         = {"data_type"=>"int",      "file_field"=>"Attendee ID"}                    if field_order.push("attendee_id")
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int",      "file_field"=>"SAMS Student ID"}                if field_order.push("student_id")
            structure_hash["fields"]["invitee_id"]          = {"data_type"=>"int",      "file_field"=>"Invitee ID"}                     if field_order.push("invitee_id")
            structure_hash["fields"]["session_start_time"]  = {"data_type"=>"date",     "file_field"=>"Session Start Time (ET)"}        if field_order.push("session_start_time")
            structure_hash["fields"]["session_end_time"]    = {"data_type"=>"date",     "file_field"=>"Session End Time (ET)"}          if field_order.push("session_end_time")
            structure_hash["fields"]["attendee_start_time"] = {"data_type"=>"date",     "file_field"=>"Attendee Start Time (ET)"}       if field_order.push("attendee_start_time")
            structure_hash["fields"]["attendee_end_time"]   = {"data_type"=>"date",     "file_field"=>"Attendee End Time (ET)"}         if field_order.push("attendee_end_time")
            structure_hash["fields"]["duration_in_session"] = {"data_type"=>"text",     "file_field"=>"Duration in Session"}            if field_order.push("duration_in_session")
            structure_hash["fields"]["abbreviation"]        = {"data_type"=>"text",     "file_field"=>"ABBREVIATION"}                   if field_order.push("abbreviation")
            structure_hash["fields"]["name"]                = {"data_type"=>"text",     "file_field"=>"NAME"}                           if field_order.push("name")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end