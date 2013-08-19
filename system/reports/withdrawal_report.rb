#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Withdrawal_Report < Base
    
    #---------------------------------------------------------------------------    
    #DEPENDENCIES:
    #      Attendance_Master
    #      Jupiter_Grades
    #      K12_Aggregate_Progress
    #      K12_All_Students
    #      K12_Calms_Aggregate_Progress
    #      K12_Ecollege_Detail
    #      K12_Omnibus
    #      K12_Withdrawal
    #      Withdrawing
    #      Withdrawing_Truancy
    #---------------------------------------------------------------------------
    #FUTURE FEATURES:
    #   This should output a report of: 
    #       students who qualified for withdrawal for today
    #       students who's records were marked as complete because they will never qualify
    #       students who's records remain incomplete because they didn't qualify today
    #---------------------------------------------------------------------------
    def initialize
        super()
        adhoc = [] #add student id's here to withdraw adhoc
        adhoc.each{|sid|$students.attach(sid).withdrawal.generate_report}
        
        #Withdrawals - Truancy
        wd      = $tables.attach("Withdrawing_Truancy")
        records = wd.records_to_process
        if records
          records.each{|record|
            $students.attach(record.fields["student_id"].value).withdrawal.generate_report(record)
            sleep 2
          }
        end
        
        #Withdrawals - Requested
        wd      = $tables.attach("Withdrawing")
        records = wd.records_to_process
        if records
          records.each{|record|
            $students.attach(record.fields["student_id"].value).withdrawal.generate_report(record)
            sleep 2
          }
        end
    end
    #---------------------------------------------------------------------------
    
end

Withdrawal_Report.new