#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Attendance_Report < Base

    #---------------------------------------------------------------------------
    def initialize(report_name)
        super()
        @structure = nil
        daily_attendance
        #overall_attendance
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def daily_attendance #Run this only if attendance has not been run for that day.
        attendance_day                  = $field.new({"type"=>"date","value"=>DateTime.now}).sub! #yesterday
        all_students_attendance_days    = Hash.new
        rows                            = Array.new
        $students.current_pssa_students.each{|sid|
            student = $students.attach(sid)
            if !student.pssa_assignments.site_id.value.nil? && !student.pssa_assignments.site_start_date.value.nil?
                student_scheduled_for_attendance_day =
                    attendance_day.mathable >= student.pssa_assignments.site_start_date.mathable &&
                    attendance_day.mathable <= student.pssa_assignments.site_end_date.mathable
                pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").by_student_id(sid)
                if !pssa_reported_record
                    pssa_reported_record = $tables.attach("PSSA_ATTENDANCE_REPORTED").new_row
                    pssa_reported_record.fields["student_id"].value = sid
                    pssa_reported_record.save
                end
                if student_scheduled_for_attendance_day
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
                                student_attendance_days[day] = code
                                pssa_reported_record.fields[attendance_day.to_db].value = code
                            end
                        }
                        all_students_attendance_days[sid] = student_attendance_days
                    else
                        subject = "PSSA Attendance Daily Report - SID NOT FOUND: #{sid}!"
                        content = "#{__FILE__} #{__LINE__}"
                        $base.system_notification(subject, content)
                    end
                    pssa_reported_record.save
                end 
            end
            $students.detach(sid)
        }
        
        header_row = ["Student ID",attendance_day.to_db]
        rows.push(header_row)
        all_students_attendance_days.each_pair{|sid, attendance|
            value = attendance[attendance_day.to_db] == "present" ? "pssa" : "upssa"
            rows.push([sid, value])
        }
        
        location                        = "Pssa_Attendance/Daily"
        filename                        = "pssa_attendance_daily_ATTDAY-#{attendance_day.to_db}"
        report_path = $reports.csv(location, filename, rows)
        subject = "PSSA Attendance Daily Report"
        content =
        "Please find the attached PSSA Attendance Daily Report for #{attendance_day.to_user}.
        If a student was marked present at any site, they will be listed as present on this report."
        $base.email.send("jdelguzzo@agora.org", subject, content, priority = nil, attachments = report_path)
        #$team.by_k12_name("Ashley Pickens").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
    def overall_attendance
        location                        = "Pssa_Attendance/Overall"
        filename                        = "pssa_attendance_overall"
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
                    all_students_attendance_days[sid] = student_attendance_days
                else
                    subject = "PSSA Attendance Report - SID NOT FOUND: #{sid}!"
                    content = "#{__FILE__} #{__LINE__}"
                    $base.system_notification(subject, content)
                end
                
            end   
        }
        
        header_row      = ["Student ID"]
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
            this_row    = [sid]
            attendance_days.each{|day|
                this_row.push(attendance[day])
            }
            rows.push(this_row)
        }
        
        report_path = $reports.csv(location, filename, rows)
        subject = "PSSA Attendance Overall Report - #{$idatetime}"
        content =
        "Please find the attached PSSA Attendance Report.
        If a student was marked present at any site, they will be listed as present on this report."
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
    def overall_attendance_modified
        location                        = "Pssa_Attendance/Overall_Modified"
        filename                        = "pssa_attendance_overall_modified"
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
                    all_students_attendance_days[sid] = student_attendance_days
                else
                    subject = "PSSA Attendance Report - SID NOT FOUND: #{sid}!"
                    content = "#{__FILE__} #{__LINE__}"
                    $base.system_notification(subject, content)
                end
                
            end   
        }
        
        header_row      = ["Student ID"]
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
            this_row    = [sid]
            attendance_days.each{|day|
                this_row.push(attendance[day])
            }
            rows.push(this_row)
        }
        
        report_path = $reports.csv(location, filename, rows)
        subject = "PSSA Attendance Overall Report - #{$idatetime}"
        content =
        "Please find the attached PSSA Attendance Report.
        If a student was marked present at any site, they will be listed as present on this report."
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

end

test = Pssa_Attendance_Report.new(ARGV)