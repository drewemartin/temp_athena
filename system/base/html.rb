#!/usr/local/bin/ruby

class HTML

    #---------------------------------------------------------------------------
    def initialize()
        @structure = structure
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def header(a={})
        
        page_css = $kit.web_script.css          if $kit.web_script.respond_to?("css")
        page_js  = $kit.web_script.javascript   if $kit.web_script.respond_to?("javascript")
        
#"<html><head><title>#{alt_page.page_title}</title></head><body>
#<input type='hidden' name='user_id' value='#{$user}' /> <input type='hidden' name='page' value='#{alt_page_class}' />
#<div id='message_box' style='position:fixed; bottom:0px; left:0px; width:100%; background-color:#D8EBF9; text-align:center; color:red;'></DIV>
#<div id='loading_box' style='position:fixed; bottom:0px; right:0px; margin-left:-32px; margin-top:-32px; z-index:999999;'></DIV>
#<div id='loading_cover' style='position:fixed; bottom:0px; right:0px; margin-left:-32px; margin-top:-32px; z-index:999999;'></DIV>"
        
        output = " 
            <!DOCTYPE HTML>\n
            <head>\n
            <title>#{$kit.web_script.page_title}</title>
            <meta http-equiv='Content-Type'  content='text/html; charset=UTF-8' />\n
            <meta http-equiv='Cache-Control' content='no-cache, no-store, must-revalidate'>\n
            <meta http-equiv='Pragma'        content='no-cache'>\n
            <meta http-equiv='Expires'       content='0'>\n
            #{javascript_links}\n
            <link type='text/css' href='/#{$config.code_set_name}/css/cupertino/jquery-ui-1.8.13.custom.css'    rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/css/general_D20121106.css'                    rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/css/ui_D20121106.css'                         rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/css/search_D20121106.css'                     rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/css/demographics_D20121106.css'               rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/css/expansion_element_D20121106.css'          rel='stylesheet'/>\n
            <link type='text/css' href='/#{$config.code_set_name}/javaScript/jqueryFileTree/jqueryFileTree.css' rel='stylesheet' media='screen' />\n
            <script type='text/javascript' src='http://code.highcharts.com/highcharts.js'					></script>
            <script type='text/javascript' src='http://code.highcharts.com/modules/exporting.js'				></script>
            #{page_css}\n
            #{page_js}
            </head>\n
            <body>\n
            
            <div id='student_page_view_container' name='student_page_view_container'></div>\n
          
            <INPUT type='hidden' id='page'          name='page'         value='#{$kit.page}'>\n
            <INPUT type='hidden' id='user_id'       name='user_id'      value='#{$team_member ? $team_member.preferred_email.value : ''}'>\n
            
            <div id='preload'>\n
              <img src='/#{$config.code_set_name}/images/ajax-loader_07.gif' width='1' height='1'/>\n
              <img src='/#{$config.code_set_name}/images/ajax-loader_08.gif' width='1' height='1'/>\n
              <img src='/#{$config.code_set_name}/images/dialog_error.png'   width='1' height='1'/>\n
            </div>\n
            <DIV id='document_dialog'></DIV>\n
            <DIV id='warning_dialog' style='text-align:center;'></DIV>\n
            #{default_search if a[:default_search]}
            <div id='get_row_dialog' class='get_row_dialog'></div>
            
            <div id='message_box'   style='position:fixed; bottom:0px; left:0px; width:100%; background-color:#D8EBF9; text-align:center; color:red; z-index:999999;'></DIV>
            <div id='loading_box'   style='position:fixed; bottom:0px; right:0px; margin-left:-32px; margin-top:-32px; z-index:999999;'></DIV>
            <div id='loading_cover' style='position:fixed; bottom:0px; right:0px; margin-left:-32px; margin-top:-32px; z-index:999999;'></DIV>
            <div id='how_to_dialog' class='how_to_dialog'></div>
            
            #{a[:body]}
        "
        
        #output << "<script>parent.student_page_view();</script>"
        
        return output
        
    end
    
    def javascript_links
        
        browser_alert = "Athena is currently only supported in Firefox web browser.  Using this browser will cause the site to not function correctly.  Please navigate to www.athena-sis.com in Firefox to ensure the highest compatability."
        
        links =
       "
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/jquery-1.7.2.min.js'>                </script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/jquery-ui-1.8.21.custom.min.js'>     </script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/jquery.jstree.js'>                   </script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/jqueryFileTree/jqueryFileTree.js'>   </script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/jquery-ui-timepicker-addon.js'>      </script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/bindWithDelay.js'>                   </script>\n

        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/data_tables/js/jquery.dataTables.js'></script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/data_tables/extras/TableTools/media/js/TableTools.min.js'></script>\n
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/data_tables/extras/TableTools/media/js/ZeroClipboard.js'></script>\n
        <link type='text/css' href='/#{$config.code_set_name}/javaScript/data_tables/css/jquery.dataTables.css' rel='stylesheet'/>\n
        <link type='text/css' href='/#{$config.code_set_name}/javaScript/data_tables/extras/TableTools/media/css/TableTools.css' rel='stylesheet'/>\n
        
        <script type='text/javascript' src='/#{$config.code_set_name}/javaScript/system_D20131014.js'>                </script>\n
        <script type='text/javascript'>
            var FF = !(window.mozInnerScreenX == null);if(!FF){alert('#{browser_alert}');}
            document.documentElement.className = 'no-fouc';
            $(document).ready(function() {
                $('.no-fouc').removeClass('no-fouc');
            })
        </script>\n
        <script type='text/javascript'>attachJQuery();                                              </script>\n
       "
        return links
    end

    
    def upload_message(message)
        return "<div class='upload_message' style='position:absolute; right:30px; top:20px; z-index:99999'><span class='ui-icon ui-icon-disk' style='float:left; margin-top:1px;'></span>#{message}</div>"
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

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def default_search
        
        #dlg_string      = String.new
        #search_params   = String.new
        #
        #dlg_string << "<div id='search_fields'>"
        #searchable_student_fields = [
        #    "student_id:Student ID",
        #    "studentfirstname:First Name",
        #    "studentlastname:Last Name",
        #    "grade:Grade",
        #    "studentgender:Gender"      
        #]
        #student_fields = $tables.attach("STUDENT").new_row.fields
        #searchable_student_fields.each{|field_details|
        #    field_name      = field_details.split(":")[0]
        #    label           = field_details.split(":")[1]
        #    dlg_string      << student_fields[field_name].web.text(:search=>true, :label_option=>"#{label}:")
        #    html_field_id   = student_fields[field_name].web.field_id(:search=>true)
        #    search_params   << (search_params.empty? ? html_field_id : ",#{html_field_id}")
        #}
        #dlg_string << "<button id='search_button' type='button' onclick=\"send('#{search_params}');\"></button>"
        #dlg_string << "</div>"
        #dlg_string << "<div id='search_results'></div>"
        #dlg_string << "</div>"
        #dlg_string.insert(0, "<div id='search_dialog'><div class='js_error'>Javacript Error!</div>")
        #
        #return dlg_string
    
    end
    
end
