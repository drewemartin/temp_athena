#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"
class Load_History < Base

   def initialize(args)
      super()
      
      args = false if args.empty?
      
      tables = $tables.table_names
      tables.each{|table_name|
         
         table = $tables.attach(table_name)
         
         if files_paths = Dir["#{$paths.imports_path}loading_history/#{table.file_name.gsub(".csv","/*.csv")}"]
            
            files_paths.each{|file_path|
               
               table.file_path         = file_path
               
               date_string           = file_path.split("_D")[-1].split(".csv")[0].gsub("T"," ")
               $base.created_date    = DateTime.parse(date_string).strftime("%Y-%m-%d %H:%M:%S")
               table.load(:after_load=>args,:loading_history=>true)
               
            }
            
         end 
         
      }
      
   end
   
end