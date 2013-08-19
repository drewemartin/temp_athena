#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_6 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        athena_project_estimated_completion_date_fix
        
    end
    #---------------------------------------------------------------------------
    
    def athena_project_estimated_completion_date_fix
        
        puts "#DATA CORRECTION: athena_project FIELD: estimated_completion_date (replace 00-00-0000 values w/ null)"
        
        sql_str = "UPDATE athena_project SET estimated_completion_date = NULL WHERE estimated_completion_date REGEXP '0000-00-00'"
        
        $db.query(sql_str)
        
    end
    
end

SCRIPT_6.new