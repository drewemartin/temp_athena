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
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end