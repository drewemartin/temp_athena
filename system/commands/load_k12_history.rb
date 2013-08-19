#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base/base")}"
class Load_K12_History < Base

   def initialize(args)
      super()
      
      if args
         
         dir_name = "k12_history_reports" #YOU SHOULD PUT YOUR HISTORY IMPORTS IN A SUBDIRECTORY OF THE IMPORT FILE.
         
         load_tables       = args.delete_at(0)
         after_load_tables = args
         
         load_tables.each{|table_name|
            
            table = $tables.attach(table_name)
            
            if files_paths = Dir["#{$paths.imports_path}#{dir_name}/#{table.file_name.gsub(".csv","/*.csv")}"]
               
               files_paths.each{|file_path|
                  
                  start_this_load = Time.new
                  
                  puts ">-------------------------------------------------------->"
                  puts "#START: #{start_this_load}"
                  puts "#{table_name} #{file_path}"
                  
                  table.file_path         = file_path
                  
                  #Get the actual date created first so that history will reflect correct created date.
                  last_record = nil
                  CSV.open(file_path, 'r').each{|row|
                     last_record = row[0]    
                  }
                  
                  if last_record && last_record.match(/generated/i)
                     
                     puts "K12 GENERATION TIMESTAMP: #{last_record}"
                     
                     date_string           = last_record.split("Date generated ")[1].split(" in  seconds")[0].gsub("@"," ")
                     $base.created_date    = DateTime.parse(date_string).strftime("%Y-%m-%d %H:%M:%S")
                     table.load(:k12_history_directory=>dir_name, :after_load=>after_load_tables)
                  else
                     puts "LOAD_K12_HISTORY #{table_name} FAILED!!!"
                     puts "K12 GENERATION TIMESTAMP NOT VALID: #{last_record}"
                     #base.system_notification("LOAD_K12_HISTORY FAILED", "#{table_name} - K12 Generated Date Column for file datestamped #{file_datestamp} has an unacceptable value: #{created_date}")
                  end
                  
                  end_this_load = Time.new
                  puts "#END: #{end_this_load} #{table_name} #{file_path}"
                  puts "##{( end_this_load- start_this_load)/60} MINUTES"
                  puts "<--------------------------------------------------------<"
                  
               }
               
            end
            
         }
         
      end
      
   end
   
end

Load_K12_History.new(ARGV)