#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_ENROLLMENT_RECORDS < Athena_Table
    
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
                "name"              => "sapphire_enrollment_records",
                "file_name"         => "sapphire_enrollment_records.csv",
                "file_location"     => "sapphire_enrollment_records",
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
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"        } if field_order.push("student_id")
            structure_hash["fields"]["school_start_date"    ] = {"data_type"=>"date", "file_field"=>"SCHOOL_START_DATE" } if field_order.push("school_start_date")
            structure_hash["fields"]["school_end_date"      ] = {"data_type"=>"date", "file_field"=>"SCHOOL_END_DATE"   } if field_order.push("school_end_date")
            structure_hash["fields"]["school_year"          ] = {"data_type"=>"text", "file_field"=>"SCHOOL_YEAR"       } if field_order.push("school_year")
            structure_hash["fields"]["entry_date"           ] = {"data_type"=>"date", "file_field"=>"ENTRY_DATE"        } if field_order.push("entry_date")
            structure_hash["fields"]["entry_code"           ] = {"data_type"=>"text", "file_field"=>"ENTRY_CODE"        } if field_order.push("entry_code")
            structure_hash["fields"]["entrance_desc"        ] = {"data_type"=>"text", "file_field"=>"ENTRANCE_DESC"     } if field_order.push("entrance_desc")
            structure_hash["fields"]["withdrawl_date"       ] = {"data_type"=>"date", "file_field"=>"WITHDRAWL_DATE"    } if field_order.push("withdrawl_date")
            structure_hash["fields"]["withdrawl_code"       ] = {"data_type"=>"text", "file_field"=>"WITHDRAWL_CODE"    } if field_order.push("withdrawl_code")
            structure_hash["fields"]["withdrawl_desc"       ] = {"data_type"=>"text", "file_field"=>"WITHDRAWL_DESC"    } if field_order.push("withdrawl_desc")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end