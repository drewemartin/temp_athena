#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Student_TEP_Update < Base

  def initialize()
    super()
    
  end

  def add_new_absences
    
    sids = $students.list(:currently_enrolled=>true)
    sids.each{|sid|
      
      s = $students.attach(sid)
      
      if !(u_days = s.attendance.unexcused_absences).empty?
        
        u_days.each_key{|u_date|
          
          if !($tables.attach("STUDENT_TEP_ABSENCE_REASONS").by_studentid_old(sid, u_date))
            
            record = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").new_row
            record.fields["student_id"   ].value = sid
            record.fields["att_date"     ].value = u_date
            record.fields["reason"       ].value = nil
            record.fields["agora_action" ].value = "Kmail notification regarding the absence. Family Coach called Learning Coach/Legal Guardian regarding the absence."
            record.fields["excused"      ].value = false
            record.save
            
          end
          
        }
        
      end
      
    }
    
  end
  
  def update_tep_absences
    
    unexcused_codes   = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE code_type = 'unexcused'", {:value_only=>true})
    
    pids = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").primary_ids
    pids.each{|pid|
      
      record    = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").by_primary_id(pid)
      sid       = record.fields["student_id"].value
      att_date  = record.fields["att_date"  ].value
      
      att_field = $tables.attach("attendance_master").field_bystudentid(att_date, sid)
      if att_field && !unexcused_codes.include?(att_field.value)
        record.fields["excused"].value = true
        record.save
      end
      
    }
    
  end
  
end