#!/usr/local/bin/ruby


class STUDENT_RECORDS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        @my_record_requests = 0
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Student Records"
        
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
            
            $kit.modify_tag_content("tabs-2", incoming_records, "update")
            
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
        
        tabs = Array.new
        
        tabs.push(["Outgoing",  outgoing_records])
        tabs.push(["Incoming",  incoming_records])
        tabs.push(["Documents", record_request_files($focus_student.student_id.value)])
        
        return $kit.tools.tabs(
            
            tabs,
            selected_tab    = 0,
            tab_id          = "records",
            search          = false
            
        )
        
    end
    
    def record_request_files(sid)
        
        category_id = $tables.attach("document_category").find_field("primary_id",  "WHERE name='Student Record Requests'").value
        
        type_id     = $tables.attach("document_type"    ).find_field("primary_id",  "WHERE name='Outgoing' AND category_id='#{category_id}'").value
        
        @doc_pids   = $tables.attach("DOCUMENTS").document_pids(type_id, "STUDENT", "student_id", sid)
        
        return expand_documents
        
    end

    def working_list
        
        output = Array.new
        
        nursing_departments     = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'nurse'")
        transcripts_department  = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'transcsript'")
        registrar_department    = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'registrar'")
        
        if nursing_departments && nursing_departments.include?($team_member.department_id)
            
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
            
        elsif transcripts_department && transcripts_department.include?($team_member.department_id)
            
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
            
        elsif registrar_department && registrar_department.include?($team_member.department_id)
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL"
            )
            
        elsif $team_member.preferred_email.value == "jhalverson@agora.org"
            
            new_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status IS NULL
                AND date_completed IS NULL"
            )
            
            pending_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE date_completed IS NULL
                AND status IS NOT NULL"
            )
            
        end
        
        tabulated_list = $kit.tools.tabs(
            
            tabs            = [
                
                ["New (#{       new_record_pids     ? new_record_pids.length        : '0'   })",    new_record_pids     ? record_requests_working_list(new_record_pids      ) : "There are no 'New' record requests at this time."        ],
                ["Pending (#{   pending_record_pids ? pending_record_pids.length    : '0'   })",    pending_record_pids ? record_requests_working_list(pending_record_pids  ) : "There are no 'Pending' record requests at this time."    ]
                
            ],
            selected_tab    = 0,
            tab_id          = "rri",
            search          = false
        )
        
        output.push(
            :name       => "MyRecordRequests",
            :content    => tabulated_list
        )
        
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
    
    def add_new_record_student_rri_requests()
        
        tables_array = [
            
            #HEADERS
            [
                "Priority"          ,
                "Date Requested"    ,
                "Request Method"    ,
                "Requested Records" ,
                "Notes"
            ]
            
        ]
        
        doc_pids = $tables.attach("RRI_DOCUMENT_TYPES").primary_ids("ORDER BY document_category ASC")
        
        doc_checkboxes = String.new
        
        doc_pids.each do |doc_pid|
            
            record = $tables.attach("RRI_DOCUMENT_TYPES").by_primary_id(doc_pid)
            
            pid = record.fields["primary_id"].value
            
            new_field = $field.new({"type" => "text", "field" => "rri_document_type__#{pid}"})
            
            doc_checkboxes << new_field.web.checkbox({:label_option=>record.fields["document_name"].value, :field_id=>"rri_document_type_submit__" + record.fields["primary_id"].value, :add_class=>"no_save rri_document_type"})
            
        end if doc_pids
        
        row = Array.new
        
        record = $focus_student.rri_requests.new_record
        
        row.push(record.fields["priority_level"  ].web.default())
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
        
        tables_array = [
            
            #HEADERS
            [
                "Priority",
                "Requested Records",
                "Request Method",
                "Notes"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRI_REQUESTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        if record_pids
            
            record_pids.each{|pid|
                
                row           = Array.new
                
                record_record = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(pid)
                
                sid           = record_record.fields["student_id"].value
                
                row.push(record_record.fields["priority_level"   ].web.default())
                
                if requests = requested_records_table(pid)
                    
                    row.push(requested_records_table(pid))
                    
                else
                    
                    row.push("")
                    
                end
                
                row.push(record_record.fields["request_method"   ].web.select(:dd_choices=>request_method_dd))
                row.push(record_record.fields["notes"            ].web.default())
                
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
                        "Document"      ,
                        "Status"        ,
                        "Date Completed",
                        "Notes"
                    ]
                    
                ] if !requests.has_key?(request_id)
                
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
                            )
                            
                        ),
                        
                        record.fields["date_completed"  ].web.default,
                        record.fields["notes"           ].web.default
                        
                    ]
                    
                )
                
                
            }
            
            tables_array = [
                
                #HEADERS #other requested headres are student name, active status
                [
                 
                    "High Priority?"            ,
                    "Request Details"           ,
                    "Requested Documents"
                   
                ]
                
            ]
            
            requests.keys.each{|request_id|
                
                request_rec = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(request_id)
                row         = Array.new
                
                row.push(
                    
                    request_rec.fields["requested_date"    ].web.default(:label_option=>"Requested Date") +
                    request_rec.fields["priority_level"    ].web.default(:label_option=>"Priority?"     )
                    
                )
                
                row.push(
                    
                    $tools.table(
                        :table_array    => [
                            
                            ["Student ID"       , request_rec.fields["student_id"    ].value            ],
                            ["Request Method:"  , request_rec.fields["request_method"].web.text         ],
                            ["Notes:"           , request_rec.fields["notes"         ].web.default      ],
                            ["Print Label?"     , "checkbox"                                            ],
                            ["Recipients"       , "recipients"                                          ]
                            
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
                        :caption        => false#,
                        #:embedded_style => {
                        #    :table  => "width:100%;",
                        #    :th     => nil,
                        #    :tr     => nil,
                        #    :tr_alt => nil,
                        #    :td     => nil
                        #}
                    )
                    
                )
                
                tables_array.push(row)
                
            }
            
            @my_record_requests = @my_record_requests+=1
            
            return $kit.tools.data_table(tables_array, "my_record_requests_#{@my_record_requests}")
            
        end
        
    end
    
    def requested_records_table(pid, update=false)
        
        requests = [
            
            #HEADERS
            [
                "Document"      ,
                "Status"        ,
                "Date Completed",
                "Notes"
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
                            )
                            
                        ),
                        
                        requested_document.fields["date_completed"].web.default,
                        requested_document.fields["notes"].web.default
                        
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
            :no_container   => update
        )
        
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
            
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__date_completed  input    {width:70px;}
            div.STUDENT_RRI_REQUESTED_DOCUMENTS__notes           textarea {width:120px; height:36px; resize:none; overflow-y:scroll; }
            
            div.STUDENT_RRI_REQUESTS__request_method                      {margin-bottom:10px;}
            div.STUDENT_RRI_REQUESTS__notes                      textarea {width:220px; height:100px; resize:none; overflow-y:scroll; }
            
            div.STUDENT_RRO_REQUIRED_DOCUMENTS__notes            textarea {width:220px; height:50px; resize:none; overflow-y:scroll; }
            
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