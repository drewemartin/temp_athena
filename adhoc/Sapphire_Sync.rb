#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Sapphire_Sync < Base
    
    def initialize()
        
        super()
        
        mapped_fields = {
          
          #"mailingstate"	=>        "address_state"   ,
          #"mailingaddress1"	=>        "address_1"       ,
          #"mailingaddress2"	=>        "address_2"       ,
          #"mailingcity"        =>        "address_city"    ,
          #"mailingzip"	        =>        "address_zip"     ,
          
          "studentgender"	=>        "gender"          ,
          "studenthomephone"	=>        "phone_no"        ,
          "preferred_name"	=>        "other_name"      ,
          "studentfirstname"	=>        "first_name"      ,
          "studentlastname"	=>        "last_name"       ,
          "ethnicity"           =>        "ethnicity"  
           
        }
        
        sids = $students.list(:currently_enrolled=>true)
        sids.each{|sid|
          
            s = $students.get(sid)
            t = $tables.attach("STUDENT")
            
            t.field_order.each{|field_name|
                
                if mapped_fields.keys.include?(field_name)
                  
                    s_field = $tables.attach("SAPPHIRE_STUDENT_DEMOGRAPHICS").field_value(mapped_fields[field_name],  "WHERE student_id = '#{sid}'")
                    a_field = $tables.attach("STUDENT"                      ).field_value(field_name,                 "WHERE student_id = '#{sid}'")
                    
                    fields_match            = s_field == a_field
                    parsed_phone_matches    = (!s_field.nil? && !a_field.nil?) && s_field.gsub('-','').gsub('(','').gsub(')','').gsub(' ','') == a_field.gsub('-','').gsub('(','').gsub(')','').gsub(' ','')
                    male_match              = s_field == "M" && a_field == "Male"
                    female_match            = s_field == "F" && a_field == "Female"
                    ethnicity_match         = (
                        s_field == "1"  && a_field == "American Indian"                                                                 ||
                        s_field == "9"  && a_field == "Asian"                                                                           ||
                        s_field == "3"  && a_field == "African-American"                                                                ||
                        s_field == "10" && (a_field == "Native Hawaiian or other Pacific Islander" || a_field == "Pacific Islander")    ||
                        s_field == "4"  && a_field == "Hispanic"                                                                        ||
                        s_field == "6"  && a_field == "Multi-racial"                                                                    ||
                        s_field == "7"  && (a_field == "Declined to State" || a_field == "Undefined")                                   ||
                        s_field == "5"  && a_field == "White"                                                                           
                    )
                    
                    if !(
                     
                        fields_match || parsed_phone_matches || male_match || female_match || ethnicity_match
                        
                    )
                      
                        t.find_and_trigger_event(:after_change_field, s.send(field_name))
                      
                    end
                  
                end
                
            }
          
        } if sids
        
    end
    
end

Sapphire_Sync.new()