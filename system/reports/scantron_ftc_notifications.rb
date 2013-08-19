#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class SCANTRON_FTC_NOTIFICATIONS < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        role                            = "Family Teacher Coach"
        location                        = "Scantron/Exit_Participation_Missing"
        filename                        = "scantron_exit_participation_missing"
        
        completetion_rates_by_ftc           = Array.new
        overall_eligible_students           = Array.new
        overall_missing_eligible_students   = Array.new
        
        $team.family_teacher_coaches.each{|ftc|
            eligible_students = Array.new
            rows = Array.new
            f           = $team.by_k12_name(ftc)
            staff_id    = f.samsid.value
            if students = f.current_students(:role => role, :scantron_eligible=> true)
                students.each{|sid| 
                    s               = $students.attach(sid)
                    participated    = nil
                    overall_eligible_students.push([sid, s.first_name.value, s.last_name.value, ftc])
                    eligible_students.push([sid, s.first_name.value, s.last_name.value])
                    if $school.scantron.current_test_phase == "ent"
                        if !s.scantron.participated_entrance?
                            rows.push(
                                [
                                    s.student_id,
                                    s.first_name.value,
                                    s.last_name.value[0].chr,
                                    s.scantron.participated_entrance_reading?,
                                    s.scantron.participated_entrance_math?,
                                    s.lg_first_name.value,
                                    s.lg_last_name.value,
                                    s.phone_number.value
                                ]
                            )
                            overall_missing_eligible_students.push(
                                [
                                    s.student_id,
                                    s.first_name.value,
                                    s.last_name.value[0].chr,
                                    s.scantron.participated_entrance_reading?,
                                    s.scantron.participated_entrance_math?,
                                    s.lg_first_name.value,
                                    s.lg_last_name.value,
                                    s.phone_number.value,
                                    ftc
                                ]
                            )
                        end
                    elsif $school.scantron.current_test_phase == "ext"
                        if !s.scantron.participated_exit?
                            rows.push(
                                [
                                    s.student_id,
                                    s.first_name.value,
                                    s.last_name.value[0].chr,
                                    s.scantron.participated_exit_reading?,
                                    s.scantron.participated_exit_math?,
                                    s.lg_first_name.value,
                                    s.lg_last_name.value,
                                    s.phone_number.value
                                ]
                            )
                            overall_missing_eligible_students.push(
                                [
                                    s.student_id,
                                    s.first_name.value,
                                    s.last_name.value[0].chr,
                                    s.scantron.participated_exit_reading?,
                                    s.scantron.participated_exit_math?,
                                    s.lg_first_name.value,
                                    s.lg_last_name.value,
                                    s.phone_number.value,
                                    ftc
                                ]
                            )
                        end
                    end
                    $students.detach(sid)
                }
            else
                puts "No students found for: #{ftc}"
            end
            if !rows.empty?
                rows.insert(0,
                    [
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
                eligible_students.insert(0,["Student ID","First Name","Last Name"])
                tot_stu_completed = (eligible_students.length.to_f - rows.length.to_f)
                percent_eligible_completed = ((tot_stu_completed/eligible_students.length.to_f)*100).truncate
                completetion_rates_by_ftc.push([ftc, percent_eligible_completed])
                student_report_path = $reports.csv(location, "#{filename}_#{ftc.gsub(" ","_")}_eligible_students", eligible_students)
                report_path = $reports.csv(location, "#{filename}_#{ftc.gsub(" ","_")}", rows)
                subject = "#{ftc} Scantron Participation #{percent_eligible_completed}% Complete - #{$idatetime}"
                content = "#{percent_eligible_completed}% of your Scantron assessment students have completed both their math and reading exit exams.
                Attached is a list of your students who are shown to be eligible AND a list of students who have not yet tested.
                The eligible student list is being provide so you can verify that only your eligible students are being included.
                
                If a subject is listed as FALSE the student has not completed the exam for that subject.
                If a subject is listed as TRUE the students has completed the exam for that subject."
                f.send_email(:subject=> subject, :content=> content, :attachment_path => [report_path, student_report_path])
            else
                completetion_rates_by_ftc.push([ftc, "100"])
                puts "All of #{ftc}'s eligible students have taken their Scantron Assesment"
                subject = "Scantron Participation Missing - #{$idatetime}"
                content = "According to the Scantron report all of your students have completed their exams. Attached is a list of your eligible students."
                f.send_email(:subject=> subject, :content=> content, :attachment_path => student_report_path)
            end        
        }
        completetion_rates_by_ftc.insert(0,["FTC","Percent Complete"])
        overall_eligible_students.insert(0,["Student ID","First Name","Last Name","FTC"])
        overall_missing_eligible_students.insert(0,
            [
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
        num_stu_completed = (overall_eligible_students.length.to_f - overall_missing_eligible_students.length.to_f)
        overall_percent_eligible_completed = ((num_stu_completed/overall_eligible_students.length.to_f)*100).truncate
        overall_report_eligible     = $reports.csv("#{location}/Overall", "overall_eligible_students",            overall_eligible_students           )
        overall_report_missing      = $reports.csv("#{location}/Overall", "overall_missing_eligible_students",    overall_missing_eligible_students   )
        completetion_rate_by_ftc    = $reports.csv("#{location}/Overall", "completetion_rate_by_ftc",             completetion_rates_by_ftc           )
        subject = "Overall Scantron Completetion of Math & Reading - #{overall_percent_eligible_completed}% Completed"
        content = "If you'd like me to remove you from the mailing list just let me know :)"
        $team.by_k12_name("Joel Gowman"  ).send_email(:subject=> subject, :content=> content, :attachment_path => [overall_report_eligible, overall_report_missing, completetion_rate_by_ftc])
        $team.by_k12_name("Amanda Mullen").send_email(:subject=> subject, :content=> content, :attachment_path => [overall_report_eligible, overall_report_missing, completetion_rate_by_ftc])
    end
    #---------------------------------------------------------------------------

end

SCANTRON_FTC_NOTIFICATIONS.new