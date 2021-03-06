#!/usr/local/bin/ruby


class USER_PORTAL_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
       
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Athena School Information System"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    def load_testing_file_tree
        $kit.output << $tools.file_tree(:file_path=>"/athena_files/reports/k12_reports/agora_omnibus/")
    end
    
    def load
        
        $kit.output << "<style>
            
            button.new_breakaway_button {
                width: 150px;
                font-size: xx-small !important;
            }
            button.module_bar {
                
            }
            div.menu_buttons_container {
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
                margin-bottom:30px;
            }
            
        </style>"
        
        $kit.output << "<div id='school_year_container' name='school_year_container'>#{$base.school_year_select}</div>"
        #$kit.output << "<div id='sy_warning'><b>The new 2014-2015 SY has been created in Athena. If you are looking for information that was entered in last year's database, you will need to change the school year in the drop down to the right >>>>>>>>></b></div>"
        
        $kit.output << "<div class='menu_buttons_container'>"
        
        #SEARCH ALL TEAM MEMBERS
        if $team_member.super_user? || $team_member.rights.team_search.is_true?
            $kit.output << "<button class='new_breakaway_button' id='team_search_dialog_button'>Team Search</button>#{team_search}"
        end
        
        #SEARCH ALL STUDENTS
        if $team_member.super_user? || $team_member.rights.student_search.is_true?
            $kit.output << "<button class='new_breakaway_button' id='student_search_dialog_button'>Student Search</button>#{student_search}"
        end 
      
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Attendance Admin",
            :page_name          => "ATTENDANCE_ADMIN_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.attendance_admin_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Athena Projects",
            :page_name          => "ATHENA_PROJECT_MANAGEMENT_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.athena_projects_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Course Relate",
            :page_name          => "COURSE_RELATE_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.course_relate_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Student Test Events",
            :page_name          => "STUDENT_TEST_EVENTS_ADMIN_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.test_event_admin_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Live Reports",
            :page_name          => "LIVE_REPORTS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.live_reports_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Mass Kmail",
            :page_name          => "KMAIL_UPLOAD_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.kmail_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Districts Admin",
            :page_name          => "DISTRICTS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.districts_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Withdrawal Processing",
            :page_name          => "WITHDRAWAL_PROCESSING_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.withdrawal_processing_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "RTII Behavior Vault",
            :page_name          => "RTII_BEHAVIOR_VAULT_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.rtii_behavior_vault_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "School Year Setup",
            :page_name          => "SCHOOL_YEAR_SETUP_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Enrollment Reports",
            :page_name          => "ENROLLMENT_REPORTS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.enrollment_reports_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "K12 Reports",
            :page_name          => "K12_REPORTS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.k12_reports_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Attendance Reports",
            :page_name          => "LOGIN_REMINDERS_REPORTS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.login_reminders_reports_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "ILP Vault",
            :page_name          => "ILP_VAULT_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.ilp_vault_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Record Requests Admin",
            :page_name          => "STUDENT_RECORD_REQUESTS_ADMIN_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.student_record_requests_admin_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Sapphire Data Management",
            :page_name          => "SAPPHIRE_DATA_MANAGEMENT_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.sapphire_data_management_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Schools Directory",
            :page_name          => "SCHOOLS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.schools_access.is_true?
        
        $kit.output << $tools.breakaway_button(
            
            :button_text        => "Test Packets",
            :page_name          => "TEST_PACKETS_WEB",
            :additional_params  => nil,
            :class              => "module_bar"
            
        ) if $team_member.super_user? || $team_member.rights.test_packets_access.is_true?
        
        $kit.output << "</div>"
        
        tabs_arr = Array.new
        
        working_list_pages = [
            
            "TEAM_MEMBER_RECORD_WEB",
            #"STUDENT_ATTENDANCE_AP_WEB",
            "TEST_EVENT_SITE_WEB",
            #"WITHDRAW_REQUESTS_WEB",
            "STUDENT_RECORDS_INCOMING_WEB"
            
        ]
        #Dir["#{$paths.web_interfaces_path}*.rb"].each {|file|
            
            #x = file.split("/").last.split(".").first
            
        working_list_pages.each{|page|
            require "#{File.dirname(__FILE__)}/#{page}"
            page = Object.const_get(page).new();
            if page.respond_to?("working_list")
                
                working_list_arr = page.working_list
                working_list_arr.each{|working_list|
                    
                    tabs_arr.push(
                        
                        [
                            working_list[:name],
                            working_list[:content]
                        ]
                        
                    )
                    
                } if working_list_arr
                
            end
            
        }
        
        $kit.output = $kit.tools.tabs(tabs_arr)
        
    end
    
    def response
        
        if $kit.params[:refresh] == "tabs_rri"
            
            $kit.modify_tag_content("rri_wl",web_script_funtion("STUDENT_RECORDS_INCOMING_WEB", "working_list", "true"), "update")
            
        end
        
    end
    
    def web_script_funtion(page, function_str, args = nil)
        
        output = String.new
        
        web_script = $kit.web_script_alt_page(page)
        
        if web_script.respond_to?(function_str)
            
            if args
                output =  web_script.send(function_str, args)
            else
                output =  web_script.send(function_str)
            end
            
        end
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_pdf_rri_labels(pids)
        
        pids = pids.split(",")
        
        template = "RECORD_REQUESTS_LABELS_PDF.rb"
        
        Prawn::Document.generate "#{$paths.htdocs_path}temp/rr_labels_temp#{$ifilestamp}.pdf" do |pdf|
            require "#{$paths.templates_path}pdf_templates/#{template}"
            template = eval("#{template.gsub(".rb","")}.new")
            template.generate_pdf(pids, pdf)
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_student_rri_recipients
     
        $kit.web_script(new_page = "STUDENT_RECORDS_INCOMING_WEB")
        $kit.add_new_record
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def student_search
        
        dlg_string      = String.new
        search_params   = String.new
        
        dlg_string << "<div id='student_search_fields'>"
        searchable_fields = [
            "student_id:Student ID:text",
            "studentfirstname:First Name:text",
            "studentlastname:Last Name:text",
            "familyid:Family ID:text",
            "grade:Grade:text",
            "active:Active:checkbox"
        ]
        fields = $tables.attach("STUDENT").new_row.fields
        searchable_fields.each{|field_details|
            field_name      = field_details.split(":")[0]
            label           = field_details.split(":")[1]
            field_type      = field_details.split(":")[2]
            dlg_string      << fields[field_name].web.send(field_type,{:search=>true, :label_option=>"#{label}:"})
            html_field_id   = fields[field_name].web.field_id(:search=>true)
            search_params   << (search_params.empty? ? html_field_id : ",#{html_field_id}")
        }
        dlg_string << "<button id='student_search_button' type='button' onclick=\"send('#{search_params}');\"></button>"
        dlg_string << "<button id='clear_student_search_button' type='button'></button>"
        dlg_string << "</div>"
        dlg_string << "<div id='student_search_results'></div>"
        dlg_string << "</div>"
        dlg_string.insert(0, "<div id='student_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return dlg_string
        
    end
    
    def team_search
        
        dlg_string      = String.new
        search_params   = String.new
        
        dlg_string << "<div id='team_search_fields'>"
        searchable_fields = [
            "primary_id:Team ID",
            "legal_first_name:First Name",
            "legal_last_name:Last Name"     
        ]
        fields = $tables.attach("TEAM").new_row.fields
        searchable_fields.each{|field_details|
            field_name      = field_details.split(":")[0]
            label           = field_details.split(":")[1]
            dlg_string      << fields[field_name].web.text(:search=>true, :label_option=>"#{label}:")
            html_field_id   = fields[field_name].web.field_id(:search=>true)
            search_params   << (search_params.empty? ? html_field_id : ",#{html_field_id}")
        }
        dlg_string << "<button id='team_search_button' type='button' onclick=\"send('#{search_params}');\"></button>"
        dlg_string << "<button id='clear_team_search_button' type='button'></button>"
        dlg_string << "</div>"
        dlg_string << "<div id='team_search_results'></div>"
        dlg_string << "</div>"
        dlg_string.insert(0, "<div id='team_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return dlg_string
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS 
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            html{                               overflow-y:auto !important;}
            
            div.student_contacts_container{     width:1050px;}
            #new_row_button_STUDENT_CONTACTS{   float:right; font-size: xx-small !important;}
            div.student_page_view{              position:absolute; right:20px; top:47px;}
            div.DTTT_print_info{                top:300px !important; position:absolute !important;}
            table.dataTable td{                 text-align: center;}
            div.menu_buttons_container{         clear:both;}
            div#school_year_container{          float:right; margin-bottom:10px; margin-right:10px; size:1.1em; padding-bottom: 2em; padding-right: 2.5em;}
            
            div.STUDENT_RRI_REQUESTS__notes                      textarea {width:170px; height:50px; resize:none; overflow-y:scroll; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes           textarea {width:170px; height:50px; resize:none; overflow-y:scroll; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  input    {width:70px; float:left;}
            div.STUDENT_RRI_REQUESTS__requested_date             input    {width:70px;}
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes           label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes        textarea {float:left; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes                 {float:left; width:250px; }
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed        {float:left; clear:left; width:250px; margin-bottom:5px;}
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status  label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status select {float:left; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status        {float:left; clear:left; width:250px; margin-bottom:5px;}
            
            #request_details td {text-align:left !important;}
            
            #new_pdf_button{margin-bottom:5px; margin-right:10px;}
            
            #refresh__tabs_rri{margin-top:1px; margin:bottom:5px;}
            
            #sy_warning{ float:right; margin-right:10px; color:red; border:2px solid red; padding:2px; width:850px;}
            
        "
        #    div.student_page_view{              background-color:#3BAAE3; border-radius:5px; color:white; padding:5px; margin-bottom:10px;}
        #
        #"
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end