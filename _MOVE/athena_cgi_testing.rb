#!C:/Users/Parnassus/athena-sis/Ruby187/bin/ruby.exe
require 'cgi'

Dir["#{File.dirname(__FILE__)}/system/web_interfaces/*.rb"].each {|file|
    x = file.split("/").last.split(".").first
    require File.dirname(__FILE__).gsub("cgi-bin", "htdocs/athena/system/web_interfaces/#{x.downcase}")
}
if false
    puts "Content-type: text/html"
    puts ""
    puts "<html><head></head><body>test"
end

require File.dirname(__FILE__).gsub("cgi-bin","htdocs/athena/system/base/base")

class ATHENA_CGI_TESTING < Base

    #---------------------------------------------------------------------------
    def initialize(params)
        super() 
        
        $kit                    = self
        $tools                  = $kit.tools
        $dd                     = dd 
        
        @modify_tag_content     = nil
        @structure              = nil
        self.params             = defrost(params)
        
        self.user_log_record
        
        #THIS ERROR HANDLING IS REMOVED IN ATHENA TESTING
        #begin
            
            ########################################################################
            #  MAINTENANCE  ########################################################
            if false && self.user == "jhalverson@agora.org"
                self.user = "tkreider@agora.org"
                self.testing
            end
            
            if false && self.user == "esaddler@agora.org"
                self.user = "mtrobman@agora.org"
                self.testing
            end
            
            if false && self.user == "jhalverson@agora.org"
                self.testing
            end
            ########################################################################
            #######################################################################
            
            if user_validated?
                
                ########################################################################
                #  MAINTENANCE  ########################################################
                if false# &&  self.user != "jhalverson@agora.org"
                    
                    self.web_error.down_for_maintenance
                    puts self.output
                    
                    return true
                    
                end####################################################################
                #######################################################################
                
                if params[:sid] || params[:student_id]
                    
                    if params[:sid]
                        
                        $focus_student = $students.get(params[:sid])
                        
                    elsif params[:student_id]
                        
                        $focus_student = $students.get(params[:student_id]  )
                        
                    end
                    
                else
                    
                    $focus_student = nil
                    
                end
                
                $focus_team_member  = params[:tid] ? $team.get(params[:tid])     : nil
                
                $team_member        = $team.by_team_email($kit.user)
                
                if !$focus_student
                    rows.each_pair{|k,v|
                        this_table = $tables.attach(v.table.table_name)
                        if this_table.field_order.include?("student_id")
                            record = this_table.by_primary_id(v.primary_id)
                            if record
                                $focus_student = $students.get(record.fields["student_id"].value)
                            end
                        end
                    }
                end
                
                if !$focus_team_member
                    rows.each_pair{|k,v|
                        
                        this_table = $tables.attach(v.table.table_name)
                        if (base_table = v.table.table_name == "team") || this_table.field_order.include?("team_id")
                            
                            record = this_table.by_primary_id(v.primary_id)
                            if record
                                this_member_id      = base_table ? record.primary_id : record.fields["team_id"].value
                                $focus_team_member  = $team.get(this_member_id)
                            end
                            
                        elsif this_table.field_order.include?("staff_id")
                            
                            record = this_table.by_primary_id(v.primary_id)
                            if record
                                sams_id             = record.fields["staff_id"].value
                                $focus_team_member  = $team.by_sams_id(sams_id)
                            end
                            
                        end
                        
                    }
                end
                
                save            unless (load? || fill_select_option?)
                search_results  unless (load? || fill_select_option?)
                
                if load?
                    
                    web_script.load
                 
                elsif func_string = tab_load_requested?
                    
                    if web_script.respond_to?(func_string)
                        
                        arg         = params[func_string]
                        tab_number  = func_string.to_s.split("_")[-1]
                        content     = web_script.send(func_string, arg)
                        
                        $kit.modify_tag_content(
                            "tabs-#{tab_number}",
                            content+$tools.newlabel("bottom")
                        )
                        
                    end
                    
                elsif expand_function = expandable?
                    
                    expansion_arr    = params[expand_function].split(":")
                    expansion_cls    = expansion_arr[0]
                    expansion_arg    = expansion_arr[1]
                    
                    require File.dirname(__FILE__).gsub("cgi-bin", "htdocs/athena/system/web_interfaces/#{expansion_cls}")
                    script = Object.const_get(expansion_cls.upcase).new();
                    
                    this_function = expand_function.to_s.split("_")
                    this_function.pop
                    this_function = this_function.join("_")
                    if expansion_arg
                        content = script.send(this_function,expansion_arg)
                    else
                        content = script.send(this_function)
                    end
                    
                    $kit.modify_tag_content(
                        "content_div_#{expand_function}",
                        content+$tools.newlabel("bottom")
                    )
                 
                elsif (fill_select_option_id = fill_select_option?)
                    
                    if fill_select_option_id.to_s.include?("__")
                        func_str    = "fill_select_option_"+fill_select_option_id.to_s.split("__").pop()
                    else
                        func_str    = fill_select_option_id
                    end 
                    
                    pid         = fill_select_option_id.to_s.split("__")[1]
                    field_name  = params[fill_select_option_id.to_sym].split(":")[0]
                    field_value = params[fill_select_option_id.to_sym].split(":")[1]
                    if web_script.respond_to?(func_str)
                        
                        $kit.modify_tag_content(
                            fill_select_option_id.to_s.gsub("fill_select_option_",""),
                            web_script.send(func_str, field_name, field_value, pid)
                        )
                     
                    elsif params[:student_page_view] && web_script_alt_page(params[:student_page_view]).respond_to?(func_str)
                        
                        $kit.modify_tag_content(
                            fill_select_option_id.to_s.gsub("fill_select_option_",""),
                            web_script_alt_page(params[:student_page_view]).send(func_str, field_name, field_value, pid)
                        )
                        
                    end
                    
                elsif params[:accordion_doctype]
                    load_accordion_links
                    
                elsif params[:refresh_requested]
                    refresh
                    
                elsif params[:new_breakaway]
                    add_new_breakaway
                  
                elsif params[:new_csv]
                    structure[:output] = add_new_csv
                    
                elsif params[:view_pdf]
                    view_new_pdf
                    
                elsif params[:doc_id]
                    load_secure_document
                    
                elsif params[:upload_pdf]
                    
                    output = String.new
                    
                    func = params[:upload_pdf].split("ARGV")[0]
                    args = params[:upload_pdf].split("ARGV").length > 1 ? params[:upload_pdf].split("ARGV")[1] : params[:upload_pdf].split("ARGV")[1]
                    
                    function_str = "upload_pdf_#{func}"
                    
                    if web_script.respond_to?(function_str)
                       
                        if args
                            output <<  web_script.send(function_str, args)
                        else
                            output <<  web_script.send(function_str)
                        end
                      
                    end
                    
                    $kit.modify_tag_content("upload_new_pdf_#{func}", output, "update")
                    
                elsif params[:upload_doc]
                    
                    output = String.new
                    
                    func = params[:upload_doc]
                    
                    function_str = "upload_doc_#{func}"
                    
                    if web_script.respond_to?(function_str)
                       
                        if params[:sid]
                            output <<  web_script.send(function_str, params[:sid])
                        elsif params[:tid]
                            output <<  web_script.send(function_str, params[:tid])
                        else
                            output <<  web_script.send(function_str)
                        end
                      
                    end
                    
                    $kit.modify_tag_content("upload_new_doc_#{func}", output, "update")
                    
                elsif params[:doc_upload]
                    
                    doc      = $kit.params[:doc_upload]     != "" ? $kit.params[:doc_upload]   : false
                    category = $kit.params[:doc_category]   != "" ? $kit.params[:doc_category] : false
                    type     = $kit.params[:doc_type]       != "" ? $kit.params[:doc_type]     : false
                    name     = $kit.params[:file_name]      != "" ? $kit.params[:file_name]    : false
                    ext      = $kit.params[:extension]      != "" ? $kit.params[:extension]    : false
                    sid      = $kit.params[:sidref]         != "" ? $kit.params[:sidref]       : false
                    tid      = $kit.params[:tidref]         != "" ? $kit.params[:tidref]       : false
                    
                    if doc && type && category && ext
                        
                        if sid
                            
                            save_document(sid, category, type, ext, doc, "student")
                            
                        elsif tid
                            
                            save_document(tid, category, type, ext, doc, "team")
                            
                        end
                        
                    else
                        
                        doc_validation_check(type, ext, doc, sid, tid)
                        
                    end
                 
                elsif params[:how_to]
                    get_how_to
                    
                elsif params[:new_row]
                    add_new_record
                  
                elsif params[:get_row]
                    get_row
                    
                elsif params[:sid] && params[:sid] != ""
                    
                    $kit.modify_tag_content(
                        "student_record_title",
                        web_script.page_title,
                        type="update"
                    )
                    
                    student_record.content
                    
                elsif params[:tid]
                    
                    team_member_record_title    =  String.new
                    page_title                  =  web_script.page_title
                    team_member_record_title    << page_title if !page_title.nil?
                    $kit.modify_tag_content(
                        
                        "team_member_record_title",
                        team_member_record_title,
                        type="update"
                        
                    )
                    
                    team_member_record.content
                    
                else
                    web_script.response if web_script.respond_to?("response")
                    
                end
                
            end
            
            unless @content_type_changed
                puts "Content-type: text/html"
                puts ""
            end
            
            self.output = "<script>parent.student_page_view();</script>" if load?
            
            puts self.output
            
        #rescue=>e
        #    
        #    structure[:output] = String.new
        #    self.web_error.unexpected_error
        #    puts self.output
        #    
        #    $base.system_log(
        #        "AN UNEXPECTED ERROR HAS OCCURRED! SESSION: #{$kit.user_log_record.primary_id}",
        #        caller[0],
        #        e
        #    )
        #    
        #end
        
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
    
    def current_record
        structure[:current_record]
    end
    
    def fields
        if !structure.has_key?(:fields)
            fields = Hash.new
            params.each_pair{|key,value|
                fields[key]=value if key.to_s.match(/^field_id__/)    
            }
            structure[:fields] = fields 
        end
        structure[:fields]
    end
    
    def load?
        answer = false
        answer = true if structure.has_key?(:load)
        return answer
    end
    
    def output
        if !structure.has_key?(:output)
            structure[:output] = String.new
            structure[:output] << html.header(:default_search=>true) if load?
        end
        structure[:output]
    end
    
    def page
        structure[:page]
    end
    
    def params
        structure[:params]
    end
    
    def rows
        if !structure.has_key?(:rows)
            rows = Hash.new
            if fields
                fields.each_pair{|key,value|
                    record_info = key.to_s.split("__")
                    
                    primary_id  = record_info[1]
                    table_name  = record_info[2]
                    field_name  = record_info[3]
                    
                    row_id                          = "#{table_name}#{primary_id}".to_sym
                    rows[row_id]                    = $tables.attach(table_name).new_row(primary_id)    if !rows.has_key?(row_id)
                    rows[row_id].fields[field_name].value  = value                                      if rows[row_id].fields.has_key?(field_name)                
                }
                rows.each_value{|row|
                    row.fields.each_pair{|field_name,details| row.fields.delete(field_name) if details.value.nil?}    
                }
                structure[:rows] = rows
            else
                structure[:rows] = false
            end
        end
        structure[:rows]
    end
    
    def save_requested
        structure[:save_requested]
    end
    
    def school_year
        structure[:school_year]
    end
    
    def search_params
        if !structure.has_key?(:search_params)
            search_params = Hash.new
            params.each_pair{|key,value|
                search_params[key]=value if key.to_s.match(/search__/)  
            }
            structure[:search_params] = (search_params.length == 0 ? false : search_params)
        end
        structure[:search_params]
    end
    
    def testing
        
        puts "Content-type: text/html"
        puts ""
        puts "<html><head></head><body>"
        
        puts "params received:" 
        params.each_pair{|x,y|puts "key: #{x} value: #{y}<br>"}
        
    end
    
    def team_log_record
        
        if !structure.has_key?(:team_log_record)
            
            $team_log = $team_member.log.new_record 
            $team_log.fields["user_log_id"  ].value = user_log_record.primary_id
            $team_log.save
            structure[:team_log_record] = $team_log
            
        end
        
        structure[:team_log_record]
        
    end
    
    def user
        structure[:user_id]
    end
    
    def user_log_record
        
        if !structure.has_key?(:user_log_record)
            
            user_log = $tables.attach("user_log").new_row
            user_log.fields["username"      ].value = params[:user_id]   
            user_log.fields["page"          ].value = params[:page]       
            user_log.fields["school_year"   ].value = params[:school_year]
            user_log.fields["params"        ].value = String.new
            params.each_pair{|k,v| user_log.fields["params"       ].value << "params[:#{k}] = '#{v}'\n" if (k != :doc_upload && k != :params)}
            user_log.fields["message"       ].value = nil
            user_log.fields["remote_address"].value = params[:remote_address]
            user_log.save
            structure[:user_log_record] = user_log
            
        end
        
        structure[:user_log_record]
        
    end
    
    def web_script
        if !structure.has_key?(:web_script)
            require "#{$paths.web_interfaces_path}#{page}"
            structure[:web_script] = Object.const_get(page.upcase).new();
        end
        structure[:web_script]
    end
    
    def web_script_alt_page(alt_page)
        if !structure.has_key?(:"web_script#{alt_page}")
            require "#{$paths.web_interfaces_path}#{alt_page}"
            structure[:"web_script#{alt_page}"] = Object.const_get(alt_page.upcase).new();
        end
        structure[:"web_script#{alt_page}"]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS_NOT_REVIEWED
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def file_upload
        structure["file_upload"]
    end
    
    def filepath
        structure["filepath"]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def dd
        if !structure.has_key?("dd")
            require "#{$paths.base_path}web_dd"
            structure["dd"] = Web_DD.new()
        end
        structure["dd"]
    end
    
    def html
        if !structure.has_key?("html")
            require "#{$paths.base_path}html"
            structure["html"] = HTML.new()
        end
        structure["html"]
    end
    
    def tools
        if !structure.has_key?("tools")
            require "#{$paths.base_path}web_tools"
            structure["tools"] = Web_Tools.new()
        end
        structure["tools"]
    end
    
    def student_record
        if !structure.has_key?(:student_record_web)
            require "#{$paths.web_interfaces_path}student_record_web"
            structure[:student_record_web] = STUDENT_RECORD_WEB.new()
        end
        structure[:student_record_web]
    end
    
    def team_member_record
        
        if !structure.has_key?(:team_member_record_web)
            require "#{$paths.web_interfaces_path}team_member_record_web"
            structure[:team_member_record_web] = TEAM_MEMBER_RECORD_WEB.new()
        end
        structure[:team_member_record_web]
        
    end
    
    def web_error
        if !structure.has_key?(:web_error)
            require "#{$paths.base_path}web_error"
            structure[:web_error] = Web_Error.new()
        end
        structure[:web_error]
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def add_new?
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(/add_new/)   
        }
        return false
    end
    
    def expandable?
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(/expand/)   
        }
        return false
    end
    
    def field_changed?(a={})
        $kit.params[:rows].each_pair{|k,v|
            super_user_access_changed = true if (k.to_s.match(a[:table_name]) && v.fields[a[:field_name]])  
        }
    end
    
    def fill_select_option?
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(/fill_select_option/)   
        }
        return false
    end
    
    def tab_load_requested?
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(/load_tab/)   
        }
        return false
    end
    
    def test?
        answer = false
        answer = true if params.has_key?(:test)
        return answer
    end
    
    def valid_school_year?
        answer  = false
        db_name = "agora_#{school_year.delete("-")}"
        if $db.get_data(
                "SELECT * 
                FROM  `SCHEMATA`
                WHERE SCHEMA_NAME = '#{db_name}'", "information_schema"
            )
            
            $config.db_name = db_name
            answer = true
        end
        return answer
    end
    
    def user_validated?
        
        set_team_member
        
        if $team_member
            
            if load? || (params[:id] == uid) && (params[:li] == "1") && ($team_member.last_login_id == params[:si])
                
                team_log_record
                $user = $team.by_email(user) || user
                
                modify_tag_content(
                    tag_id  = "student_page_view_container",
                    content = "<INPUT type='hidden' id='student_page_view' name='student_page_view' value='#{get_new_student_page_view}';>",
                    type    = "update"
                ) 
                return true
                
            else
                
                team_log_record
                $user = $team.by_email(user) || user
                
                log = $tables.attach("USER_LOG_CREDENTIAL_ERRORS").new_row
                log.fields["user_log_id"].value = user_log_record.primary_id
                log.fields["error"      ].value = "Team Member Found - Credentials Denied!"
                log.save
                
                return true
                
            end
            
        else
            
            self.output = web_error.invalid_user
            $base.system_notification(
                subject = "Team Member Not Found!",
                content = "ATTENTION - #{user} NOT FOUND!!! LOG: #{user_log_record.primary_id}",
                caller[0]
            )
            
            return false  
            
        end
        
    end
    
    def valid_user?
        
        #verify referer here too.
        answer = false
        
        $team_member = $team.by_team_email(user)
        if !$team_member
            $base.system_notification(
                subject = "Team Member Not Found!",
                content = "ATTENTION - #{user} NOT FOUND!!! LOG: #{user_log_record.primary_id}",
                caller[0]
            )
            params.delete(:student_page_view) if params.has_key?(:student_page_view)
            return false
        end
        
        if $team.by_email(user)
            $user           = $team.by_email(user)
            answer          = true
        else 
            answer = $user = user if  $db.get_data_single("SELECT user_login from wordpress.wp_users WHERE user_login = '#{user}'", "wordpress")
        end
        
        return answer
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def error_message(content, replacement = nil)
        
        puts "Content-type: text/html"
        puts ""
        
        self.output = "<error_communication>"
        self.output = "<H1>#{content}</H1>"
        self.output = "</error_communication>"
        
        if replacement && !load?
            
            $kit.modify_tag_content(
                "tabs",
                replacement
            )
            
        end
        
    end
    
    def modify_tag_content(html_tag_id, content, type="update") #type = "update"/"append"
        self.output = "<contentStart__#{type}__#{html_tag_id}>"
        self.output = content
        self.output = "</contentEnd>"
    end
    
    def output=(arg)
        output << arg if arg
    end
    
    def page=(arg)
        structure[:page] = arg
    end

    def params=(arg)
        if @structure.nil?
            @structure = arg
        end
        structure[:params] = arg
    end
    
    def student_record=(arg)
        if params[:sid]
            if !structure.has_key?(:student_record)
                structure[:student_record] = String.new
                sid     = params[:sid]
                student = $students.attach(sid)
                $kit.modify_tag_content("tab_title-2", student.fullname.to_user, type="update") 
            end
            structure[:student_record] << arg if arg
        end
    end
    
    def team_member_record=(arg)
        if params[:tid]
            if !structure.has_key?(:team_member_record)
                structure[:team_member_record] = String.new
                tid         = params[:tid]
                team_member = $team.get(tid)
                $kit.modify_tag_content("tab_title-3", team_member.primary_id.to_name(:full_name), type="update") 
            end
            structure[:team_member_record] << arg if arg
        end
    end
   
    def user=(arg)
        structure[:user_id] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TEMPLATED_RESPONSES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def add_new_breakaway
        
        @content_type_changed = true
        
        alt_page_content    = String.new
        
        alt_page_class      = params[:new_breakaway].split("ARGV")[0]
        args                = params[:new_breakaway].split("ARGV").length > 1 ? params[:new_breakaway].split("ARGV")[1] : params[:new_breakaway].split("ARGV")[1]
     
        alt_page            = web_script_alt_page(alt_page_class)
        
        if args
            alt_page_content << alt_page.load(args)
        else
            alt_page_content << alt_page.load
        end
        
        self.page = alt_page_class
        
        puts "Content-type: text/html"
        puts ""
        
        self.output = html.header(
            :body   =>"<style>body {background-color:#F2F5F7};</style><div id='breakaway_container' style='width:1200px; min-height:400px; margin-left:auto; margin-right:auto;'>
                
                <H1>#{alt_page.breakaway_caption} - #{$config.school_year} SY</H1>
                <div id='school_year_container' name='school_year_container'>#{$base.school_year_hidden}</div>\n
                #{alt_page_content}
                
            </div>"
        )
        
    end

    def add_new_csv
        
        if params[:new_csv]
            
            func = params[:new_csv].split("ARGV")[0]
            args = params[:new_csv].split("ARGV").length > 1 ? params[:new_csv].split("ARGV")[1] : params[:new_csv].split("ARGV")[1]
            
            function_str = "add_new_csv_#{func}"
            
            if web_script.respond_to?(function_str)
                
                if args
                    results =  web_script.send(function_str, args)
                else
                    results =  web_script.send(function_str)
                end
                
                if results
                    
                    @content_type_changed = true
                    
                    puts "Content-type:text/csv"
                    puts "Content-Disposition:attachment;filename=#{func}_#{args}_#{user_log_record.primary_id}#{$ifilestamp}.csv"
                    
                    #DATE IN THE PAST
                    puts "Expires: Mon, 26 Jul 1997 05:00:00 GMT"
                    puts "Cache-Control: no-cache"
                    puts "Pragma: no-cache"
                    
                    puts ""
                    
                    file_path   = $reports.csv(nil, user_log_record.primary_id, results)
                    filecontent = String.new
                    File.open(  file_path, 'rb'   ) do |file|
                        filecontent = file.read
                    end
                    
                    File.delete(file_path)
                    
                    return filecontent.gsub("\r","")
                    
                end
             
            else
                
                web_error.document_not_found
                
            end 
            
        end
        
    end
    
    #def add_new_pdf
    #    
    #    pdf_found = false
    #    
    #    if params[:new_pdf]
    #        
    #        func = params[:new_pdf].split("ARGV")[0]
    #        args = params[:new_pdf].split("ARGV").length > 1 ? params[:new_pdf].split("ARGV")[1] : params[:new_pdf].split("ARGV")[1]
    #        
    #        function_str = "add_new_pdf_#{func}"
    #        
    #        if web_script.respond_to?(function_str)
    #            
    #            if args
    #                file_path =  web_script.send(function_str, args)
    #            else
    #                file_path =  web_script.send(function_str)
    #            end
    #            
    #        elsif params[:student_page_view] && web_script_alt_page(params[:student_page_view]).respond_to?(function_str)
    #            
    #            if args
    #                file_path =  web_script_alt_page(params[:student_page_view]).send(function_str, args)
    #            else
    #                file_path =  web_script_alt_page(params[:student_page_view]).send(function_str)
    #            end
    #            
    #        end 
    #        
    #        if file_path
    #            
    #            @content_type_changed = true
    #            
    #            puts "Content-type:application/pdf"
    #            puts "Content-Disposition: attachment; filename=downloaded.pdf"
    #            
    #            #DATE IN THE PAST
    #            puts "Expires: Mon, 26 Jul 1997 05:00:00 GMT"
    #            puts "Cache-Control: no-cache"
    #            puts "Pragma: no-cache"
    #            
    #            puts ""
    #            
    #            filecontent = String.new
    #            File.open(file_path, 'rb') do |file|
    #                filecontent << file.read
    #            end
    #            
    #            puts filecontent
    #            
    #            File.delete(file_path)
    #            
    #        else
    #            
    #            error_message("The PDF document was not found")
    #            
    #        end
    #        
    #    end
    #    
    #end
    
    def view_new_pdf
        
        pdf_found = false
        
        if params[:view_pdf]
            
            func = params[:view_pdf].split("ARGV")[0]
            args = params[:view_pdf].split("ARGV").length > 1 ? params[:view_pdf].split("ARGV")[1] : params[:view_pdf].split("ARGV")[1]
            
            function_str = "add_new_pdf_#{func}"
            
            if web_script.respond_to?(function_str)
                
                if args
                    file_path =  web_script.send(function_str, args)
                else
                    file_path =  web_script.send(function_str)
                end
                
            elsif params[:student_page_view] && web_script_alt_page(params[:student_page_view]).respond_to?(function_str)
                
                if args
                    file_path =  web_script_alt_page(params[:student_page_view]).send(function_str, args)
                else
                    file_path =  web_script_alt_page(params[:student_page_view]).send(function_str)
                end
                
            end 
            
            if file_path
                
                load_secure_document(file_path.path)
                
            else
                
                error_message("The PDF document was not found")
                
            end
            
        end
        
    end
    
    def add_new_record
        
        if table_name = params[:new_row]
            
            function_str = "add_new_record_#{params[:new_row].downcase}"
            
            if web_script.respond_to?(function_str)
                
                new_record_str = web_script.send(function_str) 
                modify_tag_content("add_new_dialog_#{table_name}", "<input type='hidden' name='save_new_record'>"+new_record_str, type="update")
                
            elsif params[:student_page_view] && web_script_alt_page(params[:student_page_view]).respond_to?(function_str)
                
                new_record_str  = web_script_alt_page(params[:student_page_view]).send(function_str)
                css             = web_script_alt_page(params[:student_page_view]).css
                modify_tag_content("add_new_dialog_#{table_name}", css+new_record_str, type="update")
                
            end
            
        end
        
    end
    
    def get_how_to
        
        if table_name = params[:how_to]
            
            if how_to_content = $db.get_data_single(
                "SELECT post_content
                FROM wordpress.wp_posts
                WHERE post_title = '#{params[:how_to]}'
                AND post_status = 'publish'",
                selected_db = "wordpress"
            )
                
                modify_tag_content("how_to_dialog", how_to_content[0], type="update")
                
            else
                
                web_error.document_not_found
                
            end
            
        end
        
    end

    def get_row
        
        if table_name = params[:get_row]
            
            function_str = "get_row_#{params[:get_row].downcase}"
            
            if web_script.respond_to?(function_str)
                
                new_record_str = params[:argv] ? web_script.send(function_str, params[:argv]) : web_script.send(function_str)
                
                modify_tag_content("get_row_dialog", new_record_str, type="update")
                
            else
                
                web_error.default
            end
            
        end
        
    end
    
    def get_student_record
        
        #if !web_script.respond_to?("student_record")
        #    
        #    structure.delete(:web_script)
        #    self.page = "My_Students_Web"
        #    break if !web_script.respond_to?("student_record")
        #    
        #end
        
        $kit.modify_tag_content(
            "tabs-2",
            student_record.setup,
            type="update"
        )
        
        $kit.modify_tag_content(
            "tab_title-2",
            "#{$focus_student.studentfirstname.value} #{$focus_student.studentlastname.value}",
            type="update"
        )
        
        student_record_title = String.new
        page_title = web_script.page_title
        student_record_title << page_title if !page_title.nil?
        $kit.modify_tag_content(
            "student_record_title",
            student_record_title,
            type="update"
        )
        
        student_record.content
        
    end

    def defrost(ice)
        water = ice
        return water
    end
    
    def doc_validation_check(type, ext, doc, sid, tid)
        
        validation_string = "Please:<br>"
        validation_string << "Choose a file to upload.<br>"           if !doc
        validation_string << "Select a document type.<br>"            if !type
        validation_string << "Check your document extension.<br>"     if !ext
        validation_string = "No id error. How did this happen?!<br>"  if !sid && !tid
        
        $kit.output = validation_string
        
    end
    
    def load_accordion_links
        
        output = String.new
        
        doc_type_name = params[:accordion_doctype]
        
        category_id = params[:accordion_category_id]
        
        type_id = $tables.attach("document_type").find_field("primary_id", "WHERE name='#{doc_type_name}' AND category_id='#{category_id}'").value
        
        report_name = $tables.attach("document_type").field_by_pid("name",           type_id).value
        ext   = $tables.attach("document_type").field_by_pid("file_extension", type_id).value
        
        pids = $tables.attach("documents").document_pids(type_id)
        
        nice_name = $tables.attach(report_name) ? $tables.attach(report_name).nice_name : report_name
        
        pids.each_with_index do |pid, i|
            
            row = i%2 == 0 ? "even" : "odd"
            
            created_date = $tables.attach("documents").field_by_pid("created_date", pid).to_user
            
            output << "<div class='#{row}'>"
            output << "<div class='img'><img src='/#{$config.code_set_name}/javaScript/jqueryFileTree/images/#{ext}.png'></div>"
            output << "<div class='file_link'>#{nice_name} - #{created_date}</div>"
            output << "<div id='link_#{pid}' class='link_div'><button class='get_link' role='button' onclick=\"return load_secure_doc('#{pid}',true,false);\"></button></div>"
            output << "<input id='doc_id_#{pid}' name='doc_id' value='#{pid}' style='display:none;'>"
            output << $tools.newlabel("bottom")
            output << "</div>"
            
        end if pids
        
        $kit.modify_tag_content(params[:accordion_doctype], output, "update")
        
    end
    
    def load_secure_document(path=nil)
        
        if path
            
            output = "<object width='1100' height='1415' data='#{path.split("htdocs").last}'></object>"
            $kit.modify_tag_content("document_dialog", output, "update")
            
        else
            
            doc_id       = params[:doc_id]
            type_id      = $tables.attach("documents").field_by_pid("type_id", doc_id).value
            type_name    = $tables.attach("document_type").field_by_pid("name", type_id).value
            created_date = $tables.attach("documents").field_by_pid("created_date", doc_id).value
            dtime        = "D#{created_date.slice(0,4)}#{created_date.slice(5,2)}#{created_date.slice(8,2)}T#{created_date.slice(11,2)}#{created_date.slice(14,2)}#{created_date.slice(17,2)}"
            ext          = $tables.attach("document_type").field_by_pid("file_extension", type_id).value
            session_name = "#{type_name.gsub(" ","_").downcase}__#{dtime}__xid#{user_log_record.primary_id}.#{ext}"
            
            secure_file  = File.new($paths.temp_path+session_name, "wb")
            
            File.open( "#{$paths.documents_path}#{doc_id}.#{ext}", 'rb' ) do |file|
                
                secure_file << file.read
                
            end
            
            secure_path = secure_file.path
            
            secure_file.close
            
            if ext == "csv"
                
                link_path = secure_path.split("htdocs").last
                
                $kit.modify_tag_content("link_#{doc_id}", "<a class='link' href='#{link_path}'>DOWNLOAD</a>", "update")
                
            else
                
                output = "<object width='1100' height='1415' data='#{secure_path.split("htdocs").last}'></object>"
                $kit.modify_tag_content("document_dialog", output, "update")
                
            end
            
        end
        
    end
    
    def param_by_field(field)
        
        #FIRST TRY FIELD ID, AS IT IT THE MOST CONSTRAINED
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(field.web.field_id)   
        }
        
        #SECOND TRY FIELDNAME - WARNING, THIS WILL RETURN THE FIRST INSTANCE IF DUP MATCHES
        params.to_a.each{|hash_arr|
            return hash_arr[0] if hash_arr[0].to_s.match(field.field_name)   
        }
        
        return false
        
    end

    def save
        rows.each_value{|row|
            row.save
        } if rows
        return "" #correct and remove this return for error handling
    end
    
    def save_document(id, category, type, ext, doc, user_type)
        
        return_message = "File Successfully Uploaded"
        
        new_row = $tables.attach("DOCUMENTS").new_row
        
        fields = new_row.fields
        
        fields["school_year"].value = $school.current_school_year
        
        category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='#{category}'").value
        
        if $tables.attach("document_type").find_field("primary_id",  "WHERE name='#{type}' AND category_id='#{category_id}'")
            
            fields["category_id"].value = category_id
            fields["type_id"].value     = $tables.attach("document_type").find_field("primary_id",  "WHERE name='#{type}' AND category_id='#{category_id}'").value
            
            pid = new_row.save
            
        else
            
            fields["category_id"].value = 0
            fields["type_id"].value     = 0
            
            pid = new_row.save
            
            $base.system_notification(
                "No Doc Type: #{category} - #{type}",
                "documents table row #{pid} inserted without a type, because a match with '#{category} - #{type}' was not found.  Check the types in the 'document_types' table."
            )
            
        end
        
        new_relate_row = $tables.attach("DOCUMENT_RELATE").new_row
        new_relate_row.fields["document_id"].value     = pid
        if user_type == "student"
            new_relate_row.fields["table_name"].value      = "STUDENT"
            new_relate_row.fields["key_field"].value       = "student_id"
        elsif user_type == "team"
            new_relate_row.fields["table_name"].value      = "TEAM"
            new_relate_row.fields["key_field"].value       = "primary_id"
        end
        new_relate_row.fields["key_field_value"].value = id
        new_relate_row.save
        
        path = "#{$paths.documents_path}#{pid}.#{ext}"
        
        if !File.exists?(path)
            
            newDoc = File.new(path, "wb")
            
            newDoc.write(doc)
            
            newDoc.close
            
            filepath = newDoc.path
            
        else
            
            error_file_path    = "#{$paths.document_error_path}#{pid}_#{$ifilestamp}.#{ext}"
            newDoc = File.new(error_file_path, "wb")
            newDoc.write(doc)
            newDoc.close
            filepath = newDoc.path
            
            $base.system_notification(
                "FILE AT DOCUMENT PID:#{pid} ALREADY EXISTS",
                "FILE SAVED TO PATH: #{error_file_path}",
                caller[0],
                nil
            )
            return_message = "There was a problem uploading your file. An e-mail has already been send to the system administrators."
        end
        
        self.output = return_message
        
    end
    
    def search_results
        
        if !structure.has_key?(:search_results)
            
            if search_params
                
                valid_search            = false
                options_hash            = Hash.new
                
                search_type             = nil
                search_params.each_pair{|field_info, value|
                    
                    if !value.empty?
                        search_type = field_info.to_s.split("__")[1] 
                        valid_search = true
                        option  = field_info.to_s.split("__")[2]
                        options_hash[option] = Mysql.quote(Mysql.escape_string(value).gsub("\\",""))
                    end
                    
                }
                
                if valid_search
                    
                    update_content = String.new
                    
                    case search_type
                    when "STUDENT"
                        
                        options_hash[:fuzzy] = true
                        structure[:search_results] = students = $students.list(options_hash)
                        
                        if students
                            
                            if students.length >= 100
                                
                                students = students.first(100)
                                
                                update_content << "<div id='too_many'>More than 100 results found. Please refine your search results.</div>"
                                
                            end
                            
                            students.each{|sid|
                                
                                student = $students.get(sid)
                                
                                update_content << $tools.div_open("result_container", "result_container")
                                
                                update_content << $tools.breakaway_button(
                                    :button_text        => student.full_name,
                                    :page_name          => "STUDENT_RECORD_WEB",
                                    :additional_params  => {:sid=>sid},
                                    :class              => "student_search_result"
                                )
                                
                                update_content << $tools.div_open("search_sid", "search_sid")
                                update_content << student.student_id.web.label({:div_id=>"search_sid"})
                                update_content << $tools.div_close()
                                update_content << $tools.div_close()
                            }
                            
                            modify_tag_content("student_search_results", update_content, type="update")
                            
                        else
                            
                            modify_tag_content("student_search_results", "No Students Found.", type="update")
                            
                        end
                        
                    when "TEAM"
                        
                        options_hash[:ids_only]=true
                        structure[:search_results] = team_members = $team.find(options_hash)
                        
                        if team_members
                            
                            if team_members.length >= 100
                                
                                team_members = team_members.first(100)
                                
                                update_content << "<div id='too_many'>More than 100 results found. Please refine your search results.</div>"
                                
                            end
                            
                            team_members.each{|tid|
                                
                                t = $team.get(tid)
                                
                                update_content << $tools.div_open("result_container", "result_container")
                                
                                update_content << $tools.breakaway_button(
                                    :button_text        => t.full_name,
                                    :page_name          => "TEAM_MEMBER_RECORD_WEB",
                                    :additional_params  => {:tid=>tid},
                                    :class              => "team_search_result"
                                )
                                
                                update_content << $tools.div_open("search_tid", "search_tid")
                                update_content << t.primary_id.web.label({:div_id=>"search_tid"})
                                update_content << $tools.div_close()
                                update_content << $tools.div_close()
                            }
                            
                            modify_tag_content("team_search_results", update_content, type="update")
                            
                        else
                            
                            modify_tag_content("team_search_results", "No Team Members Found.", type="update")
                            
                        end
                        
                    end
                    
                else
                    
                    structure[:search_results] = false
                    error_message("Please select at least one search criteria")
                    
                end
            end
            
        end
        
        structure[:search_results]
        
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
end

params = Hash.new
komodo = true 

if komodo

params[:how_to] = 'STUDENT_TEST_EVENTS_ADMIN_WEB'
params[:page] = 'STUDENT_TEST_EVENTS_ADMIN_WEB'
params[:school_year] = '2012-2013'
params[:user_id] = 'athena-reports@agora.org'
params[:remote_address] = 'fe80::7ce7:3757:7815:2716'
params[:student_page_view] = 'undefined'

end

if !komodo
    cgi     = CGI.new
    cgi.keys.each{|key|
        if cgi[key].class == String
            params[key.to_sym]=cgi[key]
        else       
            params[key.to_sym]=cgi[key].read
        end   
    }
end

ATHENA_CGI_TESTING.new(params)
