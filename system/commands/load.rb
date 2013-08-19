#!/usr/local/bin/ruby

require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Load < Base

        def initialize(arg)
                super()
                
                db_config = $tables.attach("Db_Config")
                special_instr = !arg.empty? ? arg[0] : false
                if special_instr
                    if special_instr == "all"
                        scheduled_now = db_config.tables
                    elsif special_instr == "K12_Reports"
                        scheduled_now = db_config.k12_reports
                    else
                        scheduled_now = db_config.tables(special_instr)
                    end
                else
                    scheduled_now = db_config.scheduled_now
                end
                
                if scheduled_now
                        
                        scheduled_now.each{|db_config_record|
                                
                                table_name      = db_config_record.fields["table_name"].value
                                table           = $tables.attach(table_name)
                                
                                downloadable =
                                        table.source_type == "scantron_performance"     ||
                                        table.source_type == "jupiter_grades"           ||
                                        table.source_type == "k12_report"
                                
                                if downloadable && !table.import_file_exists?
                                        
                                        tries           = 0
                                        downloaded      = false
                                        until downloaded || tries == 5
                                                downloaded = table.download
                                                tries += 1
                                        end
                                        if downloaded
                                                loaded = table.load
                                        else
                                                loaded = false
                                        end
                                        
                                else
                                        
                                        loaded = table.load
                                        
                                end
                                
                                if !loaded
                                        
                                        ########################################################
                                        #PROCESS THAT MUST TAKE PLACE REGARDLESS OF LOAD SUCCESS
                                        case table_name
                                        when "K12_OMNIBUS"
                                                $tables.attach("student_attendance").after_load_k12_omnibus
                                        end
                                        ########################################################
                                        
                                        db_config_record_updated= db_config.by_table_name(table_name)
                                        subject                 = "IMPORT FAILED - #{table.table_name}!"
                                        content                 = String.new
                                        content << "\nTOTAL DOWNLOAD ATTEMPTS: #{tries}"
                                        content << "\nDOWNLOADED: #{downloaded}"
                                        content << "\nLOADED: #{loaded}"
                                        content << "\nSTATUS: #{db_config_record_updated.fields["last_import_status"].value}"
                                        
                                        $base.system_notification(subject, content)
                                        
                                        secondary_alert_recipients = [
                                                "tkreider@agora.org",
                                                "esaddler@agora.org",
                                                "kyoung@agora.org"
                                        ]
                                        $base.email.scuttle(subject, content, secondary_alert_recipients) if secondary_alert_recipients.length > 0
                                        
                                end
                        }
                end
        end

end

Load.new(ARGV)