#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports", "base")}/base"

class Evaluation_Snapshot_Ftc < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        program_start_time = Time.new
        #spot_check
        
        department_role   = "Family Teacher Coach"
        department_id     = 1
        department_totals = Hash.new
        department_totals["count_all_students"                                  ] = []
        department_totals["count_all_students_new"                              ] = []
        department_totals["count_current_students"                              ] = []
        department_totals["count_current_students_new"                          ] = []
        department_totals["count_withdrawn_students"                            ] = []
        department_totals["count_withdrawn_students_new"                        ] = []
        department_totals["count_current_pssa_students"                         ] = []
        department_totals["percent_new"                                         ] = []
        department_totals["percent_inyear"                                      ] = []
        department_totals["percent_seven_twelve"                                ] = []
        department_totals["percent_free_reduced"                                ] = []
        department_totals["percent_tier_three"                                  ] = []
        department_totals["rate_attendance"                                     ] = []
        department_totals["rate_retention"                                      ] = []
        department_totals["rate_scantron_dd_participation_spring"               ] = []
        department_totals["rate_scantron_dd_participation_fall"                 ] = []
        department_totals["rate_monthly_assessment_participation_overall"       ] = []
        department_totals["rate_monthly_assessment_participation_tier_three"    ] = []
        department_totals["rate_pssa_participation"                             ] = []
        department_totals["extra_rate_attendance_withdrawn"                     ] = []
        department_totals["extra_rate_attendance_all_students"                  ] = []
        
        eligible_team_members = $team.family_teacher_coaches
        
        #FNORD - This can be moved to a table if this is an issue every year.
        ineligible_team_members = [
            "Calvin Smith",
            "Quincy Clegg",
            "Crystal Pritchett",
            "Naquisha Hartwell",
            "Kelly Bowes",
            "Elisa Mindlin",
            "Nancy Wagner"
        ]

        ineligible_team_members.each{|ftc|
            eligible_family_teacher_coaches.delete(ftc) if eligible_family_teacher_coaches.include?(ftc)
        }
        
        eligible_team_members.each{|ftc|
            puts start_time = Time.new
            staff_id    = $team.by_k12_name(ftc).samsid.value
            record      = $tables.attach("EVALUATION_METRICS").by_samsid_role(staff_id, department_role)
            if !record
                record = $tables.attach("EVALUATION_METRICS").new_row
                record.fields["samsid"].value   = staff_id
                record.fields["role"].value     = department_role
            end
            
            #FNORD - These functions should be changed to team_member object methods (i.e. .ftc_of(:current), .ftc_of(:all), .ftc_of(:withdrawn))
            all                 = $students.ftc_all_students(:staff_id => staff_id)                                     
            all_new             = $students.ftc_all_students(:staff_id => staff_id, :new_students_only => true)         
            current             = $students.ftc_current_students(:staff_id => staff_id)                                 
            current_new         = $students.ftc_current_students(:staff_id => staff_id, :new_students_only => true)     
            withdrawn           = $students.ftc_withdrawn_students(:staff_id => staff_id, :dropout_truancy=>true)                               
            withdrawn_new       = $students.ftc_withdrawn_students(:staff_id => staff_id, :new_students_only => true, :dropout_truancy=>true)   
            in_year_enrolled    = $students.ftc_current_students(:staff_id => staff_id, :enrolled_after_date => "#{$school.current_school_year_start.mathable.strftime("%Y")}-10-01")
            seven_twelve        = $students.ftc_current_students(:staff_id => staff_id, :grade=> "7|8|9|10|11|12")      
            free_reduced        = $students.ftc_current_students(:staff_id => staff_id, :free_reduced=> true)           
            tier_three          = $students.ftc_current_students(:staff_id => staff_id, :tier=> 3)                      
            pssa_eligible       = $students.ftc_current_students(:staff_id => staff_id, :pssa_eligible=> true)          
            pssa_participated   = $students.ftc_current_students(:staff_id => staff_id, :pssa_eligible=> true, :pssa_participated=> true)
            scantron_eligible   = $students.ftc_current_students(:staff_id => staff_id, :scantron_eligible=> true)
            dora_doma_eligible  = $students.ftc_current_students(:staff_id => staff_id, :dora_doma_eligible=> true)
            
            scantron_participated_spring = 0.0
            scantron_eligible.each{|sid|scantron_participated_spring += 1 if $students.attach(sid).scantron.participated_entrance?}    if scantron_eligible
            
            scantron_participated_fall = 0.0
            scantron_eligible.each{|sid| scantron_participated_fall += 1 if $students.attach(sid).scantron.participated_exit?}          if scantron_eligible
            
            dora_doma_participated_spring = 0.0
            dora_doma_eligible.each{|sid| dora_doma_participated_spring += 1 if $students.attach(sid).dora_doma_participated_spring?}   if dora_doma_eligible
            
            dora_doma_participated_fall = 0.0
            dora_doma_eligible.each{|sid| dora_doma_participated_fall += 1 if $students.attach(sid).dora_doma_participated_fall?}       if dora_doma_eligible
            
            tot_all                 = all                ? all.length.to_f                : 0.0
            tot_all_new             = all_new            ? all_new.length.to_f            : 0.0
            tot_current             = current            ? current.length.to_f            : 0.0
            tot_current_new         = current_new        ? current_new.length.to_f        : 0.0
            tot_withdrawn           = withdrawn          ? withdrawn.length.to_f          : 0.0
            tot_withdrawn_new       = withdrawn_new      ? withdrawn_new.length.to_f      : 0.0
            tot_in_year_enrolled    = in_year_enrolled   ? in_year_enrolled.length.to_f   : 0.0
            tot_seven_twelve        = seven_twelve       ? seven_twelve.length.to_f       : 0.0
            tot_free_reduced        = free_reduced       ? free_reduced.length.to_f       : 0.0
            tot_tier_three          = tier_three         ? tier_three.length.to_f         : 0.0
            tot_pssa_eligible       = pssa_eligible      ? pssa_eligible.length.to_f      : 0.0
            tot_pssa_participated   = pssa_participated  ? pssa_participated.length.to_f  : 0.0
            tot_scantron_eligible   = scantron_eligible  ? scantron_eligible.length.to_f  : 0.0
            tot_dora_doma_eligible  = dora_doma_eligible ? dora_doma_eligible.length.to_f : 0.0         
            
            current_att_tots = 0
            if tot_current > 0
                current.each{|sid|
                    current_att_tots = current_att_tots + $students.attach(sid).attendance.rate_decimal
                }
            end
            
            withdrawn_att_tots = 0
            if tot_withdrawn > 0
                withdrawn.each{|sid|
                    withdrawn_att_tots = withdrawn_att_tots + $students.attach(sid).attendance.rate_decimal
                }
            end
            
            all_att_tots = 0
            if tot_all > 0
                all.each{|sid|
                    all_att_tots = all_att_tots + $students.attach(sid).attendance.rate_decimal
                }
            end  
            
            record.fields["count_all_students"                                  ].value = tot_all
            record.fields["count_all_students_new"                              ].value = tot_all_new
            record.fields["count_current_students"                              ].value = tot_current
            record.fields["count_current_students_new"                          ].value = tot_current_new
            record.fields["count_withdrawn_students"                            ].value = tot_withdrawn
            record.fields["count_withdrawn_students_new"                        ].value = tot_withdrawn_new
            record.fields["count_current_pssa_students"                         ].value = tot_pssa_eligible
            record.fields["percent_new"                                         ].value = tot_current_new/tot_current
            record.fields["percent_inyear"                                      ].value = tot_in_year_enrolled/tot_current
            record.fields["percent_seven_twelve"                                ].value = tot_seven_twelve/tot_current
            record.fields["percent_free_reduced"                                ].value = tot_free_reduced/tot_current
            record.fields["percent_tier_three"                                  ].value = tot_tier_three/tot_current
            record.fields["rate_attendance"                                     ].value = (current_att_tots/tot_current)
            record.fields["rate_retention"                                      ].value = (tot_current/tot_all)
            record.fields["rate_scantron_dd_participation_spring"               ].value = (scantron_participated_spring+dora_doma_participated_spring)/(tot_scantron_eligible+tot_dora_doma_eligible)
            record.fields["rate_scantron_dd_participation_fall"                 ].value = (scantron_participated_fall+dora_doma_participated_fall)/(tot_scantron_eligible+tot_dora_doma_eligible)
            record.fields["rate_monthly_assessment_participation_overall"       ].value = nil
            record.fields["rate_monthly_assessment_participation_tier_three"    ].value = nil
            record.fields["rate_pssa_participation"                             ].value = (tot_pssa_participated/tot_pssa_eligible)
            record.fields["extra_rate_attendance_withdrawn"                     ].value = (withdrawn_att_tots/tot_current)
            record.fields["extra_rate_attendance_all_students"                  ].value = (all_att_tots/tot_current)
            record.save
            
            department_totals.each_key{|field_name|
                department_totals[field_name].push(record.fields[field_name].value)  
            }
            puts "#{ftc} RECORD COMPLETED IN: #{(Time.new - start_time)/60}"
        }
        
        puts start_time = Time.new
        record = $tables.attach("EVALUATION_METRICS").by_samsid_role(department_id, department_role)
        if !record
            record = $tables.attach("EVALUATION_METRICS").new_row
            record.fields["samsid"].value   = department_id
            record.fields["role"].value     = department_role
        end
        
        department_totals.each_pair{|field_name, field_array|
            keep_record     = true
            dep_tot         = 0.0
            dep_tot_entries = field_array.length
            field_array.each{|x|
                if x.is_a?(Float)
                    dep_tot = dep_tot + x
                else
                    keep_record = false
                end 
            }
            dep_average                     = dep_tot/dep_tot_entries   if keep_record
            record.fields[field_name].value = dep_average               if keep_record
        }
        record.save
        puts "Department RECORD COMPLETED IN: #{(Time.new - start_time)/60}"
        puts "Evaluation_Snapshot_Ftc COMPLETED IN: #{(Time.new - program_start_time)/60}"
    end
    #---------------------------------------------------------------------------

    def spot_check
        #SPOT-CHECK STUDENT LISTS
        location                    = "FTC_Evaluations/Spot_Check"
        
        complete_all_rows           = [["FTC","Student ID","First Name","Last Name"]]
        complete_current_rows       = [["FTC","Student ID","First Name","Last Name"]]
        complete_withdrawn_rows     = [["FTC","Student ID","First Name","Last Name"]]
        
        ftcs = [
            "Jamie Sosonkin",
            "Susan Detwiler",
            "Eric Winson",
            "John Heranic",
            "Amanda Fegley"
        ]
        ftcs.each{|ftc|
            puts $team.by_k12_name(ftc).samsid.value    
        }
        ftcs.each{|ftc| 
            team_member     = $team.by_k12_name(ftc)
            staff_id        = team_member.samsid.value
            attachments     = Array.new
            
            if all              = $students.ftc_all_students(:staff_id => staff_id)
                filename        = "all_students"
                all_rows        = [["FTC","Student ID","First Name","Last Name"]]
                all.each{|sid|
                    s = $students.attach(sid)
                    all_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                    complete_all_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                }
                attachments.push(   $reports.csv(location, "#{ftc.gsub(" ","_")}_#{filename}", all_rows)         )
            end
            
            if current         = $students.ftc_current_students(:staff_id => staff_id)
                filename        = "current_students"
                current_rows    = [["FTC","Student ID","First Name","Last Name"]] 
                current.each{|sid|
                    s = $students.attach(sid)
                    current_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                    complete_current_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                }
                attachments.push(   $reports.csv(location, "#{ftc.gsub(" ","_")}_#{filename}", current_rows)     )
            end
            
            if withdrawn       = $students.ftc_withdrawn_students(:staff_id => staff_id)
                filename        = "withdrawn_students"
                withdrawn_rows  = [["FTC","Student ID","First Name","Last Name"]]
                withdrawn.each{|sid|
                    s = $students.attach(sid)
                    withdrawn_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                    complete_withdrawn_rows.push([ftc,sid,s.first_name.value,s.last_name.value])
                }
                attachments.push(   $reports.csv(location, "#{ftc.gsub(" ","_")}_#{filename}", withdrawn_rows)   )
            end
            
            subject = "For Your Approval - Student list - Second Try :)"
            content = "These student lists are very important because they include all of the students who will be included in your end of the year metrics report.
            Please take a moment to verify that you believe these student lists are correct.
            You should have three reports (all_students, current_students and withdrawn_students),
            each one should include only students who were last assigned to you for each category.
            I appreciate you taking this time. Please email me asap if/when you notice any discrepancies."
            #$team.by_k12_name("Jenifer Halverson").send_email(:subject=> subject, :content=> content, :attachment_path=> attachments)
            team_member.send_email(:subject=> subject, :content=> content, :attachment_path=> attachments)
        }
        complete_all_students_report        = $reports.csv(location, "complete_all_students_report",          complete_all_rows       )
        complete_current_students_report    = $reports.csv(location, "complete_current_students_report",      complete_current_rows   )
        complete_withdrawn_students_report  = $reports.csv(location, "complete_withdrawn_students_report",    complete_withdrawn_rows )
    end
end

Evaluation_Snapshot_Ftc.new