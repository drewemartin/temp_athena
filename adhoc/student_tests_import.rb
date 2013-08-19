#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Student_Tests_Import < Base
    
    def initialize()
        super()
        csv_path = "#{$paths.imports_path}student_tests_import.csv"
        i=0
        CSV.open(csv_path, "rb").each do |csv_row|
            if i==0
                i+=1
                next
            end
            
            sid          = csv_row[0]
            test_subject = csv_row[1]
            test_type    = csv_row[2]
            
            s   = $students.get(sid)
            
            if s
                
                new_row = $tables.attach("STUDENT_TESTS").new_row
                new_row.fields["student_id"].value = sid
                new_row.fields["test_subject"].value = test_subject
                new_row.fields["test_type"].value = test_type
                #new_row.save #UNCOMMENT TO ACTUALLY RUN
                
            else
                
                puts sid
                
            end
            
            i+=1
            
        end
        
    end
    
end

Student_Tests_Import.new()