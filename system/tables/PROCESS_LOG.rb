#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class PROCESS_LOG < Athena_Table
    
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

    def by_process(class_name, function_name=nil, completed=nil, created_date=nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("class_name",          "=",      class_name    ) )
        params.push( Struct::WHERE_PARAMS.new("function_name",       "=",      function_name ) ) if function_name
        params.push( Struct::WHERE_PARAMS.new("completed_datetime",  "IS NOT", "NULL"        ) ) if completed == true
        params.push( Struct::WHERE_PARAMS.new("completed_datetime",  "IS",     "NULL"        ) ) if completed == false
        params.push( Struct::WHERE_PARAMS.new("created_date",        "REGEXP", created_date  ) ) if created_date
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY created_date DESC"
        records(where_clause)
    end
    
    def by_status(arg,remote=nil)
        operator = arg.upcase == "NULL" ? "IS" : "="
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("status",          operator,      arg    ) )
        params.push( Struct::WHERE_PARAMS.new("remote",          "=",           remote ) )
        where_clause = $db.where_clause(params)
        records(where_clause)
    end
    
    def queue_process(class_name, function_name, args = nil, remote='0')
        record = new_row
        record.fields["class_name"      ].value = class_name
        record.fields["function_name"   ].value = function_name
        record.fields["args"            ].value = args.gsub("\"","\\\"") if args
        record.fields["remote"          ].value = remote
        record.fields["school_year"     ].value = $config.school_year
        record.save
        
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
                "name"              => "process_log",
                "file_name"         => "process_log.csv",
                "file_location"     => "process_log",
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
            structure_hash["fields"]["class_name"]          = {"data_type"=>"text",     "file_field"=>"class_name"}         if field_order.push("class_name")
            structure_hash["fields"]["function_name"]       = {"data_type"=>"text",     "file_field"=>"function_name"}      if field_order.push("function_name")
            structure_hash["fields"]["args"]                = {"data_type"=>"text",     "file_field"=>"args"}               if field_order.push("args")
            structure_hash["fields"]["status"]              = {"data_type"=>"text",     "file_field"=>"status"}             if field_order.push("status")
            structure_hash["fields"]["start_datetime"]      = {"data_type"=>"datetime", "file_field"=>"start_datetime"}     if field_order.push("start_datetime")
            structure_hash["fields"]["completed_datetime"]  = {"data_type"=>"datetime", "file_field"=>"completed_datetime"} if field_order.push("completed_datetime")
            structure_hash["fields"]["school_year"]         = {"data_type"=>"text",     "file_field"=>"school_year"}        if field_order.push("school_year")
            structure_hash["fields"]["remote"]              = {"data_type"=>"bool",     "file_field"=>"remote"}             if field_order.push("remote")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
end