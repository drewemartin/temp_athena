#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class BULK_MODIFICATION_LOG < Athena_Table
    
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
                "name"              => "bulk_modification_log",
                "file_name"         => "bulk_modification_log.csv",
                "file_location"     => "bulk_modification_log",
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
            structure_hash["fields"]["table"]           = {"data_type"=>"text", "file_field"=>"table"}     if field_order.push("table")
            structure_hash["fields"]["pid"]             = {"data_type"=>"int",  "file_field"=>"pid"}       if field_order.push("pid")
            structure_hash["fields"]["field"]           = {"data_type"=>"text", "file_field"=>"field"}     if field_order.push("field")
            structure_hash["fields"]["from"]            = {"data_type"=>"text", "file_field"=>"from"}      if field_order.push("from")
            structure_hash["fields"]["to"]              = {"data_type"=>"text", "file_field"=>"to"}        if field_order.push("to")
            structure_hash["fields"]["reason"]          = {"data_type"=>"text", "file_field"=>"reason"}    if field_order.push("reason")
            structure_hash["fields"]["authorized_by"]   = {"data_type"=>"text", "file_field"=>"authorized_by"}      if field_order.push("authorized_by")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end