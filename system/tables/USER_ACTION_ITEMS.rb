#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class USER_ACTION_ITEMS < Athena_Table
    
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

    def by_sams_id(id, completed = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("sams_id",    "=", id             ) )
        params.push( Struct::WHERE_PARAMS.new("completed",  "=", completed.to_s ) ) if completed
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY created_date DESC"
        records(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "user_action_items",
                "file_name"         => "user_action_items.csv",
                "file_location"     => "user_action_items",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["sams_id"      ] = {"data_type"=>"int",    "file_field"=>"sams_id"     } if field_order.push("sams_id")
            structure_hash["fields"]["student_id"   ] = {"data_type"=>"int",    "file_field"=>"student_id"  } if field_order.push("student_id")
            structure_hash["fields"]["table_name"   ] = {"data_type"=>"text",   "file_field"=>"table_name"  } if field_order.push("table_name")
            structure_hash["fields"]["table_fields" ] = {"data_type"=>"text",   "file_field"=>"table_fields"} if field_order.push("table_fields")
            structure_hash["fields"]["table_pid"    ] = {"data_type"=>"int",    "file_field"=>"table_pid"   } if field_order.push("table_pid")
            structure_hash["fields"]["message"      ] = {"data_type"=>"text",   "file_field"=>"message"     } if field_order.push("message")
            structure_hash["fields"]["completed"    ] = {"data_type"=>"bool",   "file_field"=>"completed"   } if field_order.push("completed")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end