#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("data_processing","base/base")

class TEAM_METRICS_SNAPSHOT_a < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        
        program_start_time          = Time.new
       
        @reporting_period           = "2011-2012 EOY - WITH PASSING RATES"
        
        @department_id              = 1
        @peer_group_id              = 2
        
        department_roles            = $team.student_base_evaluation_roles
        department_roles            = ["Freshman Academy"]            # USE THIS TO OVERRIDE
        
        demographic_set = {:sub_table => :FEMALE, :female => true}
        demographic_set = {:sub_table => :MALE,   :male => true}
        demographic_set = nil
        
        $switch = true
        #$term   = "Q4"
        #team_member_snapshot("778634", "Freshman Academy", demographic_set = nil)
        department_roles.each{|role|
            #demographic_sets = [
            #    nil,
            #    {:sub_table => :FEMALE, :female => true},
            #    {:sub_table => :MALE,   :male => true}
            #]
            #demographic_sets.each{|d_set|
            #    snapshot(role, d_set)
            #}
            
            #snapshot(role, demographic_set)
            #
            #peer_group_snapshot(role, demographic_set)
            #department_snapshot(role, demographic_set)
            fill_eval_template(role)
        }
        
        #THIS IS TEMPORARY _ DELETE AFTER BETTER METHOD CREATED
        #snapshot_7_12
        #snapshot_7_12_wrap_up
        #snapshot_7_12_wrap_up_department
        
        puts "Evaluation_Snapshot_Student_Based COMPLETED IN: #{(Time.new - program_start_time)/60}"
    end
    #---------------------------------------------------------------------------
    
    def demographic_sets
        [
            {:sub_table => :MALE,   :male => true},
            {:sub_table => :FEMALE, :female => true}
            
        ]
    end
    
    def demographic_chart(samsid, role)
        results             = totals_hash
        results["header"]   = ["Category"]
        field_order         = nil
        peer_group          = nil
        k12_name            = $team.attach_samsid(samsid).k12_fullname.value
        demographic_sets.each{|demographic|
            results["header"].push(demographic[:sub_table].to_s)
            record      = find_record(samsid, role, group = nil, demographic)
            peer_group  = record.fields["peer_group"].to_user
            field_order = record.table.field_order
            field_order.each{|field_name|
                if totals_hash.has_key?(field_name)
                    results[field_name].push(record.fields[field_name].to_user)
                end
            }
            
        }
        
        excel           = $base.excel
        #excel.Visible   = 1
        workbook        = excel.Workbooks.Open("#{$paths.templates_path}team_metrics_demographics.xlsx")
        worksheet       = workbook.Worksheets(2)
        worksheet.Name  = samsid
        
        r = 2
        results["header"].each_with_index{|v, i| worksheet.Cells(1, i+1).Value = v}
        field_order.each{|field_name|
            if results.has_key?(field_name)
                c = 2
                delete_string = field_name.split("_")[0]
                worksheet.Cells(r, 1).Value = field_name.gsub(delete_string,'').gsub("_"," ")
                results[field_name].each{|field_value|
                    worksheet.Cells(r, c).Value = field_value
                    c += 1
                }
                r += 1
            end 
        }
        worksheet   = workbook.Worksheets(1)
        worksheet.Select
        
        location    = $config.init_path("#{$paths.reports_path}Team_Metrics/EVALUATIONS/ROLE_#{clean_string(role)}/#{samsid}_#{clean_string(k12_name)}"    )
        filename    = clean_string("demographics_chart_#{samsid}_#{$ifilestamp}")
        doc_path    = "#{location}#{filename}.xlsx"
        workbook.SaveAs(doc_path.gsub("/","\\"))
        #workbook.SaveAs(doc_path.gsub("/","\\"),17)
        workbook.close
        excel.Quit
    end

    def fill_eval_template(role)
        eval_failed  = Array.new
        dep_record   = $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(@department_id,  role, @reporting_period)
       
        eval_template_name      = $team.evaluation_template_by_role(role)
        
        if eval_template_name && eval_template_name = eval_template_name.value
            eligible_team_members   = $team.members_by_role(role)
            ineligible_team_members = $team.student_based_evaluation_exempt(role)
            ineligible_team_members.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
            eligible_team_members.each{|samsid|
              #TEST DELETE WHEN COMPLETE
              #eval_template_name      = "primary_evals_complete"
              #samsid = "414575"
              
                #demographic_chart(samsid, role)
              
              
                ftc          = $team.attach_samsid(samsid)
                k12_name     = "#{ftc.k12_first_name.value} #{ftc.k12_last_name.value}"
                record       = $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, @reporting_period)
                group        = record.fields["peer_group"].value 
                peer_record  = $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(@peer_group_id,  role, @reporting_period, group)
                evaluation_record = $tables.attach("TEAM_EVALUATIONS_STUDENT_BASED").by_samsid(samsid)
                
                if group && record && peer_record && dep_record
                    replace = Hash.new
                    replace["[team_member]"] = k12_name
                    replace["[today]"]       = $iuser
                    record.fields.each_pair{|field_name, details|
                        replace["[#{field_name}]"] = details
                    }
                    dep_record.fields.each_pair{|field_name, details|
                        replace["[dep_#{field_name}]"] = details
                    }
                    peer_record.fields.each_pair{|field_name, details|
                        replace["[peer_#{field_name}]"] = details
                    }
                    
                    checkboxes = [
                        "inst_evi_fos",
                        "inst_evi_rmatts",
                        "inst_distinguished",
                        "inst_proficient",
                        "inst_needs_improve",
                        "inst_unsatisfactory",
                        "metrics_evi_dpfs",
                        "pro_distinguished",
                        "pro_proficient",
                        "pro_needs_improve",
                        "pro_unsatisfactory",
                        "ab_mentoring",
                        "ab_recruiting",
                        "ab_commitee",
                        "ab_testing",
                        "ab_afterhours_sess",
                        "ab_pd_leader",
                        "ab_admin_expert",
                        "ab_club_advisor",
                        "ab_substituting",
                        "ab_afterhours_parent",
                        "ab_other"
                    ]
                    
                    evaluation_hash.each_key{|field_name|
                        field = evaluation_record ? evaluation_record.fields[field_name] : nil
                        replace["[#{field_name}]"] =  field  
                    }
                    
                    index = 0
                    begin
                        word = $base.word
                        #word.Visible = true
                        doc  = word.Documents.Open("#{$paths.templates_path}#{eval_template_name}.docx")
                    rescue => e
                        index += 1
                        puts e
                        puts "RESTART"
                        retry if index < 3
                        puts "AUTO FILL FAILED! #{filename}"
                        break
                    end
                    #CHECKBOXES
                    if !checkboxes.empty?
                        checkboxes.each{|field_name|
                            r = replace["[#{field_name}]"]
                            if (r && !r.value.nil? && r.is_true?)
                                doc.FormFields(field_name).CheckBox.Value = true
                            else
                                doc.FormFields(field_name).CheckBox.Value = false
                            end
                        }
                    end
                    replace.each_pair{|f,r|
                        #footer
                        #word.ActiveWindow.View.Type = 3
                        #word.ActiveWindow.ActivePane.View.SeekView = 10
                        #word.Selection.HomeKey(unit=6)
                        #find = word.Selection.Find
                        #find.Text = f
                        #while word.Selection.Find.Execute
                        #    if r.nil? || r == ""
                        #        rvalue = " "
                        #    elsif r.class == Field
                        #        rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                        #    else
                        #        rvalue = r.to_s
                        #    end
                        #    word.Selection.TypeText(text=rvalue.gsub("’","'"))
                        #end
                        
                        #main body
                        #word.ActiveWindow.ActivePane.View.SeekView = 0
                        word.Selection.HomeKey(unit=6)
                        find = word.Selection.Find
                        find.Text = f
                        while word.Selection.Find.Execute
                            if r.nil? || r == ""
                                rvalue = " "
                            elsif r.class == Field
                                rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                            else
                                rvalue = r.to_s
                            end
                            word.Selection.TypeText(text=rvalue.gsub("’","'"))
                        end
                    }
                    
                    #FNORD - THIS NEED TO BE GENERALIZED AND MOVED!!!!
                    group_file      = clean_string(group)
                    location        = $config.init_path(    "#{$paths.reports_path}Team_Metrics/EVALUATIONS/ROLE_#{clean_string(role)}/#{samsid}_#{clean_string(k12_name)}"    )
                    filename        = clean_string("evaluation_form_#{samsid}_#{$ifilestamp}")
                    word_doc_path   = "#{location}#{filename}.docx"
                    
                    doc.SaveAs(word_doc_path.gsub("/","\\"))
                    #doc.SaveAs(pdf_doc_path.gsub("/","\\"),17)
                    doc.close
                    word.Quit
                else
                    eval_failed.push("SAMSID: #{samsid} - #{k12_name} ROLE: #{role} PEER_GOUP: #{group||"N/A"}")
                end
            }
        end
        eval_failed_string = String.new
        eval_failed.each{|eval|eval_failed_string << " " + eval} if !eval_failed.empty?
        subject = "Team Eval Auto-Fill FAILED! #{@reporting_period}"
        content = "No metrics found: #{eval_failed_string}"
        $base.system_notification(subject, content) if !eval_failed.empty?
    end
    
    def clean_string(str)
        return str.gsub("-","_").gsub(" ","_")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SNAPSHOTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_snapshot(role, demographic_set = nil)
        if demographic_set && demographic_set[:sub_table]
            table_name  = "TEAM_METRICS_STUDENT_BASED_#{demographic_set[:sub_table]}"
        else
            table_name  = "TEAM_METRICS_STUDENT_BASED"
        end
        
        totals  = totals_hash
        
        eligible_team_members = $team.members_by_role(role)
        
        ineligible_team_members = $team.student_based_evaluation_exempt(role)
        ineligible_team_members.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
        
        if eligible_team_members
            eligible_team_members.each{|samsid|
                record = $tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period)
                if record
                    totals.each_key{|field_name|
                        totals[field_name].push(record.fields[field_name].mathable)
                    }
                else
                    puts "#{__FILE__} #{__LINE__} - Record not found. Reporting Period: #{@reporting_period} SAMSID: #{samsid} ROLE: #{role}"
                end
                
            }
            
            record = get_record(@department_id, role, group = nil, demographic_set)
            totals.each_pair{|field_name, field_array|
                tot         = 0.0
                tot_entries = 0
                field_array.each{|x|
                    if x.is_a?(Float) || x.is_a?(Integer)
                        tot = tot + x
                        tot_entries += 1
                    end 
                }
                if tot_entries > 0
                    average = tot/tot_entries                   
                    record.fields[field_name].value = average
                end
            }
            record.save
        end
        
    end
    
    def peer_group_snapshot(role, demographic_set = nil)
        if demographic_set && demographic_set[:sub_table]
            table_name  = "TEAM_METRICS_STUDENT_BASED_#{demographic_set[:sub_table]}"
        else
            table_name  = "TEAM_METRICS_STUDENT_BASED"
        end
        
        #FIND ALL GROUPS IN THE CURRENT ROLE
        peer_groups     = $team.peer_groups_by_role(role)
        
        #Hold peers missing a student group - all peers should have a student group
        peers_missing   = []
        peer_group_failed = Array.new
        
        #EVALUATE EACH GROUP
        peer_groups.each{|group|
            totals  = totals_hash
            eligible_team_members   = $team.peer_group_members_by_role_group(role, group)
            ineligible_team_members = $team.student_based_evaluation_exempt(role)
            ineligible_team_members.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
            eligible_team_members.each{|samsid|
                record = $tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period)
                if record
                    record.fields["peer_group"].value = group
                    record.save
                    totals.each_key{|field_name|
                        totals[field_name].push(record.fields[field_name].mathable)
                    }
                else
                    peer_name = $team.attach_samsid(samsid).k12_fullname.value
                    peers_missing.push("SAMSID: #{samsid} - #{peer_name} ROLE: #{role} PEER_GOUP: #{group}")
                    peer_group_failed.push(group)
                end
                
            }
            
            #RECORD GROUP TOTALS
            if !peer_group_failed.include?(group)
                record = get_record(@peer_group_id, role, group, demographic_set)
                record.fields["peer_group"].value = group
                totals.each_pair{|field_name, field_array|
                    tot         = 0.0
                    tot_entries = 0
                    field_array.each{|x|
                        if x.is_a?(Float) || x.is_a?(Integer)
                            tot = tot + x
                            tot_entries += 1
                        end 
                    }
                    if tot_entries > 0
                        average = tot/tot_entries                   
                        record.fields[field_name].value = average
                    end
                }
                record.save 
            end
            
        }
        peer_string = String.new
        peers_missing.each{|peer|peer_string << " " + peer} if !peers_missing.empty?
        subject = "Team Metrics Peer Snapshot FAILED! #{@reporting_period}"
        content = "No metrics found: #{peer_string}"
        $base.system_notification(subject, content) if !peers_missing.empty?
    end
    
    def team_member_snapshot(samsid, role, demographic_set = nil)
        puts samsid
        team_member                          = $team.attach_samsid(samsid)
        team_member.student_demographic_set  = demographic_set
        
        ########################################################################
        # DEMOGRAPHICS ARE SET TO CURRENT ROLE ONLY AFTER THIS POINT!!!        #
        ########################################################################
        team_member.student_demographic_set[:role] = role
        ########################################################################
        
        record = get_record(samsid, role, group = nil, demographic_set)
        
        all_students = team_member.students
        count_all_students                                      = all_students ? all_students.length.to_f : 0.0
        
        all_students_new = team_member.students(:new_students_only => true)
        count_all_students_new                                  = all_students_new ? all_students_new.length.to_f : 0.0
        
        #Withdrawn student included in student list are limited to drop outs and truancy withdrawals for FTCs
        if role == "Family Teacher Coach"
            withdrawn_students                                  = team_member.students(:withdrawn_students_only => true, :dropout_truancy=>true)                               
            withdrawn_students_new                              = team_member.students(:withdrawn_students_only => true, :new_students_only => true, :dropout_truancy=>true)
        else
            withdrawn_students                                  = team_member.students(:withdrawn_students_only => true)                               
            withdrawn_students_new                              = team_member.students(:withdrawn_students_only => true, :new_students_only => true)
        end
        
        count_withdrawn_students                                = withdrawn_students ? withdrawn_students.length.to_f : 0.0
        
        count_withdrawn_students_new                            = withdrawn_students_new ? withdrawn_students_new.length.to_f : 0.0
        
        ########################################################################
        # DEMOGRAPHICS ARE SET TO CURRENT STUDENTS ONLY AFTER THIS POINT!!!    #
        ########################################################################
        team_member.student_demographic_set[:current_students_only] = true
        ########################################################################
        
        current_students = team_member.students
        count_current_students                                  = current_students ? current_students.length.to_f : 0.0
        
        current_students_new = team_member.students(:new_students_only => true)
        count_current_students_new                              = current_students_new ? current_students_new.length.to_f : 0.0
        
        in_year_enrolled = team_member.students(:enrolled_after_date => "#{$school.current_school_year_start.mathable.strftime("%Y")}-10-01")
        count_in_year_enrolled                                  = in_year_enrolled ? in_year_enrolled.length.to_f : 0.0
        
        seven_twelve = team_member.students(:grade=> "7|8|9|10|11|12")  
        count_seven_twelve                                      = seven_twelve ? seven_twelve.length.to_f : 0.0
        
        free_reduced = team_member.students(:free_reduced=> true)
        count_free_reduced                                      = free_reduced ? free_reduced.length.to_f : 0.0
        
        tier_three = team_member.students(:tier=> 3)
        count_tier_three                                        = tier_three ? tier_three.length.to_f : 0.0
        
        pssa_eligible = team_member.students(:pssa_eligible=> true)
        count_pssa_eligible                                     = pssa_eligible ? pssa_eligible.length.to_f : 0.0
        
        pssa_participated = team_member.students(:pssa_eligible=> true, :pssa_participated=> true)
        count_pssa_participated                                 = pssa_participated ? pssa_participated.length.to_f : 0.0
        
        
###############################################################################################################################################
# SCANTRON COUNTS #############################################################################################################################
###############################################################################################################################################
        
        scantron_eligible = team_member.students(:scantron_eligible=> true)
        count_scantron_eligible                                 = scantron_eligible ? scantron_eligible.length.to_f : 0.0
        
        scantron_participated_fall = []
        scantron_eligible.each{|sid| scantron_participated_fall.push(sid) if $students.attach(sid).scantron.participated_entrance?} if scantron_eligible
        count_scantron_participated_fall                        = !scantron_participated_fall.empty? ? scantron_participated_fall.length.to_f : 0.0
        
        scantron_participated_spring = []
        scantron_eligible.each{|sid|scantron_participated_spring.push(sid) if $students.attach(sid).scantron.participated_exit?} if scantron_eligible
        count_scantron_participated_spring                      = !scantron_participated_spring.empty? ? scantron_participated_spring.length.to_f : 0.0
        
        scantron_participated_math = []
        scantron_eligible.each{|sid|scantron_participated_math.push(sid) if $students.attach(sid).scantron.participated_math?} if scantron_eligible
        count_scantron_participated_math                        = !scantron_participated_math.empty? ? scantron_participated_math.length.to_f : 0.0
        
        scantron_participated_reading = []
        scantron_eligible.each{|sid|scantron_participated_reading.push(sid) if $students.attach(sid).scantron.participated_reading?} if scantron_eligible
        count_scantron_participated_reading                     = !scantron_participated_reading.empty? ? scantron_participated_reading.length.to_f : 0.0
        
        scantron_participated_fall_math = []
        scantron_eligible.each{|sid| scantron_participated_fall_math.push(sid) if $students.attach(sid).scantron.participated_entrance?} if scantron_eligible
        count_scantron_participated_fall_math                   = !scantron_participated_fall_math.empty? ? scantron_participated_fall_math.length.to_f : 0.0
        
        scantron_participated_spring_math = []
        scantron_eligible.each{|sid|scantron_participated_spring_math.push(sid) if $students.attach(sid).scantron.participated_exit?} if scantron_eligible
        count_scantron_participated_spring_math                 = !scantron_participated_spring_math.empty? ? scantron_participated_spring_math.length.to_f : 0.0
        
        scantron_participated_fall_reading = []
        scantron_eligible.each{|sid| scantron_participated_fall_reading.push(sid) if $students.attach(sid).scantron.participated_entrance?} if scantron_eligible
        count_scantron_participated_fall_reading                = !scantron_participated_fall_reading.empty? ? scantron_participated_fall_reading.length.to_f : 0.0
        
        scantron_participated_spring_reading = []
        scantron_eligible.each{|sid|scantron_participated_spring_reading.push(sid) if $students.attach(sid).scantron.participated_exit?} if scantron_eligible
        count_scantron_participated_spring_reading              = !scantron_participated_spring_reading.empty? ? scantron_participated_spring_reading.length.to_f : 0.0
        
###############################################################################################################################################

###############################################################################################################################################
# DORA DOMA COUNTS ############################################################################################################################
###############################################################################################################################################
        
        dora_doma_eligible = team_member.students(:dora_doma_eligible=> true)
        count_dora_doma_eligible                                = dora_doma_eligible ? dora_doma_eligible.length.to_f : 0.0
        
        dora_doma_participated_fall = []
        dora_doma_eligible.each{|sid| dora_doma_participated_fall.push(sid) if $students.attach(sid).dora_doma_participated_fall?} if dora_doma_eligible
        count_dora_doma_participated_fall                       = !dora_doma_participated_fall.empty? ? dora_doma_participated_fall.length.to_f : 0.0
        
        dora_doma_participated_spring = []
        dora_doma_eligible.each{|sid| dora_doma_participated_spring.push(sid) if $students.attach(sid).dora_doma_participated_spring?}   if dora_doma_eligible
        count_dora_doma_participated_spring                     = !dora_doma_participated_spring.empty? ? dora_doma_participated_spring.length.to_f : 0.0
        
        dora_doma_participated_math = []
        dora_doma_eligible.each{|sid| dora_doma_participated_math.push(sid) if $students.attach(sid).dora_doma_participated_math?}   if dora_doma_eligible
        count_dora_doma_participated_math                       = !dora_doma_participated_math.empty? ? dora_doma_participated_math.length.to_f : 0.0
        
        dora_doma_participated_reading = []
        dora_doma_eligible.each{|sid| dora_doma_participated_reading.push(sid) if $students.attach(sid).dora_doma_participated_reading?}   if dora_doma_eligible
        count_dora_doma_participated_reading                    = !dora_doma_participated_reading.empty? ? dora_doma_participated_reading.length.to_f : 0.0
        
        dora_doma_participated_fall_math = []
        dora_doma_eligible.each{|sid| dora_doma_participated_fall_math.push(sid) if $students.attach(sid).doma_participated_fall?} if dora_doma_eligible
        count_dora_doma_participated_fall_math                  = !dora_doma_participated_fall_math.empty? ? dora_doma_participated_fall_math.length.to_f : 0.0
        
        dora_doma_participated_spring_math = []
        dora_doma_eligible.each{|sid|dora_doma_participated_spring_math.push(sid) if $students.attach(sid).doma_participated_spring?} if dora_doma_eligible
        count_dora_doma_participated_spring_math                = !dora_doma_participated_spring_math.empty? ? dora_doma_participated_spring_math.length.to_f : 0.0
        
        dora_doma_participated_fall_reading = []
        dora_doma_eligible.each{|sid| dora_doma_participated_fall_reading.push(sid) if $students.attach(sid).dora_participated_fall?} if dora_doma_eligible
        count_dora_doma_participated_fall_reading               = !dora_doma_participated_fall_reading.empty? ? dora_doma_participated_fall_reading.length.to_f : 0.0
        
        dora_doma_participated_spring_reading = []
        dora_doma_eligible.each{|sid|dora_doma_participated_spring_reading.push(sid) if $students.attach(sid).dora_participated_spring?} if dora_doma_eligible
        count_dora_doma_participated_spring_reading             = !dora_doma_participated_spring_reading.empty? ? dora_doma_participated_spring_reading.length.to_f : 0.0
        
###############################################################################################################################################
# SCANTRON && DORA DOMA COUNTS ################################################################################################################
###############################################################################################################################################
        
        count_scantron_dd_eligible                              =(count_dora_doma_eligible                       +       count_scantron_eligible                    )
        count_scantron_dd_participated_fall                     =(count_dora_doma_participated_fall              +       count_scantron_participated_fall           )
        count_scantron_dd_participated_spring                   =(count_dora_doma_participated_spring            +       count_scantron_participated_spring         )
        count_scantron_dd_participated_math                     =(count_dora_doma_participated_math              +       count_scantron_participated_math           )
        count_scantron_dd_participated_reading                  =(count_dora_doma_participated_reading           +       count_scantron_participated_reading        )
        count_scantron_dd_participated_fall_math                =(count_dora_doma_participated_fall_math         +       count_scantron_participated_fall_math      )
        count_scantron_dd_participated_spring_math              =(count_dora_doma_participated_spring_math       +       count_scantron_participated_spring_math    )
        count_scantron_dd_participated_fall_reading             =(count_dora_doma_participated_fall_reading      +       count_scantron_participated_fall_reading   )
        count_scantron_dd_participated_spring_reading           =(count_dora_doma_participated_spring_reading    +       count_scantron_participated_spring_reading )
        
###############################################################################################################################################
        
        engage_eligible = team_member.students(:engage_eligible=> true)
        count_engage_eligible                                   = engage_eligible ? engage_eligible.length.to_f : 0.0
        
        engage_high = []
        engage_eligible.each{|sid|engage_high.push(sid) if $students.attach(sid).engagement_level.value == "High"}                       if engage_eligible
        count_engage_high                                       = !engage_high.empty? ? engage_high.length.to_f : 0.0
        
        engage_average = []
        engage_eligible.each{|sid|engage_average.push(sid) if $students.attach(sid).engagement_level.value == "Average"}                 if engage_eligible
        count_engage_average                                    = !engage_average.empty? ? engage_average.length.to_f : 0.0
        
        engage_low = []
        engage_eligible.each{|sid|engage_low.push(sid) if $students.attach(sid).engagement_level.value == "Low"}                         if engage_eligible
        count_engage_low                                        = !engage_low.empty? ? engage_low.length.to_f : 0.0
        
        special_ed = team_member.students(:special_ed=> true)
        count_special_ed                                        = special_ed ? special_ed.length.to_f : 0.0
        
        monthly_assessment_eligible = team_member.students(:monthly_assessment_eligible=> :overall)
        count_monthly_assessment_eligible                       = monthly_assessment_eligible ? monthly_assessment_eligible.length.to_f : 0.0
        
        monthly_assessment_participated = []
        monthly_assessment_eligible.each{|sid| monthly_assessment_participated.push(sid) if $students.attach(sid).monthly_assessment_participated?} if monthly_assessment_eligible
        count_monthly_assessment_participated                   = !monthly_assessment_participated.empty? ? monthly_assessment_participated.length.to_f : 0.0
        
        monthly_assessment_participated_math = []
        monthly_assessment_eligible.each{|sid| monthly_assessment_participated_math.push(sid) if $students.attach(sid).monthly_assessment_participated_math?} if monthly_assessment_eligible
        count_monthly_assessment_participated_math              = !monthly_assessment_participated_math.empty? ? monthly_assessment_participated_math.length.to_f : 0.0
        
        monthly_assessment_participated_reading = []
        monthly_assessment_eligible.each{|sid| monthly_assessment_participated_reading.push(sid) if $students.attach(sid).monthly_assessment_participated_reading?} if monthly_assessment_eligible
        count_monthly_assessment_participated_reading           = !monthly_assessment_participated_reading.empty? ? monthly_assessment_participated_reading.length.to_f : 0.0
        
        monthly_assessment_tier_three_eligible  = team_member.students(:monthly_assessment_eligible=> :overall, :tier=> 3)
        count_monthly_assessment_tier_three_eligible            = monthly_assessment_tier_three_eligible ? monthly_assessment_tier_three_eligible.length.to_f : 0.0 
        
        monthly_assessment_tier_three_participated = []
        monthly_assessment_tier_three_eligible.each{|sid| monthly_assessment_tier_three_participated.push(sid) if $students.attach(sid).monthly_assessment_participated?} if monthly_assessment_tier_three_eligible
        count_monthly_assessment_tier_three_participated        = !monthly_assessment_tier_three_participated.empty? ? monthly_assessment_tier_three_participated.length.to_f : 0.0
        
        monthly_assessment_tier_2or3_eligible  = team_member.students(:monthly_assessment_eligible=> :overall, :tier=> "2|3")
        count_monthly_assessment_tier_2or3_eligible             = monthly_assessment_tier_2or3_eligible ? monthly_assessment_tier_2or3_eligible.length.to_f : 0.0 
        
        monthly_assessment_tier_2or3_participated = []
        monthly_assessment_tier_2or3_eligible.each{|sid| monthly_assessment_tier_2or3_participated.push(sid) if $students.attach(sid).monthly_assessment_participated?} if monthly_assessment_tier_2or3_eligible
        count_monthly_assessment_tier_2or3_participated         = !monthly_assessment_tier_2or3_participated.empty? ? monthly_assessment_tier_2or3_participated.length.to_f : 0.0
        
        percent_new                                             = count_current_students_new                            /       count_current_students                                                                                  
        percent_inyear                                          = count_in_year_enrolled                                /       count_current_students                                                                                      
        percent_seven_twelve                                    = count_seven_twelve                                    /       count_current_students                                                                                          
        percent_free_reduced                                    = count_free_reduced                                    /       count_current_students                                                                                          
        percent_tier_three                                      = count_tier_three                                      /       count_current_students                                                                                            
        percent_pssa_eligible                                   = count_pssa_eligible                                   /       count_current_students                                                                                         
        percent_pssa_participated                               = count_pssa_participated                               /       count_pssa_eligible                                                                                        
        
###############################################################################################################################################
# SCANTRON PERCENTS ###########################################################################################################################
###############################################################################################################################################
        
        percent_scantron_eligible                               = count_scantron_eligible                               /       count_current_students                                                                                     
        percent_scantron_participated_fall                      = count_scantron_participated_fall                      /       count_scantron_eligible                                                                           
        percent_scantron_participated_spring                    = count_scantron_participated_spring                    /       count_scantron_eligible
        percent_scantron_participated_math                      = count_scantron_participated_spring                    /       count_scantron_eligible
        percent_scantron_participated_reading                   = count_scantron_participated_spring                    /       count_scantron_eligible
        percent_scantron_participated_fall_math                 = count_scantron_participated_fall_math                 /       count_scantron_eligible
        percent_scantron_participated_spring_math               = count_scantron_participated_spring_math               /       count_scantron_eligible
        percent_scantron_participated_fall_reading              = count_scantron_participated_fall_reading              /       count_scantron_eligible
        percent_scantron_participated_spring_reading            = count_scantron_participated_spring_reading            /       count_scantron_eligible
        
###############################################################################################################################################
 
###############################################################################################################################################
# DORA DOME PERCENTS ##########################################################################################################################
###############################################################################################################################################
        
        percent_dora_doma_eligible                               = count_dora_doma_eligible                             /       count_current_students                                                                                     
        percent_dora_doma_participated_fall                      = count_dora_doma_participated_fall                    /       count_dora_doma_eligible                                                                           
        percent_dora_doma_participated_spring                    = count_dora_doma_participated_spring                  /       count_dora_doma_eligible
        percent_dora_doma_participated_math                      = count_dora_doma_participated_spring                  /       count_dora_doma_eligible
        percent_dora_doma_participated_reading                   = count_dora_doma_participated_spring                  /       count_dora_doma_eligible
        percent_dora_doma_participated_fall_math                 = count_dora_doma_participated_fall_math               /       count_dora_doma_eligible
        percent_dora_doma_participated_spring_math               = count_dora_doma_participated_spring_math             /       count_dora_doma_eligible
        percent_dora_doma_participated_fall_reading              = count_dora_doma_participated_fall_reading            /       count_dora_doma_eligible
        percent_dora_doma_participated_spring_reading            = count_dora_doma_participated_spring_reading          /       count_dora_doma_eligible                                                                       
      
###############################################################################################################################################

###############################################################################################################################################
# SCANTRON && DORA DOMA PERCENTS ##############################################################################################################
###############################################################################################################################################
        
        percent_scantron_dd_eligible                            = count_scantron_dd_eligible                            /       count_current_students
        percent_scantron_dd_participated_fall                   = count_scantron_dd_participated_fall                   /       count_scantron_dd_eligible                                                                          
        percent_scantron_dd_participated_spring                 = count_scantron_dd_participated_spring                 /       count_scantron_dd_eligible
        percent_scantron_dd_participated_math                   = count_scantron_dd_participated_spring                 /       count_scantron_dd_eligible
        percent_scantron_dd_participated_reading                = count_scantron_dd_participated_spring                 /       count_scantron_dd_eligible
        percent_scantron_dd_participated_fall_math              = count_scantron_dd_participated_fall_math              /       count_scantron_dd_eligible
        percent_scantron_dd_participated_spring_math            = count_scantron_dd_participated_spring_math            /       count_scantron_dd_eligible
        percent_scantron_dd_participated_fall_reading           = count_scantron_dd_participated_fall_reading           /       count_scantron_dd_eligible
        percent_scantron_dd_participated_spring_reading         = count_scantron_dd_participated_spring_reading         /       count_scantron_dd_eligible
        
###############################################################################################################################################
        
        percent_engage_eligible                                 = count_engage_eligible                                 /       count_current_students                                                                                       
        percent_engage_high                                     = count_engage_high                                     /       count_engage_eligible                                                                                            
        percent_engage_average                                  = count_engage_average                                  /       count_engage_eligible                                                                                         
        percent_engage_low                                      = count_engage_low                                      /       count_engage_eligible                                                                                             
        percent_special_ed                                      = count_special_ed                                      /       count_current_students                                                                                            
        percent_monthly_assessment_eligible                     = count_monthly_assessment_eligible                     /       count_current_students                                                                           
        percent_monthly_assessment_participated                 = count_monthly_assessment_participated                 /       count_monthly_assessment_eligible                                                            
        
        percent_monthly_assessment_participated_math            = count_monthly_assessment_participated_math            /       count_monthly_assessment_eligible
        percent_monthly_assessment_participated_reading         = count_monthly_assessment_participated_reading         /       count_monthly_assessment_eligible
        
        percent_monthly_assessment_tier_three_eligible          = count_monthly_assessment_tier_three_eligible          /       count_current_students                                                                
        percent_monthly_assessment_tier_three_participated      = count_monthly_assessment_tier_three_participated      /       count_monthly_assessment_tier_three_eligible                                      
        percent_monthly_assessment_tier_2or3_eligible           = count_monthly_assessment_tier_2or3_eligible           /       count_current_students                                                                 
        percent_monthly_assessment_tier_2or3_participated       = count_monthly_assessment_tier_2or3_participated       /       count_monthly_assessment_tier_2or3_eligible                                        
        
        current_att_tots        = 0.0
        current_students.each{|sid| current_att_tots = current_att_tots + $students.attach(sid).attendance.rate_decimal}        if current_students
        rate_attendance_current                                 = current_att_tots/count_current_students                       if current_students
        
        withdrawn_att_tots      = 0.0
        withdrawn_students.each{|sid| withdrawn_att_tots = withdrawn_att_tots + $students.attach(sid).attendance.rate_decimal}  if withdrawn_students
        rate_attendance_withdrawn                               = withdrawn_att_tots/count_withdrawn_students                   if withdrawn_students
        
        all_att_tots            = 0.0
        all_students.each{|sid| all_att_tots = all_att_tots + $students.attach(sid).attendance.rate_decimal}                    if all_students
        rate_attendance_all                                     = all_att_tots/count_all_students                               if all_students
        
        rate_retention                                          = count_current_students/count_all_students                     if withdrawn_students
        
        
        
        monthly_assessment_math_eligible = team_member.students(:monthly_assessment_eligible=> :math)
        count_monthly_assessment_math_eligible                  = monthly_assessment_math_eligible ? monthly_assessment_math_eligible.length.to_f : 0.0
        monthly_assessment_growth_overall_math_tots = 0.0
        monthly_assessment_math_eligible.each{|sid| monthly_assessment_growth_overall_math_tots = monthly_assessment_growth_overall_math_tots + $students.attach(sid).monthly_assessment_growth_overall_math.mathable} if monthly_assessment_math_eligible
        rate_monthly_assessment_growth_overall_math             = monthly_assessment_growth_overall_math_tots/count_monthly_assessment_math_eligible if monthly_assessment_math_eligible
        
        monthly_assessment_reading_eligible = team_member.students(:monthly_assessment_eligible=> :reading)
        count_monthly_assessment_reading_eligible               = monthly_assessment_reading_eligible ? monthly_assessment_reading_eligible.length.to_f : 0.0
        monthly_assessment_growth_overall_reading_tots = 0.0
        monthly_assessment_reading_eligible.each{|sid| monthly_assessment_growth_overall_reading_tots = monthly_assessment_growth_overall_reading_tots + $students.attach(sid).monthly_assessment_growth_overall_reading.mathable} if monthly_assessment_reading_eligible
        rate_monthly_assessment_growth_overall_reading          = monthly_assessment_growth_overall_reading_tots/count_monthly_assessment_reading_eligible if monthly_assessment_reading_eligible
        
        
        
        annual_assessment_growth_math_eligible          = team_member.students(:annual_assessment_eligible=> :math)
        count_annual_assessment_growth_math_eligible    = annual_assessment_growth_math_eligible ? annual_assessment_growth_math_eligible.length.to_f : 0.0
        annual_assessment_growth_math_tots = 0.0
        annual_assessment_growth_math_eligible.each{|sid|
            growth = $students.attach(sid).annual_assessment_growth_math
            if growth && growth.is_true?
                annual_assessment_growth_math_tots      = annual_assessment_growth_math_tots + 1
            end
        } if annual_assessment_growth_math_eligible
        rate_annual_assessment_growth_math              = annual_assessment_growth_math_tots/count_annual_assessment_growth_math_eligible if annual_assessment_growth_math_eligible
        
        annual_assessment_growth_reading_eligible          = team_member.students(:annual_assessment_eligible=> :reading)
        count_annual_assessment_growth_reading_eligible    = annual_assessment_growth_reading_eligible ? annual_assessment_growth_reading_eligible.length.to_f : 0.0
        annual_assessment_growth_reading_tots = 0.0
        annual_assessment_growth_reading_eligible.each{|sid|
            growth = $students.attach(sid).annual_assessment_growth_reading
            if growth && growth.is_true?
                annual_assessment_growth_reading_tots      = annual_assessment_growth_reading_tots + 1
            end
        } if annual_assessment_growth_reading_eligible
        rate_annual_assessment_growth_reading              = annual_assessment_growth_reading_tots/count_annual_assessment_growth_reading_eligible if annual_assessment_growth_reading_eligible
        
        
        passing_tots = 0.0
        classes_tots = 0.0
        current_students.each{|sid|
            passing_recs = $students.attach(sid).passing_records($term || "Yr")
            if passing_recs
                passing_recs.each{|rec|
                    passing_tots += 1 if rec.fields["passing"].is_true?
                    classes_tots += 1
                } 
            end
        } if current_students
        rate_passing                                       = passing_tots/classes_tots if current_students
        
        engagement_level_tots   = 0.0
        engage_eligible.each{|sid|
            level = $students.attach(sid).engagement_level.value
            level = 3.0 if level == "High"
            level = 2.0 if level == "Average"
            level = 1.0 if level == "Low"
            engagement_level_tots = engagement_level_tots + level
        } if engage_eligible
        avg_engagement_level                                    = engagement_level_tots/count_engage_eligible if engage_eligible                         
        primary_id = false
        record.fields.each_key{|field_name|
            record.fields[field_name].value = eval(field_name) if field_name.match(/count_|percent_|avg_|rate_/)
        }
        record.save
        
        place_holder = "students_"
        include_record = get_include_record(samsid, role, demographic_set)
        include_record.fields.each_key{|field_name|
            if field_name.include?(place_holder)
                x = eval( field_name.gsub(/^#{place_holder}/,'')  )
                if x && !x.empty?
                    include_record.fields[field_name].value = x.join(",")
                end
            end
        }
        include_record.save
    end
    
    def snapshot(role, demographic_set = nil)
        eligible_team_members      = $team.members_by_role(role)     
        
        if eligible_team_members
            #REMOVE INELLIGIBLE TEAM MEMBERS
            #ineligible_team_members = $team.student_based_evaluation_exempt(role)
            #ineligible_team_members.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
            
            if demographic_set && demographic_set[:sub_table]
                table_name  = "TEAM_METRICS_STUDENT_BASED_#{demographic_set[:sub_table]}"
            else
                table_name  = "TEAM_METRICS_STUDENT_BASED"
            end
            
            eligible_team_members.each{|samsid|
                if !$tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period)
                    team_member_snapshot(samsid, role, demographic_set)
                end 
            }
            
        end
    end
    
    def snapshot_7_12
        $switch = true
        role    = "Freshman Academy"
        $reporting_date_override = false
        #q2 Jan 26 q3 april 11
        ["Q4"].each{|term|
            $term                       = term
            @reporting_period           = "2011-2012 EOY #{term}"
            
            eligible_team_members = $db.get_data_single("SELECT samsid FROM student_relate_7_12 WHERE role = '#{role}' AND samsid IS NOT NULL GROUP BY samsid")     
            
            if eligible_team_members
                eligible_team_members.each{|samsid|
                    if !$tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, @reporting_period)
                        team_member_snapshot(samsid, role)
                    end
                }
            end  
        }   
    end
    
    def snapshot_7_12_wrap_up
        role = "Freshman Academy"
        eligible_team_members = $db.get_data_single("SELECT samsid FROM student_relate_7_12 WHERE role = '#{role}' AND samsid IS NOT NULL GROUP BY samsid")     
        
        if eligible_team_members
            reporting_periods = ["2011-2012 EOY Q4"]
            
            eligible_team_members.each{|samsid|
                if !$tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, @reporting_period)
                    totals = totals_hash
                    reporting_periods.each{|period|
                        record = $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, period)
                        totals.each_key{|field_name|
                            totals[field_name].push(record.fields[field_name].mathable)    
                        }
                    }
                    
                    wrap_up_record = get_record(samsid, role)
                    totals.each_pair{|field_name, field_array|
                        keep_record = true
                        tot         = 0.0
                        tot_entries = 0
                        field_array.each{|x|
                            if x.is_a?(Float) || (x.is_a?(Integer) && x > 0)
                                tot = tot + x
                                tot_entries += 1
                            end 
                        }
                        if tot_entries > 0
                            average = tot/tot_entries                   
                            wrap_up_record.fields[field_name].value = average
                        end
                    }
                    wrap_up_record.save
                end
            }
        end
    end
    
    def snapshot_7_12_wrap_up_department
        role = "High School Teacher"
        eligible_team_members = $db.get_data_single("SELECT samsid FROM student_relate_7_12 WHERE role = '#{role}' AND samsid IS NOT NULL GROUP BY samsid")     
        
        if eligible_team_members
            #REMOVE INELLIGIBLE TEAM MEMBERS
            ineligible_team_members = []
            ineligible_team_members.each{|samsid| @eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
            
            #THIS IS TEMPORARY _ DELETE AFTER THIS YEAR
            #already_processed = $db.get_data_single("SELECT samsid FROM TEAM_METRICS_STUDENT_BASED")
            #already_processed.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if already_processed
            
            reporting_periods = ["2011-2012 EOY - Wrap Up"]
            
            totals = totals_hash
            eligible_team_members.each{|samsid|
                if $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, @reporting_period)
                    reporting_periods.each{|period|
                        record = $tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, period)
                        totals.each_key{|field_name|
                            totals[field_name].push(record.fields[field_name].mathable)    
                        }
                    }
                end
            }
            wrap_up_record = get_record(@department_id, role)
            totals.each_pair{|field_name, field_array|
                keep_record = true
                tot         = 0.0
                tot_entries = 0
                field_array.each{|x|
                    if x.is_a?(Float) || (x.is_a?(Integer) && x > 0)
                        tot = tot + x
                        tot_entries += 1
                    end 
                }
                if tot_entries > 0
                    average = tot/tot_entries                   
                    wrap_up_record.fields[field_name].value = average
                end
            }
            wrap_up_record.save
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def find_record(samsid, role, group = nil, demographic_set = nil)
        if demographic_set && demographic_set[:sub_table]
            table_name  = "TEAM_METRICS_STUDENT_BASED_#{demographic_set[:sub_table]}"
        else
            table_name  = "TEAM_METRICS_STUDENT_BASED"
        end
        
        return $tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period, group)
    end
    
    def get_record(samsid, role, group = nil, demographic_set = nil)
        if demographic_set && demographic_set[:sub_table]
            table_name  = "TEAM_METRICS_STUDENT_BASED_#{demographic_set[:sub_table]}"
        else
            table_name  = "TEAM_METRICS_STUDENT_BASED"
        end
        
        record = $tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period, group)
        if !record
            record = $tables.attach(table_name).new_row
            record.fields["samsid"              ].value = samsid
            record.fields["role"                ].value = role
            record.fields["reporting_period"    ].value = @reporting_period
            record.save
        end
        return record
    end
    
    def get_include_record(samsid, role, demographic_set = nil)
        if demographic_set && demographic_set[:sub_table]
            table_name  = "TEAM_METRICS_STUDENT_BASED_STUDENT_INCLUDES_#{demographic_set[:sub_table]}"
        else
            table_name  = "TEAM_METRICS_STUDENT_BASED_STUDENT_INCLUDES"
        end
        
        record = $tables.attach(table_name).by_samsid_role(samsid, role, @reporting_period)
        if !record
            record = $tables.attach(table_name).new_row
            record.fields["samsid"              ].value = samsid
            record.fields["role"                ].value = role
            record.fields["reporting_period"    ].value = @reporting_period
            record.save
        end
        return record
    end
    
    def totals_hash
        totals = Hash.new
        
        totals["count_all_students"]                                            = []                      
        totals["count_all_students_new"]                                        = []
        totals["count_current_students"]                                        = []
        totals["count_current_students_new"]                                    = []
        totals["count_withdrawn_students"]                                      = []
        totals["count_withdrawn_students_new"]                                  = []
        totals["count_in_year_enrolled"]                                        = []
        totals["count_seven_twelve"]                                            = []
        totals["count_free_reduced"]                                            = []
        totals["count_tier_three"]                                              = []
        totals["count_pssa_eligible"]                                           = []
        totals["count_pssa_participated"]                                       = []
        totals["count_scantron_eligible"]                                       = []
        totals["count_scantron_participated_fall"]                              = []
        totals["count_scantron_participated_spring"]                            = []
        totals["count_scantron_participated_math"]                              = []
        totals["count_scantron_participated_reading"]                           = []
        totals["count_scantron_participated_fall_math"]                         = []
        totals["count_scantron_participated_spring_math"]                       = []
        totals["count_scantron_participated_fall_reading"]                      = []
        totals["count_scantron_participated_spring_reading"]                    = []
        totals["count_dora_doma_eligible"]                                      = []
        totals["count_dora_doma_participated_fall"]                             = []
        totals["count_dora_doma_participated_spring"]                           = []
        totals["count_dora_doma_participated_math"]                             = []
        totals["count_dora_doma_participated_reading"]                          = []
        totals["count_dora_doma_participated_fall_math"]                        = []
        totals["count_dora_doma_participated_spring_math"]                      = []
        totals["count_dora_doma_participated_fall_reading"]                     = []
        totals["count_dora_doma_participated_spring_reading"]                   = []
        totals["count_scantron_dd_eligible"]                                    = []
        totals["count_scantron_dd_participated_fall"]                           = []
        totals["count_scantron_dd_participated_spring"]                         = []
        totals["count_scantron_dd_participated_math"]                           = []
        totals["count_scantron_dd_participated_reading"]                        = []
        totals["count_scantron_dd_participated_fall_math"]                      = []
        totals["count_scantron_dd_participated_spring_math"]                    = []
        totals["count_scantron_dd_participated_fall_reading"]                   = []
        totals["count_scantron_dd_participated_spring_reading"]                 = []
        totals["count_engage_eligible"]                                         = []
        totals["count_engage_high"]                                             = []
        totals["count_engage_average"]                                          = []
        totals["count_engage_low"]                                              = []
        totals["count_special_ed"]                                              = []
        totals["count_monthly_assessment_eligible"]                             = []
        totals["count_monthly_assessment_participated"]                         = []
        totals["count_monthly_assessment_participated_math"]                    = []
        totals["count_monthly_assessment_participated_reading"]                 = []
        totals["count_monthly_assessment_tier_three_eligible"]                  = []
        totals["count_monthly_assessment_tier_three_participated"]              = []
        totals["count_monthly_assessment_tier_2or3_eligible"]                   = []
        totals["count_monthly_assessment_tier_2or3_participated"]               = []
        totals["count_monthly_assessment_math_eligible"]                        = []
        totals["count_monthly_assessment_reading_eligible"]                     = []
        totals["count_annual_assessment_growth_math_eligible"]                  = []
        totals["count_annual_assessment_growth_reading_eligible"]               = []
        totals["percent_new"]                                                   = []
        totals["percent_inyear"]                                                = []
        totals["percent_seven_twelve"]                                          = []
        totals["percent_free_reduced"]                                          = []
        totals["percent_tier_three"]                                            = []
        totals["percent_pssa_eligible"]                                         = []
        totals["percent_pssa_participated"]                                     = []
        totals["percent_scantron_eligible"]                                     = []
        totals["percent_scantron_participated_fall"]                            = []
        totals["percent_scantron_participated_spring"]                          = []
        totals["percent_scantron_participated_math"]                            = []
        totals["percent_scantron_participated_reading"]                         = []
        totals["percent_scantron_participated_fall_math"]                       = []
        totals["percent_scantron_participated_spring_math"]                     = []
        totals["percent_scantron_participated_fall_reading"]                    = []
        totals["percent_scantron_participated_spring_reading"]                  = []
        totals["percent_dora_doma_eligible"]                                    = []
        totals["percent_dora_doma_participated_fall"]                           = []
        totals["percent_dora_doma_participated_spring"]                         = []
        totals["percent_dora_doma_participated_math"]                           = []
        totals["percent_dora_doma_participated_reading"]                        = []
        totals["percent_dora_doma_participated_fall_math"]                      = []
        totals["percent_dora_doma_participated_spring_math"]                    = []
        totals["percent_dora_doma_participated_fall_reading"]                   = []
        totals["percent_dora_doma_participated_spring_reading"]                 = []
        totals["percent_scantron_dd_eligible"]                                  = []
        totals["percent_scantron_dd_participated_fall"]                         = []
        totals["percent_scantron_dd_participated_spring"]                       = []
        totals["percent_scantron_dd_participated_math"]                         = []
        totals["percent_scantron_dd_participated_reading"]                      = []
        totals["percent_scantron_dd_participated_fall_math"]                    = []
        totals["percent_scantron_dd_participated_spring_math"]                  = []
        totals["percent_scantron_dd_participated_fall_reading"]                 = []
        totals["percent_scantron_dd_participated_spring_reading"]               = []
        totals["percent_engage_eligible"]                                       = []
        totals["percent_engage_high"]                                           = []
        totals["percent_engage_average"]                                        = []
        totals["percent_engage_low"]                                            = []
        totals["percent_special_ed"]                                            = []
        totals["percent_monthly_assessment_eligible"]                           = []
        totals["percent_monthly_assessment_participated"]                       = []
        totals["percent_monthly_assessment_participated_math"]                  = []
        totals["percent_monthly_assessment_participated_reading"]               = []
        totals["percent_monthly_assessment_tier_three_eligible"]                = []
        totals["percent_monthly_assessment_tier_three_participated"]            = []
        totals["percent_monthly_assessment_tier_2or3_eligible"]                 = []
        totals["percent_monthly_assessment_tier_2or3_participated"]             = []
        totals["rate_attendance_current"]                                       = []
        totals["rate_attendance_withdrawn"]                                     = []
        totals["rate_attendance_all"]                                           = []
        totals["rate_retention"]                                                = []
        totals["rate_monthly_assessment_growth_overall_math"]                   = []
        totals["rate_monthly_assessment_growth_overall_reading"]                = []
        totals["rate_annual_assessment_growth_math"]                            = []
        totals["rate_annual_assessment_growth_reading"]                         = []
        totals["rate_passing"]                                                  = []
        totals["avg_engagement_level"]                                          = []
        
        return totals
    end
    
    def evaluation_hash
        e_hash = Hash.new
        
        e_hash["evaluation_date"]                                               = []
        e_hash["title"]                                                         = []
        e_hash["academic_team"]                                                 = []
        e_hash["evaluator"]                                                     = []
        e_hash["review_period"]                                                 = []
        e_hash["inst_evi_fos"]                                                  = []
        e_hash["inst_evi_rmatts"]                                               = []
        e_hash["inst_distinguished"]                                            = []
        e_hash["inst_proficient"]                                               = []
        e_hash["inst_needs_improve"]                                            = []
        e_hash["inst_unsatisfactory"]                                           = []
        e_hash["instruction_teacher_comments"]                                  = []
        e_hash["instruction_evaluator_comments"]                                = []
        e_hash["metrics_evi_dpfs"]                                              = []
        e_hash["metrics_annual_assessment_score"]                               = []
        e_hash["metrics_monthly_assessment_score"]                              = []
        e_hash["metrics_teacher_comments"]                                      = []
        e_hash["metrics_evaluator_comments"]                                    = []
        e_hash["pro_distinguished"]                                             = []
        e_hash["pro_proficient"]                                                = []
        e_hash["pro_needs_improve"]                                             = []
        e_hash["pro_unsatisfactory"]                                            = []
        e_hash["professionalism_teacher_comments"]                              = []
        e_hash["professionalism_evaluator_comments"]                            = []
        e_hash["self_assessment_teacher_comments"]                              = []
        e_hash["self_assessment_teacher_score"]                                 = []
        e_hash["self_assessment_evaluator_comments"]                            = []
        e_hash["self_assessment_evaluator_score"]                               = []
        e_hash["overall_score"]                                                 = []
        e_hash["goals_comments"]                                                = []
        e_hash["goals_1"]                                                       = []
        e_hash["goals_2"]                                                       = []
        e_hash["goals_3"]                                                       = []
        e_hash["ab_mentoring"]                                                  = []
        e_hash["ab_recruiting"]                                                 = []
        e_hash["ab_commitee"]                                                   = []
        e_hash["ab_testing"]                                                    = []
        e_hash["ab_afterhours_sess"]                                            = []
        e_hash["ab_pd_leader"]                                                  = []
        e_hash["ab_admin_expert"]                                               = []
        e_hash["ab_club_advisor"]                                               = []
        e_hash["ab_substituting"]                                               = []
        e_hash["ab_afterhours_parent"]                                          = []
        e_hash["ab_other"]                                                      = []
        e_hash["ab_other_text"]                                                 = []
        e_hash["overall_teacher_comments"]                                      = []
        e_hash["overall_director_comments"]                                     = []
        
        return e_hash
    end

end

TEAM_METRICS_SNAPSHOT_a.new