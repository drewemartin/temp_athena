#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports", "base")}/base"

class Evaluation_Snapshot_Student_Based < Base

    #---------------------------------------------------------------------------
    def initialize(args)
        super()
        program_start_time  = Time.new
        
        @department_id      = 1
        @peer_group_id      = 2
        
        #CURRENTLY BEING EVALUATED
        @role                   = nil
        @eligible_team_members  = nil
        @evaluation_roles       = $team.student_base_evaluation_roles if args.empty?
        
        snapshot if @evaluation_roles
        puts "Evaluation_Snapshot_Student_Based COMPLETED IN: #{(Time.new - program_start_time)/60}"
    end
    #---------------------------------------------------------------------------

    def snapshot
        @evaluation_roles.each{|role|
            @role                       = role
            @eligible_team_members      = $team.members_by_role(@role)
            ineligible_team_members     = $team.student_based_evaluation_exempt(@role)
            
            if @eligible_team_members && ineligible_team_members
                ineligible_team_members.each{|samsid|
                    @eligible_team_members.delete(samsid) if @eligible_team_members.include?(samsid)
                }
            end
            
            if @eligible_team_members
                @eligible_team_members.each{|samsid|
                    team_member_snapshot(samsid)
                }
                department_snapshot
                peer_group_snapshot
            end
        }
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def get_record(samsid)
        record = $tables.attach("EVALUATION_METRICS").by_samsid_role(samsid, @role)
        if !record
            record = $tables.attach("EVALUATION_METRICS").new_row
            record.fields["samsid"  ].value = @department_id
            record.fields["role"    ].value = @role
        end
        return record
    end
    
    def reset_totals_hash(hash)
        hash.each_key{|key| @department_totals[key].clear }
    end
    
    def totals_hash
        totals                                                       = Hash.new
        totals["count_all_students"]                                  = []
        totals["count_all_students_new"]                              = []
        totals["count_current_students"]                              = []
        totals["count_current_students_new"]                          = []
        totals["count_withdrawn_students"]                            = []
        totals["count_withdrawn_students_new"]                        = []
        totals["count_current_pssa_students"]                         = []
        totals["percent_new"]                                         = []
        totals["percent_inyear"]                                      = []
        totals["percent_seven_twelve"]                                = []
        totals["percent_free_reduced"]                                = []
        totals["percent_tier_three"]                                  = []
        totals["percent_engage_high"]                                 = []
        totals["percent_engage_average"]                              = []
        totals["percent_engage_low"]                                  = []
        totals["percent_specialed"]                                   = []
        totals["rate_attendance"]                                     = []
        totals["rate_retention"]                                      = []
        totals["rate_scantron_dd_participation_spring"]               = []
        totals["rate_scantron_dd_participation_fall"]                 = []
        totals["rate_monthly_assessment_participation_overall"]       = []
        totals["rate_monthly_assessment_participation_tier_three"]    = []
        totals["rate_pssa_participation"]                             = []
        totals["rate_attendance_withdrawn"]                           = []
        totals["rate_attendance_all_students"]                        = []
        totals["rate_passing_mastery"]                                = []
        return totals
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SNAPSHOTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_snapshot
        totals  = totals_hash
        @eligible_team_members.each{|samsid|
            record = $tables.attach("EVALUATION_METRICS").by_samsid_role(samsid, @role)
            totals.each_key{|field_name|
                totals.push(record.fields[field_name].value)
            }
        }
        
        record = $tables.attach("EVALUATION_METRICS").by_samsid_role(@peer_group_id, @role)
        if !record
            record = $tables.attach("EVALUATION_METRICS").new_row
            record.fields["samsid"  ].value = @department_id
            record.fields["role"    ].value = @role
        end
        totals.each_pair{|field_name, field_array|
            keep_record = true
            tot         = 0.0
            tot_entries = field_array.length
            field_array.each{|x|
                if x.is_a?(Float)
                    tot = tot + x
                else
                    keep_record = false
                end 
            }
            if keep_record
                average = tot/tot_entries                   
                record.fields[field_name].value = average
            end
        }
        record.save
    end
    
    def peer_group_snapshot
        totals      = totals_hash
        
        #FIND ALL GROUPS IN THE CURRENT ROLE
        peer_groups = $team.peer_groups_by_role(@role)
        
        #EVALUATE EACH GROUP
        peer_groups.each{|group|
            totals  = reset_totals_hash(totals)
            members = $team.peer_group_members_by_group(group)
            members.each{|samsid|
                record = $tables.attach("EVALUATION_METRICS").by_samsid_role(samsid, @role)
                totals.each_key{|field_name|
                    totals.push(record.fields[field_name].value)
                }
            }
            
            #RECORD GROUP TOTALS
            record = $tables.attach("EVALUATION_METRICS").by_samsid_role(@peer_group_id, @department_role)
            if !record
                record = $tables.attach("EVALUATION_METRICS").new_row
                record.fields["samsid"  ].value = @peer_group_id
                record.fields["role"    ].value = @role
            end
            totals.each_pair{|field_name, field_array|
                keep_record = true
                tot         = 0.0
                tot_entries = field_array.length
                field_array.each{|x|
                    if x.is_a?(Float)
                        tot = tot + x
                    else
                        keep_record = false
                    end 
                }
                if keep_record
                    average = tot/tot_entries                   
                    record.fields[field_name].value = average
                end
            }
            record.save
        }
    end
    
    def team_member_snapshot(samsid)
        team_member     = $team.attach_samsid(samsid)
        record          = get_record(samsid)
        
        all             = team_member.all_students(:role => @role)                                     
        all_new         = team_member.all_students(:role => @role, :new_students_only => true)         
        current         = team_member.current_students(:role => @role)                                 
        current_new     = team_member.current_students(:role => @role, :new_students_only => true)     
        
        #Withdrawn student included in student list are limited to drop outs and truancy withdrawals for FTCs
        if team == "Family Teacher Coach"
            withdrawn           = team_member.withdrawn_students(:role => @role, :dropout_truancy=>true)                               
            withdrawn_new       = team_member.withdrawn_students(:role => @role, :new_students_only => true, :dropout_truancy=>true)
        else
            withdrawn           = team_member.withdrawn_students(:role => @role)                               
            withdrawn_new       = team_member.withdrawn_students(:role => @role, :new_students_only => true)
        end  
        
        in_year_enrolled                        = team_member.current_students(:role => @role, :enrolled_after_date => "#{$school.current_school_year_start.mathable.strftime("%Y")}-10-01")
        seven_twelve                            = team_member.current_students(:role => @role, :grade=> "7|8|9|10|11|12")      
        free_reduced                            = team_member.current_students(:role => @role, :free_reduced=> true)           
        tier_three                              = team_member.current_students(:role => @role, :tier=> 3)                      
        pssa_eligible                           = team_member.current_students(:role => @role, :pssa_eligible=> true)          
        pssa_participated                       = team_member.current_students(:role => @role, :pssa_eligible=> true, :pssa_participated=> true)
        scantron_eligible                       = team_member.current_students(:role => @role, :scantron_eligible=> true)
        dora_doma_eligible                      = team_member.current_students(:role => @role, :dora_doma_eligible=> true)
        engage_eligible                         = team_member.current_students(:role => @role, :engage_eligible=> true)
        special_ed                              = team_member.current_students(:role => @role, :special_ed=> true)
        monthly_assessment_eligible             = team_member.current_students(:role => @role, :monthly_assessment_eligible=> :overall)
        monthly_assessment_eligible_tier_three  = team_member.current_students(:role => @role, :monthly_assessment_eligible=> :overall, :tier=> 3)
        
        current_att_tots = 0
        current.each{|sid| current_att_tots = current_att_tots + $students.attach(sid).attendance.rate_decimal}                     if current
        
        withdrawn_att_tots = 0
        withdrawn.each{|sid| withdrawn_att_tots = withdrawn_att_tots + $students.attach(sid).attendance.rate_decimal}               if withdrawn
        
        all_att_tots = 0
        all.each{|sid| all_att_tots = all_att_tots + $students.attach(sid).attendance.rate_decimal}                                 if all
        
        engage_high = 0.0
        engage_eligible.each{|sid|engage_high += 1 if $students.attach(sid).engagement_level.value == "High"}                       if engage_eligible
        
        engage_average = 0.0
        engage_eligible.each{|sid|engage_average += 1 if $students.attach(sid).engagement_level.value == "Average"}                 if engage_eligible
        
        engage_low = 0.0
        engage_eligible.each{|sid|engage_low += 1 if $students.attach(sid).engagement_level.value == "Low"}                         if engage_eligible
        
        scantron_participated_spring = 0.0
        scantron_eligible.each{|sid|scantron_participated_spring += 1 if $students.attach(sid).scantron.participated_entrance?}    if scantron_eligible
        
        scantron_participated_fall = 0.0
        scantron_eligible.each{|sid| scantron_participated_fall += 1 if $students.attach(sid).scantron.participated_exit?}          if scantron_eligible
        
        dora_doma_participated_spring = 0.0
        dora_doma_eligible.each{|sid| dora_doma_participated_spring += 1 if $students.attach(sid).dora_doma_participated_spring?}   if dora_doma_eligible
        
        dora_doma_participated_fall = 0.0
        dora_doma_eligible.each{|sid| dora_doma_participated_fall += 1 if $students.attach(sid).dora_doma_participated_fall?}       if dora_doma_eligible
        
        monthly_assessment_participated = 0.0
        monthly_assessment_eligible.each{|sid| monthly_assessment_participated = monthly_assessment_participated + $students.attach(sid).monthly_assessment_participation_avg.mathable} if monthly_assessment_eligible
        
        monthly_assessment_participated_tier_three = 0.0
        monthly_assessment_eligible_tier_three.each{|sid| monthly_assessment_participated_tier_three = monthly_assessment_participated_tier_three + $students.attach(sid).monthly_assessment_participation_avg.mathable} if dora_doma_eligible
        
        tot_all                                    = all                                    ? all.length.to_f                               : 0.0
        tot_all_new                                = all_new                                ? all_new.length.to_f                           : 0.0
        tot_current                                = current                                ? current.length.to_f                           : 0.0
        tot_current_new                            = current_new                            ? current_new.length.to_f                       : 0.0
        tot_withdrawn                              = withdrawn                              ? withdrawn.length.to_f                         : 0.0
        tot_withdrawn_new                          = withdrawn_new                          ? withdrawn_new.length.to_f                     : 0.0
        tot_in_year_enrolled                       = in_year_enrolled                       ? in_year_enrolled.length.to_f                  : 0.0
        tot_seven_twelve                           = seven_twelve                           ? seven_twelve.length.to_f                      : 0.0
        tot_free_reduced                           = free_reduced                           ? free_reduced.length.to_f                      : 0.0
        tot_tier_three                             = tier_three                             ? tier_three.length.to_f                        : 0.0
        tot_pssa_eligible                          = pssa_eligible                          ? pssa_eligible.length.to_f                     : 0.0
        tot_pssa_participated                      = pssa_participated                      ? pssa_participated.length.to_f                 : 0.0
        tot_scantron_eligible                      = scantron_eligible                      ? scantron_eligible.length.to_f                 : 0.0
        tot_dora_doma_eligible                     = dora_doma_eligible                     ? dora_doma_eligible.length.to_f                : 0.0         
        tot_engage_eligible                        = engage_eligible                        ? engage_eligible.length.to_f                   : 0.0
        tot_special_ed                             = special_ed                             ? special_ed.length.to_f                        : 0.0
        tot_monthly_assessment_eligible            = monthly_assessment_eligible            ? monthly_assessment_eligible.length.to_f       : 0.0
        tot_monthly_assessment_eligible_tier_three = monthly_assessment_eligible_tier_three ? monthly_assessment_eligible.length.to_f       : 0.0 
        
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
        record.fields["percent_engage_high"                                 ].value = engage_high/tot_engage_eligible
        record.fields["percent_engage_average"                              ].value = engage_average/tot_engage_eligible
        record.fields["percent_engage_low"                                  ].value = engage_low/tot_engage_eligible
        record.fields["percent_specialed"                                   ].value = tot_special_ed/tot_current
        record.fields["rate_attendance"                                     ].value = current_att_tots/tot_current
        record.fields["rate_attendance_withdrawn"                           ].value = withdrawn_att_tots/tot_current
        record.fields["rate_attendance_all_students"                        ].value = all_att_tots/tot_current
        record.fields["rate_retention"                                      ].value = tot_current/tot_all
        record.fields["rate_scantron_dd_participation_spring"               ].value = (scantron_participated_spring+dora_doma_participated_spring)/(tot_scantron_eligible+tot_dora_doma_eligible)
        record.fields["rate_scantron_dd_participation_fall"                 ].value = (scantron_participated_fall+dora_doma_participated_fall)/(tot_scantron_eligible+tot_dora_doma_eligible)
        record.fields["rate_monthly_assessment_participation_overall"       ].value = monthly_assessment_participated/tot_monthly_assessment_eligible
        record.fields["rate_monthly_assessment_participation_tier_three"    ].value = monthly_assessment_participated_tier_three/tot_monthly_assessment_eligible
        record.fields["rate_pssa_participation"                             ].value = tot_pssa_participated/tot_pssa_eligible
        record.save   
    end
    
end

Evaluation_Snapshot_Student_Based.new(ARGV)