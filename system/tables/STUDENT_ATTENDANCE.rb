#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ATTENDANCE < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def DISABLED_after_load_k12_ecollege_activity
        
        source  = "LMS"
        pids    = $tables.attach("K12_ECOLLEGE_ACTIVITY").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_ECOLLEGE_ACTIVITY").by_primary_id(pid)
            date    = record.fields["activitydate" ].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_elluminate_session
        
        source  = "Blackboard"
        pids    = $tables.attach("K12_ELLUMINATE_SESSION").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_ELLUMINATE_SESSION").by_primary_id(pid)
            date    = record.fields["attendee_start_time"   ].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_hs_activity
        
        source  = "LMS - Manual"
        pids    = $tables.attach("K12_HS_ACTIVITY").primary_ids
        
        pids.each{|pid|
            
            record  = $tables.attach("K12_HS_ACTIVITY").by_primary_id(pid)
            date    = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
                
                student = $students.get(record.fields["student_id"].value)
                student.log_attendance_activity(:date=>date, :source=>source) if student
                
            end
            
        } if pids
        
    end
    
    def DISABLED_after_load_k12_lessons_count_daily
        
        source  = "OLS"
        pids    = $tables.attach("K12_LESSONS_COUNT_DAILY").primary_ids
        
        pids.primary_ids.each{|pid|
            
            record  = $tables.attach("K12_LESSONS_COUNT_DAILY").by_primary_id(pid)
            date    = record.fields["total_last_lesson" ].iso_date
            
            if $field.is_schoolday?(date)
                
                if !date.nil?
                    
                    student = $students.get(record.fields["student_id"].value)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                end
                
            end
           
        } if pids
        
    end
    
    def DISABLE_after_load_k12_logins
        
        #THE STUDENT LOGGED IN
        source  = "K12 Logins"
        pids    = $tables.attach("K12_LOGINS").primary_ids("WHERE role = '1001' AND last_login IS NOT NULL AND last_login REGEXP '2013-09-03'")
        
        pids.each{|pid|
            
            record      = $tables.attach("K12_LOGINS").by_primary_id(pid)
            date        = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
              
                identity_id = record.fields["identityid"].value
                
                if sid = $tables.attach("STUDENT").find_field("student_id", "WHERE identityid = '#{identity_id}'")
                    
                    student = $students.get(sid.value)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                end
                
            end
            
        } if pids
        
        #THE LEARNING COACH LOGGED IN
        source  = "K12 Logins - LC"
        pids    = $tables.attach("K12_LOGINS").primary_ids("WHERE role = '1000' AND last_login IS NOT NULL AND last_login REGEXP '2013-09-03'")
        
        pids.each{|pid|
            
            record      = $tables.attach("K12_LOGINS").by_primary_id(pid)
            date        = record.fields["last_login"].iso_date
            
            if $field.is_schoolday?(date)
                
                family_id   = record.fields["familyid"  ].value
                regkey      = record.fields["regkey"    ].value         
                sids        = $tables.attach("STUDENT").student_ids("WHERE (familyid = '#{family_id}' OR lcregistrationid REGEXP '#{regkey}')")
                
                
                sids.each{|sid|
                    
                    student = $students.get(sid)
                    student.log_attendance_activity(:date=>date, :source=>source) if student
                    
                } if sids
                
            end
            
        } if pids
        
    end

    def after_load_k12_omnibus
        
        eval_date = $base.created_date ? DateTime.parse($base.created_date).strftime("%Y-%m-%d") : $idate
        
        if $field.is_schoolday?(eval_date)
            
            sids = $students.list(:currently_enrolled=>true)
            sids.each{|sid|
                
                student = $students.get(sid)
                
                #CREATE A DAILY ATTENDANCE MASTER RECORD IF ONE DOES NOT EXIST
                student.attendance_master.existing_record || student.attendance_master.new_record.save
                
                #CREATE A DAILY ATTENDANCE RECORD IF ONE DOES NOT EXIST
                if !student.attendance.existing_records("WHERE date = '#{eval_date}'")
                    
                    #CREATE A MODE RECORD WITH THE DEFAULT SETTING IF ONE DOES NOT EXIST
                    if !student.attendance_mode.existing_record
                        record = student.attendance_mode.new_record
                        record.fields["attendance_mode"].set("Synchronous")
                        record.save
                    end
                    
                    mode    = student.attendance_mode.attendance_mode.value
                    code    = mode.match(/Manual/) ? (mode.match(/(default 'p')/) ? "p" : "a") : nil
                    
                    record  = student.attendance.new_record
                    record.fields["date"       ].value = eval_date
                    record.fields["mode"       ].value = mode
                    record.fields["code"       ].value = code
                    record.save
                    
                end
                
            } if sids
            
        end
        
    end

    def after_load_k12_withdrawal
        
        sids = $tables.attach("k12_withdrawal").students_with_records
        sids.each{|sid|
            
            wd_effective_date = $tables.attach("k12_withdrawal").by_studentid_old(sid).fields["schoolwithdrawdate"].value
            records = $tables.attach("student_attendance").records("WHERE attendance_date > '#{wd_effective_date}' AND student_id = '#{sid}'")
            records.each{|record|
                record.fields["mode"].value = "Withdrawn"
                record.save
            } if records
            #MARK ALL SCHOOL DAYS AFTER THE WITHDRAW EFFECTIVE DATE AS NULL
            att_mast_record = $tables.attach("student_attendance_master").by_studentid(sid)
            if att_mast_record
                school_days = $school.school_days_after(wd_effective_date)
                if school_days
                    school_days.each{|date|
                        att_mast_record.fields["code_#{date}"    ].value = nil
                        att_mast_record.fields["activity_#{date}"].value = nil
                    }
                    att_mast_record.save
                end
            end
        }
        
    end
    
    def DISABLED_after_load_student_sapphire_period_attendance
        
        #start = Time.new
        
        source  = "Sapphire Period Attendance"
        pids    = $tables.attach("STUDENT_SAPPHIRE_PERIOD_ATTENDANCE").primary_ids
        
        pids.each{|pid|
            
            record              = $tables.attach("STUDENT_SAPPHIRE_PERIOD_ATTENDANCE").by_primary_id(pid)
            sid                 = record.fields["student_id"    ].value
            date                = record.fields["calendar_day"  ].value
            student             = $students.get(sid)
            
            student_activity    = String.new
            
            day_codes = $tables.attach("SAPPHIRE_CALENDARS_CALENDARS").find_fields(
                "CONCAT(school,':',day_code)",
                "WHERE date = '#{date}' GROUP BY CONCAT(school,':',day_code)",
                {:value_only=>true}
            )
            
            qualifying_periods = Array.new
            
            day_codes.each{|day_code|
                
                school      = day_code.split(":")[0]
                day_code    = day_code.split(":")[1]
                
                pattern_fields = $tables.attach("STUDENT_SAPPHIRE_CLASS_ROSTER").find_fields(
                    "pattern",
                    "WHERE active IS TRUE
                    AND `pattern` REGEXP '\\\\(.*#{day_code}.*\\\\)'
                    AND school_id = '#{school}'
                    AND student_id = '#{sid}'
                    GROUP BY pattern",
                    {:value_only=>true}
                )
                
                if pattern_fields
                    
                    pattern_fields.each{|pattern_field|
                        
                        pattern_field.split(/\r?\n/).each{|pattern|
                            
                            if period_code = pattern.match(/^(.*?)\W/).to_s
                                
                                qualifying_periods.push("period_#{period_code.strip}")
                              
                            end
                          
                        }
                        
                    }
                    
                    qualifying_periods.each{|period_code|
                        
                        #STUDENT MARKED PRESENT OR THE TEACHER FORGOT TO MARK ATTENDANCE (Forgetting to mark = present per Christina)
                        code            = record.fields[period_code.downcase].value
                        activity_code   = (code.nil? ||  code.downcase=="p") ? "p" : (code.downcase=="a" ? "u" : code.downcase)
                        
                        if (
                            
                            period_code.match(/period_elo|period_mo|period_orn/)    &&
                            activity_code == "p"                                    &&
                            student.grade.match(/K|1st|2nd|3rd|4th|5th/)
                            
                        )
                            
                            related_students = $students.list(:familyid=>student.family_id.value, :grade=>"/K|1st|2nd|3rd|4th|5th/")
                            
                            related_students.each{|related_sid|
                                
                                $student.get(related_sid).log_attendance_activity(
                                    :date      => date,
                                    :source    => "#{source}: #{period_code} - #{activity_code}"
                                ) if !(related_sid == sid)
                                
                            } 
                            
                        end
                        
                        activity            = "#{source}: #{period_code} - #{activity_code}"
                        student_activity    = attendance_activity(:activity=>activity, :activity_string=>student_activity)
                        
                    } if qualifying_periods
                    
                end
                
            } if day_codes
            
            student.log_attendance_activity(
                :date      => date,
                :source    => student_activity
            ) if !student_activity.empty?
            
        } if pids
        
        #puts "completed in #{(Time.new - start)/60} minutes"
        
    end

    def after_change_field_mode(obj)
        process_attendance(obj)
    end
    
    def after_change_field_code(obj)
        process_attendance(obj)
    end
    
    def after_insert(obj)
        process_attendance(obj)
    end
    
    def process_attendance(obj)
        unless caller.find{|x|x.match(/Attendance_Processing/)}
            record = by_primary_id(obj.primary_id)
            $students.process_attendance(:student_id=>record.fields["student_id"].value,:date=>record.fields["date"].value)
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_attendance",
                "file_name"         => "student_attendance.csv",
                "file_location"     => "student_attendance",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"student_id"    } if field_order.push("student_id"      )
            structure_hash["fields"]["date"             ] = {"data_type"=>"date", "file_field"=>"date"          } if field_order.push("date"            )
            structure_hash["fields"]["mode"             ] = {"data_type"=>"text", "file_field"=>"mode"          } if field_order.push("mode"            )
            structure_hash["fields"]["code"             ] = {"data_type"=>"text", "file_field"=>"code"          } if field_order.push("code"            )
            structure_hash["fields"]["official_code"    ] = {"data_type"=>"text", "file_field"=>"official_code" } if field_order.push("official_code"   )
            structure_hash["fields"]["sources"          ] = {"data_type"=>"text", "file_field"=>"sources"       } if field_order.push("sources"         )
            structure_hash["fields"]["complete"         ] = {"data_type"=>"bool", "file_field"=>"complete"      } if field_order.push("complete"        )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end