#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_STUDENTS < Athena_Table
    
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
    
    def by_studentid_old(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def add_student(sid)
        if !by_studentid_old(sid)
            row = new_row
            row.fields["student_id" ].value = sid
            row.fields["active"     ].value = true
            row.save
        else
            return false
        end
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name}") 
    end
    
    def active_sids
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} WHERE active IS TRUE") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def sapphire_new_students(fields_to_select)
        k12_db = $tables.attach("k12_omnibus").data_base
        sql_statement =
            "SELECT
                #{fields_to_select}
            FROM #{k12_db}.k12_omnibus
            LEFT JOIN #{data_base}.sapphire_students on #{k12_db}.k12_omnibus.student_id = #{data_base}.sapphire_students.student_id
            LEFT JOIN #{k12_db}.k12_home_language on #{k12_db}.k12_omnibus.student_id = #{k12_db}.k12_home_language.student_id
            LEFT JOIN #{k12_db}.k12_enrollment_info_tab_v2 on #{k12_db}.k12_omnibus.student_id = #{k12_db}.k12_enrollment_info_tab_v2.student_id
            WHERE k12_omnibus.schoolenrolldate IS NOT NULL
            AND k12_omnibus.enrollapproveddate IS NOT NULL
            AND sapphire_students.student_id IS NULL"
        if fields_to_select.split(",").length > 1
            $db.get_data(sql_statement)
        else
            $db.get_data_single(sql_statement)
        end
    end
    
    def sapphire_returning_students(fields_to_select)
        k12_db = $tables.attach("k12_omnibus").data_base
        sql_statement =
            "SELECT
                #{fields_to_select}
            FROM #{k12_db}.k12_omnibus
            LEFT JOIN #{data_base}.sapphire_students on #{k12_db}.k12_omnibus.student_id = #{data_base}.sapphire_students.student_id
            LEFT JOIN #{k12_db}.k12_home_language on #{k12_db}.k12_omnibus.student_id = #{k12_db}.k12_home_language.student_id
            LEFT JOIN #{k12_db}.k12_enrollment_info_tab_v2 on #{k12_db}.k12_omnibus.student_id = #{k12_db}.k12_enrollment_info_tab_v2.student_id
            WHERE k12_omnibus.schoolenrolldate IS NOT NULL
            AND k12_omnibus.enrollapproveddate IS NOT NULL
            AND sapphire_students.student_id IS NOT NULL
            AND sapphire_students.active IS FALSE"
        if fields_to_select.split(",").length > 1
            $db.get_data(sql_statement)
        else
            $db.get_data_single(sql_statement)
        end
    end
    
    def after_load_k12_omnibus
        
        if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/)
            sapphire_update_new_students
            sapphire_update_returning_students
            invalid_districts_report
        end
        
    end
    
    def after_load_k12_withdrawal
        
        if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/)
            require "#{$paths.system_path}reports/sapphire_withdrawal_report.rb"
            sapphire_withdrawal_report = Sapphire_Withdrawal_Report.new
            sapphire_withdrawal_report.withdrawals_import   #IMPORTED BY SAPPHIRE
            sapphire_withdrawal_report.graduates_report     #REPORTED TO JOEL
        end
        
    end
    
    def sapphire_update_new_students
        ####################################################################
        #CHECK FOR NEW STUDENTS TO REPORT TO SAPPHIRE
        location    = "inbox"
        filename    = "new_students"
        
        fields_to_select = String.new
        headers          = Array.new   
        $tables.attach("K12_Omnibus").field_order.each{|field_name|
            
            headers.push(field_name)
            daun_db = $tables.attach("districts_aun").data_base
            case field_name
            when "districtid"
                select_str = "(SELECT aun FROM #{daun_db}.districts_aun WHERE K12_Omnibus.districtofresidence = districts_aun.name)"
                
            when /[^i]city/
                select_str = "IF(CHAR_LENGTH(#{field_name})<=20, #{field_name}, LEFT(#{field_name},20))"
                
            else
                select_str = "K12_Omnibus.#{field_name}"
            end
            
            fields_to_select = fields_to_select.empty? ? select_str : "#{fields_to_select},#{select_str}"
            
        }
        headers.push("k12_home_language_language")
        headers.push("k12_enrollment_info_tab_v2_homelangsurv")
        fields_to_select = fields_to_select.empty? ? "k12_home_language.language"   : "#{fields_to_select},k12_home_language.language"
        fields_to_select = fields_to_select.empty? ? "k12_enrollment_info_tab_v2.homelangsurv" : "#{fields_to_select},k12_enrollment_info_tab_v2.homelangsurv"
        
        student_array    = sapphire_new_students(fields_to_select)
        if student_array
            
            file_path       = $reports.csv(location, filename, student_array.insert(0, headers), timestamp = false)
            $reports.move_to_sapphire_inbox(file_path)
            
            File.delete(file_path)
            
            storage_location    = "Sapphire_Update/New_Students"
            
            storage_file_path = $reports.save_document({:csv_rows=>student_array, :category_name=>"Sapphire Imports", :type_name=>"Sapphire New Students"})
            $reports.move_to_athena_reports_from_docs(storage_file_path, storage_location, filename, false)
            
        end
        
        new_student_ids = sapphire_new_students("k12_omnibus.student_id")
        new_student_ids.each{|sid|
            $tables.attach("SAPPHIRE_STUDENTS").add_student(sid)
        } if new_student_ids
        ####################################################################
    end
    
    def sapphire_update_returning_students
        ####################################################################
        #CHECK FOR RETURNING STUDENTS TO REPORT TO (to be decided)
        location    = "Sapphire_Update/Returning_Students"
        filename    = "returning_students"
        
        fields_to_select = String.new
        headers          = Array.new   
        $tables.attach("K12_Omnibus").field_order.each{|field_name|
            headers.push(field_name)
            fields_to_select = fields_to_select.empty? ? "K12_Omnibus.#{field_name}" : "#{fields_to_select},K12_Omnibus.#{field_name}"
        }
        headers.push("k12_home_language_language")
        headers.push("k12_enrollment_info_tab_v2_homelangsurv")
        fields_to_select = fields_to_select.empty? ? "k12_home_language.language"   : "#{fields_to_select},k12_home_language.language"
        fields_to_select = fields_to_select.empty? ? "k12_enrollment_info_tab_v2.homelangsurv" : "#{fields_to_select},k12_enrollment_info_tab_v2.homelangsurv"
        
        student_array    = sapphire_returning_students(fields_to_select)
        if student_array
            file_path       = $reports.save_document({:csv_rows=>student_array.insert(0, headers), :category_name=>"Sapphire Reports", :type_name=>"Sapphire Returning Students"})
            #name_holder     = file_path.split("/")[-1]
            #temp_name       = file_path.gsub(name_holder, "new_students.csv")
            
            #File.rename(file_path, temp_name) 
            #$reports.move_to_sapphire_inbox(file_path)
            
            returning_student_ids = sapphire_returning_students("k12_omnibus.student_id")
            returning_student_ids.each{|sid|
                record = $tables.attach("SAPPHIRE_STUDENTS").by_studentid_old(sid)
                record.fields["active"].value = true
                record.save
            }
            
            #File.rename(temp_name, file_path)
            #$reports.move_to_athena_reports(file_path)
            $base.email.athena_smtp_email(
                ["jgowman@agora.org","jhalverson@agora.org","SMcDonnell@agora.org"],
                "Sapphire Returning Students",
                "Please find the attached report",
                file_path,
                nil,
                "returning_students_#{$ifilestamp}.csv"
            )
            
        end
        ####################################################################
    end
    
    def invalid_districts_report
        
        location    = "Sapphire_Update/Invalid_Districts"
        filename    = "invalid_districts"
        
        headers     = ["Student ID","District Of Residence","Phone","Legal Guardian"]
        s_db = $tables.attach("student").data_base
        daun_db = $tables.attach("districts_aun").data_base
        rows = $db.get_data(
            
            "SELECT
                student.student_id,
                student.districtofresidence,
                student.studenthomephone,
                CONCAT(student.lgfirstname,' ',student.lglastname)
            FROM #{s_db}.student
            LEFT JOIN #{daun_db}.districts_aun ON #{daun_db}.districts_aun.name = #{s_db}.student.districtofresidence
            WHERE districts_aun.primary_id IS NULL
            AND student.active IS TRUE"
            
        )
        
        if rows
            
            file_path = $reports.save_document({:csv_rows=>rows.insert(0, headers), :category_name=>"Sapphire Reports", :type_name=>"Invalid Districts Report"})
            
            $base.email.athena_smtp_email(["jgowman@agora.org","jhalverson@agora.org"], "Student with Invalid District of Residence", "Please find the attached report", file_path, nil, "#{filename}_#{$ifilestamp}.csv")
            
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "sapphire_students",
                "file_name"         => "sapphire_students.csv",
                "file_location"     => "sapphire_students",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]  = {"data_type"=>"int", "file_field"=>"student_id"} if field_order.push("student_id")
            structure_hash["fields"]["active"]      = {"data_type"=>"bool", "file_field"=>"active"} if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end