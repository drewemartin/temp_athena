#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Delete_Temp_Files < Base
    
    def initialize()
        
        super()
        
        if File.exists?(path = $paths.temp_path)
            
            Dir.entries(path).each{|entry|
                
                File.delete("#{path}/#{entry}") if entry != "." && entry != ".."
                
            }
            
        end
        
    end
    
end

Delete_Temp_Files.new()