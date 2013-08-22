#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_STUDENT_COURSE < Athena_Table
    
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
        record(where_clause) 
    end
    
    def by_classroom_name(classroom_name, student_id = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("classroomname",  "=", classroom_name ) )
        params.push( Struct::WHERE_PARAMS.new("studentid",      "=", student_id     ) ) if student_id
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "k12_student_course",
                "file_name"         => "agora_student_course_report.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_studentCourse.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Student Course"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["studentid"]           = {"data_type"=>"int",  "file_field"=>"Student ID"}             if field_order.push("studentid")
        structure_hash["fields"]["identity_id"]         = {"data_type"=>"int",  "file_field"=>"Identity ID"}            if field_order.push("identity_id")
        structure_hash["fields"]["student_last_name"]   = {"data_type"=>"text", "file_field"=>"Student Last Name"}      if field_order.push("student_last_name")
        structure_hash["fields"]["student_first_name"]  = {"data_type"=>"text", "file_field"=>"Student First Name"}     if field_order.push("student_first_name")
        structure_hash["fields"]["enroll_aprove_date"]  = {"data_type"=>"text", "file_field"=>"Enroll Aprove Date"}     if field_order.push("enroll_aprove_date")
        structure_hash["fields"]["student_grade_level"] = {"data_type"=>"text", "file_field"=>"Student Grade Level"}    if field_order.push("student_grade_level")
        structure_hash["fields"]["pri_teacher_id"]      = {"data_type"=>"int",  "file_field"=>"Pri Teacher ID"}         if field_order.push("pri_teacher_id")
        structure_hash["fields"]["teacher_last_name"]   = {"data_type"=>"text", "file_field"=>"Teacher Last Name"}      if field_order.push("teacher_last_name")
        structure_hash["fields"]["teacher_first_name"]  = {"data_type"=>"text", "file_field"=>"Teacher First name"}     if field_order.push("teacher_first_name")
        structure_hash["fields"]["course_id"]           = {"data_type"=>"int",  "file_field"=>"Course ID"}              if field_order.push("course_id")
        structure_hash["fields"]["course_code"]         = {"data_type"=>"text", "file_field"=>"Course Code"}            if field_order.push("course_code")
        structure_hash["fields"]["course_name"]         = {"data_type"=>"text", "file_field"=>"Course Name"}            if field_order.push("course_name")
        structure_hash["fields"]["course_start_date"]   = {"data_type"=>"date", "file_field"=>"Course Start Date"}      if field_order.push("course_start_date")
        structure_hash["fields"]["classroomname"]       = {"data_type"=>"text", "file_field"=>"CLASSROOMNAME"}          if field_order.push("classroomname")
        structure_hash["fields"]["cpersonid"]           = {"data_type"=>"int",  "file_field"=>"CPERSONID"}              if field_order.push("cpersonid")
        structure_hash["fields"]["teacherfirstname"]    = {"data_type"=>"text", "file_field"=>"TEACHERFIRSTNAME"}       if field_order.push("teacherfirstname")
        structure_hash["fields"]["teacherlastname"]     = {"data_type"=>"text", "file_field"=>"TEACHERLASTNAME"}        if field_order.push("teacherlastname")
        structure_hash["fields"]["school_name"]         = {"data_type"=>"text", "file_field"=>"School Name"}            if field_order.push("school_name")
        structure_hash["fields"]["final_grade"]         = {"data_type"=>"text", "file_field"=>"Final Grade"}            if field_order.push("final_grade")
        structure_hash["fields"]["grade_status"]        = {"data_type"=>"text", "file_field"=>"Grade Status"}           if field_order.push("grade_status")
        structure_hash["fields"]["do_not_promote"]      = {"data_type"=>"text", "file_field"=>"DONOTPROMOTE"}           if field_order.push("do_not_promote")
        
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end