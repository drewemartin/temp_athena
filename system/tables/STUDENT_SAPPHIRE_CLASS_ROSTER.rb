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

    def after_change_field(field_obj)
        
        if !(field_obj.field_name == "complete")
            
            record = by_primary_id(field_obj.primary_id)
            manage_ilp(record)
            
        end
        
    end
    
    def after_insert(record)
        
        manage_ilp(record)
        
    end
    
    def manage_ilp(record)
        
        student     = $students.get(record.fields["student_id"].value)
        
        course_id   = record.fields["course_id" ].value
        section_id  = record.fields["section_id"].value
        
        sol         = "#{course_id} - #{section_id}"
        
        pattern     = record.fields["pattern"].value
        arr         = pattern.partition("(")
        per_code    = arr[0].strip
        arr2        = arr[2].partition(")")
        days        = arr2[0]
        school_type = $tables.attach("sapphire_dictionary_periods").find_field("school_type", "WHERE period_code='#{per_code}'")
        
        ilp_cat     = $tables.attach("ilp_entry_category"  ).find_field("primary_id", "WHERE name='Sapphire Course Schedule#{school_type ? " #{school_type.value}" :""}'")
        ilp_type    = $tables.attach("ilp_entry_type"      ).find_field("primary_id", "WHERE category_id = '#{ilp_cat.value}' AND name='#{per_code}'")
        
        if ilp_cat && ilp_type
            
            if (
                
                ilp_record = student.ilp.existing_records(
                    "WHERE  ilp_entry_category_id   = '#{ilp_cat.value  }'
                    AND     ilp_entry_type_id       = '#{ilp_type.value }'
                    AND     solution                = '#{sol            }'"
                )
                
            )
                
                ilp_record = ilp_record[0]
                
            else
                
                ilp_record = student.ilp.new_record
                
            end
            
            ilp_record.fields["ilp_entry_category_id"  ].value = ilp_cat.value
            ilp_record.fields["ilp_entry_type_id"      ].value = ilp_type.value
            
            ilp_record.fields["description"            ].value = "#{record.fields["course_title"].value} - #{record.fields["staff_name"].value}"
            ilp_record.fields["solution"               ].value = "#{course_id} - #{section_id}"
            
            ilp_record.fields["monday"                 ].value = (days.include?("M") ? true : false)
            ilp_record.fields["tuesday"                ].value = (days.include?("T") ? true : false)
            ilp_record.fields["wednesday"              ].value = (days.include?("W") ? true : false)
            ilp_record.fields["thursday"               ].value = (days.include?("R") ? true : false)
            ilp_record.fields["friday"                 ].value = (days.include?("F") ? true : false)
            
            ilp_record.fields["day1"                   ].value = (days.include?("1") ? true : false)
            ilp_record.fields["day2"                   ].value = (days.include?("2") ? true : false)
            ilp_record.fields["day3"                   ].value = (days.include?("3") ? true : false)
            ilp_record.fields["day4"                   ].value = (days.include?("4") ? true : false)
            ilp_record.fields["day5"                   ].value = (days.include?("5") ? true : false)
            ilp_record.fields["day6"                   ].value = (days.include?("6") ? true : false)
            ilp_record.fields["day7"                   ].value = (days.include?("7") ? true : false)
            
            ilp_record.save
            
        end
       
    end
    
    def after_load_student_sapphire_class_roster
        activate_classes
        deactivate_classes
    end
    
    def activate_classes
        
        el_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_EL"       ).data_base
        ms_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_MS"       ).data_base
        hs_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_HS"       ).data_base
        
        ss_db = $tables.attach("STUDENT_SAPPHIRE_CLASS_ROSTER"  ).data_base
        
        pids = primary_ids(
            
            "LEFT JOIN #{el_db}.sapphire_class_roster_el
                
                ON  sapphire_class_roster_el.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_el.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_el.section_id    = student_sapphire_class_roster.section_id
                
            LEFT JOIN #{ms_db}.sapphire_class_roster_ms
                
                ON  sapphire_class_roster_ms.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_ms.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_ms.section_id    = student_sapphire_class_roster.section_id
              
            LEFT JOIN #{hs_db}.sapphire_class_roster_hs
                
                ON  sapphire_class_roster_hs.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_hs.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_hs.section_id    = student_sapphire_class_roster.section_id
                
            WHERE (
                
                sapphire_class_roster_el.primary_id IS NOT NULL
                    OR
                sapphire_class_roster_ms.primary_id IS NOT NULL
                    OR
                sapphire_class_roster_hs.primary_id IS NOT NULL
                
            )
            AND active IS NOT TRUE"
            
        )
        
        pids.each{|pid|
            
            record = by_primary_id(pid)
            record.field["active"].value = true
            record.save
            
        } if pids
        
    end

    def deactivate_classes
        
        el_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_EL"       ).data_base
        ms_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_MS"       ).data_base
        hs_db = $tables.attach("SAPPHIRE_CLASS_ROSTER_HS"       ).data_base
        
        ss_db = $tables.attach("STUDENT_SAPPHIRE_CLASS_ROSTER"  ).data_base
        
        pids = primary_ids(
            
            "LEFT JOIN #{el_db}.sapphire_class_roster_el
                
                ON  sapphire_class_roster_el.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_el.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_el.section_id    = student_sapphire_class_roster.section_id
                
            LEFT JOIN #{ms_db}.sapphire_class_roster_ms
                
                ON  sapphire_class_roster_ms.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_ms.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_ms.section_id    = student_sapphire_class_roster.section_id
              
            LEFT JOIN #{hs_db}.sapphire_class_roster_hs
                
                ON  sapphire_class_roster_hs.student_id    = student_sapphire_class_roster.student_id
                AND sapphire_class_roster_hs.course_id     = student_sapphire_class_roster.course_id
                AND sapphire_class_roster_hs.section_id    = student_sapphire_class_roster.section_id
                
            WHERE (
                
                sapphire_class_roster_el.primary_id IS NULL
                    OR
                sapphire_class_roster_ms.primary_id IS NULL
                    OR
                sapphire_class_roster_hs.primary_id IS NULL
                
            )
            AND active IS NOT FALSE"
            
        )
        
        pids.each{|pid|
            
            record = by_primary_id(pid)
            record.field["active"].value = false
            record.save
            
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
                :keys               => ["course_id","section_id","student_id"],
                :update             => true,
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"                       ] = {"data_type"=>"text", "file_field"=>"STUDENT_ID"                    } if field_order.push("student_id"                      )
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
            structure_hash["fields"]["active"                           ] = {"data_type"=>"bool", "file_field"=>"active"                        } if field_order.push("active"                          )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end