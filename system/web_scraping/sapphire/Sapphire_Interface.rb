#!/usr/local/bin/ruby
require 'watir-webdriver'

class Sapphire_Interface

    #---------------------------------------------------------------------------
    def initialize()
        
        @structure  = structure
        @timeout    = 5
        @params     = {}
        
    end
    #---------------------------------------------------------------------------
    
    def instance_params
        @params
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def process_queue(queue_pid)
        puts queue_pid
        @params[:queue_record   ] = $tables.attach("SAPPHIRE_INTERFACE_QUEUE"       ).by_primary_id(queue_pid)
        @params[:queue_record   ].fields["started_datetime"].set($base.right_now.to_db).save
        
        @params[:map_record     ] = $tables.attach("SAPPHIRE_INTERFACE_MAP"         ).by_primary_id(@params[:queue_record   ].fields["map_id"              ].value)
        @params[:options_record ] = $tables.attach("SAPPHIRE_INTERFACE_OPTIONS"     ).by_primary_id(@params[:map_record     ].fields["sapphire_option_id"  ].value)
        
        school_id = "EL"
       
        if @params[:options_record].fields["module_name"].match(/Student Information System/)
            
            @params[:src_record]        = $tables.attach(@params[:map_record].fields["athena_table"].value).by_primary_id(@params[:queue_record].fields["athena_pid"].value)
            sid                         = @params[:src_record].fields["student_id"].value
            student                     = $students.get(sid)
            
            if student.active.is_true?
                
                school_id                   = (student && student.grade.match(/K|1st|2nd|3rd|4th|5th/)) ? "EL" : (student && student.grade.match(/6th|7th|8th/)) ? "MS" : "HS"
                
                @params[:school_code        ] = school_id
                @params[:school_year        ] = $school.current_school_year.split("-")[-1]
                @params[:module             ] = @params[:options_record].fields["module_name"].value
                @params[:sid                ] = sid
                @params[:new_value          ] = @params[:src_record].fields[@params[:map_record].fields["athena_field"].value].value
                
                puts @params
                
                if student_update_record
                    
                    @params[:queue_record   ].fields["successful"           ].set(true                  ).save 
                    @params[:queue_record   ].fields["completed_datetime"   ].set($base.right_now.to_db ).save
                    
                end
                
            else
                
                #$base.system_notification(
                #    subject = "Sapphire Update Failed - SID: #{sid}",
                #    content = "Student is not active"
                #)
                
                @params[:queue_record   ].fields["successful"           ].set(false                 ).save
                @params[:queue_record   ].fields["completed_datetime"   ].set($base.right_now.to_db ).save
                @params[:queue_record   ].fields["notes"                ].set("Inactive Student"    ).save
                
            end
            
        end 
        
    end
    
    def follow_options_path(options_record = @params[:options_record], field_value = false)
        
        if options_record.fields["parent_option_id"].is_true?
            this_options_record = $tables.attach("SAPPHIRE_INTERFACE_OPTIONS").by_primary_id(options_record.fields["parent_option_id"].value)
            follow_options_path(this_options_record)
        end
        
        if options_record.fields["path"].value.match("ETHNICITY")
            select_tab("3")
        end
        
        options_hash = {}
        options_hash[:option_type  ] = options_record.fields["option_type"   ].value    
        options_hash[:option_value ] = options_record.fields["option_value"  ].value     
        options_hash[:field_value  ] = @params[:src_record].fields[@params[:map_record].fields["athena_field"].value].value   
        
        puts options_hash
        
        send(options_record.fields["action"].value, options_hash)
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
            set_structure(struct_hash) if !struct_hash.nil?
        end
        @structure
    end
    
    def notify_timeout
        
        #@params[:queue_record   ].fields["started_datetime"     ].set(nil).save
        #@params[:queue_record   ].fields["completed_datetime"   ].set(nil).save
        
        @params[:queue_record   ].fields["successful"   ].set(false                     ).save
        @params[:queue_record   ].fields["notes"        ].set("Timeout - #{caller[0]}"  ).save
        
        #$base.system_notification(
        #    subject = "Sapphire Interface - Timeout!",
        #    content = caller[0]
        #)
        
        return false
        
    end
    
##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#private
#def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
#end
##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def browser(page=nil)
        
        if !structure["browser"]
            
            page = "https://agora-sapphire.k12system.com/Gradebook/main.cfm"
            
            connected   = false
            tried       = 0
            until connected || tried == 3
                
                #Watir::Browser.default = "firefox"
                session = Watir::Browser.new
                sleep 2
                session.goto(page)
                sleep 2
                
                if session.text_field(:name, "j_username").exists?
                    
                    structure["browser" ]   = session
                    connected               = true
                    
                else
                    
                    session.close
                    tried+=1
                    
                end
                
            end
            
        elsif !page.nil? && !(structure["page"] == page)
            
            structure["browser" ].goto(page) 
            
        end
        
        if tried == 3
            
            $base.system_notification(
                subject     = "Sapphire Interface Processing - Failed Initial Connection",
                content     = "Three unsuccessful attempts were made to connect to #{page}",
                this_caller = nil,
                e_obj       = nil
            )
            
            break
            
        else
            
            structure["page"] = page
            return structure["browser"]
            
        end
        
    end
   
    def click_logout
        
        field_identifiers   = [
            "/html/body/table/tbody/tr[2]/td[2]/form/table/tbody/tr[2]/td/table/tbody/tr[5]/td/input[2]",
            "/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[3]/td/div[2]/input"
        ]
        
        field_found = false
        i = 0
        until field_found
            
            field_identifiers.each{|field_identifier|
                
                if browser.button(:xpath, field_identifier).exists?
                    browser.button(:xpath, field_identifier).click
                    field_found = true
                else
                    sleep 1
                end
                if i >= @timeout
                    notify_timeout
                end 
                
            }
            
            i+=1
            
        end
        
    end
    
    def click_login
        
        field_identifier    = "/html/body/table/tbody/tr[2]/td[2]/form/table/tbody/tr[2]/td/table/tbody/tr[4]/td/input"
        field_found         = false
        i = 0
        until field_found
            if browser.button(:xpath, field_identifier).exists?
                browser.button(:xpath, field_identifier).click
                field_found = true
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def click_signon
        
        field_identifier    = "/html/body/table/tbody/tr[2]/td[2]/form/table/tbody/tr[2]/td/table/tbody/tr[5]/td/input"
        field_found         = false
        i = 0
        until field_found
            if browser.button(:xpath, field_identifier).exists?
                browser.button(:xpath, field_identifier).click
                field_found = true
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def goto_module
        
        selected_module = @params[:options_record ].fields["module_name"].value
        
        browser("https://agora-sapphire.k12system.com/Gradebook/CMS/SISLanding.cfm"                                                 ) if selected_module=="Student Information System"
        browser("https://agora-sapphire.k12system.com/Gradebook/CMS/IEPWriter/Landing.cfm"                                          ) if selected_module=="Special Education / IEP Writer"
        browser("https://agora-sapphire.k12system.com/Gradebook/CMS/AssessmentTracker.cfm?SID=A7F1E37C-040C-F841-875D0B001547EF40"  ) if selected_module=="Assessment Tracker"
        
    end
    
    
    
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def change_hidden(params=@params)
        
        if params[:option_type].to_sym == :id
            
            browser.execute_script(
                "$('##{params[:option_value]}').value = '#{params[:field_value]}'"
            )
            
            browser.execute_script(
                
                "$(\"select #{params[:option_value]} option\").each(
                    function() {
                        this.selected = (this.text == #{params[:field_value]});
                    }
                );"
                
            )
            
            browser.execute_script(
                "alert($('STUDENT_ID'))"
            )
        end
        
    end
    
    def click(params=@params)
        
        field_found = false
        i = 0
        until field_found
            if browser.link(params[:option_type].to_sym, params[:option_value]).exists?
                
                browser.link(params[:option_type].to_sym, params[:option_value]).click
                field_found = true
                
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end

    def select(params=@params)
        
        field_found = false
        i = 0
        until field_found
            
            #puts "test exists"
            puts it_exists   = browser.select_list(params[:option_type].to_sym, params[:option_value]).exists?
            
            #puts "test visible"
            puts its_visible = browser.select_list(params[:option_type].to_sym, params[:option_value]).visible?
            
            if (
                
                it_exists && its_visible 
                
            )
                
                if browser.select_list(params[:option_type].to_sym,params[:option_value]).option(:value, params[:field_value]).exists?
                    
                    browser.select_list(params[:option_type].to_sym,params[:option_value]).select_value(params[:field_value])
                    
                elsif browser.select_list(params[:option_type].to_sym,params[:option_value]).option(:text, params[:field_value]).exists?
                    
                    browser.select_list(params[:option_type].to_sym,params[:option_value]).select(params[:field_value])
                    
                end
                
                field_found = true
                
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end

    def set(params=@params)
        
        field_found = false
        i = 0
        until field_found
            if browser.text_field(params[:option_type].to_sym, params[:option_value]).exists?
                
                browser.text_field(params[:option_type].to_sym, params[:option_value]).set(params[:field_value])
                field_found = true
                
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end

    def select_tab(tab_number = nil)
        
        if tab_number
            
            tab_selected = false
            
            until tab_selected
                
                if browser.li(:id, "tab_#{tab_number}").exists?
                    
                    browser.execute_script(
                        
                        "SapphireLib.pingSIS(); tab_hide(#{tab_number}, 8); document.student_demographics.OPEN_TAB.value=#{tab_number};"
                        
                    )
                    
                    tab_selected = true
                    
                else
                    
                    sleep 1
                    
                end
                
            end
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOGIN
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def login
        
        set_username
        set_password  
        click_login
        select_school(      @params[:school_code])
        select_school_year( @params[:school_year])
        click_signon
        
    end
    
    def select_school(school_code)
        
        field_identifier    = "school_id"
        field_found         = false
        
        i = 0
        until field_found
            if browser.select_list(:id, field_identifier).exists?
                browser.select_list(:id, field_identifier).select_value(school_code)
                field_found = true
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def select_school_year(school_year)
        
        field_identifier    = "school_year"
        field_found         = false
        
        i = 0
        until field_found
            if browser.select_list(:id, field_identifier).exists?
                browser.select_list(:id, field_identifier).select_value(school_year)
                field_found = true
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def set_password(password = "tBM679p8a")
        
        field_identifier    = "j_password"
        field_found         = false
        i = 0
        until field_found
            if browser.text_field(:name, field_identifier).exists?
                browser.text_field(:name, field_identifier).set password
                field_found = true
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def set_username(username = "jhalverson")
        
        field_identifier    = "j_username"
        field_found         = false
        i = 0
        until field_found
            if browser.text_field(:name, field_identifier).exists?
                browser.text_field(:name, field_identifier).set username
                field_found = true
            else
                if i == 0
                    click_logout
                end
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STUDENT_INFORMATION_SYSTEM
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def goto_student_demographics
        
        browser("https://agora-sapphire.k12system.com/Gradebook/CMS/StudentDemographics.cfm")
        
    end
    
    def save_student
        
        sleep 5
       
        tried   = 0
        success = false
        
        until success || tried == 3
            
            puts tried
            
            tried+=1
            
            results = browser.execute_script(
                "if ($('main_form').onsubmit()) {
                    
                    $('main_form').Action.value='Save';
                    $('main_form').Action.disabled=false;
                    if ($('main_form').smartsubmit) {
                        $('main_form').smartsubmit(true);
                    } else {
                        $('main_form').submit();
                    }
                    
                    return true;
                    
                }else{
                    
                    return false;
                    
                }"
            )
            
            success = results == true
            
        end
        
        sleep 5
        
    end
    
    def search_students
        
        field_found         = false
        i = 0
        until field_found
            if browser.text_field(:id, "namesrch_string").exists?
                
                browser.text_field(:id, "namesrch_string").focus
                driver = browser.driver
               
                @params[:sid].each do |c|
                    driver.switch_to.active_element.send_keys(c)
                end
                
                field_found = true
                
            else
                sleep 1
            end
            if i >= @timeout
                notify_timeout
            end
            i+=1
        end
        
    end
    
    def select_student
        
        field_found = false
        i = 0
        
        begin
            
            until (field_found || i >= @timeout)
                
                if browser.div(:id, "namesrch_auto").li(:id, "stu_#{@params[:sid]}").exists?
                    
                    browser.div(:id, "namesrch_auto").li(:id, "stu_#{@params[:sid]}").click
                    field_found = true
                    
                else
                    sleep 1
                end
                
                i+=1
                
            end
            
        rescue => e
            
            i+=1
            retry if i < @timeout
            
        end
        
        if i >= @timeout
            
            notify_timeout
            
        end
        
    end
    
    def student_update_record
        
        login
        goto_module
        goto_student_demographics
        search_students
        select_student
        
        follow_options_path
        
        save_student
        
        browser.close
        
    end
    
end

Sapphire_Interface.new