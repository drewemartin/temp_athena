#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_PACKETS < Athena_Table
    
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

    def after_insert(obj)
        
        assign_packet_to_warehouse(obj)
        
        #ADD DEFAULT STATUS
        by_primary_id(obj.primary_id).fields["status"].set("Unused").save
        
    end
    
    def after_change_field(obj)
     
        record = by_primary_id(obj.primary_id)
        record.fields["verified"].value = false if obj.field_name != "verified"
        record.save
        
    end
    
    def after_change_field_returned_to_warehouse(obj)
        
        if obj.is_true?
            
            row_obj = by_primary_id(obj.primary_id)
            assign_packet_to_warehouse(row_obj)
            
        end
        
    end
    
    def after_change_field_student_id(obj)
        
        record = by_primary_id(obj.primary_id)
        record.fields["status"].value = "In Progress"
        record.save
        
    end
    
    def after_change_test_event_site_id(field_obj)
        
        previous_test_event_site_id = $tables.attach("TEST_PACKET_LOCATION").field_value(
            "test_event_site_id",
            "WHERE test_packet_id = '#{field_obj.primary_id}' ORDER BY created_date DESC"
        )
        
        if previous_test_event_site_id != field_obj.value
            
            record = $tables.attach("TEST_PACKET_LOCATION").new_row
            record.fields["test_packet_id"      ].value = field_obj.primary_id
            record.fields["test_event_site_id"  ].value = field_obj.value
            record.save
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENT_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def assign_packet_to_warehouse(obj)
        
        if test_event_site_id = $tables.attach("TEST_EVENT_SITES").field_value(
            "primary_id",
            "WHERE site_name = 'Warehouse'
            AND test_event_id = '#{obj.fields["test_event_id"].value}'"
        )
            
            previous_test_event_site_id = $tables.attach("TEST_PACKET_LOCATION").field_value(
                "test_event_site_id",
                "WHERE test_packet_id = '#{obj.primary_id}' ORDER BY created_date DESC"
            )
            
            if previous_test_event_site_id != test_event_site_id
                
                record = $tables.attach("TEST_PACKET_LOCATION").new_row
                record.fields["test_packet_id"      ].value = obj.primary_id
                record.fields["test_event_site_id"  ].value = test_event_site_id
                record.save
                
            end
            
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
                :load_type          => :append,
                :keys               => ["serial_number","test_event_id"],
                :update             => true,
                "name"              => "test_packets",
                "file_name"         => "test_packets.csv",
                "file_location"     => "test_packets",
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
            
            structure_hash["fields"]["serial_number"            ] = {"data_type"=>"int",  "file_field"=>"serial_number"         } if field_order.push("serial_number"           )
            structure_hash["fields"]["grade_level"              ] = {"data_type"=>"text", "file_field"=>"grade_level"           } if field_order.push("grade_level"             )
            structure_hash["fields"]["subject"                  ] = {"data_type"=>"text", "file_field"=>"subject"               } if field_order.push("subject"                 )
            structure_hash["fields"]["large_print"              ] = {"data_type"=>"bool", "file_field"=>"large_print"           } if field_order.push("large_print"             )
            structure_hash["fields"]["test_event_id"            ] = {"data_type"=>"int",  "file_field"=>"test_event_id"         } if field_order.push("test_event_id"           )
            structure_hash["fields"]["test_type_id"             ] = {"data_type"=>"int",  "file_field"=>"test_type_id"          } if field_order.push("test_type_id"            )
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"student_id"            } if field_order.push("student_id"              )
            structure_hash["fields"]["test_event_site_id"       ] = {"data_type"=>"int",  "file_field"=>"test_event_site_id"    } if field_order.push("test_event_site_id"      )
            structure_hash["fields"]["administrator_team_id"    ] = {"data_type"=>"int",  "file_field"=>"administrator_team_id" } if field_order.push("administrator_team_id"   )
            structure_hash["fields"]["status"                   ] = {"data_type"=>"text", "file_field"=>"status"                } if field_order.push("status"                  )
            structure_hash["fields"]["verified"                 ] = {"data_type"=>"bool", "file_field"=>"verified"              } if field_order.push("verified"                )
            structure_hash["fields"]["returned_to_warehouse"    ] = {"data_type"=>"bool", "file_field"=>"returned_to_warehouse" } if field_order.push("returned_to_warehouse"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end