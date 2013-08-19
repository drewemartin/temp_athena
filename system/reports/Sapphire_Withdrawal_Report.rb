#!/usr/local/bin/ruby

class Sapphire_Withdrawal_Report

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
   
    def withdrawals_import
        
        location    = "inbox"
        filename    = "withdrawn_students"
        rows        = Array.new
        headers     = Array.new
     
        headers.push("STUDENT_ID","WITHDRAWDATE","WITHDRAWCODE","SCHOOL_YEAR")
        sql_string =  
            "SELECT
                sapphire_students.student_id,
                IFNULL(k12_withdrawal.schoolwithdrawdate,k12_withdrawal.withdrawdate),
                IFNULL(k12_withdrawal.transferring_to,LEFT(k12_withdrawal.withdrawreason,2)),
                #{$school.current_school_year_end.mathable.strftime("%Y")}
            FROM sapphire_students
            LEFT JOIN k12_withdrawal ON k12_withdrawal.student_ID = sapphire_students.student_id
            WHERE sapphire_students.active IS TRUE
            AND k12_withdrawal.student_ID IS NOT NULL
            AND k12_withdrawal.transferring_to != '1'"
        rows = $db.get_data(sql_string)
        
        if rows
            
            rows.each{|row|
                sid = row[0]
                sapp_record = $tables.attach("sapphire_students").by_studentid_old(sid)
                sapp_record.fields["active"].value = false
                sapp_record.save
            }
            
            rows = rows.insert(0,headers)
            
            file_path = $reports.csv(location, filename, rows, timestamp = false)
            $reports.move_to_sapphire_inbox(file_path)
            File.delete(file_path)
            
            storage_location    = "Sapphire_Update/Withdrawn_Students"
            storage_file_path   = $reports.save_document({:csv_rows=>rows, :category_name=>"Sapphire Imports", :type_name=>"Sapphire Withdrawn Students"})
            $reports.move_to_athena_reports_from_docs(storage_file_path, storage_location, filename, false)
            
            return storage_file_path
            
        else
            return false
        end
        
    end

    def graduates_report
        
        rows        = Array.new
        headers     = Array.new
     
        headers.push("STUDENT_ID","WITHDRAWDATE","WITHDRAWCODE","SCHOOL_YEAR")
        sql_string =  
            "SELECT
                sapphire_students.student_id,
                IFNULL(k12_withdrawal.schoolwithdrawdate,k12_withdrawal.withdrawdate),
                IFNULL(k12_withdrawal.transferring_to,LEFT(k12_withdrawal.withdrawreason,2)),
                #{$school.current_school_year_end.mathable.strftime("%Y")}
            FROM sapphire_students
            LEFT JOIN k12_withdrawal ON k12_withdrawal.student_ID = sapphire_students.student_id
            WHERE sapphire_students.active IS TRUE
            AND k12_withdrawal.student_ID IS NOT NULL
            AND k12_withdrawal.transferring_to = '1'"
        rows = $db.get_data(sql_string)
        
        if rows
            
            rows.each{|row|
                sid = row[0]
                sapp_record = $tables.attach("sapphire_students").by_studentid_old(sid)
                sapp_record.fields["active"].value = false
                sapp_record.save
            }
            
            rows = rows.insert(0,headers)
            
            storage_location    = "Sapphire_Update/Graduated_Students"
            storage_file_path   = $reports.save_document({:csv_rows=>rows, :category_name=>"Sapphire Reports", :type_name=>"Sapphire Graduated Students"})
            
            $team.find(:full_name=>"Joel Gowman").send_email(
                :subject               => "Sapphire - Graduated Students",        
                :content               => "Please find the attached list of students to be marked as graduated in the Sapphire System.",         
                :sender                => nil,
                :additional_recipients => ["Jenifer Halverson"],
                :attachment_name       => "sapphire_graduated_students_#{$ifilestamp}.csv",  
                :attachment_path       => storage_file_path
            )
            
            return storage_file_path
            
        else
            return false
        end
        
    end
    
end
