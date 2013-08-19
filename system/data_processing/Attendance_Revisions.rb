#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Attendance_Revisions < Base
  
  def update_complete_for_date_range(start_date, end_date, new_value)
    $school.schooldays_by_range(start_date, end_date).each do |att_date|
      if new_value
        complete_status = "0"
        
      att_records = $tables.attach("student_attendance").students_with_records_by_date(att_date, new_value)
      if att_records
        att_records.each do |sid|
          att_field = $tables.attach("student_attendance").field_bystudentid("complete", sid, att_date)
          att_field.value = new_value
          att_field.save
        end
      end
    end
  end
  
end