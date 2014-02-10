#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_STUDENT_SE_ACCOMMODATIONS < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_sapphire",
                "name"              => "sapphire_student_se_accommodations",
                "file_name"         => "sapphire_student_se_accommodations.csv",
                "file_location"     => "sapphire_student_se_accommodations",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"                    } if field_order.push("student_id"              )
            structure_hash["fields"]["last_name"                ] = {"data_type"=>"text", "file_field"=>"LAST_NAME"                     } if field_order.push("last_name"               )
            structure_hash["fields"]["first_name"               ] = {"data_type"=>"text", "file_field"=>"FIRST_NAME"                    } if field_order.push("first_name"              )
            structure_hash["fields"]["school_id"                ] = {"data_type"=>"text", "file_field"=>"SCHOOL_ID"                     } if field_order.push("school_id"               )
            structure_hash["fields"]["grade_level"              ] = {"data_type"=>"text", "file_field"=>"GRADE_LEVEL"                   } if field_order.push("grade_level"             )
            structure_hash["fields"]["current_iep_no"           ] = {"data_type"=>"int",  "file_field"=>"CURRENT_IEP_NO"                } if field_order.push("current_iep_no"          )
            structure_hash["fields"]["iep_date"                 ] = {"data_type"=>"date", "file_field"=>"IEP_DATE"                      } if field_order.push("iep_date"                )
            structure_hash["fields"]["iep_implementation_date"  ] = {"data_type"=>"date", "file_field"=>"IEP_IMPLEMENTATION_DATE"       } if field_order.push("iep_implementation_date" )
            structure_hash["fields"]["assessment_type_group"    ] = {"data_type"=>"text", "file_field"=>"ASSESSMENT_TYPE_GROUP"         } if field_order.push("assessment_type_group"   )
            structure_hash["fields"]["assessment_type_code"     ] = {"data_type"=>"text", "file_field"=>"ASSESSMENT_TYPE_CODE"          } if field_order.push("assessment_type_code"    )
            structure_hash["fields"]["accommodation_code"       ] = {"data_type"=>"text", "file_field"=>"ACCOMMODATION_CODE"            } if field_order.push("accommodation_code"      )
            structure_hash["fields"]["accommodation_desc"       ] = {"data_type"=>"text", "file_field"=>"ACCOMMODATION_DESC"            } if field_order.push("accommodation_desc"      )
          
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end