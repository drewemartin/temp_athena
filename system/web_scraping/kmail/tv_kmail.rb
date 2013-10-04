#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/tv_interface"

################################################################################
#Description: 
#Created By: 
################################################################################
class TV_Kmail < TV_Interface
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #---------------------------------------------------------------------------
    def initialize(agent_name) #Default is to students, will be extended to included adults then teachers. 
        
        super()
        @agent_name = agent_name
        @browser    = ''
        
        Struct.new( "KMAIL_DATA",
            :SENDER, #'tep_invites:tv'
            :KMAIL_TYPE, #Student, Administrator
            :RECIPIENT, #studentid, Admin name
            :SUBJECT,
            :CONTENT,
            :ID
        )
        
        @kmail = Struct::KMAIL_DATA.new()
        @kmail_type     = "Student"
        @kmail_id       = ''
        
        @successfull        = false
        #@screen_shot_path   = @base.init_path("#{@base.syspath}kmail/screen_shots")
        @error              = ''
        
        #add functionality to inlude cc and bcc recipients
        
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
    
    #---------------------------------------------------------------------------
    def send
        #first thing to do is to enter the kmail details into the kmail table.
        #db_insert
        if set_creds(@kmail.SENDER)
            @browser = Watir::Browser.new
            set_browser(@browser)
            sign_in
            if @kmail_type == 'Student'
                criteria_value_pair = ["2:#{@kmail.RECIPIENT}"]
                students_search(criteria_value_pair)
                if student_found_select(@kmail.RECIPIENT)
                   # new_kmail_link_xpath    = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/form/div/table/tbody/tr/td/div/ul/li/a"
                    new_kmail_link_xpath    = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/table/tbody/tr/td/div/ul/li/a"
                    new_kmail_link          = @browser.link(:xpath, new_kmail_link_xpath)
                    link_loaded = false
                    until link_loaded
                        if new_kmail_link.exists?  
                            new_kmail_link.click
                            link_loaded = true
                        end
                    end
                    new_window("K-Mail")
                else
                    db_update(false, "Recipient Not Active")
                    return false 
                end
            elsif @kmail_type == 'Administrator'
                goto_kmailbox
                new_kmail
                new_window("K-Mail")
                set_recipient
            end
            set_subject
            set_content
            #set_attachment
            commit_send
            db_update(true)
        else
            $base.system_notification(
                subject = "tv_kmail (#{@agent_name})",
                content = "Failed at `tv_kmail.send` because `Credentials not provided`."
            )
            return false
        end
        
        #put function to clear values
        return @kmail_id
    end
    #---------------------------------------------------------------------------

    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #---------------------------------------------------------------------------
    def db_update(status, error='')
        error_sql = error.empty? ? '' : ",`error` = '#{error}'"
        update_sql =
            "UPDATE kmail
            SET
                `date_time_sent`    = NOW(),
                `successfull`       = #{status},
                `screenshot_path`   = '#{@screenshot_path}'
                #{error_sql}
            WHERE primary_id = '#{@kmail.ID}'"
        $db.query(update_sql, @db_name)
        @browser.close
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def db_insert() #add attachment info once that becomes available. 
        t = Time.new
        date_time_entered = "#{t.strftime("%Y")}-#{t.strftime("%m")}-#{t.strftime("%d")} #{t.strftime("%H")}:#{t.strftime("%M")}:#{t.strftime("%S")}"
        
        if @kmail_type == "Student"
            fields = "`sender`,`kmail_type`,`recipient_studentid`,`subject`,`content`,`date_time_entered`"
            values = "'#{@creds[0]}','#{@kmail_type}','#{@kmail.RECIPIENT}','#{@kmail.SUBJECT}','#{@kmail.CONTENT}','#{date_time_entered}'"
        elsif @kmail_type == "Administrator"
            fields = "`sender`,`kmail_type`,`recipient_name`,`subject`,`content`,`date_time_entered`"
            values = "'#{@creds[0]}','#{@kmail_type}','#{@kmail.RECIPIENT.gsub(":"," ")}','#{@kmail.SUBJECT}','#{@kmail.CONTENT}','#{date_time_entered}'"
        end
        
        insert_sql = 
            "INSERT INTO kmail (#{fields}) VALUES (#{values})"
        $db.query(insert_sql, @db_name)
        @kmail_id = $db.get_data_single("SELECT LAST_INSERT_ID();")[0]
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def new_window(title)   
        new_window_found = false
        until new_window_found
            if @browser.window(:title => title).exists?
                @browser.window(:title => title).use
                new_window_found = true
            end
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def commit_send
        #this need to take a screenshot, name with appropriate labels (perhaps just the kmail id #) and save the path to @screen_shot_path
        #and catch and report any errors to @error
        @browser.link(:text, "Send Now").click
        #find way to verify success, error etc
        @successfull        = true
        @screenshot_path    = ''
        @error              = ''
        #@browser.close
        #new_window("K12 TotalView School")
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def new_kmail
        new_kmail_found = false
        until new_kmail_found
            if @browser.link(:text, /New K-Mail/).exists?
                @browser.link(:text, /New K-Mail/).click
                new_kmail_found = true
            else
                #do some stuff to find new_kmail
            end
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def goto_kmailbox
        kmailbox_found = false
        until kmailbox_found
            if @browser.link(:text, /KMail/).exists?
                @browser.link(:text, /KMail/).click
                kmailbox_found = true
            else
                #do some stuff to find the box
            end
        end 
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_attachment
        att_link1_found = false
        until att_link1_found
            if @browser.link(:text, /Attach files/).exists?
                @browser.link(:text, /Attach files/).click
                att_link1_found = true
            else
                #put stuff here to wait for or find the window
            end
        end
        
        att_link2_found = false
        until att_link2_found
            if @browser.link(:id, "attachmentDialogId").exists?
                @browser.link(:id, "attachmentDialogId").fire_event("onClick")
                att_link2_found = true
            end
        end
        
        input_win_found = false
        until input_win_found
            if @browser.file_field(:title, /File Upload/).exists?
                @browser.file_field(:title, /File Upload/).set("C:/Athena/test.txt")
                input_win_found = true
            else
                #do something
            end
        end  
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_content
        block_reply = "/html/body/div[2]/div/form/div[2]/table/tbody/tr[5]/td[2]/input"
        block       = @browser.checkbox(:xpath, block_reply)
        block.set 
        i = 0
        content_entered = false
        driver = @browser.driver
        driver.switch_to.frame "messageBody_ifr"
        @kmail.CONTENT.each do |c|
            driver.switch_to.active_element.send_keys(c)
            success = true 
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_recipient #this needs some work to deal with the recipients that aren't found
        
        fname = @kmail.RECIPIENT.split(":")[0]
        lname = @kmail.RECIPIENT.split(":")[1]
        
        to_box = @browser.text_field(:value, /Click to Search/)
        
        rolebox = @browser.select_list(:index, 1)
        
        fname_xpath = "/html/body/div[2]/div/div[2]/div/div/form/table/tbody/tr[2]/td[2]/input"
        fname_field = @browser.text_field(:xpath, fname_xpath)
        
        lname_xpath = "/html/body/div[2]/div/div[2]/div/div/form/table/tbody/tr[2]/td[4]/input"
        lname_field = @browser.text_field(:xpath, lname_xpath)
        
        search_button = @browser.input(:value, "Search")
        
        checkbox_path = "/html/body/div[2]/div/div[2]/div/div/div[2]/form/div/table/tbody/tr[2]/td/input"
        checkbox      = @browser.checkbox(:xpath, checkbox_path)
        
        return_button = @browser.input(:value, "Return to Message")
        
        to_box_found = false
        until to_box_found
            if to_box.exists?
                to_box.click 
                to_box_found = true
            end
        end
        
        rolebox_found = false
        until rolebox_found
            if rolebox.exists?
                rolebox.clear
                if @kmail_type == "Administrator"
                    rolebox.select_value("0")
                end
                rolebox_found = true
            end
        end
        
        firstname_found = false
        until firstname_found
            if fname_field.exists?
                fname_field.set fname
                firstname_found = true
            end
        end
        
        lastname_found = false
        until lastname_found
            if lname_field.exists?
                lname_field.set lname
                lastname_found = true
            end
        end
        
        search_button_found = false
        until search_button_found
            if search_button.exists?
                search_button.click
                search_button_found = true
            end
        end
        
        checkbox_found = false
        until checkbox_found
            if checkbox.exists?
                checkbox.set
                checkbox_found = true
            end
        end
        
        return_button_found = false
        until return_button_found
            begin
                if return_button.exists?
                return_button.click
                return_button_found = true
                end
            rescue
                puts "Return to message failed, trying again."
            end   
        end
     
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_subject
        subject_path    = "/html/body/div[2]/div/form/div[2]/table/tbody/tr[2]/td[2]/input"
        #subject_path    = "/html/body/div[2]/div/form/div/table[2]/tbody/tr/td[2]/input"
        subject_field   = @browser.text_field(:xpath, subject_path )
        
        subject_field_found = false
        until subject_field_found
            if subject_field.exists?
                subject_field.set @kmail.SUBJECT
                subject_field_found = true
            end
        end
        
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|A|c|c|e|s|s|o|r|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                  
    public
  
    #---------------------------------------------------------------------------
    def kmail
        return @kmail
    end
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    def kmail_type
      return @kmail_type
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|o|d|i|f|i|e|r|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                  
    public
    
    #---------------------------------------------------------------------------
    def kmail=(arg)
        @kmail.SENDER       = arg[0]
        @kmail.KMAIL_TYPE   = arg[1]
        @kmail.RECIPIENT    = arg[2]
        @kmail.SUBJECT      = arg[3]
        @kmail.CONTENT      = arg[4]
        @kmail.ATTACHMENTS  = arg[5].empty? ? nil : arg[5]
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def kmail_type=(arg)
        @kmail_type = arg
    end
    #---------------------------------------------------------------------------
  
end