#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RECORDS_RECEIVED < Athena_Table
    
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

    def by_studentid_old(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",  "=", sid   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_records",
                "file_name"         => "student_records.csv",
                "file_location"     => "student_records",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",        "file_field"=>"student_id"          } if field_order.push("student_id"          )
            structure_hash["fields"]["record_type_id"   ] = {"data_type"=>"int",        "file_field"=>"record_type_id"      } if field_order.push("record_type_id"      )
            
            #by default status should be received - but other options will be able to be added so that eventually (if it is decided that we can know enough
            #information to definitely conclude that a record MUST be received for this particular student)we will be able to auto generate followup requests. 
            structure_hash["fields"]["status"           ] = {"data_type"=>"text",       "file_field"=>"status"              } if field_order.push("status"              )
            structure_hash["fields"]["received_datetime"] = {"data_type"=>"datetime",   "file_field"=>"received_datetime"   } if field_order.push("received_datetime"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end