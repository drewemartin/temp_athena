#!/usr/local/bin/ruby

class KMAIL_UPLOAD_WEB
    #---------------------------------------------------------------------------
    def load
        output = String.new
        output << $tools.tab_identifier(1)
        output << "<div id='upload_status'></div>"
        output << $kit.tools.tabs([["Upload", upload], ["Keywords Legend", keywords]])
        return output
    end
    
    def breakaway_caption
        return "Mass Kmail Upload"
    end
    
    def page_title
        return "Kmail"
    end
    
    #--------------------------------------------------------------------------- 
    def response
        
        subject = $kit.params[:subject]     != "" ? $kit.params[:subject    ] : false
        account = $kit.params[:account]     != "" ? $kit.params[:account    ] : false
        content = $kit.params[:content]     != "" ? $kit.params[:content    ] : false
        csv     = $kit.params[:csv_upload]  != "" ? $kit.params[:csv_upload ] : false
        block   = $kit.params[:block_reply] ? "1" : "0"
        
        if subject && account  && content && csv
            
            queue_kmail_from_upload(subject, content, account, csv, block)
            
        else
            
            validation_check
            
        end
        
    end
    #---------------------------------------------------------------------------
    def upload
        
        output = ""
        output << "<form id='upload_form' name='form' action='D20130906.rb' method='POST' enctype='multipart/form-data' >"
        output << $tools.kmailinput("subject", "Subject Line:")
        output << $tools.newselect("account", credentials_dd, "Account To Send From:")
        output << $tools.kmailtextarea("content", "Message of Kmail:")
        output << "<div class='http_message'>If your message includes a link, it must contain the complete web address!  This means that the website must start with \"http://\" or \"https://\"<br><br><span style='color:green'>Good: http://www.google.com</span><br><span style='color:red'>Bad: www.google.com<br>Bad: google.com</span><br><br>Failure to add the complete web address will cause the link ot appear as plain text in the student's inbox.</div>"
        output << $field.new({"type" => "text", "field" => "block_reply", "value"=>"1"}).web.checkbox({:label_option=>"Block Reply", :field_id=>"block_reply", :add_class=>"no_save"})
        output << "<div class='block_message'>Check this box to block replies to your kmail.</div>"
        output << $tools.newlabel("recipients_label", "Choose A .csv Of Recipients To Kmail")
        output << "<div class='csv_message'>Only valid student id's in the first column of the csv are used.</div>"
        output << $tools.csv_upload(self.class.name, "upload_form", "113")
        output << "<input class='submit_button' type='button' name='action' value='Upload and Queue Kmails' onclick='redirect_submit(\"upload_form\")'/>"
        output << $tools.newlabel("bottom")
        output << "</form>"
        return output
        
    end
    
    def queue_kmail_from_upload(subject, message, sender, csv_param, block)
        
        output = String.new
        
        begin
            
            recipients    = Array.new
            success_count = 0
            
            file_path  = $config.init_path("#{$paths.imports_path}kmail")
            serverFile = "#{file_path}#{$ifilestamp}.csv"
            
            i=1
            CSV.open(serverFile, "wb") do |csv|
                
                CSV.parse(csv_param) do |row|
                    
                    if row[0].nil?
                        
                        output << "Warning: Ignoring blank field at row #{i}<br>"
                        
                    elsif row[0].match(/^[0-9]+$/)
                        
                        student = $students.attach(row[0])
                        
                        if student.exists?
                            
                            recipients << row[0]
                            success_count += 1
                            
                        else
                            
                            output << "Warning: SID ##{row[0]} is not an existing Student ID. No kmail will be sent.<br>"
                            
                        end
                        
                        $students.detach(row[0])
                        
                    else
                        
                        output << "Warning: '#{row[0]}' at line #{i} is not a number. No kmail will be sent.<br>"
                        
                    end
                    
                    csv << row
                    
                    i+=1
                    
                end
                
            end
            
            $reports.save_document({:category_name=>"Athena", :type_name=>"Mass Kmail Students List", :file_path=>serverFile})
            
        rescue
            
            output = "Failed to parse and upload csv to Athena<br>"
            
        end
        
        begin
            
            if recipients.length > 0
                
                csv_path = $reports.save_document({:category_name=>"Athena",:type_name=>"Mass Kmail Students List",:csv_rows=>recipients})
                
                $base.queue_process("Queue_Kmails", "mass_kmail", "#{subject}<,>#{message}<,>#{sender}<,>#{csv_path}<,>#{block}")
                
                output << "<br>#{success_count} kmails successfully queued.<br>Actual kmail delivery time to student's inbox varies depending on current queue volume."
                output << "<success>"
                
            else
                
                output << "There were no student id's in your csv. Nothing has been queued."
                
            end
            
        rescue
            
            output = "Upload successful, but there was an error queing the kmails.<br>"
            
        end
        
        $kit.output = output
        
    end
    
    def validation_check
        validation_string = "You did not:<br>"
        validation_string << "Fill out the subject line.<br>" if !@subject
        validation_string << "Select the account to send from.<br>" if !@account
        validation_string << "Create the message of the kmail.<br>" if !@content
        validation_string << "Choose a csv file.<br>" if !@csv
        $kit.output = validation_string
    end
    
    def credentials_dd
        return [
            {:name=>"Agora Office",           :value=>"office_admin"},
            {:name=>"Attendance Office",      :value=>"attendance_reports"},
            {:name=>"ISP",                    :value=>"ispkmail"},
            {:name=>"Nurses",                 :value=>"nursing"},
            {:name=>"Address Change",         :value=>"address_change"},
            {:name=>"Kristin Walters-Seidel", :value=>"kristin_walters_seidel"},
            {:name=>"Yvette Fleming",         :value=>"yvette_fleming"},
            {:name=>"Stephanie Boon",         :value=>"stephanie_boon"},
            {:name=>"Scott Feely",            :value=>"scott_feely"},
            {:name=>"Bill Koch",              :value=>"bill_koch"},
            {:name=>"Regan Shebeck",          :value=>"regan_shebeck"}
        ]
    end
    
    def keywords
        output = $tools.div_open("message")
        output <<
"Keywords are a feature that is built into Total View Kmail, not into the Athena Information System.<br>
They are useful for adding specific student information to a general message designed for multiple recipients.<br><br>
Keywords are used by entering the corresponding keyword surrounded by the \"pipe\" character (shift\>backslash) into the body of your kmail.<br><br>
An example where a student's name is \"John Smith\":<br>
<b>\"Hello |student.firstnameLastname|! Your student id is: |student.id|.\"</b><br><br>
When John opens his kmail, he will read:<br>
<b>\"Hello John Smith! Your student id is: 123456.\"</b><br>
<br>
Please use these keywords below to help personalize your mass kmails.<br>"
        output << $tools.div_close()
        output << $tools.div_open("kmail_keywords")
        records = $tables.attach("Kmail_Keywords").records
        output << $tools.div_open("keyword_left")
        records.each do |record|
            fields = record.fields
            keyword = fields["keyword"].value
            output << "|#{keyword}|<br>"
        end if records
        output << $tools.div_close()
        output << $tools.div_open("keyword_right")
        records.each do |record|
            fields = record.fields
            description = fields["description"].value
            output << "#{description}<br>"
        end if records
        output << $tools.div_close()
        output << $tools.div_close()
        output << $tools.newlabel("bottom")
    end
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        div.subject{                            float:left; clear:left; margin-bottom:10px;}
        div.account{                            float:left; clear:left; margin-bottom:10px;}
        div.content{                            float:left; clear:left; margin-bottom:10px;}
        div.http_message{                       float:right; width:320px; height:190px; font-size:0.9em; border:3px double #2779aa; margin-left: 5px; padding:5px;}
        div.block_message{                      float:right; width:320px; font-size:0.9em; border:3px double #2779aa; margin-left: 5px; padding:5px;}
        div.block_reply{                        float:left; clear:left; margin-bottom:20px;}
        div.recipients_label{                   float:left; clear:left; margin-bottom:10px;}
        input.csv_upload{                       float:left; clear:left; margin-bottom:10px;}
        div.csv_message{                        float:right; width:320px; font-size:0.9em; border:3px double #2779aa; margin-left: 5px; padding:5px;}
        input.submit_button{                    float:left; clear:left; margin-bottom:10px;}
        
        div.subject     label{                  display:inline-block; width:175px;}
        div.account     label{                  display:inline-block; width:175px;}
        div.content     label{                  display:inline-block; width:175px; vertical-align:top;}
        div.block_reply label{                  display:inline-block; width:172px;}
        
        div.subject input{                      width:600px;}
        
        textarea{                               width:600px; height:200px; resize:none; overflow-y:scroll}
        
        div.message{                            float:left; clear:left; padding: 20px 60px; margin-bottom:20px; font-size:1.1em; line-height:1.5em; text-align:center; border-bottom:1px solid #3BAAE3; border-top:1px solid #3BAAE3;}
        div.kmail_keywords_title{               float:left; clear:left; font-size:1.3em; margin-bottom:5px; margin-top:10px;}
        div.kmail_keywords{                     float:left; clear:left; width:100%; border:1px solid #3BAAE3; border-radius: 5px; box-shadow: inset 1px 0px 10px #869BAC; background:url('/athena/images/row_separator_25px.png') repeat left top;}
        div.keyword_left{                       float:left; width:350px; line-height:25px; margin-left:10px;}
        div.keyword_right{                      float:left; width:480px; line-height:25px; margin-left:10px;}
        
        iframe{                                 float:right; display:none;}
        #search_dialog_button{                  display:none;}
        #upload_status{                         text-align:center; overflow-y:scroll;}
        "
        output << "</style>"
        return output
    end

    def javascript
        
    end
end