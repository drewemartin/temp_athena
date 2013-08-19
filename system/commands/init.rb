#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Init < Base
    
    #---------------------------------------------------------------------------
    def initialize(table = nil)
        super()
        @init_primary_pre_reqs = false
        if !table.empty?
            init(table[0])
        else
            $tables.table_names.each{|table|
                init(table)
            }
        end
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    def init(table)
        start = Time.new
        table = $tables.attach(table)
        if !@init_primary_pre_reqs
            table.init_primary_pre_reqs
            @init_primary_pre_reqs = true
        end
        puts "Init started at #{time_str(start)} -> #{table.table_name}"
        table.init
        puts "Init completed in #{(Time.new - start)/60} minutes"
        puts ">-------------------------------------------------------->"
    end

end

Init.new(["ILP_ENTRY_TYPE"])