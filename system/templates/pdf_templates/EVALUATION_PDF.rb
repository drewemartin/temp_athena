#!/usr/local/bin/ruby
require "prawn"

class EVALUATION_PDF

    #---------------------------------------------------------------------------
    def initialize()
        
        @t = nil
        
    end
    #---------------------------------------------------------------------------
    
    def generate_pdf(tid, evaluation_type, pdf = nil)
        
        @t  = $team.get(tid)
        a   = nil
        b   = nil
        c   = nil
        
        case evaluation_type
            
        when "Engagement"
            
            pid = @t.evaluation_engagement_metrics.primary_id.value
            record = $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS").by_primary_id(pid)
            fields = record.fields
            total = 0.0
            
            field_names = [
                "scantron_participation_fall",
                "scantron_participation_spring",
                "attendance",
                "truancy_prevention",
                "keystone_participation",
                "pssa_participation",
                "quality_documentation",
                "feedback"
            ]
            
            field_names.each do |name|
                
                if field_val = fields[name].value
                    
                    total += field_val.to_f
                    
                end
                
            end
            
            fields["score"].value = total
            record.save
            
            a = @t.evaluation_engagement_professionalism.score.mathable
            b = @t.evaluation_engagement_observation.score.mathable
            c = @t.evaluation_engagement_metrics.score.mathable
            
        when "Elementary"
            
            a = @t.evaluation_academic_professionalism.score.mathable
            b = @t.evaluation_academic_instruction.score.mathable
            c = @t.evaluation_academic_metrics.score.mathable
            
        when "Middle School"
            
            a = @t.evaluation_academic_professionalism.score.mathable
            b = @t.evaluation_academic_instruction.score.mathable
            c = @t.evaluation_academic_metrics.score.mathable
            
        end
        
        if (a && b && c)
            
            overall_score                       = a + b + c
            @t.evaluation_summary.score.set(overall_score).save
            generate_confirmed_pdf(tid, evaluation_type, pdf)
            
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
    
    def generate_confirmed_pdf(tid, evaluation_type, pdf = nil)
        
        @t   = $team.get(tid)
        
        render_required = false
        
        if !pdf
            
            render_required = true
            file_name       = "TEAMID_#{tid}_EVALUATION_#{$ifilestamp}.pdf"
            file_path       = $paths.team_member_path(tid, sub_directory = "Evaluations") #correct this to include the team member document path
            pdf             = Prawn::Document.new
            
        end
        
        generic_evaluation(pdf, evaluation_type)
        
        pdf.render_file "#{file_path}#{file_name}" if render_required
        
        return "#{file_path}#{file_name}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________GENERAL_TEMPLATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def above_and_beyond(pdf, aab)
        
        pdf.table [
            
            ["Above and Beyond
Team Member has participated in additional duties beyond his/her job description that contributes to the operation, growth and positive climate of our school."],
            ["Sources of Evidence:
#{aab.source_mentoring               && aab.source_mentoring.is_true?               ? checkbox_filled : checkbox_empty  } Mentoring
#{aab.source_recruitment_team        && aab.source_recruitment_team.is_true?        ? checkbox_filled : checkbox_empty  } During the Year Recruitment Team
#{aab.source_committee               && aab.source_committee.is_true?               ? checkbox_filled : checkbox_empty  } Committee Work
#{aab.source_testing                 && aab.source_testing.is_true?                 ? checkbox_filled : checkbox_empty  } Testing
#{aab.source_after_hours             && aab.source_after_hours.is_true?             ? checkbox_filled : checkbox_empty  } After Hours Sessions with parents/students
#{aab.source_leading_pd              && aab.source_leading_pd.is_true?              ? checkbox_filled : checkbox_empty  } Leading Professional Development
#{aab.source_program_admin           && aab.source_program_admin.is_true?           ? checkbox_filled : checkbox_empty  } Program Administrator/expert 
#{aab.source_local_club              && aab.source_local_club.is_true?              ? checkbox_filled : checkbox_empty  } LOCAL Club Advisor
#{aab.source_subsitute_no_pay        && aab.source_subsitute_no_pay.is_true?        ? checkbox_filled : checkbox_empty  } Substituting (Without compensation) 
#{aab.source_parent_training         && aab.source_parent_training.is_true?         ? checkbox_filled : checkbox_empty  } Parent trainings outside normal work hours              
#{aab.source_distinguished_aims      && aab.source_distinguished_aims.is_true?      ? checkbox_filled : checkbox_empty  } Distinguished AIMS Web participation              
#{aab.source_distinguished_define_u  && aab.source_distinguished_define_u.is_true?  ? checkbox_filled : checkbox_empty  } Distinguished Define U attendance              
#{aab.source_other                   && aab.source_other.value                      ? checkbox_filled : checkbox_empty  } Other – Please describe here: #{aab.source_other ? aab.source_other.value : ""}"],
            
            [comments(pdf, aab.team_member_comments.value,  type="team", 520)],
            [comments(pdf, aab.supervisor_comments.value,   type="eval", 520)]
            
        ],
        :width      =>520,
        :position   => :center do
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.background_color = "DBF4FF"
                    c.size = 8
                    c.inline_format = true
                    
                when 1
                    
                    c.size = 8
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return pdf
    end
    
    def comments(pdf, comments, type="team", col_width=420)
        
        header = String.new
        
        case type
        when "team"
            
            header = "Team Member Comments:"
            
        when "eval"
            
            header = "Evaluator Comments:"
            
        end
        
        comment_box = pdf.make_table([
            
            [header, ""],
            [comments, {:image=>blank, :image_height=>36}]
            
        ], :column_widths=>[col_width,0],
           :cell_style => {:border_width=>0.1}
           
        ) do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.height = 14
                    c.padding = 2
                    c.size = 7
                    c.inline_format = true
                    
                when 1
                    
                    c.size = 7 if c.column == 0
                    
                end
                
            end
            
        end
        
        return comment_box
        
    end
    
    def employee_information_section(pdf, eval_title)
        
        employee_name       = @t.primary_id.to_name(:full_name)
        title               = @t.title.value
        department          = $tables.attach("DEPARTMENT").field_by_department_id("name", @t.department_id.value).value
        case @t.department_id.value.to_i
        when 2,3,5,6
            supervisor      = $tables.attach("DEPARTMENT").field_by_department_id("head_team_id", @t.department_id.value).to_name(:full_name)
        when 4
            supervisor      = @t.supervisor_team_id.to_name(:full_name)
        end
        
        
        review_period       = "#{$school.current_school_year} School Year"
        
        pdf.table [
            
            ["<b>#{eval_title}</b>", {:content=>"Date: #{$iuser}", :align=>:right}]
            
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
            ["Department:",             department],
            ["Supervisor:",             supervisor],
            ["Review Period:",          review_period]
            
        ],
        :width          => 520,
        :position       => :center,
        :column_widths  => [140, 380],
        :cell_style     => {
            :size    => 10,
            :padding => 2
        }
        
        return pdf
        
    end

    def generic_evaluation(pdf, type)
        
        set_fonts(pdf)
        
        evaluation_summary               = @t.evaluation_summary
        evaluation_metrics_data          = nil
        evaluation_professionalism_data  = nil
        evaluation_observation_data      = nil
        evaluation_summary_table         = Array.new
        evaluation_title                 = String.new
        evaluation_sections              = Array.new
        overall_score                    = evaluation_summary.score.mathable
        evaluation_above_and_beyond      = nil
        
        case type
        when "Engagement"
            
            evaluation_metrics_data          = @t.evaluation_engagement_metrics
            evaluation_professionalism_data  = @t.evaluation_engagement_professionalism
            evaluation_observation_data      = @t.evaluation_engagement_observation
            evaluation_title                 = "Family Coach Performance Review"
            evaluation_summary_table         = engagement_summary_data_array
            evaluation_sections              = [
                "evaluation_engagement_metrics_section(pdf)",
                "evaluation_engagement_observation_section(pdf)",
                "evaluation_engagement_professionalism_section(pdf)"
            ]
            
        when "Elementary"
            
            evaluation_metrics_data          = @t.evaluation_academic_metrics
            evaluation_professionalism_data  = @t.evaluation_academic_professionalism
            evaluation_observation_data      = @t.evaluation_academic_instruction
            evaluation_title                 = "Elementary Program Performance Review"
            evaluation_summary_table         = academic_summary_data_array
            evaluation_sections              = [
                "evaluation_academic_instruction_section(pdf)",
                "evaluation_academic_metrics_section(pdf)",
                "evaluation_academic_professionalism_section(pdf)" 
            ]
            
        when "Middle School"
            
            evaluation_metrics_data          = @t.evaluation_academic_metrics
            evaluation_professionalism_data  = @t.evaluation_academic_professionalism
            evaluation_observation_data      = @t.evaluation_academic_instruction
            evaluation_title                 = "Middle School General Education Teacher Performance Review"
            evaluation_summary_table         = academic_summary_data_array
            evaluation_sections              = [
                "evaluation_academic_instruction_section(pdf)",
                "evaluation_academic_ms_metrics_section(pdf)",
                "evaluation_academic_professionalism_section(pdf)" 
            ]
            
        end
        
        pdf.move_down 8
        
        agora_logo(pdf)
        
        pdf.move_down 10
        
        employee_information_section(pdf, evaluation_title)
        
        pdf.move_down 25
        
        overall_performance_score_range(pdf, overall_score)
        
        pdf.move_down 25
        
        summary_benchmark_data_section(pdf, evaluation_summary_table)
        
        pdf.start_new_page
        
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
        
        evaluation_sections.each do |section|
            
            eval(section)
            
        end
        
        overall_score_section(pdf, overall_score)
        
        goals_section(pdf, evaluation_summary)
        
        pdf.start_new_page
        
        verification_of_review_section(pdf)
        
        pdf.move_down 20
        
        above_and_beyond(pdf, @t.evaluation_aab)
        
        pdf.move_down 20
        
        return pdf
        
    end
    
    def goals_section(pdf, evaluation_summary)
        
        goal_1  = evaluation_summary.goal_1.value
        goal_2  = evaluation_summary.goal_2.value
        goal_3  = evaluation_summary.goal_3.value
        
        team_comments  = evaluation_summary.team_member_comments.value
        eval_comments  = evaluation_summary.supervisor_comments.value
        
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
        
        pdf.table([
            
            ["1.", ""],
            [goal_1, {:image=>blank, :image_height=>36}],
            ["2.", ""],
            [goal_2, {:image=>blank, :image_height=>36}],
            ["3.", ""],
            [goal_3, {:image=>blank, :image_height=>36}],
            [comments(pdf, team_comments, type="team", 520)],
            [comments(pdf, eval_comments, type="eval", 520)]
            
        ], :position      => :center,
           :column_widths => [520,0],
           :cell_style    => {:border_width=>1}
           
        ) do
            
            cells.style do |c|
                
                case c.row
                    
                when 0,2,4
                    
                    c.height = 14
                    c.padding = 2
                    c.size = 7
                    c.inline_format = true
                    
                when 1,3,5
                    
                    c.size = 7 if c.column == 0
                    
                end
                
            end
            
        end
        
        return pdf
        
    end
    
    def overall_performance_score_range(pdf, overall_score)
        
        pdf.table [
            
            ["<b>Overall Performance Score Range</b>", "<b>Overall Score: #{overall_score}</b>"],
            
        ],
        :width          => 520,
        :column_widths  => [400,120],
        :position       => :center,
        :cell_style     => {
            :padding            => 4,
            :background_color   => "F0F0F0",
            :size               => 10,
            :inline_format      => true
        }
        
        pdf.fill_color "F0F0F0"
        pdf.fill_and_stroke_rectangle [10, 485], 520, 32
        pdf.fill_color "000000"
        pdf.move_down 4
        
        key_colors  = ["FFC000", "FFFF00", "00B050", "00B0F0"]
        
        pdf.table [
                
                ["Unsatisfactory\n< 44", "Progressing\n45 - 67", "Proficient\n68 - 89", "Distinguished\n90 - 100"]
                
            ], :width=>500, :position=>:center, :column_widths=>[107,164,157,72] do
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
        
        return pdf
        
    end
    
    def overall_score_section(pdf, overall_score)
        
        pdf.table [
            
            ["Overall Score\n(0-100pts)", overall_score]
            
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
        
    end
    
    def summary_benchmark_data_section(pdf, table_data_array)
        
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
        
        pdf.table table_data_array,
        :width         =>520,
        :position      =>:center,
        :column_widths => [295, 75, 75, 75],
        :cell_style    => {
            :size    => 8,
            :padding => 4,
        } do
            cells.style do |c|
                
                case c.column
                    
                when 1,2,3
                    
                    c.align   = :center
                    
                end
                
            end
            
        end    
        
        return pdf
        
    end
        
    def verification_of_review_section(pdf)
        
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
        
        return pdf
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACADEMIC_ELEMENTARY_SPECIFIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def evaluation_academic_instruction_section(pdf)
        
        pdf.table [
            
            ["Instruction\n(40%)",      academic_instruction_sub_section(pdf)]
            
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
        
        return pdf
        
    end
    
    def academic_instruction_sub_section(pdf)
        
        academic_instruction           = @t.evaluation_academic_instruction
        
        co_chk                         = academic_instruction.source_comprehensive_observation.value == "1" ? checkbox_filled : checkbox_empty
        lr_chk                         = academic_instruction.source_lesson_recordings.value         == "1" ? checkbox_filled : checkbox_empty
        uo_chk                         = academic_instruction.source_unannounced_observation.value   == "1" ? checkbox_filled : checkbox_empty
        
        inst_score                     = academic_instruction.score.value
        
        inst_dist_chk                  = inst_score == "40.00" ? checkbox_filled : checkbox_empty
        inst_prof_chk                  = inst_score == "30.00" ? checkbox_filled : checkbox_empty
        inst_prog_chk                  = inst_score == "20.00" ? checkbox_filled : checkbox_empty
        inst_unsat_chk                 = inst_score == "10.00" ? checkbox_filled : checkbox_empty
        
        inst_teacher_comments          = academic_instruction.team_member_comments.value
        inst_evaluator_comments        = academic_instruction.supervisor_comments.value
        
        instruction_sub_section = pdf.make_table [
            
            ["<b>Distinguished</b>\nThe team member demonstrates exemplary, innovative instruction which leads to maximized student mastery and can be used as a model for the staff.", "#{inst_dist_chk} 40"],
            ["<b>Proficient</b>\nThe team member demonstrates consistent application of effective instruction which leads to significant student mastery.",                             "#{inst_prof_chk} 30"],
            ["<b>Progressing</b>\nThe team member demonstrates emergent skills with some areas needing improvement. Student mastery is limited.",                                       "#{inst_prog_chk} 20"],
            ["<b>Unsatisfactory</b>\nThe team member requires significant improvement in order for the lesson to be effective.",                                                        "#{inst_unsat_chk} 10"]
                
        ],
        :column_widths => [370,50] do
            cells.style do |c|
                c.inline_format = true
                c.height        = 35
                case c.column
                when 0
                    c.size = 7
                when 1
                    c.size = 12
                    c.align = :center
                    c.valign = :center
                end
            end
        end
        
        instruction_section = pdf.make_table([
                ["<b>Research based instructional strategies are implemented and delivered effectively.
Observations conducted Fall/Winter/Spring.

Team member's  performance demonstrates effective instruction through:</b>
• Communication with Students
• Explicit Instruction (Mini-Lesson)
• Guided Practice
• Assessment
• Demonstrating Responsiveness"],
                ["<b>Sources of evidence:</b>
#{co_chk}  Comprehensive Observations
#{lr_chk}  Lesson Recordings
#{uo_chk}  Unannounced Observations"],
                [instruction_sub_section],
                [comments(pdf, inst_teacher_comments,   type="team")],
                [comments(pdf, inst_evaluator_comments, type="eval")]
            ], :width=>420
        ) do
            cells.style do |c|
                
                case c.row
                    
                when 0,1
                    
                    c.background_color="DBF4FF"
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return instruction_section
        
    end
    
    def evaluation_academic_metrics_section(pdf)
        
        pdf.table [
            
            ["Metrics\n(40%)",          academic_metrics_sub_section(pdf)]
            
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
        
        graph_deviation_from_norm(pdf)
        
        return pdf
        
    end
    
    def academic_metrics_sub_section(pdf)
        
        academic_metrics               = @t.evaluation_academic_metrics
        
        metrics_soe_chk                = academic_metrics.source_data.value == "1" ? checkbox_filled : checkbox_empty
        
        metrics_a                      = academic_metrics.assessment_performance.value
        metrics_b                      = (academic_metrics.assessment_participation_fall.mathable || 0) + (academic_metrics.assessment_participation_spring.mathable || 0)
        metrics_c                      = academic_metrics.study_island_achievement.value
        metrics_d                      = academic_metrics.study_island_participation.value
        metrics_overall                = academic_metrics.score.value
        
        metrics_evaluator_comments     = academic_metrics.team_member_comments.value
        metrics_supervisor_comments    = academic_metrics.supervisor_comments.value
        
        metrics_scale_p1 = pdf.make_table [
            
            ["<b>Unsatisfactory:</b>\n<-2 SD = 2.5 pts", "<b>Progressing:</b>\n<-1 SD = 5 pts", "<b>Proficient:</b>\nWithin (+/-) 1 SD = 7.5 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }
        
        metrics_scale_p2 = pdf.make_table [
            
            ["<b>Distinguished:</b>\n>+1 SD = 10 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }

        
        metrics_points_sub_section = pdf.make_table [
            
            ["<b>1. Scantron Performance and AIMSweb Achievement/Growth</b>\nGrowth is based on standard deviation from your peer group's mean (SD).", "Category 1 Points:\n#{metrics_a}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>2. Benchmark Assessment Completion</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                     "Category 2 Points:\n#{metrics_b}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>3. Study Island Blue Ribbon Annual Achievement</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",         "Category 3 Points:\n#{metrics_c}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>4. Study Island Blue Ribbon Monthly Participation</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",      "Category 4 Points:\n#{metrics_d}"],
            [metrics_scale_p1, metrics_scale_p2]
            
        ] do
            
            cells.style do |c|
                
                if c.row == 0 || c.row == 2 || c.row == 4 || c.row == 6
                    
                    c.inline_format = true
                    
                    case c.column
                        
                    when 0
                        
                        c.size = 7
                        c.width = 277.5
                        
                    when 1
                        
                        c.size = 6
                        c.width = 92.5
                        
                    end
                    
                end
                
            end
            
        end
        
        metrics_sub_section = pdf.make_table [
            
            [metrics_points_sub_section, "<b>Metrics Section Points Awarded:</b>\n\n#{metrics_overall}"]
            
        ] do
            
            cells.style do |c|
                
                case c.column
                    
                when 0
                    
                    c.width = 370
                    
                when 1
                    
                    c.size = 7
                    c.inline_format = true
                    c.align         = :center
                    c.valign        = :center
                    c.width = 50
                    
                end
                
            end
            
        end
        
        metrics_section = pdf.make_table [
            
            ["<b>Students will master grade level standards and demonstrate growth.</b>
• Mastery is indicated by the percentage of students who earn Blue Ribbons on monthly Study Island assignments. 
• Academic growth is measured through Scantron Performance and/or AIMSweb."],
            [metrics_sub_section],
            [comments(pdf, metrics_evaluator_comments,   type="team")],
            [comments(pdf, metrics_supervisor_comments,  type="eval")]
            
        ],
        :width=>420 do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.background_color="DBF4FF"
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return metrics_section
        
    end
    
    def evaluation_academic_professionalism_section(pdf)
        
        pdf.table [
            
            ["Professionalism\n(20%)",  academic_professionalism_sub_section(pdf)]
            
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
        
        return pdf
        
    end
    
    def academic_professionalism_sub_section(pdf)
        
        academic_professionalism       = @t.evaluation_academic_professionalism
        
        prof_conduct_chk               = academic_professionalism.source_conduct.value             == "1" ? checkbox_filled : checkbox_empty
        prof_mar_chk                   = academic_professionalism.source_record_keeping.value      == "1" ? checkbox_filled : checkbox_empty
        prof_cwf_chk                   = academic_professionalism.source_communication.value       == "1" ? checkbox_filled : checkbox_empty
        prof_pipg_chk                  = academic_professionalism.source_professional_growth.value == "1" ? checkbox_filled : checkbox_empty
        
        prof_score                     = academic_professionalism.score.value
        
        prof_dist_chk                  = prof_score == "20.00" ? checkbox_filled : checkbox_empty
        prof_prof_chk                  = prof_score == "15.00" ? checkbox_filled : checkbox_empty
        prof_prog_chk                  = prof_score == "10.00" ? checkbox_filled : checkbox_empty
        prof_unsat_chk                 = prof_score == "5.00"  ? checkbox_filled : checkbox_empty

        prof_teacher_comments          = academic_professionalism.team_member_comments.value
        prof_evaluator_comments        = academic_professionalism.supervisor_comments.value
        
        professionalism_sub_section = pdf.make_table [
            ["<b>Distinguished</b>\nThe team member extensively demonstrates indicators of performance.",       "#{prof_dist_chk} 20"],
            ["<b>Proficient</b>\nThe team member thoroughly demonstrates indicators of performance.",           "#{prof_prof_chk} 15"],
            ["<b>Progressing</b>\nThe team member adequately demonstrates indicators of performance.",          "#{prof_prog_chk} 10"],
            ["<b>Unsatisfactory</b>\nThe team member rarely or never demonstrates indicators of performance.",  "#{prof_unsat_chk} 05"]
        ],
        :column_widths => [370,50] do
            cells.style do |c|
                c.inline_format = true
                c.height        = 30
                case c.column
                when 0
                    c.size = 7
                when 1
                    c.size = 12
                    c.align = :center
                    c.valign = :center
                end
            end
        end
        
        professionalism_section = pdf.make_table [
            
            ["<b>Team member maintains a high level of knowledge regarding his or her subject area and collaborates effectively with colleagues.  A professional Team Member is always eager to learn by attending new training and reporting back to the team.
Sources of Evidence</b>:
#{prof_conduct_chk}  <b>Conduct</b> 
•Demonstrates integrity and ethical practices
•Advocacy
•Decision making
•Compliance with school policies and procedures
#{prof_mar_chk}  <b>Maintaining accurate records</b>
•Provides timely feedback on work assignments
•Enters detailed and appropriate notes in Total View 
•Updates ILPs for students
#{prof_cwf_chk}  <b>Communicating with Families</b>
•Responds to phone and K-Mail messages within 24 hours
•Conference notes and ILPs 
#{prof_pipg_chk}  <b>Participating in PLCs and Professional Growth</b>
•Relationships with colleagues
•Service to the school
•Enhancement of content knowledge and pedagogical skill"],
            [professionalism_sub_section],
            [comments(pdf, prof_teacher_comments,   type="team")],
            [comments(pdf, prof_evaluator_comments, type="eval")]
            
        ], :width=>420 do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return professionalism_section
        
    end
    
    def academic_summary_data_array
        
        evaluation_summary = @t.evaluation_summary
        
        #PEER GROUP SUMMARY RECORD
        pgsr = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").by_peer_group_id(@t.peer_group_id.value, @t.department_id.value)
        
        #DEPARTMENT SUMMARY RECORD
        dsr = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").by_department_id(@t.department_id.value)
        
        summary_array = Array.new
        
        summary_array = [
            
            ["Average # Student on Class List",                                    evaluation_summary.students.to_user({:na=>true}),                                dsr ? dsr.fields["students"                             ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["students"                            ].to_user({:na=>true}) : ""  ],
            ["% Students New to Agora This Year",                                  evaluation_summary.new.to_user({:na=>true}),                                     dsr ? dsr.fields["new"                                  ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["new"                                 ].to_user({:na=>true}) : ""  ],
            ["% Class List From In-Year Enrollments",                              evaluation_summary.in_year.to_user({:na=>true}),                                 dsr ? dsr.fields["in_year"                              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["in_year"                             ].to_user({:na=>true}) : ""  ],
            ["% Class List From Free or Reduced Lunch Households",                 evaluation_summary.low_income.to_user({:na=>true}),                              dsr ? dsr.fields["low_income"                           ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["low_income"                          ].to_user({:na=>true}) : ""  ],
            ["% Class List Identified as Tier 3 Academic Category",                evaluation_summary.tier_23.to_user({:na=>true}),                                 dsr ? dsr.fields["tier_23"                              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["tier_23"                             ].to_user({:na=>true}) : ""  ],
            ["% Special Education Students on Class List",                         evaluation_summary.special_ed.to_user({:na=>true}),                              dsr ? dsr.fields["special_ed"                           ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["special_ed"                          ].to_user({:na=>true}) : ""  ],
            ["Study Island Monthly Participation Average - Overall",               evaluation_summary.study_island_participation.to_user({:na=>true}),              dsr ? dsr.fields["study_island_participation"           ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["study_island_participation"          ].to_user({:na=>true}) : ""  ],
            ["Study Island Average of Blue Ribbons Earned- Overall",               evaluation_summary.study_island_achievement.to_user({:na=>true}),                dsr ? dsr.fields["study_island_achievement"             ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["study_island_achievement"            ].to_user({:na=>true}) : ""  ],
            ["Student Attendance Rate",                                            evaluation_summary.attendance_rate.to_user({:na=>true}),                         dsr ? dsr.fields["attendance_rate"                      ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["attendance_rate"                     ].to_user({:na=>true}) : ""  ],
            ["Student Engagement Level Average (1 = Low, 2 = Average, 3 = High)",  evaluation_summary.engagement_level.to_user({:na=>true}),                        dsr ? dsr.fields["engagement_level"                     ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["engagement_level"                    ].to_user({:na=>true}) : ""  ]
            
        ]
        
        case @t.department_id.value
        when "2","5"
            
            summary_array.insert(6, 
                
                ["Scantron Performance Participation - Fall",           evaluation_summary.scantron_participation_fall.to_user({:na=>true}),             dsr ? dsr.fields["scantron_participation_fall"          ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_fall"         ].to_user({:na=>true}) : ""  ],
                ["Scantron Performance Participation - Spring",         evaluation_summary.scantron_participation_spring.to_user({:na=>true}),           dsr ? dsr.fields["scantron_participation_spring"        ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_spring"       ].to_user({:na=>true}) : ""  ],
                ["Scantron Performance Growth",                         evaluation_summary.scantron_growth_overall.to_user({:na=>true}),                 dsr ? dsr.fields["scantron_growth_overall"              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_growth_overall"             ].to_user({:na=>true}) : ""  ]
                
            )
            
        when "3"
            
            summary_array.insert(6, 
                
                ["AIMSweb Participation - Fall",                        evaluation_summary.aims_participation_fall.to_user({:na=>true}),             dsr ? dsr.fields["aims_participation_fall"          ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["aims_participation_fall"         ].to_user({:na=>true}) : ""  ],
                ["AIMSweb Participation - Spring",                      evaluation_summary.aims_participation_spring.to_user({:na=>true}),           dsr ? dsr.fields["aims_participation_spring"        ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["aims_participation_spring"       ].to_user({:na=>true}) : ""  ],
                ["AIMSweb Growth",                                      evaluation_summary.aims_growth_overall.to_user({:na=>true}),                 dsr ? dsr.fields["aims_growth_overall"              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["aims_growth_overall"             ].to_user({:na=>true}) : ""  ]
                
            )
            
        when "6"
            
            summary_array.insert(6,
                                 
                ["Scantron Performance Participation - Fall",           evaluation_summary.scantron_participation_fall.to_user({:na=>true}),         dsr ? dsr.fields["scantron_participation_fall"          ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_fall"         ].to_user({:na=>true}) : ""  ],
                ["Scantron Performance Participation - Spring",         evaluation_summary.scantron_participation_spring.to_user({:na=>true}),       dsr ? dsr.fields["scantron_participation_spring"        ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_spring"       ].to_user({:na=>true}) : ""  ],
                ["Scantron Performance Growth",                         evaluation_summary.scantron_growth_overall.to_user({:na=>true}),             dsr ? dsr.fields["scantron_growth_overall"              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_growth_overall"             ].to_user({:na=>true}) : ""  ],
                ["AIMSweb Participation - Fall",                        evaluation_summary.aims_participation_fall.to_user({:na=>true}),             dsr ? dsr.fields["scantron_participation_fall"          ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_fall"         ].to_user({:na=>true}) : ""  ],
                ["AIMSweb Participation - Spring",                      evaluation_summary.aims_participation_spring.to_user({:na=>true}),           dsr ? dsr.fields["scantron_participation_spring"        ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_participation_spring"       ].to_user({:na=>true}) : ""  ],
                ["AIMSweb Growth",                                      evaluation_summary.aims_growth_overall.to_user({:na=>true}),                 dsr ? dsr.fields["scantron_growth_overall"              ].to_user({:na=>true}) : "", pgsr ? pgsr.fields["scantron_growth_overall"             ].to_user({:na=>true}) : ""  ]
                
            )
            
        end
        
        return summary_array
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACADEMIC_MIDDLE_SCHOOL_SPECIFIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def evaluation_academic_ms_metrics_section(pdf)
        
        pdf.table [
            
            ["Metrics\n(40%)",          academic_metrics_ms_sub_section(pdf)]
            
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
        
        graph_deviation_from_norm(pdf)
        
        return pdf
        
    end
    
    def academic_metrics_ms_sub_section(pdf)
        
        academic_metrics               = @t.evaluation_academic_metrics
        
        metrics_soe_chk                = academic_metrics.source_data.value == "1" ? checkbox_filled : checkbox_empty
        
        metrics_a1                     = academic_metrics.assessment_performance.value
        metrics_a2                     = (academic_metrics.assessment_participation_fall.mathable || 0) + (academic_metrics.assessment_participation_spring.mathable || 0)
        metrics_b                      = academic_metrics.course_passing_rate.value
        metrics_c                      = academic_metrics.study_island_achievement.value
        metrics_d                      = academic_metrics.study_island_participation.value
        metrics_overall                = academic_metrics.score.value
        
        metrics_evaluator_comments     = academic_metrics.team_member_comments.value
        metrics_supervisor_comments    = academic_metrics.supervisor_comments.value
        
        metrics_scale_p1 = pdf.make_table [
            
            ["<b>Unsatisfactory:</b>\n<-2 SD = 2.5 pts", "<b>Progressing:</b>\n<-1 SD = 5 pts", "<b>Proficient:</b>\nWithin (+/-) 1 SD = 7.5 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }
        
        metrics_scale_p2 = pdf.make_table [
            
            ["<b>Distinguished:</b>\n>+1 SD = 10 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }
        
        metrics_table = [
            
            ["<b>2. Course Passing Rate (All Subjects)</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                                           "Category 2 Points:\n#{metrics_b}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>3. Study Island Blue Ribbon Annual Achievement (English, Math Only)</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",             "Category 3 Points:\n#{metrics_c}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>4. Study Island Blue Ribbon Monthly Participation (All Subjects)</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                "Category 4 Points:\n#{metrics_d}"],
            [metrics_scale_p1, metrics_scale_p2]
            
        ]
        
        role_details = $focus_team_member.role_details
        course_row   = $tables.attach("course_relate").by_course_name(role_details.first) if role_details
        
        if course_row && (course_row.fields["scantron_growth_math"].value == "1" || course_row.fields["scantron_growth_reading"].value == "1")
            
            metrics_table.insert(0, 
                ["<b>1. Scantron Performance (English, Math)</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                                         "Category 1 Points:\n#{metrics_a1}"],
                [metrics_scale_p1, metrics_scale_p2]
            )
            
        else
            
            metrics_table.insert(0, 
                ["<b>1. Participation (Science, History, PE)</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                                         "Category 1 Points:\n#{metrics_a2}"],
                [metrics_scale_p1, metrics_scale_p2]
            )
            
        end
        
        metrics_points_sub_section = pdf.make_table metrics_table do
            
            cells.style do |c|
                
                if c.row == 0 || c.row == 2 || c.row == 4 || c.row == 6
                    
                    c.inline_format = true
                    
                    case c.column
                        
                    when 0
                        
                        c.size = 7
                        c.width = 277.5
                        
                    when 1
                        
                        c.size = 6
                        c.width = 92.5
                        
                    end
                    
                end
                
            end
            
        end
        
        metrics_sub_section = pdf.make_table [
            
            [metrics_points_sub_section, "<b>Metrics Section Points Awarded:</b>\n\n#{metrics_overall}"]
            
        ] do
            
            cells.style do |c|
                
                case c.column
                    
                when 0
                    
                    c.width = 370
                    
                when 1
                    
                    c.size = 7
                    c.inline_format = true
                    c.align         = :center
                    c.valign        = :center
                    c.width = 50
                    
                end
                
            end
            
        end
        
        metrics_section = pdf.make_table [
            
            ["<b>Students will master grade level standards and demonstrate growth.</b>
• Mastery is indicated by the percentage of students who earn Blue Ribbons on monthly Study Island assignments. 
• Academic growth is measured through Scantron Performance and/or AIMSweb."],
            [metrics_sub_section],
            [comments(pdf, metrics_evaluator_comments,   type="team")],
            [comments(pdf, metrics_supervisor_comments,  type="eval")]
            
        ],
        :width=>420 do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.background_color="DBF4FF"
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return metrics_section
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ENGAGEMENT_SPECIFIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def evaluation_engagement_metrics_section(pdf)
        
        pdf.table [
            
            ["Student Engagement and Related Metrics\n(0-70pts)",      engagement_metrics_sub_section(pdf)]
            
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
        
        graph_deviation_from_norm(pdf)
        
        return pdf
        
    end
    
    def engagement_metrics_sub_section(pdf)
        
        engagement_metrics = @t.evaluation_engagement_metrics
        
        metrics_st_part_fall           = engagement_metrics.scantron_participation_fall.value
        metrics_st_part_spring         = engagement_metrics.scantron_participation_spring.value
        metrics_att_vs                 = engagement_metrics.attendance.value
        metrics_do_tp                  = engagement_metrics.truancy_prevention.value
        metrics_pssa_keystone_part     = "#{engagement_metrics.pssa_participation.value.to_f + engagement_metrics.keystone_participation.value.to_f}"
        metrics_quality_doc            = engagement_metrics.quality_documentation.value
        metrics_fp_feedback            = engagement_metrics.feedback.value
        metrics_coach_comments         = engagement_metrics.team_member_comments.value
        metrics_evaluator_comments     = engagement_metrics.supervisor_comments.value
        metrics_score                  = engagement_metrics.score.value
                
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
            
            ["<b>2. Attendance in Virtual School (0-25pts)</b>\nAttendance score is based on the aggregated average attendance rate of all students on class list.",  metrics_att_vs],
            ["<b>3. Dropout/Truancy Prevention (0-10pts)</b>\nRetention score is based on the number of students who are not withdrawn due to truancy or dropout from the total number of students on class list.", metrics_do_tp],
            ["<b>4. PSSA and Keystone Participation Rate (0-10pts)</b>\nScore is based on percentage of students required to take state standardized tests who actually participate", metrics_pssa_keystone_part],
            ["<b>5. Quality Documentation (0-10pts)</b>\nScore is based on assessed thoroughness of documentation of student interactions", metrics_quality_doc],
            ["<b>6. Family and Peer Feedback (0-5pts)</b>\nScore is based on survey results of families and Agora colleagues with respect to levels of service and responsiveness.", metrics_fp_feedback],
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
            [comments(pdf, metrics_coach_comments,     type="team", 350)],
            [comments(pdf, metrics_evaluator_comments, type="eval", 350)]
        ]
        
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
        
        metrics_section_table = pdf.make_table([
                ["<b>Team Members's performance appropriately demonstrates:</b>
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
        
        return metrics_section_table
        
    end
    
    def evaluation_engagement_observation_section(pdf)
        
        engagement_observation    = @t.evaluation_engagement_observation
        observation_score         = engagement_observation.score.value
        
        pdf.table [
            
            ["Observation\n(0-20pts)", engagement_observation_sub_section(pdf, engagement_observation), "Observation Score:\n#{observation_score}"]
            
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
        
    end
    
    def engagement_observation_sub_section(pdf, engagement_observation)
        
        rapport_chk            = engagement_observation.rapport.value                == "1" ? checkbox_filled : checkbox_empty
        basic_knowledge_chk    = engagement_observation.knowledge.value              == "1" ? checkbox_filled : checkbox_empty
        clear_goal_chk         = engagement_observation.goal.value                   == "1" ? checkbox_filled : checkbox_empty
        narrative_chk          = engagement_observation.narrative.value              == "1" ? checkbox_filled : checkbox_empty
        obtain_commit_chk      = engagement_observation.obtaining_commitment.value   == "1" ? checkbox_filled : checkbox_empty
        comm_level_chk         = engagement_observation.communication.value          == "1" ? checkbox_filled : checkbox_empty
        doc_follow_up_chk      = engagement_observation.documentation_followup.value == "1" ? checkbox_filled : checkbox_empty
        
        ob_teacher_comments    = engagement_observation.team_member_comments.value
        ob_evaluator_comments  = engagement_observation.supervisor_comments.value
        
        observation_sub_section_table = pdf.make_table [
            
            ["<b>Team Member demonstrates during live interactions with students and families the competencies and traits required to build and grow relationships that enable academic achievement (See Observation Form)

Highlighted areas include:</b>
#{rapport_chk        } <u>Rapport</u> with the family – (leads to trust on the family's behalf)
#{basic_knowledge_chk} Basic <u>knowledge</u> when responding to questions, responses when information is not known
#{clear_goal_chk     } Clear <u>goal</u> of desired outcome of visit or call with student/family
#{narrative_chk      } <u>Narrative</u> – having a \"big picture\" conversation
#{obtain_commit_chk  } <u>Obtaining commitment</u> from the student/family
#{comm_level_chk     } <u>Communication</u> level – active listening, genuine interactions
#{doc_follow_up_chk  } <u>Documentation & Follow up</u>"],
            [comments(pdf, ob_teacher_comments,   type="team", 350)],
            [comments(pdf, ob_evaluator_comments, type="eval", 350)],
        ], :column_widths=>[350] do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return observation_sub_section_table
        
    end
    
    def evaluation_engagement_professionalism_section(pdf)
        
        engagement_professionalism    = @t.evaluation_engagement_professionalism
        professionalism_score         = engagement_professionalism.score.value
        
        pdf.table [
            
            ["Professionalism\n(0-10pts)",                             evaluation_engagement_professionalism_sub_section(pdf), "Professionalism Score:\n#{professionalism_score}"]
            
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
        
    end
    
    def evaluation_engagement_professionalism_sub_section(pdf)
        
        engagement_professionalism = @t.evaluation_engagement_professionalism
        
        address_parent_chk        = engagement_professionalism.source_addresses_concerns.value         == "1" ? checkbox_filled : checkbox_empty
        team_collab_chk           = engagement_professionalism.source_collaboration.value              == "1" ? checkbox_filled : checkbox_empty
        comm_prof_chk             = engagement_professionalism.source_communication.value              == "1" ? checkbox_filled : checkbox_empty
        att_event_chk             = engagement_professionalism.source_attends_events.value             == "1" ? checkbox_filled : checkbox_empty
        exec_engage_chk           = engagement_professionalism.source_execution.value                  == "1" ? checkbox_filled : checkbox_empty
        seek_prof_dev_chk         = engagement_professionalism.source_professional_development.value   == "1" ? checkbox_filled : checkbox_empty
        active_valued_chk         = engagement_professionalism.source_meeting_contributions.value      == "1" ? checkbox_filled : checkbox_empty
        timely_escalate_chk       = engagement_professionalism.source_issue_escalation.value           == "1" ? checkbox_filled : checkbox_empty
        sti_lev_marked_chk        = engagement_professionalism.source_sti.value                        == "1" ? checkbox_filled : checkbox_empty
        meets_deadlines_chk       = engagement_professionalism.source_meets_deadlines.value            == "1" ? checkbox_filled : checkbox_empty
        
        prof_score                     = engagement_professionalism.score.value
        
        prof_teacher_comments          = engagement_professionalism.team_member_comments.value
        prof_evaluator_comments        = engagement_professionalism.supervisor_comments.value
        
        professionalism_section_table = pdf.make_table [
            
            ["<b>Team Member's performance appropriately demonstrates indicates a spirit of teamwork, collaboration and interest in developing themselves.

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
            [comments(pdf, prof_teacher_comments,   type="team", 350)],
            [comments(pdf, prof_evaluator_comments, type="eval", 350)]
            
        ], :column_widths=>[350] do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.size = 7
                    c.inline_format = true
                    
                end
                
            end
            
        end
        
        return professionalism_section_table
        
    end
    
    def engagement_summary_data_array
        
        evaluation_summary = @t.evaluation_summary
        
        #PEER GROUP SUMMARY RECORD
        pgsr = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").by_peer_group_id(@t.peer_group_id.value, @t.department_id.value)
        
        #DEPARTMENT SUMMARY RECORD
        dsr = $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").by_department_id(@t.department_id.value)
        
        return  [
                    ["Current # Student on Class List",                             evaluation_summary.students.to_user({:na=>true}),                      dsr.fields["students"                        ].to_user({:na=>true}),   pgsr.fields["students"                        ].to_user({:na=>true}) ],
                    ["% Students New to Agora This Year",                           evaluation_summary.new.to_user({:na=>true}),                           dsr.fields["new"                             ].to_user({:na=>true}),   pgsr.fields["new"                             ].to_user({:na=>true}) ],
                    ["% Class List From In-Year Enrollments",                       evaluation_summary.in_year.to_user({:na=>true}),                       dsr.fields["in_year"                         ].to_user({:na=>true}),   pgsr.fields["in_year"                         ].to_user({:na=>true}) ],
                    ["% Class List in Grades 7-12",                                 evaluation_summary.grades_712.to_user({:na=>true}),                    dsr.fields["grades_712"                      ].to_user({:na=>true}),   pgsr.fields["grades_712"                      ].to_user({:na=>true}) ],
                    ["% Class List From Free or Reduced Lunch Households",          evaluation_summary.low_income.to_user({:na=>true}),                    dsr.fields["low_income"                      ].to_user({:na=>true}),   pgsr.fields["low_income"                      ].to_user({:na=>true}) ],
                    ["% Class List Identified as Tier 2 - 3 Academic Category",     evaluation_summary.tier_23.to_user({:na=>true}),                       dsr.fields["tier_23"                         ].to_user({:na=>true}),   pgsr.fields["tier_23"                         ].to_user({:na=>true}) ],
                    ["% Class List In Special Education",                           evaluation_summary.special_ed.to_user({:na=>true}),                    dsr.fields["special_ed"                      ].to_user({:na=>true}),   pgsr.fields["special_ed"                      ].to_user({:na=>true}) ],
                    ["Student Attendance Rate",                                     evaluation_summary.attendance_rate.to_user({:na=>true}),               dsr.fields["attendance_rate"                 ].to_user({:na=>true}),   pgsr.fields["attendance_rate"                 ].to_user({:na=>true}) ],
                    ["Student Retention Rate",                                      evaluation_summary.retention_rate.to_user({:na=>true}),                dsr.fields["retention_rate"                  ].to_user({:na=>true}),   pgsr.fields["retention_rate"                  ].to_user({:na=>true}) ],
                    ["Scantron / Assessment Participation Rate - Fall",             evaluation_summary.scantron_participation_fall.to_user({:na=>true}),   dsr.fields["scantron_participation_fall"     ].to_user({:na=>true}),   pgsr.fields["scantron_participation_fall"     ].to_user({:na=>true}) ],
                    ["Scantron / Assessment Participation Rate - Spring",           evaluation_summary.scantron_participation_spring.to_user({:na=>true}), dsr.fields["scantron_participation_spring"   ].to_user({:na=>true}),   pgsr.fields["scantron_participation_spring"   ].to_user({:na=>true}) ],
                    ["Define U Participation Rate",                                 evaluation_summary.define_u_participation.to_user({:na=>true}),        dsr.fields["define_u_participation"          ].to_user({:na=>true}),   pgsr.fields["define_u_participation"          ].to_user({:na=>true}) ],
                    ["PSSA Participation Rate (In Eligible Grades)",                evaluation_summary.pssa_participation.to_user({:na=>true}),            dsr.fields["pssa_participation"              ].to_user({:na=>true}),   pgsr.fields["pssa_participation"              ].to_user({:na=>true}) ],
                    ["Keystone Participation Rate (In Eligible Grades)",            evaluation_summary.keystone_participation.to_user({:na=>true}),        dsr.fields["keystone_participation"          ].to_user({:na=>true}),   pgsr.fields["keystone_participation"          ].to_user({:na=>true}) ]
                ]
        
    end
    
end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TEMPLATE_TOOLS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def agora_logo(pdf)
        
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        
        pdf.image logo_path,
            :width      => 190,
            :height     => 50,
            :position   => :right
            
        return pdf
        
    end
    
    def blank
        
        return "#{$paths.templates_path}images/blank.jpg"
        
    end
    
    def checkbox_empty
        
        return "\xE2\x98\x90"
        
    end
    
    def checkbox_filled
        
        return "\xE2\x98\x91"
        
    end
    
    def set_fonts(pdf)
        
        pdf.font_families.update("Arial" => {
            :normal      => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
            :italic      => "c:/windows/fonts/ariali.ttf",
            :bold        => "c:/windows/fonts/arialbd.ttf",
            :bold_italic => "c:/windows/fonts/arialbi.ttf"
        })
        
        pdf.font "Arial"
        
        pdf.fallback_fonts ["#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"]
        
        return pdf
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________GRAPH
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

def graph_deviation_from_norm(pdf)
    
    cursor_position = pdf.cursor
    
    pdf.stroke_color "000000"
    pdf.fill_color "DBF4FF"
    pdf.line_width = 1
    pdf.fill_and_stroke_rectangle [10, pdf.cursor], 100, 100
    pdf.fill_color "000000"   
    
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
            
            case @t.department_id.value
                
            when "2","3","6"
                
                scantron    = @t.evaluation_academic_metrics.assessment_performance_dfn.value
                data_points.push(["1", scantron.to_f     ]) if scantron
                
                attendance  = ((@t.evaluation_academic_metrics.assessment_participation_fall_dfn.value.to_f || 0) + (@t.evaluation_academic_metrics.assessment_participation_spring_dfn.value.to_f || 0))/2              
                data_points.push(["2", attendance.to_f   ]) if attendance
                
                si_achievement  = @t.evaluation_academic_metrics.study_island_achievement_dfn.value       
                data_points.push(["3", si_achievement.to_f   ]) if si_achievement
                
                si_participation   = @t.evaluation_academic_metrics.study_island_participation_dfn.value               
                data_points.push(["4", si_participation.to_f    ]) if si_participation
                
            when "5"
                
                scantron    = @t.evaluation_academic_metrics.assessment_performance_dfn.value
                data_points.push(["1", scantron.to_f     ]) if scantron
                
                course_passing  = @t.evaluation_academic_metrics.course_passing_rate_dfn.value             
                data_points.push(["2", course_passing.to_f   ]) if course_passing
                
                si_participation   = @t.evaluation_academic_metrics.study_island_participation_dfn.value               
                data_points.push(["3", si_participation.to_f    ]) if si_participation
                
                si_achievement  = @t.evaluation_academic_metrics.study_island_achievement_dfn.value       
                data_points.push(["4", si_achievement.to_f   ]) if si_achievement
                
            when "4"
                
                scantron    = (@t.evaluation_engagement_metrics.scantron_participation_fall_dfn.value.to_f||0) + (@t.evaluation_engagement_metrics.scantron_participation_spring_dfn.value.to_f||0)/2
                data_points.push(["1", scantron.to_f     ]) if scantron
                
                attendance  = @t.evaluation_engagement_metrics.attendance_dfn.value              
                data_points.push(["2", attendance.to_f   ]) if attendance
                
                truancy_prevention   = @t.evaluation_engagement_metrics.truancy_prevention_dfn.value               
                data_points.push(["3", truancy_prevention.to_f    ]) if truancy_prevention
                
                state_test  = (@t.evaluation_engagement_metrics.keystone_participation_dfn.value.to_f||0) + (@t.evaluation_engagement_metrics.pssa_participation_dfn.value.to_f||0)/2       
                data_points.push(["4", state_test.to_f   ]) if state_test
                
            end
            
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
