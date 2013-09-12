#!/usr/local/bin/ruby
#require 'watir'
require 'watir-webdriver'

################################################################################
#Description: Provides basic TV interface capabilities to automation classes
#Created By: Jenifer Halverson
################################################################################
class TV_Interface
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #---------------------------------------------------------------------------
    def initialize()
        
        @creds              = []
        @browser            = ''
        @url             = "https://totalviewschool.k12.com/cgi-bin/WebObjects/TotalViewVA.woa"
        @search_criteria    = []
        
        Struct.new( "STUDENTS_SEARCH",
            :first_name,#0
            :last_name,#1
            :studentid,#2
            :full_part_time,#3
            :status,#4
            :sti,#5
            :engagement,#6
            :grade_s,#7
            :day_past_last_ols_login,#8
            :day_past_last_lms_login,#9
            :special_ed,#10
            :teacher_first_name,#11
            :teacher_last_name,#12
            :zip_code,#13
            :registration_status,#14
            :iol_participation,#15
            :standard_reading,#16
            :standard_math #17
        )
        Struct.new( "STUDENTS_TAB_FAMILY_INCOME",
            :foster_child,#0
            :ward_of_court,#1
            :food_stamp_recipient,#2
            :family_members,#3
            :family_income_frequency,#4
            :family_income_amount,#5
            :information_unchanged,#6
            :free_reduced_meals,#7
            :economically_disadvantaged,#8
            :save_changes#9
        )
        
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    public
    
    #---------------------------------------------------------------------------
    def students_search( criteria_value_pairs )
        #Accepts an array of criteria_value_pairs; ie ["1:smith", "0:joe"]
        #searches for only one, must be called mutiple time if there are many students
        toggle_path = "/html/body/div/div[2]/div/div/div[2]/div/div/div/div"
        search_params = students_search_load( criteria_value_pairs )
        link_found = false
        student_tab_confirmed = false
        i = 0
        until link_found
            if @browser.link(:text, "Students").exists?    
                @browser.link(:text, "Students").click
                sleep 3
                until student_tab_confirmed
                    if @browser.button(:value, "Display All Students").exists?
                        student_tab_confirmed = true
                    elsif i == 30
                        raise "execution expired - `Students` tab" 
                    else
                        i+= 1
                    end
                end
                link_found = true
            end
        end
        search_select(search_params)
        @browser.button(:value, "Search").click#fire_event("onClick")
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def student_found_link
        student_xpath = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/form/div/div/div/div/table/tbody/tr[2]/td[3]/a"
        if @browser.link(:xpath, student_xpath).exists?
            @browser.link(:xpath, student_xpath).fire_event("onClick")
        else
            return false
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def student_found_select(student_id)
        student_checkbox_xpath  = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/div/div/div/table/tbody/tr[2]/td/div/input"
        student_checkbox        = @browser.checkbox(:xpath, student_checkbox_xpath)
        student_id_path         = "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/form/div/div/div/table/tbody/tr[2]/td[2]"
        not_found_path          = "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/p"
        i = 0
        student_id_field_found = false
        until student_id_field_found
            if @browser.element_by_xpath(student_id_path).exists?
                student_id_found = @browser.element_by_xpath(student_id_path).text
                student_id_field_found = true
            elsif @browser.element_by_xpath(not_found_path).exists?
                return false if @browser.element_by_xpath(not_found_path).text == "No Results Found"
            elsif i == 20
                raise "execution expired on search results."
            end
            i+=1
            sleep 1
        end
        
        if student_id_found == student_id  
            i = 0
            student_checkbox_checked = false
            until student_checkbox_checked
                if student_checkbox.exists?
                    student_checkbox.set
                    student_checkbox_checked = true
                    return true
                elsif i < 5
                    puts i
                    i += 1
                    sleep 1
                else
                    puts student_id
                    return false
                end
            end
        else
            return false
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def students_tab_family_income
        
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_browser(arg)
        @browser = arg
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def set_creds(arg)
        if arg.split(":").length == 2
            creds_db = $tables.attach("CREDENTIALS").data_base
            task_system = arg.split(":")
            cred_sql =
            "SELECT
                credn,
                credp
            FROM credentials
            WHERE task = '#{task_system[0]}'
            AND system = '#{task_system[1]}'"
            results = $db.get_data(cred_sql, creds_db)
            if results    
                @creds = results[0]
            else
                return false
            end
            return true
        else
            return false
        end
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def sign_in
        @browser.goto( @url )
        i = 0
        logged_in = false
        confirmed = false
        until logged_in
            if @browser.text_field(:name, "username").exists? || i == 30 #trying to let it error out so it can be retried.
                @browser.text_field(:name, "username").set @creds[0]
                @browser.text_field(:name, "password").set @creds[1]
                @browser.button(:value, "Login").click
                j = 0
                until confirmed
                    if @browser.link(:text, "Logout").exists?
                        confirmed = true
                        logged_in = true
                    elsif j == 30
                        raise exception, "execution expired #{__LINE__}"
                        #@browser.link(:text, "Logout").click #clicking purposefully to produce an error
                    else
                        j += 1
                        sleep 1
                    end
                end
                
            else
                i += 1
                sleep 1
            end   
        end
        
        return @browser  
    end
    #---------------------------------------------------------------------------    

    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #---------------------------------------------------------------------------
    def students_search_load( criteria_value_pairs )
        #NOTE: This step adds the type of element and xpath to be used to find the search field, then adds the user defined search criteria use push
        
        search_params = Struct::STUDENTS_SEARCH.new()
        search_params.first_name                = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[2]/td[2]/input"           ]
        search_params.last_name                 = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[2]/td[4]/input"           ]
        search_params.studentid                 = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[3]/td[2]/input"           ]
        search_params.full_part_time            = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[4]/td[2]/select"          ]
        search_params.status                    = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[5]/td[2]/select"          ]
        search_params.sti                       = ["checkbox",   "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[6]/td[2]/input"           ]
        search_params.engagement                = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[7]/td[2]/select"          ]
        search_params.grade_s                   = ["option",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[8]/td[2]/select/option"   ]
        search_params.day_past_last_ols_login   = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[9]/td[2]/input"           ]
        search_params.day_past_last_lms_login   = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[9]/td[4]/input"           ]
        search_params.special_ed                = ["checkbox",   "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[10]/td[2]/input"          ]
        search_params.teacher_first_name        = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[11]/td[2]/input"          ]
        search_params.teacher_last_name         = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[11]/td[4]/input"          ]
        search_params.zip_code                  = ["text_field", "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[3]/td[4]/input"           ]
        search_params.registration_status       = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[4]/td[4]/select"          ]
        search_params.iol_participation         = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[5]/td[4]/select"          ]
        search_params.standard_reading          = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[6]/td[4]/select"          ]
        search_params.standard_math             = ["select",     "/html/body/div/div[2]/div/div/div[2]/div/div/div[2]/div/form/table/tbody/tr[7]/td[4]/select"          ]
        
        i = 0
        while i < criteria_value_pairs.length
            criteria_value_pair = criteria_value_pairs[i].split(':')
            criteria = Integer(criteria_value_pair[0])
            value = criteria_value_pair[1]
            search_params[criteria].push(value)
            i+=1   
        end
        
        return search_params
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def students_tab_family_income_load(criteria_value_pairs)
        family_income_tab = Struct::STUDENTS_TAB_FAMILY_INCOME.new()
        
        family_income_tab.foster_child                  = ["checkbox",      "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[2]/td[2]/input"                            ]
        family_income_tab.ward_of_court                 = ["checkbox",      "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[2]/td[2]/input[2]"                         ]   
        family_income_tab.food_stamp_recipient          = ["checkbox",      "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[2]/td[2]/input[3]"                         ]  
        family_income_tab.family_members                = ["text_field",    "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[5]/td[2]/input"                            ]
        family_income_tab.family_income_frequency       = ["select",        "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[6]/td[2]/select"                           ]
        family_income_tab.family_income_amount          = ["text_field",    "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[6]/td[2]/input"                            ]  
        family_income_tab.information_unchanged         = ["checkbox",      "//*[@id='IncomeNeedsVerify']"                                                                                                                                      ]      
        family_income_tab.free_reduced_meals            = ["select",        "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[12]/td/table/tbody/tr/td[2]/select"        ]
        family_income_tab.economically_disadvantaged    = ["select",        "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[12]/td/table/tbody/tr[2]/td[2]/select"     ] 
        family_income_tab.save_changes                  = ["button",        "/html/body/div/div[2]/div/div/div[2]/div/div[2]/div/div[3]/ul[2]/li[9]/div/div/form/table/tbody/tr[3]/td/table/tbody/tr[12]/td/table/tbody/tr[2]/td[2]/select"     ]
        
        i = 0
        while i < criteria_value_pairs.length
            criteria_value_pair = criteria_value_pairs[i].split(':')
            criteria = Integer(criteria_value_pair[0])
            value = criteria_value_pair[1]
            family_income_tab[criteria].push(value)
            i+=1   
        end
        
        return family_income_tab
    
    end
    #---------------------------------------------------------------------------
    
    #---------------------------------------------------------------------------
    def search_select(search_params) #perhaps expand this to include all setting/selecting tasks, no time atm, maybe even becoming a public class
        
        i = 0
        while i < search_params.length
            search_param = search_params[i]
            if search_param.length > 2
                param_field     = @browser.text_field(:xpath, search_param[1])
                param_criteria  = search_param[2]
                param_field_found = false
                
                until param_field_found
                    if param_field.exists?
                        param_field.set param_criteria
                        param_field_found = true
                    end
                end
            end
            i += 1   
        end
        
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|A|c|c|e|s|s|o|r|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                  
    public
    
    #---------------------------------------------------------------------------
    def search_criteria
        @search_criteria
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|o|d|i|f|i|e|r|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                                                  
    public
    
    #---------------------------------------------------------------------------
    def search_criteria=(myarg)
        @search_criteria = myarg
    end
    
    def creds=(myarg)
        @creds = myarg
    end

end