#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Attendance_Master_Comparison < Base
    
    def initialize()
        super()
        i=0
        schooldays = $school.school_days($idate).reverse
        schooldays = ["2013-05-22"]
        athena_att_master_pids = $tables.attach("Attendance_Master_Athena").primary_ids
        athena_att_master_pids.each do |pid|
            athena_record  = $tables.attach("Attendance_Master_Athena").by_primary_id(pid)
            sid = athena_record.fields["student_id"].value
            perseus_record = $tables.attach("Attendance_Master").by_studentid_old(sid)
            if athena_record && perseus_record
                schooldays.each do |date|
                    a_code = athena_record.fields[date].value
                    p_code = perseus_record.fields[date].value
                    if a_code != p_code
                        puts "sid:#{sid} date:#{date} No Match:'#{a_code}<>#{p_code}'"
                        i+=1
                    end
                end
            else
                puts "No Matching sid for #{sid}"
            end
        end
        puts "#{i} Total Mismatch Records"
    end
    
end

Attendance_Master_Comparison.new