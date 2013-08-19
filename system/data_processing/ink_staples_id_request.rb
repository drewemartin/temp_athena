#!/usr/local/bin/ruby

class Ink_Staples_Id_Request

    def initialize(reinit = false, override = false)
        
        super()
        
        @reinit = reinit
        
        @csv_path    = String.new
        @needs_id    = Array.new
        
        if ENV["COMPUTERNAME"] == "ATHENA" || override
            
            begin
                
                process_students
                
            rescue=>e
                
                $base.system_notification("Ink Requests Processing Failed.", e.message)
                
            end
                
            if @needs_id.length > 0
                
                @csv_path = $reports.save_document({:csv_rows=>@needs_id, :category_name=>"Supplies", :type_name=>"Ink ID Requests"})
                
                email_csv
                
            end
            
        end
        
    end
  
    def process_students
        
        $students.current_students.each do |sid|
            
            s = $students.attach(sid)
            
            add_id = true
            
            address_string = "#{s.mailing_address.to_user}#{s.mailing_address_line_two.to_user}#{s.mailing_city.to_user}#{s.mailing_state.to_user}#{s.mailing_zip.to_user}".gsub(" ", "").upcase
            
            requested_rows = $tables.attach("Ink_Staples_Ids_Requested").by_studentid_old(sid)
            
            requested_rows.each do |row|
                
                fields = row.fields
                
                if fields["address_string"].value == address_string && !@reinit
                    
                    add_id = false
                    
                end
                
                add_id = false if $tables.attach("Ink_Staples_Ids_Requested").confirmed_record(sid, address_string)
                
            end if requested_rows
            
            if add_id
                
                if !@reinit
                    
                    row = s.new_row("Ink_Staples_Ids_Requested")
                    fields  = row.fields
                    fields["confirmed"     ].value = "0"
                    fields["address_string"].value = address_string
                    row.save
                    
                else
                    
                    row = $tables.attach("Ink_Staples_Ids_Requested").unconfirmed_record(sid, address_string)
                    
                    if !row
                        
                        row = s.new_row("Ink_Staples_Ids_Requested")
                        fields  = row.fields
                        fields["confirmed"     ].value = "0"
                        fields["address_string"].value = address_string
                        row.save
                        
                    else
                        
                        fields = row.fields
                        
                    end
                    
                end
                
                
                ship_to_id = fields["primary_id"].value
                
                if s.mailing_address.to_user.match(/^p.*box.*$|^rr/i)
                    
                    next
                    
                end
                
                if match = s.mailing_address.to_user.match(/p.*box.*$/i)
                    
                    s.mailing_address.value.gsub!(match.to_s, "")
                    
                end
                
                if s.mailing_address_line_two.value
                    
                    if s.mailing_address_line_two.value.match(/DO NOT SHIP/)
                        
                        s.mailing_address_line_two.value = ""
                        
                    end
                    
                    if match = s.mailing_address_line_two.to_user.match(/p.*box.*$/i)
                        
                        s.mailing_address_line_two.value.gsub!(match.to_s, "")
                        
                    end
                    
                end
                
                if match = s.mailing_address.to_user.match(/ apt.*$|,apt.*$|apartment.*$/i)
                    
                    s.mailing_address.value.gsub!(match.to_s, "")
                    
                    if s.mailing_address_line_two.value
                        
                        s.mailing_address_line_two.value << match.to_s
                        
                    else
                        
                        s.mailing_address_line_two.value = match.to_s
                        
                    end
                    
                end
                
                @needs_id.push(
                    
                    [
                        "RESIDENTIAL",
                        "CONSISTENT W/ALL OTHER EXISTING LOCATIONS",
                        "#{ship_to_id}".slice(0,15),
                        "#{s.first_name.to_user} #{s.last_name.to_user}".slice(0,35),
                        "#{s.mailing_address.to_user}".slice(0,35),
                        "",
                        "#{if s.mailing_address_line_two.value && !s.mailing_address_line_two.value.match(/DO NOT SHIP/) then s.mailing_address_line_two.to_user.slice(0,35) else "" end}",
                        "#{s.mailing_city.to_user}".slice(0,19),
                        "#{s.mailing_state.to_user}".slice(0,2),
                        "#{s.mailing_zip.to_user}",
                        "",
                        "",
                        ""
                    ]
                    
                )
                
            end
            
            $students.detach(sid)
            
        end
        
    end
    
    def email_csv
        
        subject = "Agora Shipto Id Request - Manual Action Needed : #{$idate}"
        content = "The rows in the attached csv need to be manually copied an pasted into the Excel template that Staples needs for adding new students into their system."
        email   = ["lcraig@agora.org", "esaddler@agora.org"]
        
        begin
            
            $base.email.athena_smtp_email(email, subject, content, @csv_path, nil, "shipto_id_request.csv")
            
        rescue => e
            
            $base.system_notification("Manual Ink Requests Email Failed", e.message)
            
        end
        
    end
    
    def make_staples_xls(rows)#No longer used, but may be good to keep an a reference for XLS generation (if we ever are masochistic enough to try automating excel files again...)
        
        i=4
        require "win32ole"
        excel = WIN32OLE::new('excel.Application')
        book  = excel.Workbooks.Open("#{$paths.templates_path}Staples_Id_Request_Template.xls")
        sheet = book.worksheets("Shiptos Only")
        
        rows.each do |row|
            
            j=0
            
            ("a".."j").each{|letter|
                
                sheet.range("#{letter}#{i}").value = row[j]
                
                j+=1
            }
            
            i+=1
            
        end
        
        file_path = $config.init_path("#{$paths.reports_path}ink_orders/Staples_Id_Requests/")   
        save_path = "#{file_path}shipto_id_request_#{$ifilestamp}.xls"
        
        @report_path = save_path
        
        book.SaveAs(save_path.gsub("/","\\"))
        
        book.close
        excel.Quit
        
    end

end