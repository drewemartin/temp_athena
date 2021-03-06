#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"

class Daily_Attendance_4 < Base

    def initialize()
        super()
    end

    def execute_processes
        
        until !(pid = $tables.attach("student_attendance").primary_ids("WHERE logged IS NULL AND mode IS NOT NULL"))
            
            pid = pid[40]
            record = $tables.attach("student_attendance").by_primary_id(pid)
            record.fields["official_code"].set("thinking").save
            puts sid   = record.fields["student_id"].value
            date  = record.fields["date"].value
            $students.process_attendance(
              :student_id => sid,
              :date       => date
            )
            
        end
        
    end
    
end

Daily_Attendance_4.new().execute_processes
