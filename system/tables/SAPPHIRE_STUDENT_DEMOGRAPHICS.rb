#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_STUDENT_DEMOGRAPHICS < Athena_Table
    
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
                :load_type          => :append,
                :data_base          => "#{$config.school_name}_sapphire",
                :keys               => ["student_id"],
                :update             => true,
                "name"              => "sapphire_student_demographics",
                "file_name"         => "sapphire_student_demographics.csv",
                "file_location"     => "sapphire_student_demographics",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"            } if field_order.push("student_id"              )
            structure_hash["fields"]["last_name"        ] = {"data_type"=>"text", "file_field"=>"LAST_NAME"             } if field_order.push("last_name"               )
            structure_hash["fields"]["first_name"       ] = {"data_type"=>"text", "file_field"=>"FIRST_NAME"            } if field_order.push("first_name"              )
            structure_hash["fields"]["resident_district"] = {"data_type"=>"text", "file_field"=>"RESIDENT_DISTRICT"     } if field_order.push("resident_district"       )
            structure_hash["fields"]["state_student_id" ] = {"data_type"=>"text", "file_field"=>"STATE_STUDENT_ID"      } if field_order.push("state_student_id"        )
            structure_hash["fields"]["ethnicity_desc"   ] = {"data_type"=>"text", "file_field"=>"ETHNICITY_DESC"        } if field_order.push("ethnicity_desc"          )
            structure_hash["fields"]["ethnicity"        ] = {"data_type"=>"text", "file_field"=>"ETHNICITY"             } if field_order.push("ethnicity"               )
            structure_hash["fields"]["email_address"    ] = {"data_type"=>"text", "file_field"=>"EMAIL_ADDRESS"         } if field_order.push("email_address"           )
            structure_hash["fields"]["phone_no"         ] = {"data_type"=>"text", "file_field"=>"PHONE_NO"              } if field_order.push("phone_no"                )
            structure_hash["fields"]["birth_date"       ] = {"data_type"=>"date", "file_field"=>"BIRTH_DATE"            } if field_order.push("birth_date"              )
            structure_hash["fields"]["gender"           ] = {"data_type"=>"text", "file_field"=>"GENDER"                } if field_order.push("gender"                  )
            structure_hash["fields"]["other_name"       ] = {"data_type"=>"text", "file_field"=>"OTHER_NAME"            } if field_order.push("other_name"              )
            structure_hash["fields"]["township_code"    ] = {"data_type"=>"text", "file_field"=>"TOWNSHIP_CODE"         } if field_order.push("township_code"           )
            structure_hash["fields"]["address_county"   ] = {"data_type"=>"text", "file_field"=>"ADDRESS_COUNTY"        } if field_order.push("address_county"          )
            structure_hash["fields"]["address_zip_ext"  ] = {"data_type"=>"text", "file_field"=>"ADDRESS_ZIP_EXT"       } if field_order.push("address_zip_ext"         )
            structure_hash["fields"]["address_zip"      ] = {"data_type"=>"text", "file_field"=>"ADDRESS_ZIP"           } if field_order.push("address_zip"             )
            structure_hash["fields"]["address_state"    ] = {"data_type"=>"text", "file_field"=>"ADDRESS_STATE"         } if field_order.push("address_state"           )
            structure_hash["fields"]["address_city"     ] = {"data_type"=>"text", "file_field"=>"ADDRESS_CITY"          } if field_order.push("address_city"            )
            structure_hash["fields"]["address_2"        ] = {"data_type"=>"text", "file_field"=>"ADDRESS_2"             } if field_order.push("address_2"               )
            structure_hash["fields"]["address_1"        ] = {"data_type"=>"text", "file_field"=>"ADDRESS_1"             } if field_order.push("address_1"               )
            structure_hash["fields"]["grade_level"      ] = {"data_type"=>"text", "file_field"=>"GRADE_LEVEL"           } if field_order.push("grade_level"             )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end