#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Sapphire_Sync < Base
    
    def initialize()
        
        super()
        
        mapped_fields = {
          
          "studentfirstname"	=>        "first_name"      ,
          "mailingstate"	=>        "address_state"   ,
          "studentlastname"	=>        "last_name"       ,
          "preferred_name"	=>        "other_name"      ,
          "mailingaddress1"	=>        "address_1"       ,
          "mailingaddress2"	=>        "address_2"       ,
          "mailingcity"	        =>        "address_city"    ,
          "studentgender"	=>        "gender"          ,
          "studenthomephone"	=>        "phone_no"        ,
          "mailingzip"	        =>        "address_zip"
           
        }
        
        sids = $students.list(:currently_enrolled=>true)
        sids.each{|sid|
          
            s = $students.get(sid)
            t = $tables.attach("STUDENT")
            
            t.field_order.each{|field_name|
                
                if mapped_fields.keys.include?(field_name)
                  
                    s_field = $tables.attach("SAPPHIRE_STUDENT_DEMOGRAPHICS").field_value(mapped_fields[field_name],  "WHERE student_id = '#{sid}'")
                    a_field = $tables.attach("STUDENT"                      ).field_value(field_name,                 "WHERE student_id = '#{sid}'")
                    
                    if !(s_field == a_field)
                      
                        t.find_and_trigger_event(:after_change_field, s.send(field_name))
                      
                    end
                  
                end
                
            }
          
        } if sids
        
    end
    
end

Sapphire_Sync.new()