#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SAPPHIRE_CLASS_ROSTER < Athena_Table
    
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
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def create_student_ILP_records
        #iterate through each primary_id in student_sapphire_class_roster
        pids = $tables.attach("student_sapphire_class_roster").primary_ids
        pids.each{|pid|
            record = $tables.attach("student_sapphire_class_roster").by_primary_id(pid)
            course_id = record.fields["course_id"].value
            section_id = record.fields["section_id"].value
            student_id = record.fields["student_id"].value
            
            #check to see if student already has this ilp record
            sol = "#{course_id} - #{section_id}"
            ilps = $tables.attach("student_ilp").primary_ids(
                "WHERE student_id   = '#{student_id}'
                AND solution        = '#{sol}'"
            )
            
            #student doesn't already have this ilp record
            if !ilps
                new_row = $tables.attach("student_ilp").new_row
                
                pattern = record.fields["pattern"].value
                arr = pattern.partition("(")
                per_code = arr[0].strip
                arr2 = arr[2].partition(")")
                days = arr2[0]
                school_type = $tables.attach("sapphire_dictionary_periods").find_field("school_type", "WHERE period_code='#{per_code}'")
                
                new_row.fields["student_id"             ].value = student_id
                new_row.fields["ilp_entry_category_id"  ].value = $tables.attach("ilp_entry_category").find_field("primary_id", "WHERE name='Sapphire Course Schedule #{school_type}'").value
                
                new_row.fields["ilp_entry_type_id"      ].value = $tables.attach("ilp_entry_type").find_field("primary_id", "WHERE name='#{per_code}'").value
                new_row.fields["description"            ].value = "#{record.fields["course_title"].value} - #{record.fields["staff_name"].value}"
                new_row.fields["solution"               ].value = "#{course_id} - #{section_id}"
                
                new_row.fields["monday"                 ].value = (days.include?("M") ? true : false)
                new_row.fields["tuesday"                ].value = (days.include?("T") ? true : false)
                new_row.fields["wednesday"              ].value = (days.include?("W") ? true : false)
                new_row.fields["thursday"               ].value = (days.include?("R") ? true : false)
                new_row.fields["friday"                 ].value = (days.include?("F") ? true : false)
                
                new_row.fields["day1"                   ].value = (days.include?("1") ? true : false)
                new_row.fields["day2"                   ].value = (days.include?("2") ? true : false)
                new_row.fields["day3"                   ].value = (days.include?("3") ? true : false)
                new_row.fields["day4"                   ].value = (days.include?("4") ? true : false)
                new_row.fields["day5"                   ].value = (days.include?("5") ? true : false)
                new_row.fields["day6"                   ].value = (days.include?("6") ? true : false)
                new_row.fields["day7"                   ].value = (days.include?("7") ? true : false)
                
                new_row.save
            end
        } if pids
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_sapphire_class_roster",
                "file_name"         => "student_sapphire_class_roster.csv",
                "file_location"     => "student_sapphire_class_roster",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many,
                :keys               => ["course_id","section_id","student_id"]
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["school_year"                      ] = {"data_type"=>"int", "file_field"=>"SCHOOL_YEAR"                    } if field_order.push("school_year"                     )
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
            structure_hash["fields"]["student_id"                       ] = {"data_type"=>"text", "file_field"=>"STUDENT_ID"                    } if field_order.push("student_id"                      )
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