#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Table_Import_Type_Script < Base
    
    def initialize()
        
        super()
        
        $db.get_data_single("SHOW TABLES FROM dev_k12").each do |table_name|
            table_nice_name = $tables.attach(table_name).nice_name
            type_record = $tables.attach("document_type").record("WHERE name = '#{table_nice_name}'")
            if type_record
                type_record.fields["name"].value = table_name
                type_record.save
            end
        end
        
    end
    
end

Table_Import_Type_Script.new()