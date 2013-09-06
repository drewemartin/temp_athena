#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class ATTENDANCE_MASTER < Athena_Table
    
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

    def absences_by_studentid(studentid, cutoff_date)
        days = schooldays(cutoff_date)
        select_days = ""
        select_days = days.each{|day|
            select_days = select_days.empty? ? "'#{day}'" : "#{select_days},'#{day}'"
        }
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        results = get_data("SELECT #{select_days} FROM #{table_name} #{where_clause}")
        absences = Array.new
        results.each{|row|
            i = 0
            row.each{|field|
                absences.push(days[i]) if Integer(field) && field != "p"
                i += 1
            }
        }
        return absences
    end
    
    def unexcused_by_studentid(studentid, cutoff_date)
        days        = schooldays(cutoff_date)
        absences    = Array.new
        days.each{|day|
            results = $db.get_data_single(
                "SELECT '#{day}'
                FROM attendance_master
                WHERE `#{day}` IN (SELECT code FROM attendance_codes WHERE code_type = 'unexcused')
                AND student_id = '#{studentid}'"
            )
            absences.push(results[0]) if results
        }
        return absences
    end
    
    def attendance_codes(arg = nil)
        where_clause = "WHERE code_type = '#{arg}'" if arg
        select_sql =
            "SELECT code
            FROM attendance_codes
            #{where_clause}"
        $db.get_data_single(select_sql)
    end
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def schooldays(cutoff_date = nil, order_option = "ASC")
        cutoff_sql = cutoff_date ? "AND column_name <= '#{cutoff_date}'" : ""
        select_sql =
            "SELECT column_name
            FROM `columns`
            WHERE table_name = '#{table_name}'
            AND TABLE_SCHEMA = '#{$config.db_name}'
            AND column_name REGEXP '^20'
            #{cutoff_sql}
            ORDER BY column_name #{order_option}"
        $db.get_data_single(select_sql, "information_schema")
    end
    
    def schooldays_by_range(start_date, end_date, order_option = "ASC")
        select_sql =
            "SELECT column_name
            FROM `columns`
            WHERE table_schema = '#{$config.db_name}'
            AND table_name = '#{table_name}'
            AND column_name REGEXP '^20'
            AND column_name >= '#{start_date}'
            AND column_name <= '#{end_date}'
            ORDER BY column_name #{order_option}"

        $db.get_data_single(select_sql, "information_schema")
    end
    
    def schooldays_after(start_date)
        select_sql =
            "SELECT column_name
            FROM `columns`
            WHERE table_schema = '#{$config.db_name}'
            AND table_name = '#{table_name}'
            AND column_name REGEXP '^20'
            AND column_name > '#{start_date}'
            AND column_name <= '#{$school.current_school_year_end.value}'
            ORDER BY column_name ASC"

        $db.get_data_single(select_sql, "information_schema")
    end
    
    def selected_fields_by_studentid(student_id, fields_str)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id) )
        where_clause = $db.where_clause(params)
        record(where_clause, fields_str) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{table_name}") 
    end
    
    def x_school_day_ago(x)
        all_school_days = schooldays($base.today)
        i = 1
        while i < x
            all_school_days.slice!(-1)
            i += 1
        end
        return all_school_days.slice!(-1)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def create_att_master_records
        $students.current_students.each do |sid|
            if !by_studentid_old(sid)
                student = $students.attach(sid)
                student.new_row("Attendance_Master").save
                $students.detach(sid)
            end
        end
    end
    
    def add_new_students(current_students)
        students = students_with_records
        new_record = new_row()
        current_students.each do |student|
            if !students || !students.include?(student)
                new_record.clear
                new_record.fields["student_id"].value = student
                new_record.insert   
            end
        end
        batch_absent(current_students, today.iso_date)
    end
    
    def batch_absent(students, attendance_date, audit_trail = false) #accepts and array of studentids
        audit = audit_trail
        students.each{|studentid|
            row = by_studentid_old(studentid)
            row.fields[attendance_date].value = "a"
            row.save
        }
        audit = true
    end
    
    def batch_present(students, attendance_date, audit_trail = false) #accepts and array of studentids
        audit = audit_trail
        students.each{|studentid|
            row = by_studentid_old(studentid)
            row.fields[attendance_date].value = "p"
            row.save
        }
        audit = true
    end
    
    def pre_reqs
        ["School_Year_Detail","School_Calendar"]
    end
    
    def update_metrics_summary(sid)
        rate   = $students.attach(sid).attendance.rate
        record = $tables.attach("Metrics_Student_Summary_Current").by_studentid_old(sid)
        record.fields["attendance_rate"].value = rate
        record.save
    end
    
    def after_change_field(field_obj)
        record = by_primary_id(field_obj.primary_id)
        date = field_obj.field_name
        require "#{$paths.system_path}data_processing/Attendance_Processing"
        Attendance_Processing.new(record.fields["student_id"].value, date)
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "attendance_master",
                "file_name"         => "attendance_master.csv",
                "file_location"     => "attendance_master",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash) #This needs special instructions for init.
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_id"] = {"data_type"=>"int", "file_field"=>"student_id"} if field_order.push("student_id")
        if $tables.attach("School_Year_Detail").current
            sy_fields   = $tables.attach("School_Year_Detail").current.fields
            start_date  = sy_fields["start_date"]
            end_date    = sy_fields["end_date"]
            #end_date    = DateTime.now
            
            day         = start_date
            holidays    = $tables.attach("School_Calendar").holiday_dates
            loaded      = false
            until loaded
                is_weekday = day.mathable.strftime("%w") != '0' && day.mathable.strftime("%w") != '6'
                if is_weekday
                    is_schoolday = !holidays.index(day.to_db)
                    if is_schoolday
                        structure_hash["fields"][day.to_db] = {"data_type"=>"text", "file_field"=>day.to_db}    if field_order.push(day.to_db)
                    end
                end
                day.add!
                loaded = true if day.mathable > end_date.mathable
            end
        else
            structure_hash["fields"]["LOAD_SCHOOL_YEAR_DATA"] = {"data_type"=>"text", "file_field"=>"LOAD_SCHOOL_YEAR_DATA"} if field_order.push("LOAD_SCHOOL_YEAR_DATA")
        end
        structure_hash["field_order"] = field_order
        return structure_hash
    end
 
end