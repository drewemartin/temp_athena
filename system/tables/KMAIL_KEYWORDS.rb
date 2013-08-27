#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class KMAIL_KEYWORDS < Athena_Table
    
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

    def by_type(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("type",  "=", arg   ) )
        where_clause = $db.where_clause(params)
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "kmail_keywords",
                "file_name"         => "kmail_keywords.csv",
                "file_location"     => "kmail_keywords",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => false
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["keyword"]         = {"data_type"=>"text",  "file_field"=>"keyword"}     if field_order.push("keyword")
            structure_hash["fields"]["type"]            = {"data_type"=>"text",  "file_field"=>"type"}        if field_order.push("type")
            structure_hash["fields"]["description"]     = {"data_type"=>"text",  "file_field"=>"description"} if field_order.push("description")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end