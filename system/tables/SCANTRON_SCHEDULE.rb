#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCANTRON_SCHEDULE < Athena_Table
    
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

    def current_test_phase(date = nil)
        this_date = date ? "'#{date}'" : "CURDATE()"
        phase = "ent" if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE #{this_date} >= ent_start_date AND #{this_date} <= ent_end_date")
        phase = "ext" if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE #{this_date} >= ext_start_date AND #{this_date} <= ext_end_date")
        return phase 
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
                "name"              => "scantron_schedule",
                "file_name"         => "scantron_schedule.csv",
                "file_location"     => "scantron_schedule",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["ent_start_date"   ] = {"data_type"=>"date", "file_field"=>"ent_start_date"    } if field_order.push("ent_start_date")
            structure_hash["fields"]["ent_end_date"     ] = {"data_type"=>"date", "file_field"=>"ent_end_date"      } if field_order.push("ent_end_date")
            structure_hash["fields"]["ext_start_date"   ] = {"data_type"=>"date", "file_field"=>"ext_start_date"    } if field_order.push("ext_start_date")
            structure_hash["fields"]["ext_end_date"     ] = {"data_type"=>"date", "file_field"=>"ext_end_date"      } if field_order.push("ext_end_date")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end