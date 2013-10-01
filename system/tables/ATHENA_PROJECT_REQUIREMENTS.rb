#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATHENA_PROJECT_REQUIREMENTS < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "athena_project_requirements",
                "file_name"         => "athena_project_requirements.csv",
                "file_location"     => "athena_project_requirements",
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
            
            structure_hash["fields"]["project_id"               ] = {"data_type"=>"int",  "file_field"=>"project_id"            } if field_order.push("project_id"              )
            structure_hash["fields"]["requirement"              ] = {"data_type"=>"text", "file_field"=>"requirement"           } if field_order.push("requirement"             )
            structure_hash["fields"]["phase"                    ] = {"data_type"=>"int",  "file_field"=>"phase"                 } if field_order.push("phase"                   )
            structure_hash["fields"]["automated_process"        ] = {"data_type"=>"bool", "file_field"=>"automated_process"     } if field_order.push("automated_process"       )
            structure_hash["fields"]["pdf_template"             ] = {"data_type"=>"bool", "file_field"=>"pdf_template"          } if field_order.push("pdf_template"            )
            structure_hash["fields"]["process_improvement"      ] = {"data_type"=>"bool", "file_field"=>"process_improvement"   } if field_order.push("process_improvement"     )
            structure_hash["fields"]["report"                   ] = {"data_type"=>"bool", "file_field"=>"report"                } if field_order.push("report"                  )
            structure_hash["fields"]["system_interface"         ] = {"data_type"=>"bool", "file_field"=>"system_interface"      } if field_order.push("system_interface"        )
            structure_hash["fields"]["user_interface"           ] = {"data_type"=>"bool", "file_field"=>"user_interface"        } if field_order.push("user_interface"          )
            structure_hash["fields"]["change"                   ] = {"data_type"=>"bool", "file_field"=>"change"                } if field_order.push("change"                  )
            structure_hash["fields"]["priority"                 ] = {"data_type"=>"text", "file_field"=>"priority"              } if field_order.push("priority"                )
            
        structure_hash["field_order"] = field_order
        
        return structure_hash
        
    end

end