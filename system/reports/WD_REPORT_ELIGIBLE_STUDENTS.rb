#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class WD_REPORT_ELIGIBLE_STUDENTS < Base
    #---------------------------------------------------------------------------
    def initialize()
        super()
    end
    #---------------------------------------------------------------------------
   
    def start
        #Creates csv file and returns file_path.
        students = $students.search(
            :current_students_only      =>  true,
            :withdrawal_eligible_date   =>  true,
            :withdrawal_incomplete      =>  true,
            :withdrawal_not_processed   =>  true
        )
        students.each{|sid|
            
        }
        
    end
end

K8_Present_Report.new