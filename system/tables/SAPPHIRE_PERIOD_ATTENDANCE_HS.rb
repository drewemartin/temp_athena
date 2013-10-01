#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_PERIOD_ATTENDANCE_HS < Athena_Table
    
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
    
    def after_load_sapphire_period_attendance_hs
     
        $base.queue_process("ATTENDANCE_LOG", "sapphire_period_attendance", "HS")
        $tables.attach("DAILY_ATTENDANCE_LOG").log_completed($idate, "sapphire_period_attendance_hs")
        
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
                "name"              => "sapphire_period_attendance_hs",
                "file_name"         => "sapphire_period_attendance_hs.csv",
                "file_location"     => "sapphire_period_attendance_hs",
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
            structure_hash["fields"]["period_hr"                ] = {"data_type"=>"text", "file_field"=>"PERIOD_HR"                     } if field_order.push("period_hr"               )
            structure_hash["fields"]["period_1"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_1"                      } if field_order.push("period_1"                )
            structure_hash["fields"]["period_2"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_2"                      } if field_order.push("period_2"                )
            structure_hash["fields"]["period_3"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_3"                      } if field_order.push("period_3"                )
            structure_hash["fields"]["period_4"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_4"                      } if field_order.push("period_4"                )
            structure_hash["fields"]["period_5"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_5"                      } if field_order.push("period_5"                )
            structure_hash["fields"]["period_6"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_6"                      } if field_order.push("period_6"                )
            structure_hash["fields"]["period_7"                 ] = {"data_type"=>"text", "file_field"=>"PERIOD_7"                      } if field_order.push("period_7"                )
            structure_hash["fields"]["period_ist"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_IST"                    } if field_order.push("period_ist"              )
            structure_hash["fields"]["period_orn"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_ORN"                    } if field_order.push("period_orn"              )
            structure_hash["fields"]["logged"                   ] = {"data_type"=>"bool", "file_field"=>"logged"                        } if field_order.push("logged"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end