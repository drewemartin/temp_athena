#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Init < Base
    
    #---------------------------------------------------------------------------
    def initialize(table = nil)
        super()
        start = Time.new
        @init_primary_pre_reqs = false
        if !table.empty?
            init(table[0])
        else
            $tables.table_names.each{|table|
                init(table)
            }
        end
        puts "#{(Time.new - start)/60} minutes"
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    def init(tableName)
        start = Time.new
        table = $tables.attach(tableName)
        if table
            if !@init_primary_pre_reqs
                table.init_primary_pre_reqs
                @init_primary_pre_reqs = true
            end
            puts "Init started at #{time_str(start)} -> #{table.data_base}.#{table.table_name}"
            table.init
            puts "Init completed in #{(Time.new - start)/60} minutes"
            puts ">-------------------------------------------------------->"
        else
            puts "'#{tableName}' is not a table."
        end
    end

end

Init.new(ARGV)