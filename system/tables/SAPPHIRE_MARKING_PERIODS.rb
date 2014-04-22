#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_MARKING_PERIODS < Athena_Table
    
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
                :load_type          => :append,
                :data_base          => "#{$config.school_name}_sapphire",
                :keys               => ["mp_code","school_year","school_id"],
                :update             => true,
                "name"              => "sapphire_marking_periods",
                "file_name"         => "sapphire_marking_periods.csv",
                "file_location"     => "sapphire_marking_periods",
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
            
            structure_hash["fields"]["mp_code"                          ] = {"data_type"=>"text", "file_field"=>"MP_CODE"                       } if field_order.push("mp_code"                         )
            structure_hash["fields"]["mp_desc"                          ] = {"data_type"=>"text", "file_field"=>"MP_DESC"                       } if field_order.push("mp_desc"                         )
            structure_hash["fields"]["interim_comments_flg"             ] = {"data_type"=>"text", "file_field"=>"INTERIM_COMMENTS_FLG"          } if field_order.push("interim_comments_flg"            )
            structure_hash["fields"]["mp_end_date"                      ] = {"data_type"=>"date", "file_field"=>"MP_END_DATE"                   } if field_order.push("mp_end_date"                     )
            structure_hash["fields"]["mp_start_date"                    ] = {"data_type"=>"date", "file_field"=>"MP_START_DATE"                 } if field_order.push("mp_start_date"                   )
            structure_hash["fields"]["mp_order"                         ] = {"data_type"=>"int",  "file_field"=>"MP_ORDER"                      } if field_order.push("mp_order"                        )
            structure_hash["fields"]["collect_grade_from"               ] = {"data_type"=>"date", "file_field"=>"COLLECT_GRADE_FROM"            } if field_order.push("collect_grade_from"              )
            structure_hash["fields"]["collect_grade_to"                 ] = {"data_type"=>"date", "file_field"=>"COLLECT_GRADE_TO"              } if field_order.push("collect_grade_to"                )
            structure_hash["fields"]["duration_code"                    ] = {"data_type"=>"text", "file_field"=>"DURATION_CODE"                 } if field_order.push("duration_code"                   )
            structure_hash["fields"]["duration_desc"                    ] = {"data_type"=>"text", "file_field"=>"DURATION_DESC"                 } if field_order.push("duration_desc"                   )
            structure_hash["fields"]["duration_group_code"              ] = {"data_type"=>"text", "file_field"=>"DURATION_GROUP_CODE"           } if field_order.push("duration_group_code"             )
            structure_hash["fields"]["state_course_semester_code_rid"   ] = {"data_type"=>"text", "file_field"=>"STATE_COURSE_SEMESTER_CODE_RID"} if field_order.push("state_course_semester_code_rid"  )
            structure_hash["fields"]["sapphire_created_by"              ] = {"data_type"=>"text", "file_field"=>"CREATED_BY"                    } if field_order.push("sapphire_created_by"             )
            structure_hash["fields"]["sapphire_created_date"            ] = {"data_type"=>"date", "file_field"=>"CREATED_DATE"                  } if field_order.push("sapphire_created_date"           )
            structure_hash["fields"]["sapphire_modified_by"             ] = {"data_type"=>"text", "file_field"=>"MODIFIED_BY"                   } if field_order.push("sapphire_modified_by"            )
            structure_hash["fields"]["sapphire_modified_date"           ] = {"data_type"=>"date", "file_field"=>"MODIFIED_DATE"                 } if field_order.push("sapphire_modified_date"          )
            structure_hash["fields"]["school_year"                      ] = {"data_type"=>"year", "file_field"=>"SCHOOL_YEAR"                   } if field_order.push("school_year"                     )
            structure_hash["fields"]["school_id"                        ] = {"data_type"=>"text", "file_field"=>"SCHOOL_ID"                     } if field_order.push("school_id"                       )
        
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end