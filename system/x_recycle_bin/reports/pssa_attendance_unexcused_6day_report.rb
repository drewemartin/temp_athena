#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Attendance_Unexcused_6day_Report < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        
        location                        = "Pssa_Attendance/Unexcused_6day"
        filename                        = "pssa_attendance_unexcused_6day"
        
        start_date                      = nil
        end_date                        = nil
        
        all_students_attendance_days    = Hash.new
        rows                            = Array.new
        $students.current_pssa_students.each{|sid|
            student = $students.attach(sid)
            if !student.pssa_assignments.site_id.value.nil? && !student.pssa_assignments.site_start_date.value.nil?
                #CHECKS TO MAKE SURE WE HAVE THE MOST ACCURATE START AND END DATES.
                site_start  = student.pssa_assignments.site_start_date
                site_end    = student.pssa_assignments.site_end_date
                start_date  = site_start    if start_date.nil?  || site_start.mathable  < start_date.mathable
                end_date    = site_end      if end_date.nil?    || site_end.mathable    > end_date.mathable
                
                student_attendance_days = Hash.new
                records = $tables.attach("PSSA_ATTENDANCE").by_studentid_old(sid)
                if records
                    records.each{|row|
                        day  = row.fields["attendance_date"].value
                        code = row.fields["attendance_code"].value
                        if student_attendance_days.has_key?(day) && !student_attendance_days[day].nil?
                            #Check to make sure the correct code is accepted for this attendance day.
                            puts "#{__FILE__} STOP"
                        end
                        if !student_attendance_days.has_key?(day) || student_attendance_days[day].nil? || (student_attendance_days[day] == "unexcused" && code == "present")
                            student_attendance_days[day] = code
                        end
                    }
                    unexcused_tot = 0
                    student_attendance_days.each_pair{|day, code|
                        if code == "unexcused"
                            unexcused_tot += 1
                        end
                    }
                    if unexcused_tot >= 6
                        pssa_absence_dates = String.new
                        date_array = []
                        student_attendance_days.each_pair{|date, code|date_array.push(date) if code == "unexcused"}
                        date_array.sort.each{|date|pssa_absence_dates << "<br>#{date}"}
                        subject = "PSSA Truancy Risk Alert! Student ID: #{sid}"
                        content = "Please be advised that #{student.first_name.value} has accumulated #{unexcused_tot} PSSA absences. <br>Absence Dates: #{pssa_absence_dates}"
                        #$team.by_k12_name(student.family_teacher_coach.value).send_email(:subject=> subject, :content=> content)
                        puts subject
                        puts content
                        all_students_attendance_days[sid] = student_attendance_days 
                    end
                else
                    subject = "PSSA Attendance Report - SID NOT FOUND: #{sid}!"
                    content = "#{__FILE__} #{__LINE__}"
                    $base.system_notification(subject, content)
                end
                
            end   
        }
        
        header_row      = ["Student ID","Name","Grade Level"]
        attendance_days = Array.new
        eval_date       = start_date
        while eval_date.mathable <= end_date.mathable
            if eval_date.is_schoolday?
                header_row.push(eval_date.value)
                attendance_days.push(eval_date.value)
            end
            eval_date.add!
        end
        rows.push(header_row)
        all_students_attendance_days.each_pair{|sid, attendance|
            s = $students.attach(sid)
            this_row    = [sid,s.fullname.value,s.grade.value]
            attendance_days.each{|day|
                this_row.push(attendance[day])
            }
            $students.detach(sid)
            rows.push(this_row)
        }
        
        report_path = $reports.csv(location, filename, rows)
        subject = "Pssa Attendance Unexcused 6 or more days Report - #{$idatetime}"
        content =
        ""
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    #---------------------------------------------------------------------------

end

Pssa_Attendance_Unexcused_6day_Report.new