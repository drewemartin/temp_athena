#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_SITES < Athena_Table
    
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
    
    def by_facility_name(facility_name)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("facility_name",  "=", facility_name  ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
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
                "name"              => "test_sites",
                "file_name"         => "test_sites.csv",
                "file_location"     => "test_sites",
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
            structure_hash["fields"]["region"           ] = {"data_type"=>"text", "file_field"=>"region"                } if field_order.push("region")
            structure_hash["fields"]["facility_name"    ] = {"data_type"=>"text", "file_field"=>"facility_name"         } if field_order.push("facility_name")
            structure_hash["fields"]["address"          ] = {"data_type"=>"text", "file_field"=>"address"               } if field_order.push("address")
            structure_hash["fields"]["city"             ] = {"data_type"=>"text", "file_field"=>"city"                  } if field_order.push("city")
            structure_hash["fields"]["state"            ] = {"data_type"=>"text", "file_field"=>"state"                 } if field_order.push("state")
            structure_hash["fields"]["zip_code"         ] = {"data_type"=>"text", "file_field"=>"zip_code"              } if field_order.push("zip_code")
            structure_hash["fields"]["site_url"         ] = {"data_type"=>"text", "file_field"=>"site_url"              } if field_order.push("site_url")
            structure_hash["fields"]["directions"       ] = {"data_type"=>"text", "file_field"=>"directions"            } if field_order.push("directions")
            structure_hash["fields"]["contact_name"     ] = {"data_type"=>"text", "file_field"=>"contact_name"          } if field_order.push("contact_name")
            structure_hash["fields"]["contact_phone"    ] = {"data_type"=>"text", "file_field"=>"contact_phone"         } if field_order.push("contact_phone")
            structure_hash["fields"]["contact_email"    ] = {"data_type"=>"text", "file_field"=>"contact_email"         } if field_order.push("contact_email")
            structure_hash["fields"]["available_hours"  ] = {"data_type"=>"text", "file_field"=>"available_hours"       } if field_order.push("available_hours")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end