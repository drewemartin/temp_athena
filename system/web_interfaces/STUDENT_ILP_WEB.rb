#!/usr/local/bin/ruby


class STUDENT_ILP_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
      
        @ilp_categories = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids(
            "WHERE #{$focus_student.grade.to_grade_field} IS TRUE
            ORDER BY name ASC"
        )
      
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        if (
            
            new_category_dd
            
        )
            
            add_new_button = $tools.button_new_row(
                table_name              = "STUDENT_ILP",
                additional_params_str   = "sid",
                save_params             = "sid"
            )
            
            upload_doc_button  = $tools.button_upload_doc( "ilp_document", "sid" )
            create_doc_button  = $tools.button_view_pdf(  "ilp_document", "", additional_params_str = $focus_student.student_id.value, ["sid"])
            responsible_parties_dialog = "<DIV id='add_new_dialog_STUDENT_ILP_RESPONSIBLE_PARTIES' style='display:none;' class='add_new_dialog'></DIV>\n"
            
            return "Individualized Learning Plan #{add_new_button}#{upload_doc_button}#{create_doc_button}#{responsible_parties_dialog}"
            
        elsif $focus_student.ilp.existing_records
            
            upload_doc_button  = $tools.button_upload_doc( "ilp_document", "sid" )
            create_doc_button  = $tools.button_view_pdf(  "ilp_document", "", additional_params_str = $focus_student.student_id.value, ["sid"])
            
            return "Individualized Learning Plan #{upload_doc_button}#{create_doc_button}"
            
        else
            
            return "Individualized Learning Plan"
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
    end
    
    def response
        
        if $kit.add_new?
            
            student_record
            
        end
        
        if $kit.params[:fields].keys.find{|x|x.to_s.match(/description/)}
            
            row_key = $kit.params[:rows].keys[0]
            pid     = $kit.params[:rows][row_key].primary_id
            
            record  = $focus_student.ilp.existing_records("WHERE primary_id = '#{pid}'")[0]
            cat_id  = record.fields["ilp_entry_category_id"].value
            index   = @ilp_categories.index(cat_id)+1
            
            records                 = $focus_student.ilp.existing_records("WHERE ilp_entry_category_id = '#{cat_id}'")
            records_count           = records ? records.length : 0
            records_filled          = $focus_student.ilp.existing_records("WHERE ilp_entry_category_id = '#{cat_id}' AND description IS NOT NULL")
            records_filled_count    = records_filled ? records_filled.length : 0
            category_name           = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(cat_id).fields["name"].value
            
            $kit.modify_tag_content(
                "tab_title-#{index}",
                "#{category_name} (#{records_filled_count}/#{records_count})"
            )
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record(sid = $kit.params[:sid])
        
        tabs = Array.new
        
        @ilp_categories.each{|pid|
            
            verify_required_types_exist(pid)
            records                 = $focus_student.ilp.existing_records("WHERE ilp_entry_category_id = '#{pid}'")
            records_count           = records ? records.length : 0
            records_filled          = $focus_student.ilp.existing_records("WHERE ilp_entry_category_id = '#{pid}' AND description IS NOT NULL")
            records_filled_count    = records_filled ? records_filled.length : 0
            category_name           = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(pid).fields["name"].value
            
            if $tables.attach("ILP_ENTRY_CATEGORY").field_by_pid("manual",pid).is_true? 
                label_with_indicator = "<span class='ui-icon ui-icon-unlocked' style='display:inline-block;height: 12px;'></span>#{category_name}(#{records_filled_count}/#{records_count})"
            else
                label_with_indicator = "<span class='ui-icon ui-icon-locked'   style='display:inline-block;height: 12px;'></span>#{category_name}(#{records_filled_count}/#{records_count})"
            end
            
            tabs.push([label_with_indicator, ilp_details(records, category_name.downcase)    ]) 
            
        }
        
        tabs.push(["Uploads", ilp_uploads(sid)])
        
        return $kit.tools.tabs(
            
            tabs,
            selected_tab    = 0,
            tab_id          = "ilp",
            search          = false
            
        )
        
    end
    
    def ilp_uploads(sid)
        
        output  = String.new
        
        category_id = $tables.attach("document_category").find_field("primary_id",  "WHERE name='Individualized Learning Plan'").value
        
        type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Student ILP' AND category_id='#{category_id}'").value
        
        if @doc_pids = $tables.attach("DOCUMENTS").document_pids(type_id, "STUDENT", "student_id", sid)
            
            output << expand_documents
            
        else
            
            output << "No Files Have Been Uploaded."
            
        end
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________UPLOAD_PDF_FORMS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def upload_doc_ilp_document(sid)
        output = String.new
        
        output << "<form id='doc_upload_form' name='form' action='athena_cgi.rb' method='POST' enctype='multipart/form-data' >"
        output << "<input id='sidref' name='sidref' value='#{sid}' type='hidden'>"
        output << $tools.document_upload2(self.class.name, "Individualized Learning Plan", "Student ILP", "doc_upload_form", "pdf")
        output << "</form>"
        
        return output
    end
    
    def add_new_pdf_ilp_document(sid)
        
        template = "INDIVIDUALIZED_LEARNING_PLAN_PDF.rb"
        
        pdf = Prawn::Document.generate "#{$paths.htdocs_path}temp/ilp_temp#{$ifilestamp}.pdf" do |pdf|
            require "#{$paths.templates_path}pdf_templates/#{template}"
            template = eval("#{template.gsub(".rb","")}.new")
            template.generate_pdf(sid, pdf)
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_student_ilp()
        
        output  = String.new
        
        fields  = $focus_student.ilp.new_record.fields
        
        output << fields["ilp_entry_category_id"].web.select(
            :label_option   => "Individualized Learning Plan Category",
            :dd_choices     => new_category_dd,
            :onchange       => "fill_select_option('add_new_dialog_STUDENT_ILP', this, 'student_id'  );",
            :validate       => true
        )
        
        #output << "<div id='new_ilp_details'></div>"
        
        output << $tools.disable_save_button("Save Record")
        
        return output 
        
    end
    
    def add_new_record_student_ilp_responsible_parties
        
        output      = String.new
        
        fields      = $focus_student.ilp_responsible_parties.new_record.fields
        
        output << fields["ilp_id"       ].set($kit.params[:ilp_id]).web.hidden
        output << fields["student_id"   ].web.hidden
        
        tables_array = Array.new
        
        tables_array.push(
            
            [
                
                "Responsible Party",
                "Responsibility",
                "Completed?"
               
            ]
            
        )
        
        tables_array.push(
            
            [
             
                fields["team_id"].web.select(
                    :dd_choices     => responsible_parties_dd,
                    :validate       => true
                ),
                fields["responsibility"].web.default(:validate=> true),
                fields["completed"     ].web.default
                
            ]
            
        )
        
        output << $kit.tools.data_table(tables_array, "new_test_events", type = "NewRecord")
        
        return output 
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
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
            
        }
        
        output << $kit.tools.data_table(tables_array, "evaluation_documents")
        output << "</div>"
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def progress_dd
        
        progress_types = [
            
            "Achieved",     
            "In Progress",
            "Not Met"
            
        ]
        
        $dd.from_array(progress_types)
        
    end
    
    def goal_type_dd
        
        goal_types = [
            
            "Short Term Goals",     
            "Mid Term Goals",       
            "Agora Eagle",          
            "Post-Secondary Goals", 
            "Career Goals",         
            
        ]
        
        $dd.from_array(goal_types)
        
    end
    
    def new_category_dd
        
        $tables.attach("ILP_ENTRY_CATEGORY").dd_choices(
            "ilp_entry_category.name",
            "ilp_entry_category.primary_id",
            "LEFT JOIN ilp_entry_type ON ilp_entry_type.category_id = ilp_entry_category.primary_id
            WHERE TRUE
            AND(
                ilp_entry_category.max_entries IS NULL
                OR(
                    
                    (SELECT COUNT(student_ilp.student_id)
                    FROM student_ilp
                    WHERE
                        student_ilp.student_id              = #{$focus_student.student_id.value} AND
                        student_ilp.ilp_entry_category_id   = ilp_entry_category.primary_id
                    GROUP BY student_ilp.student_id) IS NULL
                    
                    OR
                    
                    (SELECT COUNT(student_ilp.student_id)
                    FROM student_ilp
                    WHERE
                        student_ilp.student_id              = #{$focus_student.student_id.value} AND
                        student_ilp.ilp_entry_category_id   = ilp_entry_category.primary_id
                    GROUP BY student_ilp.student_id) < ilp_entry_category.max_entries
                    
                )
            )
            AND ilp_entry_category.manual IS TRUE
            AND ilp_entry_type.manual IS TRUE
            
            AND ilp_entry_category.#{$focus_student.grade.to_grade_field} IS TRUE
            AND ilp_entry_type.#{$focus_student.grade.to_grade_field}
            
            GROUP BY ilp_entry_category.primary_id
            ORDER BY ilp_entry_category.name ASC"
            
        )
        
    end
    
    def new_type_dd(cat_id)
        $tables.attach("ILP_ENTRY_TYPE").dd_choices(
            "name",
            "primary_id",
            "WHERE TRUE
            AND(
                ILP_ENTRY_TYPE.max_entries IS NULL
                OR(
                    
                    (SELECT COUNT(student_ilp.student_id)
                    FROM student_ilp
                    WHERE
                        student_ilp.student_id              = #{$focus_student.student_id.value} AND
                        student_ilp.ilp_entry_type_id   = ilp_entry_type.primary_id
                    GROUP BY student_ilp.student_id) IS NULL
                    
                    OR
                    
                    (SELECT COUNT(student_ilp.student_id)
                    FROM student_ilp
                    WHERE
                        student_ilp.student_id              = #{$focus_student.student_id.value} AND
                        student_ilp.ilp_entry_type_id   = ilp_entry_type.primary_id
                    GROUP BY student_ilp.student_id) < ilp_entry_type.max_entries
                    
                )
            )
            AND category_id = '#{cat_id}'
            AND #{$focus_student.grade.to_grade_field} IS TRUE
            AND manual IS TRUE
            ORDER BY name ASC"
        )
    end
    
    def responsible_parties_dd
        
        where_student = $focus_student ? "WHERE student_relate.studentid = '#{$focus_student.student_id.value}'" : "WHERE true"
        $tables.attach("team").dd_choices(
            "CONCAT(legal_first_name,' ',legal_last_name)",
            "team.primary_id",
            "LEFT JOIN student_relate ON student_relate.team_id = team.primary_id
            #{where_student}
            AND student_relate.active IS TRUE
            GROUP BY team.primary_id"
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_FILL_SELECT_OPTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def fill_select_option_description(field_name, field_value, pid)
        
        return $tables.attach("ILP_ENTRY_TYPE").by_primary_id(field_value).fields["default_description"].value
        
    end
    
    def fill_select_option_solution(field_name, field_value, pid)
        
        return $tables.attach("ILP_ENTRY_TYPE").by_primary_id(field_value).fields["default_solution"].value
        
    end
    
    def fill_select_option_ilp_entry_type_id(field_name, field_value, pid)
        
        output      = String.new
        
        dd_choices  = $tables.attach("ILP_ENTRY_TYPE").dd_choices(
            "name",
            "primary_id",
            "WHERE category_id = '#{field_value}' ORDER BY name ASC"
        )
        
        record = $tables.attach("STUDENT_ILP").new_row
        
        if dd_choices
            
            output << record.fields["ilp_entry_type_id"].web.select_replacement(
                {
                    :dd_choices     => dd_choices
                },
                true
            )
            
        else
            
            output << record.fields["ilp_entry_type_id"].web.select_replacement()
            
        end
        
        $kit.modify_tag_content("new_ilp_details", output       , "update")
        
    end

    def fill_select_option_add_new_dialog_STUDENT_ILP(field_name, field_value, pid)
        
        output  = String.new
        
        fields  = $focus_student.ilp.new_record.fields
        
        output << fields["student_id"].web.hidden()
        
        output << fields["ilp_entry_category_id"].set(field_value).web.select(
            :label_option   => "Individualized Learning Plan Category",
            :dd_choices     => new_category_dd,
            :onchange       => "fill_select_option('add_new_dialog_STUDENT_ILP', this, 'student_id'  );",
            :validate       => true
        )
        
        tables_array = Array.new
        
        headers = Array.new
        
        headers.push("Type"                  )
        headers.push("Description"           )
        
        category_record = $tables.attach("ILP_ENTRY_CATEGORY"   ).by_primary_id(field_value)
        
        #OPTIONAL FIELDS
        headers.push("Solution"                     ) if category_record && category_record.fields["interface_solution"           ].is_true? 
        headers.push("Completed"                    ) if category_record && category_record.fields["interface_completed"          ].is_true? 
        headers.push("Goal Type"                    ) if category_record && category_record.fields["interface_goal_type"          ].is_true? 
        headers.push("Progress"                     ) if category_record && category_record.fields["interface_progress"           ].is_true? 
        headers.push("Scheduled Re-Eval Date"       ) if category_record && category_record.fields["interface_expiration_date"    ].is_true?  
        headers.push("Display as Weekly Schedule"   ) if category_record && category_record.fields["display_type"].match(/Weekly/i)
        headers.push("Display as 6 Day Schedule"    ) if category_record && category_record.fields["display_type"].match(/6 Day/i)
        headers.push("Display as 7 Day Schedule"    ) if category_record && category_record.fields["display_type"].match(/7 Day/i)
        
        tables_array.push(headers)
        
        record_row = Array.new
        
        onchange = Array.new
        onchange.push("fill_select_option('#{fields["description" ].web.field_id}', this  );") if category_record.fields["interface_description"  ].is_true?
        onchange.push("fill_select_option('#{fields["solution"    ].web.field_id}', this  );") if category_record.fields["interface_solution"     ].is_true?
        record_row.push(
            fields["ilp_entry_type_id"].web.select(
                :dd_choices     => new_type_dd(field_value),
                :onchange       => onchange,
                :validate       => true
            )
        )
        record_row.push( fields["description"    ].web.default)
        
        #OPTIONAL FIELDS
        record_row.push( fields["solution"                           ].web.default                                            ) if category_record && category_record.fields["interface_solution"           ].is_true? 
        record_row.push( fields["completed"                          ].web.default                                            ) if category_record && category_record.fields["interface_completed"          ].is_true? 
        record_row.push( fields["goal_type"                          ].web.select(:dd_choices=> goal_type_dd)                 ) if category_record && category_record.fields["interface_goal_type"          ].is_true? 
        record_row.push( fields["progress"                           ].web.select(:dd_choices=> progress_dd)                  ) if category_record && category_record.fields["interface_progress"           ].is_true? 
        record_row.push( fields["expiration_date"                    ].web.default                                            ) if category_record && category_record.fields["interface_expiration_date"    ].is_true? 
        
        if category_record.fields["display_type"].match(/Weekly/i)
            
            weekly_schedule_arr = Array.new
            weekly_schedule_arr.push(["Monday","Tuesday","Wednesday","Thursday","Friday"])
            weekly_schedule_arr.push(
                
                [
                    fields["monday"   ].web.default,
                    fields["tuesday"  ].web.default,
                    fields["wednesday"].web.default,
                    fields["thursday" ].web.default,
                    fields["friday"   ].web.default
                ]
                
            )
            
            weekly_schedule = $tools.table(
                :table_array    => weekly_schedule_arr,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            record_row.push(weekly_schedule)
            
        end
        
        if category_record.fields["display_type"].match(/6 Day/i)
            
            six_day_schedule_arr = Array.new
            six_day_schedule_arr.push(["Day 1","Day 2","Day 3","Day 4","Day 5","Day 6"])
            six_day_schedule_arr.push(
                
                [
                    fields["day1"].web.default,
                    fields["day2"].web.default,
                    fields["day3"].web.default,
                    fields["day4"].web.default,
                    fields["day5"].web.default,
                    fields["day6"].web.default
                ]
                
            )
            
            six_day_schedule = $tools.table(
                :table_array    => six_day_schedule_arr,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            record_row.push(six_day_schedule)
            
        end
        
        if category_record.fields["display_type"].match(/7 Day/i)
            
            seven_day_schedule_arr = Array.new
            seven_day_schedule_arr.push(["Day 1","Day 2","Day 3","Day 4","Day 5","Day 6","Day 7"])
            seven_day_schedule_arr.push(
                
                [
                    fields["day1"].web.default,
                    fields["day2"].web.default,
                    fields["day3"].web.default,
                    fields["day4"].web.default,
                    fields["day5"].web.default,
                    fields["day6"].web.default,
                    fields["day7"].web.default
                ]
                
            )
            
            seven_day_schedule = $tools.table(
                :table_array    => seven_day_schedule_arr,
                :unique_name    => "eligible_grades",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
            record_row.push(seven_day_schedule)
            
        end
        
        tables_array.push(record_row)
        
        output << $kit.tools.data_table(tables_array, "new_test_events", type = "NewRecord")
        
        output << $tools.enable_save_button("Save Record")
        
        #$kit.modify_tag_content("add_new_dialog_STUDENT_ILP", output       , "update")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def ilp_details(student_ilps, section_name)
        
        tables_array = Array.new
        headers = Array.new
        
        headers.push("Exclude from PDF"     )
        headers.push("Created By"           )
        
        if student_ilps
            
            category_id         = student_ilps[0].fields["ilp_entry_category_id" ].value
            category_record = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(category_id)
            
            fields_displayed = Array.new
            category_record.fields.each_pair{|field_name, setting|
                
                if (field_name.match(/interface/) && setting.is_true?)
                    
                    if (ordered = category_record.fields[field_name.gsub("interface_","order_")].value)
                        fields_displayed[ordered.to_i-1] = field_name
                    else
                        fields_displayed.push(field_name)
                    end
                    
                end
                
            }
            
            fields_displayed.each{|field_name|
                
                custom_label    = category_record.fields[field_name.gsub("interface_","label_")].value
                default_label   = student_ilps[0].table.fields[field_name.gsub("interface_","")][:label]
                header_label    = custom_label || default_label
                headers.push("<b>#{header_label}</b>")   
                
            }
            
            student_ilps.each{|ilp|
                
                this_row = Array.new
                this_row.push( ilp.fields["pdf_excluded"   ].web.default                                               )
                team_member = $team.find(:email_address=>ilp.fields["created_by"].value)
                this_row.push( team_member ? team_member.full_name : ilp.fields["created_by"].value                    )
                
                fields_displayed.each{|field_name|
                 
                    ilp_field_name = field_name.gsub("interface_","")
                    if ilp_field_name.match(/ilp_entry_category_id/)
                        ilp_value = $tables.attach("ILP_ENTRY_CATEGORY" ).field_by_pid("name", ilp.fields[ilp_field_name].value).to_user
                    elsif ilp_field_name.match(/ilp_entry_type_id/)
                        ilp_value = $tables.attach("ILP_ENTRY_TYPE"     ).field_by_pid("name", ilp.fields[ilp_field_name].value).to_user
                    else
                        type_id = ilp.fields["ilp_entry_type_id"].value
                        disabled = !(
                            $tables.attach("ILP_ENTRY_CATEGORY" ).by_primary_id(category_id ).fields["manual"].is_true? &&
                            $tables.attach("ILP_ENTRY_TYPE"     ).by_primary_id(type_id     ).fields["manual"].is_true?            
                        )
                        ilp_value = ilp.fields[ilp_field_name].web.default(:disabled=>disabled)
                    end
                    this_row.push(ilp_value)   
                    
                }
                tables_array.push(this_row)
                
            }
            
        end
        
        return $tools.data_table(tables_array.insert(0, headers), section_name, "default", true)
        
    end

    def responsible_parties(student_ilp_record)
        
        parties_array   = Array.new
       
        parties_array.push(
            
            headers = [
                "Name",
                "Responsibility",
                "Completed?"
            ]
            
        )
        
        parties_records = $students.get(student_ilp_record.fields["student_id"].value).ilp_responsible_parties.existing_records("WHERE ilp_id = '#{student_ilp_record.primary_id}'")
        parties_records.each{|parties_record|
            
            t           = $team.get(parties_record.fields["team_id"].value)
            party_name  = "#{t.legal_first_name.value} #{t.legal_last_name.value}"
            parties_array.push(
                [
                    party_name,
                    parties_record.fields["responsibility"  ].web.default,
                    parties_record.fields["completed"       ].web.default
                ]
            )
           
        } if parties_records
        
        parties_table = $tools.table(
            :table_array    => parties_array,
            :unique_name    => "related_classes",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        ilp_id = student_ilp_record.fields["primary_id"].web.hidden(:field_id=>"ilp_id_#{student_ilp_record.fields["primary_id"].value}", :field_name=>"ilp_id")
        
        add_new_button = $tools.button_new_row(
            table_name              = "STUDENT_ILP_RESPONSIBLE_PARTIES",
            additional_params_str   = "sid,ilp_id_#{student_ilp_record.fields["primary_id"].value}",
            save_params             = "sid,ilp_id_#{student_ilp_record.fields["primary_id"].value}",
            "Add New",
            true
        )
        
        return "#{ilp_id}#{add_new_button}#{parties_table}"
        
    end
    
    def verify_required_types_exist(category_id)
        
        missing_entries = $tables.attach("ILP_ENTRY_TYPE").primary_ids(
            "LEFT JOIN student_ilp ON student_ilp.ilp_entry_type_id = ilp_entry_type.primary_id
                AND student_ilp.student_id = '#{$focus_student.student_id.value}'
            WHERE category_id = '#{category_id}'
                AND student_ilp.ilp_entry_type_id IS NULL
                AND ILP_ENTRY_TYPE.required IS TRUE"
        )
        
        if missing_entries
            
            $base.created_by = "Athena-SIS"
            
            missing_entries.each{|type_id|
                
                ilp_type_record = $tables.attach("ILP_ENTRY_TYPE").by_primary_id(type_id)
                
                student_ilp_record = $focus_student.ilp.new_record
                student_ilp_record.fields["ilp_entry_category_id"   ].set(category_id   )
                student_ilp_record.fields["ilp_entry_type_id"       ].set(type_id       )
                student_ilp_record.fields["description"             ].set(ilp_type_record.fields["default_description" ].value       )
                student_ilp_record.fields["solution"                ].set(ilp_type_record.fields["default_solution"    ].value       )
                student_ilp_record.save
                
            }
            
            $base.created_by = nil
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        
        output << "iframe                   {       float:right; display:none;}"
        
        output << "#new_row_button_STUDENT_ILP                       {       float:right; font-size: xx-small !important;}"
        
        output << "div#tabs_ilp .ui-tabs-nav {
            font-size: x-small;
        }"
        
        output << "div.related_classes_container                            {width: 600px; height: 100px; resize: none; overflow-y: scroll;}"
        output << "div.STUDENT_ILP__description                     textarea{width: 290px; height: 100px; resize: none; overflow-y: scroll;}"
        output << "div.STUDENT_ILP__solution                        textarea{width: 290px; height: 100px; resize: none; overflow-y: scroll;}"
        output << "div.STUDENT_ILP_RESPONSIBLE_PARTIES__completed      input{display: block; margin-left: auto; margin-right: auto;}"
        output << "div.STUDENT_ILP__pdf_excluded                            {text-align: center;}"
        output << "div.STUDENT_ILP__day1                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day2                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day3                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day4                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day5                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day6                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP__day7                                    {text-align: center; width: 30px;}"
        output << "div.STUDENT_ILP_RESPONSIBLE_PARTIES__responsibility      {width: 365px;}"
        output << "div.STUDENT_ILP_RESPONSIBLE_PARTIES__responsibility textarea{ clear: left; display: block; width: 350px; height: 100px; resize: none; overflow-y: scroll; float:left;}"
        
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