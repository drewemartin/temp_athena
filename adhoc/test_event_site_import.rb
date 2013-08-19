#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Test_Event_Site_Import < Base
    
    def initialize()
        super()
        csv_path = "#{$paths.imports_path}test_event_site_import.csv"
        i=0
        CSV.open(csv_path, "rb").each do |csv_row|
            if i==0
                i+=1
                next
            end
            
            site_name  = csv_row[2]
            start_date = csv_row[4]
            end_date   = csv_row[5]
            test_event_id = "5" #CHANGE IF NECCESARY!!!!!!
            puts csv_row[3]
            test_site_id = $tables.attach("TEST_SITES").by_facility_name(csv_row[3]).fields["primary_id"].value
            
            new_row = $tables.attach("TEST_EVENT_SITES").new_row
            new_row.fields["test_event_id"].value = test_event_id
            new_row.fields["test_site_id" ].value = test_site_id
            new_row.fields["site_name"    ].value = site_name
            new_row.fields["start_date"   ].value = start_date
            new_row.fields["end_date"     ].value = end_date
            #new_row.save #UNCOMMENT TO ACTUALLY RUN
            
            i+=1
            
        end
        
    end
    
end

Test_Event_Site_Import.new()