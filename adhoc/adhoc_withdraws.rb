#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Adhoc_Withdraws < Base
    
    def initialize()
        
        super()
        
        csv_path = "#{$paths.imports_path}adhoc_withdraws.csv"
        
        i=0
        
        CSV.open(csv_path, "rb").each do |csv_row|
            
            if i==0
                i+=1
                next
            end
            
            sid            = csv_row[0]
            agora_reason   = "5"
            k12_reason     = "C2"
            effective_date = "2013-06-13"
            initiated_date = "2013-07-23 00:00:00"
            status         = "Requested"
            type           = "Compliancy"
            method         = "E-Mail"
            relationship   = "Admin - Compliancy"
            
            s   = $students.get(sid)
            
            if s
                
                new_row = $tables.attach("Withdrawing").new_row
                fields = new_row.fields
                fields["student_id"].value     = sid
                fields["agora_reason"].value   = agora_reason
                fields["k12_reason"].value     = k12_reason
                fields["effective_date"].value = effective_date
                fields["initiated_date"].value = initiated_date
                fields["status"].value         = status
                fields["type"].value           = type
                fields["method"].value         = method
                fields["relationship"].value   = relationship
                
                new_row.save
                
            else
                
                puts sid
                
            end
            
            i+=1
            
        end
        
    end
    
end

Adhoc_Withdraws.new()