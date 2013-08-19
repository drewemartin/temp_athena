#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_STI_INTERVENTION < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT studentid FROM #{table_name} GROUP BY student_id") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def trigger_event(arg)
        case arg
        when "after_insert"
        when "before_insert"
        when "after_load"
        when "before_load"
        when "after_save"
        when "before_save"
        when "after_update"
        when "before_update"
        end
        "overwrite"
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "k12_sti_intervention",
                "file_name"         => "agora_sti_intervention.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_sti_intervention_report.csv",
                "source_type"       => "k12_report",
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
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",      "file_field"=>"STUDENTID"}          if field_order.push("student_id")
            structure_hash["fields"]["identityid"]              = {"data_type"=>"int",      "file_field"=>"IDENTITYID"}         if field_order.push("identityid")
            structure_hash["fields"]["student_firstname"]       = {"data_type"=>"text",     "file_field"=>"STUDENT_FIRSTNAME"}  if field_order.push("student_firstname")
            structure_hash["fields"]["student_lastname"]        = {"data_type"=>"text",     "file_field"=>"STUDENT_LASTNAME"}   if field_order.push("student_lastname")
            structure_hash["fields"]["grade"]                   = {"data_type"=>"text",     "file_field"=>"GRADE"}              if field_order.push("grade")
            structure_hash["fields"]["gradelevelid"]            = {"data_type"=>"int",      "file_field"=>"GRADELEVELID"}       if field_order.push("gradelevelid")
            structure_hash["fields"]["school_name"]             = {"data_type"=>"text",     "file_field"=>"SCHOOL_NAME"}        if field_order.push("school_name")
            structure_hash["fields"]["schoolid"]                = {"data_type"=>"int",      "file_field"=>"SCHOOLID"}           if field_order.push("schoolid")
            structure_hash["fields"]["teacher_firstname"]       = {"data_type"=>"text",     "file_field"=>"TEACHER_FIRSTNAME"}  if field_order.push("teacher_firstname")
            structure_hash["fields"]["teacher_lastname"]        = {"data_type"=>"text",     "file_field"=>"TEACHER_LASTNAME"}   if field_order.push("teacher_lastname")
            structure_hash["fields"]["template_name"]           = {"data_type"=>"text",     "file_field"=>"TEMPLATE_NAME"}      if field_order.push("template_name")
            structure_hash["fields"]["communicationdate"]       = {"data_type"=>"date",     "file_field"=>"COMMUNICATIONDATE"}  if field_order.push("communicationdate")
            structure_hash["fields"]["type_name"]               = {"data_type"=>"text",     "file_field"=>"TYPE_NAME"}          if field_order.push("type_name")
            structure_hash["fields"]["modify_date"]             = {"data_type"=>"date",     "file_field"=>"MODIFY_DATE"}        if field_order.push("modify_date")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end