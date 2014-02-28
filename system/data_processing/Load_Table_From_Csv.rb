#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Load_Table_From_Csv < Base

    def initialize()
        super()
    end

    def load_table(table_name)
        
        $tables.attach(table_name).load
        
    end
    
end