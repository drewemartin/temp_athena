#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class Adhoc_Kmail < Base
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #---------------------------------------------------------------------------
    def initialize(sender, subject)
        super()
        
        @recipient_studentids   = get_recipients
        @sender                 = sender
        @subject                = subject
        
        queue_imports
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    public
    
    def queue_imports
        
        puts "Total To Add To Queue: #{@recipient_studentids.length}"
        
        @recipient_studentids.each do |sid|
            student             = $students.attach(sid)
            puts                  student.sid.value
            file                = File.open("#{$paths.imports_path}kmail/content/content.txt")
            content             = file.read
            kmail_content       = insert_keywords(student, content)
            student.queue_kmail(@subject, content, @sender)  
            $students.detach(sid)
        end
        
    end

    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    def get_recipients
        
        recipient_path = "#{$paths.imports_path}kmail/recipients/studentids.csv"
        
        recipient_studentids =[]
        
        CSV.foreach( recipient_path ) do |row|
            if !row.first.nil? && row.first.match(/\d/)
                recipient_studentids <<  row[0]
            end
        end
        
        current_studentids = $students.list(:current_students=>true)

        recipient_studentids.delete_if{|v|
            !current_studentids.include?(v)
        }
        
        return recipient_studentids
    end
    
    #---------------------------------------------------------------------------
    def insert_keywords(recipient, content)
        
        content.gsub!( "“","\"")
        content.gsub!( "”","\"")
        content.gsub!( "’","'")
        content.gsub!( "|student.lcfirstname|",         recipient.lc_first_name.value  )                                if recipient.lc_first_name.value
        content.gsub!( "|student.id|",                  recipient.sid.value  )                                          if recipient.sid.value
        content.gsub!( "|student.firstname|",           recipient.first_name.value )                                    if recipient.first_name.value
        content.gsub!( "|student.lastname|",            recipient.last_name.value  )                                    if recipient.last_name.value
        content.gsub!( "|student.firstnameLastname|",   "#{recipient.first_name.value} #{recipient.last_name.value}")   if recipient.last_name.value
        if content =~ /student.absence_dates/
            unexcused_days = String.new
            unexcused_absences = recipient.attendance.unexcused_absences
            i=0
            unexcused_absences.each_key do |day|
                i+=1
                unexcused_days << "#{Date.parse(day).strftime('%m/%d/%y')}"
                unexcused_days << ", " if unexcused_absences.size != i
            end
            content.gsub!( "|student.absence_dates|",   unexcused_days)
        end
        return Mysql.quote(content)
    end
    #---------------------------------------------------------------------------
  
end

#Accounts
#-------------
#attendance_reports
#lanore_spearing
#joel_gowman
#office_admin #for: A+, SI
#maegan_kern
#nursing
#ispkmail
#colleen_richardson

#Subject Lines
#-------------
#Welcome to Study Island
#Welcome to A+

Adhoc_Kmail.new('office_admin', '**Study Island Login Information**') #