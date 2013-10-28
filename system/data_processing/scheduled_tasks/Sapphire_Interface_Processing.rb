#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"
require "#{$paths.system_path}web_scraping/sapphire/sapphire_interface"

class Sapphire_Interface_Processing < Base

    def initialize()
        super()
        number_one________engage!
    end

    def number_one________engage!
        
        until !(
            
            pid = $tables.attach("SAPPHIRE_INTERFACE_QUEUE").field_value(
                "primary_id",
                "WHERE started_datetime IS NULL
                AND completed_datetime IS NULL"
            )
            
        )
            
            Sapphire_Interface.new.process_queue(pid)
            
        end
        
    end
    
end

Sapphire_Interface_Processing.new
