#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_PARTICIPATION < Athena_Table
    
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
                "name"              => "student_participation",
                "file_name"         => "student_participation.csv",
                "file_location"     => "student_participation",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"   ] = {"data_type"=>"int",  "file_field"=>"student_id"    } if field_order.push("student_id"  )
            structure_hash["fields"]["keystone"     ] = {"data_type"=>"bool", "file_field"=>"keystone"      } if field_order.push("keystone"    )
            structure_hash["fields"]["aims_fall"    ] = {"data_type"=>"bool", "file_field"=>"aims_fall"     } if field_order.push("aims_fall"   )
            structure_hash["fields"]["aims_spring"  ] = {"data_type"=>"bool", "file_field"=>"aims_spring"   } if field_order.push("aims_spring" )
            structure_hash["fields"]["study_island" ] = {"data_type"=>"bool", "file_field"=>"study_island"  } if field_order.push("study_island")
            structure_hash["fields"]["pssa"         ] = {"data_type"=>"bool", "file_field"=>"pssa"          } if field_order.push("pssa"        )
            structure_hash["fields"]["define_u"     ] = {"data_type"=>"bool", "file_field"=>"define_u"      } if field_order.push("define_u"    )
            structure_hash["fields"]["ayp"          ] = {"data_type"=>"bool", "file_field"=>"ayp"           } if field_order.push("ayp"         )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end