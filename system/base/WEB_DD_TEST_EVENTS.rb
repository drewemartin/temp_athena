#!/usr/local/bin/ruby

class WEB_DD_TEST_EVENTS

    #---------------------------------------------------------------------------
    def initialize()
        @structure = structure
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def event_sites(test_event_id)
        
        $tables.attach("TEST_EVENT_SITES").dd_choices(
            "site_name",
            "primary_id",
            "WHERE (
                test_event_id = '#{test_event_id}' OR
                (test_event_id IS NULL AND test_site_id IS NULL)
            )
            ORDER BY site_name ASC"
        )
        
    end
   
    def test_packet_serial_numbers(test_event_site_id)
        
        test_event_id = $tables.attach("TEST_EVENT_SITES").field_value("test_event_id", "WHERE primary_id = '#{test_event_site_id}'")
        
        $tables.attach("TEST_PACKETS").dd_choices(
            "serial_number",
            "serial_number",
            "WHERE test_event_id = '#{test_event_id}'"
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

end