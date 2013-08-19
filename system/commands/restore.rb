#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Restore < Base

    def initialize(arg)
        super()
        db_config = $tables.attach("Db_Config")
        table_instr  = !arg.empty? ? arg[0] : false
        rewind_instr = !arg.empty? && arg.length == 2 ? arg[1] : false
        if !table_instr
            table_list = db_config.tables
        elsif table_instr == "K12_Reports"
            table_list = db_config.k12_reports
        else
            table_list = db_config.tables(table_instr)
        end
        if table_list
            table_list.each{|x|
                x.fields["last_import_status"].value    = "RESTORING FROM BACKUP"
                x.fields["last_import_datetime"].value  = $idatetime
                x.save 
                start = Time.new
                table = $tables.attach(x.fields["table_name"].value)
                puts "Restore started at #{time_str(start)} -> #{table.table_name}"
                table.restore(rewind_instr)
                puts "Restore completed in #{(Time.new - start)/60} minutes"
                puts ">-------------------------------------------------------->"   
                x.fields["last_import_status"].value = "RESTORE COMPLETE"
                x.save 
            }
        end
    end

end

Restore.new(["athena_project"])