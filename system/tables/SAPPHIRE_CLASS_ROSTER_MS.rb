#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_CLASS_ROSTER_MS < Athena_Table
    
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

    def after_load_sapphire_class_roster_ms
        
        $tables.attach("DAILY_ATTENDANCE_LOG").log_completed($idate, "sapphire_class_roster_ms")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
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
                :data_base          => "#{$config.school_name}_sapphire",
                "name"              => "sapphire_class_roster_ms",
                "file_name"         => "sapphire_class_roster_ms.csv",
                "file_location"     => "sapphire_class_roster_ms",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"                       ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"                    } if field_order.push("student_id"                      )
            structure_hash["fields"]["school_year"                      ] = {"data_type"=>"int",  "file_field"=>"SCHOOL_YEAR"                   } if field_order.push("school_year"                     )
            structure_hash["fields"]["school_id"                        ] = {"data_type"=>"text", "file_field"=>"SCHOOL_ID"                     } if field_order.push("school_id"                       )
            structure_hash["fields"]["course_id"                        ] = {"data_type"=>"text", "file_field"=>"COURSE_ID"                     } if field_order.push("course_id"                       )
            structure_hash["fields"]["course_title"                     ] = {"data_type"=>"text", "file_field"=>"COURSE_TITLE"                  } if field_order.push("course_title"                    )
            structure_hash["fields"]["section_id"                       ] = {"data_type"=>"text", "file_field"=>"SECTION_ID"                    } if field_order.push("section_id"                      )
            structure_hash["fields"]["dept_code"                        ] = {"data_type"=>"text", "file_field"=>"DEPT_CODE"                     } if field_order.push("dept_code"                       )
            structure_hash["fields"]["duration_code"                    ] = {"data_type"=>"text", "file_field"=>"DURATION_CODE"                 } if field_order.push("duration_code"                   )
            structure_hash["fields"]["duration_desc"                    ] = {"data_type"=>"text", "file_field"=>"DURATION_DESC"                 } if field_order.push("duration_desc"                   )
            structure_hash["fields"]["pattern"                          ] = {"data_type"=>"text", "file_field"=>"PATTERN"                       } if field_order.push("pattern"                         )
            structure_hash["fields"]["staff_name"                       ] = {"data_type"=>"text", "file_field"=>"STAFF_NAME"                    } if field_order.push("staff_name"                      )
            structure_hash["fields"]["staff_id"                         ] = {"data_type"=>"text", "file_field"=>"STAFF_ID"                      } if field_order.push("staff_id"                        )
            structure_hash["fields"]["room_code"                        ] = {"data_type"=>"text", "file_field"=>"ROOM_CODE"                     } if field_order.push("room_code"                       )
            structure_hash["fields"]["room_desc"                        ] = {"data_type"=>"text", "file_field"=>"ROOM_DESC"                     } if field_order.push("room_desc"                       )
            structure_hash["fields"]["subject_area_code"                ] = {"data_type"=>"text", "file_field"=>"SUBJECT_AREA_CODE"             } if field_order.push("subject_area_code"               )
            structure_hash["fields"]["last_name"                        ] = {"data_type"=>"text", "file_field"=>"LAST_NAME"                     } if field_order.push("last_name"                       )
            structure_hash["fields"]["first_name"                       ] = {"data_type"=>"text", "file_field"=>"FIRST_NAME"                    } if field_order.push("first_name"                      )
            structure_hash["fields"]["middle_name"                      ] = {"data_type"=>"text", "file_field"=>"MIDDLE_NAME"                   } if field_order.push("middle_name"                     )
            structure_hash["fields"]["status_flg"                       ] = {"data_type"=>"text", "file_field"=>"STATUS_FLG"                    } if field_order.push("status_flg"                      )
            structure_hash["fields"]["add_drop_flg"                     ] = {"data_type"=>"text", "file_field"=>"ADD_DROP_FLG"                  } if field_order.push("add_drop_flg"                    )
            structure_hash["fields"]["birth_date"                       ] = {"data_type"=>"date", "file_field"=>"BIRTH_DATE"                    } if field_order.push("birth_date"                      )
            structure_hash["fields"]["counselor_name"                   ] = {"data_type"=>"text", "file_field"=>"COUNSELOR_NAME"                } if field_order.push("counselor_name"                  )
            structure_hash["fields"]["curriculum_code"                  ] = {"data_type"=>"text", "file_field"=>"CURRICULUM_CODE"               } if field_order.push("curriculum_code"                 )
            structure_hash["fields"]["curriculum_desc"                  ] = {"data_type"=>"text", "file_field"=>"CURRICULUM_DESC"               } if field_order.push("curriculum_desc"                 )
            structure_hash["fields"]["gender"                           ] = {"data_type"=>"text", "file_field"=>"GENDER"                        } if field_order.push("gender"                          )
            structure_hash["fields"]["grade_level"                      ] = {"data_type"=>"text", "file_field"=>"GRADE_LEVEL"                   } if field_order.push("grade_level"                     )
            structure_hash["fields"]["home_room"                        ] = {"data_type"=>"text", "file_field"=>"HOME_ROOM"                     } if field_order.push("home_room"                       )
            structure_hash["fields"]["pims_giep_flg"                    ] = {"data_type"=>"text", "file_field"=>"PIMS_GIEP_FLG"                 } if field_order.push("pims_giep_flg"                   )
            structure_hash["fields"]["in_special_ed_flg"                ] = {"data_type"=>"text", "file_field"=>"IN_SPECIAL_ED_FLG"             } if field_order.push("in_special_ed_flg"               )
            structure_hash["fields"]["pims_service_plan_flg"            ] = {"data_type"=>"text", "file_field"=>"PIMS_SERVICE_PLAN_FLG"         } if field_order.push("pims_service_plan_flg"           )
            structure_hash["fields"]["special_service_start_date"       ] = {"data_type"=>"date", "file_field"=>"SPECIAL_SERVICE_START_DATE"    } if field_order.push("special_service_start_date"      )
            structure_hash["fields"]["special_service_exit_date"        ] = {"data_type"=>"date", "file_field"=>"SPECIAL_SERVICE_EXIT_DATE"     } if field_order.push("special_service_exit_date"       )
            structure_hash["fields"]["state_student_id"                 ] = {"data_type"=>"text", "file_field"=>"STATE_STUDENT_ID"              } if field_order.push("state_student_id"                )
            structure_hash["fields"]["meal_status"                      ] = {"data_type"=>"text", "file_field"=>"MEAL_STATUS"                   } if field_order.push("meal_status"                     )
            structure_hash["fields"]["ethnicity"                        ] = {"data_type"=>"text", "file_field"=>"ETHNICITY"                     } if field_order.push("ethnicity"                       )
            structure_hash["fields"]["ethnicity_desc"                   ] = {"data_type"=>"text", "file_field"=>"ETHNICITY_DESC"                } if field_order.push("ethnicity_desc"                  )
            structure_hash["fields"]["state_ethnicity_code"             ] = {"data_type"=>"text", "file_field"=>"STATE_ETHNICITY_CODE"          } if field_order.push("state_ethnicity_code"            )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end