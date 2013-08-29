#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_CALENDARS_CALENDARS < Athena_Table
    
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
                "name"              => "sapphire_calendars_calendars",
                "file_name"         => "sapphire_calendars_calendars.csv",
                "file_location"     => "sapphire_calendars_calendars",
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
            
            structure_hash["fields"]["date"                     ] = {"data_type"=>"date", "file_field"=>"date"                  } if field_order.push("date"                )
            structure_hash["fields"]["day"                      ] = {"data_type"=>"text", "file_field"=>"day"                   } if field_order.push("day"                 )
            structure_hash["fields"]["non_school_day_type"      ] = {"data_type"=>"text", "file_field"=>"non_school_day_type"   } if field_order.push("non_school_day_type" )
            structure_hash["fields"]["day_code"                 ] = {"data_type"=>"text", "file_field"=>"day_code"              } if field_order.push("day_code"            )
            structure_hash["fields"]["count_day"                ] = {"data_type"=>"bool", "file_field"=>"count_day"             } if field_order.push("count_day"           )
            structure_hash["fields"]["student_attend"           ] = {"data_type"=>"text", "file_field"=>"student_attend"        } if field_order.push("student_attend"      )
            structure_hash["fields"]["school"                   ] = {"data_type"=>"text", "file_field"=>"school"                } if field_order.push("school"              )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end