#!/usr/local/bin/ruby

class Web
#FNORD - REMEMBER TO PULL THE VALIDATE MARK OUT ONCE WE HAVE A BETTER PROCESS.
    #---------------------------------------------------------------------------
    def initialize(field_obj) 
        @structure = nil
        self.field = field_obj
        entity_gsub.each_pair do|k,v|
            self.field.value.gsub!(k,v) if self.field.value.class == String
        end
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
    
    def add_class
        validate?
        structure[:add_class]
    end
    
    def callback
        structure[:callback]
    end
    
    def date_range_start
        structure[:date_range_start]
    end
    
    def date_range_end
        structure[:date_range_end]
    end
    
    def dd_choices_option
        structure[:dd_choices]
    end
    
    def defaultDate_catch
        structure[:defaultDate_catch]
    end
    
    def defaultDate_throw
        structure[:defaultDate_throw]
    end
    
    def disabled
        disabled? ? "disabled='disabled'" : ""  
    end
    
    def history
        history? ? button_show_history : ""
    end
    
    def display
        display? ? "style='display:none'" : ""
    end
    
    def div_id
        div_id? ? "id=\"#{structure[:div_id]}\"" : ""
    end
    
    def field
        structure[:field]
    end
    
    def field_class
        if !structure.has_key?(:field_class)
            if field.table_class == "NilClass"
                structure[:field_class] = "#{field.field_name}"
            elsif structure[:search]
                structure[:field_class] = "search__#{field.table_class}__#{field.field_name}"
            else
                structure[:field_class] = "#{field.table_class}__#{field.field_name}"
            end
        end
        structure[:field_class]
    end
    
    def field_id(arg = nil)
        self.options = arg
        if !structure.has_key?(:field_id)
            if field.table_class == "NilClass"
                field_id = field.field_name
                
            elsif structure[:search]
                field_id = "search__#{field.table_class}__#{field.field_name}"
                
            else
                field_id = "field_id__#{field.primary_id}__#{field.table_class}__#{field.field_name}"
                
            end
            structure[:field_id] = freeze(field_id)
        end
        structure[:field_id]
    end
    
    def field_name(arg = nil)
        self.options = arg
        if !structure.has_key?(:field_name)
            if field.table_class == "NilClass"
                field_name = field.field_name
                
            elsif structure[:search]
                field_name = "search__#{field.table_class}__#{field.field_name}"
                
            else
                field_name = "field_id__#{field.primary_id}__#{field.table_class}__#{field.field_name}"
                
            end
            structure[:field_name] = freeze(field_name)
        end
        structure[:field_name]
    end
    
    def file_ext_option
        structure[:file_ext]  
    end
    
    def identifiers
        validate?
        return "id='#{field_id}' name='#{field_name}' class='#{field_class} #{add_class}'"
    end
    
    def js_option
        "#{onchange} #{onclick} #{onload}"
    end
    
    def label_option
        structure[:label_option]
    end
    
    def link_text
        structure[:link_text]
    end
    
    def onchange
        onchange? ? "onchange=\"#{structure[:onchange]}\"" : ""
    end
    
    def onclick
        onclick? ? "onclick=\"#{structure[:onclick]}\"" : ""
    end
    
    def onload
        onload? ? "onload=\"#{structure[:onload]}\"" : ""
    end
    
    def options
        "#{disabled} #{readonly} #{tab_order_option} #{js_option} #{style_option} autocomplete='off'"
    end
    
    def readonly
        readonly? ? "readonly='readonly'" : ""  
    end
    
    def style_option
        structure[:style] ? "style='#{structure[:style]}'" : ""
    end
    
    def tab_order_option
        tab_order? ? "tabindex='#{structure[:tab_order]}'" : ""  
    end
    
    def validate_mark
        validate? ? " *" : ""
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def default(arg = nil)
        self.options = arg
        
        case field.datatype
        when "text"
            textarea(arg)
        when "int", "year", "decimal(5,4)", "decimal(10,2)", "time", "decimal(15,2)"
            text(arg)
        when "date"
            date(arg)
        when "bool","tinyint"
            checkbox(arg)
        when "datetime"
            datetime(arg)
        else
            "peanut butter"
        end
    end
    
    def hidden(arg = nil)
        self.options = arg
        element = "<input #{options} #{identifiers} type ='hidden' value='#{field.value}'>\n"
        div(element)
    end
    
    def text(arg = nil)
        self.options = arg
        element = "<input #{options} #{identifiers} type='text' value='#{field.value}'>#{validate_mark}\n"
        div(element+history)
    end
    
    def label(arg = nil)
        self.options = arg
        element = "<label #{options} name='#{field_name}' class='#{field_class} #{add_class}'>#{field.value}</label>\n"
        div(element)
    end
    
    def button(arg = nil)
        self.options = arg
        element = "<button #{options} #{identifiers} >#{field.value}</button>\n"
        div(element)
    end
    
    def submit(arg = nil)
        self.options = arg
        element = "<input #{options} #{identifiers} type='submit' value='#{field.value}'>\n"
        div(element)
    end
    
    def checkbox(arg = nil)
        if arg && arg.has_key?(:onclick)
            arg[:onclick].insert(0,"toggle_checkbox(this);")
        elsif arg
            arg[:onclick] = "toggle_checkbox(this);"
        else
            arg = {:onclick=>"toggle_checkbox(this)"}
        end
        self.options = arg
        
        checked = field.is_true? ? "checked='checked'" : ''
        element = "<input #{options} #{identifiers} type='checkbox' #{checked} value='#{field.value}'>#{validate_mark}\n"
        div(element+history)
    end
    
    def date(arg = nil)
        self.options = arg
        date_iterator = $tools.date_iterator
        if field.primary_id
            date_id="date_#{field.primary_id}_#{date_iterator}"
        else
            date_id="date_#{date_iterator}"
        end
        
        throw_id = defaultDate_throw ? "#{defaultDate_throw}_#{field.primary_id}" : ""
        catch_id = defaultDate_catch ? "#{defaultDate_catch}_#{field.primary_id}" : ""
        
        element = "<input #{options} readonly='readonly' type='text' name='#{field_id}' class='datepick #{add_class}' id='#{date_id}' value='#{field.to_user}' min='#{date_range_start}' max='#{date_range_end}' throw_to='#{throw_id}' catch_from='#{catch_id}'>#{validate_mark}\n"
        div(element+history)
    end
    
    def datetime(arg = nil)
        self.options = arg
        date_iterator = $tools.date_iterator
        if field.primary_id
            date_id="datetime_#{field.primary_id}_#{date_iterator}"
        else
            date_id="datetime_#{date_iterator}"
        end
        element = "<input #{options} readonly='readonly' type='text' name='#{field_id}' class='datetimepick #{add_class}' id='#{date_id}' value='#{field.to_user}' min='#{date_range_start}' max='#{date_range_end}'>#{validate_mark}\n"
        div(element+history)
    end
    
    def radio(arg = nil)
        self.options = arg
        element = String.new
        structure[:radio_choices].each_with_index{|choice, i|
            selected = choice[:value] == field.value ? "checked" : ""
            element <<  "<input type='radio' id='#{field_id}_#{i}' class='#{field_class}' name='#{field_name}' value='#{choice[:value]}' #{selected}>#{choice[:name]}<br>"
        }if structure[:radio_choices]
        div(element+history)
    end
    
    def select(arg = nil, no_null = nil, select_on_name = nil)
        self.options = arg
        null_display = (no_null || structure[:no_null]) ? "style='display:none';" : ""
        element = "<select #{options} type='select' #{identifiers}>\n"
        element << "<option value='' #{null_display}></option>"
        structure[:dd_choices].each{|choice|
            if select_on_name || structure[:select_on_name]
                if choice[:name] == field.value
                    selected = "selected='selected'"
                elsif choice[:name] == "NULL" && field.value.nil?
                    selected = "selected='selected'"
                else
                    selected = ""
                end
            else
                if choice[:value] == field.value
                    selected = "selected='selected'"
                elsif choice[:value] == "NULL" && field.value.nil?
                    selected = "selected='selected'"
                else
                    selected = ""
                end
            end
            
            element << "<option value='#{choice[:value]}' #{selected}>#{choice[:name]}</option>"
        } if structure[:dd_choices]
        element << "</select>#{validate_mark}"
        div(element+history)
    end
    
    def select_replacement(arg = nil, no_null = nil, select_on_name = nil)
        
        self.options = arg
        null_display = no_null ? "style='display:none';" : ""
        #element = "<select #{options} type='select' #{identifiers}>\n"
        element = "<option value='' #{null_display}></option>"
        structure[:dd_choices].each{|choice|
            if select_on_name
                if choice[:name] == field.value
                    selected = "selected='selected'"
                elsif choice[:name] == "NULL" && field.value.nil?
                    selected = "selected='selected'"
                else
                    selected = ""
                end
            else
                if choice[:value] == field.value
                    selected = "selected='selected'"
                elsif choice[:value] == "NULL" && field.value.nil?
                    selected = "selected='selected'"
                else
                    selected = ""
                end
            end
            
            element << "<option value='#{choice[:value]}' #{selected}>#{choice[:name]}</option>"
        } if structure[:dd_choices]
        #element << "</select>#{validate_mark}"
        
        return element
        
    end
    
    def sym_link(arg = nil, preload_id = nil, change_tab = nil)
        this_onclick    = (!arg.nil? && arg.class == Hash && arg.has_key?(:onclick)) ? arg[:onclick] : "send"
        self.options    = {:label=>false}
        self.options    = arg if arg
        select_tab      = change_tab.nil?   ? "" : "selectTab(#{change_tab});"
        preload         = preload_id.nil?   ? "" : "setPreSpinner('#{preload_id}');"
        self.options    = {:onclick=>"#{this_onclick}('#{field_id}'); #{select_tab} #{preload}"}
        element = "<label style =\"cursor:pointer; text-decoration:underline; color:#12C;\" #{options} >#{link_text||field.value}</label>"
        element << "<input #{identifiers} value='#{field.value}' type ='hidden'></label>"
        div(element)
    end
    
    def title_option
        
        return (structure[:title] ? "title='#{structure[:title]}'" : nil)
        
    end
    
    def link(arg = nil, preload_id = nil, change_tab = nil)
        self.options    = {:label=>false}
        self.options    = arg if arg
        element = "<label style =\"cursor:pointer; text-decoration:underline; color:#3BAAE3;\" #{options}>#{link_text||field.value}</label>"
        div(element)
    end
    
    def button_toggle(arg = nil)
        self.options = arg if arg
        self.options = {:onclick=>"toggle_button(this.id)"}
        element =
            "<input #{options} #{identifiers('stylebutton')} type='button' value='#{field.value}'>\n"
        div(element)
    end
    
    def textarea(arg = nil)
        
        self.options = arg
        
        element = "<textarea #{options} #{identifiers} type='textarea'>#{field.value}</textarea>#{validate_mark}\n"
        div(element+history)
        
    end
    
    def file(arg = nil)
        self.options = arg
        self.options = {:onchange=>"filetype(this, #{file_ext}"}
        element = "<INPUT #{options} #{identifiers} type='file' size='50' enctype='multipart/form-data')/>\n"
        div(element)
    end
    
    def button_show_history #(primary_id, table_name, field_name)
        
        button_html = String.new
        
        params = "#{field.primary_id}__#{field.table_class}__#{field.field_name}"
        
        button_html << "<input id='show_history__#{params}' name='show_history' value='#{params}' type='hidden'>"
        button_html << "<button name='show_history_button' class='show_history_button ui-icon ui-icon-clock' id='show_history_button__#{params}' onclick=\"show_history('show_history__#{params}');\"></button>"
        
        return button_html
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def field=(arg)
        structure[:field] = arg
    end
    
    def options=(arg) #{:dd_choices=>nil,:disabled=>nil,:file_ext=>nil,:hidden=>nil,:on_click=>nil,:label=>nil,:tab_order=>nil}
        if arg
            arg.each_pair{|option,value|
                structure[option]=value
            }
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS
end 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def disabled?
        
        answer = false
        #unless $team_member && $team_member.super_user?
        #    answer = true if (structure[:disabled] == true || !$team_member)
        #end
        
        if $team_member && $team_member.super_user?
            
            answer = false
          
        elsif (structure[:disabled] == true || !$team_member)
            
            answer = true
            
        elsif (structure[:disabled] == false && $team_member)
            
            answer = false
            
        elsif $tables.attach("team_rights").field_order.include?( edit_access_field = $kit.page.downcase.gsub("_web","_edit"))
            
            answer = true if !($team_member.rights.send(edit_access_field).is_true?)
            
        end
        
        return answer
        
    end
    
    def history?
        answer = false
        answer = true if !structure[:history] == false
        return answer
    end
    
    def display?
        answer = false
        answer = true if !structure[:display] == false
        return answer
    end
    
    def div_id?
        answer = false
        answer = true if !structure[:div_id] == false
        return answer
    end
    
    def label?
        answer = false
        answer = true if structure.has_key?(:label_option)
        return answer
    end
    
    def onchange?
        answer = false
        answer = true if structure.has_key?(:onchange)
        return answer
    end
    
    def onclick?
        answer = false
        answer = true if structure.has_key?(:onclick)
        return answer
    end
    
    def onload?
        answer = false
        answer = true if structure.has_key?(:onload)
        return answer
    end
    
    def readonly?
        answer = false
        answer = true if structure[:readonly] == true
        return answer
    end
    
    def tab_order?
        answer = false
        answer = true if structure.has_key?(:tab_order)
        return answer
    end
    
    def validate?
        answer = false
        answer = true if structure.has_key?(:validate) && structure[:validate] == true
        if answer
            structure[:add_class] = "validate"
        end
        return answer
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def div(element)
        label_element = "<label #{field_class} #{options} for='#{field_id}'>#{label_option}</label>\n" if label?
        div_element   = "<DIV #{title_option} class='#{field_class} #{add_class}' #{div_id} #{display}>#{label_element}#{element} </DIV>"
        
        return div_element unless structure[:no_div]
        return "#{label_element}#{element}"
    end
    
    def freeze(water)
        ice = water
        return ice
    end
    
    def entity_gsub
        
        replacement_hash = Hash.new
        
        replacement_hash["'"] = "&#39;"
        
        return replacement_hash
        
    end
    
end
