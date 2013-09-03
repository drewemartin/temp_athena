#!/usr/local/bin/ruby

class EVALUATION_PDF_ELEMENTARY

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def confirmed_batch(group=true)
        completed_batch_pdf = Prawn::Document.new
        #sids=["1038176", "767108"]
        sids = $students.list(:currently_enrolled=>true, :grade=>"8th").sort_by(&:to_i)
        sids.each do |sid|
            if $tables.attach("Jupiter_Grades").by_studentid_old(sid)
                if group
                    generate_pdf(sid, completed_batch_pdf)
                    completed_batch_pdf.start_new_page
                else
                    generate_pdf(sid)
                end
            end
        end
        file_name = "8th_Q1_Report_Cards_#{$ifilestamp}.pdf"
        file_path = $config.init_path("#{$paths.reports_path}Report_Cards")
        completed_batch_pdf.render_file("#{file_path}#{file_name}") if group
    end
    
    def generate_pdf(tid, pdf = nil)
        
        t   = $team.get(tid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        
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
        
        empty_checkbox  = "\xE2\x98\x90" # "☐"
        
        filled_checkbox = "\xE2\x98\x91" # "☑"
        
        employee_name       = t.primary_id.to_name(:full_name)
        title               = ""
        academic_department = t.department.value
        evaluator           = t.supervisor_team_id.to_name(:full_name)
        review_period       = "#{$school.current_school_year} School Year"
        
        overall_score       = 75
        
        evaluation_summary = t.evaluation_summary

        avg_num_student_on_class_list                              = [evaluation_summary.students.value,                                evaluation_summary.students.to_department_group_average,                                evaluation_summary.students.to_peer_group_average                                ]
        percent_students_new_to_agora_this_year                    = [evaluation_summary.new.value,                                     evaluation_summary.new.to_department_group_average,                                     evaluation_summary.new.to_peer_group_average                                     ]
        percent_class_list_in_year_enrollments                     = [evaluation_summary.in_year.value,                                 evaluation_summary.in_year.to_department_group_average,                                 evaluation_summary.in_year.to_peer_group_average                                 ]
        percent_class_list_free_or_reduced_lunch_households        = [evaluation_summary.low_income.value,                              evaluation_summary.low_income.to_department_group_average,                              evaluation_summary.low_income.to_peer_group_average                              ]
        percent_class_list_identified_tier_3_academic_category     = [evaluation_summary.tier_23.value,                                 evaluation_summary.tier_23.to_department_group_average,                                 evaluation_summary.tier_23.to_peer_group_average                                 ]
        percent_special_education_students_on_class_list           = [evaluation_summary.special_ed.value,                              evaluation_summary.special_ed.to_department_group_average,                              evaluation_summary.special_ed.to_peer_group_average                              ]
        scantron_perf_and_aimsweb_participation_fall               = [evaluation_summary.scantron_participation_fall.value,             evaluation_summary.scantron_participation_fall.to_department_group_average,             evaluation_summary.scantron_participation_fall.to_peer_group_average             ]
        scantron_perf_and_aimsweb_participation_spring             = [evaluation_summary.scantron_participation_spring.value,           evaluation_summary.scantron_participation_spring.to_department_group_average,           evaluation_summary.scantron_participation_spring.to_peer_group_average           ]
        scantron_perf_and_aimsweb_growth                           = [evaluation_summary.scantron_growth.value,                         evaluation_summary.scantron_growth.to_department_group_average,                         evaluation_summary.scantron_growth.to_peer_group_average                         ]
        si_mon_participation_avg_overall                           = [evaluation_summary.study_island_participation.value,              evaluation_summary.study_island_participation.to_department_group_average,              evaluation_summary.study_island_participation.to_peer_group_average              ]
        si_mon_participation_avg_tier_2_3                          = [evaluation_summary.study_island_participation_tier_23.value,      evaluation_summary.study_island_participation_tier_23.to_department_group_average,      evaluation_summary.study_island_participation_tier_23.to_peer_group_average      ]
        si_avg_blue_ribbons_overall                                = [evaluation_summary.study_island_achievement.value,                evaluation_summary.study_island_achievement.to_department_group_average,                evaluation_summary.study_island_achievement.to_peer_group_average                ]
        si_avg_blue_ribbons_tier_2_3                               = [evaluation_summary.study_island_achievement_tier_23.value,        evaluation_summary.study_island_achievement_tier_23.to_department_group_average,        evaluation_summary.study_island_achievement_tier_23.to_peer_group_average        ]
        student_attendance_rate                                    = [evaluation_summary.attendance_rate.value,                         evaluation_summary.attendance_rate.to_department_group_average,                         evaluation_summary.attendance_rate.to_peer_group_average                         ]
        student_engagement_level_avg                               = [evaluation_summary.engagement_level.value,                        evaluation_summary.engagement_level.to_department_group_average,                        evaluation_summary.engagement_level.to_peer_group_average                        ]
        
        
        academic_instruction = t.evaluation_academic_instruction
        
        comprehensive_observations     = academic_instruction.source_comprehensive_observation.value
        lesson_recordings              = academic_instruction.source_lesson_recordings.value
        unannounced_observations       = academic_instruction.source_unannounced_observation.value
        
        co_chk                         = comprehensive_observations == "1" ? filled_checkbox : empty_checkbox
        lr_chk                         = lesson_recordings          == "1" ? filled_checkbox : empty_checkbox
        uo_chk                         = unannounced_observations   == "1" ? filled_checkbox : empty_checkbox
        
        inst_score                     = academic_instruction.score.value
        
        inst_dist_chk                  = inst_score == "40" ? filled_checkbox : empty_checkbox
        inst_prof_chk                  = inst_score == "30" ? filled_checkbox : empty_checkbox
        inst_prog_chk                  = inst_score == "20" ? filled_checkbox : empty_checkbox
        inst_unsat_chk                 = inst_score == "10" ? filled_checkbox : empty_checkbox
        
        inst_teacher_comments          = ""
        inst_evaluator_comments        = ""
        
        
        academic_metrics = t.evaluation_academic_metrics
        
        metrics_soe                    = academic_metrics.source_data.value
        
        metrics_soe_chk                = metrics_soe == "1" ? filled_checkbox : empty_checkbox
        
        metrics_a                      = academic_metrics.assessment_performance.value
        metrics_b                      = academic_metrics.benchmark_assessment_completion.value
        metrics_c                      = academic_metrics.si_blue_ribbon_annual_achievement.value
        metrics_d                      = academic_metrics.si_blue_ribbon_participation.value
        metrics_overall                = academic_metrics.score.value
        
        metrics_evaluator_comments     = ""
        
        
        academic_professionalism = t.evaluation_academic_professionalism
        
        prof_conduct                   = academic_professionalism.source_conduct.value
        prof_mar                       = academic_professionalism.source_record_keeping.value
        prof_cwf                       = academic_professionalism.source_communication.value
        prof_pipg                      = academic_professionalism.source_professional_growth.value
        
        prof_conduct_chk               = prof_conduct == "1" ? filled_checkbox : empty_checkbox
        prof_mar_chk                   = prof_mar     == "1" ? filled_checkbox : empty_checkbox
        prof_cwf_chk                   = prof_cwf     == "1" ? filled_checkbox : empty_checkbox
        prof_pipg_chk                  = prof_pipg    == "1" ? filled_checkbox : empty_checkbox
        
        prof_score                     = academic_professionalism.score.value
        
        prof_dist_chk                  = prof_score == "20" ? filled_checkbox : empty_checkbox
        prof_prof_chk                  = prof_score == "15" ? filled_checkbox : empty_checkbox
        prof_prog_chk                  = prof_score == "10" ? filled_checkbox : empty_checkbox
        prof_unsat_chk                 = prof_score == "5"  ? filled_checkbox : empty_checkbox

        prof_teacher_comments          = ""
        prof_evaluator_comments        = ""
        
        
        overall_rating                 = ""
        
        goal1                          = ""
        goal2                          = ""
        goal3                          = ""
        
        aab_mentoring                  = false
        aab_dty_recruitment_team       = false
        aab_committee_work             = false
        aab_testing                    = false
        aab_ahswsp                     = false
        aab_lpd                        = false
        aab_program_admin              = false
        aab_club_advisor               = false
        aab_substituting               = false
        aab_parent_trainings           = false
        aab_other                      = false
        aab_other_description          = ""
        
        aab_mentoring_chk              = aab_mentoring             == "1" ? filled_checkbox : empty_checkbox
        aab_dty_recruitment_team_chk   = aab_dty_recruitment_team  == "1" ? filled_checkbox : empty_checkbox
        aab_committee_work_chk         = aab_committee_work        == "1" ? filled_checkbox : empty_checkbox
        aab_testing_chk                = aab_testing               == "1" ? filled_checkbox : empty_checkbox
        aab_ahswsp_chk                 = aab_ahswsp                == "1" ? filled_checkbox : empty_checkbox
        aab_lpd_chk                    = aab_lpd                   == "1" ? filled_checkbox : empty_checkbox
        aab_program_admin_chk          = aab_program_admin         == "1" ? filled_checkbox : empty_checkbox
        aab_club_advisor_chk           = aab_club_advisor          == "1" ? filled_checkbox : empty_checkbox
        aab_substituting_chk           = aab_substituting          == "1" ? filled_checkbox : empty_checkbox
        aab_parent_trainings_chk       = aab_parent_trainings      == "1" ? filled_checkbox : empty_checkbox
        aab_other_chk                  = aab_other                 == "1" ? filled_checkbox : empty_checkbox
        
        aab_teacher_comments           = ""
        aab_evaluator_comments         = ""
        
        #SCHOOL LOGO
        pdf.move_down 8
        pdf.image logo_path,
            :width  => 190,
            :height => 50,
            :position => :right
        
        pdf.move_down 10
        
        #Employee Information
        pdf.table [
            
            ["<b>Elementary Program Performance Review</b>", {:content=>"Date: #{$iuser}", :align=>:right}]
            
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
            ["Academic Department:",    academic_department],
            ["Evaluator:",              evaluator],
            ["Review Period:",          review_period]
            
        ],
        :width          => 520,
        :position       => :center,
        :column_widths  => [120, 400],
        :cell_style     => {
            :size    => 10,
            :padding => 2
        }
        
        pdf.move_down 25
        
        #Performance Score
        #score = rand(100)
        
        pdf.table [
            
            ["<b>Overall Performance Score Range</b>", "<b>Overall Score: #{overall_score}</b>"],
            
        ],
        :width    => 520,
        :column_widths => [420,100],
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
                
            ], :width=>500,
        :position=>:center,
        :column_widths=>[107,164,179,50] do
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
            
            ["Average # Student on Class List",                                    avg_num_student_on_class_list[0]                         ,avg_num_student_on_class_list[1]                              ,avg_num_student_on_class_list[2]                            ],
            ["% Students New to Agora This Year",                                  percent_students_new_to_agora_this_year[0]               ,percent_students_new_to_agora_this_year[1]                    ,percent_students_new_to_agora_this_year[2]                  ],
            ["% Class List From In-Year Enrollments",                              percent_class_list_in_year_enrollments[0]                ,percent_class_list_in_year_enrollments[1]                     ,percent_class_list_in_year_enrollments[2]                   ],
            ["% Class List From Free or Reduced Lunch Households",                 percent_class_list_free_or_reduced_lunch_households[0]   ,percent_class_list_free_or_reduced_lunch_households[1]        ,percent_class_list_free_or_reduced_lunch_households[2]      ],
            ["% Class List Identified as Tier 3 Academic Category",                percent_class_list_identified_tier_3_academic_category[0],percent_class_list_identified_tier_3_academic_category[1]     ,percent_class_list_identified_tier_3_academic_category[2]   ],
            ["% Special Education Students on Class List",                         percent_special_education_students_on_class_list[0]      ,percent_special_education_students_on_class_list[1]           ,percent_special_education_students_on_class_list[2]         ],
            ["Scantron Performance and AIMSweb Participation - Fall",              scantron_perf_and_aimsweb_participation_fall[0]          ,scantron_perf_and_aimsweb_participation_fall[1]               ,scantron_perf_and_aimsweb_participation_fall[2]             ],
            ["Scantron Performance and AIMSweb Participation - Spring",            scantron_perf_and_aimsweb_participation_spring[0]        ,scantron_perf_and_aimsweb_participation_spring[1]             ,scantron_perf_and_aimsweb_participation_spring[2]           ],
            ["Scantron Performance and AIMSweb Growth",                            scantron_perf_and_aimsweb_growth[0]                      ,scantron_perf_and_aimsweb_growth[1]                           ,scantron_perf_and_aimsweb_growth[2]                         ],
            ["Study Island Monthly Participation Average - Overall",               si_mon_participation_avg_overall[0]                      ,si_mon_participation_avg_overall[1]                           ,si_mon_participation_avg_overall[2]                         ],
            ["Study Island Monthly Participation Average - Tier 2 and 3 only",     si_mon_participation_avg_tier_2_3[0]                     ,si_mon_participation_avg_tier_2_3[1]                          ,si_mon_participation_avg_tier_2_3[2]                        ],
            ["Study Island Average of Blue Ribbons Earned- Overall",               si_avg_blue_ribbons_overall[0]                           ,si_avg_blue_ribbons_overall[1]                                ,si_avg_blue_ribbons_overall[2]                              ],
            ["Study Island Average of Blue Ribbons Earned- Tier 2 and 3 only",     si_avg_blue_ribbons_tier_2_3[0]                          ,si_avg_blue_ribbons_tier_2_3[1]                               ,si_avg_blue_ribbons_tier_2_3[2]                             ],
            ["Student Attendance Rate",                                            student_attendance_rate[0]                               ,student_attendance_rate[1]                                    ,student_attendance_rate[2]                                  ],
            ["Student Engagement Level Average (1 = Low, 2 = Average, 3 = High)",  student_engagement_level_avg[0]                          ,student_engagement_level_avg[1]                               ,student_engagement_level_avg[2]                             ]
            
        ],
        :width         =>520,
        :position      =>:center,
        :column_widths => [295, 75, 75, 75],
        :cell_style    => {
            :size    => 8,
            :padding => 4
        }
        
        pdf.start_new_page
        
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
        :column_widths => [100,370,50],
        :cell_style    => {
            :size          => 10,
            :inline_format => true,
            :align         => :center,
            :padding       => 3
        }
        
        instruction_sub_section = pdf.make_table [
            
            ["<b>Distinguished</b>\nThe teacher demonstrates exemplary, innovative instruction which leads to maximized student mastery and can be used as a model for the staff.", "#{inst_dist_chk} 40"],
            ["<b>Proficient</b>\nThe teacher demonstrates consistent application of effective instruction which leads to significant student mastery.",                             "#{inst_prof_chk} 30"],
            ["<b>Progressing</b>\nThe teacher demonstrates emergent skills with some areas needing improvement. Student mastery is limited.",                                       "#{inst_prog_chk} 20"],
            ["<b>Unsatisfactory</b>\nThe teacher requires significant improvement in order for the lesson to be effective.",                                                        "#{inst_unsat_chk} 10"]
                
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

Teacher's  performance demonstrates effective instruction through:</b>
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
                ["Teacher Comments: #{inst_teacher_comments}"],
                ["Evaluator Comments: #{inst_evaluator_comments}"]
            ], :width=>420
        ) do
            cells.style do |c|
                
                case c.row
                    
                when 0,1
                    
                    c.background_color="DBF4FF"
                    c.size = 7
                    c.inline_format = true
                    
                when 3,4
                    
                    c.height = 50
                    c.size = 7
                    
                end
                
            end
            
        end
        
        metrics_scale_p1 = pdf.make_table [
            
            ["<b>Unsatisfactory:</b>\n<-2 SD = 10 pts", "<b>Progressing:</b>\n<-1 SD = 20 pts", "<b>Proficient:</b>\nWithin (+/-) 1 SD = 30 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }
        
        metrics_scale_p2 = pdf.make_table [
            
            ["<b>Distinguished:</b>\n>+1 SD = 40 pts"]
            
        ],
        :column_widths => 92.5,
        :cell_style    => {
            :size          => 6,
            :inline_format => true
        }

        
        metrics_points_sub_section = pdf.make_table [
            
            ["<b>A. Scantron Performance and AIMSweb Achievement/Growth</b>\nGrowth is based on standard deviation from your peer group's mean (SD).", "Category A Points:\n#{metrics_a}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>B. Benchmark Assessment Completion</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",                     "Category B Points:\n#{metrics_b}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>C. Study Island Blue Ribbon Annual Achievement</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",         "Category C Points:\n#{metrics_c}"],
            [metrics_scale_p1, metrics_scale_p2],
            ["<b>D. Study Island Blue Ribbon Monthly Participation</b>\nGrowth is based on standard deviation from your peer group's mean (SD).",      "Category D Points:\n#{metrics_d}"],
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
            
            [metrics_points_sub_section, "<b>Metrics Section Points Awarded:</b>\n\n#{metrics_overall}\n\n(Mean of Earned Category Points)"]
            
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
            ["<b>Sources of Evidence:</b>\n#{metrics_soe_chk} Data"],
            [metrics_sub_section],
            ["Evaluator Comments: #{metrics_evaluator_comments}"]
            
        ],
        :width=>420 do
            
            cells.style do |c|
                
                case c.row
                    
                when 0,1
                    
                    c.background_color="DBF4FF"
                    c.size = 7
                    c.inline_format = true
                    
                when 3
                    
                    c.height = 50
                    c.size = 7
                    
                end
                
            end
            
        end
        
        professionalism_sub_section = pdf.make_table [
            ["<b>Distinguished</b>\nThe teacher extensively demonstrates indicators of performance.",       "#{prof_dist_chk} 20"],
            ["<b>Proficient</b>\nThe teacher thoroughly demonstrates indicators of performance.",           "#{prof_prof_chk} 15"],
            ["<b>Progressing</b>\nThe teacher adequately demonstrates indicators of performance.",          "#{prof_prog_chk} 10"],
            ["<b>Unsatisfactory</b>\nThe teacher rarely or never demonstrates indicators of performance.",  "#{prof_unsat_chk} 05"]
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
            
            ["<b>Teacher maintains a high level of knowledge regarding his or her subject area and collaborates effectively with colleagues.  A professional teacher is always eager to learn by attending new training and reporting back to the team.
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
            ["Teacher Comments: #{prof_teacher_comments}"],
            ["Evaluator Comments: #{prof_evaluator_comments}"]
            
        ], :width=>420 do
            
            cells.style do |c|
                
                case c.row
                    
                when 0
                    
                    c.size = 7
                    c.inline_format = true
                    
                when 2,3
                    
                    c.size = 7
                    c.inline_format = true
                    c.height = 50
                    
                end
                
            end
            
        end
        
        pdf.table [
            
            ["Instruction\n(40%)",      instruction_section],
            ["Metrics\n(40%)",          metrics_section],
            ["Professionalism\n(20%)",  professionalism_section]
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
        
        pdf.table [
            
            ["Overall Rating\n(100%)", overall_rating]
            
        ],
        :width         => 520,
        :position      => :center,
        :column_widths => [470,50],
        :cell_style    => {
            :size             => 8,
            :inline_format    => true,
            :align            => :right,
            :background_color => "DBF4FF"
        }

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
            
            ["1.#{goal1}
              2.#{goal2}
              3.#{goal3}"]
            
        ],
        :width      => 520,
        :position   => :center,
        :cell_style => {
            :size          => 8,
            :inline_format => true
        }
        
        pdf.move_down 20
        
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
        
        pdf.table [
            
            ["Above and Beyond
Teacher has participated in additional duties beyond his/her job description that contributes to the operation, growth and positive climate of our school."],
            ["Sources of Evidence:
#{aab_mentoring_chk           } Mentoring
#{aab_dty_recruitment_team_chk} During the Year Recruitment Team
#{aab_committee_work_chk      } Committee Work
#{aab_testing_chk             } Testing
#{aab_ahswsp_chk              } After Hours Sessions with parents/students
#{aab_lpd_chk                 } Leading Professional Development
#{aab_program_admin_chk       } Program Administrator/expert 
#{aab_club_advisor_chk        } LOCAL Club Advisor
#{aab_substituting_chk        } Substituting (Without compensation) 
#{aab_parent_trainings_chk    } Parent trainings outside normal work hours
                 
#{aab_other_chk} Other – Please describe here: #{aab_other_description}"],
            ["Teacher Comments: #{aab_teacher_comments}"],
            ["Evaluator Comments: #{aab_evaluator_comments}"]
            
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
        
        #data = Array.new
        #(1..100).each do |x|
        #    data.push(rand(100))
        #end
        
        data = ["1", "1", "0", "0", "0.75"]
        
        #data = []
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
        
        scale_height   = 150
        scale_width    = 400
        scale_padding  = 25
        scale_offset   = 25
        
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
                
                pdf.vertical_line   scale_offset, 175, :at=> scale_offset
                pdf.horizontal_line scale_offset, 425, :at=> scale_offset
                
                (0..30).each do |x|
                    
                    pdf.horizontal_line 20, 25,  :at=>x*vertical_scale + scale_offset
                    
                end
                
            end
            
            pdf.stroke do
                
                pdf.stroke_color "0077DD"
                pdf.line_width = 0.5
                
                sortedData.each do |x|
                    
                    if x.first >= m-sds*3 && x.first <= m+sds*3
                        pdf.vertical_line   scale_offset, (x.last*vertical_inc) + scale_offset, :at=>x.first*horizontal_inc + scale_offset+1 - deviation_offset
                    end
                    
                    
                end
                
            end
            
            pdf.transparent(0.25) do
                pdf.fill_color "E8272C"
                pdf.fill_rectangle [(m-sds)*horizontal_inc + scale_offset - deviation_offset, scale_height+scale_offset], (sds*horizontal_inc*2), scale_height
            end
            
            pdf.transparent(0.25) do
                pdf.fill_color "01FC3A"
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
                
                pdf.vertical_line scale_offset, 175, :at=> m*horizontal_inc      + scale_offset - deviation_offset
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
            
        end
        
        #INTACT STUDENT TAGS
        #pdf.bounding_box([0, 25], :width => 535, :height => 25) do
        #    #STUDENT ID
        #    pdf.bounding_box([0, 0], :width => 535, :height => 25) do
        #        pdf.text s.student_id,
        #            :align => :left,
        #            :size => 10
        #    end
        #    #STUDENT LAST NAME
        #    pdf.bounding_box([0, 0], :width => 535, :height => 25) do
        #        pdf.text s.last_name.to_user,
        #            :align => :center,
        #            :size => 10
        #    end
        #    #STUDENT FIRST NAME
        #    pdf.bounding_box([0, 0], :width => 535, :height => 25) do
        #        pdf.text s.first_name.to_user,
        #            :align => :right,
        #            :size => 10
        #    end
        #end
        pdf.render_file "#{file_path}#{file_name}" if render_required
        
        return "#{file_path}#{file_name}"
        
    end
end