#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class AIMS_TEST_RESULTS < Athena_Table
    
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
                "name"              => "aims_test_results",
                "file_name"         => "aims_test_results.csv",
                "file_location"     => "aims_test_results",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"Student ID"                            } if field_order.push("student_id"              )
            structure_hash["fields"]["first_name"       ] = {"data_type"=>"text", "file_field"=>"StudentFirstName"                      } if field_order.push("first_name"              )
            structure_hash["fields"]["last_name"        ] = {"data_type"=>"text", "file_field"=>"StudentLastName"                       } if field_order.push("last_name"               )
            structure_hash["fields"]["teacher_last_name"] = {"data_type"=>"text", "file_field"=>"TeacherLastName"                       } if field_order.push("teacher_last_name"       )
            structure_hash["fields"]["grade"            ] = {"data_type"=>"text", "file_field"=>"Grade"                                 } if field_order.push("grade"                   )
            structure_hash["fields"]["gom"              ] = {"data_type"=>"text", "file_field"=>"GOM"                                   } if field_order.push("gom"                     )
            
            structure_hash["fields"]["fall_correct"     ] = {"data_type"=>"int",  "file_field"=>"Fall_September Corrects"               } if field_order.push("fall_correct"            )
            structure_hash["fields"]["fall_error"       ] = {"data_type"=>"int",  "file_field"=>"Fall_September Errors"                 } if field_order.push("fall_error"              )
            structure_hash["fields"]["fall_percentile"  ] = {"data_type"=>"int",  "file_field"=>"Fall_SeptemberNationalPercentileRank"  } if field_order.push("fall_percentile"         )
            
            structure_hash["fields"]["winter_correct"   ] = {"data_type"=>"int",  "file_field"=>"Winter_January Corrects"               } if field_order.push("winter_correct"          )
            structure_hash["fields"]["winter_error"     ] = {"data_type"=>"int",  "file_field"=>"Winter_January Errors"                 } if field_order.push("winter_error"            )
            structure_hash["fields"]["winter_percentile"] = {"data_type"=>"int",  "file_field"=>"Winter_JanuaryNationalPercentileRank"  } if field_order.push("winter_percentile"       )
            
            structure_hash["fields"]["spring_correct"   ] = {"data_type"=>"int",  "file_field"=>"Spring_May Corrects"                   } if field_order.push("spring_correct"          )
            structure_hash["fields"]["spring_error"     ] = {"data_type"=>"int",  "file_field"=>"Spring_May Errors"                     } if field_order.push("spring_error"            )
            structure_hash["fields"]["spring_percentile"] = {"data_type"=>"int",  "file_field"=>"Spring_MayNationalPercentileRank"      } if field_order.push("spring_percentile"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end