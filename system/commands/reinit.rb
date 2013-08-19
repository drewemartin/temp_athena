#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class ReInit < Base
    
    #---------------------------------------------------------------------------
    def initialize(table = nil)
        super()
        
        if !table.empty?
            re_initialize(table[0])
        else
            $tables.table_names.each{|table|
                re_initialize(table)
            }
        end
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    def re_initialize(table)
        start = Time.new
        table = $tables.attach(table)
        puts "started at #{time_str(start)} -> #{table.table_name}"
        table.re_initialize
        puts "completed in #{(Time.new - start)/60} minutes"
        puts ">-------------------------------------------------------->"
    end

end

ReInit.new(ARGV)