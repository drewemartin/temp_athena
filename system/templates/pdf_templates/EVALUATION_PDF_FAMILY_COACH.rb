#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("templates/pdf_templates","base/base")
class EVALUATION_PDF_FAMILY_COACH < Base

    #---------------------------------------------------------------------------
    def initialize()
        
        super()
        @t = nil
        
    end
    #---------------------------------------------------------------------------
    
    def above_and_beyond(pdf)
        
        empty_checkbox  = "\xE2\x98\x90" # "☐"
        
        filled_checkbox = "\xE2\x98\x91" # "☑"
        
        aab = @t.evaluation_aab
        pdf.table [
            
            ["Above and Beyond
Teacher has participated in additional duties beyond his/her job description that contributes to the operation, growth and positive climate of our school."],
            ["Sources of Evidence:
#{aab.source_mentoring        && aab.source_mentoring.is_true?          ? filled_checkbox : empty_checkbox  } Mentoring
#{aab.source_recruitment_team && aab.source_recruitment_team.is_true?   ? filled_checkbox : empty_checkbox  } During the Year Recruitment Team
#{aab.source_committee        && aab.source_committee.is_true?          ? filled_checkbox : empty_checkbox  } Committee Work
#{aab.source_testing          && aab.source_testing.is_true?            ? filled_checkbox : empty_checkbox  } Testing
#{aab.source_after_hours      && aab.source_after_hours.is_true?        ? filled_checkbox : empty_checkbox  } After Hours Sessions with parents/students
#{aab.source_leading_pd       && aab.source_leading_pd.is_true?         ? filled_checkbox : empty_checkbox  } Leading Professional Development
#{aab.source_program_admin    && aab.source_program_admin.is_true?      ? filled_checkbox : empty_checkbox  } Program Administrator/expert 
#{aab.source_local_club       && aab.source_local_club.is_true?         ? filled_checkbox : empty_checkbox  } LOCAL Club Advisor
#{aab.source_subsitute_no_pay && aab.source_subsitute_no_pay.is_true?   ? filled_checkbox : empty_checkbox  } Substituting (Without compensation) 
#{aab.source_parent_training  && aab.source_parent_training.is_true?    ? filled_checkbox : empty_checkbox  } Parent trainings outside normal work hours              
#{aab.source_other            && aab.source_other.value                 ? filled_checkbox : empty_checkbox  } Other – Please describe here: #{aab.source_other ? aab.source_other.value : ""}"],
            
            ["Coach Comments: #{        aab.team_member_comments ? aab.team_member_comments.value   : ""}"],
            ["Evaluator Comments: #{    aab.supervisor_comments  ? aab.supervisor_comments.value    : ""}"]
            
        ],
        :width      =>520,
        :position   => :center,
        :cell_style => {
            :size          => 8,
            :inline_format => true
        } do
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.background_color = "DBF4FF"
                    
                when 2,3
                    
                    c.height = 50
                    
                end
                
            end
            
        end
        
        pdf.move_down 20
        
        return pdf
        
    end
    
    def evaluation(pdf)
        
        empty_checkbox  = "\xE2\x98\x90" # "☐"
        
        filled_checkbox = "\xE2\x98\x91" # "☑"
        
        engagement_metrics = @t.evaluation_engagement_metrics
        
        metrics_st_part_fall                                       = engagement_metrics.scantron_participation.value
        metrics_st_part_spring                                     = ""#engagement_metrics.scantron_participation.value
        metrics_st_part_comments                                   = engagement_metrics.scantron_participation_comments.value
        metrics_att_vs                                             = engagement_metrics.attendance.value
        metrics_att_vs_comments                                    = engagement_metrics.attendance_comments.value
        metrics_do_tp                                              = engagement_metrics.truancy_prevention.value
        metrics_do_tp_comments                                     = engagement_metrics.truancy_prevention_comments.value
        metrics_pssa_part                                          = engagement_metrics.evaluation_participation.value
        metrics_pssa_comments                                      = engagement_metrics.evaluation_participation_comments.value
        metrics_quality_doc                                        = engagement_metrics.quality_documentation.value
        metrics_quality_doc_comments                               = engagement_metrics.quality_documentation_comments.value
        metrics_fp_feedback                                        = engagement_metrics.feedback.value
        metrics_fp_feedback_comments                               = engagement_metrics.feedback_comments.value
        metrics_coach_comments                                     = engagement_metrics.team_member_comments.value
        metrics_evaluator_comments                                 = engagement_metrics.supervisor_comments.value
        metrics_score                                              = engagement_metrics.score.value
        
        engagement_observation = @t.evaluation_engagement_observation
        
        rapport                   = engagement_observation.rapport.value
        basic_knowledge           = engagement_observation.knowledge.value
        clear_goal                = engagement_observation.goal.value
        narrative                 = engagement_observation.narrative.value
        obtain_commit             = engagement_observation.obtaining_commitment.value
        comm_level                = engagement_observation.communication.value
        doc_follow_up             = engagement_observation.documentation_followup.value
        
        rapport_chk               = rapport           == "1" ? filled_checkbox : empty_checkbox
        basic_knowledge_chk       = basic_knowledge   == "1" ? filled_checkbox : empty_checkbox
        clear_goal_chk            = clear_goal        == "1" ? filled_checkbox : empty_checkbox
        narrative_chk             = narrative         == "1" ? filled_checkbox : empty_checkbox
        obtain_commit_chk         = obtain_commit     == "1" ? filled_checkbox : empty_checkbox
        comm_level_chk            = comm_level        == "1" ? filled_checkbox : empty_checkbox
        doc_follow_up_chk         = doc_follow_up     == "1" ? filled_checkbox : empty_checkbox
        
        observation_score         = engagement_observation.score.value
        
        ob_teacher_comments       = engagement_observation.team_member_comments.value
        ob_evaluator_comments     = engagement_observation.supervisor_comments.value
        
        engagement_professionalism = @t.evaluation_engagement_professionalism
        
        address_parent            = engagement_professionalism.source_addresses_concerns.value
        team_collab               = engagement_professionalism.source_collaboration.value
        comm_prof                 = engagement_professionalism.source_communication.value
        att_event                 = engagement_professionalism.source_attends_events.value
        exec_engage               = engagement_professionalism.source_execution.value
        seek_prof_dev             = engagement_professionalism.source_professional_development.value
        active_valued             = engagement_professionalism.source_meeting_contributions.value
        timely_escalate           = engagement_professionalism.source_issue_escalation.value
        sti_lev_marked            = engagement_professionalism.source_sti.value
        meets_deadlines           = engagement_professionalism.source_meets_deadlines.value
        
        address_parent_chk        = address_parent    == "1" ? filled_checkbox : empty_checkbox
        team_collab_chk           = team_collab       == "1" ? filled_checkbox : empty_checkbox
        comm_prof_chk             = comm_prof         == "1" ? filled_checkbox : empty_checkbox
        att_event_chk             = att_event         == "1" ? filled_checkbox : empty_checkbox
        exec_engage_chk           = exec_engage       == "1" ? filled_checkbox : empty_checkbox
        seek_prof_dev_chk         = seek_prof_dev     == "1" ? filled_checkbox : empty_checkbox
        active_valued_chk         = active_valued     == "1" ? filled_checkbox : empty_checkbox
        timely_escalate_chk       = timely_escalate   == "1" ? filled_checkbox : empty_checkbox
        sti_lev_marked_chk        = sti_lev_marked    == "1" ? filled_checkbox : empty_checkbox
        meets_deadlines_chk       = meets_deadlines   == "1" ? filled_checkbox : empty_checkbox
 
        prof_score                     = engagement_professionalism.score.value
        
        prof_teacher_comments          = engagement_professionalism.team_member_comments.value
        prof_evaluator_comments        = engagement_professionalism.supervisor_comments.value
        
        overall_rating                 = engagement_professionalism.score.mathable + engagement_observation.score.mathable + engagement_metrics.score.mathable
        
        #METRICS
        metrics_sub_section1 = pdf.make_table [
            
            ["<b>1. Scantron Participation - Fall and Spring (0-10pts)</b>", "<b>Fall</b>", "<b>Spring</b>"],
            ["Scantron score is based on the number of students who completed the assessment from the number of total student on class list.", metrics_st_part_fall, metrics_st_part_spring]
        ],
        :column_widths => [350,35,35] do
            cells.style do |c|
                c.inline_format = true
                c.size = 6
                case c.column
                when 1,2
                    c.align = :center
                    c.valign = :center
                end
            end
        end
        
        metrics_sub_section2 = pdf.make_table [
            
            ["Comments:", metrics_st_part_comments],
            ["<b>2. Attendance in Virtual School (0-25pts)</b>\nAttendance score is based on the aggregated average attendance rate of all students on class list.",  metrics_att_vs],
            ["Comments:", metrics_att_vs_comments],
            ["<b>3. Dropout/Truancy Prevention (0-10pts)</b>\nRetention score is based on the number of students who are not withdrawn due to truancy or dropout from the total number of students on class list.", metrics_do_tp],
            ["Comments:", metrics_do_tp_comments],
            ["<b>4. PSSA and Keystone Participation Rate (0-10pts)</b>\nScore is based on percentage of students required to take state standardized tests who actually participate", metrics_pssa_part],
            ["Comments:", metrics_pssa_comments],
            ["<b>5. Quality Documentation (0-10pts)</b>\nScore is based on assessed thoroughness of documentation of student interactions", metrics_quality_doc],
            ["Comments:", metrics_quality_doc_comments],
            ["<b>6. Family and Peer Feedback (0-5pts)</b>\nScore is based on survey results of families and Agora colleagues with respect to levels of service and responsiveness.", metrics_fp_feedback],
            ["Comments:", metrics_fp_feedback_comments]
        ],
        :column_widths => [350,70] do
            cells.style do |c|
                c.inline_format = true
                c.size = 6
                case c.column
                when 1
                    c.align  = :center
                    c.valign = :center
                end
                case c.row
                when 0,1,3,5,9,11
                    c.height = 30
                when 2,4,6,8,10,12
                    c.height = 25
                end
            end
        end
        
        metrics_comments = pdf.make_table [
            ["Evaluator Comments: #{metrics_evaluator_comments}"],
            ["Overall Coach Comments On Metrics: #{metrics_coach_comments}"]
        ],
        :column_widths => [350] do
            cells.style do |c|
                c.inline_format = true
                c.size = 6
                c.height = 50
            end
        end
        
        metrics_comments_and_score = pdf.make_table [
            [metrics_comments, "Metrics Score:\n#{metrics_score}"]
        ],
        :column_widths => [350,70] do
            cells.style do |c|
                if c.column == 1
                    
                    c.inline_format=true
                    c.size=7
                    c.padding=3
                    c.valign=:center
                    c.align=:center
                    c.height = 50
                    
                end

            end
        end
        
        metrics_section = pdf.make_table([
                ["<b>Coach's performance appropriately demonstrates:</b>
• Monitor and support students' participation in Scantron Performance Series or other required assessments 
• Monitor and support students' daily attendance
• Ongoing efforts to keep Agora students in school and prevent dropouts
• Awareness of Tier 2 and 3-designated students and appropriate related actions
• Timely execution of engagement initiatives and related activities
• Completion of initial Home Visits with follow-up as required"],
                ["<b>Sources of Evidence:</b>
• Study Island Participation Report
• Scantron Participation Report
• Attendance Report
• Retention Report
• TV Notes
• Engagement initiative documentation"],
                [metrics_sub_section1],
                [metrics_sub_section2],
                [metrics_comments_and_score]
            ], :width=>420
        ) do
            cells.style do |c|
                
                case c.row
                    
                when 0,1
                    
                    c.background_color="DBF4FF"
                    c.size = 6
                    c.inline_format = true
                
                end
                
            end
            
        end
        
        pdf.line_width = 0.1
        
        #OBSERVATION
        observation_section = pdf.make_table [
            
            ["<b>Family Coach demonstrates during live interactions with students and families the competencies and traits required to build and grow relationships that enable academic achievement (See Observation Form)

Highlighted areas include:</b>
#{rapport_chk        } <u>Rapport</u> with the family – (leads to trust on the family's behalf)
#{basic_knowledge_chk} Basic <u>knowledge</u> when responding to questions, responses when information is not known
#{clear_goal_chk     } Clear <u>goal</u> of desired outcome of visit or call with student/family
#{narrative_chk      } <u>Narrative</u> – having a \"big picture\" conversation
#{obtain_commit_chk  } <u>Obtaining commitment</u> from the student/family
#{comm_level_chk     } <u>Communication</u> level – active listening, genuine interactions
#{doc_follow_up_chk  } <u>Documentation & Follow up</u>"],
            ["Coach Comments: #{ob_teacher_comments}"],
            ["Evaluator Comments: #{ob_evaluator_comments}"]    
        ], :width=>350, :column_widths=>[350] do
            
            cells.style do |c|
                
                c.size = 7
                c.inline_format = true
                
                case c.row
                    
                when 1,2
                    
                    c.height = 50
                    
                end
                
            end
            
        end
        
        #PROFESSIONALISM
        professionalism_section = pdf.make_table [
            
            ["<b>Family Coach's performance appropriately demonstrates indicates a spirit of teamwork, collaboration and interest in developing themselves.

Sources of Evidence:</b>
#{address_parent_chk }  Addresses parent concerns in a timely manner             
#{team_collab_chk    }  Team Collaboration                                                        
#{comm_prof_chk      }  Communication is professional(written and verbal)
#{att_event_chk      }  Attends required school events
#{exec_engage_chk    }  Execution of engagement efforts
#{seek_prof_dev_chk  }  Seeks and participates in individualized Prof Dev opportunities
#{active_valued_chk  }  Is an active and valued contributor in team meetings     
#{timely_escalate_chk}  Timely escalation of engagement issues
#{sti_lev_marked_chk }  STI / Level of Engagement marked
#{meets_deadlines_chk}  Consistently meets established timelines/deadlines"],
            ["Coach Comments: #{prof_teacher_comments}"],
            ["Evaluator Comments: #{prof_evaluator_comments}"]
            
        ], :width=>350, :column_widths=>[350] do
            
            cells.style do |c|
                
                c.size = 7
                c.inline_format = true
                
                case c.row
                    
                when 1,2
                    
                    c.height = 50
                    
                end
                
            end
            
        end
        
        pdf.table [
            
            ["Student Engagement and Related Metrics\n(0-70pts)",      metrics_section]
        ],
        :width         => 520,
        :position      => :center,
        :column_widths => [100,420] do
            
            cells.style do |c|
                
                if c.column==0
                    
                    c.inline_format=true
                    c.size=10
                    c.padding=3
                    c.valign=:center
                    c.align=:center
                    c.background_color="DBF4FF"
                    
                end
                
            end
            
        end
        
        store_cursor = pdf.cursor
        
        pdf.stroke_color "000000"
        pdf.fill_color "DBF4FF"
        pdf.line_width = 1
        pdf.fill_and_stroke_rectangle [10, pdf.cursor], 100, 100
        pdf.fill_color "000000"      
        
        em = @t.evaluation_engagement_metrics
        
        graph_deviation_from_norm(pdf, store_cursor)
        
        pdf.table [
            
            ["Observation\n(0-20pts)",                                 observation_section, "Observation Score:\n#{observation_score}"],
            ["Professionalism\n(0-10pts)",                             professionalism_section, "Professionalism Score:\n#{prof_score}"]
            
        ],
        :width         => 520,
        :position      => :center,
        :column_widths => [100,350,70] do
            
            cells.style do |c|
                
                if c.column==0
                    
                    c.inline_format=true
                    c.size=10
                    c.padding=3
                    c.valign=:center
                    c.align=:center
                    c.background_color="DBF4FF"
                    
                end
                
                if c.column==2
                   
                    c.inline_format=true
                    c.size=7
                    c.padding=3
                    c.valign=:center
                    c.align=:center
                    
                end
                
            end
            
        end
        
        #OVERALL SCORE
        pdf.table [
            
            ["Overall Score\n(0-100pts)", overall_rating]
            
        ],
        :width         => 520,
        :position      => :center,
        :column_widths => [450,70],
        :cell_style    => {
            :size             => 8,
            :inline_format    => true,
            :align            => :right,
            :background_color => "DBF4FF"
        }
        
        return pdf
        
    end
    
    def evaluation_table(pdf)
        
        #Evaluation
        pdf.table [
            
            ["Evaluation"]
            
        ],
        :width      =>520,
        :position   => :center,
        :cell_style => {
            :size             => 10,
            :padding          => 2,
            :align            => :center,
            :text_color       => "FFFFFF",
            :background_color => "000000"
        }
        
        pdf.table [
            
            ["<b>Area</b>","<b>Criteria</b>","<b>Score</b>"]
            
        ],
        :width         =>520,
        :position      => :center,
        :column_widths => [100,350,70],
        :cell_style    => {
            :size          => 10,
            :inline_format => true,
            :align         => :center,
            :padding       => 3
        }
        
        return pdf
        
    end
    
    def general_information(pdf)
        
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        
        employee_name       = @t.primary_id.to_name(:full_name)
        title               = ""
        academic_department = $tables.attach("DEPARTMENT").field_by_pid("name",@t.department_id.value).value
        evaluator           = @t.supervisor_team_id.to_name(:full_name)
        
        review_period       = "#{$school.current_school_year} School Year"
        
        #SCHOOL LOGO
        pdf.move_down 8
        pdf.image logo_path,
            :width  => 190,
            :height => 50,
            :position => :right
        
        pdf.move_down 10
        
        #Employee Information
        pdf.table [
            
            ["<b>Family Coach Performance Review</b>", {:content=>"Date: #{$iuser}", :align=>:right}]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size => 12,
            :inline_format => true,
            :borders => []
        }
        
        pdf.move_down 3
        
        pdf.table [
            
            ["Employee Information"]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size             => 10,
            :padding          => 2,
            :align            => :center,
            :text_color       => "FFFFFF",
            :background_color => "000000"
        }
        
        pdf.table [
            
            ["Employee Name:",          employee_name],
            ["Title:",                  title],
            ["Academic Team:",          academic_department],
            ["Program Support Coach:",  evaluator],
            ["Review Period:",          review_period]
            
        ],
        :width          => 520,
        :position       => :center,
        :column_widths  => [140, 380],
        :cell_style     => {
            :size    => 10,
            :padding => 2
        }
        
        pdf.move_down 25
        
        return pdf
        
    end
    
    def generate_confirmed_pdf(tid, pdf = nil)
        
        @t   = $team.get(tid)
        
        render_required = false
        if !pdf
            render_required = true
            file_name = "TEAMID_#{tid}_EVALUATION_#{$ifilestamp}.pdf"
            file_path = $paths.team_member_path(tid, sub_directory = "Evaluations") #correct this to include the team member document path
            pdf       = Prawn::Document.new
        end
        
        pdf.font_families.update("Arial" => {
            :normal      => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
            :italic      => "c:/windows/fonts/ariali.ttf",
            :bold        => "c:/windows/fonts/arialbd.ttf",
            :bold_italic => "c:/windows/fonts/arialbi.ttf"
        })
        
        pdf.font "Arial"
        
        pdf.fallback_fonts ["#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"]
        
        
        
        
        general_information(pdf)
        overall_performance_score(pdf)
        performance_score_summary(pdf)
        evaluation_table(pdf)
        evaluation(pdf)
        goals(pdf)
        verification_of_review(pdf)
        above_and_beyond(pdf)
        
        
        
        
        pdf.render_file "#{file_path}#{file_name}" if render_required
        
        return "#{file_path}#{file_name}"
        
    end
    
    def generate_pdf(tid, pdf = nil)
        
        @t   = $team.get(tid)
        
        a = @t.evaluation_engagement_professionalism.score.mathable   
        b = @t.evaluation_engagement_observation.score.mathable       
        c = @t.evaluation_engagement_metrics.score.mathable
        
        if (a && b && c)
            overall_score                       = a + b + c
            @t.evaluation_summary.score.set(overall_score).save
            generate_confirmed_pdf(tid, pdf)
            
        else
            
            if $kit
                
                additional_info = String.new
                
                additional_info << "Professionalism Score Missing! "  if !a
                additional_info << "Observation Score Missing! "      if !b
                additional_info << "Metrics Score Missing! "          if !c
                
                $kit.web_error.document_not_complete(additional_info)
                
            end
            
            return false
            
        end
        
    end
    
    def goals(pdf)
        
        evaluation_summary = @t.evaluation_summary
        
        goal1                          = evaluation_summary.goal_1.value
        goal2                          = evaluation_summary.goal_2.value
        goal3                          = evaluation_summary.goal_3.value
        
        pdf.table [
            
            ["Goals"]
            
        ],
        :width      =>520,
        :position   => :center,
        :cell_style => {
            :size             => 8,
            :inline_format    => true,
            :align            => :center,
            :text_color       => "FFFFFF",
            :background_color => "000000"
        }
        
        pdf.table [
            
            ["1. #{goal1}"],
            ["2. #{goal2}"],
            ["3. #{goal3}"]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size          => 8,
            :height        => 50,
            :inline_format => true
        }
        
        pdf.start_new_page
        
        return pdf
        
    end
    
    def overall_performance_score(pdf)
        
        overall_score = @t.evaluation_summary.score.mathable
        
        pdf.table [
            
            ["<b>Overall Performance Score Range</b>", "<b>Overall Score: #{overall_score}</b>"],
            
        ],
        :width    => 520,
        :column_widths => [400,120],
        :position => :center,
        :cell_style => {
            :padding=>4,
            :background_color=>"F0F0F0",
            :size => 10,
            :inline_format=>true
        }
        
        pdf.fill_color "F0F0F0"
        pdf.fill_and_stroke_rectangle [10, 485], 520, 32
        pdf.fill_color "000000"
        pdf.move_down 4
        
        key_colors  = ["FFC000", "FFFF00", "00B050", "00B0F0"]
        
        pdf.table [
            
                ["Unsatisfactory\n< 44", "Progressing\n45 - 67", "Proficient\n68 - 92", "Distinguished\n93 - 100"]
                
            ], :width=>500, :position=>:center, :column_widths=>[107,164,179,50] do
            #[220,115,125,40]
            cells.style( :size => 6, :height=> 24, :align=>:center, :padding=>3 )
            
            cells.style do |c|
                
                c.background_color = key_colors[c.column]
                
            end
        end
        
        if overall_score >= 45
            score_line = overall_score*7.14-214
        else
            p = overall_score.to_f/44
            score_line = (107*p).to_i
        end
        
        pdf.line_width = 2
        pdf.stroke_color = "898989"
        pdf.stroke_line [21+score_line, 454], [21+score_line, 484]
        
        pdf.move_down 25
        
        return pdf
        
    end
    
    def performance_score_summary(pdf)
        
        #PEER GROUP SUMMARY RECORD
        pgsr = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").by_peer_group_id(@t.peer_group_id.value, @t.department_id.value)
        
        #DEPARTMENT SUMMARY RECORD
        dsr = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").by_department_id(@t.department_id.value)
        
        evaluation_summary = @t.evaluation_summary
        
        avg_num_student_on_class_list                              = [evaluation_summary.students.value,                                dsr.fields["students"                        ].round,          pgsr.fields["students"                        ].round          ]
        percent_students_new_to_agora_this_year                    = [evaluation_summary.new.value,                                     dsr.fields["new"                             ].round,          pgsr.fields["new"                             ].round          ]
        percent_class_list_in_year_enrollments                     = [evaluation_summary.in_year.value,                                 dsr.fields["in_year"                         ].round,          pgsr.fields["in_year"                         ].round          ]
        percent_class_list_7_12                                    = [evaluation_summary.grades_712.value,                              dsr.fields["grades_712"                      ].round,          pgsr.fields["grades_712"                      ].round          ]
        percent_class_list_free_or_reduced_lunch_households        = [evaluation_summary.low_income.value,                              dsr.fields["low_income"                      ].round,          pgsr.fields["low_income"                      ].round          ]
        percent_class_list_identified_tier_2_3_academic_category   = [evaluation_summary.tier_23.value,                                 dsr.fields["tier_23"                         ].round,          pgsr.fields["tier_23"                         ].round          ]
        percent_class_list_speced                                  = [evaluation_summary.special_ed.value,                              dsr.fields["special_ed"                      ].round,          pgsr.fields["special_ed"                      ].round          ]
        student_att_rate                                           = [evaluation_summary.attendance_rate.value,                         dsr.fields["attendance_rate"                 ].round,          pgsr.fields["attendance_rate"                 ].round          ]
        student_ret_rate                                           = [evaluation_summary.retention_rate.value,                          dsr.fields["retention_rate"                  ].round,          pgsr.fields["retention_rate"                  ].round          ]
        scantron_perf_participation_fall                           = [evaluation_summary.scantron_participation_fall.value,             dsr.fields["scantron_participation_fall"     ].round,          pgsr.fields["scantron_participation_fall"     ].round          ]
        scantron_perf_participation_spring                         = [evaluation_summary.scantron_participation_spring.value,           dsr.fields["scantron_participation_spring"   ].round,          pgsr.fields["scantron_participation_spring"   ].round          ]
        define_u_participation                                     = [evaluation_summary.define_u_participation.value,                  dsr.fields["define_u_participation"          ].round,          pgsr.fields["define_u_participation"          ].round          ]
        pssa_participation                                         = [evaluation_summary.pssa_participation.value,                      dsr.fields["pssa_participation"              ].round,          pgsr.fields["pssa_participation"              ].round          ]
        keystone_participation                                     = [evaluation_summary.keystone_participation.value,                  dsr.fields["keystone_participation"          ].round,          pgsr.fields["keystone_participation"          ].round          ]
        
        #Performance Score
        pdf.table [
            
            ["<b>Summary and Benchmark Data - Information Only</b>"]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size             => 10,
            :inline_format    => true,
            :align            => :center,
            :padding          => 3,
            :background_color => "FFFF00"
        }
        
        pdf.table [
            
            ["<b>Data Category</b>","<b>Individual</b>","<b>Department\nAverage</b>","<b>Peer Group\nAverage</b>"]
            
        ],
        :width         => 520,
        :position      => :center,
        :column_widths => [295, 75, 75, 75],
        :cell_style    => {
            :size             => 10,
            :inline_format    => true,
            :align            => :center,
            :valign           => :center,
            :padding          => 10,
            :background_color => "00B050"
        }
        
        pdf.table [
            
            ["Current # Student on Class List",                                    avg_num_student_on_class_list[0]                           ,avg_num_student_on_class_list[1]                              ,avg_num_student_on_class_list[2]                            ],
            ["% Students New to Agora This Year",                                  percent_students_new_to_agora_this_year[0]                 ,percent_students_new_to_agora_this_year[1]                    ,percent_students_new_to_agora_this_year[2]                  ],
            ["% Class List From In-Year Enrollments",                              percent_class_list_in_year_enrollments[0]                  ,percent_class_list_in_year_enrollments[1]                     ,percent_class_list_in_year_enrollments[2]                   ],
            ["% Class List in Grades 7-12",                                        percent_class_list_7_12[0]                                 ,percent_class_list_7_12[1]                                    ,percent_class_list_7_12[2]                   ],
            ["% Class List From Free or Reduced Lunch Households",                 percent_class_list_free_or_reduced_lunch_households[0]     ,percent_class_list_free_or_reduced_lunch_households[1]        ,percent_class_list_free_or_reduced_lunch_households[2]      ],
            ["% Class List Identified as Tier 2 - 3 Academic Category",            percent_class_list_identified_tier_2_3_academic_category[0],percent_class_list_identified_tier_2_3_academic_category[1]   ,percent_class_list_identified_tier_2_3_academic_category[2] ],
            ["% Class List In Special Education",                                  percent_class_list_speced[0]                               ,percent_class_list_speced[1]                                  ,percent_class_list_speced[2]                                ],
            
            
            ["Student Attendance Rate",                                            student_att_rate[0]                                        ,student_att_rate[1]                                           ,student_att_rate[2]                                         ],
            ["Student Retention Rate",                                             student_ret_rate[0]                                        ,student_ret_rate[1]                                           ,student_ret_rate[2]                                         ],
            ["Scantron / Assessment Participation Rate- Fall",                     scantron_perf_participation_fall[0]                        ,scantron_perf_participation_fall[1]                           ,scantron_perf_participation_fall[2]                         ],
            ["Scantron / Assessment Participation Rate- Spring",                   scantron_perf_participation_spring[0]                      ,scantron_perf_participation_spring[1]                         ,scantron_perf_participation_spring[2]                       ],
            ["Define U Participation Rate",                                        define_u_participation[0]                                  ,define_u_participation[1]                                     ,define_u_participation[2]                                   ],
            ["PSSA Participation Rate (In Eligible Grades)",                       pssa_participation[0]                                      ,pssa_participation[1]                                         ,pssa_participation[2]                                       ],
            ["Keystone Participation Rate (In Eligible Grades)",                   keystone_participation[0]                                  ,keystone_participation[1]                                     ,keystone_participation[2]                                   ],
            
        ],
        :width         =>520,
        :position      =>:center,
        :column_widths => [295, 75, 75, 75],
        :cell_style    => {
            :size    => 8,
            :padding => 4
        }
        
        pdf.start_new_page
        
        return pdf
        
    end
    
    def verification_of_review(pdf)
        
        pdf.table [
            
            ["Verification of Review"]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size             => 8,
            :inline_format    => true,
            :align            => :center,
            :text_color       => "FFFFFF",
            :background_color => "000000"
        }

        pdf.table [
            
            ["By signing this form, you confirm that you have discussed this review in detail with the evaluator. Signing this form does not necessarily indicate that you agree with this evaluation."]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size          => 8,
            :inline_format => true
        }

        pdf.table [
            
            ["Employee's Signature",     "Date"],
            ["",""],
            ["Evaluator's Signature",    "Date"],
            ["",""],
            ["Head Of School Signature", "Date"],
            ["",""]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size          => 8,
            :inline_format => true,
            :height        => 20
        } do
            cells.style do |c|
                
                case c.row
                    
                when 0,2,4
                    
                    c.background_color="a1bdc7"
                    
                end
                
            end
            
        end          
        
        pdf.move_down 20
        
        return pdf
        
    end
    
end

def graph_deviation_from_norm(pdf, cursor_position)
    
    
    #(pdf, [
    #    ["1", em.scantron_participation.deviation_from_peer_group_norm   ],
    #    ["2", em.attendance.deviation_from_peer_group_norm               ],
    #    ["3", em.truancy_prevention.deviation_from_peer_group_norm       ],
    #    ["4", em.evaluation_participation.deviation_from_peer_group_norm ],
    #    ["5", em.quality_documentation.deviation_from_peer_group_norm    ],
    #    ["6", em.feedback.deviation_from_peer_group_norm                 ]
    #], 110, store_cursor)
    
    scale_height   = 60
    scale_width    = 402
    scale_padding  = [10,30,9,9] #tblr
    section_width  = scale_width/6
    
    pdf.bounding_box([110,cursor_position], :width=>scale_width+scale_padding[2]+scale_padding[3], :height=>scale_height+scale_padding[0]+scale_padding[1]) do
        
        pdf.stroke_color "000000"
        pdf.line_width = 1
        
        pdf.stroke_bounds
        
        pdf.stroke do
            
            pdf.stroke_color "000000"
            
            pdf.vertical_line   scale_padding[1], scale_height + scale_padding[1], :at=> scale_padding[2]
            pdf.horizontal_line scale_padding[0], scale_width  + scale_padding[0], :at=> scale_padding[1]
            
        end
        
        pdf.stroke_color "000000"
        pdf.line_width = 1
        
        pdf.move_down scale_height + scale_padding[0]
        pdf.table [
            ["< -2 SD",        "< -1 SD",     "Within 1 SD", "> +1 SD"],
            ["Unsatisfactory", "Progressing", "Proficient",  "Distinguished"]
        ],
        #:width      =>400,
        :position   =>scale_padding[2],
        :column_widths => [section_width, section_width, section_width*2, section_width*2],
        :cell_style => {
            :size     => 6,
            :height   => 10,
            :padding  => 0,
            :align    =>:center
        }
        
        pdf.stroke do
            
            pdf.stroke_color "000000"
            
            pdf.move_to scale_padding[2],scale_padding[1]
            
            center = (scale_width/2)+scale_padding[2]
            
            curve_height = scale_height*0.95 + scale_padding[1]
            
            pdf.curve_to [center, curve_height],                                :bounds => [[scale_padding[2]+140,scale_padding[1]],[center - 60, curve_height]]
            
            pdf.curve_to [scale_width + scale_padding[2], scale_padding[1] ],   :bounds => [[center + 60, curve_height],[scale_padding[2]+scale_width-140,scale_padding[1]]]
            
        end
        
        pdf.stroke do
            
            pdf.stroke_color "0077DD"
            
            data_points = Array.new
            
            scantron    = @t.evaluation_summary.scantron_participation_fall.deviation_from_peer_group_norm
            data_points.push(["1", scantron     ]) if scantron
            
            attendance  = @t.evaluation_summary.attendance_rate.deviation_from_peer_group_norm              
            data_points.push(["2", attendance   ]) if attendance
            
            retention   = @t.evaluation_summary.retention_rate.deviation_from_peer_group_norm               
            data_points.push(["3", retention    ]) if retention
            
            state_test  = @t.evaluation_summary.state_test_participation.deviation_from_peer_group_norm       
            data_points.push(["4", state_test   ]) if state_test
            
            data_points.sort!{|x,y|x.last<=>y.last}.each_with_index do |plot, i|
                
                if plot[1] < -2.95
                    plot[1] = -2.95
                elsif plot[1] > 2.95
                    plot[1] = 2.95
                end
                
                plot[1] += 3
                
                x = (plot.last.to_f)*section_width + scale_padding[2]
                
                y_top = (scale_height+scale_padding[1])*0.9
                
                pdf.line_width = 2

                pdf.vertical_line scale_padding[1], y_top-i*8, :at=>x
                
                pdf.bounding_box [x, y_top-(i*8)], :width => 10, :height=>8, :margin=>1 do
                    
                    pdf.line_width = 1
                    pdf.stroke_bounds
                    pdf.text plot.first, :size => 6, :align => :center, :valign => :center, :color=>"0077DD"
                
                end
                
            end
            
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "FF0000"
            pdf.fill_rectangle [(section_width*2)+scale_padding[2], scale_height+scale_padding[1]], (section_width*2), scale_height
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "00FF00"
            pdf.fill_rectangle [section_width   + scale_padding[2], scale_height+scale_padding[1]], section_width, scale_height
            pdf.fill_rectangle [section_width*4 + scale_padding[2], scale_height+scale_padding[1]], section_width, scale_height
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "00ADEE"
            pdf.fill_rectangle [0 + scale_padding[2], scale_height+scale_padding[1]], section_width, scale_height
            pdf.fill_rectangle [section_width*5 + scale_padding[2], scale_height+scale_padding[1]], section_width, scale_height
        end
        
        #pdf.stroke do
        #    pdf.stroke_color "E8272C"
        #    pdf.line_width = 1
        #    
        #    pdf.vertical_line scale_padding[1], scale_height+scale_padding[1], :at=> section_width*3 + scale_padding[2] 
        #end
        
        pdf.stroke_color "000000"
        
    end

end


def graph_bak(pdf)
    
    plot_data = [["A",0],["B",0.5],["C",0.9],["D",1]]
    
    #data = Array.new
    #(1..100).each do |x|
    #    data.push(rand(100))
    #end
    
    #data = ["1", "1", "0", "0", "0.75"]
    
    data = sample_array
    #data = data.delete_if {|x| x == "0"}
    #data = data.delete_if {|x| x == "0.5"}
    
    mean  = $base.mean(data)
    sd    = $base.standard_deviation(data)
    
    #m = mean
    #sds = sd
    m   = (mean.to_f*1000).round.to_f/10
    sds = (sd.to_f*1000).round.to_f/10
    #m   = (mean.to_f*100).round.to_f
    #sds = (sd.to_f*100).round.to_f
    scale_scale = 100.0/(sds*6)
    
    scale_height   = 100
    scale_width    = 400
    scale_padding  = 10
    scale_offset   = 10
    
    vertical_inc   = 0.1
    horizontal_inc = 4*scale_scale
    vertical_scale = 5
    
    #vertical_inc   = 20
    #horizontal_inc = 4*scale_scale
    #vertical_scale = 5
    
        
    deviation_offset = m*horizontal_inc - scale_width/2
    
    dataHash = Hash.new(0)
    
    data.each do |v|
        percent = (v.to_f*1000).round.to_f/10
        dataHash[percent] += 1
        #dataHash[v] += 1
    end
    
    sortedData = dataHash.sort
    
    pdf.bounding_box([50,pdf.cursor], :width=>scale_width+scale_padding*2, :height=>scale_height+scale_padding*2) do
        
        pdf.stroke_color "000000"
        pdf.line_width = 1
        
        pdf.stroke_bounds
        
        pdf.stroke do
            
            pdf.stroke_color "000000"
            
            pdf.vertical_line   scale_offset, scale_height+scale_padding, :at=> scale_offset
            pdf.horizontal_line scale_offset, scale_width+scale_padding, :at=> scale_offset
            
        #    (0..30).each do |x|
        #        
        #        pdf.horizontal_line 20, 25,  :at=>x*vertical_scale + scale_offset
        #        
        #    end
            
        end
        
        pdf.stroke do
            
            pdf.stroke_color "000000"
            
            pdf.move_to scale_offset,scale_offset
            
            pdf.curve_to [m*horizontal_inc + scale_offset - deviation_offset, scale_height*0.9], :bounds => [[scale_offset+150,scale_offset+5],[m*horizontal_inc + scale_offset - deviation_offset - 65, scale_height*0.9]]
            
            pdf.curve_to [scale_width + scale_offset, scale_offset ],                           :bounds => [[m*horizontal_inc + scale_offset - deviation_offset + 75, scale_height*0.9],[scale_offset+scale_width-150,scale_offset+5]]
            
        end
        
        #pdf.stroke do
        #    
        #    pdf.stroke_color "0077DD"
        #    pdf.line_width = 0.5
        #    
        #    sortedData.each do |x|
        #        
        #        if x.first >= m-sds*3 && x.first <= m+sds*3
        #            pdf.vertical_line   scale_offset, (x.last*vertical_inc) + scale_offset, :at=>x.first*horizontal_inc + scale_offset+1 - deviation_offset
        #        end
        #        
        #        
        #    end
        #    
        #end
        
        pdf.stroke do
            
            pdf.stroke_color "0077DD"
            pdf.line_width = 0.5
            
            plot_data.each do |plot|
                conv_val = (plot.last.to_f*1000).round.to_f/10
            
                if conv_val <=m-sds*3
                    conv_val = m-sds*3
                end
                if conv_val >=m+sds*3
                    conv_val = m+sds*3
                end
                pdf.vertical_line scale_offset, scale_height+scale_offset+20, :at=>conv_val*horizontal_inc + scale_offset -  deviation_offset
            end
            
        #    
        #    sortedData.each do |x|
        #        
        #        if x.first >= m-sds*3 && x.first <= m+sds*3
        #            pdf.vertical_line   scale_offset, (x.last*vertical_inc) + scale_offset, :at=>x.first*horizontal_inc + scale_offset+1 - deviation_offset
        #        end
        #        
        #        
        #    end
        #    
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "FF0000"
            pdf.fill_rectangle [(m-sds)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc*2), scale_height
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "00FF00"
            pdf.fill_rectangle [(m-sds*2)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc), scale_height
            pdf.fill_rectangle [(m+sds)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc), scale_height
        end
        
        pdf.transparent(0.25) do
            pdf.fill_color "00ADEE"
            pdf.fill_rectangle [(m-sds*3)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc), scale_height
            pdf.fill_rectangle [(m+sds*2)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc), scale_height
        end
        
        pdf.stroke do
            
            pdf.stroke_color "E8272C"
            pdf.line_width = 1
            
            pdf.vertical_line scale_offset, scale_height+scale_padding, :at=> m*horizontal_inc      + scale_offset - deviation_offset
        end
        
        #pdf.stroke do
        #    pdf.stroke_color "FAFF72"
        #    pdf.vertical_line scale_offset, 175, :at=>(m+sds)*horizontal_inc + scale_offset -  deviation_offset
        #    pdf.vertical_line scale_offset, 175, :at=>(m-sds)*horizontal_inc + scale_offset -  deviation_offset
        #end
        #
        #pdf.stroke do
        #    pdf.stroke_color "#46937D"
        #    pdf.vertical_line scale_offset, 175, :at=>(m+sds*2)*horizontal_inc + scale_offset - deviation_offset
        #    pdf.vertical_line scale_offset, 175, :at=>(m-sds*2)*horizontal_inc + scale_offset - deviation_offset
        #end
        
        pdf.stroke_color "000000"
        pdf.line_width = 1
        
        pdf.move_down 175
        pdf.table [
            ["< -2 SD",        "< -1 SD",     "Within 1 SD", "> +1 SD"],
            ["Unsatisfactory", "Progressing", "Proficient",  "Distinguished"]
        ],
        :width      =>400,
        :position   =>25,
        :column_widths => [67,67,133,133],
        :cell_style => {
            :size     => 6,
            :padding  => 2,
            :align    =>:center
        }
        
    end

end
EVALUATION_PDF_FAMILY_COACH.new.generate_pdf("17",nil)