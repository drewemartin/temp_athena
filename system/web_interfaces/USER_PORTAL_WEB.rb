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
        
        $kit.output << "<div class='menu_buttons_container'>"
        
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
            
            :button_text        => "Login Reminders Reports",
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
        
        $kit.output << "</div>"
        
        tabs_arr = Array.new
        
        working_list_pages = [
            
            "TEAM_MEMBER_RECORD_WEB",
            "STUDENT_ATTENDANCE_AP_WEB",
            "TEST_EVENT_SITE_WEB",
            #"WITHDRAW_REQUESTS_WEB",
            
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
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

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