#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_ECOLLEGE_ACTIVITY < Athena_Table
    
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
                "name"              => "k12_ecollege_activity",
                "file_name"         => "agora_ECollegeActivityDuration.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_ECollegeActivityDuration.csv",
                "source_type"       => "k12_report",
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",  "file_field"=>"SAMS ID"}                if field_order.push("student_id")
            structure_hash["fields"]["student_user_id"]         = {"data_type"=>"text", "file_field"=>"STUDENT USER ID"}        if field_order.push("student_user_id")
            structure_hash["fields"]["school_name"]             = {"data_type"=>"text", "file_field"=>"SCHOOL_NAME"}            if field_order.push("school_name")
            structure_hash["fields"]["student_last_name"]       = {"data_type"=>"text", "file_field"=>"STUDENT LAST NAME"}      if field_order.push("student_last_name")
            structure_hash["fields"]["student_first_name"]      = {"data_type"=>"text", "file_field"=>"STUDENT FIRST NAME"}     if field_order.push("student_first_name")
            structure_hash["fields"]["termname"]                = {"data_type"=>"text", "file_field"=>"TERMNAME"}               if field_order.push("termname")
            structure_hash["fields"]["coursename"]              = {"data_type"=>"text", "file_field"=>"COURSENAME"}             if field_order.push("coursename")
            structure_hash["fields"]["k12_course_code"]         = {"data_type"=>"text", "file_field"=>"K12 COURSE CODE"}        if field_order.push("k12_course_code")
            structure_hash["fields"]["classroom_name"]          = {"data_type"=>"text", "file_field"=>"CLASSROOM NAME"}         if field_order.push("classroom_name")
            structure_hash["fields"]["primaryinstructorname"]   = {"data_type"=>"text", "file_field"=>"PRIMARYINSTRUCTORNAME"}  if field_order.push("primaryinstructorname")
            structure_hash["fields"]["course_last_login_date"]  = {"data_type"=>"date", "file_field"=>"COURSE LAST LOGIN DATE"} if field_order.push("course_last_login_date")
            structure_hash["fields"]["total_course_time"]       = {"data_type"=>"text", "file_field"=>"TOTAL COURSE TIME"}      if field_order.push("total_course_time")
            structure_hash["fields"]["activitydate"]            = {"data_type"=>"date", "file_field"=>"ACTIVITYDATE"}           if field_order.push("activitydate")
            structure_hash["fields"]["activityminutes"]         = {"data_type"=>"text", "file_field"=>"ACTIVITYMINUTES"}        if field_order.push("activityminutes")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end