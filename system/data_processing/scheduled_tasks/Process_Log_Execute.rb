#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"

class Process_Log_Execute < Base

    def initialize()
        super()
    end

    def execute_processes
        
        rows = $tables.attach("Process_Log").by_status("NULL")
        rows.each do |row|
            
            fields          = row.fields
            
            fields["status"         ].value = "Processing"
            fields["start_datetime" ].value = DateTime.now
            row.save
            
            class_name      = fields["class_name"       ].value
            function_name   = fields["function_name"    ].value
            if fields["args"].value.nil?
                args = ""
            else
                args = fields["args"].value.split("<,>").map {|w| "\"#{w}\""}.join(', ')
            end
            
            begin
                
                #require $config.data_processing_path+class_name
                #success = Object.const_get(class_name).new.send(function_name, args)
                
                eval("require \"#{File.dirname(__FILE__).gsub("scheduled_tasks","")}#{class_name}\"")
                
                begin
                    
                    if function_name
                        
                        eval("#{class_name}.new\(\).#{function_name}\(#{args}\)")
                        
                    else
                        
                        eval("#{class_name}.new\(#{args}\)")
                        
                    end
                    
                    fields["status"             ].value = "Completed"
                    fields["completed_datetime" ].value = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
                    
                rescue => e
                    
                    fields["status"             ].value = "Failed"
                    
                end
                
                row.save
                
            rescue => e
                
                $base.system_notification("Process Log Failed", "#{e.message}\n\n#{e.backtrace}")
                
            end
            
        end if rows
        
    end
    
end

Process_Log_Execute.new().execute_processes
