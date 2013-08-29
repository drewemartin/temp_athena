#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SAPPHIRE_PERIOD_ATTENDANCE < Athena_Table
    
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
                "name"              => "student_sapphire_period_attendance",
                "file_name"         => "student_sapphire_period_attendance.csv",
                "file_location"     => "student_sapphire_period_attendance",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many,
                :keys               => ["student_id","calendar_day"]
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"            } if field_order.push("student_id"      )
            structure_hash["fields"]["last_name"        ] = {"data_type"=>"text", "file_field"=>"LAST_NAME"             } if field_order.push("last_name"       )
            structure_hash["fields"]["first_name"       ] = {"data_type"=>"text", "file_field"=>"FIRST_NAME"            } if field_order.push("first_name"      )
            structure_hash["fields"]["middle_name"      ] = {"data_type"=>"text", "file_field"=>"MIDDLE_NAME"           } if field_order.push("middle_name"     )
            structure_hash["fields"]["grade_level"      ] = {"data_type"=>"text", "file_field"=>"GRADE_LEVEL"           } if field_order.push("grade_level"     )
            structure_hash["fields"]["calendar_day"     ] = {"data_type"=>"date", "file_field"=>"CALENDAR_DAY"          } if field_order.push("calendar_day"    )
            structure_hash["fields"]["attendance_code"  ] = {"data_type"=>"text", "file_field"=>"ATTENDANCE_CODE"       } if field_order.push("attendance_code" )
            structure_hash["fields"]["tardy_time"       ] = {"data_type"=>"text", "file_field"=>"TARDY_TIME"            } if field_order.push("tardy_time"      )
            structure_hash["fields"]["period_hr"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_HR"             } if field_order.push("period_hr"       )
            structure_hash["fields"]["period_1"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_1"              } if field_order.push("period_1"        )
            structure_hash["fields"]["period_2"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_2"              } if field_order.push("period_2"        )
            structure_hash["fields"]["period_3"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_3"              } if field_order.push("period_3"        )
            structure_hash["fields"]["period_4"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_4"              } if field_order.push("period_4"        )
            structure_hash["fields"]["period_5"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_5"              } if field_order.push("period_5"        )
            structure_hash["fields"]["period_6"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_6"              } if field_order.push("period_6"        )
            structure_hash["fields"]["period_7"         ] = {"data_type"=>"text", "file_field"=>"PERIOD_7"              } if field_order.push("period_7"        )
            structure_hash["fields"]["period_ist"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_IST"            } if field_order.push("period_ist"      )
            structure_hash["fields"]["period_orn"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_ORN"            } if field_order.push("period_orn"      )
            structure_hash["fields"]["period_m1"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M1"             } if field_order.push("period_m1"       )
            structure_hash["fields"]["period_m2"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M2"             } if field_order.push("period_m2"       )
            structure_hash["fields"]["period_m3"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M3"             } if field_order.push("period_m3"       )
            structure_hash["fields"]["period_m4"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M4"             } if field_order.push("period_m4"       )
            structure_hash["fields"]["period_m7"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M7"             } if field_order.push("period_m7"       )
            structure_hash["fields"]["period_m8"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M8"             } if field_order.push("period_m8"       )
            structure_hash["fields"]["period_m9"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_M9"             } if field_order.push("period_m9"       )
            structure_hash["fields"]["period_m12"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_M12"            } if field_order.push("period_m12"      )
            structure_hash["fields"]["period_m13"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_M13"            } if field_order.push("period_m13"      )
            structure_hash["fields"]["period_m14"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_M14"            } if field_order.push("period_m14"      )
            structure_hash["fields"]["period_mo"        ] = {"data_type"=>"text", "file_field"=>"PERIOD_MO"             } if field_order.push("period_mo"       )
            structure_hash["fields"]["period_el1"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL1"            } if field_order.push("period_el1"      )
            structure_hash["fields"]["period_el2"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL2"            } if field_order.push("period_el2"      )
            structure_hash["fields"]["period_el3"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL3"            } if field_order.push("period_el3"      )
            structure_hash["fields"]["period_el4"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL4"            } if field_order.push("period_el4"      )
            structure_hash["fields"]["period_el5"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL5"            } if field_order.push("period_el5"      )
            structure_hash["fields"]["period_el6"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL6"            } if field_order.push("period_el6"      )
            structure_hash["fields"]["period_el7"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL7"            } if field_order.push("period_el7"      )
            structure_hash["fields"]["period_el8"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL8"            } if field_order.push("period_el8"      )
            structure_hash["fields"]["period_el9"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL9"            } if field_order.push("period_el9"      )
            structure_hash["fields"]["period_elo"       ] = {"data_type"=>"text", "file_field"=>"PERIOD_ELO"            } if field_order.push("period_elo"      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end