#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class KMAIL_LOG < Athena_Table
    
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

    def by_identifier(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("identifier",  "=", arg   ) )
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
                "name"              => "kmail_log",
                "file_name"         => "kmail_log.csv",
                "file_location"     => "kmail_log",
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
            structure_hash["fields"]["subject"]    = {"data_type"=>"text",     "file_field"=>"subject"}       if field_order.push("subject")   
            structure_hash["fields"]["message"]    = {"data_type"=>"text",     "file_field"=>"message"}       if field_order.push("message")   
            structure_hash["fields"]["credential"] = {"data_type"=>"text",     "file_field"=>"credential"}    if field_order.push("credential")
            structure_hash["fields"]["kmail_ids"]  = {"data_type"=>"text",     "file_field"=>"kmail_ids"}     if field_order.push("kmail_ids") 
            structure_hash["fields"]["identifier"] = {"data_type"=>"text",     "file_field"=>"identifier"}    if field_order.push("identifier")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end