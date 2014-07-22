#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"

class Process_Log_Execute < Base

    def initialize()
        super()
    end

    def execute_processes
        
        remote = ENV["COMPUTERNAME"].match(/PERSEUS/) ? "1":"0"
        
        rows = $tables.attach("Process_Log").by_status("NULL", remote)
        rows.shift(1).each do |row|
            
            school_year_holder  = $config.school_year
            $config.school_year = row.fields["school_year"].value
            
            fields          = row.fields
            
            fields["status"         ].value = "Processing"
            fields["start_datetime" ].value = DateTime.now
            row.save
            
            class_name      = fields["class_name"       ].value
            function_name   = fields["function_name"    ].value
            created_by      = fields["created_by"       ].value
            
            $base.created_by = created_by
            
            if fields["args"].value.nil?
                
                args = ""
                
            else
                
                args = fields["args"].value.split("<,>").map {|w| "\"#{w}\""}.join(', ')
                
            end
            
            begin
                
                eval("require \"#{File.dirname(__FILE__).gsub("scheduled_tasks","")}#{class_name}\"")
                
                if function_name
                    
                    eval("#{class_name}.new\(\).#{function_name}\(#{args}\)")
                    
                else
                    
                    eval("#{class_name}.new\(#{args}\)")
                    
                end
                
                fields["status"             ].value = "Completed"
                fields["completed_datetime" ].value = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
                
                row.save
                
            rescue => e
                
                fields["status"             ].value = "Failed"
                row.save
                
                $base.system_notification("Process Log Failed", "#{e.message}\n\n#{e.backtrace}")
                
            end
            
            $config.school_year = school_year_holder
            
        end if rows
        
    end
    
end

Process_Log_Execute.new().execute_processes
