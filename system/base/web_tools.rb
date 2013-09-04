#!/usr/local/bin/ruby

class Web_Tools

    #---------------------------------------------------------------------------
    def initialize()
        @structure          = structure
        @date_iterator      = 0
        @breakaway_iterator = 1
        @csv_iterator       = 1
        @expand_iterator    = 1
        @tabs_iterator      = 0
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def date_iterator
        return @date_iterator += 1
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ELEMENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def newlabel(class_name, message = "")
        temp = $field.new({"type" => "text", "field" => class_name, "value" => message})
        return temp.web.label()
    end
    
    def newdate(class_name, label_option="")
        temp = $field.new({"type" => "text", "field" => class_name})
        return temp.web.date({:label_option=>label_option, :add_class=>"no_save"})
    end
    
    def kmailinput(class_name, label_option="", value="")
        temp = $field.new({"type" => "text", "field" => class_name, "value" => value})
        return temp.web.text({:label_option=>label_option, :add_class=>"no_save kmail_validate_content"})
    end
    
    def newselect(class_name, choices, label_option="", add_class="")
        temp = $field.new({"type" => "text", "field" => class_name})
        return temp.web.select({:label_option=>label_option, :dd_choices=>choices, :add_class=>"no_save #{add_class}"})
    end
    
    def newtextarea(class_name, label_option="", value="")
        temp = $field.new({"type" => "text", "field" => class_name, "value" => value})
        return temp.web.textarea({:label_option=>label_option, :add_class=>"no_save"})
    end
    
    def newdisabledtextarea(class_name, label_option="", value="")
        temp = $field.new({"type" => "text", "field" => class_name, "value" => value})
        return temp.web.textarea({:label_option=>label_option, :add_class=>"no_save", :readonly=>true})
    end
    
    def kmailtextarea(class_name, label_option="", value="")
        temp = $field.new({"type" => "text", "field" => class_name, "value" => value})
        return temp.web.textarea({:label_option=>label_option, :add_class=>"no_save kmail_validate_content"})
    end
    
    

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUICK_TOOLS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def div_open(class_name, id_name = "", hide = false)
        hide = hide ? "style='display: none'" : ''
        temp = "<DIV class = '#{class_name}' id = '#{id_name}' name = '#{class_name}' #{hide}>"
    end
    
    def div_close
        temp = "</DIV>"
    end
    
    def legend_open(class_name, header="")
        temp = "<FIELDSET><LEGEND class = #{class_name}>#{header}</LEGEND>"
    end
    
    def legend_close
        temp = "</FIELDSET>"
    end
    
    def csv_upload(web_script, unique_id="", size = "50")
        output = ""
        id = unique_id=="" ? "csv_upload" : "csv_upload__#{unique_id}"
        output = "
        <input type='hidden' name='page' value='#{web_script}' />
        <input type ='hidden' id= 'user_id' name= 'user_id' value= '#{$user.class == String ? $user : $user.email_address_k12.value}'>
        <input class='csv_upload' name='csv_upload' id='#{unique_id}' size='#{size}' type='file' onchange='ext_check(this, \"csv\")'/>
        <iframe id='upload_iframe_#{unique_id}' name='upload_iframe_#{unique_id}' src='' position:absolute;' onload='handle_upload(this, \"#{unique_id}\")'>
        </iframe>"
        structure[:csv_upload] = output
    end
    
    def pdf_upload(web_script, unique_id="", size = "50")
        output = ""
        id = unique_id=="" ? "pdf_upload" : "pdf_upload__#{unique_id}"
        output = "
        <input type='hidden' name='page' value='#{web_script}' />
        <input type ='hidden' id= 'user_id' name= 'user_id' value= '#{$user.class == String ? $user : $user.email_address_k12.value}'>
        <input class='pdf_upload' name='pdf_upload' id='#{unique_id}' size='#{size}' type='file' onchange='ext_check(this, \"pdf\")'/>
        <iframe id='upload_iframe_#{unique_id}' name='upload_iframe_#{unique_id}' src='' position:absolute;' onload='handle_upload(this, \"#{unique_id}\")'>
        </iframe>"
        structure[:csv_upload] = output
    end
    
    #FNORD - This funtion is not an ecapsulated tool. It is specific to admin verification and should not be placed here, or should be generalized.
    def multiple_icon_ver(initial_icon, vrecord)
        structure[:admin_ver] = vrecord.web.hidden()
        structure[:multiple_icon_ver] = "<DIV class='multi-icon ui-icon #{initial_icon}' id='ui-icon #{initial_icon}' onclick='tripleStateSelect(this);'></DIV>"
        return "#{structure[:multiple_icon_ver]} #{structure[:admin_ver]}"
    end
    
    def west_south_toggle(value=nil)
        if !structure.has_key?(:toggle_button)
            structure[:toggle_button] = "<DIV class='ui-icon ui-icon-triangle-1-w' id='ui-icon ui-icon-triangle-1-w' onclick='westSouthExpand(this);'></DIV>"
        end
        if value
            params = {
                "type"  => "text",
                "field" => "hidden_value_#{value.gsub(" ", "_")}",
                "value" => value
            }
            structure[:hidden_value] = $field.new(params).web.hidden()
        end
        return "#{structure[:toggle_button]} #{structure[:hidden_value]}"
    end
    
    def delete_button(table, pid)
        return "<button class='delete' id='#{table}__#{pid}'>DELETE</button>"
    end
    
    def callback_button(method_to_call, button_text="Add New Record", args="") #args separated by "__"
        return structure[:callback_button] = "<input id='#{method_to_call}_callback' name='callback' value='#{method_to_call}__#{args}' type='hidden'><button class='callback_button' id='#{method_to_call}-button'>#{button_text}</button>"
    end
    
    def callback(callback_string, webscript)
        args = callback_string.split("__")
        cb = args.shift.to_sym
        webscript.send(cb, *args) if respond_to? webscript.send(cb, *args)
        return cb, *args
    end
    
    def get_new_row_pid
        pid = ""
        $kit.rows.each_value do |row|
            pid = row.fields["primary_id"].value
        end
        return pid
    end
    
    def document_upload(web_script, person_id, unique_id="", ext="pdf", type=nil, file_name="document", size = "50")
        output = ""
        id = unique_id=="" ? "doc_upload" : "doc_upload__#{unique_id}"
        type_field = String.new
        if type
            type_field = "<input id='doc_type' name='doc_type' value='#{type}' style='display:none;'>"
        else
            type_field = "#{newselect('doc_type', $tables.attach('DOCUMENT_TYPE').dd_choices('nice_name', 'dir_name'), 'Document Type', "validate")}"
        end
        output = "
        <input type='hidden' name='page' value='#{web_script}' />
        <input type ='hidden' id= 'user_id' name= 'user_id' value= '#{$user.class == String ? $user : $user.email_address_k12.value}'>
        <input class='doc_upload validate' name='doc_upload' id='#{unique_id}_input' size='#{size}' type='file' onchange='ext_check(this, \"#{ext}\"); get_set_ext(this);'/>
        #{type_field}
        <input class='file_name' name='file_name' id='file_name' style='display:none;' value='#{person_id}_#{file_name}_#{$ifilestamp}'>
        <input class='extension' name='extension' id='extension' style='display:none;'>
        <iframe id='upload_iframe_#{unique_id}' name='upload_iframe_#{unique_id}' src='' position:absolute;' onload='handle_upload(this, \"#{unique_id}\")'>
        </iframe>"
        return output
    end
    
    def document_upload2(web_script, category, type, unique_id, valid_ext, size = "50")
        
        return  "
            
            <input type='hidden' name='page' value='#{web_script}'>
            <input type='hidden' id= 'user_id' name= 'user_id' value='#{$user.class == String ? $user : $user.email_address_k12.value}'>
            <input type='file' id='#{unique_id}_input' class ='doc_upload validate' name='doc_upload' size='#{size}' onchange='ext_check(this, \"#{valid_ext}\"); get_set_ext(this);'>
            <input id='doc_category' name='doc_category' value='#{category}' style='display:none;'>
            <input id='doc_type' name='doc_type' value='#{type}' style='display:none;'>
            <input id='extension' class='extension' name='extension' style='display:none;'>
            <iframe id='upload_iframe_#{unique_id}' name='upload_iframe_#{unique_id}' src='' position:absolute;' onload='handle_upload(this, \"#{unique_id}\")'>
            </iframe>
            
        "
        
    end
    
    #def ordered_list(list_array, class_name="", id="")
    #    output = "<ol class='#{class_name}' id='#{id}'>"
    #    list_array.each_with_index do |item, i|
    #        output << "<li class='ui-widget-content title='#{i}'>#{item}</li>"
    #    end
    #    output << "</ol>"
    #end
    
    def set_primary(fields, pid)
        fields.each_pair do |k,v|
            v.primary_id = pid
        end
    end
    
    def start_branch(title, expanded = false)
        expanded = expanded ? "open" : "closed"
        "<LI class='#{expanded}'>#{title}
        <UL>
        <LI>"
    end
  
    def end_branch
        "</LI>
        </UL>
        </LI>"
    end
    
    def form(form_content, form_name = "", new_rec = false)
        form_html = ""
        this_form_name = "#{form_name}"
        form_header = ""
        form_header << "<DIV class='#{form_name}'>\n"
        form_header << "<FORM id='#{this_form_name}' name='#{form_name}' enctype='multipart/form-data' action='/cgi-bin/athena_cgi.rb' style='visibility: visible;' method='post'>\n"
        form_header << "<INPUT type='hidden' name='page' value='#{$kit.page}'>\n"
        form_header << "<INPUT type ='hidden' id = 'user_id' name = 'user_id' value = '#{$user.email_address_k12.value}'>\n"
        #if !new_rec
        #    form_header << "<INPUT type ='hidden' id = 'ajax_load' name = 'ajax_load' value = '#{$kit.ajax_load}'>\n"    
        #end
        form_html = form_header << form_content << "</FORM>\n</DIV>\n"
        return form_html
    end
    
    def forms(content_array, form_name = "", index = false)
        forms_html = ""
        content_array.each_with_index do |form_content, i|
            row_num = i%2 == 0 ? "row0" : "row1"
            this_form_name = index ?  "#{form_name}_#{i}" : "#{form_name}"
            form_header = "<DIV class='#{form_name} #{row_num}'>
            <form id='#{this_form_name}' name='#{this_form_name}' enctype='multipart/form-data' action='/cgi-bin/athena_cgi.rb' style='visibility: visible;' method='post'>
            <input type='hidden' name='page' value='#{$kit.page}'>
            <input type ='hidden' id = 'user_id' name = 'user_id' value = '#{$user}'>
            <input type ='hidden' id = 'update' name = 'update' value = '#{$kit.update}'>"    
            form = form_header << form_content << "</form></DIV>"
            forms_html << form
        end
        return forms_html
    end
    
    def tabs(tab_elements, active_tab=0, tab_id=nil, search=true)
        
        tabs_html =
        "<script type=\'text/javascript\'>
        $(function(){
            $('#tabs_#{tab_id}').tabs({
                selected: #{active_tab},
                show: function(event, ui) {
                    var oTable = $('div.dataTables_scrollBody>table.dataTable', ui.panel).dataTable();
                    if ( oTable.length > 0 ) {
                        oTable.fnAdjustColumnSizing();
                        var oTableTools = TableTools.fnGetInstance( oTable[0] );
                        if ( oTableTools != null && oTableTools.fnResizeRequired() ){
                            oTableTools.fnResizeButtons();
                        }
                    }
                }
            });
        });
        </script>"
       
        title_html   = String.new
        #title_html   << "<button class='search_button' id='search_dialog_button' style='position:absolute; right:10px; top:10px;'>Search</button>" if search
        
        content_html = ""
        tab_elements.each_with_index do |element, i|
            title_html   << "<li><a id='tab_title-#{i+1}' href='#tabs-#{i+1}'>#{element[0]}</a></li>"
            content_html << "<DIV class='ui-tabs-hide' id='tabs-#{i+1}'>#{element[1]}</DIV>"
        end
        
        tabs_html << "<DIV class='ui-tabs' id='tabs_#{tab_id}'>"
        tabs_html << "<UL>#{title_html}</UL>"
        tabs_html << content_html
        tabs_html << "</DIV>"
        
        if tab_id && tab_id.match(/vertical/i)
            
            tabs_html << "
            <style type='text/css'>
                /* Vertical Tabs
                ----------------------------------*/
                .ui-tabs-vertical { width: 55em; }
                .ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; width: 12em; }
                .ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
                .ui-tabs-vertical .ui-tabs-nav li a { display:block; }
                .ui-tabs-vertical .ui-tabs-nav li.ui-tabs-selected { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; border-right-width: 1px; }
                .ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: right; width: 40em;}
            </style> 
                
                <script>
                    $(document).ready(function() {
                        $('#tabs_#{tab_id}').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
                        $('#tabs_#{tab_id} li').removeClass('ui-corner-top').addClass('ui-corner-left');
                    });
            </script>"
            
            tabs_html << "<eval_script>
                $(function(){
                $('#tabs_#{tab_id}').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
                $('#tabs_#{tab_id} li').removeClass('ui-corner-top').addClass('ui-corner-left');
                $('#tabs_#{tab_id}').tabs({
                    selected: #{active_tab},
                    show: function(event, ui) {
                        var oTable = $('div.dataTables_scrollBody>table.dataTable', ui.panel).dataTable();
                        if ( oTable.length > 0 ) {
                            oTable.fnAdjustColumnSizing();
                            if ( oTableTools != null && oTableTools.fnResizeRequired() ){
                                oTableTools.fnResizeButtons();
                            }
                        }
                    }
                });
            });</eval_script>"
            
        elsif tab_id
            
            tabs_html << "<eval_script>
                $(function(){
                $('#tabs_#{tab_id}').tabs({
                    selected: #{active_tab},
                    show: function(event, ui) {
                        var oTable = $('div.dataTables_scrollBody>table.dataTable', ui.panel).dataTable();
                        if ( oTable.length > 0 ) {
                            oTable.fnAdjustColumnSizing();
                            var oTableTools = TableTools.fnGetInstance( oTable[0] );
                            if ( oTableTools != null && oTableTools.fnResizeRequired() ){
                                oTableTools.fnResizeButtons();
                            }
                        }
                    }
                });
            });</eval_script>"
         
        end
        
        return tabs_html
        
    end
    
    def student_demographics(sid)
        
        output = String.new
        
        if sid.class != String
            sid = sid.student_id
        end
        
        t       = $team.get($user.sams_id)
        s       = $students.get(sid)
        student = $students.attach(sid)
        
        output << "<div class='student_demographics'>"
            
            add_str = "#{s.mailingaddress1.value}<br>"
            add_str << "#{!s.mailingaddress2.value.nil? ? s.mailingaddress2.value+"<br>" : ""}"
            add_str << "#{s.mailingcity.value}, #{s.mailingstate.value} #{s.mailingzip.value}"
            
            att_array = Array.new
            a1, b1 = "Enroll Date:"     , s.schoolenrolldate.value
            a2, b2 = "Days Enrolled:"   , student.attendance.enrolled_days.length
            a3, b3 = "Days Attended:"   , student.attendance.attended_days.length
            a4, b4 = "Days Excused:"    , student.attendance.excused_absences.length
            a5, b5 = "Days Unexcused:"  , student.attendance.unexcused_absences.length
            att_array.push([a1.to_s,b1.to_s])
            att_array.push([a2.to_s,b2.to_s])
            att_array.push([a3.to_s,b3.to_s])
            att_array.push([a4.to_s,b4.to_s])
            att_array.push([a5.to_s,b5.to_s])
            att_section = $tools.table(
                :table_array    => att_array,
                :unique_name    => "demo_section_att",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            id_array = Array.new
            a1, b1 = "First Name:"      , s.studentfirstname.value
            a2, b2 = "Last Name:"       , s.studentlastname.value
            a3, b3 = "StudentID:"       , s.student_id.value
            a4, b4 = "FamilyID:"        , s.familyid.value
            a5, b5 = "Grade:"           , s.grade.value
            id_array.push([a1.to_s,b1.to_s])
            id_array.push([a2.to_s,b2.to_s])
            id_array.push([a3.to_s,b3.to_s])
            id_array.push([a4.to_s,b4.to_s])
            id_array.push([a5.to_s,b5.to_s])
            id_section = $tools.table(
                :table_array    => id_array,
                :unique_name    => "demo_section_id",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            spec_disable = true unless $team_member.has_rights?("1")
            if s.specialist_reading.existing_record || s.specialist_reading.new_record.save
                
                rspec_array = Array.new
                a1, b1 = "M"            , s.specialist_reading.monday.web.default(      :disabled=>spec_disable)
                a2, b2 = "T"            , s.specialist_reading.tuesday.web.default(     :disabled=>spec_disable)
                a3, b3 = "W"            , s.specialist_reading.wednesday.web.default(   :disabled=>spec_disable)
                a4, b4 = "Th"           , s.specialist_reading.thursday.web.default(    :disabled=>spec_disable)
                a5, b5 = "F"            , s.specialist_reading.friday.web.default(      :disabled=>spec_disable)
                rspec_array.push([a1.to_s,b1.to_s])
                rspec_array.push([a2.to_s,b2.to_s])
                rspec_array.push([a3.to_s,b3.to_s])
                rspec_array.push([a4.to_s,b4.to_s])
                rspec_array.push([a5.to_s,b5.to_s])
                rspec_section = $tools.table(
                    :table_array    => rspec_array,
                    :unique_name    => "demo_section_spec",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => false
                )
                
            else
                
                rspec_section = false
                
            end
            
            
            
            
            demo_section = Array.new
            
            a1, b1 = "Student Identity"     , id_section
            a2, b2 = ""                     , ""
            a3, b3 = "Specialists"          , specialists(sid)
            a4, b4 = ""                     , ""
            a5, b5 = "Attendance"           , att_section
            demo_section.push([a1.to_s,a2.to_s,a3.to_s,a4.to_s,a5.to_s])
            demo_section.push([b1.to_s,b2.to_s,b3.to_s,b4.to_s,b5.to_s])
            
            #a1, b1 = "Address:"         , add_str
            #a2, b2 = "Phone Number:"    , s.studenthomephone.value
            #a3, b3 = "Birthday:"        , s.birthday.value
            #a4, b4 = "Age:"             , $base.age_from_date(s.birthday.value)
            #a5, b5 = "Age:"             , $base.age_from_date(s.birthday.value)
            #demo_section.push([a1.to_s,a2.to_s,a3.to_s,a4.to_s,a5.to_s])
            #demo_section.push([b1.to_s,b2.to_s,b3.to_s,b4.to_s,b5.to_s])
            
            output << $tools.table(
                :table_array    => demo_section,
                :unique_name    => "demo_section",
                :footers        => false,
                :head_section   => true,
                :title          => false,
                :caption        => false
            )
            
            output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            output << "<style>"
                
                output << "table#demo_section                          { width:100%; font-size: small; text-align:center;    }"
                output << "table#demo_section                        td{ width:20%; height:20px;                             }"
                #output << "table#demo_section                td.odd_row{ vertical-align:bottom;font-weight:bold;             }"
                #output << "table#demo_section               td.even_row{ vertical-align:top;                                 }"
                #output << "table#demo_section                        th{ font-weight:bold; border-bottom: 1px solid #000000;      }"
               
                output << "table#demo_section_att                      { 
                    width       : 80%;
                    font-size   : x-small;
                    text-align  : center;
                    margin-left : auto;
                    margin-right: auto;
                }"
                output << "table#demo_section_att                    td{ width:50%;                                          }"
                output << "table#demo_section_att           td.column_0{ vertical-align:middle; text-align:left;             }"
                output << "table#demo_section_att           td.column_1{ vertical-align:middle; text-align:right;            }"
                output << "table#demo_section_att            td.odd_row{ vertical-align:middle; font-weight:normal;          }"
                output << "table#demo_section_att           td.even_row{ vertical-align:middle;                              }"
                output << "table#demo_section_att                    th{ width:300px; border-bottom: 1px solid #000000;      }"
               
                output << "table#demo_section_id                       {
                    width       : 80%;
                    font-size   : x-small;
                    text-align  : center;
                    margin-left : auto;
                    margin-right: auto;
                }"
                output << "table#demo_section_id                     td{ width:50%;                                          }"
                output << "table#demo_section_id            td.column_0{ vertical-align:middle; text-align:left;             }"
                output << "table#demo_section_id            td.column_1{ vertical-align:middle; text-align:right;            }"
                output << "table#demo_section_id             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
                output << "table#demo_section_id            td.even_row{ vertical-align:middle;                              }"
                output << "table#demo_section_id                     th{ width:300px; border-bottom: 1px solid #000000;      }"
                
                output << "table#demo_section_spec                     {
                    width       : 80%;
                    font-size   : x-small;
                    font-weight : normal;
                    text-align  : center;
                    margin-left : auto;
                    margin-right: auto;
                }"
                output << "table#demo_section_spec             div.day { display:inline-block; width:20%;  text-align:center;}"
                output << "table#demo_section_spec         td.column_0 { width:20%; vertical-align:middle; text-align:left;  }"
                output << "table#demo_section_spec         td.column_1 { width:60%; vertical-align:middle; text-align:left; }"
                output << "table#demo_section_spec            tr.row_1 { border: 1px solid red; }"
                output << "select#field_id__2__STUDENT_SPECIALIST_MATH__team_id     { width:100%;                            }"
                output << "select#field_id__2__STUDENT_SPECIALIST_READING__team_id  { width:100%;                            }"
                
            output << "</style>"
            
        output << "</div>"
        
        output << button_hide("student_demographics")
        return output

        #}
        #
        #structure[:student_id_field]  = $field.new(sid_params).web.hidden()
        #structure[:dob_field]         = $field.new(dob_params)
        #structure[:enroll_date_field] = $field.new(enroll_date_params)
        #student.mailing_address_line_two.value = ", #{student.mailing_address_line_two.value}" if student.mailing_address_line_two.value
        #address_block = "#{student.mailing_address.value}#{student.mailing_address_line_two.value}<br>#{student.mailing_city.value}, #{student.mailing_state.value} #{student.mailing_zip.value}" 
        #
        #scantron_level_row = $tables.attach("Scantron_Performance_Level").by_studentid_old(student.sid.value)
        #
        #output << div_open("demographics_container","demographics_container")
        #    output << structure[:student_id_field]
        #    output << student.grade.web.hidden
        #    
        #    student.phone_number.to_phone_number
        #    student.birthday.to_user
        #    student.specialed_teacher.value = "N/A" if !student.specialed_teacher.value
        #    
        #    output << div_open("demographics_one")
        #        output << student.fullname.web.label(              {:label_option=>"Name:",         :div_id=>"dem_fullname",                :field_class=>"dem_fullname_label"           })
        #        output << student.sid.web.label(                   {:label_option=>"Student ID:",   :div_id=>"dem_sid",                     :field_class=>"dem_sid_label"                })
        #        output << student.grade.web.label(                 {:label_option=>"Grade:",        :div_id=>"dem_grade",                   :field_class=>"dem_grade_label"              })
        #        output << structure[:dob_field].web.label(         {:label_option=>"DOB:",          :div_id=>"dem_dob",                     })
        #        output << student.family_id.web.label(             {:label_option=>"Family Id:",    :div_id=>"dem_fid",                     :field_class=>"dem_fid_label"                })
        #        output << scantron_level_row.fields["stron_ent_perf_m"].web.label({:label_option=>"Scantron Entrance Math:",:div_id=>"dem_stron_entm",}) if scantron_level_row
        #    output << div_close
        #    output << div_open("demographics_two")
        #        output << $school.current_school_year.web.label(   {:label_option=>"School Year:",  :div_id=>"dem_current_school_year",     :field_class=>"dem_current_school_yearlabel" })
        #        output << structure[:enroll_date_field].web.label( {:label_option=>"Enroll Date:",  :div_id=>"dem_school_enroll_date",      :field_class=>"dem_school_enroll_date_label" })
        #        output << student.specialed_teacher.web.label(     {:label_option=>"SpEd Teacher:", :div_id=>"dem_specialed_teacher",       :add_class=>"no_save", :readonly=>true       })
        #        output << student.family_teacher_coach.web.label(  {:label_option=>"Family Coach:", :div_id=>"dem_family_teacher_coach",    :add_class=>"no_save", :readonly=>true       })
        #        output << "<DIV id='filler'></DIV>"
        #        output << scantron_level_row.fields["stron_ext_perf_m"].web.label({:label_option=>"Scantron Exit Math:",}) if scantron_level_row
        #    output << div_close
        #    output << div_open("demographics_three")
        #        output << div_open("address_block") << address_block << div_close
        #        output << student.districtofresidence.web.label(   {                                :div_id=>"dem_dor",                     :field_class=>"dem_dor_label"                })
        #        output << student.phone_number.web.label(          {                                :div_id=>"dem_phone_number",            :add_class=>"no_save", :readonly=>true       })
        #        output << "<DIV id='filler'></DIV>"
        #        output << scantron_level_row.fields["stron_ent_perf_r"].web.label({:label_option=>"Scantron Entrance Reading:",}) if scantron_level_row
        #    output << div_close
        #    output << div_open("demographics_four")
        #        output << $field.new(enrolled_days_params).web.label(       {:label_option=>"Enrolled Days:"})
        #        output << $field.new(attended_days_params).web.label(       {:label_option=>"Present Days:"})
        #        output << $field.new(excused_absences_params).web.label(    {:label_option=>"Excused Absences:"})
        #        output << $field.new(unexcused_absences_params).web.label(  {:label_option=>"Unexcused Absences:"})
        #        output << "<DIV id='filler'></DIV>"
        #        output << scantron_level_row.fields["stron_ext_perf_r"].web.label({:label_option=>"Scantron Exit Reading:",}) if scantron_level_row
        #    output << div_close
        #    output << newlabel("bottom")
        #output << div_close
        #return output
    end
    
    def specialists(s)
        
        s = $students.get(s) if !(s.class == Student_API)
        
        mspec_exists = s.specialist_math.existing_record    || s.specialist_math.new_record.save
        rspec_exists = s.specialist_reading.existing_record || s.specialist_reading.new_record.save
        if mspec_exists && rspec_exists
            
            spec_disable = $team_member.has_rights?("1") ? false : true
            
            spec_array = Array.new
            
            #MATH
            a1, b1 = "<div class='day'>M    #{s.specialist_math.monday.web.default(     :disabled=>spec_disable)}       </div>", s.specialist_math.monday.web.default(      :disabled=>spec_disable)
            a2, b2 = "<div class='day'>T    #{s.specialist_math.tuesday.web.default(    :disabled=>spec_disable)}      </div>", s.specialist_math.tuesday.web.default(     :disabled=>spec_disable)
            a3, b3 = "<div class='day'>W    #{s.specialist_math.wednesday.web.default(  :disabled=>spec_disable)}    </div>", s.specialist_math.wednesday.web.default(   :disabled=>spec_disable)
            a4, b4 = "<div class='day'>Th   #{s.specialist_math.thursday.web.default(   :disabled=>spec_disable)}     </div>", s.specialist_math.thursday.web.default(    :disabled=>spec_disable)
            a5, b5 = "<div class='day'>F    #{s.specialist_math.friday.web.default(     :disabled=>spec_disable)}       </div>", s.specialist_math.friday.web.default(      :disabled=>spec_disable)
            
            spec = spec_disable ? s.specialist_math.team_id.to_name : s.specialist_math.team_id.web.select(:dd_choices=>dd_team_members)
            spec_array.push(["Math:",spec || "Not Assigned"])
            spec_array.push(["",a1.to_s+a2.to_s+a3.to_s+a4.to_s+a5.to_s])
            
            #READING
            a1, b1 = "<div class='day'>M    #{s.specialist_reading.monday.web.default(      :disabled=>spec_disable)}    </div>", s.specialist_reading.monday.web.default(    :disabled=>spec_disable)
            a2, b2 = "<div class='day'>T    #{s.specialist_reading.tuesday.web.default(     :disabled=>spec_disable)}   </div>", s.specialist_reading.tuesday.web.default(   :disabled=>spec_disable)
            a3, b3 = "<div class='day'>W    #{s.specialist_reading.wednesday.web.default(   :disabled=>spec_disable)} </div>", s.specialist_reading.wednesday.web.default( :disabled=>spec_disable)
            a4, b4 = "<div class='day'>Th   #{s.specialist_reading.thursday.web.default(    :disabled=>spec_disable)}  </div>", s.specialist_reading.thursday.web.default(  :disabled=>spec_disable)
            a5, b5 = "<div class='day'>F    #{s.specialist_reading.friday.web.default(      :disabled=>spec_disable)}    </div>", s.specialist_reading.friday.web.default(    :disabled=>spec_disable)
            
            spec = spec_disable ? s.specialist_reading.team_id.to_name : s.specialist_reading.team_id.web.select(:dd_choices=>dd_team_members)
            spec_array.push(["Reading:",spec || "Not Assigned"])
            spec_array.push(["",a1.to_s+a2.to_s+a3.to_s+a4.to_s+a5.to_s])
            
            spec_section = $tools.table(
                :table_array    => spec_array,
                :unique_name    => "demo_section_spec",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
        else
            
            spec_section = false
            
        end
        
    end
    def student_attendance_form(form_content, sid, site_id)
        #save_button = $field.new({"type" => "text", "field" => "save",  "value" => "save"}).web.button("save_attendance(this);")
        form_html = ""
        form_header = ""
        id = "student_#{sid}"
        #form_header << "<DIV class='student_row' id='#{id}'>\n"
        form_header << "<FORM id='#{id}' name='#{id}' enctype='multipart/form-data' action='/cgi-bin/PSSA_ATTENDANCE_CGI.rb' style='visibility: visible;' method='post'>\n"
        form_header << "<INPUT type='hidden' name='page' value='PSSA_CONTENT'>\n"
        form_header << "<INPUT type='hidden' name='current_record' value='#{sid}'>\n"
        form_header << "<INPUT type='hidden' name='site_id' value='#{site_id}'>\n"
        form_header << "<INPUT type ='hidden' id = 'user_id' name = 'user_id' value = '#{$user.email_address_k12.value}'>\n"
        form_html = form_header << form_content << "</FORM>\n"
        #form_html << "</DIV>\n"
        return form_html
    end
    
    def tab_identifier(tab_num)
        "<input id='student_tab' name='student_tab' value='#{tab_num}' style='display: none;'>"
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________JENS_TOOLS
    #ATTENTION: THESE ARE JEN'S TOOLS. YOU MAY NOT USE THEM UNLESS YOUR NAME IS JEN.
    #IF YOU USE THEM THEY WILL WORK. HOWEVER, BE FORWARNED ->
    #YOU ARE LIKELY TO BE EATEN BY A GRUE!
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def disable_save_button(button_name = nil)
        
        return "<eval_script>
            $('#commit_save').button().attr('disable',true).addClass( 'ui-state-disabled' );;
        </eval_script>"
        
    end
    
    def enable_save_button(button_name = nil)
        
        return "<eval_script>
            $('#commit_save').button().attr('disable',false).removeClass('ui-state-disabled');
        </eval_script>"
        
    end
    
    def breakaway_button(a)#(
    #    :button_text        => nil,#string
    #    :page_name          => nil,#string
    #    :additional_params  => nil #hash
    #    :class              => nil #string
    #)
        
        output = String.new
        
        unique_id   = "new_breakaway_#{@breakaway_iterator}#{$kit.user_log_record.primary_id}"
        params_str  = unique_id.dup
        a[:additional_params].each_pair{|k, v|
            
            field_id = "#{unique_id}_#{k.to_s}"
            params_str  << ",#{field_id}"
            output      << "<input id='#{field_id}' name='#{k.to_s}' value='#{v}' type='hidden'>"
            
        } if a[:additional_params]
        
        output << "<button name='new_breakaway_button' class='new_breakaway_button #{a[:class]}' id='new_breakaway_button' onclick=\"get_new_breakaway('#{params_str}');\">#{a[:button_text]}</button>"
        output << "<input id='#{unique_id}' name='new_breakaway' value='#{a[:page_name]}' type='hidden'>"
        
        @breakaway_iterator+=1
        
        return output
        
    end
    
    def button_hide(element_id)
        "<a href='#' id='button' class='ui-state-default ui-corner-all'>Run Effect</a>"
    end
    
    def button_how_to(interface_name, how_to_title = "How To")
        
        button_html = String.new
        
        button_html << "<button name='how_to_button' class='how_to_button ui-icon ui-icon-info' id='how_to_button_#{interface_name.gsub(" ","_").gsub(":","")}' onclick=\"get_how_to('how_to=#{interface_name}', '#{how_to_title}');\"></button>"
        
        return button_html
        
    end
    
    def button_load_tab(tab_number, title, arg = nil)
        
        load_field = $field.new(
            "type"  => "text"
        )
        
        link_params = {
            :link_text      => title,
            :field_name     => "button_load_tab_#{tab_number.to_s}",
            :onclick        => "load_tab(#{tab_number.to_s}, #{arg}); selectTab(#{tab_number.to_s});"
        }
        
        return load_field.web.sym_link(link_params, "tabs-#{tab_number}", tab_number)
        #output = String.new
        #output << "<button name='button_load_tab_#{tab_number.to_s}' class='button_load_tab_#{tab_number.to_s}' id='button_load_tab_#{tab_number.to_s}' onclick=\"load_tab(#{tab_number.to_s}, #{arg}); selectTab(#{tab_number.to_s});\">#{title}</button>"
        
    end
    
    def button_get_row(a)#accepts :dialog_title, :params, :table_name
        
        param_str   = a[:params] ? ",#{a[:params]}" : ""
        button_html = String.new
        
        button_html <<
        "<input
            id      ='get_row_#{a[:table_name]}'
            name    ='get_row'
            value   ='#{a[:table_name]}'
            type    ='hidden'
        >"
        
        button_html <<
        "<button
            name    ='get_row_button'
            class   ='get_row'
            id      ='get_row_button_#{a[:table_name]}'
            onclick =\"get_row(
                'get_row_#{a[:table_name]}#{param_str}',
                '#{a[:table_name]}',
                '#{a[:dialog_title]}'
            );\"
            style   ='float:right;'
        >
            
            #{a[:button_title] || "Add New"}
            
        </button>"
        
        #button_html <<
        #"<div
        #    id      ='add_new_dialog'
        #    class   ='add_new_dialog'
        #>
        #</div>"
        
        button_html <<
        "<input
            id      ='add_new_#{a[:table_name]}'
            name    ='add_new_#{a[:table_name]}'
            value   ='#{a[:table_name]}'
            type    ='hidden'
        >"
        
        return button_html
        
    end
    
    def button_new_row(table_name, additional_params_str = nil, save_params = nil, button_text="Add New", i_will_manually_add_the_div=false)
        
        pstr = String.new
        pstr << "'new_row_#{table_name}"
        pstr << (additional_params_str ? ",#{additional_params_str}'" : "'")
        pstr << ",'#{table_name}'"
        pstr << ",'#{save_params}'" if save_params
        
        button_html = String.new
        
        button_html << "<input id='new_row_#{table_name}' name='new_row' value='#{table_name}' type='hidden'>"
        
        button_html << $field.new(
            {
                "type"      => "text",
                "field"     => "new_row_button_#{table_name}",
                "value"     => button_text
            }
        ).web.button(
            :field_id   => "new_row_button_#{table_name}",
            :no_div     => true,
            :onclick    => "get_new_row(#{pstr});",
            :add_class  => "new_row"
        )
        
        #button_html << "<button name='new_row_button' class='new_row' id='new_row_button_#{table_name}' onclick=\"get_new_row(#{pstr});\">#{button_text}</button>"
        button_html << "<DIV id='add_new_dialog_#{table_name}' style='display:none;' class='add_new_dialog'></DIV>\n" if !i_will_manually_add_the_div
        button_html << "<input id='add_new_#{table_name}' name='add_new_#{table_name}' value='#{table_name}' type='hidden'>"
        
        return button_html
    end
    
    def button_new_csv(csv_name, additional_params_str = nil, csv_title = "Download")
        
        params_str      = additional_params_str ? "ARGV#{additional_params_str}" : ""
        button_html     = String.new
        
        this_id         = "new_csv_#{csv_name}_I_#{@csv_iterator}"
        @csv_iterator   +=1
        
        button_html << "<input id='#{this_id}' name='new_csv' value='#{csv_name+params_str}' type='hidden'>"
        button_html << "<button name='new_csv_button' class='new_csv_button' id='new_csv_button' onclick=\"get_new_download('#{this_id}');\">#{csv_title}</button>"
        
        return button_html
    end
    
    def button_view_pdf(pdf_name, doc_path, additional_params_str = nil, additional_field_ids_array = nil)
        params_str  = additional_params_str ? "ARGV#{additional_params_str}" : ""
        fields_str  = additional_field_ids_array  ? "," + additional_field_ids_array.join(",") : ""
        button_html = String.new
        button_html << "<input id='view_pdf_#{pdf_name}' name='view_pdf' value='#{pdf_name+params_str}' type='hidden'>"
        button_html << "<button name='new_pdf_button' class='new_pdf_button' id='new_pdf_button' onclick=\"return load_secure_doc('#{doc_path}',false,'#{pdf_name}');\">PRINT</button>"
        return button_html
    end
    
    def button_upload_doc(doc_name, additional_params_str = nil)
        
        params_str  = additional_params_str ? additional_params_str : ""
        button_html = String.new
        
        button_html << "<input id='upload_doc_#{doc_name}' name='upload_doc' value='#{doc_name}' type='hidden'>"
        button_html << "<div id='upload_new_doc_#{doc_name}' class='add_new_dialog' style='display:none;'></div>\n"
        
        button_html << $field.new(
            {
                "type"      => "text",
                "field"     => "upload_doc_button",
                "value"     => "UPLOAD"
            }
        ).web.button(
            :field_id   => "upload_doc_button",
            :no_div     => true,
            :onclick    => "upload_doc('#{doc_name}','upload_doc_#{doc_name},#{params_str}');"
        )
        
        return button_html
        
    end
    
    def expandable_section(title, count=nil, arg = nil)
        
        expansion_id    = "#{title.split("<")[0].split(" ")[0].downcase}"
        unique_id       = "#{expansion_id}_#{@expand_iterator}#{$kit.user_log_record.primary_id}"
        interface_class = caller[0].split("/").last.split(".").first
        
        expansion_class = (count == 0 ? "expansion_header_false" : "expansion_header")
        
        title_text      = title.gsub(title.split("<")[0], newlabel("expand_text", title.split("<")[0]))
        
        output = String.new
        output << "<DIV class='#{expansion_class}' id='#{unique_id}'>"
        output << title_text
        output << "<DIV class='record_count'>#{count}</DIV>" if count
        output << newlabel("bottom")
        output << "</DIV>"
        
        output << "<input type='hidden' id='expand_#{unique_id}' name='expand_#{unique_id}' value='#{interface_class}:#{arg}'>"
        output << "<DIV class='content_div' id='content_div_expand_#{unique_id}'></DIV>"
        
        @expand_iterator += 1
        
        return output
        
        #interface_class = caller[0].split("/").last.split(".").first
        #unique_id       = "expand_#{@expand_iterator}#{$kit.user_log_record.primary_id}"
        #
        #expansion_class = (count.nil? || count == 0) ? "expansion_header_false" : "expansion_header"
        #expansion_id    = "#{title.split("<")[0].split(" ")[0].downcase}"
        #
        #title_text      = title.gsub(title.split("<")[0], newlabel("expand_text", title.split("<")[0]))
        #
        #output = String.new
        #output << "<DIV class='#{expansion_class}' id='#{unique_id}'>"
        #output << title_text
        #output << "<DIV class='record_count'>#{count}</DIV>" if count
        #output << newlabel("bottom")
        #output << "</DIV>"
        #
        #output << "<input type='hidden' id='#{unique_id}' name='expand_#{expansion_id}' value='#{interface_class}:#{arg}'>"
        #output << "<DIV class='content_div' id='content_div_expand_#{expansion_id}'></DIV>"
        #
        #@expand_iterator += 1
        #
        #return output
        
    end
    
#    def file_tree(a={})
#        
#        output = "
#        <link type='text/css' href='/athena/javascript/jqueryFileTree/jqueryFileTree.css' rel='stylesheet' type='text/css' media='screen' />
#	<script type='text/javascript' src='/athena/javascript/jqueryFileTree/jqueryFileTree.js'></script>
#        <style>
#            div.jquery_file_tree{ width: 600px; height: 400px; border: solid 2px #3baae3; overflow-y: scroll; padding: 5px; margin-left:auto; margin-right:auto; background:white;}
#            div.main{ background: #f2f5f7; border: 1px solid #DDDDDD; -moz-border-radius: 6px 6px 6px 6px; padding:20px; -moz-box-shadow: inset 1px 1px 2px gray;}
#            div.heading_container{ width: 610px; padding-bottom: 5px; margin-left:auto; margin-right:auto;}
#            div.heading{ font: 18px Helvetica,Arial,sans-serif; color: #0052A3;}
#	</style>
#	
#	<DIV class='main'>
#	    <DIV class='jquery_file_tree' id='jquery_file_tree'></DIV>
#	</DIV>"
#        
#        output << (@modify_tag_content ? "<eval_script>file_tree('#{a[:file_path]}');</eval_script>" : "<script type='text/javascript'>file_tree('#{a[:file_path]}');</script>")
#        
#        return output
#        
#    end
    
    def data_table(tables_array, unique_name, table_type = "default", titles = false, custom_titles = nil)#make sure the header row is included as the first element
        
        table_name = "dataTableDefault"   if table_type == "default"
        table_name = "dataTableNewRecord" if table_type == "NewRecord"
        
        output  = "\n\n"
        output << "<div style='padding-top:5px;padding-bottom:5px;'>"
        
        #BUILD TABLE
        output << "<div>"
        output << "<table id='#{table_name+unique_name}' class='#{table_name}'>\n"
        
        headers     = tables_array[0]
        
        output << "<thead>\n"
        th_index = 0
        headers.each{|th|
            
            if titles
                if custom_titles
                    title_string = "title='#{custom_titles[th_index]}'"
                else
                    title_string = "title='#{tables_array[0][th_index]}'"
                end
            else
                title_string = ""
            end
            
            output << " <th #{title_string}>#{th}</th>\n"
            th_index += 1
        }
        output << "</thead>\n"    
        
        output << "<tfoot>\n"
        #headers.each{|th|
        #    output << " <th>&nbsp;</th>\n"    
        #}
        output << "</tfoot>\n"    
        
        output << "<tbody>\n"
        class_row = "even"
        tables_array[1 ...tables_array.length].each{|trs|
            
            if (tr_id = trs.find{|x|(!x.nil? && x.match(/row_id/))}
            )
                trs.delete(tr_id)
            end
            output << "<tr #{tr_id ? "id='#{tr_id.split(":")[1]}'" : ""}>\n"
            td_index = 0
            if headers.length != trs.length
                puts caller
                raise "DataTables column length mismatch"
            end
            trs.each{|td|
                
                case headers[td_index]
                when "Student ID"
                    td_value = student_link(td)
                when "Team Member ID"
                    td_value = team_member_link(td)
                else
                    td_value = td
                end
                
                if titles
                    if custom_titles
                        title_string = "title='#{custom_titles[td_index]}'"
                    else
                        title_string = "title='#{tables_array[0][td_index]}'"
                    end
                else
                    title_string = ""
                end
                
                class_row = class_row == "even" ? "odd" : "even"
                output << " <td #{title_string} class='column_#{td_index}'>#{td_value}</td>\n"
                td_index+=1
            }
            output << "</tr>\n"
        }
        output << "</tbody>\n"
        
        output << "</table>\n"
        
        output << "</div></div>\n"
       
        return output
    end
    
    def table(a)
        #:table_array    => nil,
        #:unique_name    => nil,
        #:footers        => true,
        #:head_section   => true,
        #:title          => false,
        #:legend         => false,
        #:caption        => false,
        #:embedded_style => {
        #    :table  => "width:100%;",
        #    :th     => nil,
        #    :tr     => nil,
        #    :tr_alt => nil,
        #    :td     => nil
        #}
        
        a[:embedded_style] = Hash.new if !a[:embedded_style]
        
        output  = String.new
        
        output << "<div id='#{a[:unique_name]}_container' class='#{a[:unique_name]}_container'>\n"
        
        #BUILD TABLE
        output << "<table id='#{a[:unique_name]}' style='#{a[:embedded_style][:table]}'>\n"
        
        output << "<caption>#{a[:caption]}</caption>" if a[:caption]
        
        headers     = a[:table_array][0]
        
        output << "<thead>\n"
        headers.each{|th|
            output << " <th style='#{a[:embedded_style][:th]}'>#{th}</th>\n"    
        } if a[:head_section]
        output << "</thead>\n"    
        
        output << "<tfoot>\n"
        headers.each{|th|
            output << " <th style='#{a[:embedded_style][:th]}'>#{th}</th>\n"    
        } if a[:footers]
        output << "</tfoot>\n"    
        
        output << "<tbody>\n"
        class_row = "even_row"
        start_at = a[:head_section] ? 1 : 0
        row_num = 0
        a[:table_array][start_at ...a[:table_array].length].each{|trs|
            
            class_row   = class_row == "even_row" ? "odd_row" : "even_row"
            output << "<tr class='row_#{row_num} #{class_row}' style='#{a[:embedded_style][:tr_alt] ? (class_row == "even_row" ? a[:embedded_style][:tr_alt] : "") : a[:embedded_style][:tr]}'>\n"
            td_index = 0
            trs.each{|td|
                
                if $tools
                    
                    case headers[td_index]
                    when "Student ID"
                        td_value = student_link(td)
                    when "Team Member ID"
                        td_value = team_member_link(td)
                    else
                        td_value = td
                    end
                    
                else
                    td_value = td
                end
                
                if a[:title]
                    if a[:legend]
                        title_string = "title='#{a[:legend][td_index]}'"
                    else
                        title_string = "title='#{a[:table_array][0][td_index]}'"
                    end
                else
                    title_string = ""
                end
                
                output << " <td #{title_string} class='column_#{td_index}' style='#{a[:embedded_style][:td]}'>#{td_value}</td>\n"
                td_index+=1
                
            }
            output << "</tr>\n"
            row_num +=1
        }
        output << "</tbody>\n"
        
        output << "</table>\n"
        
        output << "</div>"
        
        return output
    end
    
    def doc_secure_link(doc_path, text, direct_download=false, title="", text2 = nil)
        return "<a href='/document' style =\"text-decoration:underline; color:#12C;\" onclick=\"return load_secure_doc('#{doc_path}',#{direct_download},false);\" class='doclink'>#{text}</a>#{text2}<br>"
    end
    
    def student_link(sid)
        
        if $base.is_num?(sid)
            
            return $tools.breakaway_button(
                :button_text        => sid,
                :page_name          => "STUDENT_RECORD_WEB",
                :additional_params  => {:sid=>sid},
                :class              => nil
            )
            #
            #output              = String.new
            #student             = $students.get(sid)
            #
            #student_link_params = {
            #    :link_text      => sid,
            #    :field_class    => "student_link",
            #    :field_name     => "sid",
            #    :onclick        => "select_student"
            #}
            #
            #output << student.student_id.web.sym_link(student_link_params)
            #return output
            
        else
            
            return sid
            
        end
        
    end
    
    def team_member_link(tid)
        
        return $tools.breakaway_button(
            
            :button_text        => tid,
            :page_name          => "TEAM_MEMBER_RECORD_WEB",
            :additional_params  => {:tid=>tid},
            :class              => nil
            
        )
    
        #output      = String.new
        #t           = $team.get(tid)
        #team_member_link_params = {
        #    :link_text      => tid,
        #    :field_class    => "team_member_link",
        #    :field_name     => "tid",
        #    :onclick        => "select_team_member"
        #}
        #
        #output << t.primary_id.web.sym_link(team_member_link_params)
        #return output
    end
    
    def student_links(sids, row_details = nil)
        output = String.new
        output << "<div>"
        sids.each{|sid|
            student = $students.attach(sid)
            student_link_params = {
                :link_text      => student.fullname.to_web,
                :field_class    => "student_link",
                :field_name     => "sid",
                :onclick        => "select_student",
                :row_details    => row_details
            }
            
            output << div_open("result_container", "result_container")
            output << student.sid.web.sym_link(student_link_params)
            output << div_close()
        }if sids
        output << newlabel("bottom")
        output << "</div>"
        return output
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________CHARTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def line_chart(a)#(
    #    :data_points       =>nil, #array of arrays
    #    :class             =>nil, #string
    #    :title             =>nil, #string
    #    :subtitle          =>nil, #string
    #    :xAxis_categories  =>nil, #array
    #    :yAxis_title       =>nil  #string
    #)
        
        output = String.new
        
        output << "<div id='#{a[:class]}' class'#{a[:class]}'></div>"
        
        output << "<eval_script>
            
            $(function () {
                
                var chart;
                $(document).ready(function() {
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo            : '#{a[:class]}',
                            backgroundColor     : '#F2F5F7',
                            type                : 'line',
                            marginRight         : 195,
                            marginBottom        : 25
                        },
                        title: {
                            text                : '#{a[:title]}',
                            x                   : -20 //center
                        },
                        subtitle: {
                            text                : '#{a[:subtitle]}',
                            x                   : -20
                        },
                        xAxis: {
                            categories          : ['#{a[:xAxis_categories].join("','")}']
                        },
                        yAxis: {
                            title               : {
                                text    : '#{a[:yAxis_title]}'
                            },
                            plotLines           : [{
                                value   : 0,
                                width   : 1,
                                color   : '#808080'
                            }]
                        },
                        tooltip: {
                            formatter           : function() {
                                return '<b>'+ this.series.name +'</b><br/>'+
                                this.x +': '+ this.y +'%';
                            }
                        },
                        legend: {
                            layout              : 'vertical',
                            align               : 'right',
                            verticalAlign       : 'top',
                            x                   : -10,
                            y                   : 100,
                            borderWidth         : 0
                        },
                        series: ["
                            
                            row_i           = 0
                            a[:data_points].each{|row|
                                
                                field_i = 0
                                row.each{|field|
                                    
                                    if field_i == 0
                                        
                                        output << (row_i == 0 ? "\{name: '#{field}', data: \[\]}" : ",\{name: '#{field}', data: \[\]}")
                                        
                                    else
                                        
                                        field = field.gsub("%","")
                                        field = "null" if field.nil? || field.empty?
                                        output.insert(-3, (field_i == 1 ? "#{field}" : ",#{field}"))
                                        
                                    end
                                    
                                    field_i+=1
                                    
                                }
                             
                                row_i+=1
                                
                            }
                          
                        output << "]
                        
                    });
                });
                
            });
            
        </eval_script>"
        
        return output
        
    end

    def time_chart(a)#(
    #    :data_points       =>nil, #array of arrays
    #    :class             =>nil, #string
    #    :title             =>nil, #string
    #    :subtitle          =>nil, #string
    #    :xAxis_categories  =>nil, #array
    #    :yAxis_title       =>nil  #string
    #)
        
        output = String.new
        
        output << "<div id='#{a[:class]}' style='min-width: 400px; height: 400px; margin: 0 auto'></div>"
        
        output << "<eval_script>
            
            $(function () {
                $('##{a[:class]}').highcharts({
                    chart: {
                        zoomType: 'x',
                        spacingRight: 20
                    },
                    title: {
                        text: 'USD to EUR exchange rate from 2006 through 2008'
                    },
                    subtitle: {
                        text: document.ontouchstart === undefined ?
                            'Click and drag in the plot area to zoom in' :
                            'Drag your finger over the plot to zoom in'
                    },
                    xAxis: {
                        type: 'datetime',
                        maxZoom: 14 * 24 * 3600000, // fourteen days
                        title: {
                            text: null
                        }
                    },
                    yAxis: {
                        title: {
                            text: 'Exchange rate'
                        }
                    },
                    tooltip: {
                        shared: true
                    },
                    legend: {
                        enabled: false
                    },
                    plotOptions: {
                        area: {
                            fillColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                                stops: [
                                    [0, Highcharts.getOptions().colors[0]],
                                    [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                                ]
                            },
                            lineWidth: 1,
                            marker: {
                                enabled: false
                            },
                            shadow: false,
                            states: {
                                hover: {
                                    lineWidth: 1
                                }
                            },
                            threshold: null
                        }
                    },
            
                    series: [{
                        type: 'area',
                        name: 'USD to EUR',
                        pointInterval: 24 * 3600 * 1000,
                        pointStart: Date.UTC(2006, 0, 01),
                        data: [
                            0.8446, 0.8445, 0.8444, 0.8451,    0.8418, 0.8264,    0.8258, 0.8232,    0.8233, 0.8258,
                            0.8283, 0.8278, 0.8256, 0.8292,    0.8239, 0.8239,    0.8245, 0.8265,    0.8261, 0.8269,
                            0.8273, 0.8244, 0.8244, 0.8172,    0.8139, 0.8146,    0.8164, 0.82,    0.8269, 0.8269,
                            0.8269, 0.8258, 0.8247, 0.8286,    0.8289, 0.8316,    0.832, 0.8333,    0.8352, 0.8357,
                            0.8355, 0.8354, 0.8403, 0.8403,    0.8406, 0.8403,    0.8396, 0.8418,    0.8409, 0.8384,
                            0.8386, 0.8372, 0.839, 0.84, 0.8389, 0.84, 0.8423, 0.8423, 0.8435, 0.8422,
                            0.838, 0.8373, 0.8316, 0.8303,    0.8303, 0.8302,    0.8369, 0.84, 0.8385, 0.84,
                            0.8401, 0.8402, 0.8381, 0.8351,    0.8314, 0.8273,    0.8213, 0.8207,    0.8207, 0.8215,
                            0.8242, 0.8273, 0.8301, 0.8346,    0.8312, 0.8312,    0.8312, 0.8306,    0.8327, 0.8282,
                            0.824, 0.8255, 0.8256, 0.8273, 0.8209, 0.8151, 0.8149, 0.8213, 0.8273, 0.8273,
                            0.8261, 0.8252, 0.824, 0.8262, 0.8258, 0.8261, 0.826, 0.8199, 0.8153, 0.8097,
                            0.8101, 0.8119, 0.8107, 0.8105,    0.8084, 0.8069,    0.8047, 0.8023,    0.7965, 0.7919,
                            0.7921, 0.7922, 0.7934, 0.7918,    0.7915, 0.787, 0.7861, 0.7861, 0.7853, 0.7867,
                            0.7827, 0.7834, 0.7766, 0.7751, 0.7739, 0.7767, 0.7802, 0.7788, 0.7828, 0.7816,
                            0.7829, 0.783, 0.7829, 0.7781, 0.7811, 0.7831, 0.7826, 0.7855, 0.7855, 0.7845,
                            0.7798, 0.7777, 0.7822, 0.7785, 0.7744, 0.7743, 0.7726, 0.7766, 0.7806, 0.785,
                            0.7907, 0.7912, 0.7913, 0.7931, 0.7952, 0.7951, 0.7928, 0.791, 0.7913, 0.7912,
                            0.7941, 0.7953, 0.7921, 0.7919, 0.7968, 0.7999, 0.7999, 0.7974, 0.7942, 0.796,
                            0.7969, 0.7862, 0.7821, 0.7821, 0.7821, 0.7811, 0.7833, 0.7849, 0.7819, 0.7809,
                            0.7809, 0.7827, 0.7848, 0.785, 0.7873, 0.7894, 0.7907, 0.7909, 0.7947, 0.7987,
                            0.799, 0.7927, 0.79, 0.7878, 0.7878, 0.7907, 0.7922, 0.7937, 0.786, 0.787,
                            0.7838, 0.7838, 0.7837, 0.7836, 0.7806, 0.7825, 0.7798, 0.777, 0.777, 0.7772,
                            0.7793, 0.7788, 0.7785, 0.7832, 0.7865, 0.7865, 0.7853, 0.7847, 0.7809, 0.778,
                            0.7799, 0.78, 0.7801, 0.7765, 0.7785, 0.7811, 0.782, 0.7835, 0.7845, 0.7844,
                            0.782, 0.7811, 0.7795, 0.7794, 0.7806, 0.7794, 0.7794, 0.7778, 0.7793, 0.7808,
                            0.7824, 0.787, 0.7894, 0.7893, 0.7882, 0.7871, 0.7882, 0.7871, 0.7878, 0.79,
                            0.7901, 0.7898, 0.7879, 0.7886, 0.7858, 0.7814, 0.7825, 0.7826, 0.7826, 0.786,
                            0.7878, 0.7868, 0.7883, 0.7893, 0.7892, 0.7876, 0.785, 0.787, 0.7873, 0.7901,
                            0.7936, 0.7939, 0.7938, 0.7956, 0.7975, 0.7978, 0.7972, 0.7995, 0.7995, 0.7994,
                            0.7976, 0.7977, 0.796, 0.7922, 0.7928, 0.7929, 0.7948, 0.797, 0.7953, 0.7907,
                            0.7872, 0.7852, 0.7852, 0.786, 0.7862, 0.7836, 0.7837, 0.784, 0.7867, 0.7867,
                            0.7869, 0.7837, 0.7827, 0.7825, 0.7779, 0.7791, 0.779, 0.7787, 0.78, 0.7807,
                            0.7803, 0.7817, 0.7799, 0.7799, 0.7795, 0.7801, 0.7765, 0.7725, 0.7683, 0.7641,
                            0.7639, 0.7616, 0.7608, 0.759, 0.7582, 0.7539, 0.75, 0.75, 0.7507, 0.7505,
                            0.7516, 0.7522, 0.7531, 0.7577, 0.7577, 0.7582, 0.755, 0.7542, 0.7576, 0.7616,
                            0.7648, 0.7648, 0.7641, 0.7614, 0.757, 0.7587, 0.7588, 0.762, 0.762, 0.7617,
                            0.7618, 0.7615, 0.7612, 0.7596, 0.758, 0.758, 0.758, 0.7547, 0.7549, 0.7613,
                            0.7655, 0.7693, 0.7694, 0.7688, 0.7678, 0.7708, 0.7727, 0.7749, 0.7741, 0.7741,
                            0.7732, 0.7727, 0.7737, 0.7724, 0.7712, 0.772, 0.7721, 0.7717, 0.7704, 0.769,
                            0.7711, 0.774, 0.7745, 0.7745, 0.774, 0.7716, 0.7713, 0.7678, 0.7688, 0.7718,
                            0.7718, 0.7728, 0.7729, 0.7698, 0.7685, 0.7681, 0.769, 0.769, 0.7698, 0.7699,
                            0.7651, 0.7613, 0.7616, 0.7614, 0.7614, 0.7607, 0.7602, 0.7611, 0.7622, 0.7615,
                            0.7598, 0.7598, 0.7592, 0.7573, 0.7566, 0.7567, 0.7591, 0.7582, 0.7585, 0.7613,
                            0.7631, 0.7615, 0.76, 0.7613, 0.7627, 0.7627, 0.7608, 0.7583, 0.7575, 0.7562,
                            0.752, 0.7512, 0.7512, 0.7517, 0.752, 0.7511, 0.748, 0.7509, 0.7531, 0.7531,
                            0.7527, 0.7498, 0.7493, 0.7504, 0.75, 0.7491, 0.7491, 0.7485, 0.7484, 0.7492,
                            0.7471, 0.7459, 0.7477, 0.7477, 0.7483, 0.7458, 0.7448, 0.743, 0.7399, 0.7395,
                            0.7395, 0.7378, 0.7382, 0.7362, 0.7355, 0.7348, 0.7361, 0.7361, 0.7365, 0.7362,
                            0.7331, 0.7339, 0.7344, 0.7327, 0.7327, 0.7336, 0.7333, 0.7359, 0.7359, 0.7372,
                            0.736, 0.736, 0.735, 0.7365, 0.7384, 0.7395, 0.7413, 0.7397, 0.7396, 0.7385,
                            0.7378, 0.7366, 0.74, 0.7411, 0.7406, 0.7405, 0.7414, 0.7431, 0.7431, 0.7438,
                            0.7443, 0.7443, 0.7443, 0.7434, 0.7429, 0.7442, 0.744, 0.7439, 0.7437, 0.7437,
                            0.7429, 0.7403, 0.7399, 0.7418, 0.7468, 0.748, 0.748, 0.749, 0.7494, 0.7522,
                            0.7515, 0.7502, 0.7472, 0.7472, 0.7462, 0.7455, 0.7449, 0.7467, 0.7458, 0.7427,
                            0.7427, 0.743, 0.7429, 0.744, 0.743, 0.7422, 0.7388, 0.7388, 0.7369, 0.7345,
                            0.7345, 0.7345, 0.7352, 0.7341, 0.7341, 0.734, 0.7324, 0.7272, 0.7264, 0.7255,
                            0.7258, 0.7258, 0.7256, 0.7257, 0.7247, 0.7243, 0.7244, 0.7235, 0.7235, 0.7235,
                            0.7235, 0.7262, 0.7288, 0.7301, 0.7337, 0.7337, 0.7324, 0.7297, 0.7317, 0.7315,
                            0.7288, 0.7263, 0.7263, 0.7242, 0.7253, 0.7264, 0.727, 0.7312, 0.7305, 0.7305,
                            0.7318, 0.7358, 0.7409, 0.7454, 0.7437, 0.7424, 0.7424, 0.7415, 0.7419, 0.7414,
                            0.7377, 0.7355, 0.7315, 0.7315, 0.732, 0.7332, 0.7346, 0.7328, 0.7323, 0.734,
                            0.734, 0.7336, 0.7351, 0.7346, 0.7321, 0.7294, 0.7266, 0.7266, 0.7254, 0.7242,
                            0.7213, 0.7197, 0.7209, 0.721, 0.721, 0.721, 0.7209, 0.7159, 0.7133, 0.7105,
                            0.7099, 0.7099, 0.7093, 0.7093, 0.7076, 0.707, 0.7049, 0.7012, 0.7011, 0.7019,
                            0.7046, 0.7063, 0.7089, 0.7077, 0.7077, 0.7077, 0.7091, 0.7118, 0.7079, 0.7053,
                            0.705, 0.7055, 0.7055, 0.7045, 0.7051, 0.7051, 0.7017, 0.7, 0.6995, 0.6994,
                            0.7014, 0.7036, 0.7021, 0.7002, 0.6967, 0.695, 0.695, 0.6939, 0.694, 0.6922,
                            0.6919, 0.6914, 0.6894, 0.6891, 0.6904, 0.689, 0.6834, 0.6823, 0.6807, 0.6815,
                            0.6815, 0.6847, 0.6859, 0.6822, 0.6827, 0.6837, 0.6823, 0.6822, 0.6822, 0.6792,
                            0.6746, 0.6735, 0.6731, 0.6742, 0.6744, 0.6739, 0.6731, 0.6761, 0.6761, 0.6785,
                            0.6818, 0.6836, 0.6823, 0.6805, 0.6793, 0.6849, 0.6833, 0.6825, 0.6825, 0.6816,
                            0.6799, 0.6813, 0.6809, 0.6868, 0.6933, 0.6933, 0.6945, 0.6944, 0.6946, 0.6964,
                            0.6965, 0.6956, 0.6956, 0.695, 0.6948, 0.6928, 0.6887, 0.6824, 0.6794, 0.6794,
                            0.6803, 0.6855, 0.6824, 0.6791, 0.6783, 0.6785, 0.6785, 0.6797, 0.68, 0.6803,
                            0.6805, 0.676, 0.677, 0.677, 0.6736, 0.6726, 0.6764, 0.6821, 0.6831, 0.6842,
                            0.6842, 0.6887, 0.6903, 0.6848, 0.6824, 0.6788, 0.6814, 0.6814, 0.6797, 0.6769,
                            0.6765, 0.6733, 0.6729, 0.6758, 0.6758, 0.675, 0.678, 0.6833, 0.6856, 0.6903,
                            0.6896, 0.6896, 0.6882, 0.6879, 0.6862, 0.6852, 0.6823, 0.6813, 0.6813, 0.6822,
                            0.6802, 0.6802, 0.6784, 0.6748, 0.6747, 0.6747, 0.6748, 0.6733, 0.665, 0.6611,
                            0.6583, 0.659, 0.659, 0.6581, 0.6578, 0.6574, 0.6532, 0.6502, 0.6514, 0.6514,
                            0.6507, 0.651, 0.6489, 0.6424, 0.6406, 0.6382, 0.6382, 0.6341, 0.6344, 0.6378,
                            0.6439, 0.6478, 0.6481, 0.6481, 0.6494, 0.6438, 0.6377, 0.6329, 0.6336, 0.6333,
                            0.6333, 0.633, 0.6371, 0.6403, 0.6396, 0.6364, 0.6356, 0.6356, 0.6368, 0.6357,
                            0.6354, 0.632, 0.6332, 0.6328, 0.6331, 0.6342, 0.6321, 0.6302, 0.6278, 0.6308,
                            0.6324, 0.6324, 0.6307, 0.6277, 0.6269, 0.6335, 0.6392, 0.64, 0.6401, 0.6396,
                            0.6407, 0.6423, 0.6429, 0.6472, 0.6485, 0.6486, 0.6467, 0.6444, 0.6467, 0.6509,
                            0.6478, 0.6461, 0.6461, 0.6468, 0.6449, 0.647, 0.6461, 0.6452, 0.6422, 0.6422,
                            0.6425, 0.6414, 0.6366, 0.6346, 0.635, 0.6346, 0.6346, 0.6343, 0.6346, 0.6379,
                            0.6416, 0.6442, 0.6431, 0.6431, 0.6435, 0.644, 0.6473, 0.6469, 0.6386, 0.6356,
                            0.634, 0.6346, 0.643, 0.6452, 0.6467, 0.6506, 0.6504, 0.6503, 0.6481, 0.6451,
                            0.645, 0.6441, 0.6414, 0.6409, 0.6409, 0.6428, 0.6431, 0.6418, 0.6371, 0.6349,
                            0.6333, 0.6334, 0.6338, 0.6342, 0.632, 0.6318, 0.637, 0.6368, 0.6368, 0.6383,
                            0.6371, 0.6371, 0.6355, 0.632, 0.6277, 0.6276, 0.6291, 0.6274, 0.6293, 0.6311,
                            0.631, 0.6312, 0.6312, 0.6304, 0.6294, 0.6348, 0.6378, 0.6368, 0.6368, 0.6368,
                            0.636, 0.637, 0.6418, 0.6411, 0.6435, 0.6427, 0.6427, 0.6419, 0.6446, 0.6468,
                            0.6487, 0.6594, 0.6666, 0.6666, 0.6678, 0.6712, 0.6705, 0.6718, 0.6784, 0.6811,
                            0.6811, 0.6794, 0.6804, 0.6781, 0.6756, 0.6735, 0.6763, 0.6762, 0.6777, 0.6815,
                            0.6802, 0.678, 0.6796, 0.6817, 0.6817, 0.6832, 0.6877, 0.6912, 0.6914, 0.7009,
                            0.7012, 0.701, 0.7005, 0.7076, 0.7087, 0.717, 0.7105, 0.7031, 0.7029, 0.7006,
                            0.7035, 0.7045, 0.6956, 0.6988, 0.6915, 0.6914, 0.6859, 0.6778, 0.6815, 0.6815,
                            0.6843, 0.6846, 0.6846, 0.6923, 0.6997, 0.7098, 0.7188, 0.7232, 0.7262, 0.7266,
                            0.7359, 0.7368, 0.7337, 0.7317, 0.7387, 0.7467, 0.7461, 0.7366, 0.7319, 0.7361,
                            0.7437, 0.7432, 0.7461, 0.7461, 0.7454, 0.7549, 0.7742, 0.7801, 0.7903, 0.7876,
                            0.7928, 0.7991, 0.8007, 0.7823, 0.7661, 0.785, 0.7863, 0.7862, 0.7821, 0.7858,
                            0.7731, 0.7779, 0.7844, 0.7866, 0.7864, 0.7788, 0.7875, 0.7971, 0.8004, 0.7857,
                            0.7932, 0.7938, 0.7927, 0.7918, 0.7919, 0.7989, 0.7988, 0.7949, 0.7948, 0.7882,
                            0.7745, 0.771, 0.775, 0.7791, 0.7882, 0.7882, 0.7899, 0.7905, 0.7889, 0.7879,
                            0.7855, 0.7866, 0.7865, 0.7795, 0.7758, 0.7717, 0.761, 0.7497, 0.7471, 0.7473,
                            0.7407, 0.7288, 0.7074, 0.6927, 0.7083, 0.7191, 0.719, 0.7153, 0.7156, 0.7158,
                            0.714, 0.7119, 0.7129, 0.7129, 0.7049, 0.7095
                        ]
                    }]
                });
            });
            
        </eval_script>"
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DD_CHOICES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def dd_team_members
        if $tables.attach("K12_STAFF").primary_ids(" GROUP BY CONCAT(firstname,' ',lastname) ORDER BY position DESC ")
            
            return $tables.attach("K12_STAFF").dd_choices(
                "CONCAT(firstname,' ',lastname)",
                "samspersonid",
                " GROUP BY CONCAT(firstname,' ',lastname) ORDER BY CONCAT(firstname,' ',lastname) ASC "
            )
            
        else
            return false
        end
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

end