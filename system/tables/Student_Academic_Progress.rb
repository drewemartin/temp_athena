#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ACADEMIC_PROGRESS < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure    = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def by_studentid_old(sid, term=nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",  "=", sid   ) )
        params.push( Struct::WHERE_PARAMS.new("term",        "=", term  ) ) if term
        where_clause = $db.where_clause(params)
        
        records(where_clause)
        
    end
    
    def new_row_if_none_exists(sid, course_code, data_source, term)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=", sid            ) )
        params.push( Struct::WHERE_PARAMS.new("course_code",    "=", course_code    ) )
        params.push( Struct::WHERE_PARAMS.new("data_source",    "=", data_source    ) )
        params.push( Struct::WHERE_PARAMS.new("term",           "=", term           ) )
        where_clause = $db.where_clause(params)
        
        progress_record = record(where_clause)
        
        if !progress_record
            progress_record = new_row
            progress_record.fields["student_id" ].value = sid
            progress_record.fields["course_code"].value = course_code
            progress_record.fields["data_source"].value = data_source
            progress_record.fields["term"       ].value = term
        end
        
        return progress_record
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_aggregate_progress
        
        data_source = "K12_Aggregate_Progress"
        
        sids = $tables.attach("K12_Aggregate_Progress").students_with_records
        sids.each{|sid|
            
            records = $tables.attach("K12_Aggregate_Progress").by_studentid_old(sid) 
            records[0].fields.each_pair{|field,details|
                
                if field.match(/progress_percent/) && details.value && details.value.to_f > 0
                    
                    subject     = field.gsub("_progress_percent","").upcase
                    percentage  = details.value
                    
                    progress_record = new_row_if_none_exists(sid, course_code=subject, data_source, $school.current_term.value)
                        
                        progress_record.fields["classroom_name"               ].value = nil                    
                        progress_record.fields["course_name"                  ].value = subject             
                        progress_record.fields["start_date"                   ].value = nil             
                        progress_record.fields["completion"                   ].value = nil             
                        progress_record.fields["progress"                     ].value = percentage               
                        progress_record.fields["teacher_name"                 ].value = nil           
                        progress_record.fields["teacher_staff_id"             ].value = nil       
                        progress_record.fields["class_risk_level"             ].value = nil       
                        progress_record.fields["class_risk_level_recent"      ].value = nil
                        progress_record.fields["engagement_level"             ].value = nil
                        
                    progress_record.save
                    
                end
                
            } if records
            
        } if sids
        
    end
    
    def after_load_k12_calms_aggregate_progress
        
        data_source	= "K12_Calms_Aggregate_Progress"
        pids            = $tables.attach("K12_Calms_Aggregate_Progress").primary_ids
        
        pids.each{|pid|
            
            calms_record        = $tables.attach("K12_Calms_Aggregate_Progress").by_primary_id(pid)
            sid                 = calms_record.fields["studentid"        ].value
            course_code         = calms_record.fields["coursecode"       ].value
            coursename          = calms_record.fields["coursename"       ].value
            startdate           = calms_record.fields["coursestartdate"  ].value
            progress            = calms_record.fields["percent_progress" ]
            
            if progress.mathable
                
                progress_record = new_row_if_none_exists(sid, course_code, data_source, $school.current_term.value)
                    
                    progress_record.fields["classroom_name"               ].value = nil         
                    progress_record.fields["course_code"                  ].value = course_code
                    progress_record.fields["course_name"                  ].value = coursename
                    progress_record.fields["start_date"                   ].value = startdate
                    progress_record.fields["completion"                   ].value = nil
                    progress_record.fields["progress"                     ].value = progress.value
                    progress_record.fields["teacher_name"                 ].value = nil
                    progress_record.fields["teacher_staff_id"             ].value = nil
                    progress_record.fields["class_risk_level"             ].value = nil       
                    progress_record.fields["class_risk_level_recent"      ].value = nil
                    progress_record.fields["engagement_level"             ].value = nil
                    
                progress_record.save
                
            end
            
        } if pids
    end
    
    def after_load_jupiter_grades
        
        data_source     = "Jupiter_Grades"
        pids            = $tables.attach("Jupiter_Grades").primary_ids
        
        pids.each{|pid|
            
            e               = $tables.attach("Jupiter_Grades").by_primary_id(pid)
            progress        = e.fields["percent"]
            course_code     = e.fields["subject"            ].value #THIS IS THE ONLY FIELD THEY'RE FILING OUT
            term            = e.fields["term"               ].value
            
            if progress.mathable
                
                sid         = e.fields["studentid"          ].value
                progress    = e.fields["percent"            ]
                teacher     = e.fields["teacher"            ].value
                
                teacher_staff_id = nil
                if teacher
                    firstname           = teacher.split(", ")[1]
                    lastname            = teacher.split(", ")[0]
                    team_member         = $team.by_k12_name(firstname+" "+lastname)
                    teacher_staff_id    = team_member.samsid.value if team_member
                end
                
                progress_record = new_row_if_none_exists(sid, course_code, data_source, term)
                    
                    progress_record.fields["classroom_name"               ].value = nil                     
                    progress_record.fields["course_name"                  ].value = course_code             
                    progress_record.fields["start_date"                   ].value = nil             
                    progress_record.fields["completion"                   ].value = nil             
                    progress_record.fields["progress"                     ].value = progress.value               
                    progress_record.fields["teacher_name"                 ].value = teacher           
                    progress_record.fields["teacher_staff_id"             ].value = teacher_staff_id       
                    progress_record.fields["class_risk_level"             ].value = nil       
                    progress_record.fields["class_risk_level_recent"      ].value = nil
                    progress_record.fields["engagement_level"             ].value = nil
                    
                progress_record.save
                
            end
            
        } if pids
    end
    
    def after_load_k12_ecollege_detail
        
        data_source = "K12_Ecollege_Detail"
        pids        = $tables.attach("K12_Ecollege_Detail").primary_ids
        
        pids.each{|pid|
            
            e               = $tables.attach("K12_Ecollege_Detail").by_primary_id(pid)
            progress        = e.fields["course_average_to_date"]
            
            if progress.mathable
                
                sid             = e.fields["sams_id"            ].value
                course_code     = e.fields["classroom_name"     ].value 
                course_name     = e.fields["sams_course_name"   ].value.split(": ")[-1]
                t_first_name    = e.fields["teacher_first_name" ].value
                t_last_name     = e.fields["teacher_last_name"  ].value
                
                teacher_staff_id    = nil
                teacher             = t_first_name+" "+t_last_name
                if t_first_name && t_last_name
                    team_member         = $team.by_k12_name(teacher)
                    teacher_staff_id    = team_member.samsid.value if team_member
                end
                
                curr_term = $school.current_term
                
                if curr_term
                    curr_term = $school.current_term.value
                end
                
                progress_record = new_row_if_none_exists(sid, course_code, data_source, curr_term)
                    
                    progress_record.fields["classroom_name"               ].value = nil                    
                    progress_record.fields["course_name"                  ].value = course_name             
                    progress_record.fields["start_date"                   ].value = nil             
                    progress_record.fields["completion"                   ].value = nil             
                    progress_record.fields["progress"                     ].value = progress.value               
                    progress_record.fields["teacher_name"                 ].value = teacher           
                    progress_record.fields["teacher_staff_id"             ].value = teacher_staff_id       
                    progress_record.fields["class_risk_level"             ].value = nil      
                    progress_record.fields["class_risk_level_recent"      ].value = nil
                    progress_record.fields["engagement_level"             ].value = nil
                    
                progress_record.save
                
            end
            
        } if pids
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def class_risk_level(progress)
        school_days = $school.school_days($base.yesterday.iso_date)
        target      = (school_days.length * 0.005556)
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
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_academic_progress",
                "file_name"         => "student_academic_progress.csv",
                "file_location"     => "student_academic_progress",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",          "file_field"=>"student_id"}                 if field_order.push("student_id")
            structure_hash["fields"]["classroom_name"]          = {"data_type"=>"text",         "file_field"=>"classroom_name"}             if field_order.push("classroom_name")
            structure_hash["fields"]["course_code"]             = {"data_type"=>"text",         "file_field"=>"course_code"}                if field_order.push("course_code")
            structure_hash["fields"]["course_name"]             = {"data_type"=>"text",         "file_field"=>"course_name"}                if field_order.push("course_name")
            structure_hash["fields"]["start_date"]              = {"data_type"=>"date",         "file_field"=>"start_date"}                 if field_order.push("start_date")
            structure_hash["fields"]["completion"]              = {"data_type"=>"decimal(5,4)", "file_field"=>"completion"}                 if field_order.push("completion")
            structure_hash["fields"]["progress"]                = {"data_type"=>"decimal(5,4)", "file_field"=>"progress"}                   if field_order.push("progress")
            structure_hash["fields"]["teacher_name"]            = {"data_type"=>"text",         "file_field"=>"teacher_name"}               if field_order.push("teacher_name")
            structure_hash["fields"]["teacher_staff_id"]        = {"data_type"=>"int",          "file_field"=>"teacher_staff_id"}           if field_order.push("teacher_staff_id")
            structure_hash["fields"]["class_risk_level"]        = {"data_type"=>"int",          "file_field"=>"class_risk_level"}           if field_order.push("class_risk_level")
            structure_hash["fields"]["class_risk_level_recent"] = {"data_type"=>"int",          "file_field"=>"class_risk_level_recent"}    if field_order.push("class_risk_level_recent")
            structure_hash["fields"]["engagement_level"]        = {"data_type"=>"int",          "file_field"=>"engagement_level"}           if field_order.push("engagement_level")
            structure_hash["fields"]["data_source"]             = {"data_type"=>"text",         "file_field"=>"data_source"}                if field_order.push("data_source")
            structure_hash["fields"]["term"]                    = {"data_type"=>"text",         "file_field"=>"term"}                       if field_order.push("term")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end