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
                :grade_k=>true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>true, :grade_8th=>true, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "AIMS Assessment",
                :display_type               => "Table",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>true, :grade_8th=>true, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "Scantron Results",
                :display_type               => "Table",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>true, :grade_8th=>true, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "State Tests",
                :display_type               => "Table",
                :manual                     => false
            },
            {
                :grade_k=>true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>true, :grade_8th=>true, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                :name                       => "Student Information Survey",
                :display_type               => "Table 2",
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
            structure_hash["fields"]["interface_progress"               ] = {"data_type"=>"bool", "file_field"=>"interface_progress"            } if field_order.push("interface_progress"              )
            structure_hash["fields"]["interface_expiration_date"        ] = {"data_type"=>"bool", "file_field"=>"interface_expiration_date"     } if field_order.push("interface_expiration_date"       )
            structure_hash["fields"]["interface_responsible_parties"    ] = {"data_type"=>"bool", "file_field"=>"interface_responsible_parties" } if field_order.push("interface_responsible_parties"   )
            
            ######################################################################################################################
            #ALL STUDENT ILP FIELDS SHOULD BE LISTED HERE, THIS WAY THE USER CAN HAVE THE OPTION OF INCLDING THAT FIELD ON THE PDF
            #DISPLAY ON INTERFACE?
            structure_hash["fields"]["interface_ilp_entry_category_id"  ] = {"data_type"=>"bool", "file_field"=>"interface_ilp_entry_category_id"       } if field_order.push("interface_ilp_entry_category_id" )
            structure_hash["fields"]["interface_ilp_entry_type_id"      ] = {"data_type"=>"bool", "file_field"=>"interface_ilp_entry_type_id"           } if field_order.push("interface_ilp_entry_type_id"     )
            structure_hash["fields"]["interface_goal_type"              ] = {"data_type"=>"bool", "file_field"=>"interface_goal_type"                   } if field_order.push("interface_goal_type"             )
            structure_hash["fields"]["interface_description"            ] = {"data_type"=>"bool", "file_field"=>"interface_description"                 } if field_order.push("interface_description"           )
            structure_hash["fields"]["interface_solution"               ] = {"data_type"=>"bool", "file_field"=>"interface_solution"                    } if field_order.push("interface_solution"              )
            structure_hash["fields"]["interface_completed"              ] = {"data_type"=>"bool", "file_field"=>"interface_completed"                   } if field_order.push("interface_completed"             )
            structure_hash["fields"]["interface_progress"               ] = {"data_type"=>"bool", "file_field"=>"interface_progress"                    } if field_order.push("interface_progress"              )
            structure_hash["fields"]["interface_monday"                 ] = {"data_type"=>"bool", "file_field"=>"interface_monday"                      } if field_order.push("interface_monday"                )
            structure_hash["fields"]["interface_tuesday"                ] = {"data_type"=>"bool", "file_field"=>"interface_tuesday"                     } if field_order.push("interface_tuesday"               )
            structure_hash["fields"]["interface_wednesday"              ] = {"data_type"=>"bool", "file_field"=>"interface_wednesday"                   } if field_order.push("interface_wednesday"             )
            structure_hash["fields"]["interface_thursday"               ] = {"data_type"=>"bool", "file_field"=>"interface_thursday"                    } if field_order.push("interface_thursday"              )
            structure_hash["fields"]["interface_friday"                 ] = {"data_type"=>"bool", "file_field"=>"interface_friday"                      } if field_order.push("interface_friday"                )
            structure_hash["fields"]["interface_day1"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day1"                        } if field_order.push("interface_day1"                  )
            structure_hash["fields"]["interface_day2"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day2"                        } if field_order.push("interface_day2"                  )
            structure_hash["fields"]["interface_day3"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day3"                        } if field_order.push("interface_day3"                  )
            structure_hash["fields"]["interface_day4"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day4"                        } if field_order.push("interface_day4"                  )
            structure_hash["fields"]["interface_day5"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day5"                        } if field_order.push("interface_day5"                  )
            structure_hash["fields"]["interface_day6"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day6"                        } if field_order.push("interface_day6"                  )
            structure_hash["fields"]["interface_day7"                   ] = {"data_type"=>"bool", "file_field"=>"interface_day7"                        } if field_order.push("interface_day7"                  )
            structure_hash["fields"]["interface_expiration_date"        ] = {"data_type"=>"bool", "file_field"=>"interface_expiration_date"             } if field_order.push("interface_expiration_date"       )
            structure_hash["fields"]["interface_pdf_excluded"           ] = {"data_type"=>"bool", "file_field"=>"interface_pdf_excluded"                } if field_order.push("interface_pdf_excluded"          )
            structure_hash["fields"]["interface_responsible_parties"    ] = {"data_type"=>"bool", "file_field"=>"interface_responsible_parties"         } if field_order.push("interface_responsible_parties"   )
            #DISPLAY ON PDF?
            structure_hash["fields"]["pdf_ilp_entry_category_id"        ] = {"data_type"=>"bool", "file_field"=>"pdf_ilp_entry_category_id"             } if field_order.push("pdf_ilp_entry_category_id"       )
            structure_hash["fields"]["pdf_ilp_entry_type_id"            ] = {"data_type"=>"bool", "file_field"=>"pdf_ilp_entry_type_id"                 } if field_order.push("pdf_ilp_entry_type_id"           )
            structure_hash["fields"]["pdf_goal_type"                    ] = {"data_type"=>"bool", "file_field"=>"pdf_goal_type"                         } if field_order.push("pdf_goal_type"                   )
            structure_hash["fields"]["pdf_description"                  ] = {"data_type"=>"bool", "file_field"=>"pdf_description"                       } if field_order.push("pdf_description"                 )
            structure_hash["fields"]["pdf_solution"                     ] = {"data_type"=>"bool", "file_field"=>"pdf_solution"                          } if field_order.push("pdf_solution"                    )
            structure_hash["fields"]["pdf_completed"                    ] = {"data_type"=>"bool", "file_field"=>"pdf_completed"                         } if field_order.push("pdf_completed"                   )
            structure_hash["fields"]["pdf_progress"                     ] = {"data_type"=>"bool", "file_field"=>"pdf_progress"                          } if field_order.push("pdf_progress"                    )
            structure_hash["fields"]["pdf_monday"                       ] = {"data_type"=>"bool", "file_field"=>"pdf_monday"                            } if field_order.push("pdf_monday"                      )
            structure_hash["fields"]["pdf_tuesday"                      ] = {"data_type"=>"bool", "file_field"=>"pdf_tuesday"                           } if field_order.push("pdf_tuesday"                     )
            structure_hash["fields"]["pdf_wednesday"                    ] = {"data_type"=>"bool", "file_field"=>"pdf_wednesday"                         } if field_order.push("pdf_wednesday"                   )
            structure_hash["fields"]["pdf_thursday"                     ] = {"data_type"=>"bool", "file_field"=>"pdf_thursday"                          } if field_order.push("pdf_thursday"                    )
            structure_hash["fields"]["pdf_friday"                       ] = {"data_type"=>"bool", "file_field"=>"pdf_friday"                            } if field_order.push("pdf_friday"                      )
            structure_hash["fields"]["pdf_day1"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day1"                              } if field_order.push("pdf_day1"                        )
            structure_hash["fields"]["pdf_day2"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day2"                              } if field_order.push("pdf_day2"                        )
            structure_hash["fields"]["pdf_day3"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day3"                              } if field_order.push("pdf_day3"                        )
            structure_hash["fields"]["pdf_day4"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day4"                              } if field_order.push("pdf_day4"                        )
            structure_hash["fields"]["pdf_day5"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day5"                              } if field_order.push("pdf_day5"                        )
            structure_hash["fields"]["pdf_day6"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day6"                              } if field_order.push("pdf_day6"                        )
            structure_hash["fields"]["pdf_day7"                         ] = {"data_type"=>"bool", "file_field"=>"pdf_day7"                              } if field_order.push("pdf_day7"                        )
            structure_hash["fields"]["pdf_expiration_date"              ] = {"data_type"=>"bool", "file_field"=>"pdf_expiration_date"                   } if field_order.push("pdf_expiration_date"             )
            structure_hash["fields"]["pdf_pdf_excluded"                 ] = {"data_type"=>"bool", "file_field"=>"pdf_pdf_excluded"                      } if field_order.push("pdf_pdf_excluded"                )
            structure_hash["fields"]["pdf_responsible_parties"          ] = {"data_type"=>"bool", "file_field"=>"pdf_responsible_parties"               } if field_order.push("pdf_responsible_parties"         )
            #DISPLAY ORDER
            structure_hash["fields"]["order_ilp_entry_category_id"      ] = {"data_type"=>"int",  "file_field"=>"order_ilp_entry_category_id"           } if field_order.push("order_ilp_entry_category_id"     )
            structure_hash["fields"]["order_ilp_entry_type_id"          ] = {"data_type"=>"int",  "file_field"=>"order_ilp_entry_type_id"               } if field_order.push("order_ilp_entry_type_id"         )
            structure_hash["fields"]["order_goal_type"                  ] = {"data_type"=>"int",  "file_field"=>"order_goal_type"                       } if field_order.push("order_goal_type"                 )
            structure_hash["fields"]["order_description"                ] = {"data_type"=>"int",  "file_field"=>"order_description"                     } if field_order.push("order_description"               )
            structure_hash["fields"]["order_solution"                   ] = {"data_type"=>"int",  "file_field"=>"order_solution"                        } if field_order.push("order_solution"                  )
            structure_hash["fields"]["order_completed"                  ] = {"data_type"=>"int",  "file_field"=>"order_completed"                       } if field_order.push("order_completed"                 )
            structure_hash["fields"]["order_progress"                   ] = {"data_type"=>"int",  "file_field"=>"order_progress"                        } if field_order.push("order_progress"                  )
            structure_hash["fields"]["order_monday"                     ] = {"data_type"=>"int",  "file_field"=>"order_monday"                          } if field_order.push("order_monday"                    )
            structure_hash["fields"]["order_tuesday"                    ] = {"data_type"=>"int",  "file_field"=>"order_tuesday"                         } if field_order.push("order_tuesday"                   )
            structure_hash["fields"]["order_wednesday"                  ] = {"data_type"=>"int",  "file_field"=>"order_wednesday"                       } if field_order.push("order_wednesday"                 )
            structure_hash["fields"]["order_thursday"                   ] = {"data_type"=>"int",  "file_field"=>"order_thursday"                        } if field_order.push("order_thursday"                  )
            structure_hash["fields"]["order_friday"                     ] = {"data_type"=>"int",  "file_field"=>"order_friday"                          } if field_order.push("order_friday"                    )
            structure_hash["fields"]["order_day1"                       ] = {"data_type"=>"int",  "file_field"=>"order_day1"                            } if field_order.push("order_day1"                      )
            structure_hash["fields"]["order_day2"                       ] = {"data_type"=>"int",  "file_field"=>"order_day2"                            } if field_order.push("order_day2"                      )
            structure_hash["fields"]["order_day3"                       ] = {"data_type"=>"int",  "file_field"=>"order_day3"                            } if field_order.push("order_day3"                      )
            structure_hash["fields"]["order_day4"                       ] = {"data_type"=>"int",  "file_field"=>"order_day4"                            } if field_order.push("order_day4"                      )
            structure_hash["fields"]["order_day5"                       ] = {"data_type"=>"int",  "file_field"=>"order_day5"                            } if field_order.push("order_day5"                      )
            structure_hash["fields"]["order_day6"                       ] = {"data_type"=>"int",  "file_field"=>"order_day6"                            } if field_order.push("order_day6"                      )
            structure_hash["fields"]["order_day7"                       ] = {"data_type"=>"int",  "file_field"=>"order_day7"                            } if field_order.push("order_day7"                      )
            structure_hash["fields"]["order_expiration_date"            ] = {"data_type"=>"int",  "file_field"=>"order_expiration_date"                 } if field_order.push("order_expiration_date"           )
            structure_hash["fields"]["order_pdf_excluded"               ] = {"data_type"=>"int",  "file_field"=>"order_pdf_excluded"                    } if field_order.push("order_pdf_excluded"              )
            structure_hash["fields"]["order_responsible_parties"        ] = {"data_type"=>"int",  "file_field"=>"order_responsible_parties"             } if field_order.push("order_responsible_parties"       )
            #DISPLAY LABEL
            structure_hash["fields"]["label_ilp_entry_category_id"      ] = {"data_type"=>"text",  "file_field"=>"label_ilp_entry_category_id"           } if field_order.push("label_ilp_entry_category_id"     )
            structure_hash["fields"]["label_ilp_entry_type_id"          ] = {"data_type"=>"text",  "file_field"=>"label_ilp_entry_type_id"               } if field_order.push("label_ilp_entry_type_id"         )
            structure_hash["fields"]["label_goal_type"                  ] = {"data_type"=>"text",  "file_field"=>"label_goal_type"                       } if field_order.push("label_goal_type"                 )
            structure_hash["fields"]["label_description"                ] = {"data_type"=>"text",  "file_field"=>"label_description"                     } if field_order.push("label_description"               )
            structure_hash["fields"]["label_solution"                   ] = {"data_type"=>"text",  "file_field"=>"label_solution"                        } if field_order.push("label_solution"                  )
            structure_hash["fields"]["label_completed"                  ] = {"data_type"=>"text",  "file_field"=>"label_completed"                       } if field_order.push("label_completed"                 )
            structure_hash["fields"]["label_progress"                   ] = {"data_type"=>"text",  "file_field"=>"label_progress"                        } if field_order.push("label_progress"                  )
            structure_hash["fields"]["label_monday"                     ] = {"data_type"=>"text",  "file_field"=>"label_monday"                          } if field_order.push("label_monday"                    )
            structure_hash["fields"]["label_tuesday"                    ] = {"data_type"=>"text",  "file_field"=>"label_tuesday"                         } if field_order.push("label_tuesday"                   )
            structure_hash["fields"]["label_wednesday"                  ] = {"data_type"=>"text",  "file_field"=>"label_wednesday"                       } if field_order.push("label_wednesday"                 )
            structure_hash["fields"]["label_thursday"                   ] = {"data_type"=>"text",  "file_field"=>"label_thursday"                        } if field_order.push("label_thursday"                  )
            structure_hash["fields"]["label_friday"                     ] = {"data_type"=>"text",  "file_field"=>"label_friday"                          } if field_order.push("label_friday"                    )
            structure_hash["fields"]["label_day1"                       ] = {"data_type"=>"text",  "file_field"=>"label_day1"                            } if field_order.push("label_day1"                      )
            structure_hash["fields"]["label_day2"                       ] = {"data_type"=>"text",  "file_field"=>"label_day2"                            } if field_order.push("label_day2"                      )
            structure_hash["fields"]["label_day3"                       ] = {"data_type"=>"text",  "file_field"=>"label_day3"                            } if field_order.push("label_day3"                      )
            structure_hash["fields"]["label_day4"                       ] = {"data_type"=>"text",  "file_field"=>"label_day4"                            } if field_order.push("label_day4"                      )
            structure_hash["fields"]["label_day5"                       ] = {"data_type"=>"text",  "file_field"=>"label_day5"                            } if field_order.push("label_day5"                      )
            structure_hash["fields"]["label_day6"                       ] = {"data_type"=>"text",  "file_field"=>"label_day6"                            } if field_order.push("label_day6"                      )
            structure_hash["fields"]["label_day7"                       ] = {"data_type"=>"text",  "file_field"=>"label_day7"                            } if field_order.push("label_day7"                      )
            structure_hash["fields"]["label_expiration_date"            ] = {"data_type"=>"text",  "file_field"=>"label_expiration_date"                 } if field_order.push("label_expiration_date"           )
            structure_hash["fields"]["label_pdf_excluded"               ] = {"data_type"=>"text",  "file_field"=>"label_pdf_excluded"                    } if field_order.push("label_pdf_excluded"              )
            structure_hash["fields"]["label_responsible_parties"        ] = {"data_type"=>"text",  "file_field"=>"label_responsible_parties"             } if field_order.push("label_responsible_parties"       )
            ######################################################################################################################
            
            structure_hash["fields"]["grade_k"                          ] = {"data_type"=>"bool", "file_field"=>"grade_k"                               } if field_order.push("grade_k"                         )
            structure_hash["fields"]["grade_1st"                        ] = {"data_type"=>"bool", "file_field"=>"grade_1st"                             } if field_order.push("grade_1st"                       )
            structure_hash["fields"]["grade_2nd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_2nd"                             } if field_order.push("grade_2nd"                       )
            structure_hash["fields"]["grade_3rd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_3rd"                             } if field_order.push("grade_3rd"                       )
            structure_hash["fields"]["grade_4th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_4th"                             } if field_order.push("grade_4th"                       )
            structure_hash["fields"]["grade_5th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_5th"                             } if field_order.push("grade_5th"                       )
            structure_hash["fields"]["grade_6th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_6th"                             } if field_order.push("grade_6th"                       )
            structure_hash["fields"]["grade_7th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_7th"                             } if field_order.push("grade_7th"                       )
            structure_hash["fields"]["grade_8th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_8th"                             } if field_order.push("grade_8th"                       )
            structure_hash["fields"]["grade_9th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_9th"                             } if field_order.push("grade_9th"                       )
            structure_hash["fields"]["grade_10th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_10th"                            } if field_order.push("grade_10th"                      )
            structure_hash["fields"]["grade_11th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_11th"                            } if field_order.push("grade_11th"                      )
            structure_hash["fields"]["grade_12th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_12th"                            } if field_order.push("grade_12th"                      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end