#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Reindex < Base
    
    #---------------------------------------------------------------------------
    def initialize(table = nil)
        super()
        
        if !table.empty?
            $tables.attach(table[0]).reindex
        else
            $tables.table_names.each{|table|
                $tables.attach(table).reindex
                puts "REINDEXED TABLE - #{table}"
            }
        end
        
    end
    #---------------------------------------------------------------------------

end

Reindex.new(ARGV)