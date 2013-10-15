#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SAPPHIRE_GRADES < Athena_Table
    
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

    def after_insert(obj)
        sapphire_record = by_primary_id(obj.primary_id)
        $tables.attach("STUDENT_ACADEMIC_PROGRESS").update_sapphire_grades(sapphire_record)
    end
    
    def after_change_field_grade_numeric_tgb(obj)
        sapphire_record = by_primary_id(obj.primary_id)
        $tables.attach("STUDENT_ACADEMIC_PROGRESS").update_sapphire_grades(sapphire_record)
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
                :load_type          => :append,
                :keys               => ["student_id","course_id","section_id"],
                :update             => true,
                "name"              => "student_sapphire_grades",
                "file_name"         => "student_sapphire_grades.csv",
                "file_location"     => "student_sapphire_grades",
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
            
            structure_hash["fields"]["district_id"                      ] = {"data_type"=>"text",               "file_field"=>"DISTRICT_ID"                                             } if field_order.push("district_id"                     )
            structure_hash["fields"]["school_id"                        ] = {"data_type"=>"text",               "file_field"=>"SCHOOL_ID"                                               } if field_order.push("school_id"                       )
            structure_hash["fields"]["school_year"                      ] = {"data_type"=>"year",               "file_field"=>"SCHOOL_YEAR"                                             } if field_order.push("school_year"                     )
            structure_hash["fields"]["student_rid"                      ] = {"data_type"=>"int",                "file_field"=>"STUDENT_RID"                                             } if field_order.push("student_rid"                     )
            structure_hash["fields"]["first_name"                       ] = {"data_type"=>"text",               "file_field"=>"FIRST_NAME"                                              } if field_order.push("first_name"                      )
            structure_hash["fields"]["middle_name"                      ] = {"data_type"=>"text",               "file_field"=>"MIDDLE_NAME"                                             } if field_order.push("middle_name"                     )
            structure_hash["fields"]["last_name"                        ] = {"data_type"=>"text",               "file_field"=>"LAST_NAME"                                               } if field_order.push("last_name"                       )
            structure_hash["fields"]["student_id"                       ] = {"data_type"=>"int",                "file_field"=>"STUDENT_ID"                                              } if field_order.push("student_id"                      )
            structure_hash["fields"]["gender"                           ] = {"data_type"=>"text",               "file_field"=>"GENDER"                                                  } if field_order.push("gender"                          )
            structure_hash["fields"]["course_id"                        ] = {"data_type"=>"text",               "file_field"=>"COURSE_ID"                                               } if field_order.push("course_id"                       )
            structure_hash["fields"]["section_id"                       ] = {"data_type"=>"int",                "file_field"=>"SECTION_ID"                                              } if field_order.push("section_id"                      )
            structure_hash["fields"]["duration_code"                    ] = {"data_type"=>"text",               "file_field"=>"DURATION_CODE"                                           } if field_order.push("duration_code"                   )
            structure_hash["fields"]["teacher_rid"                      ] = {"data_type"=>"int",                "file_field"=>"TEACHER_RID"                                             } if field_order.push("teacher_rid"                     )
            structure_hash["fields"]["credits"                          ] = {"data_type"=>"int",                "file_field"=>"CREDITS"                                                 } if field_order.push("credits"                         )
            structure_hash["fields"]["course_title"                     ] = {"data_type"=>"text",               "file_field"=>"COURSE_TITLE"                                            } if field_order.push("course_title"                    )
            structure_hash["fields"]["credits_status"                   ] = {"data_type"=>"text",               "file_field"=>"CREDITS_STATUS"                                          } if field_order.push("credits_status"                  )
            structure_hash["fields"]["finished_course_flg"              ] = {"data_type"=>"bool",               "file_field"=>"FINISHED_COURSE_FLG"                                     } if field_order.push("finished_course_flg"             )
            structure_hash["fields"]["grade_level"                      ] = {"data_type"=>"text",               "file_field"=>"GRADE_LEVEL"                                             } if field_order.push("grade_level"                     )
            structure_hash["fields"]["school_year_desc"                 ] = {"data_type"=>"text",               "file_field"=>"SCHOOL_YEAR_DESC"                                        } if field_order.push("school_year_desc"                )
            structure_hash["fields"]["weight_code"                      ] = {"data_type"=>"text",               "file_field"=>"WEIGHT_CODE"                                             } if field_order.push("weight_code"                     )
            structure_hash["fields"]["teacher_first_name"               ] = {"data_type"=>"text",               "file_field"=>"TEACHER_FIRST_NAME"                                      } if field_order.push("teacher_first_name"              )
            structure_hash["fields"]["teacher_last_name"                ] = {"data_type"=>"text",               "file_field"=>"TEACHER_LAST_NAME"                                       } if field_order.push("teacher_last_name"               )
            structure_hash["fields"]["teacher_id"                       ] = {"data_type"=>"int",                "file_field"=>"TEACHER_ID"                                              } if field_order.push("teacher_id"                      )
            structure_hash["fields"]["home_room"                        ] = {"data_type"=>"text",               "file_field"=>"HOME_ROOM"                                               } if field_order.push("home_room"                       )
            structure_hash["fields"]["home_room_desc"                   ] = {"data_type"=>"text",               "file_field"=>"HOME_ROOM_DESC"                                          } if field_order.push("home_room_desc"                  )
            structure_hash["fields"]["homeroom_teacher_last_name"       ] = {"data_type"=>"text",               "file_field"=>"HOMEROOM_TEACHER_LAST_NAME"                              } if field_order.push("homeroom_teacher_last_name"      )
            structure_hash["fields"]["homeroom_teacher_first_name"      ] = {"data_type"=>"text",               "file_field"=>"HOMEROOM_TEACHER_FIRST_NAME"                             } if field_order.push("homeroom_teacher_first_name"     )
            structure_hash["fields"]["homeroom_teacher_id"              ] = {"data_type"=>"int",                "file_field"=>"HOMEROOM_TEACHER_ID"                                     } if field_order.push("homeroom_teacher_id"             )
            structure_hash["fields"]["department_code"                  ] = {"data_type"=>"text",               "file_field"=>"DEPARTMENT_CODE"                                         } if field_order.push("department_code"                 )
            structure_hash["fields"]["department_desc"                  ] = {"data_type"=>"text",               "file_field"=>"DEPARTMENT_DESC"                                         } if field_order.push("department_desc"                 )
            structure_hash["fields"]["tgb_mp"                           ] = {"data_type"=>"text",               "file_field"=>"TGB_MP"                                                  } if field_order.push("tgb_mp"                          )
            structure_hash["fields"]["grade_alpha_tgb"                  ] = {"data_type"=>"text",               "file_field"=>"GRADE_ALPHA_TGB"                                         } if field_order.push("grade_alpha_tgb"                 )
            structure_hash["fields"]["grade_numeric_tgb"                ] = {"data_type"=>"decimal(5,4)",       "file_field"=>"GRADE_NUMERIC_TGB", :file_data_type=>:percentage         } if field_order.push("grade_numeric_tgb"               )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end