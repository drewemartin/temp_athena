#!/usr/local/bin/ruby

class ATTENDANCE_LOG

    def initialize()
        super()
        
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def k12_logins_students
        
        source          = "K12 Logins"
        source_table    = $tables.attach("K12_LOGINS")
        
        pids            = source_table.primary_ids(
            "WHERE role = '1001'
            AND last_login IS NOT NULL
            AND logged IS NULL"
        )
        
        pids.each{|pid|
            
            date = source_table.field_value_by_pid("last_login", pid)
            
            if $field.is_schoolday?(date)
              
                identity_id = source_table.field_value_by_pid("identityid", pid)
                
                if sid = $tables.attach("STUDENT").field_value("student_id", "WHERE identityid = '#{identity_id}'")
                    
                    student = $students.get(sid)
                    
                    if student
                        student.log_attendance_activity(
                            :date       => date,
                            :source     => source,
                            :period     => nil,
                            :class      => source_table.field_value_by_pid("rolename", pid),
                            :code       => "p",
                            :team_id    => nil
                        )
                    end
                    
                end
                
            end
            
        } if pids
        
        if pids
            
            source_table.query(
                "UPDATE #{source_table.table_name}
                SET logged = true
                WHERE primary_id IN(#{pids.join(",")})"
            )
            
        end
        
    end

    def k12_logins_learning_coaches
        
        source          = "K12 Logins - LC"
        source_table    = $tables.attach("K12_LOGINS")
        pids            = source_table.primary_ids(
            "WHERE role = '1000'
            AND last_login IS NOT NULL
            AND logged IS NULL"
        )
        
        pids.each{|pid|
            
            date = source_table.field_value_by_pid("last_login", pid)
            
            if $field.is_schoolday?(date)
                
                family_id   = source_table.field_value_by_pid("familyid",   pid)
                regkey      = source_table.field_value_by_pid("regkey",     pid)      
                sids        = $tables.attach("STUDENT").student_ids("WHERE (familyid = '#{family_id}' OR lcregistrationid REGEXP '#{regkey}')")
                
                
                sids.each{|sid|
                    
                    student = $students.get(sid)
                    student.log_attendance_activity(
                        :date       => date,
                        :source     => source,
                        :period     => nil,
                        :class      => source_table.field_value_by_pid("rolename", pid),
                        :code       => "p",
                        :team_id    => nil
                    ) if student
                    
                } if sids
                
            end
            
        } if pids
        
        if pids
            
            source_table.query(
                "UPDATE #{source_table.table_name}
                SET logged = true
                WHERE primary_id IN(#{pids.join(",")})"
            )
            
        end
        
    end

    def sapphire_period_attendance(school)
        
        source          = "SPA"
        source_table    = $tables.attach("SAPPHIRE_PERIOD_ATTENDANCE_#{school}")
        pids            = source_table.primary_ids("WHERE logged IS NULL")
        
        pids.each{|pid|
            
            date    = source_table.field_value_by_pid("calendar_day",    pid)
            sid     = source_table.field_value_by_pid("student_id",      pid)
            
            day_code = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").field_value(
                "day_code",
                "WHERE school = '#{school}' AND date = '#{date}' GROUP BY day_code"
            )
            
            qualifying_periods = Array.new
            
            if day_code
                
                fields = $tables.attach("SAPPHIRE_CLASS_ROSTER_#{school}").field_values(
                    "CONCAT( IFNULL(pattern,''),':',IFNULL(course_title,''),':',IFNULL(staff_id,'') )",
                    "WHERE TRUE
                    AND `pattern` REGEXP '\\\\(.*#{day_code}.*\\\\)'
                    AND school_id = '#{school}'
                    AND student_id = '#{sid}'
                    GROUP BY pattern"
                )
                
                if fields
                    
                    fields.each{|field|
                        
                        pattern_field = field.split(":")[0]
                        
                        pattern_field.split(/\r?\n/).each{|pattern|
                            
                            if period_code = pattern.match(/^(.*?)\W/).to_s
                                
                                qualifying_periods.push("#{field.gsub(pattern_field, period_code.strip)}")
                              
                            end
                          
                        }
                        
                    }
                    
                    qualifying_periods.each{|qualified_period|
                        
                        period_code, course_title, staff_id = qualified_period.split(":")
                        team_member = $team.find(:sams_id=>staff_id)
                        team_id     = team_member ? team_member.primary_id.value : nil
                        
                        #STUDENT MARKED PRESENT OR THE TEACHER FORGOT TO MARK ATTENDANCE (Forgetting to mark = present per Christina)
                        code            = source_table.field_value_by_pid("period_#{period_code.downcase}", pid)
                        activity_code   = (code.nil? ||  code.downcase=="p") ? "p" : (code.downcase=="a" ? "u" : code.downcase)
                        
                        student         = $students.get(sid)
                        
                        if (
                            
                            period_code.match(/period_elo|period_mo|period_orn/)    &&
                            activity_code == "p"                                    &&
                            student.grade.match(/K|1st|2nd|3rd|4th|5th/)
                            
                        )
                            
                            related_students = $students.list(:familyid=>student.family_id.value, :grade=>"/K|1st|2nd|3rd|4th|5th/")
                            
                            related_students.each{|related_sid|
                                
                                $students.get(related_sid).log_attendance_activity(
                                    :date       => date,
                                    :source     => source,
                                    :period     => period_code,
                                    :class      => course_title,
                                    :code       => activity_code,
                                    :team_id    => team_id || nil
                                ) if !(related_sid == sid)
                                
                            } 
                            
                        end
                        
                        student.log_attendance_activity(
                            :date       => date,
                            :source     => source,
                            :period     => period_code,
                            :class      => course_title,
                            :code       => activity_code,
                            :team_id    => team_id || nil
                        )
                        
                    } if qualifying_periods
                    
                end
                
            end
            
        } if pids
        
        if pids
            
            source_table.query(
                "UPDATE #{source_table.table_name}
                SET logged = true
                WHERE primary_id IN(#{pids.join(",")})"
            )
            
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
    
end