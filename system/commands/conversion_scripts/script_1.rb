#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_1 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        #GENERAL CHANGES
        populate_team_active_field
        team_one_to_one_setup
        populate_course_relate_table
        scantron_exempt
        student_relate_evaluation_eligible
        math_specialists
        reading_specialists
        
    end
    #---------------------------------------------------------------------------
    
    def populate_team_active_field
        
        puts "#POPULATE TABLE: team FIELD: active"
        
        $db.query("UPDATE team SET active = true")
        
    end
    
    def team_one_to_one_setup
        
        puts "#CREATE TEAM ONE TO ONE RECORDS"
        
        #MAKE SURE THAT ALL ACTIVE TEAM MEMBERS HAVE ALL ONE TO ONE RELATIONSHIP RECORDS
        pids = $tables.attach("team").primary_ids(
            "WHERE active IS TRUE"
        )
        Dir.glob("#{$paths.tables_path}TEAM_*.rb").each{|entry|
            
            table_name = entry.split("/")[-1].gsub(".rb","")
            
            if $tables.attach(table_name).relationship == :one_to_one
                
                table_function = table_name.gsub("TEAM_", "").downcase
             
                pids.each{|pid|
                    
                    t = $team.get(pid)
                    t.send("#{table_function}").existing_record || t.send("#{table_function}").new_record.save
                    
                }
                
            end
            
        } if pids
        
    end

    def populate_course_relate_table
        
        puts "#POPULATE TABLE: course_relate FIELD: course_name, scantron_growth_math, scantron_growth_reading"
        
        pids = $tables.attach("STUDENT_RELATE").primary_ids
        pids.each{|pid|
            
            record           = $tables.attach("STUDENT_RELATE").by_primary_id(pid)
            this_course_name = record.fields["role_details" ].value
            if !this_course_name.nil?
                
                if !$tables.attach("COURSE_RELATE").primary_ids("WHERE course_name = '#{Mysql.quote(this_course_name)}'")
                    record = $tables.attach("COURSE_RELATE").new_row
                    record.fields["course_name"              ].value = this_course_name
                    record.fields["scantron_growth_math"     ].value = true
                    record.fields["scantron_growth_reading"  ].value = true
                    record.save
                end
                
            end
            
        } if pids
        
    end
    
    def scantron_exempt
        
        puts "#POPULATE TABLE: student_assessment FIELD: scantron_exempt_ent_m, scantron_exempt_ent_r, scantron_exempt_ext_m, scantron_exempt_ext_r"
        
        headers = nil
        CSV.open("#{$paths.conversion_path}scantron_exempt.csv","rb").each{|row|
            
            if headers
                
                if s = $students.get(row[0])
                    
                    s.assessment.send(headers[1]).set(row[1]).save
                    s.assessment.send(headers[2]).set(row[2]).save
                    s.assessment.send(headers[3]).set(row[3]).save
                    s.assessment.send(headers[4]).set(row[4]).save
                    
                else
                    puts row[0]
                end
                
            else
                headers = row
            end
            
        }
        
    end
    
    def student_relate_evaluation_eligible
        
        puts "#POPULATE TABLE: student_realte FIELD: eval_eligible_academic, eval_eligible_engagement"
        
        $db.query(
            
            "UPDATE student_relate
            SET  eval_eligible_academic = TRUE,
            eval_eligible_engagement = TRUE"
            
        )
        
    end
    
    def math_specialists
        
        puts "#POPULATE TABLE: student_specialist_math"
        
        headers = nil
        CSV.open("#{$paths.conversion_path}math_specialists.csv","rb").each{|row|
            #student_id	team_id	monday	tuesday	wednesday	thursday	friday
            if headers
                
                if s = $students.get(row[0])
                    
                    s.specialist_math.existing_record || s.specialist_math.new_record.save
                    
                    if t = $team.find(:full_name=>row[1])
                        
                        s.specialist_math.send(headers[0]).set(row[0]                   ).save
                        s.specialist_math.send(headers[1]).set(t.primary_id.value       ).save
                        s.specialist_math.send(headers[2]).set(row[2]                   ).save
                        s.specialist_math.send(headers[3]).set(row[3]                   ).save
                        s.specialist_math.send(headers[4]).set(row[4]                   ).save
                        s.specialist_math.send(headers[5]).set(row[5]                   ).save
                        s.specialist_math.send(headers[6]).set(row[6]                   ).save
                        
                    else
                        puts "#{headers[1]}: #{row[1]}"
                    end
                    
                else 
                    puts "#{headers[0]}: #{row[0]}"
                end
                
            else
                headers = row
            end
            
        }
        
    end
    
    def reading_specialists
        
        puts "#POPULATE TABLE: student_specialist_reading"
        
        headers = nil
        CSV.open("#{$paths.conversion_path}reading_specialists.csv","rb").each{|row|
            #student_id	team_id	monday	tuesday	wednesday	thursday	friday
            if headers
                
                if s = $students.get(row[0])
                    
                    s.specialist_reading.existing_record || s.specialist_reading.new_record.save
                    
                    if t = $team.find(:full_name=>row[1])
                        
                        s.specialist_reading.send(headers[0]).set(row[0]                   ).save
                        s.specialist_reading.send(headers[1]).set(t.primary_id.value       ).save
                        s.specialist_reading.send(headers[2]).set(row[2]                   ).save
                        s.specialist_reading.send(headers[3]).set(row[3]                   ).save
                        s.specialist_reading.send(headers[4]).set(row[4]                   ).save
                        s.specialist_reading.send(headers[5]).set(row[5]                   ).save
                        s.specialist_reading.send(headers[6]).set(row[6]                   ).save
                        
                    else
                        puts "#{headers[1]}: #{row[1]}"
                    end
                    
                else 
                    puts "#{headers[0]}: #{row[0]}"
                end
                
            else
                headers = row
            end
            
        }
        
    end
    
end