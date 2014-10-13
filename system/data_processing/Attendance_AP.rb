#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Attendance_AP < Base

    def initialize(arg = [])
        super()
        send(arg) if !arg.empty?
    end
    
    def create_attendance_records(att_date = $idate)
        
        if $field.is_schoolday?(att_date)
            
            sids = $students.list(:currently_enrolled=>true, :overall_attendance_mode=>"Academic Plan")
            sids.each{|sid|
                
                academic_team_records = $students.get(sid).related_team_records(:academic_plan)
                if academic_team_records
                    
                    academic_team_records.each{|record|
                        
                        staff_id = record.fields["staff_id"].value
                        if !$tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(sid, staff_id, att_date)
                            
                            record = $tables.attach("STUDENT_ATTENDANCE_AP").new_row
                            
                            record.fields["student_id"               ].value = sid
                            record.fields["staff_id"                 ].value = staff_id
                            record.fields["date"                     ].value = att_date
                            
                            record.save
                            
                        end
                        
                    }
                    
                else
                    
                    $base.system_notification(
                        subject = "Student has no Academic Plan Team! - STUDENTID: #{sid}",
                        content = "Please identify why this student has no active `Student Relate` records."
                    )
                    
                end
                
                
            } if sids
            
        end
        
    end
    
    def notice_ap_attendance(att_date = $idate, staff_ids = nil)
        
        if $field.is_schoolday?(att_date)
            
            if staff_ids.nil?
                
                staff_ids = $tables.attach("STUDENT_ATTENDANCE_AP").staff_ids("WHERE date = '#{att_date}'")
                
            elsif staff_ids.class == String
                
                staff_ids = staff_ids.split(",")
                
            end
            
            staff_ids.each{|staff_id|
                
                student_table = Array.new
                student_table.push(
                    [
                        "Student ID",
                        "First Name",
                        "Last Initial",
                        "Phone Number",
                        "Learning Coach",
                        "Legal Guardian"
                    ]
                )
                sids = $tables.attach("STUDENT_ATTENDANCE_AP").studentids_by_staffid(staff_id, att_date)
                sids.each{|sid|
                    
                    stu = $students.get(sid)
                    student_table.push(
                        [
                            sid,
                            stu.studentfirstname.value,
                            stu.studentlastname.value[0].chr.insert(-1, "."),
                            stu.studenthomephone.to_phone_number,
                            "#{stu.lcfirstname.value} #{stu.lclastname.value}",
                            "#{stu.lgfirstname.value} #{stu.lglastname.value}",
                        ]
                    )
                    
                }
                
                t = $team.by_sams_id(staff_id)
                notification_subject = "NOTICE! You have Academic Plan Students today."
                notification_content =
                    "Please go to www.athena-sis.com/academic-plan-attendance today to mark Academic Plan Attendance for the following students:<br><br>"+
                    $base.web_tools.table(
                        :table_array    => student_table,
                        :unique_name    => "students",
                        :footers        => false,
                        :head_section   => false,
                        :title          => false,
                        :caption        => false
                    )+
                    "<br><br>Thank You!<br><br>"
                
                if t
                    
                    email_list = ["crivera@agora.org",t.preferred_email.value]
                    email_list += $software_team
                    
                    file_path = $reports.csv("temp", "academic_plan_students", student_table)
                    $base.email.athena_smtp_email(
                        
                        recipients    = email_list,
                        subject       = notification_subject,
                        content       = notification_content,
                        attachments   = file_path
                        
                    )
                    File.delete(file_path)
                    
                else
                    
                    $base.system_notification(
                        subject = "Team Member Not Found! - SAMSID: #{staff_id}",
                        content = notification_subject + notification_content
                    )
                    
                end
                
            } if staff_ids
            
        end
        
    end
    
end

Attendance_AP.new(ARGV)
