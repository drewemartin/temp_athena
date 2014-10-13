#!/usr/local/bin/ruby

class STUDENT_RECORDS_OUTGOING_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        @my_record_requests = 0
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Record Requests - Outgoing"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        $kit.student_data_entry
        
    end
    
    def response
        
        if $kit.params[:add_rii_document]
            
            request_id = $kit.params[:add_rii_document].split("__").first
            doc_id     = $kit.params[:add_rii_document].split("__").last
            
            new_row = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").new_row
            
            new_row.fields["rri_request_id"].value = request_id
            new_row.fields["record_type_id"].value = doc_id
            
            new_row.save
            
            $kit.modify_tag_content("requested_docs_#{request_id}_container", requested_records_table(request_id, true), "update")
            
        end
        
        if $kit.params[:add_new_STUDENT_RRI_REQUESTS]
            
            $tables.attach("RRI_DOCUMENT_TYPES").primary_ids.each do |pid|
                
                if $kit.params["rri_document_type__#{pid}".to_sym] == "1"
                    
                    new_row = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").new_row
                    
                    new_row.fields["rri_request_id"].value = $kit.rows.first[1].fields["primary_id"].value
                    new_row.fields["record_type_id"].value = pid
                    
                    new_row.save
                    
                end
                
            end
            
            js_string = $tools.button_new_row(
                table_name                  = "STUDENT_RRI_RECIPIENTS",
                additional_params_str       = "rri_request_id=#{$kit.rows.first[1].primary_id}",
                save_params                 = "sid",
                button_text                 = nil,
                i_will_manually_add_the_div = true,
                inner_add_new               = false,
                return_js_string            = true
                
            )
            $kit.output = "<eval_script>#{js_string}</eval_script>"
            #$kit.params[:new_row] = "STUDENT_RRI_RECIPIENTS"
            
            #$kit.modify_tag_content("tabs-2", incoming_records, "update")
            
            
            return false
            
        end
        
        #if $kit.add_new?
        #    
        #    $kit.student_record.content
        #    
        #end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        outgoing_records
        
    end
    
    def record_request_files(sid)
        
        category_id = $tables.attach("document_category").find_field("primary_id",  "WHERE name='Student Record Requests'").value
        
        type_id     = $tables.attach("document_type"    ).find_field("primary_id",  "WHERE name='Outgoing' AND category_id='#{category_id}'").value
        
        @doc_pids   = $tables.attach("DOCUMENTS").document_pids(type_id, "STUDENT", "student_id", sid)
        
        return expand_documents
        
    end

    def working_list(refresh=false)
        
        output = Array.new
        
        nursing_departments     = $tables.attach("department").field_values("primary_id", "WHERE name REGEXP 'nursing'")
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
                
                ["New Documents (#{       new_record_pids     ? new_record_pids.length        : '0'   })",    new_record_pids     ? record_requests_working_list(new_record_pids      ) : "There are no 'New' record requests at this time."        ],
                ["Pending Documents (#{   pending_record_pids ? pending_record_pids.length    : '0'   })",    pending_record_pids ? record_requests_working_list(pending_record_pids  ) : "There are no 'Pending' record requests at this time."    ]
                
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
    
    def add_new_record_student_rro_required_documents()
        
        tables_array = [
            
            #HEADERS
            [
                "StudentID",
                "Record Type",
                "Status"
            ]
            
        ]
        
        row = Array.new
        
        record = $focus_student.rro_required_documents.new_record
        
        row.push( record.fields["student_id"           ].web.label() + record.fields["student_id"].web.hidden()) 
        row.push( record.fields["record_type_id"       ].web.select(:dd_choices=>document_types_dd($focus_student.student_id.value), :validate => true) )
        row.push( record.fields["status"               ].web.select(:dd_choices=>status_dd,         :validate => true) )  
        
        tables_array.push(row)
      
        return $kit.tools.data_table(tables_array, "new_record", type = "NewRecord")
        
    end
    
    def add_new_record_student_rri_recipients
        
        output = String.new
        
        record = $kit.params[:existing_recipient] ? $focus_student.rri_recipients.record("WHERE primary_id = '#{$kit.params[:existing_recipient]}'") : $focus_student.rri_recipients.new_record
        
        output << record.fields["rri_request_id"  ].set($kit.params[:rri_request_id]).web.hidden() + record.fields["student_id"  ].set($focus_student.student_id.value).web.hidden()
        
        school_dd = $tables.attach("SCHOOLS").dd_choices(
            name            = "school_name" ,
            value           = "primary_id"  ,
            where_clause    = nil
        )
        
        output << $field.new(
            "type"  =>  "text",
            "field" =>  "school_name",
            "value" =>  nil
        ).web.select(
            {
                :dd_choices => school_dd,
                :onchange   => "
                fill_select_option('#{record.fields["name"          ].web.field_id}', this );
                fill_select_option('#{record.fields["address_1"     ].web.field_id}', this );
                fill_select_option('#{record.fields["city"          ].web.field_id}', this );
                fill_select_option('#{record.fields["state"         ].web.field_id}', this );
                fill_select_option('#{record.fields["zip"           ].web.field_id}', this );"
                #fill_select_option('#{record.fields["fax_number"    ].web.field_id}', this );
                #fill_select_option('#{record.fields["email_address" ].web.field_id}', this );"
            },
            true
        )
        
        output << record.fields["name"            ].web.text(    :label_option => "Name:"            )
        output << record.fields["attn"            ].web.text(    :label_option => "Attention:"       )
        output << record.fields["via_mail"        ].web.default( :label_option => "Via Mail?"        )
        output << record.fields["address_1"       ].web.text(    :label_option => "Address 1:"       )
        output << record.fields["address_2"       ].web.text(    :label_option => "Address 2:"       )
        output << record.fields["city"            ].web.text(    :label_option => "City:"            )
        output << record.fields["state"           ].web.text(    :label_option => "State:"           )
        output << record.fields["zip"             ].web.text(    :label_option => "Zip:"             )
        output << record.fields["via_fax"         ].web.default( :label_option => "Via Fax?"         )
        output << record.fields["fax_number"      ].web.text(    :label_option => "Fax Number:"      )
        output << record.fields["via_email"       ].web.default( :label_option => "Via Email?"       )
        output << record.fields["email_address"   ].web.text(    :label_option => "Email Address:"   )
        
        return output
        
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
        
        doc_pids        = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids("ORDER BY document_category ASC")
        
        doc_checkboxes  = String.new
        
        doc_pids.each do |doc_pid|
            
            record      = $tables.attach("RRI_DOCUMENT_TYPES").by_primary_id(doc_pid)
            
            pid         = record.fields["primary_id"].value
            
            new_field = $field.new({"type" => "text", "field" => "rri_document_type__#{pid}"})
            
            doc_checkboxes << new_field.web.checkbox({:label_option=>record.fields["document_name"].value, :field_id=>"rri_document_type_submit__" + record.fields["primary_id"].value, :add_class=>"no_save rri_document_type"})
            
        end if doc_pids
        
        row = Array.new
        
        #row.push(
        #    
        #    $field.new("field"=>"modify_tag").set("new_recipients").web.hidden +
        #    $tools.button_new_row(
        #        table_name              = "STUDENT_RRI_RECIPIENTS"  ,
        #        additional_params_str   = "modify_tag"              ,
        #        save_params             = "modify_tag",
        #        nil,nil,true
        #    ) +
        #    "<DIV id='new_recipients'></DIV>"
        #    
        #)
        
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
                "Normal"        ,
                "*High*"          ,
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
        
        [
            {:name=>"End Of Year Request",                   :value=>"End Of Year Request"                  },
            {:name=>"Parent Email",                          :value=>"Parent Email"                         },
            {:name=>"Parent Written Request",                :value=>"Parent Written Request"               },
            {:name=>"School or District Email",              :value=>"School or District Email"             },
            {:name=>"School or District Written Request",    :value=>"School or District Written Request"   },
            {:name=>"Social Security Determination Request", :value=>"Social Security Determination Request"},
            {:name=>"Social Service Email",                  :value=>"Social Service Email"                 },
            {:name=>"Social Service Written Request",        :value=>"Social Service Written Request"       }
        ]
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FILL_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def fill_select_option_name(field_name, field_value, pid)
        
        return $tables.attach("SCHOOLS").field_value("school_name", "WHERE primary_id = '#{field_value}'")
        
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

    def outgoing_records
        
        output = String.new
        
        output << $tools.button_new_row(
            table_name              = "STUDENT_RRO_REQUIRED_DOCUMENTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        sid = $focus_student.student_id.value
        
        previous_school_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_student_id(sid)
        
        #if previous_school_record && previous_school_record.fields["verified"].value == "1"
        #    
        #    output << $tools.button_view_pdf(
        #        "record_request",
        #        "",
        #        additional_params_str = sid,
        #        ["sid"]
        #    )
        #    
        #else
        #    
        #    output << $tools.newlabel("not_verified", "This student's previous school is not verified, so a pdf can not be made.")
        #    
        #end
        
        tables_array = [
            
            #HEADERS
            [
                "Record Type",
                "Status",
                "Received Date",
                "Notes",
                "Created Date"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        if record_pids
            
            record_pids.each{|pid|
                
                row            = Array.new
                
                record_record  = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").by_primary_id(pid)
                
                sid            = record_record.fields["student_id"    ].value
                
                record_type_id = record_record.fields["record_type_id"].value
                
                row.push($tables.attach("RRO_DOCUMENT_TYPES").field_value("document_name", "WHERE primary_id = '#{record_type_id}'"))
                row.push(record_record.fields["status"         ].web.select(:dd_choices=>status_dd)   )
                row.push(record_record.fields["received_date"  ].web.default())
                row.push(record_record.fields["notes"          ].web.default())
                row.push(record_record.fields["created_date"   ].to_user())
                
                tables_array.push(row)
                
            }
            
            output << $kit.tools.data_table(tables_array, "record_students")
            
        else
            
            output << $tools.newlabel("no_record", "There are not contacts entered for this student.")
            
        end
        
        return output
        
    end
    
    def incoming_records
        
        output = String.new
        
        output << $tools.button_new_row(
            table_name              = "STUDENT_RRI_REQUESTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        output << "<DIV id='add_new_dialog_STUDENT_RRI_RECIPIENTS' style='display:none;' class='add_new_dialog'></DIV>\n"
        
        output << "<input id='new_row_STUDENT_RRI_RECIPIENTS' type='hidden' value='STUDENT_RRI_RECIPIENTS' name='new_row'>"
        
        tables_array = [
            
            #HEADERS
            [
                "Priority",
                "Requested Records",
                "Request Details"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRI_REQUESTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        if record_pids
            
            record_pids.each{|pid|
                
                row           = Array.new
                
                record_record = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(pid)
                
                sid           = record_record.fields["student_id"].value
                
                row.push(record_record.fields["priority_level"   ].web.select(:dd_choices=>priority_levels))
                
                if requests = requested_records_table(pid)
                    
                    row.push(requested_records_table(pid))
                    
                else
                    
                    row.push("")
                    
                end
                
                recipients = $focus_student.rri_recipients.existing_records("WHERE rri_request_id = '#{pid}'")
                if recipients
                    
                    rec_table_array = Array.new
                    
                    recipients.each{|recipient|
                        
                        rec_table_array = [
                            ["Mail:",
                                "#{recipient.fields["name"].value}"+"<br>"+
                                "Attn: "+"#{recipient.fields["attn" ].value}"+"<br>"+
                                "#{recipient.fields["address_1"     ].value}"+"<br>"+
                                "#{recipient.fields["address_2"     ].value}"+"<br>"+
                                "#{recipient.fields["city"          ].value}"+", "+
                                "#{recipient.fields["state"         ].value} "+
                                "#{recipient.fields["zip"           ].value}"],
                            ["Fax:",
                                recipient.fields["fax_number"    ].value],
                            ["Email:",
                                recipient.fields["email_address" ].value]
                        ]
                        
                    }
                    
                    recipient_table = $tools.table(
                        :table_array    => rec_table_array,
                        :student_link   => "name",
                        :unique_name    => "request_details",
                        :footers        => false,
                        :head_section   => false,
                        :title          => false,
                        :legend         => false,
                        :caption        => false
                    )
                    
                else
                    
                    recipient_table = "No recipients found."
                    
                end
                
                row.push(
                    
                    recipient_table+
                    record_record.fields["request_method"   ].web.select( :label_option=>"Request Method:", :dd_choices=>request_method_dd)+
                    record_record.fields["notes"            ].web.default(:label_option=>"Notes:")
                    
                )
                
                tables_array.push(row)
                
            }
            
            output << $kit.tools.data_table(tables_array, "incoming_records")
            
        else
            
            output << $tools.newlabel("no_record", "There are not contacts entered for this student.")
            
        end
        
        return output
        
    end
    
    def expand_documents
        
        output = "<div style='width:990px;'>"
        
        tables_array = [
            
            #HEADERS
            [
                "Action",
                "Document Type",
                "Date Uploaded",
                "Uploaded By"
            ]
        ]
        
        @doc_pids.each{|pid|
            
            document = $tables.attach("DOCUMENTS").by_primary_id(pid)
            
            tables_array.push([
                
                $tools.doc_secure_link(pid, "View or Download"),
                
                $tables.attach("document_type").field_by_pid("name", document.fields["type_id"].value).value,
                
                document.fields["created_date"].to_user,
                
                begin $team.by_team_email(document.fields["created_by"].value).full_name rescue "Unknown" end
                
            ])
            
        } if @doc_pids
        
        output << $kit.tools.data_table(tables_array, "record_request_documents")
        output << "</div>"
        
        return output
        
    end
    
    def record_requests_working_list(open_record_pids)
        
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
                
                recipients = $students.get(request_rec.fields["student_id"].value).rri_recipients.existing_records("WHERE rri_request_id = '#{request_id}'")
                if recipients
                    
                    rec_table_array = Array.new
                    
                    add_new_button = $tools.button_new_row(
                        
                        table_name                  = "STUDENT_RRI_RECIPIENTS"                                                              ,
                        additional_params_str       = "rri_request_id=#{request_id},sid=#{request_rec.fields["student_id"].value}"          ,
                        save_params                 = nil                                                                                   ,
                        button_text                 = "Add New"                                                                             ,
                        i_will_manually_add_the_div = true                                                                                  ,
                        inner_add_new               = nil                                                                                   ,
                        return_js_string            = nil
                        
                    )
                    
                    rec_table_array.push(
                        
                        [
                            
                            "Print?"        ,
                            "Edit"          ,
                            "Recipients #{add_new_button}"               
                            
                        ]
                        
                    )
                    recipients.each{|recipient|
                        
                        add_table_arr = [
                            ["Mail:",
                                "#{recipient.fields["name"].value}"+"<br>"+
                                "Attn: "+"#{recipient.fields["attn" ].value}"+"<br>"+
                                "#{recipient.fields["address_1"     ].value}"+"<br>"+
                                "#{recipient.fields["address_2"     ].value}"+"<br>"+
                                "#{recipient.fields["city"          ].value}"+", "+
                                "#{recipient.fields["state"         ].value} "+
                                "#{recipient.fields["zip"           ].value}"],
                            ["Fax:",
                                recipient.fields["fax_number"    ].value],
                            ["Email:",
                                recipient.fields["email_address" ].value]
                        ]
                        
                        add_table = $tools.table(
                            :table_array    => add_table_arr,
                            :unique_name    => "address_block",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :legend         => false,
                            :caption        => false
                        )
                        
                        rec_table_array.push(
                            
                            [
                                
                                recipient.batch_checkbox,
                                $field.new.set_field_name("existing_recipient").set(recipient.primary_id).web.hidden +
                                $tools.button_new_row(
                                    
                                    table_name                  = "STUDENT_RRI_RECIPIENTS"      ,
                                    additional_params_str       = "existing_recipient"          ,
                                    save_params                 = "existing_recipient"          ,
                                    button_text                 = "Edit"                        ,
                                    i_will_manually_add_the_div = false                         ,
                                    inner_add_new               = false                         ,
                                    return_js_string            = false
                                    
                                ),
                                add_table
                              
                            ]
                            
                        )
                        
                    }
                    
                    recipient_table = $tools.table(
                        :table_array    => rec_table_array,
                        :student_link   => "name",
                        :unique_name    => "request_details",
                        :footers        => false,
                        :head_section   => true,
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
                    )
                    
                else
                    
                    recipient_table = "No recipients found."
                    
                end
                
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
                    recipient_table
                    
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
    
    def requested_records_table(pid, update=false)
        
        requests = [
            
            #HEADERS
            [
                "Document"      ,
                "Details"
                #"Status"        ,
                #"Date Completed",
                #"Notes"
            ]
            
        ]
        
        all_doc_pids = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids
        
        all_doc_pids.each do |doc_pid|
            
            requested_document = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").record("WHERE rri_request_id = '#{pid}' AND record_type_id = '#{doc_pid}'")
            
            if requested_document
                
                requests.push(
                    
                    [
                        
                        requested_document.fields["record_type_id"].set(
                            
                            $tables.attach("RRI_DOCUMENT_TYPES").field_value(
                                "document_name",
                                "WHERE primary_id = '#{requested_document.fields["record_type_id"].value}'"
                            )
                            
                        ).web.label,
                        
                        requested_document.fields["status"].web.select(
                            
                            :dd_choices => $tables.attach("RRI_STATUS").dd_choices(
                                "status"      ,
                                "primary_id"  ,
                                nil
                            ),
                            :label_option=>"Status:"
                        )+
                        
                        requested_document.fields["date_completed"].web.default(:label_option=>"Date Completed:")+
                        requested_document.fields["notes"].web.default(:label_option=>"Notes:")
                        
                    ]
                    
                )
                
            else
                
                button_name = "Add " + $tables.attach("RRI_DOCUMENT_TYPES").by_primary_id(doc_pid).fields["document_name"].value
                
                button = "
                    <button class='add_rii_doc_button' id='add_rii_doc_button_#{pid}' onclick='send\(\"add_rii_document_#{pid}_#{doc_pid}\"\)\;var par_div = this.parentNode.parentNode.parentNode.parentNode.parentNode; par_div.style.height = par_div.offsetHeight+\"px\";setPreSpinner(\"requested_docs_#{pid}_container\");'>#{button_name}</button>
                    <input id='add_rii_document_#{pid}_#{doc_pid}' type='hidden' value='#{pid}__#{doc_pid}' name='add_rii_document'
                "
                
                requests.push([button,nil,nil])
                
            end
            
        end
        
        return $tools.table(
            :table_array    => requests,
            :unique_name    => "requested_docs_#{pid}",
            :footers        => false,
            :head_section   => true,
            :title          => false,
            :legend         => false,
            :caption        => false,
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
            
            div.rri_document_type       { width:150px; height:20px;}
            div.rri_document_type label { float:left; display:inline-block; min-width:100px; text-align:left; margin-top:2px;}
            div.rri_document_type input { float:right;}
            
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes        textarea {width:200px; height:36px; float:left; resize:none; overflow-y:scroll; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes           label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes                 {float:left; width:300px; }
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  input {width:70px;}
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed        {float:left; clear:left; width:300px; margin-bottom:5px;}
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status          label {float:left; display:inline-block; margin-right:10px; }
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status                {float:left; clear:left; width:300px; margin-bottom:5px;}
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__status         select {float:left;}
            
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