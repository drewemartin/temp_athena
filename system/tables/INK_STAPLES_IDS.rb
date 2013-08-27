#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class INK_STAPLES_IDS < Athena_Table
    
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

    def by_staples_id(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("ship_to", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_primaryid(pid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id",  "=", pid   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def staples_id(concat_id)
        select_sql =
        "SELECT ship_to
        FROM ink_staples_ids
        WHERE
        LOWER(
            CONCAT(
                LEFT(RIGHT(name,CHAR_LENGTH(name)-LOCATE('%',name)),3),
                LEFT(RIGHT(RIGHT(name,CHAR_LENGTH(name)-LOCATE('%',name)),CHAR_LENGTH(RIGHT(name,CHAR_LENGTH(name)-LOCATE('%',name)))-LOCATE(' ',RIGHT(name,CHAR_LENGTH(name)-LOCATE('%',name)))),3),
                LEFT(address_1,3),
                LEFT(city,3)
            )
        )
        = LOWER('#{concat_id}')"
        return $db.get_data_single(select_sql)
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
                "name"              => "ink_staples_ids",
                "file_name"         => "ink_staples_ids.csv",
                "file_location"     => "ink_staples_ids",
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
            structure_hash["fields"]["division"]            = {"data_type"=>"text", "file_field"=>"Division:"}          if field_order.push("division")
            structure_hash["fields"]["master"]              = {"data_type"=>"int",  "file_field"=>"Master:"}            if field_order.push("master")
            structure_hash["fields"]["bill_to"]             = {"data_type"=>"text", "file_field"=>"Billto ID:"}         if field_order.push("bill_to")
            structure_hash["fields"]["ship_to"]             = {"data_type"=>"text", "file_field"=>"Shipto ID:"}         if field_order.push("ship_to")
            structure_hash["fields"]["name"]                = {"data_type"=>"text", "file_field"=>"Shipto Name:"}       if field_order.push("name")
            structure_hash["fields"]["address_1"]           = {"data_type"=>"text", "file_field"=>"Shipto Add Line 1:"} if field_order.push("address_1")
            structure_hash["fields"]["address_2"]           = {"data_type"=>"text", "file_field"=>"Shipto Add Line 3:"} if field_order.push("address_2")
            structure_hash["fields"]["city"]                = {"data_type"=>"text", "file_field"=>"Shipto City:"}       if field_order.push("city")
            structure_hash["fields"]["state"]               = {"data_type"=>"text", "file_field"=>"Shipto State:"}      if field_order.push("state")
            structure_hash["fields"]["zip"]                 = {"data_type"=>"text", "file_field"=>"Shipto Zip:"}        if field_order.push("zip")
            structure_hash["fields"]["phone"]               = {"data_type"=>"text", "file_field"=>"Shipto Phone:"}      if field_order.push("phone")
            structure_hash["fields"]["fax"]                 = {"data_type"=>"text", "file_field"=>"Shipto Fax:"}        if field_order.push("fax")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end