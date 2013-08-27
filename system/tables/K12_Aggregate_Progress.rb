#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_AGGREGATE_PROGRESS < Athena_Table
    
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
    alias :by_sams_id :by_studentid_old
    
    def by_studentid_record(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("sams_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT sams_id FROM #{table_name} GROUP BY sams_id") 
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
                "name"              => "k12_aggregate_progress",
                "file_name"         => "agora_aggregate_progress.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_aggregateProg.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "Aggregate Progress"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["classroom_name"]               = {"data_type"=>"text",                                        "file_field"=>"Classroom Name"}               if field_order.push("classroom_name")
        structure_hash["fields"]["identity_id"]                  = {"data_type"=>"int",                                         "file_field"=>"Identity ID"}                  if field_order.push("identity_id")
        structure_hash["fields"]["sams_id"]                      = {"data_type"=>"int",                                         "file_field"=>"SAMS ID"}                      if field_order.push("sams_id")
        structure_hash["fields"]["student_last_name"]            = {"data_type"=>"text",                                        "file_field"=>"Student Last Name"}            if field_order.push("student_last_name")
        structure_hash["fields"]["student_first_name"]           = {"data_type"=>"text",                                        "file_field"=>"Student First Name"}           if field_order.push("student_first_name")
        structure_hash["fields"]["learning_coach_last_name"]     = {"data_type"=>"text",                                        "file_field"=>"Learning Coach Last Name"}     if field_order.push("learning_coach_last_name")
        structure_hash["fields"]["student_grade_level"]          = {"data_type"=>"text",                                        "file_field"=>"Student Grade Level"}          if field_order.push("student_grade_level")
        structure_hash["fields"]["math_progress_percent"]        = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Math progress percent"}        if field_order.push("math_progress_percent")
        structure_hash["fields"]["la/ls_progress_percent"]       = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"LA/LS progress percent"}       if field_order.push("la/ls_progress_percent")
        structure_hash["fields"]["lit/phonics_progress_percent"] = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Lit/Phonics progress percent"} if field_order.push("lit/phonics_progress_percent")
        structure_hash["fields"]["spelling_progress_percent"]    = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Spelling progress percent"}    if field_order.push("spelling_progress_percent")
        structure_hash["fields"]["history_progress_percent"]     = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"History progress percent"}     if field_order.push("history_progress_percent")
        structure_hash["fields"]["science_progress_percent"]     = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Science progress percent"}     if field_order.push("science_progress_percent")
        structure_hash["fields"]["art_progress_percent"]         = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Art progress percent"}         if field_order.push("art_progress_percent")
        structure_hash["fields"]["music_progress_percent"]       = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Music progress percent"}       if field_order.push("music_progress_percent")
        structure_hash["fields"]["other_progress_percent"]       = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage,  "file_field"=>"Other progress percent"}       if field_order.push("other_progress_percent")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end