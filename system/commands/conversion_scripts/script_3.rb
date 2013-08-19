#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_3 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        #remove_student_relate_family_coach_records
        #load_history_student_relate
        
    end
    #---------------------------------------------------------------------------
    
    def remove_student_relate_family_coach_records
        
        $db.query(
            "DELETE
            FROM student_relate
            WHERE role = 'Family Teacher Coach'"
        )
        
    end
    
    def load_history_student_relate
        
        puts "#LOAD FAMILY COACH/STUDENT RELATE HISTORY"
        puts "Please move omnibus files (date range 9/1/2012 - Now) from FTP to imports/load_history/agora_omnibus? (PRESS ENTER WHEN READY)"
        this_response = STDIN.gets
        
        require "#{$paths.data_processing_path}load_history"
        Load_History.new(["student_relate"])
       
    end
    
end