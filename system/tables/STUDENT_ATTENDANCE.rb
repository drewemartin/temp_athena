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
    
    def by_studentid_old(arg, att_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg        ) )
        params.push( Struct::WHERE_PARAMS.new("date",       "=", att_date   ) ) if att_date
        where_clause = $db.where_clause(params)
        if att_date.nil?
            where_clause << "ORDER BY date DESC"
            records(where_clause)
        else
            record(where_clause)
        end
    end
    
    def create_record_if_none_exists(student_id, att_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id ) )
        params.push( Struct::WHERE_PARAMS.new("date",       "=", att_date   ) )
        where_clause = $db.where_clause(params)
        results = record(where_clause)
        if results
            return results
        else
            return new_row
        end
    end
    
    def attendance_date(att_date, args)
        params = Array.new
        operator = args[:operator] ? args[:operator] : "="
        
        params.push( Struct::WHERE_PARAMS.new("date",       operator, att_date              ) )
        params.push( Struct::WHERE_PARAMS.new("student_id", "=",      args[:student_id]     ) ) if args[:student_id]
        
        where_clause = $db.where_clause(params)
        records(where_clause)
    end
    
    def field_bystudentid(field_name, studentid, att_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid  ) )
        params.push( Struct::WHERE_PARAMS.new("date",       "=", att_date   ) ) if att_date
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def students_with_records
        select_str = 
        "SELECT
            student_id 
        FROM
            `student_attendance` 
        WHERE
            mode IS NOT NULL 
            AND mode != 'Withdrawn'
            AND mode != 'SED-Changed'
        GROUP BY student_id"
        $db.get_data_single(select_str)
    end
    
    def students_with_records_by_date(att_date, complete = nil)
        select_str =
        "SELECT
            student_id
        FROM `student_attendance`
        WHERE date = '#{att_date}'
        #{" AND complete = '#{complete}' " if complete}
        GROUP BY student_id"
        $db.get_data_single(select_str)
    end
    
    def finalize_eligible
        $db.get_data_single(
            "SELECT
                primary_id
            FROM #{table_name}
            LEFT JOIN attendance_master ON #{table_name}.student_id = attendance_master.student_id
            WHERE attendance_master.CONCAT(\"`\",date,\"`\" NOT IN(
                SELECT
                    code
                FROM attendance_codes
                WHERE
            )
            AND mode != 'Withdrawn'
            AND mode != 'SED-Changed'"
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load_k12_ecollege_activity
        
        activity_table = $tables.attach("k12_ecollege_activity")
        activity_table.primary_ids("GROUP BY student_id, activitydate").each{|pid|
            
            activity_record = activity_table.by_primary_id(pid)
            s_id            = activity_record.fields["student_id"   ].value
            att_date        = activity_record.fields["activitydate" ].iso_date
            att_record      = by_studentid_old(s_id,att_date)
            
            if att_record && !att_date.nil?
                
                this_code   = "p-k12_ecollege_activity"
                curr_value  = att_record.fields["code"].value
                
                if curr_value.nil?
                    att_record.fields["code"].value = this_code
                    att_record.save
                    
                elsif !curr_value.include?(this_code)
                    att_record.fields["code"].value = "#{curr_value},#{this_code}"
                    att_record.save
                    
                end
                
            end
            
        }
        
    end
    
    def after_load_k12_elluminate_session
        ellum_table = $tables.attach("k12_elluminate_session")
        ellum_table.primary_ids.each{|pid|
            
            ellum_record        = ellum_table.by_primary_id(pid)
            att_date            = ellum_record.fields["attendee_start_time"].iso_date
            
            sid                 = ellum_record.fields["student_id"].value
            student_record      = by_studentid_old(sid, att_date)
            
            if student_record
                att_code        = "p-k12_elluminate_session"
                current_value   = student_record.fields["code"].value
                
                if current_value.nil?
                    new_value       = att_code
                elsif !current_value.include?(att_code)
                    new_value       = "#{current_value},#{att_code}"
                else
                    new_value       = current_value
                end
                
                student_record.fields["code"].value = new_value
                student_record.save
            end
            
        }
    end
    
    def after_load_k12_hs_activity
        activity_table = $tables.attach("k12_hs_activity")
        activity_table.primary_ids.each{|pid|
            
            activity_record = activity_table.by_primary_id(pid)
            hs_date = activity_record.fields["last_login"].iso_date
            
            s_id = activity_record.fields["student_id"].value
            activity_student_record = by_studentid_old(s_id,hs_date)
            
            if activity_student_record && !hs_date.nil?
                hs_code = "p-k12_hs_activity"
                curr_value = activity_student_record.fields["code"].value
                
                if curr_value.nil?
                    neww_value = hs_code
                elsif !curr_value.include?(hs_code)
                    neww_value = "#{curr_value},#{hs_code}"
                else
                    neww_value = curr_value
                end
                
                activity_student_record.fields["code"].value = neww_value
                activity_student_record.save
            end
            
        }
        
    end
    
    def after_load_k12_omnibus
        $tables.attach("STUDENT_ATTENDANCE_MODE").create_att_mode_records
        $tables.attach("STUDENT_ATTENDANCE"     ).create_att_records
    end
    
    def after_load_k12_lessons_count_daily
        les_count_table = $tables.attach("k12_lessons_count_daily")
        les_count_table.primary_ids.each{|pid|
            
            les_record = les_count_table.by_primary_id(pid)
            att_datee = les_record.fields["total_last_lesson"].iso_date
            
            sidd = les_record.fields["student_id"].value
            student_recordd = by_studentid_old(sidd,att_datee)
            
            if student_recordd && !att_datee.nil?
                att_codee = "p-k12_lessons_count_daily"
                current_valuee = student_recordd.fields["code"].value
                
                if current_valuee.nil?
                    new_valuee = att_codee
                elsif !current_valuee.include?(att_codee)
                    new_valuee = "#{current_valuee},#{att_codee}"
                else
                    new_valuee = current_valuee
                end
                
                student_recordd.fields["code"].value = new_valuee
                student_recordd.save
            end
           
        }
        
    end
    
    def after_load_k12_logins
        login_table = $tables.attach("k12_logins")
        #THE STUDENT LOGGED IN
        login_table.primary_ids("WHERE role = '1001'").each{|pid|
            
            login_record = login_table.by_primary_id(pid)
            att_date = login_record.fields["last_login"].iso_date
           
            identity_id = login_record.fields["identityid"].value
            if sid = $tables.attach("Student").field_byidentityid("student_id", identity_id)
                sid = sid.value
                student_record = by_studentid_old(sid, att_date)
               
                if student_record && !att_date.nil?
                    att_code = "p-k12_logins"
                    current_value = student_record.fields["code"].value
                   
                    if current_value.nil?
                        new_value = att_code
                    elsif !current_value.include?(att_code)
                        new_value = "#{current_value},#{att_code}"
                    else
                        new_value = current_value
                    end
                   
                    student_record.fields["code"].value = new_value
                    student_record.save
                end
                
            end
            
        }
        #THE LEARNING COACH LOGGED IN
        login_table.primary_ids("WHERE role = '1000'").each{|pid|
            
            login_record    = login_table.by_primary_id(pid)
            att_date        = login_record.fields["last_login"].iso_date
            
            family_id       = login_record.fields["familyid"].value
            regkey          = login_record.fields["regkey"].value         
            sids            = $tables.attach("Student").students_with_records("WHERE (familyid = '#{family_id}' OR lcregistrationid REGEXP '#{regkey}')")
            
            sids.each{|sid|
                student_record = by_studentid_old(sid, att_date)
                
                if student_record && !att_date.nil?
                    att_code = "p-k12_logins - LC"
                    current_value = student_record.fields["code"].value
                    
                    if current_value.nil?
                        new_value = att_code
                    elsif !current_value.include?(att_code)
                        new_value = "#{current_value},#{att_code}"
                    else
                        new_value = current_value
                    end
                    
                    student_record.fields["code"].value = new_value
                    student_record.save
                end
            } if sids
            
        }
    end

    def after_load_k12_withdrawal
        
        sids = $tables.attach("k12_withdrawal").students_with_records
        sids.each{|sid|
            
            wd_effective_date = $tables.attach("k12_withdrawal").by_studentid_old(sid).fields["schoolwithdrawdate"].value
            records = $tables.attach("student_attendance").attendance_date(wd_effective_date, {:student_id=>sid,:operator=>">"})
            records.each{|record|
                record.fields["mode"].value = "Withdrawn"
                record.save
            } if records
            #MARK ALL SCHOOL DAYS AFTER THE WITHDRAW EFFECTIVE DATE AS NULL
            att_mast_record = $tables.attach("attendance_master").by_studentid_old(sid)
            if att_mast_record
                school_days = $school.school_days_after(wd_effective_date)
                if school_days
                    school_days.each{|date|
                        att_mast_record.fields[date].value = nil
                    }
                    att_mast_record.save
                end
            end
        }
        
    end
    
    def after_change_field_mode(field_obj)
        after_field_change(field_obj)
    end
    
    def after_change_field_code(field_obj)
        after_field_change(field_obj)
    end
    
    def after_field_change(field_obj)
        record = by_primary_id(field_obj.primary_id)
        require "#{$paths.system_path}data_processing/Attendance_Processing"
        Attendance_Processing.new(record.fields["student_id"].value, record.fields["date"].value)
    end
    
    def create_att_records(att_date = $idate) 
        if $field.is_schoolday?(att_date)
            $students.current_students.each do |sid|
                if !by_studentid_old(sid, att_date)
                    student         = $students.attach(sid)
                    mode            = $tables.attach("student_attendance_mode").current_mode_by_studentid(sid).value
                    sources         = $tables.attach("attendance_modes").sources_by_mode(mode)
                    attendance_row  = new_row
                    fields          = attendance_row.fields
                    fields["student_id" ].value = sid
                    fields["date"       ].value = att_date
                    fields["mode"       ].value = mode
                    fields["sources"    ].value = sources ? sources.value : sources
                    fields["complete"   ].value = false
                    attendance_row.save
                    $students.detach(sid)
                end
            end
        end
    end
    
    def after_insert(row_obj)
        record = by_primary_id(row_obj.primary_id)
        require "#{$paths.system_path}data_processing/Attendance_Processing"
        Attendance_Processing.new(record.fields["student_id"].value, record.fields["date"].value)
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