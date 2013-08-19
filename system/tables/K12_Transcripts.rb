#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_TRANSCRIPTS < Athena_Table
    
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

    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{table_name}") 
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
                "name"              => "k12_transcripts",
                "file_name"         => "k12_transcripts.csv",
                "file_location"     => "k12_reports",
                "source_address"    => nil,
                "source_type"       => :k12_screen_scrap,
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
            structure_hash["fields"]["studentid"]                       = {"data_type"=>"int",          "file_field"=>"StudentID"}                      if field_order.push("studentid")
            structure_hash["fields"]["first_name"]                      = {"data_type"=>"text",         "file_field"=>"First Name"}                     if field_order.push("first_name")
            structure_hash["fields"]["last_name"]                       = {"data_type"=>"text",         "file_field"=>"Last Name"}                      if field_order.push("last_name")
            structure_hash["fields"]["grade"]                           = {"data_type"=>"int",          "file_field"=>"Grade"}                          if field_order.push("grade")
            structure_hash["fields"]["enter_date"]                      = {"data_type"=>"date",         "file_field"=>"Enter Date"}                     if field_order.push("enter_date")
            structure_hash["fields"]["cohort_year"]                     = {"data_type"=>"int",          "file_field"=>"Cohort Year"}                    if field_order.push("cohort_year")
            structure_hash["fields"]["graduation_date"]                 = {"data_type"=>"date",         "file_field"=>"Graduation Date"}                if field_order.push("graduation_date")
            structure_hash["fields"]["diploma"]                         = {"data_type"=>"text",         "file_field"=>"Diploma"}                        if field_order.push("diploma")
            structure_hash["fields"]["credits_required"]                = {"data_type"=>"decimal(4,2)",      "file_field"=>"Credits Required"}               if field_order.push("credits_required")
            structure_hash["fields"]["hs_transfer_credits"]             = {"data_type"=>"decimal(4,2)",      "file_field"=>"HS Transfer Credits"}            if field_order.push("hs_transfer_credits")
            structure_hash["fields"]["concurrent_enrollment_credits"]   = {"data_type"=>"decimal(4,2)",      "file_field"=>"Concurrent Enrollment Credits"}  if field_order.push("concurrent_enrollment_credits")
            structure_hash["fields"]["k12_earned_credits"]              = {"data_type"=>"decimal(4,2)",      "file_field"=>"K12 Earned Credits"}             if field_order.push("k12_earned_credits")
            structure_hash["fields"]["total_credits"]                   = {"data_type"=>"decimal(4,2)",      "file_field"=>"Total Credits"}                  if field_order.push("total_credits")
            structure_hash["fields"]["credits_needed_to_graduate"]      = {"data_type"=>"decimal(4,2)",      "file_field"=>"Credits Needed to Graduate"}     if field_order.push("credits_needed_to_graduate")
            structure_hash["fields"]["earned_but_not_needed_credits"]   = {"data_type"=>"decimal(4,2)",      "file_field"=>"Earned, but Not Needed Credits"} if field_order.push("earned_but_not_needed_credits")
            structure_hash["fields"]["k12_courses_only_gpa"]            = {"data_type"=>"decimal(5,4)", "file_field"=>"K12 Courses Only GPA"}           if field_order.push("k12_courses_only_gpa")
            structure_hash["fields"]["academic_gpa"]                    = {"data_type"=>"decimal(5,4)", "file_field"=>"Academic GPA"}                   if field_order.push("academic_gpa")
            structure_hash["fields"]["weighted_k12_courses_only_gpa"]   = {"data_type"=>"decimal(5,4)", "file_field"=>"Weighted K12 Courses Only GPA"}  if field_order.push("weighted_k12_courses_only_gpa")
            structure_hash["fields"]["weighted_academic_gpa"]           = {"data_type"=>"decimal(5,4)", "file_field"=>"Weighted Academic GPA"}          if field_order.push("weighted_academic_gpa")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end