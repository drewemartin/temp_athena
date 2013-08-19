#!/usr/local/bin/ruby

class Jupiter_Grades_Interface

    #---------------------------------------------------------------------------
    def initialize()
        @structure = structure
        @timeout   = 10
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def download_grades_ms(school_year = nil)
        
        login
        menu_item_setup
        menu_item_import_export
        select_school_menu("Agora Cyber Charter Middle School")
        select_year_menu(school_year)
        
        begin
            select_import_export("Export Grades & Schedules")
        rescue => e
            testing_error_notification("Jupiter Grades Select Import Export Failed", e)
        end
        
        begin
            select_file_format("Excel.csv")
        rescue => e
            testing_error_notification("Jupiter Grades Select File Format Failed", e)
        end
        
        begin
            submit_import_export
        rescue => e
            testing_error_notification("Jupiter Grades Submit Import Export Failed", e)
        end
        
        begin
            submit_confirm_export
        rescue => e
            testing_error_notification("Jupiter Grades Submit Confirm Export Failed", e)
        end
        
        begin
            browser.close_all() if download_complete?("#{$paths.imports_path}/Jupiter_Grades_&_Schedules.csv")
        rescue => e
            testing_error_notification("Jupiter Grades Browser Close Failed", e)
        end
        return true
        
    end
    
    def testing_error_notification(subject, e)
        $base.system_notification(
            subject = subject,
            content = "#{__FILE__} #{__LINE__}",
            caller[0],
            e
        )
        raise e
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
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def browser
        if !structure["browser"]
            start
        end
        return structure["browser"]
    end
    
    def download_complete?(file_path)
        complete = false
        i=0
        until complete == true
            notify_timeout_check(i)
            if File.exists?( file_path ) and !File.exists?( "#{ file_path }.part" )
                complete = true
                sleep 1
            end
            sleep 1
            i+=1
        end
        return true
    end
    
    def login
        if !structure["login"]
            #goto login
            #link = "//*[@id=\"tab9\"]"
            #link_found = false
            #until link_found
            #    if browser.link(:xpath, link).exists?
            #        browser.link(:xpath, link).click
            #        link_found = true
            #        sleep 1
            #    end   
            #end
            #change tabs if needed
            #link = "/html/body/form/table[3]/tbody/tr/td/img[4]"
            #link_found = false
            #i = 0
            #until link_found || i == 3
            #    if browser.link(:xpath, link).exists?
            #        browser.link(:xpath, link).click
            #        link_found = true
            #        sleep 1
            #        i += 1
            #    end   
            #end
            
            #enter username
            field = "/html/body/form/table[3]/tbody/tr[2]/td/table/tbody/tr/td[2]/input"
            field_found = false
            i=0
            until field_found
                notify_timeout_check(i)
                if browser.text_field(:xpath, field).exists?
                    browser.text_field(:xpath, field).set "kyoung21"
                    field_found = true
                end
                sleep 1
                i+=1
            end
            
            #enter password
            field = "/html/body/form/table[3]/tbody/tr[2]/td/table/tbody/tr[2]/td[2]/input"
            field_found = false
            i=0
            until field_found
                notify_timeout_check(i)
                if browser.text_field(:xpath, field).exists?
                    browser.text_field(:xpath, field).set "4everyoung"
                    field_found = true
                end
                sleep 1
                i+=1
            end
            
            #submit form
            submit = "btn2"
            browser.cell(:id, submit).fire_event("onClick")
            structure["login"] = true
            #bypass messaging
            #submit = "btn2"
            #browser.cell(:id, submit).fire_event("onClick")
        end
        return structure["login"]
    end
    
    def menu_item_import_export
        menu_item = "/html/body/form/table[2]/tbody/tr[2]/td[7]/table/tbody/tr[8]/td"
        menu_item_clicked = false
        i=0
        until menu_item_clicked
            notify_timeout_check(i)
            if browser.cell(:xpath, menu_item).exists?
                browser.cell(:xpath, menu_item).fire_event("onClick")
                return true
            end
            sleep 1
            i+=1
        end
    end
    
    def menu_item_setup
        menu_item = "setup"
        menu_item_clicked = false
        i=0
        until menu_item_clicked
            notify_timeout_check(i)
            if browser.cell(:id, menu_item).exists?
                browser.cell(:id, menu_item).fire_event("onClick")
                menu_item_clicked = true
            end
            sleep 1
            i+=1
        end
    end
    
    def move_file(file_path)
        
    end
    
    def select_file_format(select_item = nil)
        select_box = "exportext"
        if browser.select_list(:id, select_box).exists?
            browser.select_list(:id, select_box).set(select_item)
        end
    end
    
    def select_import_export(select_item = nil)
        #select_box = "impexpwhat"
        #until browser.select_list(:name, select_box).exists?
        #    sleep 1
        #end
        #browser.select_list(:name, select_box).set(select_item)
        i=0
        until browser.cell(:text, select_item).exists?
            notify_timeout_check(i)
            sleep 1
            i+=1
        end
        browser.cell(:text, select_item).fire_event("onClick")
    end
    
    def select_school_menu(select_item = nil)
        select_box = "schoolmenu"
        if browser.select_list(:id, select_box).exists?
            browser.select_list(:id, select_box).set(select_item)
        end
    end
    
    def select_year_menu(select_item = nil)
        select_box = "yearmenu"
        if browser.select_list(:id, select_box).exists?
            browser.select_list(:id, select_box).set(select_item)
        end
    end
    
    def start
        if !structure["start"]
            Watir::Browser.default = "firefox"
            session = Watir::Browser.new
            session.goto("https://jupitergrades.com/login/")
            structure["browser"] = session
            structure["started"] = true
        end
        return structure["start"]
    end
    
    def submit_confirm_export
        #wait for download
        submit = "btn1"
        confirmed = false
        i=0
        until confirmed
            notify_timeout_check(i)
            if browser.cell(:id, submit).exists?
                browser.cell(:id, submit).fire_event("onClick")
                confirmed = true
            end
            sleep 1
            i+=1
        end
    end
    
    def submit_import_export
        submit = "btn2"
        button_exists = false
        i=0
        until button_exists
            notify_timeout_check(i)
            if browser.cell(:id, submit).exists?
                browser.cell(:id, submit).fire_event("onClick")
                button_exists = true
            end
            sleep 1
            i+=1
        end
    end
    
    def notify_timeout_check(times)
        if times >= @timeout
            $base.system_notification(
                subject = "Jupiter Grades Timeout",
                content = caller[0]
            )
            raise("Jupiter Grades Download Timeout Notification!")
        end
    end
    
end