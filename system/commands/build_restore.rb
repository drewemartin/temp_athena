#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Build_Restore < Base
    
    #---------------------------------------------------------------------------
    def initialize(destination)
        super()
        
        destination     = destination[0]||"restore_build"
        
        restore_path    = "#{$config.storage_root}#{destination}"
        zip_file_path   = "#{$config.storage_root}extract_to_restore_folder_#{$ifilestamp}.zip"
        zip_file        = Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE)
        zip_file.close
        Dir.entries($paths.tables_path).each{|entry|
            
            if !entry.gsub(/\.|rb/,"").empty?
                
                table = $tables.attach(entry.split(".rb")[0])
                if table.exists?
                    
                    start = Time.new
                    puts "started at #{time_str(start)} -> #{table.table_name}"
                        
                        zip_file    = Zip::ZipFile.open(zip_file_path)
                        backup_path = table.re_initialize(
                            :backup_only    => true,
                            :restore_path   => destination
                        )
                        entry_dir   = backup_path.split("/")[-1]
                        srcPath = backup_path.gsub("#{entry}/","")
                        zip_file.add(entry_dir, srcPath)
                        Dir.glob("#{backup_path}*.csv").each{|file_path|
                            this_entry = file_path.split("/")[-1]
                            zip_file.add("#{entry_dir}/#{this_entry}", file_path)
                        }
                       
                        zip_file.close
                        
                    puts "completed in #{(Time.new - start)/60} minutes"
                    puts ">-------------------------------------------------------->"
                    
                end
                
            end 
        }
        
        existing_codeset_restore_file = Dir.glob("#{restore_path}*")
        FileUtils.rm_rf(restore_path) if existing_codeset_restore_file
        
    end
    #---------------------------------------------------------------------------

end

Build_Restore.new(ARGV)