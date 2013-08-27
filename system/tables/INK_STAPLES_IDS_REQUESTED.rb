#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class INK_STAPLES_IDS_REQUESTED < Athena_Table
    
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
   
    def by_studentid_old(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_primaryid(pid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id",  "=", pid   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_studentid_confirmed_address(sid, address_string) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid) )
        params.push( Struct::WHERE_PARAMS.new("confirmed", "=", "1") )
        params.push( Struct::WHERE_PARAMS.new("address_string", "=", address_string) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def unconfirmed() 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("confirmed", "=", "0") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def unconfirmed_record(sid, address_string) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("confirmed",      "=", "0")            )
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=", sid)            )
        params.push( Struct::WHERE_PARAMS.new("address_string", "=", address_string) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def confirmed_record(sid, address_string) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("confirmed",      "=", "1")            )
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=", sid)            )
        params.push( Struct::WHERE_PARAMS.new("address_string", "=", address_string) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_load_ink_staples_ids
        require File.dirname(__FILE__).gsub("tables","data_processing/ink_staples_id_confirmation")
        Ink_Staples_Id_Confirmation.new
    end
    
    def after_load_k12_omnibus(reinit = false)
        require File.dirname(__FILE__).gsub("tables","data_processing/ink_staples_id_request")
        Ink_Staples_Id_Request.new(reinit)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "ink_staples_ids_requested",
                "file_name"         => "ink_staples_ids_requested.csv",
                "file_location"     => "ink_staples_ids_requested",
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
            structure_hash["fields"]["student_id"]            = {"data_type"=>"int",  "file_field"=>"student_id"}       if field_order.push("student_id")
            structure_hash["fields"]["confirmed"]             = {"data_type"=>"text", "file_field"=>"confirmed"}        if field_order.push("confirmed")
            structure_hash["fields"]["address_string"]        = {"data_type"=>"text", "file_field"=>"address_string"}   if field_order.push("address_string")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end