#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Upload_Documents < Base
    
    def initialize()
        
        super()
        upload_attendance_master               #ok
        upload_enrollment_reports              #ok
        upload_ink_orders                      #ok
        upload_ink_id_requests                 #ok
        upload_login_reminders                 #ok
        upload_sapphire_new_students           #ok
        upload_sapphire_returning_students     #ok
        upload_sapphire_invalid_districts      #ok
        upload_sapphire_withdrawn_students     #ok
        upload_scantron_participation_overall  #ok 
        upload_sid_to_pid                      #ok
        upload_snap_update                     #ok
        upload_team_evaluations                #ok
        upload_tep_documents                   #ok
        upload_truancy_withdrawal              #ok
        upload_withdrawal_student_documents    #ok
        upload_withdrawal_to_registrar         #ok
        upload_withdrawal_to_districts         #ok
        upload_k12_reports
        
    end
    
    def upload_attendance_master
        
        file_loop("Attendance_Master", "Attendance Master", "Attendance", skip_folders=[], exclusive_filetype=".csv")
        
    end
    
    def upload_enrollment_reports
        
        file_loop("Enrollment_Reports", "Duplicated Students Report", "Enrollment")
        
    end
    
    def upload_ink_orders
        
        file_loop("ink_orders", "Ink Orders", "Supplies", ["Staples_Id_Requests", "Staples_Id_Requests_Alt"])
        
    end
    
    def upload_ink_id_requests
        
        file_loop("ink_orders/Staples_Id_Requests_Alt", "Ink ID Requests", "Supplies")
        
    end
    
    def upload_login_reminders
        
        file_loop("Login_Reminders", "Login Reminders Report", "Attendance")
        
    end
    
    def upload_sapphire_new_students
        
        file_loop("Sapphire_Update/New_Students", "Sapphire New Students", "Sapphire Imports", ["Sapphire_Update"])
        
    end
    
    def upload_sapphire_returning_students
        
        file_loop("Sapphire_Update/Returning_Students", "Sapphire Returning Students", "Sapphire Reports", ["Sapphire_Update"])
        
    end


    def upload_sapphire_invalid_districts
        
        file_loop("Sapphire_Update/Invalid_Districts", "Invalid Districts Report", "Sapphire Reports")
        
    end
    
    def upload_sapphire_withdrawn_students
        
        file_loop("Sapphire_Update/Withdrawn_Students", "Sapphire Withdrawn Students", "Sapphire Imports")
        
    end
    
    def upload_scantron_participation_overall
        
        file_loop("Scantron/Participation_Notifications/Overall", "Scantron Participation Completion Overall Report", "Scantron")
        
    end 
    
    def upload_sid_to_pid
        
        file_loop("converted_sid_to_pid_csv", "Converted SID To PID CSV", "Athena")
        
    end
    
    def upload_snap_update
        
        rootpath = "#{$paths.reports_path}Snap_Update"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                
                if entry.include?("Students")
                    
                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Nursing'").value
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Snap Students Update' AND category_id='#{category_id}'").value
                    
                    time_stamp   = entry.split("_").last.split(".").first
                    new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                    
                    if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                        
                        #add to user_documents_table to get pid
                        new_row = $tables.attach("documents").new_row
                        fields = new_row.fields
                        fields["school_year"].value = $school.current_school_year.value
                        fields["category_id"].value = category_id
                        fields["type_id"].value     = type_id
                        new_row_pid = new_row.save
                        
                    else
                        
                        next
                        
                    end
                    
                elsif entry.include?("Caregivers")
                    
                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Nursing'").value
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Snap Caregivers Update' AND category_id='#{category_id}'").value
                    
                    time_stamp   = entry.split("_").last.split(".").first
                    new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                    
                    if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                        
                        #add to user_documents_table to get pid
                        new_row = $tables.attach("documents").new_row
                        fields = new_row.fields
                        fields["school_year"].value = $school.current_school_year.value
                        fields["category_id"].value = category_id
                        fields["type_id"].value     = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Snap Caregivers Update' AND category_id='#{category_id}'").value
                        new_row_pid = new_row.save
                        
                    else
                        
                        next
                        
                    end
                    
                else
                    
                    next
                    
                end
                
                #copy file to user_documents folder
                file_path   = "#{rootpath}/#{entry}"
                ext         = entry.split(".").last
                new_path    = "#{$paths.documents_path}#{new_row_pid}.#{ext}"
                
                FileUtils.cp(file_path,new_path)
                
            end
        } if File.exists?(rootpath)
        
    end
    
    def upload_team_evaluations
        
        rootpath = $paths.htdocs_path + "Team_Member_Records"
        docs_path = $paths.documents_path
        documents_table = $tables.attach("DOCUMENTS")
        document_relate_table = $tables.attach("DOCUMENT_RELATE")
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                tid = File.basename(entry).delete("TeamID_")
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if File.directory?(newpath = "#{rootpath}/#{entry}/SY_2012-2013/Evaluations")
                    Dir.chdir("#{newpath}")
                    Dir.entries(newpath).each{|entry_file|
                        if !entry_file.gsub(/\.|rb/,"").empty?
                            
                            category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Team Member Evaluations'").value
                            type_id =     $tables.attach("document_type").find_field("primary_id", "WHERE name='Evaluation' AND category_id='#{category_id}'").value
                            
                            time_stamp   = entry_file.split("_").last.split(".").first
                            new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                            
                            if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                                
                                name = File.basename(entry_file)
                                
                                new_doc_row = documents_table.new_row
                                new_doc_row.fields["category_id"].value = category_id
                                new_doc_row.fields["type_id"].value     = type_id
                                new_doc_row.fields["school_year"].value = "2012-2013"
                                new_doc_pid = new_doc_row.save
                                
                                new_relate_row = document_relate_table.new_row
                                new_relate_row.fields["document_id"].value     = new_doc_pid
                                new_relate_row.fields["table_name"].value      = "TEAM"
                                new_relate_row.fields["key_field"].value       = "primary_id"
                                new_relate_row.fields["key_field_value"].value = tid
                                new_relate_row.save
                                
                                ext = name.split(".").last
                                new_name = "#{new_doc_pid}.#{ext}"
                                FileUtils.cp("#{newpath}/#{name}", "#{docs_path}#{new_name}")
                                
                            else
                                
                                next
                                
                            end
                            
                        end
                    }
                end
            end
        } if File.exists?(rootpath)
    end
    
    def upload_tep_documents
        
        rootpath = $paths.htdocs_path + "Student_Records"
        docs_path = $paths.documents_path
        documents_table = $tables.attach("DOCUMENTS")
        document_relate_table = $tables.attach("DOCUMENT_RELATE")
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty? 
                sid = File.basename(entry).delete("StudentID_")
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if File.directory?(newpath = "#{rootpath}/#{entry}/SY_2012-2013/TEP")
                    Dir.chdir("#{newpath}")
                    Dir.entries(newpath).each{|entry_file|
                        if !entry_file.gsub(/\.|rb/,"").empty?
                            
                            category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Truancy'").value
                            type_id     = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Truancy Elimination Plan' AND category_id='#{category_id}'").value
                            
                            time_stamp   = entry_file.split("_").last.split(".").first
                            new_created_date = set_created_date(time_stamp) if time_stamp[0,2] == "D2"
                            
                            if time_stamp[0,2] == "D2" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                                
                                name = File.basename(entry_file)
                                
                                new_doc_row = documents_table.new_row
                                new_doc_row.fields["category_id"].value = category_id
                                new_doc_row.fields["type_id"].value     = type_id
                                new_doc_row.fields["school_year"].value = "2012-2013"
                                new_doc_pid = new_doc_row.save
                                
                                new_relate_row = document_relate_table.new_row
                                new_relate_row.fields["document_id"].value     = new_doc_pid
                                new_relate_row.fields["table_name"].value      = "STUDENT"
                                new_relate_row.fields["key_field"].value       = "student_id"
                                new_relate_row.fields["key_field_value"].value = sid
                                new_relate_row.save
                                
                                ext = name.split(".").last
                                new_name = "#{new_doc_pid}.#{ext}"
                                FileUtils.cp("#{newpath}/#{name}", "#{docs_path}#{new_name}")
                                
                            else
                                
                                next
                                
                            end
                        end
                    }
                end
            end
        } if File.exists?(rootpath)
    end
    
    def upload_truancy_withdrawal
        
        file_loop("Truancy_Withdrawal", "Truancy Withdrawal Report", "Truancy", skip_folders=[], exclusive_filetype=".csv")
        
    end
    
    def upload_withdrawal_student_documents
        
        rootpath = $paths.htdocs_path + "Student_Records"
        docs_path = $paths.documents_path
        documents_table = $tables.attach("DOCUMENTS")
        document_relate_table = $tables.attach("DOCUMENT_RELATE")
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty? 
                sid = File.basename(entry).delete("StudentID_")
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if File.directory?(newpath = "#{rootpath}/#{entry}/SY_2012-2013/Withdrawal")
                    Dir.chdir("#{newpath}")
                    Dir.entries(newpath).each{|entry_folder|
                        if !entry_folder.gsub(/\.|rb/,"").empty?
                            wd_pid = File.basename(entry_folder).delete("WD_Request_")
                            Dir.entries(entry_folder).each{|entry_file|
                                if !entry_file.gsub(/\.|rb/,"").empty?
                                    
                                    name = File.basename(entry_file)
                                    
                                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Withdrawals'").value
                                    if entry_file.include?("districtnotify")
                                        type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='District Withdrawal Notification' AND category_id='#{category_id}'").value
                                    elsif entry_file.include?("final_grades")
                                        type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Final Grades' AND category_id='#{category_id}'").value
                                    else
                                        next
                                    end
                                    
                                    timestamp = File.ctime("#{newpath}/#{entry_folder}/#{entry_file}")
                                    new_created_date   = timestamp.strftime("%Y-%m-%d %H:%M:%S")
                                    $base.created_date = new_created_date
                                    
                                    if !$tables.attach("documents").document_pids(type_id, "STUDENT", "student_id", sid, new_created_date)
                                        
                                        new_row = documents_table.new_row
                                        fields = new_row.fields
                                        fields["category_id"].value = category_id
                                        fields["type_id"].value     = type_id
                                        fields["school_year"].value = "2012-2013"
                                        pid = new_row.save
                                        
                                        new_relate_row = document_relate_table.new_row
                                        new_relate_row.fields["document_id"].value     = pid
                                        new_relate_row.fields["table_name"].value      = "STUDENT"
                                        new_relate_row.fields["key_field"].value       = "student_id"
                                        new_relate_row.fields["key_field_value"].value = sid
                                        new_relate_row.save
                                        
                                        new_relate_row = document_relate_table.new_row
                                        new_relate_row.fields["document_id"].value     = pid
                                        new_relate_row.fields["table_name"].value      = "WITHDRAWING"
                                        new_relate_row.fields["key_field"].value       = "primary_id"
                                        new_relate_row.fields["key_field_value"].value = wd_pid
                                        new_relate_row.save
                                        
                                        ext = name.split(".").last
                                        new_name = "#{pid}.#{ext}"
                                        FileUtils.cp("#{newpath}/#{entry_folder}/#{name}", "#{docs_path}#{new_name}")
                                        
                                    else
                                        
                                        next
                                        
                                    end
                                    
                                end
                            }
                        end
                    }
                end
            end
        } if File.exists?(rootpath)
    end

    def upload_withdrawal_to_registrar
        
        rootpath = "#{$paths.reports_path}Withdrawals/District_Notification/To_Registrar"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                
                if entry.include?("all_districts")
                    
                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Withdrawals'").value
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='District Withdrawal Notification - Complete'  AND category_id='#{category_id}'").value
                    
                    time_stamp   = entry.split("_").last.split(".").first
                    new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                    
                    if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                        
                        #add to user_documents_table to get pid
                        
                        new_row = $tables.attach("documents").new_row
                        fields = new_row.fields
                        fields["school_year"].value = $school.current_school_year.value
                        fields["category_id"].value = category_id
                        fields["type_id"].value     = type_id
                        new_row_pid = new_row.save
                        
                    else
                        
                        next
                        
                    end
                    
                elsif entry.include?("districts_not_found")
                    
                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Withdrawals'").value
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Missing District Contact Information' AND category_id='#{category_id}'").value
                    
                    time_stamp   = entry.split("_").last.split(".").first
                    new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                    
                    if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                        
                        #add to user_documents_table to get pid
                        
                        new_row = $tables.attach("documents").new_row
                        fields = new_row.fields
                        fields["school_year"].value = $school.current_school_year.value
                        fields["category_id"].value = category_id
                        fields["type_id"].value     = type_id
                        new_row_pid = new_row.save
                        
                    else
                        
                        next
                        
                    end
                    
                else
                    
                    next
                    
                end
                
                #copy file to user_documents folder
                file_path   = "#{rootpath}/#{entry}"
                ext         = entry.split(".").last
                new_path    = "#{$paths.documents_path}#{new_row_pid}.#{ext}"
                
                FileUtils.cp(file_path,new_path)
                
            end
            
        } if File.exists?(rootpath)
        
    end
    
    def upload_withdrawal_to_districts
        districts_aun_table = $tables.attach("districts_aun")
        rootpath = "#{$paths.reports_path}Withdrawals/District_Notification/To_Districts"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                Dir.entries(rootpath+"/"+entry).each{|sub_entry|
                    if !sub_entry.gsub(/\.|rb/,"").empty?
                        
                        category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Withdrawals'").value
                        type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='District Withdrawal Notification - By District' AND category_id='#{category_id}'").value
                        
                        time_stamp   = sub_entry.split("_").last.split(".").first
                        new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                        
                        if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                            
                            district_name = sub_entry.split("_").first
                            did = districts_aun_table.find_field("aun", "WHERE name='#{district_name.gsub("  "," ")}'").value
                            #add to user_documents_table to get pid
                            
                            new_row = $tables.attach("documents").new_row
                            fields = new_row.fields
                            fields["school_year"].value = $school.current_school_year.value
                            fields["category_id"].value = category_id
                            fields["type_id"].value     = type_id
                            new_row_pid = new_row.save
                            
                            new_relate_row = $tables.attach("document_relate").new_row
                            new_relate_row.fields["document_id"].value     = new_row_pid
                            new_relate_row.fields["table_name"].value      = "DISTRICTS_AUN"
                            new_relate_row.fields["key_field"].value       = "aun"
                            new_relate_row.fields["key_field_value"].value = did
                            new_relate_row.save
                            
                            #copy file to user_documents folder
                            file_path   = "#{rootpath}/#{entry}/#{sub_entry}"
                            ext         = sub_entry.split(".").last
                            new_path    = "#{$paths.documents_path}#{new_row_pid}.#{ext}"
                            
                            FileUtils.cp(file_path,new_path)
                            
                        else
                            
                            next
                            
                        end
                        
                    end
                }
            end
        } if File.exists?(rootpath)
    end
    
    def upload_k12_reports
        
        rootpath = "#{$paths.reports_path}k12_reports"
        Dir.entries(rootpath).each{|report_folder|
            if !report_folder.gsub(/\.|rb/,"").empty?
                if $reports.name_replacements.has_key?(report_folder)
                    category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='K12 Reports'").value
                    type_name = $reports.name_replacements[report_folder]
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='#{type_name}' AND category_id='#{category_id}'").value
                    Dir.entries(rootpath+"/"+report_folder).each{|file|
                        if !file.gsub(/\.|rb/,"").empty? #&& file.include?(".csv")
                            time_stamp   = file.split(/_(?!PROGRESS)/).last.split(".").first
                            new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                            if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                                #add to user_documents_table to get pid
                                
                                new_row = $tables.attach("documents").new_row
                                fields = new_row.fields
                                fields["school_year"].value = $school.current_school_year.value
                                fields["category_id"].value = category_id
                                fields["type_id"].value     = type_id
                                new_row_pid = new_row.save
                                
                                #copy file to user_documents folder
                                file_path   = "#{rootpath+"/"+report_folder}/#{file}"
                                ext         = file.split(".").last
                                new_path    = "#{$paths.documents_path}#{new_row_pid}.#{ext}"
                                
                                FileUtils.cp(file_path,new_path)
                            else
                                next
                            end
                        end
                    }
                end
            end
        } if File.exists?(rootpath)
        
    end
    
    def file_loop(reports_sub_dir, type_name, category_name, skip_folders=[], exclusive_filetype = nil)
        
        rootpath = "#{$paths.reports_path}#{reports_sub_dir}"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                next if skip_folders.include?(entry)
                next if exclusive_filetype && !entry.include?(exclusive_filetype)
                
                category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='#{category_name}'").value
                type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='#{type_name}' AND category_id='#{category_id}'").value
                
                time_stamp   = entry.split("_").last.split(".").first
                new_created_date = set_created_date(time_stamp) if time_stamp[0,1] == "D"
                
                if time_stamp[0,1] == "D" && !$tables.attach("documents").document_exists_by_time(type_id, new_created_date)
                    
                    #add to user_documents_table to get pid
                    
                    new_row = $tables.attach("documents").new_row
                    fields = new_row.fields
                    fields["school_year"].value = $school.current_school_year.value
                    fields["category_id"].value = category_id
                    fields["type_id"].value     = type_id
                    new_row_pid = new_row.save
                    
                    #copy file to user_documents folder
                    file_path   = "#{rootpath}/#{entry}"
                    ext         = entry.split(".").last
                    new_path    = "#{$paths.documents_path}#{new_row_pid}.#{ext}"
                    
                    FileUtils.cp(file_path,new_path)
                    
                else
                    
                    next
                    
                end
                
            end
        } if File.exists?(rootpath)
        
    end
    
    def set_created_date(timestamp)
        
        yy = timestamp.slice(1,4)
        mo = timestamp.slice(5,2)
        dd = timestamp.slice(7,2)
        hh = timestamp.slice(10,2)
        mi = timestamp.slice(12,2)
        ss = timestamp.slice(14,2)
        
        date_time = "#{yy}-#{mo}-#{dd} #{hh}:#{mi}:#{ss}"
        
        $base.created_date    = date_time
        
        return date_time
        
    end
    
end

Upload_Documents.new()