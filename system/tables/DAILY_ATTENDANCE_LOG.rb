#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DAILY_ATTENDANCE_LOG < Athena_Table
    
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
    
    def log_completed(date, source)
        
        if pid = primary_ids("WHERE date = '#{date}'")
            
            record = by_primary_id(pid)
            record.fields[source].value = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
            record.save
            
        else
            
            record = new_row
            record.fields["date"].value = date
            record.fields[source].value = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
            record.save
            
        end
        
    end
    
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
                "name"              => "daily_attendance_log",
                "file_name"         => "daily_attendance_log.cav",
                "file_location"     => "daily_attendance_log",
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
            
            structure_hash["fields"]["date"                             ] = {"data_type"=>"date",       "file_field"=>"date"                            } if field_order.push("date"                            )
            structure_hash["fields"]["existing"                         ] = {"data_type"=>"int",        "file_field"=>"existing"                        } if field_order.push("existing"                        )
            structure_hash["fields"]["new"                              ] = {"data_type"=>"int",        "file_field"=>"new"                             } if field_order.push("new"                             )
            structure_hash["fields"]["sapphire_class_roster_el"         ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_class_roster_el"        } if field_order.push("sapphire_class_roster_el"        )
            structure_hash["fields"]["sapphire_class_roster_ms"         ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_class_roster_ms"        } if field_order.push("sapphire_class_roster_ms"        )
            structure_hash["fields"]["sapphire_class_roster_hs"         ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_class_roster_hs"        } if field_order.push("sapphire_class_roster_hs"        )
            structure_hash["fields"]["sapphire_period_attendance_el"    ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_period_attendance_el"   } if field_order.push("sapphire_period_attendance_el"   )
            structure_hash["fields"]["sapphire_period_attendance_ms"    ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_period_attendance_ms"   } if field_order.push("sapphire_period_attendance_ms"   )
            structure_hash["fields"]["sapphire_period_attendance_hs"    ] = {"data_type"=>"datetime",   "file_field"=>"sapphire_period_attendance_hs"   } if field_order.push("sapphire_period_attendance_hs"   )
            structure_hash["fields"]["k12_logins"                       ] = {"data_type"=>"datetime",   "file_field"=>"k12_logins"                      } if field_order.push("k12_logins"                      )
            structure_hash["fields"]["k12_logins_lc"                    ] = {"data_type"=>"datetime",   "file_field"=>"k12_logins_lc"                   } if field_order.push("k12_logins_lc"                   )
            structure_hash["fields"]["completed"                        ] = {"data_type"=>"datetime",   "file_field"=>"completed"                       } if field_order.push("completed"                       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end