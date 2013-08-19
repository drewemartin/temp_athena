#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class CONVERSION_TOOL < Base

    def initialize(a=[])
        super()
        
        if db_option = a.find{|x|x.match(/db:/)}
            @dbname = db_option.split(":")[1]
        else
            @dbname = $config.db_name
        end
        
        @archive_dbname     = "#{$config.school_name}_archive_#{@dbname}_#{$ifilestamp}"
        
        @mysql_path         = "#{File.dirname(__FILE__).gsub("htdocs/athena/system/commands","mysql\\bin\\mysql"    )}".gsub("/","\\")
        @mysqldump_path     = "#{File.dirname(__FILE__).gsub("htdocs/athena/system/commands","mysql\\bin\\mysqldump")}".gsub("/","\\")
        
        @restore_path       = $config.init_path("#{$paths.restore_path}conversion")
        
        if !a.empty?
            
            function    = a.delete_at(0)
         
            if a.empty?
                eval(function)
            else
                eval("#{function}(#{"\"#{a.join("\", \"")}\""})")
            end
            
        else
            complete_conversion
        end
        
    end

    def complete_conversion
        
        start = Time.new
        
        #backup
        archive
        pre_init
        restore
        post_init
        conversion_scripts
        re_init
        
        puts "#CONVERSION COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def archive
        
        start = Time.new
        
        puts "#ARCHIVE OLD DATABASE"
        
        $db.query("CREATE DATABASE IF NOT EXISTS `#{@archive_dbname}`")
        $db.query('show tables', @dbname).each do |table|
            $db.query("RENAME TABLE #{@dbname}.#{table[0]} TO #{@archive_dbname}.#{table[0]};")
        end
        
        puts "#CONVERSION ARCHIVE COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def backup(table_name = nil)
        
        start = Time.new
        
        tables = table_name ? [[table_name]] : $db.query('show tables', @dbname)
        
        puts "#CREATE BACKUP OF OLD DATABASE"
        tables.each do |table|
            puts "BACKING UP: #{table}"
            `#{@mysqldump_path} -u #{$config.db_user} -p#{$config.db_pass} #{@dbname} #{table[0]} > #{@restore_path}#{table[0]}.sql`
        end
        
        puts "#CONVERSION BACKUP COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def conversion_scripts
        
        start = Time.new
        
        puts "#RUN CONVERSION SCRIPTS"
        i = 1
        complete = false
        until complete
            
            file_path = "#{$paths.commands_path}conversion_scripts/script_#{i}.rb"
            if File.exists?(file_path)
                
                start = Time.new
                
                require "#{file_path}"
                conversion_script = Object.const_get("SCRIPT_#{i}").new();
                
                puts "#CONVERSION SCRIPT - #{file_path} COMPLETED IN #{(Time.new - start)/60} MINUTES"
                puts ">-------------------------------------------------------->"
                
            else
                complete = true
            end
            
            i+=1
            
        end
        
        puts "#CONVERSION SCRIPTS COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def pre_init
        
        start = Time.new
        
        puts "#CREATE CONVERSION DATABASE"
        $db.query("CREATE DATABASE IF NOT EXISTS `#{@dbname}`")          
        
        puts "#RUN PRE-INIT PROCEDURE ON CONVERSION DATABASE"
        init_primary_pre_reqs = false
        $tables.table_names.each{|table|
            
            table = $tables.attach(table)
            
            if !init_primary_pre_reqs
                table.init_primary_pre_reqs
                init_primary_pre_reqs = true
            end
            
            table.init(nil, table_only = true)
            
        }
        
        puts "#CONVERSION PRE-INIT COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end

    def post_init
        
        start = Time.new
        
        puts "#RUN POST-INIT PROCEDURE ON CONVERSION DATABASE"
        init_primary_pre_reqs = false
        $tables.table_names.each{|table|
            
            table = $tables.attach(table)
            
            if !init_primary_pre_reqs
                table.init_primary_pre_reqs
                init_primary_pre_reqs = true
            end
            
            table.init
            
        }
        
        puts "#CONVERSION POST-INIT COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def re_init
        
        start = Time.new
        
        puts "#RUN RE-INIT PROCEDURE ON CONVERSION DATABASE"
        $tables.table_names.each{|table|
            table = $tables.attach(table)
            table.re_initialize
        }
        
        puts "#CONVERSION RE-INIT COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def restore(table_name = nil)
        
        start = Time.new          
        
        tables = table_name ? [table_name] : $db.get_data_single('show tables', @dbname)
        
        puts "#RESTORE INTO CONVERSION DATABASE"
        tables.each do |table|
            puts "RESTORING: #{table}"
            `#{@mysql_path} -u #{$config.db_user} -p#{$config.db_pass} #{@dbname} < #{@restore_path}#{table}.sql`
        end
        
        puts "#CONVERSION RESTORE COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
    def restore_from_archive(archive_datetime_stamp, table_name = nil)
        
        start = Time.new          
        
        tables = table_name ? [table_name] : $db.get_data_single('show tables', @dbname)
        
        puts "#RESTORE FROM ARCHIVE"
        tables.each do |table|
            puts "RESTORING: #{table}"
            `#{@mysql_path} -u #{$config.db_user} -p#{$config.db_pass} #{@dbname} < #{@restore_path}#{table}.sql`
        end
        
        puts "#CONVERSION RESTORE COMPLETED IN #{(Time.new - start)/60} MINUTES"
        puts ">-------------------------------------------------------->"
        
    end
    
end
  
CONVERSION_TOOL.new(ARGV)