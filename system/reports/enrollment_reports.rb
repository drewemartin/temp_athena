#!/usr/bin/env ruby
#!/usr/local/bin/ruby

class Enrollment_Reports

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
   
    def flag_duplicates(datee = nil)
        
        date_addon = datee ? " AND enrollreceiveddate = '#{datee}' " : ""
        
        location    = "Enrollment_Reports"
        filename    = "flag_duplicates"
        rows        = Array.new
        headers     = [
            "student_id",
            "firstname",
            "lastname",
            "birthday",
            "enrollreceiveddate",
            "enrollapproveddate"
        ]
        
        k12_db = $tables.attach("k12_all_students").data_base
        
        $db.query(
            "CREATE TABLE IF NOT EXISTS #{k12_db}.x_k12_eitr_concat AS(
                SELECT
                    primary_id,
                    student_id,
                    CONCAT(firstname, lastname, birthday) AS concat
                FROM #{k12_db}.k12_enrollment_info_tab_v2
            )","agora_k12"
        )
        $db.query("ALTER TABLE #{k12_db}.x_k12_eitr_concat ENGINE = MYISAM")
        $db.query("ALTER TABLE #{k12_db}.x_k12_eitr_concat ADD INDEX (`primary_id`)")
        $db.query("ALTER TABLE #{k12_db}.x_k12_eitr_concat ADD INDEX (`student_id`)")
        $db.query("ALTER TABLE #{k12_db}.x_k12_eitr_concat ADD FULLTEXT (`concat`)")
        
        $db.query(
            "CREATE TABLE IF NOT EXISTS #{k12_db}.x_k12_all_students_concat AS (
                SELECT
                    primary_id,
                    student_id,
                    CONCAT(studentfirstname, studentlastname, birthday) AS concat
                FROM #{k12_db}.k12_all_students
            )","agora_k12"
        )
        
        $db.query("ALTER TABLE #{k12_db}.x_k12_all_students_concat ENGINE = MYISAM")
        $db.query("ALTER TABLE #{k12_db}.x_k12_all_students_concat ADD INDEX (`primary_id`)")
        $db.query("ALTER TABLE #{k12_db}.x_k12_all_students_concat ADD INDEX (`student_id`)")
        $db.query("ALTER TABLE #{k12_db}.x_k12_all_students_concat ADD FULLTEXT (`concat`)")
        
        sql_string_3 =
            "SELECT
                x_k12_eitr_concat.primary_id
            FROM #{k12_db}.x_k12_eitr_concat
            LEFT JOIN #{k12_db}.x_k12_all_students_concat
            ON x_k12_eitr_concat.concat = x_k12_all_students_concat.concat
            WHERE x_k12_eitr_concat.student_id != x_k12_all_students_concat.student_id
            GROUP BY x_k12_eitr_concat.student_id
        "
        
        pids = $db.get_data(sql_string_3)
        
        sql_string_4 =
            "SELECT
                student_id,
                firstname,
                lastname,
                birthday,
                enrollreceiveddate,
                enrollapproveddate
            FROM #{k12_db}.k12_enrollment_info_tab_v2
            WHERE primary_id IN (#{pids.join(',')})
            #{date_addon}"
        
        rows = pids ? $db.get_data(sql_string_4):[]
        
        $db.query("DROP TABLE IF EXISTS #{k12_db}.x_k12_eitr_concat,#{k12_db}.x_k12_all_students_concat")
        
        file_path = $reports.save_document({:csv_rows=>rows.insert(0,headers), :category_name=>"Enrollment", :type_name=>"duplicated_students_report"})
        $reports.move_to_athena_reports_from_docs(file_path, location, filename, false)
        return file_path
        
    end

end

