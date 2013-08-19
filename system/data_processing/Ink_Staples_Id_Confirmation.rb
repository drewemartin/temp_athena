#!/usr/local/bin/ruby

class Ink_Staples_Id_Confirmation

    def initialize()
        
        super()
        
        if ENV["COMPUTERNAME"] == "ATHENA"
            
            confirm_records
            
        end
        
    end
  
    def confirm_records
        
        i=0
        
        unconfirmed = $tables.attach("ink_staples_ids_requested").unconfirmed
        
        if unconfirmed
            
            unconfirmed.each do |record|
                
                pid = record.primary_id
                
                if $tables.attach("ink_staples_ids").by_staples_id(pid)
                    
                    record.fields["confirmed"].value = "1"
                    record.save
                    
                    i+=1
                    
                end
                
            end
            
            puts "#{i} new confirmed records"
            
        else
            
            puts "No unconfirmed records"
            
        end
        
    end
    
end