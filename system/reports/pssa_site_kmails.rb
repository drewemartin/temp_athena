#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Site_Kmails < Base

    #---------------------------------------------------------------------------
    def initialize(report_name)
        super()
        @structure = nil
        
        reminder
        
        #adhoc_content_by_site
        
        #subject             = "|student.firstnameLastname| is in danger of being withdrawn for truancy for non-attendance at PSSA testing"
        #content_path        = "rollover_assignments_week_one"
        #student_list_path   = "student_list_rollover_assignments_week_one"
        #adhoc_content_by_student_list(subject, content_path, student_list_path)
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def adhoc_content_by_site
        content_folder  = "pssa_site_reminder_MONTGOMERY"
        site_id         = "24"
        
        content = File.open("#{$config.import_path}pssa_site_kmail_content/#{content_folder}.txt", "rb").read
        sender = "agorapssa"
        rows = Array.new
        rows.push(["Student ID","Subject","Content"])
        $students.current_pssa_students.each{|sid|
            stu = $students.attach(sid)
            if stu.pssa_assignments.site_id && stu.pssa_assignments.site_id.value == site_id
                subject = "|student.firstnameLastname| is in danger of being withdrawn for truancy for non-attendance at PSSA testing"
                stu_content = content.dup
                merge_content(stu_content)
                stu.queue_kmail(subject, content, sender)
                rows.push([sid,subject,content])
            end
        }
        location    = "Pssa_Site_Adhoc_Kmails"
        filename    = "pssa_site_adhoc_kmail"
        report_path = $reports.csv(location, filename, rows)
        subject     = "PSSA Site Adhoc Kmail Report"
        content     = "Please find the attached PSSA Site Adhoc Kmail Report."
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
    def adhoc_content_by_student_list(subject, content_file, student_list_path)
        content = File.open("#{$config.import_path}pssa_site_kmail_content/#{content_file}.txt", "rb").read
        sender  = "agorapssa"
        rows    = Array.new
        rows.push(["Student ID","Subject","Content"])
        CSV.open( "#{$config.import_path}pssa_site_kmail_content/#{student_list_path}.csv" , 'r' ) do |row|
            sid = row[0]
            stu = $students.attach(sid)
            subject = "|student.firstnameLastname| is in danger of being withdrawn for truancy for non-attendance at PSSA testing"
            stu_content = merge(stu, content.dup)            
            stu.queue_kmail(subject, stu_content, sender)
            rows.push([sid,subject,stu_content])
        end
        location    = "Pssa_Site_Adhoc_Kmails"
        filename    = "pssa_site_adhoc_kmail"
        report_path = $reports.csv(location, filename, rows)
        subject     = "PSSA Site Adhoc Kmail Report"
        content     = "Please find the attached PSSA Site Adhoc Kmail Report."
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
    def reminder
        rows = Array.new
        rows.push(["Student ID","Subject","Content"])
        site_start_date = date_of_next("Monday").to_db
        $students.current_pssa_students.each{|sid|
          stu            = $students.attach(sid).pssa_assignments
          stu_start_date = stu.site_start_date
          if stu_start_date && stu_start_date.to_db == site_start_date
            rows.push(stu.queue_site_reminder_kmail) unless stu.site_name.value == "Montgomery"
          end    
        }
        location    = "Pssa_Site_Reminder_Kmails"
        filename    = "start_date_#{site_start_date}_pssa_site_reminders"
        report_path = $reports.csv(location, filename, rows)
        subject     = "PSSA Site Reminder Kmail Report - #{site_start_date}"
        content     = "Please find the attached PSSA Site Reminders Kmail Report for Start Date #{site_start_date}"
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

    def merge(stu, stu_string)
        stu = stu.pssa_assignments
        site_address    = "#{stu.site_address.value} #{stu.site_city.value} #{stu.site_state.value} #{stu.site_zip_code.value}"
        site_name       = stu.site_name.value
        stu_string.gsub!("|site_address|",  site_address)
        stu_string.gsub!("|site_name|",     site_name)
        return stu_string
    end
end

test = Pssa_Site_Kmails.new(ARGV)