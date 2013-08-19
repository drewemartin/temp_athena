#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Metrics_Student_Snapshot < Base

    #---------------------------------------------------------------------------    
    #DEPENDENCIES:
    #       Attendance_Master
    #       K12_All_Students
    #       K12_Omnibus
    #       K12_STI_Combined 
    #   Jupiter_Grades
    #       K12_Aggregate_Progress
    #       K12_All_Students
    #   K12_Calms_Aggregate_Progress
    #   K12_Ecollege_Detail
    #       K12_Omnibus
    #       K12_Transcripts
    #       K12_Withdrawal
    #       Scantron_Performance
    #       Rtii_Tier_Levels
    #       Pssa
    #---------------------------------------------------------------------------
    def initialize()
        super()
        $students.current_students.each{|sid|
            student = $students.attach(sid)
            student.metrics.snapshot
            $students.detach(sid)
        } 
    end
    #---------------------------------------------------------------------------
    
end

Metrics_Student_Snapshot.new