#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Site_Selection_Add < Base
    
    def initialize()
        super()
        csv_path = "#{$paths.imports_path}site_selection_survey_upload.csv"
        i=0
        CSV.open(csv_path, "rb").each do |csv_row|
            if i==0
                i+=1
                next
            end
            
            sid = csv_row[0]
            selected_site_name = csv_row[4]
            test_name = csv_row[5].gsub("PSSA ", "")
            
            test_event_site_id = $tables.attach("TEST_EVENT_SITES").by_site_name(selected_site_name).primary_id
            
            existing_records = $tables.attach("STUDENT_TESTS").by_studentid_old(sid, test_name, "PSSA")
            
            if !existing_records
                
                existing_records2 = $tables.attach("STUDENT_TESTS").by_studentid_old(sid, test_name, "PASA")
                
                if !existing_records2
                    
                    new_row = $tables.attach("STUDENT_TESTS").new_row
                    
                    fields = new_row.fields
                    
                    fields["student_id"        ].value = sid
                    fields["test_event_site_id"].value = test_event_site_id
                    fields["test_type"         ].value = "PSSA"
                    fields["test_subject"      ].value = test_name
                
                    new_row.save
                    
                elsif existing_records2.length == 1
                
                    existing_records2.each do |record|
                    
                        record.fields["test_event_site_id"].value = test_event_site_id
                        
                        record.save
                    
                    end
                    
                end
                    
            
            elsif existing_records.length == 1
                
                existing_records.each do |record|
                    
                    record.fields["test_event_site_id"].value = test_event_site_id
                    
                    record.save
                    
                end
                
            else
                
                puts sid
                
            end
            
            i+=1
        end
        
    end
    
end

Site_Selection_Add.new()