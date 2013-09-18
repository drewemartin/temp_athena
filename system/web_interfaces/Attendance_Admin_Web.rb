#!/usr/local/bin/ruby


class ATTENDANCE_ADMIN_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        @tot_tables = nil
        @com_tables = 0
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return "Attendance Admin"
    end
    
    def page_title
        return "Attendance Admin"
    end
    
    #---------------------------------------------------------------------------
    def load
        
        output = $tools.tab_identifier(1)
        output << "<div id='upload_status'></div>"
        output << $kit.tools.tabs([
            ["Attendance Modes",        attendance_mode             ],
            ["Attendance Sources",      attendance_sources          ],
            ["K12 Reports Status",      finalize_attendance_tab     ],
            #["Close Out Attendance",    close_records_tab(true)      ],
            ["Change Overall Mode",     bulk_overall_mode           ],
            ["Change Daily Mode",       bulk_daily_mode             ],
            ["Change Daily Code",       bulk_daily_code             ],
            ["Process Queue",           process_queue_tab(true)     ]
        ])
        
        return output
        
    end
    #---------------------------------------------------------------------------    
    
    #---------------------------------------------------------------------------
    def response
        
        @upload_type = $kit.params[:upload_type      ] != "" ? $kit.params[:upload_type      ] : false
        @reason      = $kit.params[:reason           ] != "" ? $kit.params[:reason           ] : false
        @authorizor  = $kit.params[:authorizor       ] != "" ? $kit.params[:authorizor       ] : false
        @csv         = $kit.params[:csv_upload       ] != "" ? $kit.params[:csv_upload       ] : false
        
        #if $kit.params[:start_date]!="" && $kit.params[:end_date]!="" && !$kit.params[:start_date].nil? && !$kit.params[:end_date].nil?
        #    
        #    start_date = $kit.date_to_db($kit.params[:start_date])
        #    end_date   = $kit.date_to_db($kit.params[:end_date])
        #    close_records_tab(init=false, start_date, end_date)
        #    
        #elsif @reason && @authorizor && @csv
        if @reason && @authorizor && @csv
            
            case @upload_type
            when "change_overall_mode"
                bulk_overall_mode_queue_process
                
            when "change_daily_mode"
                bulk_daily_mode_queue_process
                
            when "change_daily_code"
                bulk_daily_code_queue_process
                
            else
                validation_check
                
            end
            
        else
            
            validation_check
            
        end
        
        return ""
        
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def attendance_mode
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "ATTENDANCE_MODES")
        
        table_array = [
            
            #HEADERS
            [
                "mode"              ,
                "procedure_type"    ,
                "description"       
                
            ]
            
        ]
        
        pids = $tables.attach("ATTENDANCE_MODES").primary_ids
        pids.each{|pid|
            
            row = Array.new
            
            record = $tables.attach("ATTENDANCE_MODES").by_primary_id(pid) 
            row.push(record.fields["mode"               ].web.label())
            row.push(record.fields["procedure_type"     ].web.label)#select(:dd_choices=>procedure_type_dd))
            row.push(record.fields["description"        ].web.default())
            
            table_array.push(row)
            
        } if pids
        
        output << $base.web_tools.data_table(table_array, "attendance_modes")
        
        return output
        
    end
    
    def attendance_sources
        
        output = String.new
        
        output << $tools.button_new_row(table_name = "ATTENDANCE_SOURCES")
        
        table_array = [
            
            #HEADERS
            [
                "source"        ,
                "type"          ,
                "eligible grades"
                
            ]
            
        ]
        
        pids = $tables.attach("ATTENDANCE_SOURCES").primary_ids
        pids.each{|pid|
            
            row             = Array.new
            icons           = "<div class='type_icons'></div>"
            record          = $tables.attach("ATTENDANCE_SOURCES").by_primary_id(pid)
            
            icons.insert(-7, record.fields["override_attendance"   ].is_true? ? $icons.ui_notice    : "")
            icons.insert(-7, record.fields["test_event"            ].is_true? ? $icons.test         : "")
            
            row.push(record.fields["source" ].web.label()    )
            row.push(record.fields["type"   ].web.label)#select(:dd_choices=>source_type_dd)   )
            
            grades = Array.new
            grades.push(["K","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th"])  
            grades.push(
                [
                    record.fields["grade_k"       ].web.default(:disabled=>true),
                    record.fields["grade_1st"     ].web.default(:disabled=>true),
                    record.fields["grade_2nd"     ].web.default(:disabled=>true),
                    record.fields["grade_3rd"     ].web.default(:disabled=>true),
                    record.fields["grade_4th"     ].web.default(:disabled=>true),
                    record.fields["grade_5th"     ].web.default(:disabled=>true),
                    record.fields["grade_6th"     ].web.default(:disabled=>true),
                    record.fields["grade_7th"     ].web.default(:disabled=>true),
                    record.fields["grade_8th"     ].web.default(:disabled=>true),
                    record.fields["grade_9th"     ].web.default(:disabled=>true),
                    record.fields["grade_10th"    ].web.default(:disabled=>true),
                    record.fields["grade_11th"    ].web.default(:disabled=>true),
                    record.fields["grade_12th"    ].web.default(:disabled=>true)
                ]
            )
            
            grades_included = $tools.table(
                :table_array    => grades,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Eligible Grades"
            )
            
            row.push(grades_included+icons)
            
            table_array.push(row)
            
        } if pids
        
        output << $base.web_tools.data_table(table_array, "attendance_sources")
        
        return output
        
    end

    def finalize_attendance_tab
        
        output  = String.new
        
        gray    = "<img src='/athena/images/gray.png'     width='32' height='32'/>"
        yellow  = "<img src='/athena/images/yellow.png'   width='32' height='32'/>"
        green   = "<img src='/athena/images/green.png'    width='32' height='32'/>"
        red     = "<img src='/athena/images/red.png'      width='32' height='32'/>"
        colors  = {"gray"=>gray, "yellow"=>yellow, "green"=>green, "red"=>red}
        
        output << $tools.div_open("main_div", "main_div")
        complete_tot    = $tables.attach("student_attendance").primary_ids("WHERE logged IS TRUE")
        tot             = $tables.attach("student_attendance").primary_ids()
        output << "<div style='float:right;'>#{complete_tot ? complete_tot.length : 0}/#{tot ? tot.length : 0}</div>"
        #Report Status
        output << $tools.newlabel("report_status", "Report Status")
        output << $tools.div_open("status_container")
        
        #Headers
        output << $tools.div_open("headers")
        output << $tools.newlabel("name_header",        "Report")
        output << $tools.newlabel("time_header",        "Scheduled Run Time")
        output << $tools.newlabel("start_header",       "Started Time")
        output << $tools.newlabel("complete_header",    "Completed Time")
        output << $tools.newlabel("afterload_total",    "Phase")
        output << $tools.newlabel("status_header",      "Status")
        output << $tools.div_close
        
        config_rows = $tables.attach("Db_Config").attendance_reports
        @tot_tables = config_rows.length
        
        if config_rows
            
            i=0
            
            config_rows.each do |row|
                
                fields  = row.fields
                status  = status_color(fields)
                
                fields  = format_fields(fields)
                
                row_num = i%2 == 0 ? "row0" : "row1"
                output << $tools.div_open("row", row_num)
                
                output << fields["table_name"               ].web.label()
                output << fields["import_schedule"          ].web.label()
                output << fields["load_started_datetime"    ].web.label()
                output << fields["import_complete_datetime" ].web.label()
                
                output << $tools.div_open("after_load_count")
                phase_complete = 0
                ls = fields["load_started_datetime"]
                if ls.value!="---" && (ls.mathable.strftime("%Y-%m-%d") == DateTime.now.strftime("%Y-%m-%d"))
                    phase_complete   = (!fields['phase_completed'].value.nil? ? fields['phase_completed' ].value.split(",").length : 0)
                end
                phase_total      = (!fields['phase_total'    ].value.nil? ? fields['phase_total'     ].value.split(",").length : 0)
                output << "#{phase_complete}/#{phase_total}"
                output << $tools.div_close()
                
                output << $tools.div_open("status_icon")
                output << colors[status]
                output << $tools.div_close()
                
                output << $tools.newlabel("bottom")
                output << $tools.div_close()
                
                i+=1
                
            end
            
            output << $tools.newlabel("bottom")
            output << $tools.div_close()
            
        else
            
            output << $tools.newlabel("error",    "Did The Database Get Erased...?")
            
        end
        
        output << $tools.div_close
        output << $tools.newlabel("bottom")
        
        return output
        
    end
    
    def close_records_tab(init=false, start_date = nil, end_date = nil)
        
        ########################################################################
        #CREATE A NEW PROCESS RECORD IF THE USER 
        if start_date && end_date
            
            class_name      = "Attendance_Revisions"
            function_name   = "close_attendance"
            args            = "#{start_date},#{end_date}"
            $base.queue_process(class_name, function_name, args)
            
        end
        ########################################################################
        
        output = String.new
        
        output << $tools.newlabel("close_attendance_text", "Close Attendance")
        output << $tools.newdate("start_date", "Start Date:")
        output << $tools.newdate("end_date",   "End Date:")
        output << "<button id='close_attendance' class='execute'>Close Attendance Dates</button>"
        output << $tools.newlabel("bottom")
        
        if init
            return output
        else
            $kit.modify_tag_content("tabs-2", output, "update")
        end
        
    end

    def open_records_tab(init=false, start_date = nil, end_date = nil)
        
        ########################################################################
        #CREATE A NEW PROCESS RECORD IF THE USER 
        if start_date && end_date
            
            class_name      = "Attendance_Revisions"
            function_name   = "close_attendance"
            args            = "#{start_date},#{end_date},false"
            $base.queue_process(class_name, function_name, args)
            
        end
        ########################################################################
        
        output = String.new
        
        output << $tools.newlabel("close_attendance_text", "Close Attendance")
        output << $tools.newdate("start_date", "Start Date:")
        output << $tools.newdate("end_date",   "End Date:")
        output << "<button id='close_attendance' class='execute'>Close Attendance Dates</button>"
        output << $tools.newlabel("bottom")
        
        if init
            return output
        else
            $kit.modify_tag_content("tabs-2", output, "update")
        end
        
    end
    
    def process_queue_tab(init=false)
        
        output = String.new
        
        output << $tools.div_open("pending_process_div", "pending_process_div") if init
        output << $tools.newlabel("pending_text", "Pending Processes")
        output << $tools.div_open("pending_headers")
        output << $tools.newlabel("class_header",        "Group")
        output << $tools.newlabel("function_header",     "Process")
        output << $tools.newlabel("args_header",         "Modified Table")
        output << $tools.newlabel("created_date_header", "Created Date")
        output << $tools.div_close
        
        output << $tools.div_open("process_container")
        output << $tools.div_open("overlay2") << $tools.div_close
        output << $tools.div_open("bgdiv")
        
        pending_processes = $tables.attach("process_log").by_status("NULL")
        
        if pending_processes
            
            pending_processes.each do |process|
                
                fields = process.fields
                fields["args"].value = fields["args"].value.split('<,>').first if !fields["args"].value.nil?
                output << $tools.div_open("list_item")
                output << fields["class_name"].web.label
                output << fields["function_name"].web.label
                output << fields["args"].web.label
                output << fields["created_date"].to_user!.web.label
                output << $tools.div_close
                
            end
            
        end
        
        output << $kit.tools.newlabel("bottom")
        output << $tools.div_close
        output << $tools.div_close
        
        output << $tools.newlabel("completed_text", "Completed Processes")
        output << $tools.div_open("pending_headers")
        output << $tools.newlabel("class_header",        "Group")
        output << $tools.newlabel("function_header",     "Process")
        output << $tools.newlabel("args_header",         "Modified Table")
        output << $tools.newlabel("created_date_header", "Created Date")
        output << $tools.div_close
        
        output << $tools.div_open("process_container")
        output << $tools.div_open("overlay2") << $tools.div_close
        output << $tools.div_open("bgdiv")
        
        completed_processes = $tables.attach("process_log").by_status("Completed")
        
        if completed_processes
            
            completed_processes.each do |process|
                
                fields = process.fields
                fields["args"].value = fields["args"].value.split('<,>').first if fields["args"].value
                output << $tools.div_open("list_item")
                output << fields["class_name"].web.label
                output << fields["function_name"].web.label
                output << fields["args"].web.label
                output << fields["created_date"].to_user!.web.label
                output << $tools.div_close
                
            end
            
        end
        
        output << $kit.tools.newlabel("bottom")
        output << $tools.div_close
        output << $tools.div_close
        output << $kit.tools.newlabel("bottom")
        output << $tools.div_close if init

        if init
            return output
        else
            $kit.modify_tag_content("pending_process_div", output, "update")
        end
        
    end
    
    def upload_form(id, upload_type)
        
        output = String.new
        output << "<form id='#{id}' name='form' action='D20130906.rb' method='POST' enctype='multipart/form-data' >"
        output << "<INPUT type='hidden' name='upload_type' value='#{upload_type}'>"
        output << $tools.kmailinput("authorizor", "Authorizor:")
        output << $tools.newtextarea("reason", "Reason:")
        output << $tools.csv_upload(self.class.name, id, "120")
        output << "<input class='submit_button' type='button' name='action' value='Start Process' onclick='redirect_submit(\"#{id}\")'/>"
        output << "</form>"
        output << $tools.newlabel("bottom")
        
        return output
    end
    
    def bulk_overall_mode
        
        return upload_form("upload_form_overall_mode", "change_overall_mode")
    
    end
    
    def bulk_daily_mode
        
        return upload_form("upload_form_daily_mode", "change_daily_mode")
    
    end
    
    def bulk_daily_code
        
        return upload_form("upload_form_daily_code", "change_daily_code")
    
    end
    
    def save_bulk_modification_request(table)
        
        i=1
        
        length = CSV.parse(@csv).first.length
        
        while i < length
            
            new_row = $tables.attach("Bulk_Modification_Requests").new_row
            fields = new_row.fields
            fields["table"        ].value = table
            fields["field"        ].value = CSV.parse(@csv).first[i]
            fields["reason"       ].value = @reason
            fields["authorized_by"].value = @authorizor
            new_row.save
            i+=1
            
        end
        
    end
    
    def bulk_daily_code_queue_process
        
        output = String.new
        
        table = "Student_Attendance_Master"
        
        begin
            
            filePath = $reports.save_document({:category_name=>"Attendance", :type_name=>"Bulk Change - Daily Code", :csv_rows=>@csv})
            
        rescue
            
            output << "Failed to parse and upload csv to Athena<br>"
            
        end

        save_bulk_modification_request(table)
        
        i=1
        
        CSV.parse(@csv) do |row|
            sid = row[0]
            row_length = row.length
            if i==1 && row[0] == "student_id"
                j = 1
                while j < row.length
                    code_date_header = row[j].split("_")
                    if code_date_header.length == 2
                        if $school.school_days.include?(code_date_header.last)
                            j+=1
                            next
                        else
                            output << "Header \"#{row[j]}\" is not a valid school day for the #{$config.school_year} SY, or is an invalid date format (Required:yyyy-mm-dd).<br>"
                        end
                    else
                        output << "Header \"#{row[j]}\" needs to start with \"code_\" followed by the date in (yyyy-mm-dd) format.<br>"
                    end
                    j+=1
                end
                i+=1
                next
            elsif i==1 && row[0] != "student_id"
                output << "Header \"student_id\" is required in column 1.<br>"
            elsif row[0].nil?
                output << "Warning: Blank id at row #{i}.<br>"
            elsif !row[0].match(/^[0-9]+$/)
                output << "Warning: '#{row[0]}' at line #{i} is not a number.<br>"
            elsif !$students.attach(row[0]).exists?
                output << "Warning: SID ##{sid} at line #{i} is not an existing Student ID.<br>"
            elsif !$tables.attach("student_attendance_master").by_studentid(sid)
                output << "Warning: SID ##{sid} at line #{i} does not have a student attendance master record<br>"
            end
            if i!=1
                j = 1
                override_codes = $tables.attach("ATTENDANCE_CODES").find_fields("code", "WHERE overrides_procedure IS TRUE", {:value_only=>true}) || []
                while j < row.length
                    if !row[j].nil?
                        row[j].chomp!(" ")
                        if !$tables.attach("ATTENDANCE_CODES").find_fields("code", nil, {:value_only=>true}).include?(row[j])
                            output << "Warning: '#{row[j]}' at line #{i} is not a valid code.<br>"
                        end
                        if !override_codes.include?(row[j]) #if a code is not an override code, it will just be reprocessed on upload
                            output << "Warning: '#{row[j]}' at line #{i} must be replaced with a valid override code. (Overide codes are: #{override_codes.join(",")})<br>"
                        end
                    end
                    j+=1
                end
            end
            i+=1
        end
        
        if output == ""
            new_filePath = convert_sid_to_pid(table, filePath)
            $base.queue_process(
                "Change_Field_By_Pid",
                "bulk_change",
                "#{table}<,>#{@authorizor}<,>#{@reason}<,>#{new_filePath.split("/").last}")
            output = "Process queued successfully.  Your changes will take place as part of the next automatic cycle."
            output << "<success>"
        else
            output << "Please make corrections to the csv and try again."
        end
        $kit.output = output
    end
    
    def bulk_daily_mode_queue_process
        
        output = String.new
        
        table = "Student_Attendance"
        
        begin
            
            filePath = $reports.save_document({:category_name=>"Attendance", :type_name=>"Bulk Change - Daily Mode", :csv_rows=>@csv})
            
        rescue
            
            output << "Failed to parse and upload csv to Athena<br>"
            
        end

        save_bulk_modification_request(table)
        
        i=1
        CSV.parse(@csv) do |row|
            sid = row[0]
            row_length = row.length
            if i==1 && row[0] == "student_id"
                j = 1
                while j < row.length
                    if $school.school_days.include?(row[j])
                        j+=1
                        next
                    else
                        output << "Header \"#{row[j]}\" is not a valid school day or date format (yyyy-mm-dd).<br>"
                    end
                    j+=1
                end
                i+=1
                next
            elsif i==1 && row[0] != "student_id"
                output << "Header \"student_id\" is required in column 1.<br>"
            elsif row[0].nil?
                output << "Warning: Blank id at row #{i}.<br>"
            elsif !row[0].match(/^[0-9]+$/)
                output << "Warning: '#{row[0]}' at line #{i} is not a number.<br>"
            elsif !$students.attach(row[0]).exists?
                output << "Warning: SID ##{sid} is not an existing Student ID.<br>"
            elsif !$tables.attach("student_attendance_master").by_studentid(sid)
                output << "Warning: SID ##{sid} at line #{i} does not have a student attendance master record<br>"
            end
            if i!=1
                j = 1
                while j < row.length
                    if !$tables.attach("Attendance_Modes").modes_array.include?(row[j])
                        output << "Warning: '#{row[j]}' at line #{i} is not a valid mode.<br>"
                    end
                    j+=1
                end
            end
            i+=1
        end
        
        if output == ""
            new_filePath = convert_sid_to_pid_one_to_many(table, "mode", filePath)
            
            if new_filePath.is_a? Array
               output = "The id's (#{new_filePath.join(", ")}) are not eligible for this process.<br>Please make corrections to the csv and try again." 
            else
                $base.queue_process(
                    "Change_Field_By_Pid",
                    "bulk_change",
                    "#{table}<,>#{@authorizor}<,>#{@reason}<,>#{new_filePath.split("/").last}")
                output = "Process queued successfully.  Your changes will take place as part of the next automatic cycle."
                output << "<success>"
            end
        else
            output << "Please make corrections to the csv and try again."
        end
        $kit.output = output
    end
    
    def bulk_overall_mode_queue_process
        
        output = String.new
        
        table  = "Student_Attendance_Mode"
        
        begin
            
            filePath = $reports.save_document({:category_name=>"Attendance", :type_name=>"Bulk Change - Overall Mode", :csv_rows=>@csv})
            
        rescue
            
            output << "Failed to parse and upload csv to Athena<br>"
            
        end
        
        save_bulk_modification_request(table)
        
        i=1
        
        CSV.parse(@csv) do |row|
            sid = row[0]
            if i==1 && row[0] == "student_id"
                if row[1] != "attendance_mode"
                    output << "Header \"attendance_mode\" is required in column 2.<br>"
                end
                i+=1
                next
            elsif i==1 && row[0] != "student_id"
                output << "Header \"student_id\" is required in column 1.<br>"
            elsif row[0].nil?
                output << "Warning: Blank id at row #{i}.<br>"
            elsif !row[0].match(/^[0-9]+$/)
                output << "Warning: '#{row[0]}' at line #{i} is not a number.<br>"
            elsif !$students.attach(row[0]).exists?
                output << "Warning: SID ##{sid} is not an existing Student ID.<br>"
            elsif !$tables.attach("student_attendance_mode").by_studentid(sid)
                output << "Warning: SID ##{sid} at line #{i} does not have a student attendance mode record<br>"
            end
            if !$tables.attach("Attendance_Modes").modes_array.include?(row[1])
                output << "Warning: '#{row[1]}' at line #{i} is not a valid mode.<br>"
            end
            i+=1
        end
        
        if output == ""
            new_filePath = convert_sid_to_pid(table, filePath)
            $base.queue_process(
                "Change_Field_By_Pid",
                "bulk_change",
                "#{table}<,>#{@authorizor}<,>#{@reason}<,>#{new_filePath.split("/").last}")
            output = "Process queued successfully.  Your changes will take place as part of the next automatic cycle."
            output << "<success>"
        else
            output << "Please make corrections to the csv and try again."
        end
        $kit.output = output
    end
    
    def validation_check
        
        validation_string = String.new
        
        validation_string << "You did not add an authorizor.<br>"          if !@authorizor
        validation_string << "You did not add a reason.<br>"               if !@reason
        validation_string << "You did not choose a csv file.<br>"          if !@csv
        
        $kit.output = validation_string
        
    end  

    
    def convert_sid_to_pid(table, csv_path)
        converted_csv = Array.new
        CSV.open(csv_path, "r").each do |row|
            new_row = row
            if row.first == "student_id"
                new_row[0] = "pid"
            else
                sid = row.first
                pid = $tables.attach(table).by_studentid(sid).primary_id
                new_row[0] = pid
            end
            converted_csv.push(new_row)
        end
        return $reports.save_document({:category_name=>"Athena", :type_name=>"Converted SID To PID CSV", :csv_rows=>converted_csv})
    end
    
    def convert_sid_to_pid_one_to_many(table, field, csv_path)
        error_array   = Array.new
        converted_csv = Array.new
        field_headers = Array.new
        CSV.open(csv_path, "r").each do |row|
            if row.first == "student_id"
                new_row = Array.new
                row.delete_at(0)
                field_headers = row
                new_row[0] = "pid"
                new_row[1] = field
                converted_csv.push(new_row)
            else
                sid = row.first
                field_headers.each_with_index do |field_name, i|
                    new_row = Array.new
                    begin
                        pid = $tables.attach(table).by_studentid(sid, "WHERE date='#{field_name}'")[0].primary_id
                        new_row[0] = pid
                        new_row[1] = row[i+1]
                        converted_csv.push(new_row)
                    rescue
                        error_array.push(sid)
                    end
                end
            end
        end
        if !error_array.empty?
            
            return error_array
            
        else
            
            return $reports.save_document({:category_name=>"Athena", :type_name=>"Converted SID To PID CSV", :csv_rows=>converted_csv})
            
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_attendance_sources
        
        output = String.new
        
        table_array = [
            
            #HEADERS
            [
                "source"        ,
                "type"          ,
                "eligible grades"   
            ]
            
        ]
      
        record = $tables.attach("ATTENDANCE_SOURCES").new_row
        
        row = Array.new
     
        row.push(record.fields["source" ].web.text()                                                    )
        row.push(record.fields["type"   ].web.select(:dd_choices=>source_type_dd)  )
        
        grades = Array.new
        grades.push(["K","1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th"])  
        grades.push(
            [
                record.fields["grade_k"       ].web.default(),
                record.fields["grade_1st"     ].web.default(),
                record.fields["grade_2nd"     ].web.default(),
                record.fields["grade_3rd"     ].web.default(),
                record.fields["grade_4th"     ].web.default(),
                record.fields["grade_5th"     ].web.default(),
                record.fields["grade_6th"     ].web.default(),
                record.fields["grade_7th"     ].web.default(),
                record.fields["grade_8th"     ].web.default(),
                record.fields["grade_9th"     ].web.default(),
                record.fields["grade_10th"    ].web.default(),
                record.fields["grade_11th"    ].web.default(),
                record.fields["grade_12th"    ].web.default()
            ]
        )
        
        grades_included = $tools.table(
            :table_array    => grades,
            :unique_name    => "eligible_grades",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        row.push(grades_included)
        
        table_array.push(row) 
        
        output << $kit.tools.data_table(table_array, "ATTENDANCE_MODES", type = "NewRecord")
        
        return output
        
    end

    def add_new_record_attendance_modes
        
        output = String.new
        
        table_array = [
            
            #HEADERS
            [
                "mode"              ,
                #"sources"           ,
                "description"       ,
                "procedure_type"
                
            ]
            
        ]
      
        record = $tables.attach("ATTENDANCE_MODES").new_row
        
        row = Array.new
        row.push(record.fields["mode"               ].web.text())
        #row.push(record.fields["sources"            ].web.text())
        row.push(record.fields["description"        ].web.default())
        row.push(record.fields["procedure_type"     ].web.radio(:radio_choices=>procedure_type_dd))
        
        table_array.push(row) 
        
        output << $kit.tools.data_table(table_array, "ATTENDANCE_MODES", type = "NewRecord")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def procedure_type_dd
        $dd.from_array(
            [  
                "Activity"                              ,
                "Activity AND Live Sessions"            ,
                "Activity OR Live Sessions"             ,
                "Classroom Activity (50% or more)"      ,
                "Live Sessions"                         ,
                "Manual (default a)"                    ,
                "Manual (default p)"                    ,
                "Not Enrolled"                          ,
                "Override Procedure"                    
            ]
        )
    end

    def source_type_dd
        $dd.from_array(
            [
                "Live"              ,
                "Activity"          ,
                "Classroom Activity"
            ]
        )
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        output << "
        
        "
        output << "</script>"
        return output
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        div.type_icons      {display: inline-block; float: right;}
        div.type_icons img  {display: inline-block;}
        div.type_icons span {display: inline-block;}
        
        div.ATTENDANCE_MODES__description textarea{
            width: 300px;
            height: 50px;
        }
        div.ATTENDANCE_MODES__procedure_type{
            width: 300px;
        }
        
        body{                                           font-size: .8em !important;}
        #tabs_{                                         margin-bottom:10px;}
        #search_dialog_button{                          display:none;}
        
        div.report_status{                              float:left; clear:left; margin-bottom:1px; margin-left:10px; font-size:1.2em;}
        
        div.main_div{                                   width:850px;}
        div.status_container{                           float:left; clear:left; margin-left:10px; border:1px solid #386E8B; border-radius: 5px 5px; margin-bottom:20px;}
        div.overlay{                                    box-shadow: inset 1px 0px 15px #869BAC; width:848px; height:180px; top:131px; position:absolute; pointer-events: none;}
        div.headers{                                    float:left; color:white; background-color:#386E8B; width:100%;}
        div.row{                                        float:left; width:100%; height:40px; padding-top:10px;}
        div#row0{                                       background-color:#EEF0F1;}
        div#row1{                                       background-color:#F2F5F6;}
        div.name_header{                                float:left; width:245px; font-weight:bold; margin-left:5px; clear:left;}
        div.DB_CONFIG__table_name{                      float:left; width:245px; clear:left; margin-top:8px; margin-left:5px;}
        div.time_header{                                float:left; width:170px; font-weight:bold;}
        div.DB_CONFIG__import_schedule{                 float:left; width:170px; margin-top:8px;}
        div.start_header{                               float:left; width:120px; text-align:center; font-weight:bold;}
        div.DB_CONFIG__load_started_datetime{           float:left; width:120px; text-align:center; min-height:35px;}
        div.complete_header{                            float:left; width:140px; text-align:center; font-weight:bold;}
        div.DB_CONFIG__import_complete_datetime{        float:left; width:140px; text-align:center; min-height:35px;}
        div.afterload_total{                            float:left; width:80px;  text-align:center; font-weight:bold;}
        div.after_load_count{                           float:left; width:80px;  text-align:center; margin-top:8px;}
        div.status_header{                              float:left; width:75px;  text-align:center; font-weight:bold;}
        div.status_icon{                                float:left; width:75px;  text-align:center;}
        
        button{                                         float:left; clear:left; margin-bottom:15px; margin-left:10px;}
        
        div.close_attendance_text{                      float:left; clear:left; margin-left:10px; margin-bottom:10px; font-size:1.2em;}
        div.start_date{                                 float:left; clear:left; margin-left:10px; margin-bottom:5px;}
        div.end_date{                                   float:left; clear:left; margin-left:10px; margin-bottom:10px;}
        
        div.start_date label{                           display:inline-block; width:100px;}
        div.end_date label{                             display:inline-block; width:100px;}
        
        div.pending_text{                               float:left; clear:left; margin-left:10px; margin-bottom:1px; font-size:1.2em;}
        div.pending_headers{                            float:left; clear:left; color:white; background-color:#386E8B; width:852px; margin-left:10px; border-radius: 5px 5px 0 0;}
        div.class_header{                               float:left; width:200px; font-weight:bold; margin-left:15px;}
        div.function_header{                            float:left; width:200px; font-weight:bold;}
        div.args_header{                                float:left; width:200px; font-weight:bold;}
        div.created_date_header{                        float:left; width:200px; font-weight:bold;}
        div.completed_text{                             float:left; clear:left; margin-left:10px; margin-bottom:1px; font-size:1.2em;}
        div.process_container{                          float:left; clear:left; width:850px; height:200px; margin:0px 0px 20px 10px; border:1px solid #386E8B; border-radius: 0 0 5px 5px; overflow-y:scroll;}
        div.bgdiv{                                      background:url('/athena/images/row_separator_25px.png') repeat left top; min-height:200px;}
        div.list_item{                                  float:left; clear:left; margin:5px 15px; height:15px;}
        div.PROCESS_LOG__class_name{                    float:left; width:200px; min-height:1px; clear:left;}
        div.PROCESS_LOG__function_name{                 float:left; width:200px; min-height:1px;}
        div.PROCESS_LOG__args{                          float:left; width:200px; min-height:1px;}
        div.PROCESS_LOG__created_date{                  float:left; width:200px; min-height:1px;}
        
        div.reason{                             float:left; clear:left; margin-bottom:10px;}
        div.authorizor{                         float:left; clear:left; margin-bottom:10px;}
        
        input.csv_upload{                       float:left; clear:left; margin-bottom:10px;}
        div.csv_info{                           float:left; margin-top:2px; margin-left:15px; font-size:.8em;}
        input.submit_button{                    float:left; clear:left; margin-bottom:10px;}
        
        div.authorizor label{                   display:inline-block; width:100px;}
        div.reason label{                       display:inline-block; width:100px; vertical-align:top;}
        
        textarea{                               width:600px; height:100px; resize:none; overflow-y:scroll}
                
        iframe{                                 float:right; display:none;}
        #search_dialog_button{                  display:none;}
        "
        output << "</style>"
        return output
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
    def format_fields(fields)
        date_today = DateTime.now.strftime("%Y-%m-%d")
        fields["table_name"     ].value = fields["table_name"     ].value.split("_").map{|w| w.capitalize }.join(" ")
        
        if sch = fields["import_schedule"].value
            fields["import_schedule"].value = sch.split(";").map{|t| DateTime.parse(t).strftime("%I:%M %p")}.join(", ") 
        else
            fields["import_schedule"].value = "Not Scheduled"
        end
        
        if fields["load_started_datetime"].value
            load_started_datetime = fields["load_started_datetime"].value
            load_started_date     = fields["load_started_datetime"   ].value.split(" ").first
        else
            load_started_datetime = "0000-00-00 00:00:00"
            load_started_date     = false
        end
        if fields["import_complete_datetime"].value
            import_complete_datetime = fields["import_complete_datetime"].value
            import_complete_date     =fields["import_complete_datetime"].value.split(" ").first
        else
            import_complete_datetime = "0000-00-00 00:00:00"
            import_complete_date     = false
        end
        if load_started_date == date_today
            fields["load_started_datetime"].to_user!
        else
            fields["load_started_datetime"].value = "---"
        end
        if import_complete_date == date_today && import_complete_datetime >= load_started_datetime
            fields["import_complete_datetime"].to_user!
        else
            fields["import_complete_datetime"].value = "---"
        end
        
        return fields
    end
 
    def status_color(fields)
        
        ########################################################################
        #DID THE IMPORT START TODAY?
        ls = fields["load_started_datetime"]
        load_started = (!ls.value.nil? ? (ls.mathable.strftime("%Y-%m-%d") == DateTime.now.strftime("%Y-%m-%d")) : false)
        ########################################################################
        
        ########################################################################
        #DID THE IMPORT COMPLETE TODAY?
        lc = fields["import_complete_datetime"]
        load_completed = lc.value ? (lc.mathable > ls.mathable) : false
        ########################################################################
        
        ########################################################################
        #WAS THERE AN ERROR AFTER THE IMPORT STARTED?
        err = fields["last_error_datetime"]
        if err.value && (DateTime.now.strftime("%Y-%m-%d") <= err.mathable.strftime("%Y-%m-%d"))
            errored_out = err.value ? (ls.mathable < err.mathable) : false
        end
        ########################################################################
        
        ########################################################################
        #DID ALL AFTER LOAD PHASES GET COMPLETED?
        phase_tot = fields["phase_total"].value
        phase_com = fields["phase_completed"].value
        completed_after_load = (phase_tot && phase_com) ? (phase_tot.split(",").length == phase_com.split(",").length) : false
        ########################################################################
        
        if errored_out
            color   = "red"
            
        elsif !load_started
            color   = "gray"
            
        elsif load_started && load_completed
            color   = "green"
            @com_tables += 1
            
        elsif load_started && !load_completed
            color   = "yellow"
            
        else
            color = "red"
        end
        
        return color
        
    end
    
end