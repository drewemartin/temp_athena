#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ILP < Athena_Table
    
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

    def before_load_student_ilp(arg=nil)
        
        require "#{File.dirname(__FILE__).gsub("tables","data_processing")}/student_ilp_processes"
        process = STUDENT_ILP_PROCESSES.new
        
        begin
            process.reeval_reminders
        rescue=>e
            raise
            $base.system_notification(
                subject = "Student ILP Re-Evaluation Reminders Failed!",
                content = "#{e.message}"
            )
        end
        
        continue_with_load = false
        
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
                "name"              => "student_ilp",
                "file_name"         => "student_ilp.csv",
                "file_location"     => "student_ilp",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",            "file_field"=>"student_id"                  } if field_order.push("student_id"              )
            
            structure_hash["fields"]["ilp_entry_category_id"    ] = {"data_type"=>"int",            "file_field"=>"ilp_entry_category_id"       } if field_order.push("ilp_entry_category_id"   )
            structure_hash["fields"]["ilp_entry_type_id"        ] = {"data_type"=>"int",            "file_field"=>"ilp_entry_type_id"           } if field_order.push("ilp_entry_type_id"       )
            
            structure_hash["fields"]["goal_type"                ] = {"data_type"=>"text",           "file_field"=>"goal_type"                   } if field_order.push("goal_type"               )
            structure_hash["fields"]["description"              ] = {"data_type"=>"text",           "file_field"=>"description"                 } if field_order.push("description"             )
            structure_hash["fields"]["solution"                 ] = {"data_type"=>"text",           "file_field"=>"solution"                    } if field_order.push("solution"                )
            structure_hash["fields"]["completed"                ] = {"data_type"=>"bool",           "file_field"=>"completed"                   } if field_order.push("completed"               )
            structure_hash["fields"]["duration"                 ] = {"data_type"=>"text",           "file_field"=>"duration"                    } if field_order.push("duration"                )
            
            structure_hash["fields"]["monday"                   ] = {"data_type"=>"bool",           "file_field"=>"monday"                      } if field_order.push("monday"                  )
            structure_hash["fields"]["tuesday"                  ] = {"data_type"=>"bool",           "file_field"=>"tuesday"                     } if field_order.push("tuesday"                 )
            structure_hash["fields"]["wednesday"                ] = {"data_type"=>"bool",           "file_field"=>"wednesday"                   } if field_order.push("wednesday"               )
            structure_hash["fields"]["thursday"                 ] = {"data_type"=>"bool",           "file_field"=>"thursday"                    } if field_order.push("thursday"                )
            structure_hash["fields"]["friday"                   ] = {"data_type"=>"bool",           "file_field"=>"friday"                      } if field_order.push("friday"                  )
            
            structure_hash["fields"]["day1"                     ] = {"data_type"=>"bool",           "file_field"=>"day1"                        } if field_order.push("day1"                    )
            structure_hash["fields"]["day2"                     ] = {"data_type"=>"bool",           "file_field"=>"day2"                        } if field_order.push("day2"                    )
            structure_hash["fields"]["day3"                     ] = {"data_type"=>"bool",           "file_field"=>"day3"                        } if field_order.push("day3"                    )
            structure_hash["fields"]["day4"                     ] = {"data_type"=>"bool",           "file_field"=>"day4"                        } if field_order.push("day4"                    )
            structure_hash["fields"]["day5"                     ] = {"data_type"=>"bool",           "file_field"=>"day5"                        } if field_order.push("day5"                    )
            structure_hash["fields"]["day6"                     ] = {"data_type"=>"bool",           "file_field"=>"day6"                        } if field_order.push("day6"                    )
            structure_hash["fields"]["day7"                     ] = {"data_type"=>"bool",           "file_field"=>"day7"                        } if field_order.push("day7"                    )
            
            structure_hash["fields"]["expiration_date"          ] = {"data_type"=>"date",           "file_field"=>"expiration_date"             } if field_order.push("expiration_date"         )
            structure_hash["fields"]["pdf_excluded"             ] = {"data_type"=>"bool",           "file_field"=>"pdf_excluded"                } if field_order.push("pdf_excluded"            )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end