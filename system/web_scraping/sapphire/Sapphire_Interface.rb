#!/usr/local/bin/ruby
require 'firewatir'
require 'watir'

class Sapphire_Interface

    #---------------------------------------------------------------------------
    def initialize()
        
        @structure              = structure
        @timeout                = 5
        @current_school_year    = $tables.attach("SCHOOL_YEAR_DETAIL").field_value("WHERE current IS TRUE").split("-")[-1]
        
        login(
            :school_code    => "EL",
            :module         => "Student Information System"
        )
        
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def login(a={})
    # :school_code  => "EL"
        
        set_username
        set_password  
        click_login
        select_school(      a[:school_code])
        select_school_year( @current_school_year)
        click_signon
        
        if a.has_key?(:module)
            
            browser("https://agora-sapphire.k12system.com/Gradebook/CMS/SISLanding.cfm"                                                 ) if a[:module]=="Student Information System"
            browser("https://agora-sapphire.k12system.com/Gradebook/CMS/IEPWriter/Landing.cfm"                                          ) if a[:module]=="Special Education / IEP Writer"
            browser("https://agora-sapphire.k12system.com/Gradebook/CMS/AssessmentTracker.cfm?SID=A7F1E37C-040C-F841-875D0B001547EF40"  ) if a[:module]=="Assessment Tracker"
            
        end
        
        click(
            :option_type    =>"id",
            :option_value   =>"ulaitem0z0"
        )
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
        $base.system_notification(
            subject = "Sapphire Interface - Timeout!",
            content = caller[0]
        )
        raise "Sapphire Interface - Timeout!"
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def browser(page=nil)
        
        if !structure["browser"]
            
            page = "https://agora-sapphire.k12system.com/Gradebook/main.cfm"
            
            Watir::Browser.default = "firefox"
            session = Watir::Browser.new
            sleep 2
            session.goto(page)
            structure["browser" ] = session
            
        elsif !page.nil? && !(structure["page"] == page)
            
            structure["browser" ].goto(page) 
            
        end
        
        structure["page"] = page
        
        return structure["browser"]
        
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
    
    def click(a={})
    # :option_type=>nil,
    # :option_value=>nil
        
        field_found         = false
        i = 0
        until field_found
            if a[:option_type]=="id" && browser.link(:id, a[:option_value]).exists?
                x = browser.link(:id,a[:option_value]).click
                test = "window.alert('test');"
                realsies = "document.getElementById('toolbar_box').className = 'ihover iactive';"
                x = browser.execute_script("document.getElementById('ulaitem0z0').onmouseover();") 
                field_found = true
            elsif a[:option_type]=="xpath" && browser.link(:xpath, a[:option_value]).exists?
                browser.link(:id, "ulaitem0z0z1z1").click
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
end

Sapphire_Interface.new