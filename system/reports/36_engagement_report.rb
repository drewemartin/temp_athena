#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Low_Scoring_Engaged_Students < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        location                        = "Grade_k_thru_6/Low_Scoring_Students"
        filename                        = "low_scoring_students"
        rows = Array.new
        rows.push( ["Student ID", "Class", "Grade"] )
        $students.current_k6_students.each{|sid|
            s = $students.attach(sid)
            s.progress.term = "Q3"
                if records = s.progress.progress
                    records.each{|record|
                    c = record.fields["course_subject_school"].value
                    if c.match(/Language Arts|Literature|Mathematics|Spelling|Phonics/)
                        p = record.fields["progress"]
                        if p.mathable < 0.60
                            rows.push([sid,c,p.to_user])
                        end
                    end
                }
            end
            $students.detach(sid)
        }
        report_path = $reports.csv(location, filename, rows)
        subject     = "K - 6th Grade Low Scoring Student Report"
        content     = "Please find the attached Low Scoring Engaged Student Report."
        
        $team.by_k12_name("Bruce Elliott"   ).send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
        $team.by_k12_name("Michael Floyd"   ).send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
        $team.by_k12_name("Michele Buck"    ).send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
        $team.by_k12_name("Nicole Harvey"   ).send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    #---------------------------------------------------------------------------

end

Low_Scoring_Engaged_Students.new