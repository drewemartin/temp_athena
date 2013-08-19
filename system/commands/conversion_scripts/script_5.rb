#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_5 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        #STUDENT PARTICIPATION
        #student_participation_pssa
        #student_partiticpation_keystone
        
    end
    #---------------------------------------------------------------------------
    
    def student_participation_pssa
        
        puts "#POPULATE TABLE: student_participation FIELD: pssa"
        
        headers = nil
        CSV.open("#{$paths.conversion_path}student_participation_pssa.csv","rb").each{|row|
            
            if s = $students.get(row[0])
                
                s.participation.existing_record || s.participation.new_record.save
                
                s.participation.pssa.set(row[1]).save
                
            else 
                puts row[0]
            end
            
        }
        
    end
    
    def student_partiticpation_keystone
        
        puts "#POPULATE TABLE: student_participation FIELD: keystone"
        
        headers = nil
        CSV.open("#{$paths.conversion_path}student_participation_keystone.csv","rb").each{|row|
            
            if s = $students.get(row[0])
                
                s.participation.existing_record || s.participation.new_record.save
                
                s.participation.keystone.set(row[1]).save
                
            else 
                puts row[0]
            end
            
        }
        
    end
    
end

SCRIPT_5.new