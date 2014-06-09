#!/usr/local/bin/ruby


class STUDENT_RECORDS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
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
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
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
        
        open_record_pids        = nil
        nursing_departments     = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'nurse'")
        transcripts_department  = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'transcsript'")
        registrar_department    = $tables.attach("department").field_value("primary_id", "WHERE name REGEXP 'registrar'")
        
        if nursing_departments && nursing_departments.include?($team_member.department_id)
            
            open_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status NOT IN(
                    SELECT primary_id
                    FROM rri_status
                    WHERE status REGEXP 'complete'
                )
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Nursing'
                )"
            )
            
        elsif transcripts_department && transcripts_department.include?($team_member.department_id)
            
            open_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status NOT IN(
                    SELECT primary_id
                    FROM rri_status
                    WHERE status REGEXP 'complete'
                )
                AND record_type_id IN (
                    SELECT primary_id
                    FROM RRI_DOCUMENT_TYPES
                    WHERE document_category = 'Registrar'
                )"
            )
            
        elsif registrar_department && registrar_department.include?($team_member.department_id)
            
            open_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids(
                "WHERE status NOT IN(
                    SELECT primary_id
                    FROM rri_status
                    WHERE status REGEXP 'complete'
                )"
            )
            
        elsif $team_member.preferred_email.value == "jhalverson@agora.org"
            
            open_record_pids = $tables.attach("STUDENT_RRI_REQUESTED_DOCUMENTS").primary_ids()
            
        end
        
        if open_record_pids
            
            output.push(
                :name       => "MyRecordRequests (#{open_record_pids ? open_record_pids.length : 0})",
                :content    => record_requests_working_list(open_record_pids)
            )
            
        end
        
        return (output.empty? ? nil : output)
        
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
                "Student ID",
                "Request Method",
                "Status",
                "Requested Records",
                "Priority",
                "Notes"
            ]
            
        ]
        
        row = Array.new
        
        record = $focus_student.rri_requests.new_record
        
        row.push(record.fields["student_id"      ].web.label() + record.fields["student_id"].web.hidden()) 
        row.push(record.fields["request_method"  ].web.select(:dd_choices=>request_method_dd))
        row.push(record.fields["status"          ].web.select(:dd_choices=>rri_doc_status_dd))
        row.push("")
        row.push(record.fields["priority_level"  ].web.default())
        row.push(record.fields["notes"           ].web.default())
        
        tables_array.push(row)
      
        return $kit.tools.data_table(tables_array, "new_record", type = "NewRecord")
        
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
                "Request Method",
                "Status",
                "Priority",
                "Notes",
                "Date Completed"
            ]
            
        ]
        
        record_pids = $tables.attach("STUDENT_RRI_REQUESTS").primary_ids("WHERE student_id = #{$focus_student.student_id.value}")
        
        if record_pids
            
            record_pids.each{|pid|
                
                row            = Array.new
                
                record_record  = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(pid)
                
                sid            = record_record.fields["student_id"    ].value
                
                #row.push($tables.attach("RRO_DOCUMENT_TYPES").field_value("document_name", "WHERE primary_id = '#{record_type_id}'"))
                row.push(record_record.fields["request_method"   ].web.default() )
                row.push(record_record.fields["notes"            ].web.default())
                row.push(record_record.fields["priority_level"   ].web.default())
                row.push(record_record.fields["notes"            ].web.default())
                row.push(record_record.fields["date_completed"   ].web.default())
                
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
                        "Date Completed"
                    ]
                    
                ] if !requests.has_key?(request_id)
                
                requests[request_id].push(
                    
                    [
                     
                        record.fields["record_type_id"].set(
                            
                            $tables.attach("RRI_DOCUMENT_TYPES").field_value(
                                "document_name",
                                "WHERE primary_id = '#{record.fields["rri_request_id"].value}'"
                            )
                            
                        ).web.label,
                        
                        record.fields["status"].web.select(
                            
                            :dd_choices => $tables.attach("RRI_STATUS").dd_choices(
                                "status"      ,
                                "primary_id"  ,
                                nil
                            )
                            
                        ),
                        
                        record.fields["date_completed"].web.default
                        
                    ]
                    
                )
                
                
            }
            
            tables_array = [
                
                #HEADERS #other requested headres are student name, active status
                [
                 
                    "High Priority?"            ,
                    "Request Details"           ,
                    #"Student ID"                ,
                    #"Request Method"            ,
                    #"Status"                    ,
                    #"Notes"                     ,
                    #"Completed Date"            ,
                    "Print Labels?"             ,
                    "Recipients"                ,
                    "Requested Documents"
                   
                ]
                
            ]
            
            requests.keys.dup.each{|request_id|
                
                request_rec = $tables.attach("STUDENT_RRI_REQUESTS").by_primary_id(request_id)
                row         = Array.new
                
                row.push(request_rec.fields["priority_level"].web.default   )
                
                row.push(
                    
                    $tools.table(
                        :table_array    => [
                            
                            ["Student ID"       , request_rec.fields["student_id"    ].value            ],
                            ["Request Method:"  , request_rec.fields["request_method"].web.default      ],
                            ["Status"           , request_rec.fields["status"        ].web.default      ],
                            ["Notes:"           , request_rec.fields["notes"         ].web.default      ],
                            ["Date Completed"   , request_rec.fields["date_completed"].web.default      ]
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
                
                #row.push(request_rec.fields["student_id"    ].value         )
                #row.push(request_rec.fields["request_method"].web.default   )
                #row.push(request_rec.fields["status"        ].web.default   )
                #row.push(request_rec.fields["notes"         ].web.default   )
                #row.push(request_rec.fields["date_completed"].web.default   )
              
                row.push("This will house the checkboxes"                   )
                row.push("Recipients"                                       )
                
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
            
            return $kit.tools.data_table(tables_array, "my_record_requests")
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            #new_row_button_STUDENT_RRO_REQUIRED_DOCUMENTS                   { float:right; font-size: xx-small !important; margin-bottom:10px;}
            
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