#!/usr/local/bin/ruby

require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Load_Recovery < Base

        def initialize(arg)
                super()
                
                db_config = $tables.attach("Db_Config")
                if scheduled_now = db_config.scheduled_missed
                        scheduled_now.each{|x|puts x.fields["table_name"].value}
                        
                        scheduled_now.each{|db_config_record|
                                
                                table = $tables.attach(db_config_record.fields["table_name"].value)
                                
                                downloadable =
                                        table.source_type == "k12_report"
                                
                                success = false
                                if downloadable && !table.import_file_exists?
                                        #Try download up to three times
                                        tries           = 0
                                        downloaded      = false
                                        until downloaded || tries == 5
                                                downloaded = table.download
                                                tries += 1
                                        end
                                        success = table.load if downloaded
                                else
                                        success = table.load
                                end
                                $base.system_notification("LOAD FAILED - #{table}","") if !success
                        }
                end
        end

end

Load_Recovery.new(ARGV)