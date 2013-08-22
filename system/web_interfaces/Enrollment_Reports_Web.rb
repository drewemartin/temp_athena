#!/usr/local/bin/ruby

class ENROLLMENT_REPORTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    
    def breakaway_caption
        
        return "Enrollment Reports"
        
    end
    
    def page_title
        
        "Enrollment Reports"
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        output = "<div id='student_container'>"
        
        category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Enrollment'").value
        
        output << "<div id='file_link'><input id='accordion_doctype' name='accordion_doctype' style='display:none;'><input id='accordion_category_id' name='accordion_category_id' value='#{category_id}' style='display:none;'></div>"
        
        output << "<div id='file_viewer'>"
        
        type_ids = $tables.attach("document_type").primary_ids("WHERE category_id='#{category_id}'")
        
        type_ids.each do |type_id|
            
            report_name = $tables.attach("document_type").field_by_pid("name",           type_id).value
            extension   = $tables.attach("document_type").field_by_pid("file_extension", type_id).value
            
            pids = $tables.attach("documents").document_pids(type_id)
            
            count = pids ? pids.length : 0
            
            output << "<h3>#{report_name} (#{count})</h3>"
            
            output << "<div id='#{report_name.gsub(" ","_").downcase}'></div>"
            
        end if type_ids
        
        output << "</div>"
        
        output << "</div>"
        
        return output
        
    end
    
    def response
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
            
            #file_viewer  { margin-bottom:10px; width:800px; margin-left:auto; margin-right:auto;}
            
            h3            { padding-left:30px !important; padding-top:5px !important; padding-bottom:5px !important;}
            
            .defaultIcon  {
                background-image: url('/#{$config.code_set_name}/javaScript/jqueryFileTree/images/directory.png') !important;
                background-repeat: no-repeat;
                background-position: 0px 0px;
            }
            .selectedIcon {
                background-image: url('/#{$config.code_set_name}/javaScript/jqueryFileTree/images/folder_open.png') !important;
                background-repeat: no-repeat;
                background-position: 0px 0px;
            }
            .img          { float:left; clear:both; padding-right:5px; padding-top:3px;}
            .file_link    { float:left; margin-top:2px;}
            
            .get_link     { margin-left: 20px; width:100px; float:right;}
            .link_div     { margin-left: 20px; width:100px; float:right;}
            .link         { margin-left: 20px; width:100px; float:right;}
            
            .even         {background-color:#EEEEEE; padding:2px 10px;;}
            .odd          {background-color:#F2F5F7; padding:2px 10px;;}
            
            .ui-accordion-content{padding:0em !important; max-height:600px;}
            
        "
        output << "</style>"
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    #def javascript
    #    output = "<script type=\"text/javascript\">"
    #    output << "YOUR CODE HERE"
    #    output << "</script>"
    #    return output
    #end
    
end