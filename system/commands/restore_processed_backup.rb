#!/usr/local/bin/ruby

puts "Content-type: text/html"
puts ""
puts"<html><head></head><body>THIS IS A TEST"
  
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Restore_Processed_Backup < Base

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
            scheduled_now.each{|x|
                start = Time.new
                
                x.fields["last_import_status"           ].value = "IN PROGRESS - Restoring from processed backup file."
                x.fields["last_import_datetime"         ].value = $idatetime
                x.save
                
                table           = $tables.attach(x.fields["table_name"].value)
                
                successfull = table.restore
                
                if successfull
                    x.fields["last_import_status"].value = generation_stamp ? "COMPLETE - #{generation_stamp}" : "COMPLETE"
                    x.save
                else
                    puts "Load Failed"
                    x.fields["last_import_status"].value = "FAILED"
                    x.save
                    subject = "LOAD FAILED! - #{table.table_name}"
                    content = "NUMBER OF RECORDS: #{number_of_records}\nLAST RECORD: #{last_record}\nGENERATION STAMP: #{generation_stamp}"
                    $base.system_notification(subject, content)
                end
                
                puts "Load completed in #{(Time.new - start)/60} minutes"
                puts ">-------------------------------------------------------->"
            }
        end
    end

end

Restore_Processed_Backup.new(["K12_Omnibus"])