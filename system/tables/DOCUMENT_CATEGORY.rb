#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DOCUMENT_CATEGORY < Athena_Table
    
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

    def load_pre_reqs
        
        pre_reqs = [
            
            {:name=> "Truancy"                          },
            {:name=> "Withdrawals"                      },
            {:name=> "Team Member Evaluations"          },
            {:name=> "Supplies"                         },
            {:name=> "Enrollment"                       },
            {:name=> "Attendance"                       },
            {:name=> "Sapphire Imports"                 },
            {:name=> "Sapphire Exports"                 },
            {:name=> "Sapphire Reports"                 },
            {:name=> "Nursing"                          },
            {:name=> "Individualized Learning Plan"     },
            {:name=> "Athena"                           },
            {:name=> "Scantron"                         },
            {:name=> "Table Imports"                    }
            
        ]
        
        max = pre_reqs.length
        (0...max).each{|i|
            
            if primary_ids("WHERE name = '#{pre_reqs[i][:name]}'")
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "document_category",
                "file_name"         => "document_category.csv",
                "file_location"     => "document_category",
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
            
            structure_hash["fields"]["name"         ] = {"data_type"=>"text", "file_field"=>"name"          } if field_order.push("name"            )
            structure_hash["fields"]["department_id"] = {"data_type"=>"int",  "file_field"=>"department_id" } if field_order.push("department_id"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end