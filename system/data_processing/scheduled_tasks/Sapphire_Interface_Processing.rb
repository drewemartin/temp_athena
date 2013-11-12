#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base")}/base"
require "#{$paths.system_path}web_scraping/sapphire/sapphire_interface"

class Sapphire_Interface_Processing < Base

    def initialize()
        super()
        number_one________engage!
    end

    def number_one________engage!
        
        until !(
            
            pid = $tables.attach("SAPPHIRE_INTERFACE_QUEUE").field_value(
                "primary_id",
                "WHERE started_datetime IS NULL
                AND completed_datetime IS NULL"
            )
            
        )
            
            x = Sapphire_Interface.new.process_queue(pid)
            i=1
            #x.process_queue(pid)
            #x.login
            #x.goto_module
            #x.goto_student_demographics
            #x.search_students
            #x.select_student
            #
            #params      = nil
            #field_found = false
            #i = 0
            #
            #if browser.select_list(params ? params[:option_type].to_sym : @params[:option_type].to_sym, params ? params[:option_value] : @params[:option_value]).exists?
            #    
            #    browser.select_list(params ? params[:option_type].to_sym : @params[:option_type].to_sym,params ? params[:option_value] : @params[:option_value]).select_value(params ? params[:new_value] : @params[:new_value])
            #    field_found = true
            #    
            #else
            #    sleep 1
            #end
            #
            #until field_found
            #    if x.browser.text_field(params ? params[:option_type].to_sym : puts x.instance_params[:option_type].to_sym, params ? params[:option_value] : x.instance_params[:option_value]).exists?
            #        
            #        browser.text_field(params ? params[:option_type].to_sym : x.instance_params[:option_type].to_sym,params ? params[:option_value] : x.instance_params[:option_value]).set(params ? params[:field_value] : x.instance_params[:field_value])
            #        field_found = true
            #        
            #    else
            #        sleep 1
            #    end
            #    i+=1
            #end
                
            end
        
    end
    
end

Sapphire_Interface_Processing.new