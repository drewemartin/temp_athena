#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Undo_Changes < Base

    def initialize
        super()
        select_sql =
            "SELECT
                modified_date, 
                modified_by,   
                modified_pid,
                modified_field,
                modified_value,
                `2012-09-04`
            FROM
                zz_attendance_master
            WHERE
                modified_date       REGEXP  '2012-09-05 16:36'  AND
                modified_by         =       'Athena-SIS'  AND
                modified_field      =       '2012-09-04'  AND
                
                `2012-09-04` is not null
                AND `2012-09-04` != ''
            "
        results = $db.get_data(select_sql)
        if results
            results.each{|result|
                modified_date   = result[0]
                modified_by     = result[1]
                modified_pid    = result[2]
                modified_field  = result[3]
                modified_value  = result[4]
                old_value       = result[5] 
                
                record  = $tables.attach("attendance_master").by_primary_id(modified_pid)
                sid     = record.fields["student_id"].value
                record.fields["2012-09-04"].value = old_value
                record.save
            }
        end
    end
    
end

Undo_Changes.new