#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class After_Load < Base

    def initialize(arg)
        super()
        
        this_table = $tables.attach(arg[0])
        
        this_table.db_config_record(
            field_name  = "load_started_datetime",
            new_value   = DateTime.now
        )
        
        this_table.find_and_trigger_event(:after_load)
        
        this_table.db_config_record(
            field_name  = "import_complete_datetime",
            new_value   = DateTime.now
        )
        
    end
    
end

After_Load.new(ARGV)