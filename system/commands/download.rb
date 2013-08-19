#!/usr/local/bin/ruby

require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Download < Base

        def initialize(arg)
                super()
                Dir.entries($paths.tables_path).each{|entry|
                        if !entry.gsub(/\.|rb/,"").empty?
                                table_name      = entry.split(".rb")[0]
                                table           = $tables.attach(table_name)
                                downloadable    = table.source_type == "k12_report"    
                                
                                if downloadable
                                        #Try download up to three times
                                        tries           = 0
                                        downloaded      = false
                                        until downloaded || tries == 5
                                                downloaded = table.download
                                                tries += 1
                                        end
                                end
                        end  
                }
                
        end

end

Download.new(["k12_reports"])