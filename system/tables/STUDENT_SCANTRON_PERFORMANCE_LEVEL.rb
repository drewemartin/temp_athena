#!/usr/local/bin/ruby
#require File.dirname(__FILE__).gsub("tables","base/base")
#Base.new
require "#{$paths.base_path}athena_table"

class STUDENT_SCANTRON_PERFORMANCE_LEVEL < Athena_Table
    
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
    
    def after_change(row_obj)
        
        ilp_tracking_fields = {
            
            :stron_ent_perf_m   => "Math Entrance",
            :stron_ext_perf_m   => "Math Exit",
            :stron_ent_perf_r   => "Reading Entrance",
            :stron_ext_perf_r   => "Reading Exit"
            
        }
        
        sid             = field_by_pid("student_id", row_obj.primary_id).value
        student         = $students.get(sid)
        ilp_cat_id      = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids("WHERE name = 'Scantron Results'")[0]
        
        ilp_tracking_fields.each_pair{|field_name, nice_name|
           
            if row_obj.fields.keys.find{|x|x==field_name.to_s}
                
                ilp_type_id = $tables.attach("ILP_ENTRY_TYPE").primary_ids("WHERE name = '#{nice_name}' AND category_id = #{ilp_cat_id}")[0]
                if (
                    
                    ilp_records  = student.ilp.existing_records(
                        "WHERE ilp_entry_category_id    = '#{ilp_cat_id}'
                        AND ilp_entry_type_id           = '#{ilp_type_id}'"
                    )
                    
                )
                    
                    ilp_record = ilp_records[0]
                    
                else
                    
                    ilp_record = student.ilp.new_record
                    ilp_record.fields["ilp_entry_category_id"   ].value = ilp_cat_id
                    ilp_record.fields["ilp_entry_type_id"       ].value = ilp_type_id
                    
                end
                
                ilp_record.fields["description"].value = row_obj.fields[field_name.to_s].value
                ilp_record.save
                
            end
            
        } if ilp_cat_id
        
    end

    def after_load_scantron_performance_extended
        
        subjects = ["math","reading","science"]
        pids = $tables.attach("SCANTRON_PERFORMANCE_EXTENDED").primary_ids
        pids.each{|pid|
            
            performance_record  = $tables.attach("SCANTRON_PERFORMANCE_EXTENDED").by_primary_id(pid).fields
            sid                 = performance_record["student_id"].value
            if $students.get(sid)
                
                level_record = by_studentid_old(sid)
                if !level_record
                    level_record = new_row
                    level_record.fields["student_id"].value = sid
                end
                
                subjects.each{|subject|
                    
                    performance_level   = nil
                    score               = performance_record["#{subject}_scaled_score"  ]
                    test_date           = performance_record["#{subject}_test_date"     ].value
                    nce                 = performance_record["#{subject}_nce"           ].value
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
                            date_field  = "stron_#{ent_ext}_test_date_#{subject[0].chr}"
                            nce_field   = "stron_#{ent_ext}_nce_#{subject[0].chr}"
                            level_record.fields[score_field ].value = score
                            level_record.fields[level_field ].value = performance_level
                            level_record.fields[date_field  ].value = test_date
                            level_record.fields[nce_field   ].value = nce
                            
                            #math growth
                            if $students.list(
                                :student_id                 => sid,
                                :scantron_eligible          => ["ent_m","ext_m"],
                                :scantron_growth_eligible   => ["math"]
                            )
                                if $students.list(
                                    :student_id                 => sid,
                                    :scantron_eligible          => ["ent_m","ext_m"],
                                    :scantron_growth_eligible   => ["math"],
                                    :scantron_growth            => ["math"]
                                )
                                    scantron_math_growth = true
                                else
                                    scantron_math_growth = false
                                end
                                
                            else
                                scantron_math_growth = nil
                            end
                            
                            #reading growth
                            if $students.list(
                                :student_id                 => sid,
                                :scantron_eligible          => ["ent_r","ext_r"],
                                :scantron_growth_eligible   => ["reading"]
                            )
                                if $students.list(
                                    :student_id                 => sid,
                                    :scantron_eligible          => ["ent_r","ext_r"],
                                    :scantron_growth_eligible   => ["reading"],
                                    :scantron_growth            => ["reading"]
                                )
                                    scantron_reading_growth = true
                                else
                                    scantron_reading_growth = false
                                end
                                
                            else
                                scantron_reading_growth = nil
                            end
                            
                            #overall growth
                            if $students.list(
                                :student_id                 => sid,
                                :scantron_eligible          => ["ent_m","ext_m","ent_r","ext_r"],
                                :scantron_growth_eligible   => ["math","reading"]
                            )
                                if $students.list(
                                    :student_id                 => sid,
                                    :scantron_eligible          => ["ent_m","ext_m"],
                                    :scantron_growth_eligible   => ["math","reading"],
                                    :scantron_growth            => ["math","reading"]
                                )
                                    scantron_overall_growth = true
                                else
                                    scantron_overall_growth = false
                                end
                                
                            else
                                scantron_overall_growth = nil
                            end
                            
                            level_record.fields["growth_math"       ].value = scantron_math_growth
                            level_record.fields["growth_reading"    ].value = scantron_reading_growth
                            level_record.fields["growth_overall"    ].value = scantron_overall_growth
                            
                            level_record.save
                            
                        end
                        
                    else
                        puts "Test date out of range! SID: #{sid} SUBJECT: #{subject} DATE: #{test_date}"
                    end
                    
                }
                
            end
            
        } if pids
        
        ftc_participation_notifications
        
    end
  
    def ftc_participation_notifications
        
        if ENV["COMPUTERNAME"] == "ATHENA"
            
            report_location = "Scantron/Participation_Notifications"
            
            completetion_rates_by_ftc = Array.new
            completetion_rates_by_ftc.push(
                headers = [
                    "FTC",
                    "Percent Complete"
                ]
            )
            
            overall_incomplete = Array.new
            overall_incomplete.push(
                headers = [
                    "student_id",
                    "first_name",
                    "last_initial",
                    "participated_reading",
                    "participated_math",
                    "lg_first_name",
                    "lg_last_name",
                    "phone_number",
                    "FTC"
               ]
            )
            
            if $field.is_schoolday?($idate)
                
                test_phase  = $school.scantron.current_test_phase
                
                team_ids    = $team.filter(:role=>"Family Teacher Coach")
                
                if team_ids
                    
                    team_ids.each{|team_id| 
                        
                        t                   = $team.get(team_id)
                        ftc                 = t.full_name
                        
                        if eligible_students = t.enrolled_students(:scantron_eligible=>["#{test_phase}_m","#{test_phase}_r"])
                            
                            participated_students = t.enrolled_students(
                                
                                :scantron_eligible      => ["#{test_phase}_m","#{test_phase}_r"],
                                :scantron_participated  => [
                                    "stron_#{test_phase}_perf_m",
                                    "stron_#{test_phase}_perf_r"
                                ]
                                
                            ) || []
                            
                            if !(eligible_students.length == participated_students.length)
                                
                                incomplete = Array.new
                                incomplete.push(
                                    headers = [
                                        "student_id",
                                        "first_name",
                                        "last_initial",
                                        "participated_reading",
                                        "participated_math",
                                        "lg_first_name",
                                        "lg_last_name",
                                        "phone_number"
                                ]
                                )
                                
                                eligible_students.each{|sid|
                                    
                                    if !participated_students.include?(sid)
                                        
                                        s = $students.get(sid)
                                        
                                        math_result = s.meets_criteria(
                                            :scantron_eligible      => ["#{test_phase}_m"],
                                            :scantron_participated  => ["stron_#{test_phase}_perf_m"]
                                        ) ? "Yes" : "No"
                                        reading_result = s.meets_criteria(
                                            :scantron_eligible      => ["#{test_phase}_r"],
                                            :scantron_participated  => ["stron_#{test_phase}_perf_r"]
                                        ) ? "Yes" : "No"
                                        
                                        incomplete.push(
                                            [
                                                sid,
                                                s.studentfirstname.value,
                                                s.studentlastname.value[0].chr,
                                                reading_result,
                                                math_result,
                                                s.lgfirstname.value,
                                                s.lglastname.value,
                                                s.studenthomephone.to_phone_number
                                            ]
                                        )
                                        overall_incomplete.push(
                                            [
                                                sid,
                                                s.studentfirstname.value,
                                                s.studentlastname.value[0].chr,
                                                reading_result,
                                                math_result,
                                                s.lgfirstname.value,
                                                s.lglastname.value,
                                                s.studenthomephone.to_phone_number,
                                                ftc
                                            ]
                                        )
                                    end
                                    
                                }
                                
                                percent_complete = participated_students.length.to_f/eligible_students.length.to_f
                                percent_complete = $base.to_percent(percent_complete)
                                completetion_rates_by_ftc.push([ftc, "#{percent_complete}"])
                                
                                report_path = $reports.save_document({:category_name=>"Scantron", :type_name=>"Scantron Participation Incomplete Report", :csv_rows=>incomplete})
                                subject = "#{ftc} Scantron Participation #{percent_complete} Complete - #{$idatetime}"
                                content = "#{percent_complete} of your Scantron assessment students have completed both their math and reading exams.
                                Attached is a list of your students with incomplete participation."
                                t.send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
                                
                            else
                                completetion_rates_by_ftc.push([ftc, "100%"])
                            end
                            
                        end
                        
                    }
                    
                    eligible_students_overall       = $students.list(
                        :scantron_eligible      =>["#{test_phase}_m","#{test_phase}_r"],
                        :student_relate_active  => true
                    ) || []
                    participated_students_overall   = $students.list(
                        
                        :scantron_eligible      => ["#{test_phase}_m","#{test_phase}_r"],
                        :scantron_participated  => [
                            "stron_#{test_phase}_perf_m",
                            "stron_#{test_phase}_perf_r"
                        ],
                        :student_relate_active  => true
                        
                    ) || []
                    if participated_students_overall.length > 0 && eligible_students_overall.length > 0
                        percent_complete_overall  = participated_students_overall.length.to_f/eligible_students_overall.length.to_f
                        percent_complete_overall  = $base.to_percent(percent_complete_overall)
                    else
                        percent_complete_overall  = "0%"
                    end
                    overall_incomplete_report = $reports.save_document({:category_name=>"Scantron", :type_name=>"Scantron Participation Incomplete Overall Report", :csv_rows=>overall_incomplete})
                    completetion_rates_report = $reports.save_document({:category_name=>"Scantron", :type_name=>"Scantron Participation Completion Overall Report", :csv_rows=>completetion_rates_by_ftc})
                    
                    #html_table = $base.web_tools.table(completetion_rates_by_ftc, "content", footers = false) #FOR ATHENA(OLD SET ONLY)
                    html_table = $base.web_tools.table(
                        :table_array    => completetion_rates_by_ftc,
                        :unique_name    => "content",
                        :footers        => false,
                        :head_section   => false,
                        :title          => false,
                        :caption        => false
                    )
                    subject = "Overall Scantron Participation - #{percent_complete_overall} Completed"
                    content = "Attached is a list of students with incomplete participation.
                    <BR><BR>#{html_table}<BR><BR>"
                    
                    $base.email.athena_smtp_email(
                        recipient = "fcps@agora.org",
                        subject,
                        content,
                        attachments = overall_incomplete_report,
                        from_override = nil,
                        att_override = "scantron_participation_incomplete_overall_#{$ifilestamp}.csv"
                    )
                    
                    $team.find(:full_name=>"Joel Gowman"  ).send_email({:subject=>subject, :content=>content, :attachment_path=>overall_incomplete_report, :attachment_name=>"scantron_participation_incomplete_overall_#{$ifilestamp}.csv"})
                    $team.find(:full_name=>"Tim Kreider"  ).send_email({:subject=>subject, :content=>content, :attachment_path=>overall_incomplete_report, :attachment_name=>"scantron_participation_incomplete_overall_#{$ifilestamp}.csv"}) 
                    
                end
                
            end
            
        end
        
    end

    def scantron_participation_notification_family_coach_program_support
        
        fcps_team_ids = $team.family_coach_program_support
        fcps_team_ids.each{|tid|
            
            
            
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
                "name"              => "student_scantron_performance_level",
                "file_name"         => "student_scantron_performance_level.csv",
                "file_location"     => "student_scantron_performance_level",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"student_id"            } if field_order.push("student_id"              )
            structure_hash["fields"]["stron_ent_perf_m"         ] = {"data_type"=>"text", "file_field"=>"stron_ent_perf_m"      } if field_order.push("stron_ent_perf_m"        )
            structure_hash["fields"]["stron_ent_score_m"        ] = {"data_type"=>"int",  "file_field"=>"stron_ent_score_m"     } if field_order.push("stron_ent_score_m"       )
            structure_hash["fields"]["stron_ent_test_date_m"    ] = {"data_type"=>"date", "file_field"=>"stron_ent_test_date_m" } if field_order.push("stron_ent_test_date_m"   )
            structure_hash["fields"]["stron_ent_nce_m"          ] = {"data_type"=>"int",  "file_field"=>"stron_ent_nce_m"       } if field_order.push("stron_ent_nce_m"         )
            structure_hash["fields"]["stron_ext_perf_m"         ] = {"data_type"=>"text", "file_field"=>"stron_ext_perf_m"      } if field_order.push("stron_ext_perf_m"        )
            structure_hash["fields"]["stron_ext_score_m"        ] = {"data_type"=>"int",  "file_field"=>"stron_ext_score_m"     } if field_order.push("stron_ext_score_m"       )
            structure_hash["fields"]["stron_ext_test_date_m"    ] = {"data_type"=>"date", "file_field"=>"stron_ext_test_date_m" } if field_order.push("stron_ext_test_date_m"   )
            structure_hash["fields"]["stron_ext_nce_m"          ] = {"data_type"=>"int",  "file_field"=>"stron_ext_nce_m"       } if field_order.push("stron_ext_nce_m"         )
            structure_hash["fields"]["stron_ent_perf_r"         ] = {"data_type"=>"text", "file_field"=>"stron_ent_perf_r"      } if field_order.push("stron_ent_perf_r"        )
            structure_hash["fields"]["stron_ent_score_r"        ] = {"data_type"=>"int",  "file_field"=>"stron_ent_score_r"     } if field_order.push("stron_ent_score_r"       )
            structure_hash["fields"]["stron_ent_test_date_r"    ] = {"data_type"=>"date", "file_field"=>"stron_ent_test_date_r" } if field_order.push("stron_ent_test_date_r"   )
            structure_hash["fields"]["stron_ent_nce_r"          ] = {"data_type"=>"int",  "file_field"=>"stron_ent_nce_r"       } if field_order.push("stron_ent_nce_r"         )
            structure_hash["fields"]["stron_ext_perf_r"         ] = {"data_type"=>"text", "file_field"=>"stron_ext_perf_r"      } if field_order.push("stron_ext_perf_r"        )
            structure_hash["fields"]["stron_ext_score_r"        ] = {"data_type"=>"int",  "file_field"=>"stron_ext_score_r"     } if field_order.push("stron_ext_score_r"       )
            structure_hash["fields"]["stron_ext_test_date_r"    ] = {"data_type"=>"date", "file_field"=>"stron_ext_test_date_r" } if field_order.push("stron_ext_test_date_r"   )
            structure_hash["fields"]["stron_ext_nce_r"          ] = {"data_type"=>"int",  "file_field"=>"stron_ext_nce_r"       } if field_order.push("stron_ext_nce_r"         )
            structure_hash["fields"]["stron_ent_perf_s"         ] = {"data_type"=>"text", "file_field"=>"stron_ent_perf_s"      } if field_order.push("stron_ent_perf_s"        )
            structure_hash["fields"]["stron_ent_score_s"        ] = {"data_type"=>"int",  "file_field"=>"stron_ent_score_s"     } if field_order.push("stron_ent_score_s"       )
            structure_hash["fields"]["stron_ent_test_date_s"    ] = {"data_type"=>"date", "file_field"=>"stron_ent_test_date_s" } if field_order.push("stron_ent_test_date_s"   )
            structure_hash["fields"]["stron_ent_nce_s"          ] = {"data_type"=>"int",  "file_field"=>"stron_ent_nce_s"       } if field_order.push("stron_ent_nce_s"         )
            structure_hash["fields"]["stron_ext_perf_s"         ] = {"data_type"=>"text", "file_field"=>"stron_ext_perf_s"      } if field_order.push("stron_ext_perf_s"        )
            structure_hash["fields"]["stron_ext_score_s"        ] = {"data_type"=>"int",  "file_field"=>"stron_ext_score_s"     } if field_order.push("stron_ext_score_s"       )
            structure_hash["fields"]["stron_ext_test_date_s"    ] = {"data_type"=>"date", "file_field"=>"stron_ext_test_date_s" } if field_order.push("stron_ext_test_date_s"   )
            structure_hash["fields"]["stron_ext_nce_s"          ] = {"data_type"=>"int",  "file_field"=>"stron_ext_nce_s"       } if field_order.push("stron_ext_nce_s"         )
            structure_hash["fields"]["growth_math"              ] = {"data_type"=>"bool", "file_field"=>"growth_math"           } if field_order.push("growth_math"             )
            structure_hash["fields"]["growth_reading"           ] = {"data_type"=>"bool", "file_field"=>"growth_reading"        } if field_order.push("growth_reading"          )
            structure_hash["fields"]["growth_overall"           ] = {"data_type"=>"bool", "file_field"=>"growth_overall"        } if field_order.push("growth_overall"          )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end
#STUDENT_SCANTRON_PERFORMANCE_LEVEL.new.after_load_scantron_performance_extended