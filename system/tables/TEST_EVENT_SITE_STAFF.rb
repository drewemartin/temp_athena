#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_EVENT_SITE_STAFF < Athena_Table
    
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
    
    def by_staff_id(staff_id, test_event_site_id = nil, role = nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",               "=", staff_id           ) )
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id",     "=", test_event_site_id ) ) if test_event_site_id
        params.push( Struct::WHERE_PARAMS.new("role",                   "=", role               ) ) if role
        where_clause = $db.where_clause(params)
        record(where_clause)
        
    end
    
    def is_site_coordinator?(sams_id, site_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",           "=", sams_id ) )
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=", site_id ) )
        params.push( Struct::WHERE_PARAMS.new("role",               "=", "Site Coordinator" ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_test_event_site_id(id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id",  "=", id   ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
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
                "name"              => "test_event_site_staff",
                "file_name"         => "test_event_site_staff.csv",
                "file_location"     => "test_event_site_staff",
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
            structure_hash["fields"]["test_event_site_id"   ] = {"data_type"=>"int", "file_field"=>"test_event_site_id" } if field_order.push("test_event_site_id")
            structure_hash["fields"]["staff_id"             ] = {"data_type"=>"int",  "file_field"=>"staff_id"          } if field_order.push("staff_id")
            structure_hash["fields"]["role"                 ] = {"data_type"=>"text", "file_field"=>"role"              } if field_order.push("role")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end