#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Attendance_Modified_Report < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        
        attendance_days                 = Array.new
        $tables.attach("PSSA_ATTENDANCE_REPORTED").fields.each_key{|field_name|
            if !field_name.match(/student_id|primary_id|created_by|created_date/)
                reported = $db.get_data_single("SELECT * FROM pssa_attendance_reported WHERE `#{field_name}` IS NOT NULL")
                attendance_days.push(field_name) if reported
            end
        }
        
        attendance_corrected_days = Array.new
        
        location                        = "Pssa_Attendance/Modified"
        filename                        = "pssa_attendance_modified"
       
        all_students_modified_days      = Hash.new
        rows                            = Array.new
        $students.current_pssa_students.each{|sid|
            student = $students.attach(sid)
            student_current_attendance = Hash.new
            attendance_days.each{|date|
                current_records = student.pssa_assignments.attendance_by_date(date)
                if current_records
                    current_records.each{|row|
                        day  = row.fields["attendance_date"].value
                        code = row.fields["attendance_code"].value
                        if student_current_attendance.has_key?(day) && !student_current_attendance[day].nil?
                            #Check to make sure the correct code is accepted for this attendance day.
                            #the code below needs to be tested in these circumstances
                            puts "#{__FILE__} STOP"
                        end
                        if !student_current_attendance.has_key?(day) || student_current_attendance[day].nil? || (student_current_attendance[day] == "unexcused" && code == "present")
                            student_current_attendance[day] = code
                        end
                    }
                else
                    subject = "PSSA Attendance Daily Report - SID NOT FOUND: #{sid}!"
                    content = "#{__FILE__} #{__LINE__}"
                    $base.system_notification(subject, content)
                end
                
                #Check current attendance against reported, capture changes for report. Update attendance_reported to include changes.
                pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").by_student_id(sid)
                if !pssa_reported_record
                    pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").new_row
                    pssa_reported_record.fields["student_id"].value = sid
                    pssa_reported_record.save
                end
                student_modified_days = Hash.new
                student_current_attendance.each_pair{|day, code|
                    unchanged = pssa_reported_record.fields[day].value == code
                    unless unchanged
                        attendance_corrected_days.push(day) if !attendance_corrected_days.include?(day)
                        student_modified_days[day] = code
                        pssa_reported_record.fields[day].value = code
                        pssa_reported_record.save 
                    end
                }
                all_students_modified_days[sid] = student_modified_days if !student_modified_days.empty?
            }
            $students.detach(sid)
        }
        
        if attendance_corrected_days.length > 0
            header_row = ["Student ID"]
            attendance_corrected_days.sort!
            attendance_corrected_days.each{|date| header_row.push(date)}
            rows.push(header_row)
            all_students_modified_days.each_pair{|sid, attendance|
                student_row = [sid]
                attendance_corrected_days.each{|day|
                    if attendance.has_key?(day)
                        if (attendance[day] == "present")
                            value = "pssa"
                        elsif (attendance[day] == "unexcused")
                            value = "upssa"
                        else
                            value = "USE REGULAR ATTENDANCE"
                        end
                    else
                        value = "NO CHANGE"
                    end
                    
                    student_row.push(value)
                }
                
                rows.push(student_row)
            }
            
            report_path = $reports.csv(location, filename, rows)
            subject = "PSSA Attendance Modified Report"
            content =
            "Please find the attached PSSA Attendance Modified Report.
            If a student was marked present at any site, they will be listed as present on this report."
            $base.email.send("jdelguzzo@agora.org", subject, content, priority = nil, attachments = report_path)
            $base.email.send("apickens@agora.org", subject, content, priority = nil, attachments = report_path)
        end
        
    end
    #---------------------------------------------------------------------------

end

Pssa_Attendance_Modified_Report.new