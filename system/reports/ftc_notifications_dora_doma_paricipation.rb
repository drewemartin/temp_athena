#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class FTC_NOTIFICATIONS_DORA_DOMA_PARICIPATION < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        test_start_date                 = $field.new("date", "2012-05-01")
        source_report_runtime           = "5/23/2012 at 6:37pm"
        location                        = "Dora_Doma/Exit_Participation_Missing"
        filename                        = "dora_doma_exit_participation_missing"
        
        rows        = Array.new
        
        $team.family_teacher_coaches.each{|ftc|
            rows        = Array.new
            f           = $team.by_k12_name(ftc)
            staff_id    = f.samsid.value
            if students = $students.dora_doma_assessment_eligible_by_ftc(staff_id) #FNORD - Still need criteria for this
                students.each{|sid|
                    s = $students.attach(sid)
                    if !(s.dora_exam_date > test_start_date.mathable || s.doma_exam_date > test_start_date.mathable) 
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
                report_path = $reports.csv(location, "#{filename}_#{ftc.gsub(" ","_")}", rows)
                subject = "DORA DOMA Participation Missing - #{$idatetime}"
                content = "Please find the attached DORA DOMA Participation Missing Report for your students.
                This information is based on the results of a DORA DOMA report run on #{source_report_runtime}."
                #f.send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
            else
                puts "All of #{ftc}'s eligible students have taken their Scantron Assesment"
                subject = "DORA DOMA Participation Missing - #{$idatetime}"
                content = "According to the DORA DOMA report run on #{source_report_runtime} all of your students have completed their exams."
                #f.send_email(:subject=> subject, :content=> content)
            end        
        }
        
    end
    #---------------------------------------------------------------------------

end

FTC_NOTIFICATIONS_DORA_DOMA_PARICIPATION.new