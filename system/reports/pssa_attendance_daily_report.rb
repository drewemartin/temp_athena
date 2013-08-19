#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Attendance_Daily_Report < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        
        attendance_day                  = $field.new({"type"=>"date","value"=>DateTime.now}).sub!#yesterday
        attendance_day_reported         = $db.get_data_single("SELECT * FROM pssa_attendance_reported WHERE `#{attendance_day.to_db}` IS NOT NULL")
        
        location                        = "Pssa_Attendance/Daily"
        filename                        = "pssa_attendance_daily_ATTDAY-#{attendance_day.to_db}"
       
        if !attendance_day_reported && attendance_day.is_schoolday?
            all_students_attendance_days    = Hash.new
            rows                            = Array.new
            $students.current_pssa_students.each{|sid|
                student = $students.attach(sid)
                #if !student.pssa_assignments.site_id.value.nil? && !student.pssa_assignments.site_start_date.value.nil?
                    #student_scheduled_for_attendance_day =
                        #attendance_day.mathable >= student.pssa_assignments.site_start_date.mathable &&
                        #attendance_day.mathable <= student.pssa_assignments.site_end_date.mathable
                    pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").by_student_id(sid)
                    if !pssa_reported_record
                        pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").new_row
                        pssa_reported_record.fields["student_id"].value = sid
                        pssa_reported_record.save
                    end
                    #if student_scheduled_for_attendance_day
                        student_attendance_days = Hash.new
                        records = student.pssa_assignments.attendance_by_date(attendance_day.to_db)
                        if records
                            records.each{|row|
                                day  = row.fields["attendance_date"].value
                                code = row.fields["attendance_code"].value
                                if student_attendance_days.has_key?(day) && !student_attendance_days[day].nil?
                                    #Check to make sure the correct code is accepted for this attendance day.
                                    #the code below needs to be tested in these circumstances
                                    puts "#{__FILE__} STOP"
                                end
                                if !student_attendance_days.has_key?(day) || student_attendance_days[day].nil? || (student_attendance_days[day] == "unexcused" && code == "present")
                                    if !code.nil?
                                        student_attendance_days[day] = code
                                        pssa_reported_record.fields[attendance_day.to_db].value = code
                                    end
                                end
                            }
                            all_students_attendance_days[sid] = student_attendance_days if !student_attendance_days.empty?
                        else
                            #IT'S OK IF THE STUDENT WAS NOT FOUND FOR THIS REPORT BECAUSE IT IS FOR THIS ATTENDANCE DAY ONLY.
                            #$base.system_notification("PSSA Attendance Daily Report - SID NOT FOUND: #{sid}!","#{__FILE__} #{__LINE__}")
                            #puts "PSSA Attendance Daily Report - SID NOT FOUND: #{sid}!"
                        end
                        pssa_reported_record.save
                    #end 
                #end
                $students.detach(sid)
            }
            
            header_row = ["Student ID",attendance_day.to_db]
            rows.push(header_row)
            all_students_attendance_days.each_pair{|sid, attendance|
                if (attendance[attendance_day.to_db] == "present")
                    value = "pssa"
                    rows.push([sid, value])
                elsif (attendance[attendance_day.to_db] == "unexcused")
                    value = "upssa"
                    rows.push([sid, value])
                end 
            }
            
            report_path = $reports.csv(location, filename, rows)
            subject = "PSSA Attendance Daily Report"
            content =
            "Please find the attached PSSA Attendance Daily Report for #{attendance_day.to_user}.
            If a student was marked present at any site, they will be listed as present on this report."
            $base.email.send("jdelguzzo@agora.org", subject, content, priority = nil, attachments = report_path)
            $base.email.send("apickens@agora.org", subject, content, priority = nil, attachments = report_path)
        elsif attendance_day.is_schoolday?
            subject = "Report Failed! - #{filename}"
            content = "#{filename} could not be completed because this attendance day has already been reported."
            $base.system_notification(subject, content)
        end
    end
    #---------------------------------------------------------------------------

end

Pssa_Attendance_Daily_Report.new