#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("data_processing","base/base")

class Mark_Sapphire_Student_Active < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        outlook_retrieve_msg
    end
    #---------------------------------------------------------------------------
    
    def outlook_retrieve_msg
        import_path = $config.init_path("#{$paths.imports_path}sapphire_active")
        outlookk    = WIN32OLE.new('Outlook.Application')
        mapi        = outlookk.GetNameSpace('MAPI')
        inbox       = mapi.GetDefaultFolder(6)  ## passing integer 6, which represents the inbox folder.
        inbox.Items.each do |message|  
            if message.Subject == "Sapphire_Active_Student_List" ## 'Suject' method of 'Message' object gives subject of the mail.
                t = Time.new
                filepath_name = nil
                message.Subject = message.Subject + t.strftime(" On %m/%d/%Y at %I:%M%p")
                message.Attachments.each do |attachment|
                    filepath_name = "#{import_path}sapphire_active.csv"
                    attachment.SaveAsFile(filepath_name)
                end
                $tables.attach("sapphire_active").load
                verify_sapphire_import
            end
        end
    end

    def verify_sapphire_import
        active_sids     = $tables.attach("sapphire_active").students_with_records
        reported_active = $tables.attach("sapphire_students").active_sids
        if !(active_sids.sort == reported_active.sort)
            #THERE IS A PROBLEM WITH THE IMPORT
            subject = "SAPPHIRE IMPORT NOT ALIGNED WITH TOTAL VIEW!"
            content = "Clue - Once one is determined"
            $base.system_notification(subject, content)
        end
        
    end
    
    #DECIDED NOT TO MARK THESE ARE ACTIVE IN OUR NOTIVE TABLE, BUT TO CREATE AND MAINTAIN A SEPARATE SAPPHIRE_ACTIVE TABLE.
    #OUR NATIVE TABLE WILL CONTAIN ONLY CHANGES THAT WE REPORTED, AND WE CAN CHECK EACH MORNING TO MAKE SURE THAT THOSE CHANGES WERE IMPORTED TO SAPPHIRE.
    #def mark_students_active(file_path)
    #    skip = true
    #    CSV.foreach(file_path)do|row| ## If CSV filename got saved as "Sapphire_Active_Student_List"
    #        if !skip
    #            sid = row[0]
    #            sapphire_students_table = $tables.attach("Sapphire_Students").by_studentid_old(sid)
    #            if sapphire_students_table
    #                sapphire_students_table.fields["active"].value = 1
    #                sapphire_students_table.save
    #            else
    #                $base.system_notification("Sapphire Student Not Found", "Student ID: #{sid}")
    #            end
    #        else
    #            skip = false
    #        end
    #    end
    #    time_stamp = DateTime.now.strftime("D%Y%m%dT%H%M%S")
    #    File.rename(file_path, file_path.gsub(".csv", "#{time_stamp}.csv"))
    #end


#def mark_student_Active_test
#  CSV.foreach("#{$paths.imports_path}summer_school_grades.csv")do|row|
#   sid = row[0]
#   sapphire_students_table = $tables.attach("Sapphire_Students").by_studentid_old(sid) 
#   if student_id_found
#    sapphire_students_table.fields["active"].value = 1
#    sapphire_students_table.save
#   else
#     send_alert
#   end
#end

#end
end

##### --------- Functions

#outlook_retrieve_msg
#mark_students_active
#send _alert

##### --------------------
    Mark_Sapphire_Student_Active.new