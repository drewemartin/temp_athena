#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("data_processing","base/base")

class K6_Progress_Snapshot < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        term = "Q4"
        k6_students(term)
    end
    #---------------------------------------------------------------------------
    
    def k6_students(term)
        $tables.attach("K6_Progress").students_with_records.each{|sid|
            student = $students.attach(sid)
            if student.grade.match(/K|1st|2nd|3rd|4th|5th|6th/i)
                student.progress.term = term
                student.progress.progress_snapshot
                student.progress.masteries_snapshot
            end
        } 
    end
    
end

K6_Progress_Snapshot.new