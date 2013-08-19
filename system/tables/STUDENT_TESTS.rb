#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_TESTS < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def by_studentid_old(sid, test_subject = nil, test_type = nil, test_event_site_id = nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=", sid                ) )
        params.push( Struct::WHERE_PARAMS.new("test_subject",       "=", test_subject       ) ) if test_subject
        params.push( Struct::WHERE_PARAMS.new("test_type",          "=", test_type          ) ) if test_type
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=", test_event_site_id ) ) if test_event_site_id
        where_clause = $db.where_clause(params)
        records(where_clause)
        
    end
    
    def by_studentid_except_site(sid, test_event_site_id, except_this_record_id)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=",    sid                     ) )
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=",    test_event_site_id      ) )
        params.push( Struct::WHERE_PARAMS.new("primary_id",         "!=",   except_this_record_id   ) )
        where_clause = $db.where_clause(params)
        records(where_clause)
        
    end
    
    def students_by_event_site(test_event_site_id)
        $db.get_data_single(
            "SELECT student_id
            FROM #{table_name}
            WHERE test_event_site_id = '#{test_event_site_id}'"
        )
    end
    
    def pids_by_event_site(test_event_site_id)
        $db.get_data_single(
            "SELECT primary_id
            FROM #{table_name}
            WHERE test_event_site_id = '#{test_event_site_id}'"
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_change_field_test_event_site_id(field)
        
        update_attendance_record(field)
        
    end
    
    #def before_insert(row_obj)
    #    
    #    test_event_id = row_obj.fields["test_event_id"].value
    #    row_obj.fields["test_id"].value = $tables.attach("TEST_EVENTS").field_by_pid("test_id",test_event_id).value
    #    
    #end
    
    def after_insert(row_obj)
        
        record = by_primary_id(row_obj.primary_id)
        
        test_event_id = record.fields["test_event_id"].value
        record.fields["test_id"].value = $tables.attach("TEST_EVENTS").field_by_pid("test_id",test_event_id).value
        record.save
        
        field = record.fields["test_event_site_id"]
        if !(field.value.nil?)
            
            update_attendance_record(field)
            
        end
        
    end
    
    def after_load_k12_omnibus
        
        pids = $tables.attach("TEST_EVENTS").primary_ids("WHERE end_date >= CURDATE()")
        pids.each{|pid|
            
            require "#{$paths.data_processing_path}TEST_EVENTS_PROCESSING" 
            TEST_EVENTS_PROCESSING.new.update_student_tests(pid)
            
        } if pids
        
    end
    
    def before_change_field_test_event_site_id(field)
        
        current_record       = by_primary_id(field.primary_id)
        previous_field_value = current_record.fields["test_event_site_id" ].value
        sid                  = current_record.fields["student_id"         ].value
        
        unless previous_field_value == field.value
            
            #THERE ARE NO OTHER TESTS FOR THIS STUDENT ASSIGNED TO THIS SITE
            if !by_studentid_except_site(sid, test_event_site_id = field.value, except_this_record_id = field.primary_id)  
                
                if previous_site_attendance_records = $tables.attach("STUDENT_TEST_DATES").by_studentid_old(
                    
                    sid,
                    date                    = nil,
                    test_event_site_id      = previous_field_value,
                    after_attendance_date   = $idate
                    
                )
                    
                    previous_site_attendance_records.each{|date_record|
                        
                        date_record.fields["attendance_code"].value = "Resched"
                        date_record.save
                        
                    }
                    
                end
                
            end
            
        end
        
    end
    
    def update_attendance_record(field)
        
        event_site = $tables.attach("TEST_EVENT_SITES").by_primary_id(field.value)
        
        if event_site.fields["start_date"].value && event_site.fields["end_date"  ].value
            
            start_date = Date.parse(event_site.fields["start_date"].value)
            end_date   = Date.parse(event_site.fields["end_date"  ].value)
            
            duration_array = Array.new
            
            date_check = start_date
            
            while date_check <= end_date do
                
                date_str = date_check.strftime("%Y-%m-%d")
                
                duration_array.push(date_str) if $school.school_days.include?(date_str)
                
                date_check += 1
                
            end
            
            test_record = by_primary_id(field.primary_id)
            sid         = test_record.fields["student_id"].value
            
            duration_array.each{|date|
                
                if !(test_date_record = $tables.attach("STUDENT_TEST_DATES").by_studentid_siteid(sid, date, field.value))
                    
                    test_date_record = $tables.attach("STUDENT_TEST_DATES").new_row
                  
                end
                
                test_date_record.fields["date"              ].value = date
                test_date_record.fields["student_id"        ].value = sid
                test_date_record.fields["test_event_site_id"].value = field.value
                
                att_code = test_date_record.fields["attendance_code"].value
                test_date_record.fields["attendance_code"   ].value = nil if att_code == "Resched"
                
                test_date_record.save
                
            }
            
            att_recs = $tables.attach("STUDENT_TEST_DATES").by_studentid_siteid(sid, date = nil, field.value)
            att_recs.each{|att_rec|
                
                if !duration_array.include?(att_rec.fields["date"].value)
                    
                    att_rec.fields["attendance_code"].set("Resched").save 
                    
                end
                
            } if att_recs
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_tests",
                "file_name"         => "student_tests.csv",
                "file_location"     => "student_tests",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"student_id"                } if field_order.push("student_id"          )
            
            structure_hash["fields"]["test_id"                  ] = {"data_type"=>"int",  "file_field"=>"test_id"                   } if field_order.push("test_id"             )
            structure_hash["fields"]["test_subject_id"          ] = {"data_type"=>"int",  "file_field"=>"test_subject_id"           } if field_order.push("test_subject_id"     )
            structure_hash["fields"]["serial_number"            ] = {"data_type"=>"text", "file_field"=>"serial_number"             } if field_order.push("serial_number"       )
            structure_hash["fields"]["test_administrator"       ] = {"data_type"=>"text", "file_field"=>"test_administrator"        } if field_order.push("test_administrator"  )
            structure_hash["fields"]["completed"                ] = {"data_type"=>"date", "file_field"=>"completed"                 } if field_order.push("completed"           )
            structure_hash["fields"]["checked_in"               ] = {"data_type"=>"date", "file_field"=>"checked_in"                } if field_order.push("checked_in"          )
            structure_hash["fields"]["test_results"             ] = {"data_type"=>"text", "file_field"=>"test_results"              } if field_order.push("test_results"        )
            
            structure_hash["fields"]["test_event_id"            ] = {"data_type"=>"int",  "file_field"=>"test_event_id"             } if field_order.push("test_event_id"       )
            structure_hash["fields"]["test_event_site_id"       ] = {"data_type"=>"int",  "file_field"=>"test_event_site_id"        } if field_order.push("test_event_site_id"  )
            structure_hash["fields"]["assigned"                 ] = {"data_type"=>"bool", "file_field"=>"assigned"                  } if field_order.push("assigned"            )
            structure_hash["fields"]["drop_off"                 ] = {"data_type"=>"text", "file_field"=>"drop_off"                  } if field_order.push("drop_off"            )
            structure_hash["fields"]["pick_up"                  ] = {"data_type"=>"text", "file_field"=>"pick_up"                   } if field_order.push("pick_up"             )
            
            structure_hash["fields"]["athena_generated"         ] = {"data_type"=>"bool", "file_field"=>"athena_generated"          } if field_order.push("athena_generated"    )
            structure_hash["fields"]["matches_criteria"         ] = {"data_type"=>"text", "file_field"=>"matches_criteria"          } if field_order.push("matches_criteria"    )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end