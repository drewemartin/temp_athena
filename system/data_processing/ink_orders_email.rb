#!/usr/local/bin/ruby

class Ink_Orders_Email

    def initialize()
        
        super()
        
        if ENV["COMPUTERNAME"].match(/ATHENA||HERMES/)
            
            @staples_email      = ["Rachael.Conner@staples.com", "kyoung@agora.org", "esaddler@agora.org"]
            @agora_ink_orderer  = ["lcraig@agora.org", "esaddler@agora.org"]
            @admin_email        = ["esaddler@agora.org"]
            
            @processed          = {:orders=>[], :updates=>[]}
            @processed[:orders].push("\"ship to id\",\"item number\",\"qty\",\"deliver to name\",\"budget center\",\"user id\",\"phone number\"")
            @report_path        = String.new
            
            @order_header       = "<tr><td>SHIP TO ID</td><td>ITEM NUMBER</td><td>QTY</td><td>DELIVER TO NAME</td><td>BUDGET CENTER</td><td>USER ID</td><td>PHONE NUMBER</td></tr>"
            @more_info_header   = "<tr><td><u>Last Name</u></td><td><u>First Name</u></td><td><u>Student ID#</u></td></tr>"
            
            process_orders
            update_records
            
            if @processed[:orders].length > 1
                
                @report_path = $reports.save_document({:csv_rows=>@processed[:orders], :category_name=>"Supplies", :type_name=>"Ink Orders"})
                send_order_email
                
            else
                
                puts "There Are No Orders To Send To Staples"
                
            end
            
        end
        
    end
    
    def process_orders
        
        results = $school.ink.ink_by_status(["Pending", "No Staples ID"])
        
        puts "Total Pending Orders: #{results ? results.length : "0"}"
        
        results.each do |result|
            
            sid         = result.fields["studentid"].value
            pid         = result.primary_id
            student     = $students.attach(sid)
            
            if student.active?
                
                address_string  = "#{student.mailing_address.to_user}#{student.mailing_address_line_two.to_user}#{student.mailing_city.to_user}#{student.mailing_state.to_user}#{student.mailing_zip.to_user}".gsub(" ", "").upcase
                
                if confirmed_row = $tables.attach("ink_staples_ids_requested").by_studentid_confirmed_address(sid, address_string)
                    
                    staples_id  = confirmed_row.primary_id
                    ink         = result.fields["ink"].value
                    
                    if ink
                        
                        item_number = $school.ink.staples_item_number_by_ink(ink).value
                        @processed[:orders].push([staples_id, item_number, "1", "#{student.first_name.value} #{student.last_name.value}", "ink supplies", "LCRAIG", "#{student.phone_number.value}"])
                        @processed[:updates].push({:pid=>pid, :type=>"Ordered"})
                        
                    else
                        
                        @processed[:updates].push({:pid=>pid, :type=>"More Info Needed"})
                        
                    end
                    
                else
                    
                    @processed[:updates].push({:pid=>pid, :type=>"No Staples Id"})
                    
                end
                
            else
                
                @processed[:updates].push({:pid=>pid, :type=>"Canceled"})
                
            end
            
            $students.detach(sid)
            
        end if results
        
        puts "Total To Send To Staples: #{@processed[:orders].length-1}"
        
    end
  
    def update_records
        
        if @processed[:updates].length > 0
            
            @processed[:updates].each do |update|
                
                row    = $tables.attach("Ink_Orders").by_primary_id(update[:pid])
                fields = row.fields
                
                case update[:type]
                
                when "Ordered"
                    
                    fields["status"].value = "Ordered"
                    fields["order_date"].value = $idate
                    
                when "No Staples Id"
                    
                    fields["status"].value = "No Staples Id"
                    
                when "More Info Needed"
                    
                    fields["status"].value = "More Info Needed"
                    
                when "Canceled"
                    
                    fields["status"].value = "Canceled"
                    
                end
                
                row.save
                
            end
            
        end
        
    end
  
    def send_order_email
        
        subject = "Agora Ink Orders - ACCOUNT 1059542phl : #{$idate}"
        content = make_table(@processed[:orders])
        
        begin
            
            $base.email.athena_smtp_email(@staples_email, subject, content, @report_path, nil, "agora_ink_orders.csv")
            
        rescue
            
            $base.system_notification("Ink Orders Email Failed.", e.message)
            
        end
        
    end
  
    def make_table(content)
        
        output = "<table border='1'>"
        
        output << @order_header
        
        content.drop(1).each do |row|
            
            output << "<tr>"
            
            row.each do |column|
                
                output << "<td>#{column}</td>"
                
            end
            
            output << "</tr>"
            
        end
        
        output << "</table>"
        
        return output
        
    end
    
end