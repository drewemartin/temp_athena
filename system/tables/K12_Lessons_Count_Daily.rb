#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_LESSONS_COUNT_DAILY < Athena_Table
    
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

    def by_studentid_old(arg, last_lesson_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("total_last_lesson", "REGEXP", "#{last_lesson_date}.*") ) if last_lesson_date
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
                "name"              => "k12_lessons_count_daily",
                "file_name"         => "agora_lessons_count_daily.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_lessons_count_daily.csv",
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
            structure_hash["fields"]["pid"]                     = {"data_type"=>"bigint",   "file_field"=>"PID"}                  if field_order.push("pid")
            structure_hash["fields"]["integration_id"]          = {"data_type"=>"text",     "file_field"=>"INTEGRATION_ID"}       if field_order.push("integration_id")
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",      "file_field"=>"SAMS_ID"}              if field_order.push("student_id")
            structure_hash["fields"]["status"]                  = {"data_type"=>"text",     "file_field"=>"STATUS"}               if field_order.push("status")
            structure_hash["fields"]["school_name"]             = {"data_type"=>"text",     "file_field"=>"SCHOOL_NAME"}          if field_order.push("school_name")
            structure_hash["fields"]["first_name"]              = {"data_type"=>"text",     "file_field"=>"FIRST_NAME"}           if field_order.push("first_name")
            structure_hash["fields"]["last_name"]               = {"data_type"=>"text",     "file_field"=>"LAST_NAME"}            if field_order.push("last_name")
            structure_hash["fields"]["last_started"]            = {"data_type"=>"date",     "file_field"=>"LAST_STARTED"}         if field_order.push("last_started")
            structure_hash["fields"]["ols_first_lesson"]        = {"data_type"=>"date",     "file_field"=>"OLS_FIRST_LESSON"}     if field_order.push("ols_first_lesson")
            structure_hash["fields"]["ols_last_lesson"]         = {"data_type"=>"date",     "file_field"=>"OLS_LAST_LESSON"}      if field_order.push("ols_last_lesson")
            structure_hash["fields"]["ols_num_lessons"]         = {"data_type"=>"text",     "file_field"=>"OLS_NUM_LESSONS"}      if field_order.push("ols_num_lessons")
            structure_hash["fields"]["calms_started_lesson"]    = {"data_type"=>"date",     "file_field"=>"CALMS_STARTED_LESSON"} if field_order.push("calms_started_lesson")
            structure_hash["fields"]["calms_first_lesson"]      = {"data_type"=>"date",     "file_field"=>"CALMS_FIRST_LESSON"}   if field_order.push("calms_first_lesson")
            structure_hash["fields"]["calms_last_lesson"]       = {"data_type"=>"date",     "file_field"=>"CALMS_LAST_LESSON"}    if field_order.push("calms_last_lesson")
            structure_hash["fields"]["calms_num_lessons"]       = {"data_type"=>"text",     "file_field"=>"CALMS_NUM_LESSONS"}    if field_order.push("calms_num_lessons")
            structure_hash["fields"]["total_num_lessons"]       = {"data_type"=>"text",     "file_field"=>"TOTAL_NUM_LESSONS"}    if field_order.push("total_num_lessons")
            structure_hash["fields"]["total_first_lesson"]      = {"data_type"=>"date",     "file_field"=>"TOTAL_FIRST_LESSON"}   if field_order.push("total_first_lesson")
            structure_hash["fields"]["total_last_lesson"]       = {"data_type"=>"date",     "file_field"=>"TOTAL_LAST_LESSON"}    if field_order.push("total_last_lesson")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end