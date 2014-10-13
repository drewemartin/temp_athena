#!/usr/local/bin/ruby

class STUDENT_RECORDS_INCOMING_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        @my_record_requests = 0
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Record Requests - Incoming"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        $kit.student_data_entry
        
    end
    
    def response
        
        if $kit.params[:add_new_STUDENT_RRI_REQUESTED_DOCUMENTS]
            
            save_requested_documents
         
            $kit.student_record.content
         
        end
        
        if $kit.params[:add_new_STUDENT_RRI_REQUESTS]
         
            save_requested_documents
            
            js_string = $tools.button_new_row(
                
                table_name                  = "STUDENT_RRI_RECIPIENTS"                          ,
                additional_params_str       = "rri_request_id=#{$kit.rows.first[1].primary_id}" ,
                save_params                 = "sid"                                             ,
                button_text                 = nil                                               ,
                i_will_manually_add_the_div = true                                              ,
                inner_add_new               = false                                             ,
                return_js_string            = true
                
            )
            
            $kit.output = "<eval_script>#{js_string}</eval_script>"
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        output = String.new
        
        output << $tools.button_new_row(
            table_name              = "STUDENT_RRI_REQUESTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        output << "<DIV id='add_new_dialog_STUDENT_RRI_RECIPIENTS'          style='display:none;' class='add_new_dialog'></DIV>\n"
        output << "<DIV id='add_new_dialog_STUDENT_RRI_REQUESTED_DOCUMENTS' style='display:none;' class='add_new_dialog'></DIV>\n"
        output << "<input id='new_row_STUDENT_RRI_RECIPIENTS' type='hidden' value='STUDENT_RRI_RECIPIENTS' name='new_row'>"
        
        tables_array = [
            
            #HEADERS
            [
                "Priority",
                "Requested Documents",
                "Request Details"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRI_REQUESTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        record_pids.each{|pid|
            
            row           = Array.new
            
            record_record = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(pid)
            
            sid           = record_record.fields["student_id"].value
            
            row.push(record_record.fields["priority_level"   ].web.select(:dd_choices=>priority_levels))
            
            if requests = documents_table(pid)
                
                row.push(documents_table(pid))
                
            else
                
                row.push("")
                
            end
            
            row.push(
                
                recipient_table(
                    
                    recipients          = $focus_student.rri_recipients.existing_records("WHERE rri_request_id = '#{pid}'"),
                    rri_request_id      = pid,
                    printable_labels    = false
                    
                )+
                record_record.fields["request_method"   ].web.select( :label_option=>"Request Method:", :dd_choices=>request_method_dd)+
                record_record.fields["notes"            ].web.default(:label_option=>"Notes:")
                
            )
            
            tables_array.push(row)
            
        } if record_pids
        
        output << $kit.tools.data_table(tables_array, "incoming_records")
        
        return output
        
    end

    def working_list(refresh=false)
        
        output = Array.new
        
        nursing_departments     = $tables.attach("department").field_values("primary_id", "WHERE name REGEXP 'nurse'")
        transcripts_department  = $tables.attach("department").field_values("primary_id", "WHERE name REGEXP 'transcsript'")
        registrar_department    = $tables.attach("department").field_values("primary_id", "WHERE name REGEXP 'registrar'")
        speced_department       = $tables.attach("department").field_values("primary_id", "WHERE name REGEXP 'special education'")
        
        if nursing_departments && nursing_departments.include?($team_member.department_id.value)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Nursing'
                )"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Nursing'
                )"
            )
            
        elsif transcripts_department && transcripts_department.include?($team_member.department_id.value)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Registrar'
                )"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Registrar'
                )"
            )
            
        elsif registrar_department && registrar_department.include?($team_member.department_id.value)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL"
            )
            
        elsif speced_department && speced_department.include?($team_member.department_id.value)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Special Education'
                )"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Special Education'
                )"
            )
          
        elsif $team_member.preferred_email.value.match(/#{$software_team.join("|")}/)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL"
            )
            
        end
        
        neww_recipient_div = "<DIV id='add_new_dialog_STUDENT_RRI_RECIPIENTS' style='display:none;' class='add_new_dialog'></DIV>\n"
        
        tabulated_list = neww_recipient_div + $kit.tools.tabs(
            
            tabs            = [
                
                ["New Documents (#{       new_record_pids     ? new_record_pids.length        : '0'   })",    new_record_pids     ? working_list_tab_contents(new_record_pids      ) : "There are no 'New' record requests at this time."        ],
                ["Pending Documents (#{   pending_record_pids ? pending_record_pids.length    : '0'   })",    pending_record_pids ? working_list_tab_contents(pending_record_pids  ) : "There are no 'Pending' record requests at this time."    ]
                
            ],
            selected_tab    = 0,
            tab_id          = "rri",
            search          = false,
            sub_tab         = true
        )
        
        if refresh
            tabulated_list
        else
            output.push(
                :name       => "MyRecordRequests",
                :content    => button_print_labels("rri_labels")+$tools.button_refresh("tabs_rri")+$tools.div_open("rri_wl","rri_wl")+tabulated_list+$tools.div_close
            )
        end
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_pdf_record_request(sid)
        
        template = "RECORD_REQUESTS_PDF.rb"
        
        pdf = Prawn::Document.generate "#{$paths.htdocs_path}temp/rr_temp#{$ifilestamp}.pdf" do |pdf|
            require "#{$paths.templates_path}pdf_templates/#{template}"
            template = eval("#{template.gsub(".rb","")}.new")
            template.generate_pdf(sid, pdf)
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_student_rri_recipients
        
        output = String.new
        
        record = !$kit.rows.empty? ? $focus_student.rri_recipients.existing_records("WHERE primary_id = '#{$kit.rows.first[1].primary_id}'")[0] : $focus_student.rri_recipients.new_record
        
        record.fields["rri_request_id"  ].set($kit.params[:rri_request_id]) if $kit.params[:rri_request_id]
        
        output << record.fields["rri_request_id"  ].web.hidden() + record.fields["student_id"  ].web.hidden()
        
        school_dd = $tables.attach("SCHOOLS").dd_choices(
            name            = "school_name" ,
            value           = "primary_id"  ,
            where_clause    = nil
        )
        
        output << record.fields["primary_id"          ].web.select(
            {
                :dd_choices => school_dd,
                :onchange   => "fill_select_option('#{record.fields["name"          ].web.field_id}', this );",
                :add_class  => "no_save"
            },
            true
        )
        
        output << record.fields["name"            ].web.text(    :label_option => "Name:"            ,:add_class=>"no_save" )
        output << record.fields["attn"            ].web.text(    :label_option => "Attention:"       ,:add_class=>"no_save" )
        output << record.fields["via_mail"        ].web.default( :label_option => "Via Mail?"        ,:add_class=>"no_save" )
        output << record.fields["address_1"       ].web.text(    :label_option => "Address 1:"       ,:add_class=>"no_save" )
        output << record.fields["address_2"       ].web.text(    :label_option => "Address 2:"       ,:add_class=>"no_save" )
        output << record.fields["city"            ].web.text(    :label_option => "City:"            ,:add_class=>"no_save" )
        output << record.fields["state"           ].web.text(    :label_option => "State:"           ,:add_class=>"no_save" )
        output << record.fields["zip"             ].web.text(    :label_option => "Zip:"             ,:add_class=>"no_save" )
        output << record.fields["via_fax"         ].web.default( :label_option => "Via Fax?"         ,:add_class=>"no_save" )
        output << record.fields["fax_number"      ].web.text(    :label_option => "Fax Number:"      ,:add_class=>"no_save" )
        output << record.fields["via_email"       ].web.default( :label_option => "Via Email?"       ,:add_class=>"no_save" )
        output << record.fields["email_address"   ].web.text(    :label_option => "Email Address:"   ,:add_class=>"no_save" )
        
        return output
        
    end
    
    def add_new_record_student_rri_requested_documents()
      
        return doc_checkboxes(request_pid = $kit.params[:rri_request_id])
        
    end
    
    def add_new_record_student_rri_requests()
        
        tables_array = [
            
            #HEADERS
            [
                #"Recipients Test (This form needs cleanup)",
                "Priority"          ,
                "Date Requested"    ,
                "Request Method"    ,
                "Requested Records" ,
                "Notes"
            ]
            
        ]
        
        row = Array.new
        
        record = $focus_student.rri_requests.new_record
        
        row.push(record.fields["priority_level"  ].set("Normal").web.select(:dd_choices=>priority_levels))
        row.push(record.fields["requested_date"  ].set($idatetime).web.default())
        row.push(record.fields["request_method"  ].web.select(:dd_choices=>request_method_dd))
        row.push(doc_checkboxes)
        row.push(record.fields["notes"           ].web.default())
        
        tables_array.push(row)
      
        return record.fields["student_id"].web.hidden() + $kit.tools.data_table(tables_array, "new_record", type = "NewRecord")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def document_types_dd(sid)
        
        pids = $tables.attach("RRO_DOCUMENT_TYPES").required_documents(sid)
        
        $tables.attach("RRO_DOCUMENT_TYPES").dd_choices("document_name", "primary_id", "WHERE primary_id IN(#{pids.join(",")}) ORDER BY document_name") if pids
        
    end
    
    def priority_levels
        
        $dd.from_array(
            
            [
             
                "Normal"            ,
                "*High*"            ,
                "**Court Order**"
                
            ]
            
        )
        
    end
    
    def status_dd
        
        return $tables.attach("RRO_SETTINGS_STATUS").dd_choices("status_name", "primary_id")
        
    end
    
    def rri_doc_status_dd
        
        return $tables.attach("RRI_STATUS").dd_choices("status", "primary_id")
        
    end
    
    def request_method_dd
        
        $dd.from_array(
            
            [
             
                "End Of Year Request"                           ,                  
                "Parent Email"                                  ,                         
                "Parent Written Request"                        ,               
                "School or District Email"                      ,             
                "School or District Written Request"            ,   
                "Social Security Determination Request"         ,
                "Social Service Email"                          ,                 
                "Social Service Written Request"                ,       
               
            ]
            
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FILL_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def fill_select_option_name(field_name, field_value, pid)
        
        recipient_fields    = $base.is_num?(pid) ? $tables.attach("STUDENT_RRI_RECIPIENTS"   ).by_primary_id(pid).fields : $tables.attach("STUDENT_RRI_RECIPIENTS"   ).new_row.fields
        school_fields       = $tables.attach("SCHOOLS"                  ).record("WHERE primary_id = '#{field_value}'").fields
        
        $kit.modify_tag_content(recipient_fields["address_1"].web.field_id, school_fields["street_address"  ].value, "update")
        $kit.modify_tag_content(recipient_fields["city"     ].web.field_id, school_fields["city"            ].value, "update")
        $kit.modify_tag_content(recipient_fields["state"    ].web.field_id, school_fields["state"           ].value, "update")
        $kit.modify_tag_content(recipient_fields["zip"      ].web.field_id, school_fields["zip"             ].value, "update")
        
        return school_fields["school_name"].value
        
    end
    
    def fill_select_option_address_1(field_name, field_value, pid)
        
        return $tables.attach("SCHOOLS").field_value("street_address", "WHERE primary_id = '#{field_value}'")
        
    end
    
    def fill_select_option_city(field_name, field_value, pid)
        
        return $tables.attach("SCHOOLS").field_value("city", "WHERE primary_id = '#{field_value}'")
        
    end
    
    def fill_select_option_state(field_name, field_value, pid)
        
        return $tables.attach("SCHOOLS").field_value("state", "WHERE primary_id = '#{field_value}'")
        
    end
    
    def fill_select_option_zip(field_name, field_value, pid)
        
        return $tables.attach("SCHOOLS").field_value("zip", "WHERE primary_id = '#{field_value}'")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
   
    def doc_checkboxes(request_pid = nil)
     
        if request_pid
            
            requested_docs  = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").field_values("record_type_id", "WHERE rri_request_id = '#{request_pid}'")
            doc_pids        = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids("WHERE primary_id #{requested_docs ? "NOT IN(#{requested_docs.join(',')})" : nil} ORDER BY document_category ASC")
            
        else
            
            doc_pids        = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids("ORDER BY document_category ASC")
            
        end
        
        output  = String.new
        output << $field.new(
            "type"      =>  "text",
            "field"     =>  "rri_request_pid",
            "value"     =>  request_pid
        ).set(request_pid).web.hidden if request_pid
        
        doc_pids.each do |doc_pid|
            
            record      = $tables.attach("RRI_DOCUMENT_TYPES").by_primary_id(doc_pid)
            
            new_field   = $field.new({"type" => "text", "field" => "rri_document_type__#{doc_pid}"})
            
            output << new_field.web.checkbox({:label_option=>record.fields["document_name"].value, :field_id=>"rri_document_type_submit__" + doc_pid, :add_class=>"no_save rri_document_type"})
            
        end if doc_pids
        
        return output
        
    end
    
    def working_list_tab_contents(open_record_pids)
        
        if open_record_pids
            
            output      = String.new
            
            requests    = Hash.new
            
            open_record_pids.each{|pid|
                
                record      = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").by_primary_id(pid)
                request_id  = record.fields["rri_request_id"].value.to_sym
                
                requests[request_id ] = [
                    
                    #HEADERS
                    [
                        "Document",
                        "Details"
                    ]
                    
                ] if requests[request_id].nil?
                
                requests[request_id].push(
                    
                    [
                     
                        record.fields["record_type_id"].set(
                            
                            $tables.attach("RRI_DOCUMENT_TYPES").field_value(
                                "document_name",
                                "WHERE primary_id = '#{record.fields["record_type_id"].value}'"
                            )
                            
                        ).web.label,
                        
                        record.fields["status"].web.select(
                            
                            :dd_choices => $tables.attach("RRI_STATUS").dd_choices(
                                "status"      ,
                                "primary_id"  ,
                                nil
                            ),
                            :label_option=>"Status:"
                            
                        )+
                        
                        record.fields["date_completed"  ].web.default(:label_option=>"Date Completed:")+
                        record.fields["notes"           ].web.default(:label_option=>"Notes:")
                        
                    ]
                    
                )
                
                
            }
            
            tables_array = [
                
                #HEADERS #other requested headres are student name, active status
                [
                 
                    "High Priority?"            ,
                    "Requested Date"            ,
                    "Request Details"           ,
                    "Requested Documents"
                   
                ]
                
            ]
            
            requests.keys.each{|request_id|
                
                request_rec = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(request_id)
                row         = Array.new
                
                row.push(
                    
                    request_rec.fields["priority_level"    ].web.select( :dd_choices=>priority_levels),
                    request_rec.fields["requested_date"    ].web.default()
                    
                )
                
                row.push(
                    
                    $tools.table(
                        :table_array    => [
                            
                            ["Student ID:"      , request_rec.fields["student_id"    ].value],
                            ["Active?:"         , $students.get(request_rec.fields["student_id"].value).active == 1 ? "Yes" : "No"],
                            ["Request Method:"  , request_rec.fields["request_method"].web.select(:dd_choices=>request_method_dd)],
                            ["Notes:"           , request_rec.fields["notes"         ].web.default]
                            
                        ],
                        :student_link   => "name",
                        :unique_name    => "request_details",
                        :footers        => false,
                        :head_section   => :left,
                        :title          => false,
                        :legend         => false,
                        :caption        => false#,
                        #:embedded_style => {
                        #    :table  => "width:100%;",
                        #    :th     => nil,
                        #    :tr     => nil,
                        #    :tr_alt => nil,
                        #    :td     => nil
                        #}
                    )+
                    recipient_table(
                        
                        recipients          = $students.get(request_rec.fields["student_id"].value).rri_recipients.existing_records("WHERE rri_request_id = '#{request_id}'"),
                        rri_request_id      = request_id,
                        printable_labels    = true
                        
                    )
                    
                )
                
                row.push(
                    
                    $tools.table(
                        :table_array    => requests[request_id],
                        :unique_name    => "requested_docs",
                        :footers        => false,
                        :head_section   => true,
                        :title          => false,
                        :legend         => false,
                        :caption        => false,
                        :embedded_style => {
                        #    :table  => "width:100%;",
                        #    :th     => nil,
                        #    :tr     => nil,
                        #    :tr_alt => nil,
                            :td     => "border-bottom:1px dashed #6B6B6B"
                        }
                    )
                    
                )
                
                tables_array.push(row)
                
            }
            
            @my_record_requests = @my_record_requests+=1
            
            output << $kit.tools.data_table(tables_array, "my_record_requests_#{@my_record_requests}")
            
            return output
            
        end
        
    end
    
    def recipient_table(recipients, rri_request_id, printable_labels = false)
        
        rec_table_array = Array.new
        
        add_new_button = $tools.button_new_row(
            
            table_name                  = "STUDENT_RRI_RECIPIENTS"              ,
            additional_params_str       = "rri_request_id=#{rri_request_id}"    ,
            save_params                 = nil                                   ,
            button_text                 = "Add New"                             ,
            i_will_manually_add_the_div = true                                  ,
            inner_add_new               = nil                                   ,
            return_js_string            = nil
            
        )
        
        rec_table_array.push(
            
            [
                
                #HEADERS
                "Edit"          ,
                "Mail"          ,
                "Fax"           ,
                "Email"
                
            ]
            
        )
        
        rec_table_array.insert(-1, "Print?") if printable_labels
        
        recipients.each{|recipient|
            
            address_str = "#{recipient.fields["name"].value}<br>
                Attn: "+"#{recipient.fields["attn" ].value}<br>
                #{recipient.fields["address_1"     ].value}<br>
                #{recipient.fields["address_2"     ].value}<br>
                #{recipient.fields["city"          ].value}
                #{recipient.fields["state"         ].value}
                #{recipient.fields["zip"           ].value}"
            
            recipient.fields["primary_id"].web.hidden
            
            sid_param = "#{recipient.fields["student_id"    ].web.field_id}=#{recipient.fields["student_id"     ].value}"
            rid_param = "#{recipient.fields["rri_request_id"].web.field_id}=#{recipient.fields["rri_request_id" ].value}"
            
            edit_button = $tools.button_new_row(
                
                table_name                  = "STUDENT_RRI_RECIPIENTS"      ,
                additional_params_str       = "#{sid_param},#{rid_param}"   ,
                save_params                 = nil                           ,
                button_text                 = "Edit"                        ,
                i_will_manually_add_the_div = false                         ,
                inner_add_new               = false                         ,
                return_js_string            = false
                
            )
            
            rec_table_array.push(
                
                [
                    
                    edit_button                                         ,
                    address_str                                         ,
                    recipient.fields["fax_number"    ].value || "N/A"   ,
                    recipient.fields["email_address" ].value || "N/A"
                    
                ]
                
            )
            
            rec_table_array.insert(-1, "Print?") if printable_labels
            
        } if recipients
        
        return $tools.table(
            
            :table_array    => rec_table_array      ,
            :student_link   => "name"               ,
            :unique_name    => "request_details"    ,
            :footers        => false                ,
            :head_section   => true                 ,
            :title          => false                ,
            :legend         => false                ,
            :caption        => "Recipients #{add_new_button}",
            :embedded_style => {
            #    :table  => "width:100%;",
            #    :th     => nil,
            #    :tr     => nil,
            #    :tr_alt => nil,
                :td     => "border-bottom:1px dashed #6B6B6B"
            }
            
        )
        
    end
    
    def save_requested_documents
        
        $tables.attach("RRI_DOCUMENT_TYPES").primary_ids.each do |pid|
            
            if $kit.params["rri_document_type__#{pid}".to_sym] == "1"
                
                new_row = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").new_row
                
                new_row.fields["rri_request_id" ].value = !$kit.rows.empty? ? $kit.rows.first[1].fields["primary_id"].value : $kit.params[:rri_request_pid]
                new_row.fields["record_type_id" ].value = pid
                new_row.fields["student_id"     ].value = $focus_student.student_id.value
                
                new_row.save
                
            end
            
        end
        
    end
    
    def documents_table(rri_request_id, update=false)
        
        requests = [
            
            #HEADERS
            [
                "Document"      ,
                "Status"        ,
                "Completed"     ,
                "Notes"
            ]
            
        ]
        
        records = $focus_student.rri_requested_documents.existing_records("WHERE rri_request_id = '#{rri_request_id}'")
        
        records.each{|record|
            
            requests.push(
                
                [
                    
                    record.fields["record_type_id"  ].set(
                        
                        $tables.attach("RRI_DOCUMENT_TYPES").field_value(
                            "document_name",
                            "WHERE primary_id = '#{record.fields["record_type_id"].value}'"
                        )
                        
                    ).web.label,
                    record.fields["status"          ].web.select(
                        
                        :dd_choices => $tables.attach("RRI_STATUS").dd_choices(
                            "status"      ,
                            "primary_id"  ,
                            nil
                        )
                        
                    ),
                    record.fields["date_completed"  ].web.default,
                    record.fields["notes"           ].web.default
                    
                ]
                
            )
            
        } if records
        
        all_doc_pids        = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids
        student_doc_pids    = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").records("WHERE rri_request_id = '#{rri_request_id}'")
        
        add_new_button      = !student_doc_pids || all_doc_pids && all_doc_pids.length > student_doc_pids.length ? $tools.button_new_row(
            
            table_name                  = "STUDENT_RRI_REQUESTED_DOCUMENTS"     ,
            additional_params_str       = "rri_request_id=#{rri_request_id}"    ,
            save_params                 = nil                                   ,
            button_text                 = "Add New Document"                             ,
            i_will_manually_add_the_div = true                                  ,
            inner_add_new               = nil                                   ,
            return_js_string            = nil
            
        ) : nil
        
        return $tools.table(
            :table_array    => requests,
            :unique_name    => "requested_docs_#{rri_request_id}",
            :footers        => false,
            :head_section   => true,
            :title          => false,
            :legend         => false,
            :caption        => "#{add_new_button}",
            :no_container   => update,
            :embedded_style => {
            #    :table  => "width:100%;",
            #    :th     => nil,
            #    :tr     => nil,
            #    :tr_alt => nil,
                :td     => "border-bottom:1px dashed #6B6B6B"
            }
        )
        
    end
    
    def button_print_labels(pdf_name)
        button_html = String.new
        button_html << "<input id='label_ids'    name='label_ids'        value=''    type='hidden'>"
        button_html << "<input id='view_pdf_#{pdf_name}' name='view_pdf' value='#{pdf_name}' type='hidden'>"
        button_html << "<button name='new_pdf_button' class='new_pdf_button' id='new_pdf_button' onclick=\"print_labels\('rri_labels'\);\">PRINT LABELS</button>"
        return button_html
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            div.rri_document_type       { width:250px; height:20px;}
            div.rri_document_type label { float:left; display:inline-block; min-width:100px; text-align:left; margin-top:2px;}
            div.rri_document_type input { float:right;}
            
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes        textarea {width:140px; height:36px; float:left; resize:none; overflow-y:scroll; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes           label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes                 {float:left; width:150px; }
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  input {width:70px;}
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed        {float:left; clear:left; width:90px; margin-bottom:5px;}
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status          label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status                {float:left; clear:left; margin-bottom:5px;}
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status         select {float:left; width:100px;}
            
            div.STUDENT_RRI_REQUESTS__request_method                   {margin-bottom:10px;}
            div.STUDENT_RRI_REQUESTS__notes                   textarea {width:270px; height:100px; resize:none; overflow-y:scroll; }
            
            div.STUDENT_RRO_REQUIRED_DOCUMENTS__notes         textarea {width:220px; height:50px; resize:none; overflow-y:scroll; }
            
            div.STUDENT_RRI_RECIPIENTS__name                     label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__attn                     label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__via_mail                 label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__address_1                label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__address_2                label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__city                     label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__state                    label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__zip                      label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__via_fax                  label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__fax_number               label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__via_email                label {width:110px; display:inline-block;}
            div.STUDENT_RRI_RECIPIENTS__email_address            label {width:110px; display:inline-block;}
            
            div.STUDENT_RRI_RECIPIENTS__name                     input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__attn                     input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__address_1                input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__address_2                input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__city                     input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__state                    input {width:25px;  }
            div.STUDENT_RRI_RECIPIENTS__zip                      input {width:100px; }
            div.STUDENT_RRI_RECIPIENTS__fax_number               input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__email_address            input {width:250px; }
            div.STUDENT_RRI_RECIPIENTS__via_mail                 input {}
            div.STUDENT_RRI_RECIPIENTS__via_fax                  input {}
            div.STUDENT_RRI_RECIPIENTS__via_email                input {}
            
            div#add_new_dialog_STUDENT_RRI_REQUESTED_DOCUMENTS         {width:250px !important;}
        "
        
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end