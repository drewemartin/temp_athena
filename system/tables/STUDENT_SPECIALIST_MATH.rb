#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SPECIALIST_MATH < Athena_Table
    
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

    def after_change_field_team_id(field_object)
        
        specialist_record          = by_primary_id(field_object.primary_id)
        $tables.attach("STUDENT_RELATE").relate_specialist(specialist_record)
        
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
                "name"              => "student_specialist_math",
                "file_name"         => "student_specialist_math.csv",
                "file_location"     => "student_specialist_math",
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
            structure_hash["fields"]["team_id"      ] = {"data_type"=>"int",  "file_field"=>"team_id"       } if field_order.push("team_id"     )
            structure_hash["fields"]["monday"       ] = {"data_type"=>"bool", "file_field"=>"monday"        } if field_order.push("monday"      )
            structure_hash["fields"]["tuesday"      ] = {"data_type"=>"bool", "file_field"=>"tuesday"       } if field_order.push("tuesday"     )
            structure_hash["fields"]["wednesday"    ] = {"data_type"=>"bool", "file_field"=>"wednesday"     } if field_order.push("wednesday"   )
            structure_hash["fields"]["thursday"     ] = {"data_type"=>"bool", "file_field"=>"thursday"      } if field_order.push("thursday"    )
            structure_hash["fields"]["friday"       ] = {"data_type"=>"bool", "file_field"=>"friday"        } if field_order.push("friday"      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end