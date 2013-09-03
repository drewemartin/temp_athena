#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATTENDANCE_MODES < Athena_Table
    
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

    def sources_by_mode(mode)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("mode", "=", mode) )
        where_clause = $db.where_clause(params)
        find_field("sources", where_clause)
    end
    
    def modes_array
        return $db.get_data_single("SELECT mode FROM #{data_base}.attendance_modes")
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def load_pre_reqs
        
        pre_reqs = [
            {:mode=>"Academic Plan",            :description=>nil,      :procedure_type =>"Override Procedure"                  },
            {:mode=>"Activity - Not Enrolled",  :description=>nil,      :procedure_type =>"Not Enrolled"                        },
            {:mode=>"Asynchronous",             :description=>nil,      :procedure_type =>"Activity OR Live Sessions"           },
            {:mode=>"Exempt",                   :description=>nil,      :procedure_type =>"Manual (default a)"                  },
            {:mode=>"Flex",                     :description=>nil,      :procedure_type =>"Activity OR Live Sessions"           },
            {:mode=>"HS Senior Project",        :description=>nil,      :procedure_type =>"Activity OR Live Sessions"           },
            {:mode=>"SED-Changed",              :description=>nil,      :procedure_type =>"Not Enrolled"                        },
            {:mode=>"Synchronous",              :description=>nil,      :procedure_type =>"Classroom Activity (50% or more)"    },
            {:mode=>"Withdrawn",                :description=>nil,      :procedure_type =>"Not Enrolled"                        },
        ]
        
        max = pre_reqs.length
        (0...max).each{|i|
            
            if primary_ids("WHERE mode = '#{pre_reqs[i][:mode]}'")
                pre_reqs[i] = nil
            end
            
        }
        
        pre_reqs.compact!
        
        return pre_reqs
        
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
                "name"              => "attendance_modes",
                "file_name"         => "attendance_modes.csv",
                "file_location"     => "attendance_modes",
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
            
            structure_hash["fields"]["mode"                     ] = {"data_type"=>"text", "file_field"=>"mode"                  } if field_order.push("mode"                )
            structure_hash["fields"]["description"              ] = {"data_type"=>"text", "file_field"=>"description"           } if field_order.push("description"         )
            structure_hash["fields"]["procedure_type"           ] = {"data_type"=>"text", "file_field"=>"procedure_type"        } if field_order.push("procedure_type"      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end