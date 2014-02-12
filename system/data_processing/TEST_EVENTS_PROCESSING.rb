#!/usr/local/bin/ruby
#require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class TEST_EVENTS_PROCESSING #< Base

    def initialize(sid = nil, date = nil)
      
        super()
      
    end
  
    def update_student_tests(test_event_id)
        
        test_event_record = $tables.attach("TEST_EVENTS").by_primary_id(test_event_id)
        
        if !test_event_record.fields["end_date"].value.nil? && $base.today.mathable <= test_event_record.fields["end_date"].mathable
            
            test_event_record.fields["ready"].set(false).save
            
            test_event_id   = test_event_record.primary_id
            test_id         = test_event_record.fields["test_id"].value
            
            test_subject_pids = $tables.attach("TEST_SUBJECTS").primary_ids("WHERE test_id = '#{test_id}'")
            test_subject_pids.each{|pid|
                
                test_subject_id     = pid
                test_subject_record = $tables.attach("TEST_SUBJECTS").by_primary_id(pid)
                
                options             = {:currently_enrolled=>true}
                test_subject_record.table.field_order.each{|field_name|
                    
                    if test_subject_record.fields[field_name].is_true?
                        
                        options[:grade          ] ? options[:grade]<<"|#{field_name.split("_")[1]}" : options[:grade]=field_name.split("_")[1] if field_name.match("grade")
                        options[:pasa_eligible  ] = true  if field_name.match("only_pasa")
                        options[:pasa_ineligible] = true  if field_name.match("exclude_pasa")
                        
                    end
                    
                }
                
                related_classes_pids = $tables.attach("TEST_SUBJECT_CLASSES").primary_ids("WHERE test_subject_id = '#{test_subject_record.primary_id}'")
                related_classes_pids.each{|pid|
                    
                    record = $tables.attach("TEST_SUBJECT_CLASSES").by_primary_id(pid)
                    options[:academic_progress_course_name] ?  options[:academic_progress_course_name]<<"|#{record.fields["class_name"].value}" : options[:academic_progress_course_name]=record.fields["class_name"].value
                    
                } if related_classes_pids
                
                sids = $students.list(options) if options[:grade]
                sids.each{|sid|
                    
                    if !$tables.attach("STUDENT_TESTS").primary_ids(
                        
                        "WHERE student_id   = '#{sid}'
                        AND test_id         = '#{test_id}'
                        AND test_event_id   = '#{test_event_id}'
                        AND test_subject_id = '#{test_subject_id}'"
                        
                    )
                        
                        record = $tables.attach("STUDENT_TESTS").new_row
                        record.fields["student_id"      ].value = sid
                        record.fields["test_id"         ].value = test_id
                        record.fields["test_event_id"   ].value = test_event_id
                        record.fields["test_subject_id" ].value = test_subject_id  
                        record.save
                        
                    end
                    
                } if sids
                
            }
          
            test_event_record.fields["selection_last_run_date"].set($base.today.to_db).save
            test_event_record.fields["ready"].set(true).save
            
        end
        
    end

    def update_team_test_event_attendance(test_event_site_id)
        
        pids = $tables.attach("TEST_EVENT_SITE_STAFF").primary_ids(
            
            "WHERE test_event_site_id = '#{test_event_site_id}' GROUP BY team_id"
            
        )
        
        pids.each{|pid|
            
            record = $tables.attach("TEST_EVENT_SITE_STAFF").by_primary_id(pid)
            $tables.attach("TEST_EVENT_SITE_STAFF").update_team_attendance_records(record)
            
        } if pids
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
  
end
#TEST_EVENTS_PROCESSING.new