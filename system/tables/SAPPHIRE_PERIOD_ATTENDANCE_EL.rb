#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_PERIOD_ATTENDANCE_EL < Athena_Table
    
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

    def after_load_sapphire_period_attendance_el
     
        $base.queue_process("ATTENDANCE_LOG", "sapphire_period_attendance", "EL")
        $tables.attach("DAILY_ATTENDANCE_LOG").log_completed($idate, "sapphire_period_attendance_el")
        
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
                "name"              => "sapphire_period_attendance_el",
                "file_name"         => "sapphire_period_attendance_el.csv",
                "file_location"     => "sapphire_period_attendance_el",
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
            structure_hash["fields"]["period_el1"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL1"                    } if field_order.push("period_el1"              )
            structure_hash["fields"]["period_el2"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL2"                    } if field_order.push("period_el2"              )
            structure_hash["fields"]["period_el3"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL3"                    } if field_order.push("period_el3"              )
            structure_hash["fields"]["period_el4"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL4"                    } if field_order.push("period_el4"              )
            structure_hash["fields"]["period_el5"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL5"                    } if field_order.push("period_el5"              )
            structure_hash["fields"]["period_el6"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL6"                    } if field_order.push("period_el6"              )
            structure_hash["fields"]["period_el7"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL7"                    } if field_order.push("period_el7"              )
            structure_hash["fields"]["period_el8"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL8"                    } if field_order.push("period_el8"              )
            structure_hash["fields"]["period_el9"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_EL9"                    } if field_order.push("period_el9"              )
            structure_hash["fields"]["period_e10"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_E10"                    } if field_order.push("period_e10"              )
            structure_hash["fields"]["period_e11"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_E11"                    } if field_order.push("period_e11"              )
            structure_hash["fields"]["period_e12"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_E12"                    } if field_order.push("period_e12"              )
            structure_hash["fields"]["period_e13"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_E13"                    } if field_order.push("period_e13"              )
            structure_hash["fields"]["period_ela"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_ELA"                    } if field_order.push("period_ela"              )
            structure_hash["fields"]["period_elo"               ] = {"data_type"=>"text", "file_field"=>"PERIOD_ELO"                    } if field_order.push("period_elo"              )
            structure_hash["fields"]["logged"                   ] = {"data_type"=>"bool", "file_field"=>"logged"                        } if field_order.push("logged"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end