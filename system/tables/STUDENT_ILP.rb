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
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",            "file_field"=>"student_id"                  , :label=>"Student ID"          } if field_order.push("student_id"              )
            
            structure_hash["fields"]["ilp_entry_category_id"    ] = {"data_type"=>"int",            "file_field"=>"ilp_entry_category_id"       , :label=>"Category"            } if field_order.push("ilp_entry_category_id"   )
            structure_hash["fields"]["ilp_entry_type_id"        ] = {"data_type"=>"int",            "file_field"=>"ilp_entry_type_id"           , :label=>"Type"                } if field_order.push("ilp_entry_type_id"       )
            
            structure_hash["fields"]["goal_type"                ] = {"data_type"=>"text",           "file_field"=>"goal_type"                   , :label=>"Goal Type"           } if field_order.push("goal_type"               )
            structure_hash["fields"]["description"              ] = {"data_type"=>"text",           "file_field"=>"description"                 , :label=>"Description"         } if field_order.push("description"             )
            structure_hash["fields"]["solution"                 ] = {"data_type"=>"text",           "file_field"=>"solution"                    , :label=>"Solution"            } if field_order.push("solution"                )
            structure_hash["fields"]["completed"                ] = {"data_type"=>"bool",           "file_field"=>"completed"                   , :label=>"Completed"           } if field_order.push("completed"               )
            structure_hash["fields"]["progress"                 ] = {"data_type"=>"text",           "file_field"=>"progress"                    , :label=>"Progress"            } if field_order.push("progress"                )
            
            structure_hash["fields"]["monday"                   ] = {"data_type"=>"bool",           "file_field"=>"monday"                      , :label=>"Monday"              } if field_order.push("monday"                  )
            structure_hash["fields"]["tuesday"                  ] = {"data_type"=>"bool",           "file_field"=>"tuesday"                     , :label=>"Tuesday"             } if field_order.push("tuesday"                 )
            structure_hash["fields"]["wednesday"                ] = {"data_type"=>"bool",           "file_field"=>"wednesday"                   , :label=>"Wednesday"           } if field_order.push("wednesday"               )
            structure_hash["fields"]["thursday"                 ] = {"data_type"=>"bool",           "file_field"=>"thursday"                    , :label=>"Thursday"            } if field_order.push("thursday"                )
            structure_hash["fields"]["friday"                   ] = {"data_type"=>"bool",           "file_field"=>"friday"                      , :label=>"Friday"              } if field_order.push("friday"                  )
            
            structure_hash["fields"]["day1"                     ] = {"data_type"=>"bool",           "file_field"=>"day1"                        , :label=>"Day 1"               } if field_order.push("day1"                    )
            structure_hash["fields"]["day2"                     ] = {"data_type"=>"bool",           "file_field"=>"day2"                        , :label=>"Day 2"               } if field_order.push("day2"                    )
            structure_hash["fields"]["day3"                     ] = {"data_type"=>"bool",           "file_field"=>"day3"                        , :label=>"Day 3"               } if field_order.push("day3"                    )
            structure_hash["fields"]["day4"                     ] = {"data_type"=>"bool",           "file_field"=>"day4"                        , :label=>"Day 4"               } if field_order.push("day4"                    )
            structure_hash["fields"]["day5"                     ] = {"data_type"=>"bool",           "file_field"=>"day5"                        , :label=>"Day 5"               } if field_order.push("day5"                    )
            structure_hash["fields"]["day6"                     ] = {"data_type"=>"bool",           "file_field"=>"day6"                        , :label=>"Day 6"               } if field_order.push("day6"                    )
            structure_hash["fields"]["day7"                     ] = {"data_type"=>"bool",           "file_field"=>"day7"                        , :label=>"Day 7"               } if field_order.push("day7"                    )
            
            structure_hash["fields"]["expiration_date"          ] = {"data_type"=>"date",           "file_field"=>"expiration_date"             , :label=>"Re-Evaluation Date"  } if field_order.push("expiration_date"         )
            structure_hash["fields"]["pdf_excluded"             ] = {"data_type"=>"bool",           "file_field"=>"pdf_excluded"                , :label=>"Exclude from PDF?"   } if field_order.push("pdf_excluded"            )
            structure_hash["fields"]["pdf_order"                ] = {"data_type"=>"int",            "file_field"=>"pdf_excluded"                , :label=>"PDF sort order"      } if field_order.push("pdf_order"               )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end