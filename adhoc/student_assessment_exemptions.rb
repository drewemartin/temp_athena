#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Student_Assessment_Exemptions < Base
    
    def initialize()
        
        super()
        
        skip      = true
        file_path = "#{$paths.imports_path}student_assessment_exemptions.csv"
        
        CSV.foreach( file_path ) do |row|
          
            if !skip
                
                pasa_eligible       = row[9 ] == "PASA"                 ? true : nil
                religious_exempt    = row[9 ] == "Religious Exemption"  ? true : nil
                study_island_exempt = row[10] && row[10].match(/y/i)               ? true : nil
                aims_exempt         = row[12] && row[12].match(/y/i)               ? true : nil
                
                if row[11] && row[11].match(/y/i)
                  
                    scantron_exempt_ent_m = true
                    scantron_exempt_ent_r = true
                    scantron_exempt_ext_m = true
                    scantron_exempt_ext_r = true
                  
                else
                  
                    scantron_exempt_ent_m = nil
                    scantron_exempt_ent_r = nil
                    scantron_exempt_ext_m = nil
                    scantron_exempt_ext_r = nil
                  
                end
                
                s = $students.get(row[0])
                if s
                  
                    s.assessment.existing_record || s.assessment.new_record
                    a = s.assessment
                    
                    a.pasa_eligible.set(         pasa_eligible         ).save  
                    a.religious_exempt.set(      religious_exempt      ).save
                    a.study_island_exempt.set(   study_island_exempt   ).save
                    a.aims_exempt.set(           aims_exempt           ).save     
                    a.scantron_exempt_ent_m.set( scantron_exempt_ent_m ).save
                    a.scantron_exempt_ent_r.set( scantron_exempt_ent_r ).save
                    a.scantron_exempt_ext_m.set( scantron_exempt_ext_m ).save
                    a.scantron_exempt_ext_r.set( scantron_exempt_ext_r ).save
                 
                else
                    
                    puts row[0]
                    
                end
                
            end  
          
            skip = false
          
        end
        
    end
    
end

Student_Assessment_Exemptions.new()