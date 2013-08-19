#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Backup < Base

    def initialize(arg)
        super()
        
        bu_reports_path = $config.init_path($paths.reports_path+"restore/"+$ifilestamp)
        
        Dir.entries($paths.tables_path).each{|entry|
            
            if !entry.gsub(/\.|rb/,"").empty?
                
                table = $tables.attach(entry.split(".rb")[0])
                if table.exists?
                    
                    start = Time.new
                    puts "Backup started at #{time_str(start)} -> #{table.table_name}"
                        
                        existing_codeset_restore_file = Dir.glob("#{$paths.restore_path+table.table_name}*")
                        FileUtils.rm_rf(existing_codeset_restore_file) if existing_codeset_restore_file 
                     
                        zip_file_path   = bu_reports_path+table.table_name+".zip"
                        zip_file        = Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE)
                        
                        Dir.glob(table.backup()+"*.csv").each{|bu_file_path|
                            zip_file.add(bu_file_path.split("/")[-1], bu_file_path)
                        }
                        
                        zip_file.close
                        
                        $reports.move_to_athena_reports(zip_file_path, false)
                        
                        File.delete(zip_file_path)
                        
                    puts "Backup completed in #{(Time.new - start)/60} minutes"
                    puts ">-------------------------------------------------------->"
                    
                end
                
            end 
        }
        
        FileUtils.rm_rf(bu_reports_path)
        
    end

end

Backup.new(ARGV)