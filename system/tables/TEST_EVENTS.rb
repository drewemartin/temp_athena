#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_EVENTS < Athena_Table
    
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
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_omnibus
        
        row_objects = records(
            
            "WHERE start_date IS NOT NULL
            AND end_date IS NOT NULL
            AND CURDATE() <= end_date"
            
        )
        
        row_objects.each{|row_object|
            
            queue_update_student_tests(row_object)
            
        } if row_objects
        
    end
    
    def after_insert(row_object)
        queue_update_student_tests(row_object)
    end
    
    def after_change_field_end_date(field_object)
        queue_update_student_tests(field_object)
    end
    
    def after_change_field_start_date(field_object)
        queue_update_student_tests(field_object)
    end
    
    def queue_update_student_tests(this_object)
        
        $base.queue_process(
            class_name      = "TEST_EVENTS_PROCESSING",
            function_name   = "update_student_tests",
            args            = this_object.primary_id
        )
        
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
                "name"              => "test_events",
                "file_name"         => "test_events.csv",
                "file_location"     => "test_events",
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
            structure_hash["fields"]["name"                     ] = {"data_type"=>"text",       "file_field"=>"name"                      } if field_order.push("name"                        )
            structure_hash["fields"]["test_id"                  ] = {"data_type"=>"int",        "file_field"=>"test_id"                   } if field_order.push("test_id"                     )
            structure_hash["fields"]["start_date"               ] = {"data_type"=>"date",       "file_field"=>"start_date"                } if field_order.push("start_date"                  )
            structure_hash["fields"]["end_date"                 ] = {"data_type"=>"date",       "file_field"=>"end_date"                  } if field_order.push("end_date"                    )
            structure_hash["fields"]["override_attendance"      ] = {"data_type"=>"bool",       "file_field"=>"override_attendance"       } if field_order.push("override_attendance"         )
            structure_hash["fields"]["ready"                    ] = {"data_type"=>"bool",       "file_field"=>"ready"                     } if field_order.push("ready"                       )
            structure_hash["fields"]["selection_last_run_date"  ] = {"data_type"=>"datetime",   "file_field"=>"selection_last_run_date"   } if field_order.push("selection_last_run_date"     )
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end