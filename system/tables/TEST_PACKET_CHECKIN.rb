#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_PACKET_CHECKIN < Athena_Table
    
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
        record.field["checkin_date"].value = $idate
        record.save
        
        test_packet_record = $tables.attach("TEST_PACKETS").by_primary_id(obj.fields["test_packet_id"].value)
        test_packet_record.fields["test_event_site_id"].value = obj.test_event_site_id.value
        test_packet_record.save
        
        if pids = primary_ids(
            "WHERE test_packet_id = '#{obj.fields["test_packet_id"].value}'
            AND primary_id != '#{obj.primary_id}'
            AND checkout_date IS NULL"
        )
            
            pids.each{|pid|
                
                record = by_primary_id(pid)
                record.field["checkout_date"].value = $idate
                record.save    
                
            }
            
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
                "name"              => "test_packet_checkin",
                "file_name"         => "test_packet_checkin.csv",
                "file_location"     => "test_packet_checkin",
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
            
            structure_hash["fields"]["test_packet_id"       ] = {"data_type"=>"int",  "file_field"=>"test_packet_id"    } if field_order.push("test_packet_id"      )
            structure_hash["fields"]["test_event_site_id"   ] = {"data_type"=>"int",  "file_field"=>"test_event_site_id"} if field_order.push("test_event_site_id"  )
            structure_hash["fields"]["team_id"              ] = {"data_type"=>"int",  "file_field"=>"team_id"           } if field_order.push("team_id"             )
            structure_hash["fields"]["checkin_status"       ] = {"data_type"=>"text", "file_field"=>"checkin_status"    } if field_order.push("checkin_status"      )
            structure_hash["fields"]["checkin_date"         ] = {"data_type"=>"date", "file_field"=>"checkin_date"      } if field_order.push("checkin_date"        )
            structure_hash["fields"]["checkout_date"        ] = {"data_type"=>"date", "file_field"=>"checkout_date"     } if field_order.push("checkout_date"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end