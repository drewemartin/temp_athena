#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_CALMS_AGGREGATE_PROGRESS < Athena_Table
    
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

    def by_coursecode_studentid(coursecode, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("coursecode", "=", coursecode) )
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=", studentid) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_studentid_math(studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("coursecode", "REGEXP", "Geometry|Algebra|Math") )
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=", studentid) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def students_with_records
        $db.get_data_single("SELECT studentid FROM #{table_name} GROUP BY studentid") 
    end

    def class_risk_level(school_days, progress) #accepts a total number of school days, and the class progress to date
        target      = (school_days * 0.005556)
        advanced    = target + (target * 0.25) 
        below_basic = target - (target * 0.25)
        at_risk     = target - (target * 0.50)
        if progress >= advanced
            return 0
        elsif progress >= target && progress < advanced
            return 1
        elsif progress >= below_basic && progress < target
            return 2
        elsif progress >= at_risk && progress < below_basic
            return 3
        elsif progress < at_risk
            return 4
        end
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
                "name"              => "k12_calms_aggregate_progress",
                "file_name"         => "agora_calms_aggregateProg.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_calms_aggregateProg.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "CALMS Aggregate Progress"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["schoolid"]                      = {"data_type"=>"int",            "file_field"=>"SCHOOLID"}                      if field_order.push("schoolid")
        structure_hash["fields"]["schoolname"]                    = {"data_type"=>"text",           "file_field"=>"SCHOOLNAME"}                    if field_order.push("schoolname")
        structure_hash["fields"]["coursename"]                    = {"data_type"=>"text",           "file_field"=>"COURSENAME"}                    if field_order.push("coursename")
        structure_hash["fields"]["coursecode"]                    = {"data_type"=>"text",           "file_field"=>"COURSECODE"}                    if field_order.push("coursecode")
        structure_hash["fields"]["studentid"]                     = {"data_type"=>"int",            "file_field"=>"STUDENTID"}                     if field_order.push("studentid")
        structure_hash["fields"]["student_fname"]                 = {"data_type"=>"text",           "file_field"=>"STUDENT_FNAME"}                 if field_order.push("student_fname")
        structure_hash["fields"]["student_lname"]                 = {"data_type"=>"text",           "file_field"=>"STUDENT_LNAME"}                 if field_order.push("student_lname")
        structure_hash["fields"]["gradelevel"]                    = {"data_type"=>"text",           "file_field"=>"GRADELEVEL"}                    if field_order.push("gradelevel")
        structure_hash["fields"]["coursestartdate"]               = {"data_type"=>"date",           "file_field"=>"COURSESTARTDATE"}               if field_order.push("coursestartdate")
        structure_hash["fields"]["first_lesson_completed_time"]   = {"data_type"=>"date",           "file_field"=>"FIRST_LESSON_COMPLETED_TIME"}   if field_order.push("first_lesson_completed_time")
        structure_hash["fields"]["number_core_lessons_completed"] = {"data_type"=>"int",            "file_field"=>"NUMBER_CORE_LESSONS_COMPLETED"} if field_order.push("number_core_lessons_completed")
        structure_hash["fields"]["number_core_lessons"]           = {"data_type"=>"int",            "file_field"=>"NUMBER_CORE_LESSONS"}           if field_order.push("number_core_lessons")
        structure_hash["fields"]["percent_progress"]              = {"data_type"=>"decimal(5,4)",   :file_data_type=>:percent_number, "file_field"=>"PERCENT_PROGRESS"}              if field_order.push("percent_progress")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end