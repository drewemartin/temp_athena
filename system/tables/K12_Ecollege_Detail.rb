#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_ECOLLEGE_DETAIL < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("sams_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("sams_id", "=", studentid) )
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
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_ecollege_detail",
                "file_name"         => "agora_ecollege_detail.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_ecollege_detail_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "ECollege Detail" 
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_last_name"]           = {"data_type"=>"text",  "file_field"=>"STUDENT LAST NAME"}       if field_order.push("student_last_name")
        structure_hash["fields"]["student_first_name"]          = {"data_type"=>"text",  "file_field"=>"STUDENT FIRST NAME"}      if field_order.push("student_first_name")
        structure_hash["fields"]["student_grade_level"]         = {"data_type"=>"int",   "file_field"=>"STUDENT GRADE LEVEL"}     if field_order.push("student_grade_level")
        structure_hash["fields"]["sams_id"]                     = {"data_type"=>"int",   "file_field"=>"SAMS ID"}                 if field_order.push("sams_id")
        structure_hash["fields"]["iep"]                         = {"data_type"=>"text",  "file_field"=>"IEP"}                     if field_order.push("iep")
        structure_hash["fields"]["identity_id"]                 = {"data_type"=>"int",   "file_field"=>"IDENTITY ID"}             if field_order.push("identity_id")
        structure_hash["fields"]["last_login_date"]             = {"data_type"=>"date",  "file_field"=>"LAST LOGIN DATE"}         if field_order.push("last_login_date")
        structure_hash["fields"]["total_minutes"]               = {"data_type"=>"int",   "file_field"=>"TOTAL MINUTES"}           if field_order.push("total_minutes")
        structure_hash["fields"]["classroom_name"]              = {"data_type"=>"text",  "file_field"=>"CLASSROOM NAME"}          if field_order.push("classroom_name")
        structure_hash["fields"]["sams_course_name"]            = {"data_type"=>"text",  "file_field"=>"SAMS COURSE NAME"}        if field_order.push("sams_course_name")
        structure_hash["fields"]["ecollege_course_name"]        = {"data_type"=>"text",  "file_field"=>"ECOLLEGE COURSE NAME"}    if field_order.push("ecollege_course_name")
        structure_hash["fields"]["teacher_first_name"]          = {"data_type"=>"text",  "file_field"=>"TEACHER FIRST NAME"}      if field_order.push("teacher_first_name")
        structure_hash["fields"]["teacher_last_name"]           = {"data_type"=>"text",  "file_field"=>"TEACHER LAST NAME"}       if field_order.push("teacher_last_name")
        structure_hash["fields"]["course_start_date"]           = {"data_type"=>"date",  "file_field"=>"COURSE START DATE"}       if field_order.push("course_start_date")
        structure_hash["fields"]["term"]                        = {"data_type"=>"text",  "file_field"=>"TERM"}                    if field_order.push("term")
        structure_hash["fields"]["total_items_graded"]          = {"data_type"=>"int",   "file_field"=>"TOTAL ITEMS GRADED"}      if field_order.push("total_items_graded")
        structure_hash["fields"]["total_points_received"]       = {"data_type"=>"int",   "file_field"=>"TOTAL POINTS RECEIVED"}   if field_order.push("total_points_received")
        structure_hash["fields"]["total_points_possible"]       = {"data_type"=>"int",   "file_field"=>"TOTAL POINTS POSSIBLE"}   if field_order.push("total_points_possible")
        structure_hash["fields"]["total_points_for_course"]     = {"data_type"=>"int",   "file_field"=>"TOTAL POINTS FOR COURSE"} if field_order.push("total_points_for_course")
        structure_hash["fields"]["course_progress_overall"]     = {"data_type"=>"decimal(5,4)", :file_data_type=>:percent_number, "file_field"=>"COURSE PROGRESS OVERALL"} if field_order.push("course_progress_overall")
        structure_hash["fields"]["course_average_to_date"]      = {"data_type"=>"decimal(5,4)", :file_data_type=>:percent_number, "file_field"=>"COURSE AVERAGE TO DATE"}  if field_order.push("course_average_to_date")
        structure_hash["fields"]["letter_grade"]                = {"data_type"=>"text",  "file_field"=>"LETTER GRADE"}            if field_order.push("letter_grade")
        structure_hash["fields"]["school_name"]                 = {"data_type"=>"text",  "file_field"=>"SCHOOL NAME"}             if field_order.push("school_name")
        structure_hash["fields"]["hr_teacher_first_name"]       = {"data_type"=>"text",  "file_field"=>"HR TEACHER FIRST NAME"}   if field_order.push("hr_teacher_first_name")
        structure_hash["fields"]["hr_teacher_last_name"]        = {"data_type"=>"text",  "file_field"=>"HR TEACHER LAST NAME"}    if field_order.push("hr_teacher_last_name")
        structure_hash["fields"]["lc_first_name"]               = {"data_type"=>"text",  "file_field"=>"LC FIRST NAME"}           if field_order.push("lc_first_name")
        structure_hash["fields"]["lc_lastname"]                 = {"data_type"=>"text",  "file_field"=>"LC LASTNAME"}             if field_order.push("lc_lastname")
        structure_hash["fields"]["lc_homephone"]                = {"data_type"=>"text",  "file_field"=>"LC HOMEPHONE"}            if field_order.push("lc_homephone")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end