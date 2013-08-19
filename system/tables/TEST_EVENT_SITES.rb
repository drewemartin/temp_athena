#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_EVENT_SITES < Athena_Table
    
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
    
    def by_test_event_id(id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("test_event_id",  "=", id   ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_site_name(site_name, test_event_id = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("test_event_id",  "=", test_event_id  ) ) if test_event_id
        params.push( Struct::WHERE_PARAMS.new("site_name",      "=", site_name      ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_change_field_start_date(field)
        
        test_event_site_id = field.primary_id
        
        student_tests_table = $tables.attach("STUDENT_TESTS")
        
        test_record_pids = student_tests_table.pids_by_event_site(test_event_site_id)
        
        test_record_pids.each do |pid|
            
            test_record = student_tests_table.by_primary_id(pid)
           
            field = test_record.fields["test_event_site_id"]
            
            student_tests_table.update_attendance_record(field)
            
        end if test_record_pids
        
    end
    
    def after_change_field_end_date(field)
        
        test_event_site_id = field.primary_id
        
        student_tests_table = $tables.attach("STUDENT_TESTS")
        
        test_record_pids = student_tests_table.pids_by_event_site(test_event_site_id)
        
        test_record_pids.each do |pid|
            
            test_record = student_tests_table.by_primary_id(pid)
           
            field = test_record.fields["test_event_site_id"]
            
            student_tests_table.update_attendance_record(field)
            
        end if test_record_pids
        
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
                "name"              => "test_event_sites",
                "file_name"         => "test_event_sites.csv",
                "file_location"     => "test_event_sites",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["test_event_id"] = {"data_type"=>"int",  "file_field"=>"test_event_id" } if field_order.push("test_event_id")
            structure_hash["fields"]["test_site_id" ] = {"data_type"=>"int",  "file_field"=>"test_site_id"  } if field_order.push("test_site_id")
            structure_hash["fields"]["site_name"    ] = {"data_type"=>"text", "file_field"=>"site_name"     } if field_order.push("site_name")
            structure_hash["fields"]["start_date"   ] = {"data_type"=>"date", "file_field"=>"start_date"    } if field_order.push("start_date")
            structure_hash["fields"]["end_date"     ] = {"data_type"=>"date", "file_field"=>"end_date"      } if field_order.push("end_date")
            structure_hash["fields"]["special_notes"] = {"data_type"=>"text", "file_field"=>"special_notes" } if field_order.push("special_notes")
            structure_hash["fields"]["start_time"   ] = {"data_type"=>"text", "file_field"=>"start_time"    } if field_order.push("start_time")
            structure_hash["fields"]["end_time"     ] = {"data_type"=>"text", "file_field"=>"end_time"      } if field_order.push("end_time")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end