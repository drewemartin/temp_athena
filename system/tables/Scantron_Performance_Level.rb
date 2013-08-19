#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCANTRON_PERFORMANCE_LEVEL < Athena_Table
    
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
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
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
    
    
    def after_load_scantron_performance_extended_DISABLED
        
        subjects = ["math","reading","science"]
        $tables.attach("SCANTRON_PERFORMANCE_EXTENDED").primary_ids.each{|pid|
            
            performance_record  = $tables.attach("SCANTRON_PERFORMANCE_EXTENDED").by_primary_id(pid).fields
            sid                 = performance_record["student_id"].value
            
            level_record   = by_studentid_old(sid)
            if !level_record
                level_record = new_row
                level_record.fields["student_id"].value = sid
            end
            
            subjects.each{|subject|
                
                performance_level   = nil
                score               = performance_record["#{subject}_scaled_score"]
                test_date           = performance_record["#{subject}_test_date"].value
                ent_ext             = $school.scantron.current_test_phase(test_date)
                
                if ent_ext
                    
                    if score.value && ent_ext
                        score   = score.mathable
                        
                        #this pulls from the scantron record rather than the student's record in case they are testing for a different grade level for some reason. 
                        grade   = performance_record["grade"].value.gsub("Grade ","")
                        grade   = "K" if grade == "0"
                        
                        range   = $tables.attach("Scantron_Performance_Range").by_subject_grade(subject,grade).fields
                        min     = range["target_min"].mathable
                        max     = range["target_max"].mathable
                        if score < min
                            performance_level = "At Risk"
                        elsif score > max
                            performance_level = "Advanced"
                        else
                            performance_level = "On Target"
                        end
                        
                        score_field = "stron_#{ent_ext}_score_#{subject[0].chr}"
                        level_field = "stron_#{ent_ext}_perf_#{subject[0].chr}"
                        level_record.fields[score_field].value = score
                        level_record.fields[level_field].value = performance_level
                        
                        level_record.save
                        
                    end
                    
                else
                    puts "Test date out of range! SID: #{sid} SUBJECT: #{subject} DATE: #{test_date}"
                end
                
            }
            
        }
        move_source_to_dest
    end
    
    def after_load_scantron_performance_recent_DISABLED
        subjects = ["math","reading","science"]
        $tables.attach("SCANTRON_PERFORMANCE_RECENT").students_with_records.each{|sid|
            level_record   = by_studentid_old(sid)
            if !level_record
                level_record = new_row
                level_record.fields["student_id"].value = sid
            end
            performance_record  = $tables.attach("SCANTRON_PERFORMANCE_RECENT").by_studentid_old(sid).fields
            subjects.each{|subject|
                performance_level   = nil
                score               = performance_record["#{subject}_scaled_score"]
                test_date           = performance_record["#{subject}_test_date"].value
                ent_ext             = $school.scantron.current_test_phase(test_date)
                if ent_ext
                    if score.value && ent_ext
                        score   = score.mathable
                        
                        #this pulls from the scantron record rather than the student's record in case they are testing for a different grade level for some reason. 
                        grade   = performance_record["grade"].value.gsub("Grade ","")
                        grade   = "K" if grade == "0"
                        
                        range   = $tables.attach("Scantron_Performance_Range").by_subject_grade(subject,grade).fields
                        min     = range["target_min"].mathable
                        max     = range["target_max"].mathable
                        if score < min
                            performance_level = "At Risk"
                        elsif score > max
                            performance_level = "Advanced"
                        else
                            performance_level = "On Target"
                        end
                    else
                        score = score.value
                        performance_level = "Not Tested"
                    end
                    score_field = "stron_#{ent_ext}_score_#{subject[0].chr}"
                    level_field = "stron_#{ent_ext}_perf_#{subject[0].chr}"
                    level_record.fields[score_field].value = score
                    level_record.fields[level_field].value = performance_level
                else
                    puts "Test date out of range! SID: #{sid} SUBJECT: #{subject} DATE: #{test_date}"
                end
            }
            level_record.save
        }
    end
    
    def after_load_scantron_performance_DISABLED
        ent_ext  = $school.scantron.current_test_phase
        subjects = ["math","reading","science"]
        $tables.attach("Scantron_Performance").students_with_records.each{|sid|
            level_record   = by_studentid_old(sid)
            if !level_record
                level_record = new_row
                level_record.fields["student_id"].value = sid
            end
            subjects.each{|subject|
                performance_level  = nil
                performance_record = $tables.attach("Scantron_Performance").by_studentid_old(sid).fields
                score              = performance_record["#{subject}_scaled_score"]
                if score.value
                    score   = score.mathable
                    grade   = performance_record["grade"].value.gsub("Grade ","")
                    range   = $tables.attach("Scantron_Performance_Range").by_subject_grade(subject,grade).fields
                    min     = range["target_min"].mathable
                    max     = range["target_max"].mathable
                    if score < min
                        performance_level = "At Risk"
                    elsif score > max
                        performance_level = "Advanced"
                    else
                        performance_level = "On Target"
                    end
                else
                    score = score.value
                    performance_level = "Not Tested"
                end
                score_field = "stron_#{ent_ext}_score_#{subject[0].chr}"
                level_field = "stron_#{ent_ext}_perf_#{subject[0].chr}"
                level_record.fields[score_field].value = score
                level_record.fields[level_field].value = performance_level
            }
            level_record.save
        }
        
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "scantron_performance_level",
                "file_name"         => "scantron_performance_level.csv",
                "file_location"     => "scantron_performance_level",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int",  "file_field"=>"student_id"}        if field_order.push("student_id")
            structure_hash["fields"]["stron_ent_perf_m"]    = {"data_type"=>"text", "file_field"=>"stron_ent_perf_m"}  if field_order.push("stron_ent_perf_m")
            structure_hash["fields"]["stron_ent_score_m"]   = {"data_type"=>"int",  "file_field"=>"stron_ent_score_m"} if field_order.push("stron_ent_score_m")
            structure_hash["fields"]["stron_ext_perf_m"]    = {"data_type"=>"text", "file_field"=>"stron_ext_perf_m"}  if field_order.push("stron_ext_perf_m")
            structure_hash["fields"]["stron_ext_score_m"]   = {"data_type"=>"int",  "file_field"=>"stron_ext_score_m"} if field_order.push("stron_ext_score_m")
            structure_hash["fields"]["stron_ent_perf_r"]    = {"data_type"=>"text", "file_field"=>"stron_ent_perf_r"}  if field_order.push("stron_ent_perf_r")
            structure_hash["fields"]["stron_ent_score_r"]   = {"data_type"=>"int",  "file_field"=>"stron_ent_score_r"} if field_order.push("stron_ent_score_r")
            structure_hash["fields"]["stron_ext_perf_r"]    = {"data_type"=>"text", "file_field"=>"stron_ext_perf_r"}  if field_order.push("stron_ext_perf_r")
            structure_hash["fields"]["stron_ext_score_r"]   = {"data_type"=>"int",  "file_field"=>"stron_ext_score_r"} if field_order.push("stron_ext_score_r")
            structure_hash["fields"]["stron_ent_perf_s"]    = {"data_type"=>"text", "file_field"=>"stron_ent_perf_s"}  if field_order.push("stron_ent_perf_s")
            structure_hash["fields"]["stron_ent_score_s"]   = {"data_type"=>"int",  "file_field"=>"stron_ent_score_s"} if field_order.push("stron_ent_score_s")
            structure_hash["fields"]["stron_ext_perf_s"]    = {"data_type"=>"text", "file_field"=>"stron_ext_perf_s"}  if field_order.push("stron_ext_perf_s")
            structure_hash["fields"]["stron_ext_score_s"]   = {"data_type"=>"int",  "file_field"=>"stron_ext_score_s"} if field_order.push("stron_ext_score_s")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end