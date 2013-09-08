#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ATTENDANCE_ACTIVITY < Athena_Table
    
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
                "name"              => "student_attendance_activity",
                "file_name"         => "student_attendance_activity.csv",
                "file_location"     => "student_attendance_activity",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"   ] = {"data_type"=>"int",  "file_field"=>"student_id"} if field_order.push("student_id"  )
            structure_hash["fields"]["date"         ] = {"data_type"=>"date", "file_field"=>"date"      } if field_order.push("date"        )
            structure_hash["fields"]["source"       ] = {"data_type"=>"text", "file_field"=>"source"    } if field_order.push("source"      )
            structure_hash["fields"]["period"       ] = {"data_type"=>"text", "file_field"=>"period"    } if field_order.push("period"      )
            structure_hash["fields"]["class"        ] = {"data_type"=>"text", "file_field"=>"class"     } if field_order.push("class"       )
            structure_hash["fields"]["code"         ] = {"data_type"=>"text", "file_field"=>"code"      } if field_order.push("code"        )
            structure_hash["fields"]["team_id"      ] = {"data_type"=>"int",  "file_field"=>"team_id"   } if field_order.push("team_id"     )
            structure_hash["fields"]["logged"       ] = {"data_type"=>"bool", "file_field"=>"logged"    } if field_order.push("logged"      )
        
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end