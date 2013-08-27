#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class USER_LOG < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "user_log",
                "file_name"         => "user_log.csv",
                "file_location"     => "user_log",
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
            structure_hash["fields"]["username"]        = {"data_type"=>"text", "file_field"=>"username"}       if field_order.push("username")
            structure_hash["fields"]["page"]            = {"data_type"=>"text", "file_field"=>"page"}           if field_order.push("page")
            structure_hash["fields"]["school_year"]     = {"data_type"=>"text", "file_field"=>"school_year"}    if field_order.push("school_year")
            structure_hash["fields"]["params"]          = {"data_type"=>"text", "file_field"=>"params"}         if field_order.push("params")
            structure_hash["fields"]["message"]         = {"data_type"=>"text", "file_field"=>"message"}        if field_order.push("message")
            structure_hash["fields"]["remote_address"]  = {"data_type"=>"text", "file_field"=>"remote_address"} if field_order.push("remote_address")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end