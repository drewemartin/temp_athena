#!/usr/local/bin/ruby

class TEP_AGREEMENTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
      
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        tep     = $focus_student.tep_agreement.existing_record
        add_new_button = $tools.button_new_row(
            table_name              = "STUDENT_TEP_AGREEMENT",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        ul_tep  = $tools.button_upload_doc( "tep_document", "sid" )
        dl_tep  = $tools.button_view_pdf(  "tep_document", "", additional_params_str = $focus_student.student_id.value, ["sid"])
        
        avail_button = tep ? "#{ul_tep}#{dl_tep}" : add_new_button
        
        "Truancy Prevention"+avail_button
        
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
            
        elsif $kit.params[:pdf_upload]
            
            @pdf     = $kit.params[:pdf_upload  ] != "" ? $kit.params[:pdf_upload   ] : false
            $focus_studentid     = $kit.params[:sidref      ] != "" ? $kit.params[:sidref       ] : false
            if @pdf && $focus_studentid
                save_student_document_tep
            else
                validation_check
            end
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record(sid = $kit.params[:sid])
        
        output  = String.new
        
        ########################################################################
        #FNORD - THIS NEEDS TO BE MOVED INTO THE GET_STUDENT_RECORD FUNCTION OF SUBMIT
        #SINCE IT NEEDS TO BE USED EVERY TIME A RECORD OS CREATED
        #if !$kit.params[:student_page_view]
        #    student = $students.attach(sid)
        #    $kit.modify_tag_content("tab_title-2", student.fullname.to_user, type="update")
        #    output << $tools.student_demographics(student)
        #end
        ########################################################################
        
        s       = $students.get(sid)
     
        if $focus_student.tep_agreement.existing_record
            
            #THE STUDENT'S MAIN TEP RECORD
            output << $tools.div_open("student_tep_agreement_container", "student_tep_agreement_container")
                
                output << $tools.legend_open("sub", "Documents")
                    
                    category_id = $tables.attach("document_category").find_field("primary_id",  "WHERE name='Truancy'").value
                    
                    type_id = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Truancy Elimination Plan' AND category_id='#{category_id}'").value
                    
                    if @doc_pids = $tables.attach("DOCUMENTS").document_pids(type_id, "STUDENT", "student_id", sid)
                        output << expand_documents(sid)
                        
                    else
                        output << "No Results Found."
                        
                    end
                    
                output << $tools.legend_close()
                
                output << $tools.div_open("required_info_container", "required_info_container")
                    
                    if !s.tep_agreement.conducted_by_team_id.value.nil?
                        record = $tables.attach("team").by_primary_id(s.tep_agreement.conducted_by_team_id.value)
                        first_name = record.fields["legal_first_name"].value
                        last_name = record.fields["legal_last_name"].value
                        staff_name = first_name + " " + last_name
                    else
                        staff_name = "Team Member Not Found"
                    end
                    
                    output << s.tep_agreement.conducted_by_team_id.set(staff_name).web.default(     :label_option=>"Conducted By:",   :disabled=>true)
                    output << s.tep_agreement.date_conducted.web.default(   :label_option=>"Conducted Date:")
                    output << s.tep_agreement.face_to_face.web.default(     :label_option=>"Face to Face:"  )
                    
                output << $tools.div_close()
                
                output << "<div style='padding:10px;clear:both;'><hr></div>"
                
                output << s.tep_agreement.goal.web.default(             :label_option=>"Goal:"          )
                output << s.tep_agreement.special_needs.web.default(    :label_option=>"Special Needs:" )
                
                existing_contacts = related_contacts(sid)
                output << existing_contacts if existing_contacts
                
            output << $tools.div_close()
            
            #output << $tools.legend_open("sub", "Absences and Reasons")
            #        
            #        if s.tep_absence_reasons.existing_records
            #            output << expand_absences(sid)
            #            
            #        else
            #            output << "No Results Found."
            #            
            #        end
            #        
            #output << $tools.legend_close()
            #EXPANDABLE LIST OF STUDENT'S ABSENCE REASONS
            tep_absence_records     = s.tep_absence_reasons.existing_records
            absence_reason_count    = tep_absence_records ? tep_absence_records.length : 0
            #add_new_absence_button  = $tools.button_new_row(table_name = "STUDENT_TEP_ABSENCE_REASONS", additional_params_str = "sid")
            output << $tools.expandable_section("Absences and Reasons",  absence_reason_count, arg = sid)
            
            #output << $tools.legend_open("sub", "Strengths")
            #        
            #        output << $tools.button_new_row(table_name = "STUDENT_TEP_STRENGTHS", additional_params_str = "sid")
            #        
            #        if s.tep_strengths.existing_records
            #            output << expand_strengths(sid)
            #            
            #        else
            #            output << "No Results Found."
            #            
            #        end
            #        
            #output << $tools.legend_close()
            #EXPANDABLE LIST OF STUDENT'S STRENGTHS
            tep_strengths_records   = s.tep_strengths.existing_records
            strengths_count         = tep_strengths_records ? tep_strengths_records.length : 0
            add_new_strength_button = $tools.button_new_row(table_name = "STUDENT_TEP_STRENGTHS", additional_params_str = "sid")
            output << $tools.expandable_section("Strengths"+add_new_strength_button,  strengths_count, arg = sid)
            
            #EXPANDABLE LIST OF STUDENT'S ASSESSMENTS AND SOLUTIONS
            tep_assessment_records      = s.tep_assessments.existing_records
            assessment_count            = tep_assessment_records ? tep_assessment_records.length : 0
            add_new_assessment_button   = $tools.button_new_row(table_name = "STUDENT_TEP_ASSESSMENTS", additional_params_str = "sid")
            output << $tools.expandable_section("Assessments and Solutions"+add_new_assessment_button,  assessment_count, arg = sid)
            
            how_to_button_tep_benefits_and_consequences = $tools.button_how_to("How To: TEP Benefits and Consequences")
            
            #EXPANDABLE LIST OF STUDENT'S BENEFITS FOR COMPLIANS AND CONSEQUENCES FOR NON COMPLIANCE
            tep_proncons_records        = s.tep_prosncons.existing_records
            prosncons_count             = tep_proncons_records ? tep_proncons_records.length : 0
            add_new_prosncons_button    = $tools.button_new_row(table_name = "STUDENT_TEP_PROSNCONS", additional_params_str = "sid")
            output << $tools.expandable_section("Benefits and Consequences #{how_to_button_tep_benefits_and_consequences}"+add_new_prosncons_button,  prosncons_count, arg = sid)
            
        else
            output << $tools.newlabel("no_record", "A TEP has not been created for this student.")
        end
        
        output << $tools.newlabel("bottom")
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def add_new_pdf_tep_document(sid)
        
        template = "TRUANCY_ELIMINATION_PLAN_PDF.rb"
        
        pdf = Prawn::Document.generate "#{$paths.htdocs_path}temp/tep_temp#{$ifilestamp}.pdf" do |pdf|
            require "#{$paths.templates_path}pdf_templates/#{template}"
            template = eval("#{template.gsub(".rb","")}.new")
            template.generate_pdf(sid, pdf)
        end
        
        #require "#{$paths.templates_path}pdf_templates/TRUANCY_ELIMINATION_PLAN_PDF.rb"
        #template = TRUANCY_ELIMINATION_PLAN_PDF.new
        #return template.generate_pdf(sid, pdf = nil)
        
        #filecontent = String.new
        #File.open(file_path, 'rb') do |file|
        #    filecontent = file.read
        #end
        #
        #return "#{filecontent}"
        
    end
    
    #def add_new_pdf_tep_document(sid)
    #    
    #    require "#{$paths.templates_path}pdf_templates/TRUANCY_ELIMINATION_PLAN_PDF.rb"
    #    template = TRUANCY_ELIMINATION_PLAN_PDF.new
    #    return template.generate_pdf(sid, pdf = nil).path
    # 
    #end
    
    #FNORD - Just leaving this in as an example - will delete later. 
    def add_new_pdf_district_notification(pid)
        
        #GENERATE DISTRICT NOTIFICATIONS
        require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
        template = DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new
        file_path= template.generate_pdf(pid, pdf = nil).path
        
        filecontent = String.new
        File.open(file_path, 'rb') do |file|
            filecontent = file.read
        end
        
        return filecontent
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________UPLOAD_PDF_FORMS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def upload_doc_tep_document(sid)
        
        output = String.new
        
        output << "<form id='doc_upload_form' name='form' action='D20130906.rb' method='POST' enctype='multipart/form-data' >"
        output << "<input id='sidref' name='sidref' value='#{sid}' type='hidden'>"
        output << $tools.document_upload2(self.class.name, "Truancy", "Truancy Elimination Plan", "doc_upload_form", "pdf")
        output << "</form>"
        
        return output
        
    end
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SAVE_STUDENT_DOCUMENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def save_student_document_tep
        
        file_path    = $paths.student_path($focus_studentid, "TEP")
        
        newPdf       = File.new("#{$paths.student_path($focus_studentid)}TEP/tep_agreement_#{$ifilestamp}.pdf", "wb")
        
        newPdf.write(@pdf)
        newPdf.close
        
        filepath = newPdf.path
        #$reports.move_to_athena_reports(filepath, false)
        
        doc_record = $tables.attach("STUDENT_DOCUMENTS").new_row
        doc_record.fields["student_id"   ].value = $focus_studentid
        doc_record.fields["document_type"].value = "TEP"
        doc_record.fields["document_name"].value = "TEP Agreement"
        doc_record.fields["document_path"].value = filepath
        doc_record.save
        
        $kit.output = "SUCCESS"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_student_tep_absence_reasons()
        
        output  = String.new
        
        fields  = $focus_student.tep_absence_reasons.new_record.fields
        
        output << $tools.div_open("student_tep_absence_reasons_container", "student_tep_absence_reasons_container")
            
            output << fields["student_id"   ].web.hidden()
            output << fields["att_date"     ].web.default( :label_option=>"School Day:",            :div_id=>"blank", :validate=>true   )
            output << fields["excused"      ].web.default( :label_option=>"Excused?",               :div_id=>"blank"                    )
            output << fields["reason"       ].web.default( :label_option=>"Reason for Absence:",    :div_id=>"blank", :validate=>true   )
            output << fields["agora_action" ].set("Kmail, Auto-Dialer, Family Coach Called").web.default( :label_option=>"Action Taken by Agora:", :div_id=>"blank", :validate=>true   )
            
        output << $tools.div_close()
        
        return output
    end
    
    def add_new_record_student_tep_agreement()
        
        output  = String.new
        
        fields  = $focus_student.tep_agreement.new_record.fields
        
        output << $tools.div_open("student_tep_agreement_container", "student_tep_agreement_container")
            
            output << $tools.div_open("required_info_container", "required_info_container")
                
                output << fields["conducted_by_team_id"     ].set($team_member.primary_id.value).web.hidden
                output << fields["date_conducted"   ].web.default(              :label_option=>"Conducted Date:"                    )
                output << fields["face_to_face"     ].web.default(              :label_option=>"Face to Face:"                      ) 
                output << fields["student_id"       ].web.hidden(                                                          )
                
            output << $tools.div_close()
            
            output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            fields["goal"].value = "#{$focus_student.studentfirstname.value} #{$focus_student.studentlastname.value} will increase attendance."
            output << fields["goal"             ].web.default( :label_option=>"Goal:",          :validate=>true )
            output << fields["special_needs"    ].web.default( :label_option=>"Special Needs:"                  )  
            
        output << $tools.div_close()
        
        return output
    end
    
    def add_new_record_student_tep_assessments()
        
        output  = String.new
        
        fields  = $focus_student.tep_assessments.new_record.fields
        
        output << $tools.div_open("student_tep_assessments_container", "student_tep_assessments_container")
            
            output << fields["student_id"         ].web.hidden()
            
            output << fields["description"        ].web.default( :label_option=>"Description:",         :div_id=>"blank", :validate=>true)
            output << fields["solution"           ].web.default( :label_option=>"Solution:",            :div_id=>"blank", :validate=>true)
            output << fields["responsible_parties"].web.default( :label_option=>"Responsible Parties:", :div_id=>"blank", :validate=>true)
            output << fields["completion_date"    ].web.default( :label_option=>"Completion Date:",     :div_id=>"blank", :validate=>true)
            #
            #output << fields["description"        ].web.default( :label_option=>"Description:",         :div_id=>"blank", :validate=>true)
            #output << fields["solution"           ].web.default( :label_option=>"Solution:",            :div_id=>"blank", :validate=>true)
            #output << fields["responsible_parties"].web.default( :label_option=>"Responsible Parties:", :div_id=>"blank", :validate=>true)
            #output << fields["completion_date"    ].web.default( :label_option=>"Completion Date:",     :div_id=>"blank", :validate=>true)
            
        output << $tools.div_close()
        
        return output
    end
    
    def add_new_record_student_tep_strengths()
        
        output  = String.new
        
        fields  = $focus_student.tep_strengths.new_record.fields
        
        output << $tools.div_open("student_tep_strengths_container", "student_tep_strengths_container")
            
            output << fields["student_id"   ].web.hidden()
            output << fields["description"  ].web.default( :label_option=>"Description:",   :validate=>true )
            output << fields["relevance"    ].web.default( :label_option=>"Relevance:",     :validate=>true )
            
            #output << fields["description"  ].web.default( :label_option=>"Description:",   :validate=>true )
            #output << fields["relevance"    ].web.default( :label_option=>"Relevance:",     :validate=>true )
            #
            #output << fields["description"  ].web.default( :label_option=>"Description:",   :validate=>true )
            #output << fields["relevance"    ].web.default( :label_option=>"Relevance:",     :validate=>true )
            #
            #output << fields["description"  ].web.default( :label_option=>"Description:",   :validate=>true )
            #output << fields["relevance"    ].web.default( :label_option=>"Relevance:",     :validate=>true )
            
        output << $tools.div_close()
        
        return output
    end
    
    def add_new_record_student_tep_prosncons()
        
        output  = String.new
        
        fields  = $focus_student.tep_prosncons.new_record.fields
        
        output << $tools.div_open("student_tep_prosncons_container", "student_tep_prosncons_container")
            
            output << fields["student_id"   ].web.hidden(                          )
            output << fields["type"         ].web.select(  {:label_option=>"Type:", :div_id=>"blank", :validate=>true, :dd_choices=>pnc_type_dd}, true  )
            output << fields["description"  ].web.default( :label_option=>"Description:", :validate=>true                                               )

            #output << fields["type"         ].web.select(  {:label_option=>"Type:", :div_id=>"blank", :validate=>true, :dd_choices=>pnc_type_dd}, true  )
            #output << fields["description"  ].web.default( :label_option=>"Description:", :validate=>true                                               )
            #
            #output << fields["type"         ].web.select(  {:label_option=>"Type:", :div_id=>"blank", :validate=>true, :dd_choices=>pnc_type_dd}, true  )
            #output << fields["description"  ].web.default( :label_option=>"Description:", :validate=>true                                               )
            #
            #output << fields["type"         ].web.select(  {:label_option=>"Type:", :div_id=>"blank", :validate=>true, :dd_choices=>pnc_type_dd}, true  )
            #output << fields["description"  ].web.default( :label_option=>"Description:", :validate=>true                                               )
            
            
        output << $tools.div_close()
        
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def expand_absences(sid)
        
        tables_array = [
            
            #HEADERS
            ["School Day","Excused?","Reason for Absence","Action Taken by Agora"]
            
        ]
        
        pids    = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").primary_ids("WHERE student_id = #{sid} ORDER BY att_date ASC")
        pids.each{|pid|
            
            record = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").by_primary_id(pid)
            
            row = Array.new
            row.push(record.fields["att_date"     ].to_user)
            row.push(record.fields["excused"      ].web.default(:disabled=>true))
            row.push(record.fields["reason"       ].web.default())
            row.push(record.fields["agora_action" ].web.default())
            tables_array.push(row)
            
        }
        
       return $kit.tools.data_table(tables_array, "absences")
        
    end
    
    def expand_assessments(sid)
        
        tables_array = [
            
            #HEADERS
            ["Description","Solution","Responsible Parties","Completetion Date"]
            
        ]
        
        records = $students.get(sid).tep_assessments.existing_records
        records.each{|record|
            
            row = Array.new
            row.push(record.fields["description"        ].web.default())
            row.push(record.fields["solution"           ].web.default())
            row.push(record.fields["responsible_parties"].web.default())
            row.push(record.fields["completion_date"    ].web.default())
            tables_array.push(row)
            
        }
        
       return $kit.tools.data_table(tables_array, "assessments")
        
    end
    
    def expand_benefits(sid)
        
        tables_array = [
            
            #HEADERS
            ["Description","Type"]
            
        ]
        
        records = $students.get(sid).tep_prosncons.existing_records
        records.each{|record|
            
            row = Array.new
            row.push(record.fields["description"    ].web.default())
            row.push(record.fields["type"           ].web.select(  {:label_option=>"Type:", :div_id=>"blank", :validate=>true, :dd_choices=>pnc_type_dd}, true  ))
            tables_array.push(row)
            
        }
        
       return $kit.tools.data_table(tables_array, "prosncons")
        
    end
    
    def expand_documents(sid)
        
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
        
        output << $kit.tools.data_table(tables_array, "tep_documents")
        output << "</div>"
        
        return output
        
    end
    
    def expand_strengths(sid)
        
        tables_array = [
            
            #HEADERS
            ["Description","Relevance to TEP"]
            
        ]
        
        records = $students.get(sid).tep_strengths.existing_records
        records.each{|record|
            
            row = Array.new
            row.push(record.fields["description"  ].web.default())
            row.push(record.fields["relevance"    ].web.default())
            tables_array.push(row)
            
        }
        
       return $kit.tools.data_table(tables_array, "strengths")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def pnc_type_dd
        return [
            {:name=>"Benefit",    :value=>"Benefit"          },
            {:name=>"Consequence", :value=>"Consequence" }
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def validation_check
        validation_string = "You did not:<br>"
        validation_string << "Choose a pdf file.<br>" if !@pdf
        validation_string = "No sid error. How did this happen?!<br>" if !$focus_studentid
        $kit.output = validation_string
    end
        
    def related_contacts(sid)
        
        pids   = $tables.attach("student_contacts").primary_ids("WHERE student_id = '#{sid}' and (tep_initial IS TRUE OR tep_followup IS TRUE)")
        
        if pids
            
            output = String.new
            
            output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            tables_array = [
                
                #HEADERS
                [
                    "Date & Time",
                    "Successful?",
                    "Notes",
                    "Type",
                    "TEP Initial",
                    "TEP Followup",
                    "RTII Behavior",
                    "Test Sites",
                    "Scantron Performance",
                    "Study Island",
                    "Course Progress",
                    "Work Submission",
                    "Grades",
                    "Communications",
                    "Retention Risk",
                    "Escalation",
                    "Welcome Call",
                    "Initial Face-to-Face",
                    "Other",
                    "Details (if 'other')"
                ]
                
            ]
            
            pids.each{|pid|
                
                record = $tables.attach("student_contacts").by_primary_id(pid)
                
                f = record.fields
                
                row = Array.new
                ########################################################################
                #FNORD - MOVE THE 'DISPLAY:NONE' DIV INTO WEB AS AN OPTION
                row.push(f["datetime"                 ].to_user)
                row.push(f["successful"               ].to_user)
                row.push(f["notes"                    ].to_user)
                row.push(f["contact_type"             ].to_user) 
                row.push(f["tep_initial"              ].to_user)
                row.push(f["tep_followup"             ].to_user)
                row.push(f["rtii_behavior_id"         ].to_user)
                row.push(f["test_site_selection"      ].to_user)
                row.push(f["scantron_performance"     ].to_user)
                row.push(f["study_island_assessments" ].to_user)
                row.push(f["course_progress"          ].to_user)
                row.push(f["work_submission"          ].to_user)
                row.push(f["grades"                   ].to_user)
                row.push(f["communications"           ].to_user)
                row.push(f["retention_risk"           ].to_user)
                row.push(f["escalation"               ].to_user)
                row.push(f["welcome_call"             ].to_user)
                row.push(f["initial_home_visit"       ].to_user)
                row.push(f["other"                    ].to_user)
                row.push(f["other_description"        ].to_user)
                
                tables_array.push(row)
                
            }
            
            output << $tools.newlabel("related_contacts", "Related Contacts")
            
            output << $tools.data_table(tables_array, "contacts")
            
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
            
            div.student_tep_agreement_container                             {       width:100%; margin-left:auto; margin-right:auto; clear:left;}
                
                #new_row_button_STUDENT_TEP_AGREEMENT                       {       float:right; font-size: xx-small !important;}
                
                div.required_info_container                                 {       background-color:red; margin-top:20px; margin-left:4px; margin-right:auto;}
                
                div.STUDENT_TEP_AGREEMENT__conducted_by_team_id             {       width:318px; float:left; margin-right:10px;}
                div.STUDENT_TEP_AGREEMENT__date_conducted                   {       width:335px; float:left;}
                div.STUDENT_TEP_AGREEMENT__face_to_face                     {       width:125px; float:left; margin-left:10px;}
                div.STUDENT_TEP_AGREEMENT__goal                             {       float:left; width:48%; margin:4px; padding-right:1%; clear:left;}
                div.STUDENT_TEP_AGREEMENT__special_needs                    {       float:left; width:48%; margin:4px; padding-bottom:1%;}
             
                div.STUDENT_TEP_AGREEMENT__conducted_by_team_id        label{       width:103px; display:inline-block;}
                div.STUDENT_TEP_AGREEMENT__date_conducted              label{       width:120px; display:inline-block;}
                div.STUDENT_TEP_AGREEMENT__face_to_face                label{       width:95px; display:inline-block;}
                div.STUDENT_TEP_AGREEMENT__goal                        label{       width:210px; display:inline-block;}
                div.STUDENT_TEP_AGREEMENT__special_needs               label{       width:210px; display:inline-block;}
                
                div.STUDENT_TEP_AGREEMENT__conducted_by_team_id        input{       width:210px;}
                div.STUDENT_TEP_AGREEMENT__date_conducted              input{       width:210px;}
                div.STUDENT_TEP_AGREEMENT__face_to_face                input{       }
                div.STUDENT_TEP_AGREEMENT__goal                     textarea{       width:100%; height: 100%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_AGREEMENT__special_needs            textarea{       width:100%; height: 100%; overflow-y: scroll; resize: none;}
             
            div.student_tep_absence_reasons_container                       {       width:100%; margin-left:auto; margin-right:auto; height:85px;}
              
                #new_row_button_STUDENT_TEP_ABSENCE_REASONS                 {       float:right; font-size: xx-small !important;}
                
                div#blank.STUDENT_TEP_ABSENCE_REASONS__att_date             {       float:left; clear:left; width:210px; margin-top: 24px;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__excused              {       float:left; clear:left; width:100px; margin-top: 10px; margin-left: 80px;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__reason               {       position:absolute; position: absolute; right:468px; top:10px; width:450px;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__agora_action         {       position:absolute; position: absolute; right:15px; top:10px; width:450px;}
                
                div#blank.STUDENT_TEP_ABSENCE_REASONS__att_date        input{       width:114px;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__excused         input{       float:left;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__reason       textarea{       width:96%; overflow-y: scroll; resize: none;}
                div#blank.STUDENT_TEP_ABSENCE_REASONS__agora_action textarea{       width:96%; overflow-y: scroll; resize: none;}
                
                div.STUDENT_TEP_ABSENCE_REASONS__reason             textarea{       width:100%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_ABSENCE_REASONS__agora_action       textarea{       width:100%; overflow-y: scroll; resize: none;}
                
            div.student_tep_strengths_container                             {       width:900px; margin-left:auto; margin-right:auto; clear:left;}    
                
                #new_row_button_STUDENT_TEP_STRENGTHS                       {       float:right; font-size: xx-small !important;}
                
                div.STUDENT_TEP_STRENGTHS__description                      {       float:left; width:450px; clear:left;}
                div.STUDENT_TEP_STRENGTHS__relevance                        {       float:left; width:450px;}
                div.STUDENT_TEP_STRENGTHS__description              textarea{       width:97%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_STRENGTHS__relevance                textarea{       width:97%; overflow-y: scroll; resize: none;}
                
            div.student_tep_assessments_container                           {       width:100%; margin-left:auto; margin-right:auto; clear:left; display:inline-block; margin-top:10px;}    
                
                #new_row_button_STUDENT_TEP_ASSESSMENTS                     {       float:right; font-size: xx-small !important;}
                #new_pdf_button                                             {       margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}
                #upload_pdf_button                                          {       margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}
                #upload_doc_button                                          {       margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}

                div#blank.STUDENT_TEP_ASSESSMENTS__description                    {       width:31%; float:left; margin-bottom: 10px; margin-left: 20px; clear:left;}
                div#blank.STUDENT_TEP_ASSESSMENTS__solution                       {       width:31%; float:left; margin-bottom: 10px; margin-left: 20px; }
                div#blank.STUDENT_TEP_ASSESSMENTS__responsible_parties            {       width:31%; float:left; margin-bottom: 10px; margin-left: 20px; }
                div#blank.STUDENT_TEP_ASSESSMENTS__completion_date                {       float:left; clear:left;margin-bottom: 20px; margin-left: 20px;}
                
                div.STUDENT_TEP_ASSESSMENTS__description               label{       display:inline-block; width:100%;}
                div.STUDENT_TEP_ASSESSMENTS__solution                  label{       display:inline-block; width:100%;}
                div.STUDENT_TEP_ASSESSMENTS__responsible_parties       label{       display:inline-block; width:100%;}
                div.STUDENT_TEP_ASSESSMENTS__completion_date           label{       display:inline-block;}
                
                div.STUDENT_TEP_ASSESSMENTS__description            textarea{        width:96%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_ASSESSMENTS__solution               textarea{        width:96%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_ASSESSMENTS__responsible_parties    textarea{        width:96%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_ASSESSMENTS__completion_date           input{       }
                
            div.student_tep_prosncons_container                             {       width:100%; margin-left:auto; margin-right:auto; clear:left;}    
                
                #new_row_button_STUDENT_TEP_PROSNCONS                       {       float:right; font-size: xx-small !important;}
                
                div#blank.STUDENT_TEP_PROSNCONS__type                       {       float:right;}
                div.STUDENT_TEP_PROSNCONS__description                      {       float:left;  width:100%; margin-bottom: 30px;}
                
                div.STUDENT_TEP_PROSNCONS__description              textarea{       width:99%; overflow-y: scroll; resize: none;}
                div.STUDENT_TEP_PROSNCONS__type                        input{       width:100%; overflow-y: scroll; resize: none;} 
                
                div.STUDENT_TEP_PROSNCONS__type                     textarea{       float:left;  width:100%;}
                
            label.related_contacts{ font-size       : large;}
            div.related_contacts{   margin-bottom   : 15px; }
            iframe{float:right; display:none;}
            
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