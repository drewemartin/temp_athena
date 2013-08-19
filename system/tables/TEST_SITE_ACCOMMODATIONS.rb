#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_SITE_ACCOMMODATIONS < Athena_Table
    
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
                "name"              => "test_site_accommodations",
                "file_name"         => "test_site_accommodations.csv",
                "file_location"     => "test_site_accommodations",
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
            structure_hash["fields"]["testing_site_id"      ] = {"data_type"=>"int",  "file_field"=>"testing_site_id"       } if field_order.push("testing_site_id")
            structure_hash["fields"]["accommodation_name"   ] = {"data_type"=>"text", "file_field"=>"accommodation_name"    } if field_order.push("accommodation_name")
            structure_hash["fields"]["accommodation_desc"   ] = {"data_type"=>"text", "file_field"=>"accommodation_desc"    } if field_order.push("accommodation_desc")
            structure_hash["fields"]["capacity"             ] = {"data_type"=>"int",  "file_field"=>"capacity"              } if field_order.push("capacity")
            structure_hash["fields"]["cost"                 ] = {"data_type"=>"text", "file_field"=>"cost"                  } if field_order.push("cost")
            structure_hash["fields"]["notes"                ] = {"data_type"=>"text", "file_field"=>"notes"                 } if field_order.push("notes")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end