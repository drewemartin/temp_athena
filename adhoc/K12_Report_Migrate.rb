#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class K12_Report_Migrate < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        @transfile_path     = nil
        @transferred_path   = $config.init_path("#{$config.storage_root}transferred")
        @transferfail_path  = $config.init_path("#{$config.storage_root}transfer_failed")
        k12_path = "#{$paths.imports_path}k12_reports"
        Dir.entries(k12_path).each{|entry1|
         
            entry1_path = "#{k12_path}/#{entry1}"
            if !entry1.gsub(/\.|rb/,"").empty?
                
                Dir.entries(entry1_path).each{|entry2|
                    
                    entry2_path = "#{entry1_path}/#{entry2}"
                    if !entry2.gsub(/\.|rb/,"").empty?
                        
                        Dir.entries(entry2_path).each{|entry3|
                            
                            entry3_path = "#{entry2_path}/#{entry3}"
                            if !entry3.gsub(/\.|rb/,"").empty? && entry2 != "enrollmentInfoTab"
                                
                                i = 0
                                
                                puts entry3_path
                                
                                start = Time.new
                                
                                begin
                                    File.size?(entry3_path).to_s.length < 9 ? x = CSV.read(entry3_path) : x = false
                                rescue
                                    x = false
                                end
                                
                                if x && !x.empty? && x.length > 1 && (x[-1][0].match(/generated/i))
                                    #Date generated 2011-04-25@06:52 in  seconds
                                    date_string     = x[-1][0].split("Date generated ")[1].split(" in  seconds")[0].gsub("@"," ")
                                    date_stamp      = DateTime.parse(date_string).strftime("D%Y%m%dT%H%M%S")
                                    new_file_name   = entry2.include?("agora") ? "#{entry2.gsub("-","_")}_#{date_stamp}.csv" : "#{"agora"}_#{entry2.gsub("-","_")}_#{date_stamp}.csv"
                                    dir_name        = new_file_name.split("_D20")[0]
                                    @transfile_path = $config.init_path("#{@transferred_path}#{dir_name}")
                                    ftp             = login
                                    ftp.chdir("k12_reports")
                                    begin
                                        ftp.chdir(dir_name)
                                    rescue
                                        ftp.mkdir(dir_name)
                                        retry
                                    end
                                    ftp.puttextfile(entry3_path)
                                    ftp.rename(entry3, new_file_name)
                                    ftp.close
                                    FileUtils.mv(entry3_path, "#{@transfile_path}#{new_file_name}")
                                else
                                    transfer_failed(entry3_path)
                                end
                                puts DateTime.now.strftime("D%Y%m%dT%H%M%S")
                                puts "#{(Time.new - start)/60}"
                            else
                                if !entry3.gsub(/\.|rb/,"").empty?
                                    transfer_failed(entry3_path) 
                                end                          
                            end
                        }
                        Dir.rmdir(entry2_path)
                    else
                        if !entry2.gsub(/\.|rb/,"").empty?
                            p "what?!?"
                        end
                    end
                }
                Dir.rmdir(entry1_path)
            end
        }
    end
    #---------------------------------------------------------------------------

    def transfer_failed(entry3_path)
        this_time = DateTime.now.strftime("D%Y%m%dT%H%M%S")
        FileUtils.mv(
            entry3_path,
            "#{@transferfail_path}#{entry3_path.split("/")[-1]}".gsub(".","_#{this_time}.")
        )
    end
    
    def login
        ftp = Net::FTP.new('ftp.athena-sis.com')
        ftp.login("athenareports", "Lemodie_23")
        ftp.passive = true
        return ftp
    end
end

K12_Report_Migrate.new