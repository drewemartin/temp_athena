#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ILP_ENTRY_CATEGORY < Athena_Table
    
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
         
            {
                :grade_k=>true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>false, :grade_8th=>false, :grade_9th=>false, :grade_10th=>false, :grade_11th=>false, :grade_12th=>false,
                :name                       => "Sapphire Course Schedule EL",
                :display_type               => "Weekly",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>false, :grade_2nd=>false, :grade_3rd=>false, :grade_4th=>false, :grade_5th=>false, :grade_6th=>false, :grade_7th=>true, :grade_8th=>true, :grade_9th=>false, :grade_10th=>false, :grade_11th=>false, :grade_12th=>false,
                :name                       => "Sapphire Course Schedule MS",
                :display_type               => "7 Day",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>false, :grade_2nd=>false, :grade_3rd=>false, :grade_4th=>false, :grade_5th=>false, :grade_6th=>false, :grade_7th=>false, :grade_8th=>false, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "Sapphire Course Schedule HS",
                :display_type               => "6 Day",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>false, :grade_2nd=>false, :grade_3rd=>false, :grade_4th=>false, :grade_5th=>false, :grade_6th=>false, :grade_7th=>false, :grade_8th=>false, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "AIMS Assessment",
                :display_type               => "Table",
                :manual                     => false
            }
            
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
                "name"              => "ilp_entry_category",
                "file_name"         => "ilp_entry_category.csv",
                "file_location"     => "ilp_entry_category",
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
            
            structure_hash["fields"]["name"                             ] = {"data_type"=>"text", "file_field"=>"name"                          } if field_order.push("name"                            )
            structure_hash["fields"]["description"                      ] = {"data_type"=>"text", "file_field"=>"description"                   } if field_order.push("description"                     )
            structure_hash["fields"]["manual"                           ] = {"data_type"=>"bool", "file_field"=>"manual"                        } if field_order.push("manual"                          )
            structure_hash["fields"]["max_entries"                      ] = {"data_type"=>"int",  "file_field"=>"max_entries"                   } if field_order.push("max_entries"                     )
            structure_hash["fields"]["pdf_order"                        ] = {"data_type"=>"int",  "file_field"=>"pdf_order"                     } if field_order.push("pdf_order"                       )
            structure_hash["fields"]["display_type"                     ] = {"data_type"=>"text", "file_field"=>"display_type"                  } if field_order.push("display_type"                    )
            
            structure_hash["fields"]["interface_solution"               ] = {"data_type"=>"bool", "file_field"=>"interface_solution"            } if field_order.push("interface_solution"              )
            structure_hash["fields"]["interface_completed"              ] = {"data_type"=>"bool", "file_field"=>"interface_completed"           } if field_order.push("interface_completed"             )
            structure_hash["fields"]["interface_goal_type"              ] = {"data_type"=>"bool", "file_field"=>"interface_goal_type"           } if field_order.push("interface_goal_type"             )
            structure_hash["fields"]["interface_duration"               ] = {"data_type"=>"bool", "file_field"=>"interface_duration"            } if field_order.push("interface_duration"              )
            structure_hash["fields"]["interface_expiration_date"        ] = {"data_type"=>"bool", "file_field"=>"interface_expiration_date"     } if field_order.push("interface_expiration_date"       )
            structure_hash["fields"]["interface_responsible_parties"    ] = {"data_type"=>"bool", "file_field"=>"interface_responsible_parties" } if field_order.push("interface_responsible_parties"   )
            
            structure_hash["fields"]["pdf_solution"                     ] = {"data_type"=>"bool", "file_field"=>"pdf_solution"                  } if field_order.push("pdf_solution"                    )
            structure_hash["fields"]["pdf_completed"                    ] = {"data_type"=>"bool", "file_field"=>"pdf_completed"                 } if field_order.push("pdf_completed"                   )
            structure_hash["fields"]["pdf_goal_type"                    ] = {"data_type"=>"bool", "file_field"=>"pdf_goal_type"                 } if field_order.push("pdf_goal_type"                   )
            structure_hash["fields"]["pdf_duration"                     ] = {"data_type"=>"bool", "file_field"=>"pdf_duration"                  } if field_order.push("pdf_duration"                    )
            structure_hash["fields"]["pdf_expiration_date"              ] = {"data_type"=>"bool", "file_field"=>"pdf_expiration_date"           } if field_order.push("pdf_expiration_date"             )
            structure_hash["fields"]["pdf_responsible_parties"          ] = {"data_type"=>"bool", "file_field"=>"pdf_responsible_parties"       } if field_order.push("pdf_responsible_parties"         )
            
            structure_hash["fields"]["grade_k"                          ] = {"data_type"=>"bool", "file_field"=>"grade_k"                       } if field_order.push("grade_k"                         )
            structure_hash["fields"]["grade_1st"                        ] = {"data_type"=>"bool", "file_field"=>"grade_1st"                     } if field_order.push("grade_1st"                       )
            structure_hash["fields"]["grade_2nd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_2nd"                     } if field_order.push("grade_2nd"                       )
            structure_hash["fields"]["grade_3rd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_3rd"                     } if field_order.push("grade_3rd"                       )
            structure_hash["fields"]["grade_4th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_4th"                     } if field_order.push("grade_4th"                       )
            structure_hash["fields"]["grade_5th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_5th"                     } if field_order.push("grade_5th"                       )
            structure_hash["fields"]["grade_6th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_6th"                     } if field_order.push("grade_6th"                       )
            structure_hash["fields"]["grade_7th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_7th"                     } if field_order.push("grade_7th"                       )
            structure_hash["fields"]["grade_8th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_8th"                     } if field_order.push("grade_8th"                       )
            structure_hash["fields"]["grade_9th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_9th"                     } if field_order.push("grade_9th"                       )
            structure_hash["fields"]["grade_10th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_10th"                    } if field_order.push("grade_10th"                      )
            structure_hash["fields"]["grade_11th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_11th"                    } if field_order.push("grade_11th"                      )
            structure_hash["fields"]["grade_12th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_12th"                    } if field_order.push("grade_12th"                      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end