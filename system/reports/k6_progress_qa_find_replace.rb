#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("scripts", "")}/athena_base"

class K6_Progress_Snapshot_Correction < Athena_Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        fail = Array.new
        path = "#{$paths.reports_path}/Progress_Reports/School_Year_2011-2012/Q3_K6_Students"
        Dir.entries(path).each{|entry|
            file_path = "#{path}/#{entry}"
            if !File.directory?(file_path)
                PDF::Reader.open(file_path) do |reader|
                    reader.pages.each do |page|
                        if page.text.include?("[") || page.text.include?("]")
                            puts "FAIL TEST: #{file_path}"
                            fail.push(file_path)
                        end
                    end
                end
            end 
        }
        
        
        
    end
    #---------------------------------------------------------------------------
    
    
end

K6_Progress_Snapshot_Correction.new