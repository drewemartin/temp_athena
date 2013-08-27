#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class INK_PRINTER_MODELS < Athena_Table
    
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

    def all_ink() 
        order_clause = "GROUP BY ink_number ORDER BY ink_number ASC"
        records(order_clause)
    end
    
    def all_printers() 
        order_clause = "GROUP BY printer_model ORDER BY printer_model ASC"
        records(order_clause)
    end
    
    def staples_item_number_by_ink(ink)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("ink_number",  "=", ink   ) )
        where_clause = $db.where_clause(params)
        find_field("staples_item_number", where_clause)
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
                "name"              => "ink_printer_models",
                "file_name"         => "ink_printer_models.csv",
                "file_location"     => "ink_printer_models",
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
            structure_hash["fields"]["printer_name"]        = {"data_type"=>"text", "file_field"=>"printer_name"}        if field_order.push("printer_name")
            structure_hash["fields"]["printer_model"]       = {"data_type"=>"text", "file_field"=>"printer_model"}       if field_order.push("printer_model")
            structure_hash["fields"]["sams_model"]          = {"data_type"=>"text", "file_field"=>"sams_model"}          if field_order.push("sams_model")
            structure_hash["fields"]["ink_number"]          = {"data_type"=>"text", "file_field"=>"ink_number"}          if field_order.push("ink_number")
            structure_hash["fields"]["staples_item_number"] = {"data_type"=>"text", "file_field"=>"staples_item_number"} if field_order.push("staples_item_number")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end