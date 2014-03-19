#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/row"

class Athena_Table

    #---------------------------------------------------------------------------
    def initialize(struct_hash = nil)
        @current_row            = nil
        
        #pre_reqs_init
        #pre_reqs_load
        
        @this_table             = table_name
        @k12_generation_stamp   = nil
        
    end
    #---------------------------------------------------------------------------
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def audit
        table["audit"]
    end
    
    def created_date
        table[:created_date]
    end
    
    def data_base
        table[:data_base] || $config.db_name
    end
    
    def field_order
        table["field_order"]
    end
    
    def file_location
        table["file_location"]
    end
    
    def file_name
        table["file_name"]
    end
    
    def file_path
        table[:file_path] || "#{import_path}#{file_name}" 
    end
    
    def import_path
        if !structure[:import_paths]
            structure[:import_paths] = $config.init_path("#{$paths.imports_path}")
        end
        structure[:import_paths]
    end
    
    def imported_path
        if !structure[:imported_path]
            structure[:imported_path] = $config.init_path("#{$paths.imported_path}#{file_location}")
        end
        structure[:imported_path]
    end
    
    def load_type
        table[:load_type]
    end
    
    def name
        table["name"]
    end
    
    def nice_name
        table["nice_name"]
    end 
    
    def primary_pre_reqs
        ["DB_CONFIG","SYSTEM_LOG","USER_LOG","USER_LOG_CREDENTIAL_ERRORS","TEAM_LOG","SCHOOL_YEAR_DETAIL"]
    end
    
    def relationship
        table[:relationship]
    end
    
    def report_path
        if !structure["report_path"]
            structure["report_path"] = $config.init_path("#{$paths.reports_path}#{file_location}/#{file_name.gsub(".csv","")}")
        end
        structure["report_path"]
    end
    
    def source_address
        table["source_address"]
    end
    
    def source_type
        table["source_type"]
    end
    
    def table_name
        table["name"]
    end
    
    def today
        if table["today"].nil?
            table["today"] = Field.new("datetime")
            table["today"].value = DateTime.now
        end
        table["today"]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def audit=(arg)
        table["audit"] = arg
    end
    
    def created_date=(arg)
        table[:created_date] = arg
    end
    
    def file_path=(arg)
        table[:file_path] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def add_import_document_type
        
        category_name = "Table Imports"
        category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='#{category_name}'").value
        
        if !$tables.attach("document_type").find_field("primary_id",  "WHERE name='#{name}' AND category_id='#{category_id}'")
            
            category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='#{category_name}'").value
            
            new_record = $tables.attach("document_type").new_row
            new_record.fields["category_id"   ].value = category_id
            new_record.fields["name"          ].value = name
            new_record.fields["file_extension"].value = "csv"
            new_record.save
            
        end
        
    end
    
    def bulk_field_by_pid(csv_path, reason_str, authorizor)
        header          = true
        csv_fieldname   = nil
        field_names = Array.new
        csv_length = CSV.open(csv_path, "r").first.length
        CSV.open(csv_path, "r") do |row|
            if header
                i=1
                field_names = Array.new
                while i < csv_length
                   field_names.push(row[i])
                   i+=1
                end
                pid_fieldname  = row[0]
                if pid_fieldname == "pid"
                    header = false
                else
                    return false
                end
            else
                pid = row[0]
                if pid.match(/^[0-9]+$/)
                    table_record = by_primary_id(pid)
                    if table_record
                        field_names.each_with_index do |field_name, i|
                            
                            new_value = row[i+1]
                            if !new_value.nil? && new_value != ""
                                old_value = table_record.fields["#{field_name}"].value
                                if old_value != new_value
                                    
                                    bulk_log = $tables.attach("bulk_modification_log").new_row
                                    fields = bulk_log.fields
                                    fields["table"        ].value = table_name
                                    fields["pid"          ].value = table_record.primary_id
                                    fields["field"        ].value = field_name
                                    fields["from"         ].value = old_value
                                    fields["to"           ].value = new_value
                                    fields["reason"       ].value = reason_str
                                    fields["authorized_by"].value = authorizor 
                                    bulk_log.save
                                end
                            end
                            
                            table_record.fields["#{field_name}"].value = new_value
                            table_record.save
                            
                        end
                    end
                end
            end
        end
        return true
    end
    
    def bulk_update(csv_path, field_name, reason_str, authorizor, value_override=nil)
        header          = true
        csv_fieldname   = nil
        CSV.open(csv_path, "r") do |row|
            row[1] = value_override if value_override
            if header && !value_override
                sid_fieldname  = row[0]
                csv_fieldname  = row[1]
                if sid_fieldname == "student_id" && csv_fieldname == field_name
                    header = false
                else
                    return false
                end
            else
                sid = row[0]
                if sid.match(/^[0-9]+$/)
                    table_record = by_studentid(sid)
                    if table_record
                        old_value = table_record.fields["#{field_name}"].value
                        new_value = row[1]
                        table_record.fields["#{field_name}"].value = new_value
                        table_record.save
                        bulk_log = $tables.attach("bulk_modification_log").new_row
                        fields = bulk_log.fields
                        fields["table"        ].value = table_name
                        fields["pid"          ].value = table_record.primary_id
                        fields["field"        ].value = field_name
                        fields["from"         ].value = old_value
                        fields["to"           ].value = new_value
                        fields["reason"       ].value = reason_str
                        fields["authorized_by"].value = authorizor 
                        bulk_log.save
                    end
                end
            end
        end
        return true
    end
    
    def db_config_record(field_name, new_value)
        record = $tables.attach("Db_Config").by_table_name(table_name)
        record.fields[field_name].value = new_value
        record.save
    end
    
    def download
        
        begin #CATCH ANY RANDOM CRAP THAT WE DIDN"T ACCOUNT FOR
            
            db_config_record(
                field_name  = "last_import_status",
                new_value   = "DOWNLOAD STARTED"
            )
            
            case source_type
            when "k12_report"
                
                db_config_record(
                    field_name  = "load_started_datetime",
                    new_value   = $idatetime
                )
                
                http            = Net::HTTP.new('reports.k12.com', 443)
                http.use_ssl    = true
                
                http.start do |http|
                    
                    begin
                        
                        request = Net::HTTP::Get.new(source_address)
                        request.basic_auth 'jhalverson', 'dxo84tbw'
                        response = http.request(request)
                        
                    rescue => e
                        
                        return load_failed(message = "DOWNLOAD FAILED - #{e.message}", e)
                        
                    end 
                    
                    begin
                        
                        csv_text            = response.body
                        last_comma_index    = csv_text.rindex(",")
                        long_enough         = csv_text.length > (field_order.join.length * 2)
                        
                        if last_comma_index && csv_text.slice(last_comma_index..-1).match(/generated/i) && long_enough
                            
                            if csv_text.slice(last_comma_index..-1).match(/\d{4}-\d{2}-\d{2}/).to_s == $idate
                                
                                file_1 = File.open( "#{import_path}#{file_name}", 'w' )
                                file_1.puts csv_text
                                file_1.close
                                
                                if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/) && table_name == "k12_all_students"
                                    
                                    begin
                                        
                                        out_file_path = "I:/all_students.csv"
                                        
                                        if !File.directory?( "I:/" )
                                            require 'win32ole'
                                            net = WIN32OLE.new('WScript.Network')
                                            user_name = "Administrator"
                                            password  = "Ag0ra2013"
                                            net.MapNetworkDrive( 'I:', "\\\\10.1.10.100\\intactstorage", nil,  user_name, password )
                                        end
                                        
                                        FileUtils.cp("#{import_path}#{file_name}", out_file_path)
                                        
                                    rescue=>e
                                        
                                        $base.system_notification(
                                            subject = "Intact - all_students.csv Transfer Failed!",
                                            content = "Do something about it. Here's the error:
                                            #{e.message}"
                                        )
                                        
                                    end                            
                                    
                                end
                                
                                db_config_record(
                                    field_name  = "last_import_status",
                                    new_value   = "DOWNLOAD COMPLETED"
                                )
                                
                                return true
                                
                            else
                                
                                return load_failed(message = "GENERATION DATE DOES NOT MATCH TODAYS DATE - CSV \nDATE GENERATED: #{csv_text.slice(last_comma_index..-1).match(/\d{4}-\d{2}-\d{2}/).to_s}\nTODAYS DATE: #{$idate}")
                                
                            end
                            
                        elsif csv_text.match(/generated/i)
                            
                            return load_failed(message = "DOWNLOAD FAILED EMPTY FILE - CSV \nCONTENT: #{csv_text}")
                            
                        else
                            
                            return load_failed(message = "DOWNLOAD FAILED - CSV \nCONTENT: #{csv_text}")
                            
                        end
                        
                    rescue => e
                        
                        return load_failed(message = "DOWNLOAD FAILED - #{e.message} - #{csv_text}", e)
                        
                    end
                    
                end
                
            when "jupiter_grades"
                require "#{File.dirname(__FILE__)}/jupiter_grades_interface"
                i = Jupiter_Grades_Interface.new
                i.download_grades_ms(school_year = $school.current_school_year)
                #FileUtils.mv( "#{$paths.imports_path}Jupiter_Grades_&_Schedules.csv" , "#{import_path}/#{file_name}")
                return true #this may need more work if downloads fail
            when "scantron_performance"
                require "#{File.dirname(__FILE__)}/scantron_performance_interface"
                i = Scantron_Performance_Interface.new
                dl_success = i.download_scores
                #FileUtils.mv( "#{$paths.imports_path}scores.csv" , "#{import_path}/#{file_name}") if dl_success
                return dl_success
            end
            
        rescue => e
            
            return load_failed(message = "DOWNLOAD FAILED - #{e.message} - SOME RANDOM CRAP THAT WE DIDN'T ACCOUNT FOR HAPPENED IN ATHENA_TABLE.DOWNLOAD! QUICK! FIX IT!", e)
            
        end
        
    end
    
    def drop
        $db.query("DROP TABLE `#{table_name}`", data_base)
    end
    
    def exists?(this_table = nil)
        exists = $db.get_data(
            "SELECT
                table_name
            FROM information_schema.tables
            WHERE table_schema = '#{ data_base || $config.db_name }'
            AND table_name = '#{this_table || table_name}'",
            "information_schema"
        )
        return exists ? true : false
    end
    
    def fields
        unless @fields
            fields = Hash.new
            fields["primary_id"]    = {"data_type"=>"int",      "file_field"=>"primary_id"  }
            fields["created_by"]    = {"data_type"=>"text",     "file_field"=>"created_by"  }
            fields["created_date"]  = {"data_type"=>"datetime", "file_field"=>"created_date"}
            table["fields"].each_pair{|field_name, details| fields[field_name] = details}
        end
        return fields
    end
    
    def field_from_file(file_field)
        fieldname = nil
        fields.each_pair do |field_name, details|
            if details["file_field"] == file_field
                fieldname = field_name
            end
        end
        fieldname
    end
    
    def find_field(field_name, where_clause)
        record = $db.get_data("SELECT #{table_name}.primary_id, `#{field_name}` FROM #{table_name} #{where_clause}", data_base)
        if record
            record = record[0]
            id = record[0]   
            
            params = {
                "type"      =>  fields[field_name]["data_type"],
                "field"     =>  field_name,
                "table"     =>  self,
                "value"     =>  record[1],
                "primary_id"=>  id
            }
            this_field = $field.new(params)
            
            return this_field
        else
            return false
        end
    end
    
    def find_fields(field_name, where_clause, options = nil)
        
        if options && options[:value_only] && !options[:to_user]
            
            field_str = field_order.include?(field_name) ? "`#{field_name}`" : field_name
            return $db.get_data_single("SELECT #{field_str} FROM #{table_name} #{where_clause}", data_base)
            
        else
            
            records = $db.get_data("SELECT #{table_name}.primary_id, `#{field_name}` FROM #{table_name} #{where_clause}", data_base)
            if records
                
                these_fields = Array.new
                records.each{|record|
                    
                    id = record[0]   
                    
                    params = {
                        "type"      =>  fields[field_name]["data_type"],
                        "field"     =>  field_name,
                        "table"     =>  self,
                        "value"     =>  record[1],
                        "primary_id"=>  id
                    }
                    these_fields.push($field.new(params))
                    
                }
                
                if options && options[:to_user]
                    these_fields.each{|this_field|this_field.to_user!}
                    if options[:value_only]
                        these_fields.each_index{|i|these_fields[i]=these_fields[i].value}
                    end
                end
                
                return these_fields
                
            else
                
                return false
                
            end
            
        end
        
    end
    
    def pre_reqs_init
        if respond_to?('init_pre_reqs')
            init_pre_reqs.each{|req|
                req_table = $tables.attach(req)
                req_table.init
            }
        end
    end
    
    def pre_reqs_load
        
        if respond_to?('load_pre_reqs')
            
            pre_reqs = load_pre_reqs
            
            pre_reqs.each{|pre_req|
                
                record = new_row
                
                pre_req.each_pair{|k,v|
                    
                    record.fields[k.to_s].set(v)   
                    
                }
                
                record.save
                
            } if pre_reqs
            
        end
        
    end
    
    def init_primary_pre_reqs
        primary_pre_reqs.each{|req|
            req_table = $tables.attach(req)
            if !req_table.exists?
                req_table.init
                req_table.load if req_table.import_file_exists?
            end
        }
        $school.current_school_year
    end
    
    def load(a={}) #:after_load=>table_name
        
        begin
            
            continue_with_load = find_and_trigger_event(event_type = :before_load, args = nil)
            
            if continue_with_load
            
                db_config_record(
                    field_name = "load_started_datetime",
                    new_value = DateTime.now
                )
                
                db_config_record(
                    field_name  = "last_import_status",
                    new_value   = "LOAD STARTED"
                )
                
                db_config_record(
                    field_name  = "phase_completed",
                    new_value   = nil
                )
                
                if import_file_exists?
                    
                    add_import_document_type
                    $reports.save_document({:category_name=>"Table Imports", :type_name=>name, :file_path=>file_path})
                    
                    processed_filename = file_name.gsub(".csv","_#{$ifilestamp}.csv")
                    FileUtils.cp(file_path, "#{report_path}#{processed_filename}")
                    
                    if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/) && !caller.find{|x| x.include?("load_k12_history")}
                        #$reports.move_to_athena_reports("#{report_path}#{processed_filename}")
                    end
                    
                    ################################################################
                    #WE WILL NOT TRUNCATE THE TABLE IF THERE IS AN AUDIT TRAIL.
                    #IF YOU NEED TO START WITH A BLANK TABLE YOU WILL NEED TO
                    #TRUNCATE MANUALLY.
                    unless (table["audit"] || load_type == :append)
                        truncate
                    end 
                    ################################################################
                    
                    csv_field_names         = nil
                    
                    sid_row                 = nil
                    samsid_row              = nil
                    @current_row            = new_row 
                    skip                    = true
                    
                    last_row_first_column = nil
                    
                    begin
                        
                        total_rows = 0
                        CSV.foreach( file_path ) do |row|
                            
                            last_row_first_column = row[0]
                            if skip
                                csv_field_names = Array.new
                                row.each{|field|
                                    csv_field_names.push(field_from_file(field))
                                }
                                sid_row     = csv_field_names.index("student_id")
                                
                            elsif source_type == "k12_report" && last_row_first_column.match(/generated/i)
                                #SKIPPING THIS @CURRENT_ROW BECAUSE IT'S NOT VALID, JUST K12'S DATETIME GENERATION STAMP.
                            else 
                                
                                skip_this_row = false
                                
                                if table[:keys]
                                    
                                    key_field_values = String.new
                                    key_field_select = Array.new
                                    table[:keys].each{|key_name|
                                        
                                        if this_fields_value = row[csv_field_names.index(key_name)]
                                            key_field_values << @current_row.fields[key_name].set(this_fields_value.to_s).to_db.to_s   
                                        end
                                        
                                        key_field_select.push("IFNULL(`#{key_name}`, '')")
                                        
                                    }
                                    
                                    existing_record = record("WHERE CONCAT(#{key_field_select.join(",")}) = '#{key_field_values}'")
                                    if existing_record
                                        skip_this_row   = true if !table[:update]
                                        @current_row    = existing_record
                                    else
                                        @current_row.clear
                                    end
                                    
                                else
                                    @current_row.clear
                                end
                                
                                unless skip_this_row
                                    
                                    index = 0  
                                    while index < row.length
                                        
                                        csv_field = csv_field_names[index]
                                        csv_value = row[index]
                                        @current_row.fields[csv_field].value = csv_value if csv_field
                                        index += 1
                                        
                                    end
                                    
                                    @current_row.fields["created_date"].value = $base.created_date if $base.created_date
                                    
                                    begin
                                        @current_row.save
                                    rescue=>e
                                        e.backtrace
                                        $base.system_notification(
                                            subject = "LOAD WARNING - #{table_name}",
                                            content = "Save record failed in load.
                                            ROW DETAILS:
                                            #{row.to_s}
                                            ERROR MESSAGE:
                                            #{e.message}",
                                            caller[0],
                                            e
                                        )
                                        #So the load failed can be caught in case here was a problm with saving this record.
                                        #Otherwise an error is raised inside the save function and is not reported to syslog or sysnotification
                                    end
                                    
                                    total_rows += 1
                                    
                                end
                                
                            end
                            
                            skip = false
                            
                        end
                        
                        if total_rows < 5
                            $base.system_notification(
                                subject = "LOAD WARNING - #{table_name}",
                                content = "Total Rows Imported: #{total_rows}. Please verify."
                            )
                        end
                        
                    rescue => e
                        load_failed(message = e.message, e)
                        raise e
                        
                    end
                    
                    db_config_record(
                        field_name  = "load_complete_datetime",
                        new_value   = DateTime.now
                    )
                    db_config_record(
                        field_name  = "last_import_status",
                        new_value   = "LOAD SUCCEEDED - #{last_row_first_column}"
                    )
                    
                    if a[:k12_history_directory]
                        
                        history_file_name   = file_path.split("/")[-1]
                        new_history_path    = file_path.gsub(history_file_name,"").gsub(a[:k12_history_directory],"#{a[:k12_history_directory]}_loaded")
                        history_loaded_path = $config.init_path(new_history_path)
                        FileUtils.cp(file_path, "#{history_loaded_path}#{history_file_name}")
                        FileUtils.rm(file_path)
                        
                    else
                        
                        FileUtils.cp(file_path, "#{imported_path}#{processed_filename}")
                        FileUtils.rm(file_path)
                        
                    end
                    
                    find_and_trigger_event(event_type = :after_load, args = a[:after_load])
                    
                    db_config_record(
                        field_name  = "import_complete_datetime",
                        new_value   = DateTime.now
                    )
                    
                    return true
                    
                else
                    return load_failed(message = "Import file not found.")
                    
                end
                
            else
                return true
            end
            
        rescue => e
            
            return load_failed(message = "DOWNLOAD FAILED - #{e.message} - SOME RANDOM CRAP THAT WE DIDN'T ACCOUNT FOR HAPPENED IN ATHENA_TABLE.LOAD! QUICK! FIX IT!", e)
            
        end
        
    end
    
    def after_load_failed(message, e_obj)
        
        db_config_record(
            field_name  = "last_error_datetime",
            new_value   = DateTime.now
        )
        db_config_record(
            field_name  = "after_load_status",
            new_value   = "AFTER LOAD FAILED - #{message}"
        )
        
        $base.system_notification(
            subject = "AFTERLOAD FAILED - #{table_name}",
            content = message,
            caller[0],
            e_obj
        )
        
        return false
    end
    
    def load_failed(message, e_obj = nil)
        
        db_config_record(
            field_name  = "last_error_datetime",
            new_value   = DateTime.now
        )
        db_config_record(
            field_name  = "last_import_status",
            new_value   = "LOAD FAILED - #{message}"
        )
        
        $base.system_notification("LOAD FAILED - #{table_name}", message, caller[0], e_obj)
        
        return false
    end
    
    def move_source_to_dest
        
        if (destination_tables = $tables.attach("DB_CONFIG_SOURCE_MAP").find_fields(
                "destination_table",
                "WHERE source_table = '#{table_name}'
                AND active IS TRUE
                GROUP BY destination_table",
                {:value_only=>true}
            )
        )
            
            destination_tables.each{|destination_table|
                
                source_to_dest_arr = Array.new
                
                $tables.attach("DB_CONFIG_SOURCE_MAP").primary_ids(
                    
                    "WHERE source_table = '#{table_name}'
                    AND destination_table = '#{destination_table}'
                    AND active IS TRUE"
                   
                ).each{|map_record_pid|
                    
                    map_record = $tables.attach("DB_CONFIG_SOURCE_MAP").by_primary_id(map_record_pid)
                    
                    source_to_dest_hash = {
                        :source_field       => map_record.fields["source_field"                    ].value,
                        :destination_field  => map_record.fields["destination_field"               ].value,
                        :allow_null         => map_record.fields["update_with_null_values_allowed" ].is_true?  
                    }
                    
                    valid_source_field = field_order.include?(source_to_dest_hash[:source_field])
                    valid_dest_field   = $tables.attach(destination_table).field_order.include?(source_to_dest_hash[:destination_field])
                    
                    if valid_source_field && valid_dest_field
                        
                        source_to_dest_arr.push(source_to_dest_hash)
                        
                    else
                        
                        log_message =  "DB_CONFIG_SOURCE_MAP Field Mismatch Error!\n"
                        log_message << "SOURCE TABLE:      #{table_name}\n"
                        log_message << "SOURCE FIELD:      #{source_to_dest_hash[:source_field]}\n"
                        log_message << "DESTINATION TABLE: #{destination_table}\n"
                        log_message << "DESTINATION FIELD: #{source_to_dest_hash[:destination_field]}\n"
                        $base.system_notification("Source Import Error - DB_CONFIG_SOURCE_MAP",log_message)
                        
                        return false
                        
                    end
                    
                    
                }
                
                pids = primary_ids
                pids.each{|pid|
                    
                    destination_record_changed  = false
                    source_record               = by_primary_id(pid) 
                    student_id                  = source_record.fields["student_id"].value
                    
                    if !(destination_record = $tables.attach(destination_table).by_student_id(student_id))
                        
                        destination_record = $tables.attach(destination_table).new_row
                        destination_record.fields["student_id"].value = student_id
                        destination_record_changed = true
                        
                    end
                    
                    source_to_dest_arr.each{|source_to_dest|
                        
                        source_value = source_record.fields[source_to_dest[:source_field]].value
                        if source_to_dest[:allow_null] || !source_value.nil?
                            
                            destination_record.fields[source_to_dest[:destination_field]].value = source_value
                            destination_record_changed = true
                            
                        end
                        
                    }
                    
                    destination_record.save if destination_record_changed
                    
                } if pids
                
            }
            
        end
        
        
        #if map_records = $tables.attach("DB_CONFIG_SOURCE_MAP").by_source_table(table_name)
        #    
        #    primary_ids.each{|pid|
        #        
        #        #UPGRADED PROCESS
        #        map_records.each{|map_record|
        #            
        #            source_record           = by_primary_id(pid)
        #            
        #            source_field_name       = map_record.fields["source_field"].value
        #            
        #            destination_table       = map_record.fields["destination_table"].value
        #            destination_field_name  = map_record.fields["destination_field"].value
        #            
        #            if (source_field = source_record.fields[source_field_name]) && $tables.attach(destination_table).field_order.include?(destination_field_name)
        #                
        #                student             = $students.get(source_record.fields["student_id"].value)
        #                
        #                if !source_field.value.nil? || map_record.fields["update_with_null_values_allowed" ].is_true?
        #                    
        #                    if destination_table.match(/student/i)
        #                        student.send(destination_field_name).set(source_field.value).save
        #                    else
        #                        student.send(destination_table.gsub("student_","")).send(destination_field_name).set(source_field.value).save
        #                    end
        #                    
        #                end
        #                
        #            else
        #                
        #                log_message =  "DB_CONFIG_SOURCE_MAP Field Mismatch Error!\n"
        #                log_message << "SOURCE TABLE:      #{table_name}\n"
        #                log_message << "SOURCE FIELD:      #{source_field_name}\n"
        #                log_message << "DESTINATION TABLE: #{destination_table}\n"
        #                log_message << "DESTINATION FIELD: #{destination_field_name}\n"
        #                $base.system_notification("Source Import Error - DB_CONFIG_SOURCE_MAP",log_message)
        #                return false
        #                
        #            end
        #            
        #        }
        #        
        #        ##OLD PROCESS
        #        #source_record   = by_primary_id(pid)
        #        #dest_records    = Hash.new
        #        #map_records.each{|map_record|
        #        #    dest_table_name = map_record.fields["destination_table"      ].value
        #        #    if !dest_records.has_key?(dest_table_name)
        #        #        source_key_field            = map_record.fields["source_key_field"          ].value
        #        #        dest_key_field              = map_record.fields["destination_key_field"     ].value
        #        #        update_active_record_only   = map_record.fields["update_active_record_only" ].is_true?
        #        #        
        #        #        source_key_id               = source_record.fields[source_key_field         ].value
        #        #        
        #        #        #dest_record will be the active record if there is one, or creates a new record.
        #        #        dest_record_function_str    = update_active_record_only ? "active_by_#{dest_key_field}" : "by_#{dest_key_field}"
        #        #        dest_table                  = $tables.attach(dest_table_name)
        #        #        dest_record                 = dest_table.send(dest_record_function_str, source_key_id) if dest_table.respond_to?(dest_record_function_str)
        #        #        if !dest_record
        #        #            dest_record = dest_table.new_row
        #        #            dest_record.fields[dest_key_field].value = source_key_id 
        #        #        end
        #        #        dest_records[dest_table_name] = dest_record
        #        #    end
        #        #    
        #        #    dest_field      = map_record.fields["destination_field" ].value
        #        #    source_field    = map_record.fields["source_field"      ].value
        #        #    if dest_records[dest_table_name].fields[dest_field] && source_record.fields[source_field]
        #        #        
        #        #        if map_record.fields["update_with_null_values_allowed" ].is_true? || !source_record.fields[source_field].value.nil?
        #        #            dest_records[dest_table_name].fields[dest_field].value = source_record.fields[source_field].value
        #        #        end
        #        #        
        #        #    else
        #        #        log_message =  "DB_CONFIG_SOURCE_MAP Field Mismatch Error!\n"
        #        #        log_message << "SOURCE TABLE:      #{table_name}\n"
        #        #        log_message << "SOURCE FIELD:      #{source_field}\n"
        #        #        log_message << "DESTINATION TABLE: #{dest_table_name}\n"
        #        #        log_message << "DESTINATION FIELD: #{dest_field}\n"
        #        #        $base.system_notification("Source Import Error - DB_CONFIG_SOURCE_MAP",log_message)
        #        #        return false
        #        #    end
        #        #    
        #        #}
        #        
        #        #dest_records.each_value{|record|
        #        #    record.save
        #        #}
        #    }
        #    
        #end
        
    end
    
    def new_row(primary_id = nil)
        Row.new(self, primary_id)
    end
    
    def nva(params)
        nv_array = Array.new
        if !params[:results]
            select_sql =
            "SELECT #{params[:name_field]}, #{params[:value_field]}
            FROM #{table_name}
            #{params[:clause_string]}"
            params[:results] = $db.get_data(select_sql, data_base)
        end
        params[:results].each{|result| nv_array.push(    {:name=>result[0],:value=>result[1]}    )} if params[:results]
        return nv_array
    end
    
    def dd_choices(name_field, value_field, clause_string = nil)
        
        select_sql =
            "SELECT #{name_field}, #{value_field}
            FROM #{table_name}
            #{clause_string}"
        results = $db.get_data(select_sql, data_base)
        
        if results
            
            dd_choices = Array.new
            results.each{|result| dd_choices.push(    {:name=>result[0],:value=>result[1]}    )}
            
            return dd_choices
            
        else
            return false
            
        end
        
    end

    def record(where_clause = "", fields_list = nil)
        fields_str = fields_list ? fields_list : sql_fields_str
        record = $db.get_data("SELECT #{fields_str} FROM #{table_name} #{where_clause}", data_base)
        if record
            record = record[0]
            id = record[0]
            i = 0
            row = Row.new(self)
            row.trim_fields_not_listed(fields_list) if fields_list
            fields_str.gsub("`","").split(",").each{|field|
                field = field.split(".")[-1] if field.include?(".")
                row.fields[field].primary_id = id
                row.fields[field].value = record[i]
                i += 1
            }
            return row
        else 
            return false  
        end   
    end
    
    def records(where_clause = "", fields_str = nil)
        fields_str      = sql_fields_str if !fields_str
        records_array   = Array.new
        records         = $db.get_data("SELECT #{fields_str} FROM #{table_name} #{where_clause}", data_base)
        if records
            records.each do |record|
                id  = record[0]
                i   = 0
                row = Row.new(self)
                fields_str.gsub("`","").split(",").each{|field|
                    field = field.split(".")[-1] if field.include?(".")
                    row.fields[field].value         = record[i]
                    row.fields[field].primary_id    = id
                    i += 1
                }
                records_array.push(row)
            end
            return records_array
        else 
            return false  
        end   
    end
    
    def reindex(audit = false)
        #Only a total of 64 indexes are allowed.
        #Make sure to changed the reserved index total if column additions of subtractions are made
        @this_table = audit ? "zz_#{table["name"]}" : table["name"]
        
        if exists?(@this_table)
            
            indexes             = $db.get_data("SHOW INDEX FROM #{@this_table}", data_base)
            indexes_assigned    = indexes ? indexes.length : 0
            
            field_order.each {|field|
                
                field_name  = field
                details     = fields[field]
                type        = details["data_type"]
                
                unless (details.key? "index" && details["index"] == false) || (indexes_assigned >= (64))
                    
                    if field_exists?(field_name) && !index_exists?(field_name)
                        
                        case type
                        when "int","date","bool","tinyint","year","timestamp","decimal(5,4)","decimal(10,2)"
                            alter_table("ADD INDEX (`#{field_name}`)")
                        when "text"
                            alter_table("ADD FULLTEXT (`#{field_name}`)")
                        end
                        
                    end
                    
                    indexes_assigned += 1
                    
                end
                
            }
            if audit
                if !field_exists?("modified_date"   )
                    alter_table("ADD `modified_date` timestamp default current_timestamp"   )
                    alter_table("ADD INDEX (`modified_date`)"                               )
                end
                if !field_exists?("modified_by"     )
                    alter_table("ADD `modified_by` text"                                    )
                    alter_table("ADD FULLTEXT (`modified_by`)"                              )  
                end
                if !field_exists?("modified_pid"    )
                    alter_table("ADD `modified_pid` int"                                    )
                    alter_table("ADD INDEX (`modified_pid`)"                                )
                end
                if !field_exists?("modified_field"  )
                    alter_table("ADD `modified_field` text"                                 )
                    alter_table("ADD FULLTEXT (`modified_field`)"                           )
                end
                if !field_exists?("modified_value"  )
                    alter_table("ADD `modified_value` text"                                 )
                    alter_table("ADD FULLTEXT (`modified_value`)"                           )
                end 
            else
                if !field_exists?("created_date"    )
                    alter_table("ADD `created_date` timestamp DEFAULT CURRENT_TIMESTAMP"    )
                    alter_table("ADD INDEX (`created_date`)"                                ) 
                end
                if !field_exists?("created_by"      )
                    alter_table("ADD `created_by` text"                                     )  
                    alter_table("ADD FULLTEXT (`created_by`)"                               )
                end
            end
            if !audit && table["audit"]
                reindex(true)
            end
            
        end
        
    end
    
    def restore_file_exists?(audit_restore=nil)
        dest_table       = audit_restore ? "zz_#{table_name}"   : table_name
        source_file      = audit_restore ? "audit_#{file_name}"      : file_name
        source_file_path = "#{$paths.restore_path}#{table_name}/#{source_file}"
        if File.exists?(source_file_path)
            return true
        else
            return false
        end
    end
    
#    does anything call this? - FNORD
    #def records_grouped(field, where_clause = "")
    #    fields_str = sql_fields_str
    #    records_array = Array.new
    #    records = $db.get_data("SELECT #{fields_str} FROM #{table_name} #{where_clause} GROUP BY #{field}")
    #    if records
    #        records.each do |record|
    #            i = 0
    #            row = Row.new(self)
    #            fields_str.split(",").each{|field|
    #                row.fields[field].value = record[i]
    #                i += 1
    #            }
    #            records_array.push(row)
    #        end
    #        return records_array
    #    else 
    #        return false  
    #    end   
    #end
    
    def field_value(field_name, where_clause)
        
        field_str = field_name.match(/concat/i) ? field_name : "`#{field_name}`"
        
        sql_str =
            "SELECT #{field_str}
            FROM `#{table_name}`
            #{where_clause}"
        results = $db.get_data_single(sql_str, data_base)
        
        return results ? results[0] : false
        
    end
    
    def field_values(field_name, where_clause = nil)
        
        field_str = field_name.match(/concat/i) ? field_name : "`#{field_name}`"
        
        sql_str =
            "SELECT #{field_str}
            FROM `#{table_name}`
            #{where_clause}"
        results = $db.get_data_single(sql_str, data_base)
        
        return results ? results : false
        
    end
    
    def field_value_by_pid(field_name, pid)
        
        field_str = field_name.match(/concat/i) ? field_name : "`#{field_name}`"
        
        sql_str =
            "SELECT #{field_str}
            FROM `#{table_name}`
            WHERE primary_id = '#{pid}'"
        results = $db.get_data_single(sql_str, data_base)
        
        return results ? results[0] : false
        
    end
    
    def query(sql)
        $db.query(sql, data_base)
    end
    
    def truncate(audit = nil)
        
        if audit
            $db.query("TRUNCATE zz_#{table_name}", data_base)
        else
            $db.query("TRUNCATE #{table_name}", data_base)
        end
    end
    
    def values(where_clause) #needs work returns values, but no way to indicate which column they're for
        #return $db.get_data("SELECT #{sql_fields_str} FROM #{table_name} #{where_clause}")
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENT_FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def event_array(function_name)
        results = Array.new
        Dir.foreach("#{File.dirname(__FILE__).gsub("base","tables")}"){|file|
            if !file.gsub!(/\.|rb/,"").empty?
                this_table = $tables.attach(file)
                if this_table.respond_to?(function_name)
                    results.push(file)
                end
            end
        }
        return results
    end
    
    #FNORD - This should create a hash of all the tables that actually have triggers for the working table only once.
    def find_and_trigger_event(event_type, args = nil)
        
        case event_type
        when :before_change
            
            if respond_to?(:before_change)
                
                results = send(:before_change, args)
                return false if results == false
                
            end
            
        when :after_change
            
            if respond_to?(:after_change)
                
                resaults = send(:after_change, args)
                return false if results == false
                
            end
            
        when :before_change_field
            
            #CALL FOR A SPECIFIC FIELD THAT HAS CHANGED
            trigger_function_name = "#{:before_change_field}_#{args.field_name}"
            if respond_to?(trigger_function_name)
                
                results = send(trigger_function_name, args) 
                return false if results == false
                
            end
            
            #CALL FOR ANY FIELD THAT CHANGES
            trigger_function_name = "#{:before_change_field}"
            if respond_to?(trigger_function_name)
                
                results = send(trigger_function_name, args) 
                return false if results == false
                
            end
            
        when :after_change_field
            #looks in own class for :after_change_field for the field passed, requires the parameter of a Field object to be passed
            
            #SAPPHIRE UPDATE
            #SEARCH FOR ACTIVE MAP DEFINITION THAT INCLUDES THE CURRENT TABLE AND FIELD.
            #IF ANY ARE FOUND QUEUE THE PROCESS
            if args.table.field_order.include?("student_id")
                
                if map_id = $tables.attach("SAPPHIRE_INTERFACE_MAP").field_value(
                    "primary_id",
                    "WHERE athena_table     = '#{table_name         }'
                    AND athena_field        = '#{args.field_name    }'
                    AND trigger_event       = 'after_change_field'"
                )
                    
                    sid     = $tables.attach(args.table.table_name).field_value("student_id", "WHERE primary_id = '#{args.primary_id}'")
                    student = $students.get(sid)
                    
                    if student && student.active.is_true?
                        
                        queue_record = $tables.attach("SAPPHIRE_INTERFACE_QUEUE").new_row
                        queue_record.fields["map_id"            ].value = map_id
                        queue_record.fields["athena_pid"        ].value = args.primary_id
                        queue_record.save
                        
                    end
                    
                end
                
            end
            
            #CALL FOR A SPECIFIC FIELD THAT HAS CHANGED
            trigger_function_name = "#{:after_change_field}_#{args.field_name}"
            if respond_to?(trigger_function_name)
                
                results = send(trigger_function_name, args) 
                return false if results == false
                
            end
            
            #CALL FOR ANY FIELD THAT CHANGES
            trigger_function_name = "#{:after_change_field}"
            if respond_to?(trigger_function_name)
                
                results = send(trigger_function_name, args)
                return false if results == false
                
            end
         
        when :before_load #any table can have this event for self table
            
            continue_with_load = true
            
            this_trigger_event = "before_load_#{table_name.downcase}"
            
            tables_with_before_load_events = args ? args : event_array(this_trigger_event)
            
            tables_with_before_load_events.each{|file|
                this_table = $tables.attach(file)
                
                begin
                    continue_with_load = this_table.send(this_trigger_event)
                    
                rescue=> e
                    #raise e #THIS SHOULD HAVE BEEN A SYSTEM NOTIFICATION - ADDING NOW BUT LEACING THIS NOTE HERE TO HELP IDENTIFY ANY ISSUES THAT MAY COME TO LIGHT WHICH WERE CONCEALED BY THIS BEFORE...
                    $base.system_notification(
                        subject = "BEFORE LOAD FAILED - #{file}",
                        content = "Don't just stand there and shout it; do something about it... Here's the error:
                        #{e.message}"
                    )
                    
                end
                
            } if tables_with_before_load_events
            
            return continue_with_load
            
        when :after_load #any table can have this event for self table
            
            this_trigger_event = "after_load_#{table_name.downcase}"
            
            tables_with_after_load_events = args ? args.dup : event_array(this_trigger_event)
            
            db_config_record(
                field_name  = "phase_total",
                new_value   = tables_with_after_load_events.join(",")
            )
            db_config_record(
                field_name  = "phase_completed",
                new_value   = nil
            )
            
            if !args || args.include?("move_source_to_dest")
                tables_with_after_load_events.delete("move_source_to_dest")
                move_source_to_dest
            end
            
            tables_with_after_load_events.each{|file|
                this_table = $tables.attach(file)
                db_config_record(
                    field_name  = "after_load_status",
                    new_value   = "Started #{file} - #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
                )
                
                begin
                    this_table.send(this_trigger_event)
                    db_config_record    = $tables.attach("Db_Config").by_table_name(table_name)
                    phase_completed     = db_config_record.fields["phase_completed"].value
                    phase_completed     = (phase_completed ? "#{phase_completed},#{file}" : file)
                    db_config_record(
                        field_name  = "phase_completed",
                        new_value   = phase_completed
                    )
                    db_config_record(
                        field_name  = "after_load_status",
                        new_value   = "Completed #{file} - #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
                    )
                    
                rescue=> e
                    after_load_failed(message = "#{file} - #{e.message}", e)
                    raise e
                end
                
            } if tables_with_after_load_events
            
        when :after_insert
            send(:after_insert, args) if respond_to?(:after_insert)
          
        when :after_save
            send(:after_save, args) if respond_to?(:after_save)
            
        when :before_insert
            #Looks in own class for before_insert event, requires the parameter of a Row object to be passed
            if respond_to?(:before_insert)
                send(:before_insert, args)
            else
                return true
            end
            
        end
        
        return true
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________RECORD_ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def by_primary_id(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_studentid(arg, where_clause_addon = nil)
        
        if table[:relationship]
            
            params = Array.new
            
            if fields["student_id"]
                
                sid_where_addon = " WHERE student_id = '#{arg}' "
                
            elsif fields["studentid"]
                
                sid_where_addon = " WHERE studentid = '#{arg}' "
                
            end
            
            if where_clause_addon
                
                if where_clause_addon.match(/where/i)
                    
                    where_clause = where_clause_addon.gsub(/where/i,"#{sid_where_addon} AND ")
                    
                else
                    
                    where_clause = "#{sid_where_addon} #{where_clause_addon}"
                    
                end
                
            else
                
                where_clause = sid_where_addon
                
            end  
            
            if table[:relationship] == :one_to_one
                
                record(where_clause)
                
            elsif table[:relationship] == :one_to_many
                
                records(where_clause)
                
            end
            
        end
        
    end
    alias :by_student_id :by_studentid
    
    def by_tid(arg)
        
        if table[:relationship]
            
            params = Array.new
            
            if fields["team_id"]
                
                params.push( Struct::WHERE_PARAMS.new("team_id", "=", arg ) )
                
            end
            
            where_clause = $db.where_clause(params)
            
            if table[:relationship] == :one_to_one
                
                record(where_clause)
                
            elsif table[:relationship] == :one_to_many
                
                records(where_clause)
                
            end
            
        end
        
    end
    
    def field_by_pid(field_name, pid)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", pid ) )
        where_clause = $db.where_clause(params)
        
        #if !table[:relationship] || table[:relationship] == :one_to_one
            
            find_field(field_name, where_clause)
            
        #elsif table[:relationship] == :one_to_many
        #    
        #    find_fields(field_name, where_clause)
        #    
        #end
        
    end
    
    def field_by_tid(field_name, team_id)
        
        if fields["team_id"]
            
            params = Array.new
            params.push( Struct::WHERE_PARAMS.new("team_id", "=", team_id ) )
            
            where_clause = $db.where_clause(params)
            
            if table[:relationship] == :one_to_one
                
                return find_field(field_name, where_clause)
                
            elsif table[:relationship] == :one_to_many
                
                return find_fields(field_name, where_clause)
                
            end
            
        end
        
        return false
        
    end
    
    def field_by_sid(field_name, sid)
        
        if table[:relationship]
            
            params = Array.new
            
            if fields["student_id"]
                
                params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid ) )
                
            elsif fields["studentid"]
                
                params.push( Struct::WHERE_PARAMS.new("studentid", "=", sid ) )
                
            end
            
            where_clause = $db.where_clause(params)
            
            if table[:relationship] == :one_to_one
                
                find_field(field_name, where_clause)
                
            elsif table[:relationship] == :one_to_many
                
                find_fields(field_name, where_clause)
                
            end
            
        end
        
    end
    
    def primary_ids(where_clause = nil)
        $db.get_data_single(
            "SELECT #{table_name}.primary_id
            FROM #{data_base}.#{table_name}
            #{where_clause}",
            data_base
        )
    end
    
    def staff_ids(where_clause = nil)
        if fields["staff_id"]
            $db.get_data_single(
                "SELECT #{table_name}.staff_id
                FROM #{table_name}
                #{where_clause}
                GROUP BY staff_id",
                data_base
            )
        else
            return false
        end
    end
    
    def student_ids(where_clause = nil)
        if fields["student_id"]
            $db.get_data_single(
                "SELECT #{table_name}.student_id
                FROM #{table_name}
                #{where_clause}
                GROUP BY student_id",
                data_base
            )
        else
            return false
        end
    end
    
    def team_ids(where_clause = nil)
        if fields["team_id"]
            $db.get_data_single(
                "SELECT #{table_name}.team_id
                FROM #{table_name}
                #{where_clause}
                GROUP BY team_id",
                data_base
            )
        else
            return false
        end
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS?
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def empty?
        records_exist? ? false : true
    end
    
    def index_exists?(field_name)
        
        $db.get_data_single(
            
            "SELECT
                table_catalog
            FROM information_schema.statistics 
            WHERE table_schema = '#{data_base}' 
            AND table_name = '#{@this_table}' AND column_name = '#{field_name}'"  
        )
        
    end
    
    def import_file_exists?
        File.exists?(file_path)
    end
    
    def records_exist?
        $db.get_data_single("SELECT primary_id FROM #{table_name}", data_base) ? true : false
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TABLE_MAINTENANCE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load(a={})
        find_and_trigger_event(event_type = :after_load, args = a[:after_load])
    end
    
    def backup(audit_backup=nil, structured_order=nil)
        
        if audit_backup
            
            source_table    = "zz_#{table_name}"     
            dest_file       = "audit_#{file_name}"
            fields_addon    = [
                
                "modified_date",
                "modified_by",
                "modified_pid",
                "modified_field",
                "modified_value"
                
            ]
            
        else
            
            source_table    = table_name
            dest_file       = file_name
            fields_addon    = [
                
                "created_date",
                "created_by"
                
            ]
            
        end
        
        fields_str_arr  = field_order.dup
        fields_str_arr.insert(0,"primary_id")
        fields_addon.each{|field_name|
            
            fields_str_arr.insert(-1, field_name)
            
        }
        
        fields_str = structured_order ? "`#{fields_str_arr.join("`,`")}`" : "*"
        
        dest_path = $config.init_path("#{$paths.restore_path}#{table_name}")
        
        $db.query(
            
            "SELECT #{fields_str}
            FROM #{source_table}
            INTO OUTFILE '#{dest_path}#{dest_file}'
            FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\\r\\n'",
            data_base
            
        )
        
        backup(true, structured_order) if audit && !audit_backup
        
        return dest_path
        
    end
    
    def init(audit = false, table_only = false)
        
        #INITIALIZES TABLES THAT THE WHOLE SYSTEM DEPENDS ON
        init_primary_pre_reqs unless primary_pre_reqs.include?(table_name.upcase)
        
        #INITIALIZES TABLES THAT THE CALLED TABLE DEPENDS ON
        pre_reqs_init
        
        #Only a total of 64 indexes are allowed.
        #Make sure to changed the reserved index total if column additions of subtractions are made
        
        reserved_indexes = audit ? 5 : 2
        
        @this_table = audit ? "zz_#{table["name"]}" : table["name"]
        
        ########################################################################
        if exists?(@this_table)
            table_status = $db.get_data("CHECK TABLE #{@this_table} FAST QUICK;", data_base)
            puts table_status.join(" || ")
            if !(table_status[0][3] == "Table is already up to date")
                puts "PRESS ANY KEY TO CONTINUE"
                anykey = $stdin.gets
                #FNORD - add functionality to handle results of below when there's time.
                $db.query("REPAIR TABLE #{@this_table}", data_base)
            end
            
        end
        ########################################################################
        
        if !exists?(@this_table)
            indexes_assigned = 0
            $db.query("CREATE TABLE IF NOT EXISTS #{@this_table} (PRIMARY_ID int(11) primary key auto_increment not null)", data_base)
            $db.query("ALTER TABLE #{@this_table} ENGINE = MYISAM", data_base)
            indexes_assigned += 1
        else
            indexes             = $db.get_data("SHOW INDEX FROM #{@this_table}", data_base)
            indexes_assigned    = indexes ? indexes.length : 0
        end 
        
        field_order.each {|field|
            
            field_name = field
            details    = fields[field]
            
            if !field_exists?(field_name)
                type = details["data_type"]
                alter_table("ADD `#{field_name}` #{type}")
                
                unless (details.key? "index" && details["index"] == false) || (indexes_assigned >= (64 - reserved_indexes))
                    
                    if !$db.get_data("SHOW INDEX FROM #{@this_table} WHERE column_name = '#{field_name}'", data_base)
                        
                        case type
                        when "int","date","datetime","bool","tinyint","year","timestamp","decimal(5,4)","decimal(10,2)","decimal(15,2)"
                            alter_table("ADD INDEX (`#{field_name}`)")
                            indexes_assigned += 1
                        when "text"
                            alter_table("ADD FULLTEXT (`#{field_name}`)")
                            indexes_assigned += 1
                        end
                        
                    end
                    
                end
            end
            
        } unless table_only
        
        if audit
            if !field_exists?("modified_date"   )
                alter_table("ADD `modified_date` timestamp default current_timestamp"   )
                alter_table("ADD INDEX (`modified_date`)"                               )
            end
            if !field_exists?("modified_by"     )
                alter_table("ADD `modified_by` text"                                    )
                alter_table("ADD FULLTEXT (`modified_by`)"                              )  
            end
            if !field_exists?("modified_pid"    )
                alter_table("ADD `modified_pid` int"                                    )
                alter_table("ADD INDEX (`modified_pid`)"                                )
            end
            if !field_exists?("modified_field"  )
                alter_table("ADD `modified_field` text"                                 )
                alter_table("ADD FULLTEXT (`modified_field`)"                           )
            end
            if !field_exists?("modified_value"  )
                alter_table("ADD `modified_value` text"                                 )
                alter_table("ADD FULLTEXT (`modified_value`)"                           )
            end 
        else
            if !field_exists?("created_date"    )
                alter_table("ADD `created_date` timestamp DEFAULT CURRENT_TIMESTAMP"    )
                alter_table("ADD INDEX (`created_date`)"                                ) 
            end
            if !field_exists?("created_by"      )
                alter_table("ADD `created_by` text"                                     )  
                alter_table("ADD FULLTEXT (`created_by`)"                               )
            end
        end
        if !audit && table["audit"]
            init(true, table_only)
        end
        if table_name != "db_config"
            config = $tables.attach("Db_Config")
            config_record = config.by_table_name(self.class.to_s)
            if !config_record
                config_record = config.new_row
                config_record.fields["table_name"].value = self.class.to_s
                config_record.save
            end
        end
        
        unless @re_initialize || table_only
            load if import_file_exists?
            pre_reqs_load
        end
        
    end
    
    def re_initialize(a=Hash.new)
        
        if exists?
            
            @re_initialize = true
            
            init
            
            $paths.restore_path = "#{$config.storage_root}REINITIALIZE_#{$ifilestamp}"
            
            backup_path = backup(audit_backup=nil, structured_order=true)
            
            $db.query("DROP TABLE `#{table_name}`",     data_base   )
            $db.query("DROP TABLE `zz_#{table_name}`",  data_base   ) if audit
            
            init
            
            restore
            
            return backup_path
            
        end
     
    end
    
    def restore(audit_restore=nil)
        
        dest_table       = audit_restore ? "zz_#{table_name}"       : table_name
        source_file      = audit_restore ? "audit_#{table_name}"    : table_name
        source_file_path = "#{$paths.restore_path}#{table_name}/#{source_file}.csv"
        
        if File.exists?(source_file_path)
            
            $db.query("TRUNCATE #{dest_table}", data_base)
            $db.query(
                "LOAD DATA INFILE '#{source_file_path}'
                INTO TABLE #{dest_table}
                FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\\r\\n'",
                data_base
            )
            
        else
            puts "     BACKUP FILE NOT FOUND for #{dest_table}!"
        end
        
        restore(true) if audit && !audit_restore
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def set_structure(arg)
        if arg.is_a? Hash
            arg.each_pair{|k, v| @structure[k] = v}
        end
        if arg.is_a? Row
            arg.fields.each_pair{|fieldname,field| @structure[fieldname] = field if @structure.has_key?(fieldname) }
        end
    end
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
            set_structure(struct_hash) if !struct_hash.nil?
        end
        @structure
    end
    
    def structure=(arg)
        set_structure(arg)
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def alter_table(instructions)
        alter_sql =
            "ALTER TABLE `#{@this_table}`
            #{instructions}"
        $db.query(alter_sql, data_base)
    end
   
    def field_exists?(this_field)
        select_sql =
            "SELECT
                *
            FROM information_schema.columns
            WHERE table_schema  = '#{data_base || $config.db_name}'
            AND table_name      = '#{@this_table}'
            AND column_name     = '#{this_field}'"
        field_exists = $db.get_data_single(select_sql, "information_schema")
    end
   
    def prep_row
        if @fields
            @fields.each_value{|field| field.prep}
        end
    end
 
    def sql_fields_str
        fieldstr = ["primary_id","created_by","created_date"].concat(field_order)
        return "`#{table_name}`.`#{fieldstr.join("`,`#{table_name}`.`")}`"
    end
    
end