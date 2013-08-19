#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_2 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        ##TEST EVENT SYSTEM CHANGES
        populate_test_subjects_test_id
        message_manually_delete_duplicate_tests
        message_manually_add_test_type_to_test_events
        populate_student_tests_test_event_id
        populate_student_tests_test_id
        populate_student_tests_test_subject_id
        
    end
    #---------------------------------------------------------------------------
    def populate_test_subjects_test_id
        
        puts "#POPULATE TABLE: test_subjects FIELD: test_ids"
        
        tests_not_found = Array.new
        
        pids = $tables.attach("TEST_SUBJECTS").primary_ids
        pids.each{|pid|
            
            test_name   = $db.get_data_single("SELECT related_test FROM TEST_SUBJECTS WHERE primary_id = #{pid}")[0]
            test_id     = $tables.attach("TESTS").primary_ids("WHERE name = '#{test_name}'")
            if test_id
                $tables.attach("TEST_SUBJECTS").by_primary_id(pid).fields["test_id"].set(test_id ? test_id[0] : nil).save
            else
                tests_not_found.push(test_name)
            end
            
        }
        
        puts tests_not_found.join(",") if !tests_not_found.empty?
        
    end
    
    def message_manually_delete_duplicate_tests
        
        puts "#ATTENTION - MANUAL ACTION NEEDED"
        puts "Please delete any duplicates from the test table. PRESS ENTER TO CONTINUE"
        this_response = STDIN.gets
        
    end
    
    def message_manually_add_test_type_to_test_events
        
        puts "#ATTENTION - MANUAL ACTION NEEDED"
        puts "Please goto Test Event Administration and select a Test Type for each existing Test Event. PRESS ENTER TO CONTINUE"
        this_response = STDIN.gets
        
    end
    
    def populate_student_tests_test_event_id
        
        puts "#POPULATE TABLE: student_tests FIELD: test_event_id"
        
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '1'
            WHERE test_type = 'Keystone'"  
        )
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '2'
            WHERE test_type = 'K-6 Face To Face Assessment'"  
        )
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '4'
            WHERE test_type = 'PSSA'"  
        )
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '5'
            WHERE test_type = 'Spring Keystone'"  
        )
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '6'
            WHERE test_type = 'May K-6 Face to Face Assessment'"  
        )
        record = $tables.attach("test_events").new_row
        record.fields["test_id" ].value = '3'
        record.fields["name"    ].value = 'Unnamed PASA event'
        primary_id = record.save
        $db.query(
            "UPDATE student_tests
            SET test_event_id = '#{primary_id}'
            WHERE test_type = 'PASA'"  
        )
    end
    
    def populate_student_tests_test_id
        
        puts "#POPULATE TABLE: student_tests FIELD: test_id"
        
        $db.query(
            "UPDATE student_tests
            LEFT JOIN test_events ON student_tests.test_event_id = test_events.primary_id
            SET student_tests.test_id = test_events.test_id"          
        )    
        
    end

    def populate_student_tests_test_subject_id
        
        puts "#POPULATE TABLE: student_tests FIELD: test_subject_id"
        
        $db.query(
            "UPDATE student_tests
            LEFT JOIN test_subjects ON student_tests.test_id = test_subjects.test_id
            AND student_tests.test_subject = test_subjects.name
            SET student_tests.test_subject_id = test_subjects.primary_id"          
        )
        
    end
    
end