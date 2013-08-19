#!/usr/bin/env ruby
#!/usr/local/bin/ruby

class Enrollment_Reports

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
   
    def flag_duplicates(datee = nil)
        
        date_addon = datee ? " AND k12_enrollment_info_tab_v2.enrollreceiveddate = '#{datee}' " : ""
        
        location    = "Enrollment_Reports"
        filename    = "flag_duplicates"
        rows        = Array.new
        headers     = Array.new
     
        headers.push("student_id","firstname","lastname", "birthday","enrollreceiveddate","enrollapproveddate")
        
        sql_string =
            "SELECT
                k12_enrollment_info_tab_v2.student_id,
                k12_enrollment_info_tab_v2.firstname,
                k12_enrollment_info_tab_v2.lastname,
                k12_enrollment_info_tab_v2.birthday,
                k12_enrollment_info_tab_v2.enrollreceiveddate,
                k12_enrollment_info_tab_v2.enrollapproveddate
            FROM k12_enrollment_info_tab_v2
            JOIN K12_all_students ON CONCAT( k12_enrollment_info_tab_v2.firstname, k12_enrollment_info_tab_v2.lastname, k12_enrollment_info_tab_v2.birthday ) = CONCAT( K12_all_students.studentfirstname, K12_all_students.studentlastname, K12_all_students.birthday )
            WHERE k12_enrollment_info_tab_v2.student_id != K12_all_students.student_id
            #{date_addon}
            GROUP BY k12_enrollment_info_tab_v2.student_id"
        rows = $db.get_data(sql_string)
        
        if rows
            file_path = $reports.save_document({:csv_rows=>rows.insert(0,headers), :category_name=>"Enrollment", :type_name=>"Duplicated Students Report"})
            $reports.move_to_athena_reports_from_docs(file_path, location, filename, false)
            return file_path
        else
            return false
        end
        
    end

end

