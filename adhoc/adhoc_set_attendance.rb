#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class Adhoc_Set_Attendance < Base

  #---------------------------------------------------------------------------
  def initialize()
      super()
      
  end
  #---------------------------------------------------------------------------
  
    def attendance_update_report
        dates = ["2012-10-22","2012-10-23","2012-10-24","2012-10-25","2012-10-26","2012-10-29","2012-10-30","2012-10-31","2012-11-01"]
        pids = $tables.attach("Student_Attendance").primary_ids(
            "WHERE (date IN('2012-10-22','2012-10-23','2012-10-24','2012-10-25','2012-10-26','2012-10-29','2012-10-30','2012-10-31','2012-11-01'))
            GROUP BY student_id"
        )
        
        report_array    = [
            #HEADERS
            ["pid","2012-10-22","2012-10-23","2012-10-24","2012-10-25","2012-10-26","2012-10-29","2012-10-30","2012-10-31","2012-11-01"]
        ]
       
        pids.each do |pid|
          
            sid             = $tables.attach("Student_Attendance").by_primary_id(pid).fields["student_id" ].value
            att_pid         = $tables.attach("Attendance_Master").by_studentid_old(sid).fields["primary_id"].value
            row             = [att_pid]
            att_record      = $tables.attach("Attendance_Master").by_studentid_old(sid)
            streak_broken   = false
            
            puts sid
            
            dates.each do |date|
                
                student_enrolled    = false
                student_att_record  = $tables.attach("Student_Attendance").by_studentid_old(sid, date)
                if student_att_record && !(student_att_record.fields["mode"].value.match(/withdrawn|sed changed/i))
                    student_enrolled = true
                end 
                
                if student_enrolled
                    
                    field       = att_record.fields[date]
                    date_sub    = $field.new("type"=>"date","value"=>date).sub
                    
                    if !streak_broken && consecutive_absences(3, date_sub, sid)
                        
                        if field
                            if field.value == "u" || field.value.nil?
                                row.push("ur")
                            else
                                row.push("")
                            end
                        else
                            puts sid
                            break
                        end
                        
                    else
                        
                        if field
                            if field.value == "u" || field.value.nil?
                                row.push("pr")
                                streak_broken = true
                            else
                                row.push("")
                            end
                        else
                            puts sid
                            break
                        end
                        
                    end
                 
                else
                    row.push("")
                end
                
            end
            
            report_array.push(row)
            
        end
        
        $reports.csv("change_by_pid", "change_by_pid_#{$ifilestamp}", report_array)
        
    end
  
  
    def consecutive_absences(target_number, cutoff, sid)
        school_days = $school.school_days(cutoff)
        if school_days
            truancy_span = school_days.slice(-target_number, target_number)
            if truancy_span
                #if !exception_students.include?(sid)
                #IGNORE STUDENTS WHO ARE UNDER REVIEW
                student   = $students.attach(sid)
                absences  = student.attendance.unexcused_absences
                if absences && absences.length >= target_number
                    
                    truancy_dates = Array.new
                    
                    absences.each_pair do |date, details|
                        if truancy_span.include?(date)
                            truancy_dates.push(date)
                        end
                    end
                    
                    if truancy_dates.length >= target_number
                        return true
                    end
                end
            end
        end
        return false
    end
end

Adhoc_Set_Attendance.new.attendance_update_report