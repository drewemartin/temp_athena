#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_PERIOD_ATTENDANCE_MS < Athena_Table
    
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
    
    def after_load_sapphire_period_attendance_ms
     
        $base.queue_process("ATTENDANCE_LOG", "sapphire_period_attendance", "MS")
        $tables.attach("DAILY_ATTENDANCE_LOG").log_completed($idate, "sapphire_period_attendance_ms")
        
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
                :data_base          => "#{$config.school_name}_sapphire",
                :keys               => ["student_id","calendar_day"],
                :update             => false,
                "name"              => "sapphire_period_attendance_ms",
                "file_name"         => "sapphire_period_attendance_ms.csv",
                "file_location"     => "sapphire_period_attendance_ms",
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
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"                    } if field_order.push("student_id"              )
            structure_hash["fields"]["calendar_day"             ] = {"data_type"=>"date", "file_field"=>"CALENDAR_DAY"                  } if field_order.push("calendar_day"            )
            structure_hash["fields"]["attendance_code"          ] = {"data_type"=>"text", "file_field"=>"ATTENDANCE_CODE"               } if field_order.push("attendance_code"         )
            structure_hash["fields"]["tardy_time"               ] = {"data_type"=>"text", "file_field"=>"TARDY_TIME"                    } if field_order.push("tardy_time"              )
            structure_hash["fields"]["period_m1"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M1"                     } if field_order.push("period_m1"               )
            structure_hash["fields"]["period_m2"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M2"                     } if field_order.push("period_m2"               )
            structure_hash["fields"]["period_m3"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M3"                     } if field_order.push("period_m3"               )
            structure_hash["fields"]["period_m4"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M4"                     } if field_order.push("period_m4"               )
            structure_hash["fields"]["period_m7"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M7"                     } if field_order.push("period_m7"               )
            structure_hash["fields"]["period_m8"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M8"                     } if field_order.push("period_m8"               )
            structure_hash["fields"]["period_m9"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_M9"                     } if field_order.push("period_m9"               )
            structure_hash["fields"]["period_m12"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_M12"                    } if field_order.push("period_m12"              )
            structure_hash["fields"]["period_m13"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_M13"                    } if field_order.push("period_m13"              )
            structure_hash["fields"]["period_m14"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_M14"                    } if field_order.push("period_m14"              )
            structure_hash["fields"]["period_as1"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_AS1"                    } if field_order.push("period_as1"              )
            structure_hash["fields"]["period_as2"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_AS2"                    } if field_order.push("period_as2"              )
            structure_hash["fields"]["period_mo"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_MO"                     } if field_order.push("period_mo"               )
            structure_hash["fields"]["logged"                   ] = {"data_type"=>"bool", "file_field"=>"logged"                        } if field_order.push("logged"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end