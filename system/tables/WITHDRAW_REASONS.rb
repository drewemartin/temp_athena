#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class WITHDRAW_REASONS < Athena_Table
    
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
    
    def agora_reason_by_code(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("type", "=", "agora" ) )
        params.push( Struct::WHERE_PARAMS.new("code", "=", arg ) )
        where_clause = $db.where_clause(params)
        find_field("reason", where_clause)
    end
    
    def k12_reason_by_code(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("type", "=", "k12" ) )
        params.push( Struct::WHERE_PARAMS.new("code", "=", arg ) )
        where_clause = $db.where_clause(params)
        find_field("reason", where_clause)
    end

    def reason_by_code(arg)
        params = Array.new
        #params.push( Struct::WHERE_PARAMS.new("type", "=", "reason" ) )
        params.push( Struct::WHERE_PARAMS.new("code", "=", arg ) )
        where_clause = $db.where_clause(params)
        find_field("reason", where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def trigger_event(arg, arg2 = nil)
        case arg
        when "after_insert"
        when "before_insert"
        when "after_load"
        when "before_load"
        when "after_save"
        when "before_save"
        when "after_update"
        when "before_update"
        end
        "overwrite"
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "withdraw_reasons",
                "file_name"         => "withdraw_reasons.csv",
                "file_location"     => "withdraw_reasons",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => false,
                "audit"             => false
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["type"]        = {"data_type"=>"text",  "file_field"=>"type"}      if field_order.push("type")
            structure_hash["fields"]["code"]        = {"data_type"=>"text",  "file_field"=>"code"}      if field_order.push("code")
            structure_hash["fields"]["reason"]      = {"data_type"=>"text",  "file_field"=>"reason"}    if field_order.push("reason")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end
