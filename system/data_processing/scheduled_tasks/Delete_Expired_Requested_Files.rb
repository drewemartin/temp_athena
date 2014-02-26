#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"

class Delete_Expired_Requested_Files < Base
    
    def initialize()
        
        super()
        
        if File.exists?(path = $paths.temp_path)
            
            Dir.entries(path).each{|entry|
                
                if entry != "." && entry != ".."
                    
                    timestamp     = File.mtime("#{path}/#{entry}")
                    timestamp_str = timestamp.strftime("%Y-%m-%d")
                    
                    if Date.strptime(timestamp_str) < (Date.today-2)
                        
                        File.delete("#{path}/#{entry}")
                        
                    end
                    
                end
                
            }
            
        end
        
    end
    
end

Delete_Expired_Requested_Files.new()