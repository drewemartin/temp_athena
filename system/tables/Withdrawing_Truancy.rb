#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class WITHDRAWING_TRUANCY < Athena_Table
    
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
    
    def by_primaryid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_by_primaryid(field_name, primary_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", primary_id) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    #def grades_required
    #    where_clause = "WHERE status = 'ADMIN Verified' OR status = 'Initial Submission'"
    #    records(where_clause)
    #end
    
    def incomplete_by_studentid(studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("status", "=", "PENDING - GRADES") )
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        where_clause << " GROUP BY student_id"
        record(where_clause)
    end
    
    #def records_to_process
    #    $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE status = 'PENDING - GRADES' AND comments regexp '.*need.*grade.*' AND DATE_ADD(effective_date,INTERVAL 2 DAY) < CURDATE()") 
    #end
    
    def records_to_process
        #this should check for records that are not complete after the switch
        where_clause = " WHERE complete IS FALSE OR complete IS NULL"
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
                "name"              => "withdrawing_truancy",
                "file_name"         => "withdrawing_truancy.csv",
                "file_location"     => "withdrawing_truancy",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int",  "file_field"=>"student_id"}                 if field_order.push("student_id")
            structure_hash["fields"]["student_age"]         = {"data_type"=>"int",  "file_field"=>"student_age"}            if field_order.push("student_age")
            structure_hash["fields"]["initiated_date"]      = {"data_type"=>"date", "file_field"=>"initiated_date"}            if field_order.push("initiated_date")
            structure_hash["fields"]["initiator"]           = {"data_type"=>"text", "file_field"=>"initiator"}      if field_order.push("initiator")
            structure_hash["fields"]["relationship"]        = {"data_type"=>"text", "file_field"=>"relationship"}    if field_order.push("relationship")
            structure_hash["fields"]["method"]              = {"data_type"=>"text", "file_field"=>"method"}            if field_order.push("method")
            structure_hash["fields"]["agora_reason"]        = {"data_type"=>"text", "file_field"=>"agora_reason"}         if field_order.push("agora_reason")
            structure_hash["fields"]["k12_reason"]          = {"data_type"=>"text", "file_field"=>"k12_reason"}                if field_order.push("k12_reason")
            structure_hash["fields"]["truancy_dates"]       = {"data_type"=>"text", "file_field"=>"truancy_dates"}  if field_order.push("truancy_dates")
            structure_hash["fields"]["type"]                = {"data_type"=>"text", "file_field"=>"type"}                         if field_order.push("type")
            structure_hash["fields"]["ftc_notified_date"]   = {"data_type"=>"date", "file_field"=>"ftc_notified_date"}            if field_order.push("ftc_notified_date")
            structure_hash["fields"]["ftc_action"]          = {"data_type"=>"text", "file_field"=>"ftc_action"}                   if field_order.push("ftc_action")
            structure_hash["fields"]["processed_date"]      = {"data_type"=>"date", "file_field"=>"processed_date"}               if field_order.push("processed_date")
            structure_hash["fields"]["effective_date"]      = {"data_type"=>"date", "file_field"=>"effective_date"}            if field_order.push("effective_date")
            structure_hash["fields"]["status"]              = {"data_type"=>"text", "file_field"=>"status"}          if field_order.push("status")
            structure_hash["fields"]["complete"]            = {"data_type"=>"bool", "file_field"=>"complete"}                     if field_order.push("complete")
            structure_hash["fields"]["comments"]            = {"data_type"=>"text", "file_field"=>"comments"}     if field_order.push("comments")
            structure_hash["fields"]["transferring_school"] = {"data_type"=>"text", "file_field"=>"transferring_school"}          if field_order.push("transferring_school")
            structure_hash["fields"]["grades_documented"]   = {"data_type"=>"bool", "file_field"=>"grades_documented"}            if field_order.push("grades_documented")
            structure_hash["fields"]["source"]              = {"data_type"=>"text", "file_field"=>"source"}                       if field_order.push("source")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end