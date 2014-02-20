#!/usr/local/bin/ruby

class Reports

    #---------------------------------------------------------------------------
    def initialize()
        @structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def csv(location, filename, rows, filestamp = true)
        
        if location
            if location == "temp"
                path = $paths.temp_path
            else
                path = $config.init_path("#{$paths.reports_path}#{location}")
            end
        else
            path = $paths.documents_path
        end
        
        
        this_filename = filestamp ? "#{path}#{filename}_#{$ifilestamp}.csv" : "#{path}#{filename}.csv"
        file = File.open( this_filename, 'w' )
        header = nil
        rows = CSV.parse(rows) if rows.is_a?(String)
        rows.each{|row|
            value = nil
            if row.class == Array
                row.each{|r|
                    r_value = r ? r.gsub('"','""') : nil
                    value = (value.nil? ? "\"#{r_value}\"" : "#{value},\"#{r_value}\"")
                }
            elsif row.class == Hash
                if !header
                    row_header = nil
                    if row[:column_order]
                        file.puts row[:column_order].join(",")
                    else
                        row.each_key{|k|
                            k_value = k ? k.gsub('"','""') : nil
                            row_header = (row_header.nil? ? "\"#{k_value}\"" : "#{row_header},\"#{k_value}\"")
                        }
                        file.puts row_header
                    end
                    header = true
                end
                if row[:column_order]
                    row[:column_order].each{|column|
                        value = (value.nil? ? "\"#{row[column]}\"" : "#{value},\"#{row[column]}\"")
                    }
                else
                    row.each_value{|v|
                        v_value = v ? v.gsub('"','""') : nil
                        value = (value.nil? ? "\"#{v_value}\"" : "#{value},\"#{v_value}\"")
                    }
                end
            elsif row.class == Row
                if !header
                    file.puts row.header_string
                    header = true
                end
                value = row.string
            else
                value = row
            end
            
            file.puts value
        }
        file.close
        return file.path
    end
    
    def save_document(document_hash) #:category_name, :type_name, :csv_rows, :file_path
        
        new_row = $tables.attach("documents").new_row
        
        category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='#{document_hash[:category_name]}'").value
        
        fields = new_row.fields
        fields["school_year"].value = $school.current_school_year
        fields["category_id"].value = category_id
        fields["type_id"].value     = $tables.attach("document_type").find_field("primary_id",  "WHERE name='#{document_hash[:type_name]}' AND category_id='#{category_id}'").value
        
        new_document_pid = new_row.save
        
        if document_hash[:document_relate]
            
            document_hash[:document_relate].each do |document_relate_hash|
                
               new_relate_row = $tables.attach("document_relate").new_row
               
               fields = new_relate_row.fields
               fields["document_id"].value     = new_document_pid
               fields["table_name"].value      = document_relate_hash[:table_name]
               fields["key_field"].value       = document_relate_hash[:key_field]
               fields["key_field_value"].value = document_relate_hash[:key_field_value]
               new_relate_row.save
                
            end
            
        end
        
        begin
            
            if document_hash[:csv_rows]
                
                if !File.exists?("#{$paths.documents_path}#{new_document_pid}.csv")
                    
                    return csv(nil, new_document_pid, document_hash[:csv_rows], false)
                    
                else
                    
                    file_path = "#{csv(nil, "#{new_document_pid}_#{$ifilestamp}", document_hash[:csv_rows], false)}.csv"
                    
                    raise
                    
                end
                
            elsif document_hash[:pdf]
                
                if !File.exists?("#{$paths.documents_path}#{new_document_pid}.pdf")
                    
                    pdf = document_hash[:pdf].render_file("#{$paths.documents_path}#{new_document_pid}.pdf")
                    
                    return pdf.path
                    
                else
                    
                    pdf = document_hash[:pdf].render_file("#{$paths.documents_path}#{new_document_pid}_#{$ifilestamp}.pdf")
                    
                    file_path = pdf.path
                    
                    raise
                    
                end
                
            elsif document_hash[:pdf_template]
                
                if !File.exists?("#{$paths.documents_path}#{new_document_pid}.pdf")
                    
                    pdf = Prawn::Document.generate "#{$paths.documents_path}#{new_document_pid}.pdf" do |pdf|
                            require "#{$paths.templates_path}pdf_templates/#{document_hash[:pdf_template]}"
                            template = eval("#{document_hash[:pdf_template].gsub(".rb","")}.new")
                            template.generate_pdf(document_hash[:pdf_id], pdf)
                    end
                    
                    return pdf.path
                    
                else
                    
                    pdf = Prawn::Document.generate "#{$paths.documents_path}#{new_document_pid}_#{$ifilestamp}.pdf" do |pdf|
                            require "#{$paths.templates_path}pdf_templates/#{document_hash[:pdf_template]}"
                            template = eval("#{document_hash[:pdf_template].gsub(".rb","")}.new")
                            template.generate_pdf(document_hash[:pdf_id], pdf)
                    end
                    
                    file_path = pdf.path
                    ext = "pdf"
                    
                    raise
                    
                end
                
            elsif document_hash[:file_path]
                
                file_path   = document_hash[:file_path]
                ext         = file_path.split(".").last
                new_path    = "#{$paths.documents_path}#{new_document_pid}.#{ext}"
                
                if !File.exists?(new_path)
                    
                    FileUtils.cp(file_path,new_path)
                    
                else
                    
                    raise
                    
                end
                
            end
            
        rescue => e
            
            error_file_path = file_path ? "#{$paths.document_error_path}#{new_document_pid}_#{$ifilestamp}.#{ext}" : "~Not saved, because process was aborted before file creation."
            
            FileUtils.cp(file_path,error_file_path) if file_path
            
            $base.system_notification(
                "FILE AT DOCUMENT PID:#{new_document_pid} ALREADY EXISTS",
                "FILE SAVED TO PATH: #{error_file_path}<br><br>
                PROCESS ABORTED<br><br>
                #{e.backtrace}",
                caller[0],
                e
            )
            
            raise
            
        end
        
    end
    
    def exists_in_sapphire_inbox?(file_name, ftp)
        ftp = login_sapphire_inbox if !ftp
        previous_export_exists = nil
        ftp.list.each{|file_details|
            previous_export_exists = true if file_details.match(/#{file_name}/)
        }
        ftp.close
        return previous_export_exists
    end
    
    def offsite_file_exists?(filepath)
        url = URI.parse(filepath)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)
        
        if res.code == "200" #If Link Exists
            return true
        else
            return false
        end
    end
    
    def move_to_athena_reports(file_path, putstext=true)
        
        new_file_path = file_path
        
        if putstext
            big = File.size(file_path) > 52400000
            new_file_path = big ? file_path : file_path.gsub(".csv","IN_PROGRESS.csv")
            File.rename(file_path, new_file_path) if !big
        end
        
        ftp = login_athena_reports
        transfer_offsite(new_file_path, ftp, false, putstext)
        
        File.rename(new_file_path, file_path)
        
        #Delete this file once this process is confirmed to work.
        #File.delete(file_path)
    end
    
    def move_to_athena_reports_from_docs(file_path, sub_directory, alt_file_name, putstext=true)
        
        reports_doc_path = $config.init_path("#{$paths.reports_path}#{sub_directory}")+"#{alt_file_name}_#{$ifilestamp}.#{file_path.split(".").last}"
        
        FileUtils.cp(file_path, reports_doc_path)
        
        move_to_athena_reports(reports_doc_path, putstext)
        
        File.delete(reports_doc_path)
        
    end
    
    def move_to_sapphire_inbox(file_path)
        ftp = login_sapphire_inbox
        transfer_offsite(file_path, ftp)
    end
    
    def move_to_snap_inbox(file_path, rename=false)
        ftp = login_snap_inbox
        transfer_offsite(file_path, ftp, rename)
    end
    
    def name_replacements
        
        replacements = {
            
            'agora_staffList' 		 			=> 'Staff List',
            'agora_aggregate_progress' 	 			=> 'Aggregate Progress',
            'agora_all_students'             			=> 'All Students',
            'agora_attendance_modified'	 			=> 'Attendance Modified',
            'agora_attendanceModified'	 			=> 'Attendance Modified',
            'agora_calms_aggregateProg'      			=> 'CALMS Aggregate Progress',	
            'agora_classlistteacherview_vhs' 			=> 'Class List Teacher View VHS',
            'agora_ECollegeActivityDuration'			=> 'ECollege Activity Duration',
            'agora_ecollege_detail'          			=> 'ECollege Detail',
            'agora_eitr_version2'            			=> 'EITR V2',
            'agora_elluminate_session'       			=> 'Elluminate Session',
            'agora_highschool_classroom'     			=> 'Highschool Classroom',
            'agora_home_language_report'     			=> 'Home Language',
            'agora_learning_coach_report'	 		=> 'Learning Coach Report',
            'agora_lessons_count_daily'	 			=> 'Lessons Count Daily',
            'agora_logins'                   			=> 'Logins',
            'agora_logins_afternoon'	 			=> 'Logins - Afternoon',
            'agora_omnibus'                  			=> 'Omnibus',
            'agora_pal_assessment_report'			=> 'Pal Assessment',
            'agora_select-MA-LALS-grade-levels-for-students'	=> 'Progress And Achievement',
            'agora_sti_combined_report'      			=> 'STI Combined Report',
            'agora_sti_intervention'         			=> 'STI Intervention',
            'agora_student_course_report'	 	        => 'Student Course',
            'agora_withdraw'                 			=> 'Withdraw',
            'attendance_master'		 			=> 'Attendance Master',
            'flag_duplicates'		 			=> 'Flag Duplicates',
            'k12_hs_activity'					=> 'High School Activity',
            'agora_salesforce_case_report'			=> 'SalesForce Case Report'
            
        }
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def login_athena_reports
        
        ftp         = Net::FTP.new('ftp.athena-sis.com')
        tries       = 0
        max_tries   = 3
        
        begin
            
            ftp.login("athenareports", "Lemodie_23")
            ftp.passive = true
            
        rescue => e
            
            tries += 1
            retry if tries <= max_tries
            
            $base.system_notification(
                "LOGIN ATHENA REPORTS FAILED!",
                "ATTEMPTS:  #{tries}
                ERROR:      #{e.message}",
                caller[0],
                e
            )
            
        end
        
        return ftp
        
    end
    
    def login_sapphire_inbox
        ftp = Net::FTP.new('support.k12system.com')
        ftp.login("crivera", "3aPreqAt")
        ftp.passive = true
        #ftp.chdir("inbox")
        return ftp
    end
    
    def login_snap_inbox
        ftp = Net::FTP.new('ftp.snaphealthcenter.com')
        ftp.login("AgoraCyberSchool", "ruprup7AdE")
        ftp.passive = true
        return ftp
    end
    
    def transfer_offsite(file_path, ftp, rename=false, putstext=true)
        if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/)
            file_name   = file_path.split("/")[-1]
            location    = file_path.split("/reports/")[-1].gsub(file_name,"")
            begin
                
                if !location.empty?
                    
                    dir_creation_index = 0
                    begin
                        ftp.chdir(location)
                        
                    rescue
                        
                        dirpath     = nil
                        location.split("/").each{|dir|
                            dirpath     = dirpath.nil? ? dir : "#{dirpath}/#{dir}"
                            dir_found   = false
                            ftp.list.each{|entry|
                                dir_found = true if entry.match(dir)
                            }
                            
                            if !dir_found
                                ftp.mkdir(dir)
                                #begin
                                #    
                                #    ftp.chdir(location)
                                #    
                                #rescue
                                #    
                                #    ftp.mkdir(dirpath)
                                #    
                                #end
                                
                            end
                            ftp.chdir(dir)
                        }
                        
                        dir_creation_index += 1
                        
                        #retry if dir_creation_index < 5 #MAX NUMBER OF SUB DIRECTORIES
                        
                    end
                    
                end
                
                File.exists?(file_path)
                if putstext
                    
                    ftp.puttextfile(file_path)
                    
                else
                    
                    ftp.put(file_path)
                    
                end
                
                if rename
                    
                    tries = 0
                    begin
                        ftp.rename(file_name, rename)
                        
                    rescue=>e
                        if tries < 3
                            tries += 1
                            retry
                        else
                            $base.system_notification(
                                "CREATE OFFSITE REPORT FAILED!",
                                "LOCATION:  #{location}
                                FILENAME:   #{file_name}
                                ERROR:      #{e.message}",
                                caller[0],
                                e
                            )
                        end
                        
                    end
                    
                end
                
                if file_name.include?("IN_PROGRESS.csv")
                    
                    new_name = file_name.gsub("IN_PROGRESS.csv", ".csv")
                    
                    tries = 0
                    begin
                        ftp.rename(file_name, new_name)
                        
                    rescue=>e
                        if tries < 3
                            tries += 1
                            retry
                        else
                            $base.system_notification(
                                "CREATE OFFSITE REPORT FAILED!",
                                "LOCATION:  #{location}
                                FILENAME:   #{file_name}
                                ERROR:      #{e.message}",
                                caller[0],
                                e
                            )
                        end
                        
                    end 
                    
                end
                
                ftp.close
                
                return file_path
                
            rescue =>e
                
                $base.system_notification(
                    "CREATE OFFSITE REPORT FAILED!",
                    "LOCATION:  #{location}
                    FILENAME:   #{file_name}
                    ERROR:      #{e.message}",
                    caller[0],
                    e
                )
                
            end
            
        end
        
    end
    
end