#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("web_scraping/kmail","base/base")
require 'rubygems'
require 'watir'

class KMAIL_EXECUTE < Base
  
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    #---------------------------------------------------------------------------
    def initialize()
        
        super()
        
        overall_start_time = Time.new
        
        test_i=1
        
        url = "https://totalviewschool.k12.com/cgi-bin/WebObjects/TotalViewVA.woa"
        
        @db_name = $tables.attach("STUDENT_KMAIL").data_base
        
        while kmail_record = grab_kmail
            
            begin
                
                sent = false
                
                kmail_record.fields["sending"].value = "1"
                kmail_record.save
                
                pid     = kmail_record.fields["primary_id" ].value
                sid     = kmail_record.fields["student_id" ].value
                sender  = kmail_record.fields["sender"     ].value
                subject = kmail_record.fields["subject"    ].value + "__" + test_i.to_s
                content = kmail_record.fields["content"    ].value
                block   = kmail_record.fields["block_reply"].value
                
                #xpaths
                sid_xpath        = "/html/body/div/div[2]/div/div/div[2]/div/div[1]/div[2]/div/form/table/tbody/tr[3]/td[2]/input"
                no_results_xpath = "/html/body/div/div[2]/div/div/div[2]/div/div[1]/div[2]/div/p"
                s_checkbox_xpath = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/div[1]/div/div/table/tbody/tr[2]/td[1]/div/input"
                new_kmail_xpath  = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/table/tbody/tr/td/div/ul/li[1]/a"
                subject_xpath    = "/html/body/div[2]/div/form/div[2]/table/tbody/tr[2]/td[2]/input"
                block_xpath      = "/html/body/div[2]/div/form/div[2]/table/tbody/tr[5]/td[2]/input"
                
                puts "\n----------------------------------------"
                puts "SENDING KMAIL ID: #{pid}"
                puts "i = #{test_i.to_s}"
                
                start_time = Time.now
                
                credentials = get_credentials(sender)
                
                #Go to website
                browser = Watir::Browser.new :ff
                browser.goto url
                
                #Log in to TV
                browser.wait_until {browser.text_field(:name,  "username").exists?}
                
                browser.text_field(:name,  "username").set(credentials[:username])
                browser.text_field(:name,  "password").set(credentials[:password])
                browser.button(    :value, "Login"   ).click
                
                #Search for student by id
                browser.wait_until {browser.link(:text, "Students").exists?}
                
                browser.link(:text, "Students").click
                
                browser.text_field(:xpath, sid_xpath).set(sid)
                
                browser.button(:value, "Search").click
                
                #Check for results
                if !browser.p(:xpath, no_results_xpath).exists?
                    
                    #Select student and click "New K-Mail
                    browser.checkbox(:xpath, s_checkbox_xpath).set
                    browser.wait_until {browser.link(:xpath, new_kmail_xpath).exists?}
                    browser.link(:xpath, new_kmail_xpath).click
                    
                    #Switch to new k-mail pop-up
                    browser.wait_until {browser.window(:title => "K-Mail").exists?}
                    browser.window(:title => "K-Mail").use
                    browser.wait_until {browser.iframe(:id,"messageBody_ifr").exists?}
                    
                    #Check "Block Reply" if option is true
                    browser.checkbox(:xpath, block_xpath).set if block == "1"
                    
                    #Set subject
                    browser.text_field(:xpath, subject_xpath).set(subject)
                    
                    #Set content (uses javascript, because the message is located in the body tag of an iframe)
                    content.gsub!(/https*?:\/\/.*?(?=\s)/, '<a href=\"\\0\">\\0</a>') #convert http string to anchor link
                    content.gsub!("'","\\\\'")      #gsub for apostrophe
                    content.gsub!("\r\n", "<br>")   #gsub for carriage return
                    content.gsub!("\n", "<br>")     #gsub for end-line
                    
                    browser.execute_script("
                        var body = document.getElementById(\'messageBody_ifr\').contentDocument.getElementById(\'tinymce\');
                        var existing_html = body.innerHTML;
                        var content = '#{content}';
                        body.innerHTML = content + existing_html;
                    ")
                    
                    #Click send
                    browser.link(:text, "Send Now").click
                    
                    #Flag as sent, because if timeout occurs now, the message will still be delivered.
                    sent = true
                    
                    kmail_record.fields["successful"].value = "1"
                    kmail_record.fields["sending"   ].value = "0"
                    kmail_record.save
                    
                    #Wait for kmail window to close
                    browser.wait_until {!browser.window(:title => "K-Mail").exists?}
                    
                    #Close browser
                    browser.close
                    
                    puts "SUCCESSFUL"
                    
                else
                    
                    #Studend is not active
                    puts "Recipient Not Active"
                    
                    kmail_record.fields["successful"].value = "0"
                    kmail_record.fields["sending"   ].value = "0"
                    kmail_record.fields["error"     ].value = "Recipient not active"
                    kmail_record.save
                    
                    browser.close
                    
                end
                
                end_time   = Time.now
                
                if (start_time - end_time).to_int > 180
                    
                    $base.system_notification(
                        "SLOW KMAILS!",
                        "Kmails are slow. PID #{pid}"
                    )
                    
                end
                
            rescue => e
                
                if e.message == "Timeout::Error" && sent == false
                    
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    puts "Failed on try #{test_i.to_s}"
                    puts "Retrying..."
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    
                    browser.close
                    retry
                    
                elsif e.message == "Timeout::Error" && sent == true
                    
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    puts "Failed to close after send on try #{test_i.to_s}"
                    puts "Not Retrying. Verify that it was sent. (it should be)"
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    
                    kmail_record.fields["error"].value = "verify"
                    kmail_record.save
                    
                    browser.close
                    
                else
                    
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    puts "Failed on try #{test_i.to_s}"
                    puts e.message
                    puts e.backtrace
                    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    
                    kmail_record.fields["error"].value = e.message
                    kmail_record.save
                    
                    browser.close
                    
                end
                
            end
            
            test_i += 1
            
        end
        
        puts "#{(Time.new - overall_start_time)/60} minutes"
        
    end
    #---------------------------------------------------------------------------
    
    def get_credentials(sender)
        
        credentials = Hash.new
        
        record = $tables.attach("CREDENTIALS").record("WHERE task = '#{sender}'")
        
        if record
            
            fields = record.fields
            
            credentials[:username] = fields["credn"].value
            credentials[:password] = fields["credp"].value
            
            return credentials
            
        else
            
            return false
            
        end
        
    end
    
    def grab_kmail
        
        return $tables.attach("STUDENT_KMAIL").record(
            "WHERE sending IS FALSE
            AND successful IS NULL
            ORDER BY created_date ASC
            LIMIT 0,1"
        )
        
    end
    
end

KMAIL_EXECUTE.new