#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_PACKET_LOCATION < Athena_Table
    
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
     
        record = by_primary_id(obj.primary_id)
        if record.fields["checkin_date"].is_null?
            record.fields["checkin_date"].value = $idatetime
            record.save
        end
        
        test_packet_record = $tables.attach("TEST_PACKETS").by_primary_id(obj.fields["test_packet_id"].value)
        test_packet_record.fields["test_event_site_id"].value = obj.fields["test_event_site_id"].value
        test_packet_record.save
        
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
                "name"              => "test_packet_location",
                "file_name"         => "test_packet_location.csv",
                "file_location"     => "test_packet_location",
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
            
            structure_hash["fields"]["test_packet_id"       ] = {"data_type"=>"int",        "file_field"=>"test_packet_id"    } if field_order.push("test_packet_id"      )
            structure_hash["fields"]["test_event_site_id"   ] = {"data_type"=>"int",        "file_field"=>"test_event_site_id"} if field_order.push("test_event_site_id"  )
            structure_hash["fields"]["team_id"              ] = {"data_type"=>"int",        "file_field"=>"team_id"           } if field_order.push("team_id"             )
            structure_hash["fields"]["checkin_status"       ] = {"data_type"=>"text",       "file_field"=>"checkin_status"    } if field_order.push("checkin_status"      )
            structure_hash["fields"]["checkin_date"         ] = {"data_type"=>"datetime",   "file_field"=>"checkin_date"      } if field_order.push("checkin_date"        )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end