#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")
require "#{$paths.system_path}reports/truancy_withdrawals_report"

class Adhoc_Truancy_Withdraws < Base
  
    def initialize
    super()
    
    #Multidimensional array >> ["student_id", "effective_date"]
    students = [
        ["917809","2013-03-04"],
        ["875199","2013-02-19"]
    ]

    students.each{|sid_wd|
        Truancy_Withdrawals_Report.new.generate(
            cutoff              = sid_wd[1],
            official_report     = true,
            exception_students  = [],
            student_list        = [sid_wd[0]]
        )
    }
    end
end

Adhoc_Truancy_Withdraws.new