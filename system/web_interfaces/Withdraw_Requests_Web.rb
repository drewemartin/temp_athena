#!/usr/local/bin/ruby

class WITHDRAW_REQUESTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        @processors = [
            "epagan@agora.org",
            "sfields@agora.org",
            "kyoung@agora.org",
            "smcdonnell@agora.org",
            "esaddler@agora.org",
            "drowan@agora.org"
        ]
        
        @school_wide_results = @processors.include?($kit.user)
    end
    #---------------------------------------------------------------------------
    
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
    
    def page_title
        
        sid     = $focus_student.student_id.value
        student = $students.attach(sid)
        
        if $students.list({:active=>true, :student_id=>sid})
            addNewOK = true
            if withdraws = $tables.attach("Withdrawing").by_studentid_old(sid)
                withdraws.each do |withdraw|
                    fields = withdraw.fields
                    if fields["status"].value == "Requested" || fields["status"].value == "Processed"
                        addNewOK = false
                        break
                    end
                end
            end
        else
            addNewOK = false
        end
        
        how_to_button = $tools.button_how_to("How To: Withdrawal Requests")
        add_new_button = $tools.button_new_row(table_name = "Withdrawing", additional_params_str = "sid") if addNewOK
        
        "Withdraw Requests #{how_to_button}#{add_new_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        output = String.new
        
        #RETRACT WARNING DIALOG
        output << "<div id='retract_withdraw' title='Retract Withdrawal?'>"
        output << "<p><span class='ui-icon ui-icon-alert' style='float:left; margin:0 7px 20px 0;'></span>"
        output << "Do you really want to retract this withdraw request?<br>"
        output << "This action <b>can not</b> be undone!</p>"
        output << "</div>"
        
        #RESCIND WARNING DIALOG
        output << "<div id='rescind_withdraw' title='Rescind Withdrawal?'>"
        output << "<p><span class='ui-icon ui-icon-alert' style='float:left; margin:0 7px 20px 0;'></span>"
        output << "Do you really want to rescind this withdraw request?<br>"
        output << "This action <b>can not</b> be undone!</p>"
        output << "</div>"
        
        if withdraws = $tables.attach("Withdrawing").by_studentid_old($focus_student.student_id.value)
            withdraws.each do |withdraw|
                
                pid     = withdraw.primary_id
                
                title   = "Withdrawal Record"
                title   << $tools.newlabel("status", "Status: #{withdraw.fields["status"].value}")
                
                output  << $tools.expandable_section(title, 1, arg = pid)
            end
        else
            
            output << $tools.newlabel("no_record", "This student does not have any withdrawal records.")
            
        end
        output << $tools.newlabel("bottom")
        return output
        
    end
    
    def working_list
        
        output = Array.new
        
        output.push(
            :name       => "MyWithdrawals",
            :content    => my_withdrawing_students
            
        )
        
        return output
       
    end

    def my_withdrawing_students
        
        output = ""
        output << $tools.tab_identifier(2)
        
        eligible_students = $team_member.assigned_students(:withdrawing_eligible=>true, :school_wide=>@school_wide_results)
        eligible_students_length = eligible_students ? eligible_students.length : 0
        output << $tools.expandable_section("Eligible",     eligible_students_length)
        
        pending_students = $team_member.assigned_students(:withdrawing_pending=>true, :school_wide=>@school_wide_results)
        pending_students_length = pending_students ? pending_students.length : 0
        output << $tools.expandable_section("Pending",     pending_students_length)
        
        processed_students = $team_member.assigned_students(:withdrawing_processed=>true, :school_wide=>@school_wide_results)
        processed_students_length = processed_students ? processed_students.length : 0
        output << $tools.expandable_section("Processed",     processed_students_length)
        
        completed_students = $team_member.assigned_students(:withdrawing_completed=>true, :school_wide=>@school_wide_results)
        completed_students_length = completed_students ? completed_students.length : 0
        output << $tools.expandable_section("Completed",     completed_students_length)
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    #FNORD - Just leaving this in as an example - will delete later. 
    #def add_new_pdf_district_notification(pid)
    #    
    #    #GENERATE DISTRICT NOTIFICATIONS
    #    require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #    template = DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new
    #    file_path= template.generate_pdf(pid, pdf = nil).path
    #    
    #    filecontent = String.new
    #    File.open(file_path, 'rb') do |file|
    #        filecontent = file.read
    #    end
    #    
    #    return "#{filecontent}"
    #    
    #end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_withdrawing()
        output   = String.new
        
        fields  = $tables.attach("Withdrawing").new_row.fields
        
        fields["status"].value = "Requested"
        fields["type"  ].value = "User Initiated"
        
        output << fields["student_id"           ].set($focus_student.student_id.value).web.hidden()
        output << fields["status"               ].web.hidden()
        output << $tools.legend_open("initator_info", "Initiator Information")
        output << $tools.div_open("initiator_container", "initiator_container")
        output << fields["initiated_date"       ].web.datetime( :label_option=>"Initiated Date:",                                           :validate=>true)
        output << fields["type"                 ].web.text(     :label_option=>"Type:",             :dd_choices=>type_dd, :readonly=>true)
        output << fields["initiator"            ].web.text(     :label_option=>"Initiator:",                                                :validate=>true)
        output << fields["method"               ].web.select(   :label_option=>"Method:",           :dd_choices=>method_dd,                 :validate=>true)
        output << fields["relationship"         ].web.select(   :label_option=>"Relationship:",     :dd_choices=>relationship_dd,           :validate=>true)
        output << $tools.div_close()
        output << $tools.legend_close()
        output << $tools.div_open("other_container", "other_container")
        output << fields["k12_reason"           ].web.select(   :label_option=>"K12 Reason:",       :dd_choices=>k12_reson_dd("2015-01-01"),:validate=>true)
        output << fields["agora_reason"         ].web.select(   :label_option=>"Agora Reason:",     :dd_choices=>agora_reson_dd,            :validate=>true)
        output << fields["transferring_school"  ].web.text(     :label_option=>"Transferring School:")
        output << fields["effective_date"       ].web.date(     :label_option=>"Effective Date:",                                           :validate=>true)
        output << fields["comments"             ].web.textarea( :label_option=>"Comments:")
        output << $tools.newlabel("required_message", "\"*\" indicates a required field")
        output << $tools.div_close()
        
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def expand_completed
        $tools.student_links($team_member.assigned_students(:withdrawing_completed=>true, :school_wide=>@school_wide_results))
    end
    
    def expand_eligible
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID"              ,
                "First Name"              ,
                "Last Name"               ,
                "student_age"             ,
                "initiated_date"          ,
                "initiator"               ,
                "relationship"            ,
                "method"                  ,
                "agora_reason"            ,
                "k12_reason"              ,
                "type"                    ,
                "ftc_action"              ,
                "comments"                ,
                "transferring_school"     ,
                "grades_documented"       ,
                "status"                  ,
                "processed"               ,
                "retracted"               ,
                "rescinded"               ,
                "truancy_dates"           ,
                "ftc_notified_date"       ,
                "effective_date"          ,
                "eligible_date"           ,
                "processed_date"          ,
                "completed_date"          ,
                "rescinded_date"          ,
                "sapphire_reported_date"  ,
                "parent_notify_date"      ,
                "district_notify_date"    ,
                "source"                  
            ]
            
        ]
        
        pids = $tables.attach("WITHDRAWING").primary_ids(
            "WHERE eligible_date <= CURDATE()
            AND completed_date IS NULL
            AND (processed IS FALSE || processed IS NULL)
            AND (retracted IS FALSE || retracted IS NULL)
            ORDER BY `effective_date` DESC"
        )
        pids.each{|pid|
            
            record = $tables.attach("WITHDRAWING").by_primary_id(pid)
            
            row = Array.new
            
            sid    = record.fields["student_id"                  ].value
            row.push(sid)
            row.push($students.get(sid).studentfirstname.value           )
            row.push($students.get(sid).studentlastname.value            )           
            row.push(record.fields["student_age"                 ].value )          
            row.push(record.fields["initiated_date"              ].value )       
            row.push(record.fields["initiator"                   ].value )            
            row.push(record.fields["relationship"                ].value )         
            row.push(record.fields["method"                      ].value )               
            row.push(record.fields["agora_reason"                ].value )         
            row.push(record.fields["k12_reason"                  ].value )           
            row.push(record.fields["type"                        ].value )                 
            row.push(record.fields["ftc_action"                  ].value )           
            row.push(record.fields["comments"                    ].value )             
            row.push(record.fields["transferring_school"         ].value )  
            row.push(record.fields["grades_documented"           ].value )    
            row.push(record.fields["status"                      ].value )               
            row.push(record.fields["processed"                   ].value )            
            row.push(record.fields["retracted"                   ].value )            
            row.push(record.fields["rescinded"                   ].value )            
            row.push(record.fields["truancy_dates"               ].value )        
            row.push(record.fields["ftc_notified_date"           ].value )    
            row.push(record.fields["effective_date"              ].value )       
            row.push(record.fields["eligible_date"               ].value )        
            row.push(record.fields["processed_date"              ].value )       
            row.push(record.fields["completed_date"              ].value )       
            row.push(record.fields["rescinded_date"              ].value )       
            row.push(record.fields["sapphire_reported_date"      ].value )
            row.push(record.fields["parent_notify_date"          ].value )   
            row.push(record.fields["district_notify_date"        ].value ) 
            row.push(record.fields["source"                      ].value )
            
            tables_array.push(row)
            
        } if pids
        
       return $kit.tools.data_table(tables_array, "eligible")
        
    end
    
    def expand_pending
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID"              ,
                "First Name"              ,
                "Last Name"               ,
                "student_age"             ,
                "initiated_date"          ,
                "initiator"               ,
                "relationship"            ,
                "method"                  ,
                "agora_reason"            ,
                "k12_reason"              ,
                "type"                    ,
                "ftc_action"              ,
                "comments"                ,
                "transferring_school"     ,
                "grades_documented"       ,
                "status"                  ,
                "processed"               ,
                "retracted"               ,
                "rescinded"               ,
                "truancy_dates"           ,
                "ftc_notified_date"       ,
                "effective_date"          ,
                "eligible_date"           ,
                "processed_date"          ,
                "completed_date"          ,
                "rescinded_date"          ,
                "sapphire_reported_date"  ,
                "parent_notify_date"      ,
                "district_notify_date"    ,
                "source"                  
            ]
            
        ]
        sids = $team_member.assigned_students(:withdrawing_pending=>true, :school_wide=>@school_wide_results)
        sids.each{|sid|
            
            record = $tables.attach("WITHDRAWING").by_studentid(sid)
            
            row = Array.new
            
            row.push(sid)
            row.push($students.get(sid).studentfirstname.value           )
            row.push($students.get(sid).studentlastname.value            )           
            row.push(record.fields["student_age"                 ].value )          
            row.push(record.fields["initiated_date"              ].value )       
            row.push(record.fields["initiator"                   ].value )            
            row.push(record.fields["relationship"                ].value )         
            row.push(record.fields["method"                      ].value )               
            row.push(record.fields["agora_reason"                ].value )         
            row.push(record.fields["k12_reason"                  ].value )           
            row.push(record.fields["type"                        ].value )                 
            row.push(record.fields["ftc_action"                  ].value )           
            row.push(record.fields["comments"                    ].value )             
            row.push(record.fields["transferring_school"         ].value )  
            row.push(record.fields["grades_documented"           ].value )    
            row.push(record.fields["status"                      ].value )               
            row.push(record.fields["processed"                   ].value )            
            row.push(record.fields["retracted"                   ].value )            
            row.push(record.fields["rescinded"                   ].value )            
            row.push(record.fields["truancy_dates"               ].value )        
            row.push(record.fields["ftc_notified_date"           ].value )    
            row.push(record.fields["effective_date"              ].value )       
            row.push(record.fields["eligible_date"               ].value )        
            row.push(record.fields["processed_date"              ].value )       
            row.push(record.fields["completed_date"              ].value )       
            row.push(record.fields["rescinded_date"              ].value )       
            row.push(record.fields["sapphire_reported_date"      ].value )
            row.push(record.fields["parent_notify_date"          ].value )   
            row.push(record.fields["district_notify_date"        ].value ) 
            row.push(record.fields["source"                      ].value )
            
            tables_array.push(row)
            
        } if sids
        
       return $kit.tools.data_table(tables_array, "pending")
        
    end
    
    def expand_processed
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID"              ,
                "First Name"              ,
                "Last Name"               ,
                "student_age"             ,
                "initiated_date"          ,
                "initiator"               ,
                "relationship"            ,
                "method"                  ,
                "agora_reason"            ,
                "k12_reason"              ,
                "type"                    ,
                "ftc_action"              ,
                "comments"                ,
                "transferring_school"     ,
                "grades_documented"       ,
                "status"                  ,
                "processed"               ,
                "retracted"               ,
                "rescinded"               ,
                "truancy_dates"           ,
                "ftc_notified_date"       ,
                "effective_date"          ,
                "eligible_date"           ,
                "processed_date"          ,
                "completed_date"          ,
                "rescinded_date"          ,
                "sapphire_reported_date"  ,
                "parent_notify_date"      ,
                "district_notify_date"    ,
                "source"                  
            ]
            
        ]
        
        sids = $team_member.assigned_students(:withdrawing_pending=>true, :school_wide=>@school_wide_results)
        sids.each{|sid|
            
            record = $tables.attach("WITHDRAWING").by_studentid(sid)
            
            row = Array.new
            
            row.push(sid)
            row.push($students.get(sid).studentfirstname.value           )
            row.push($students.get(sid).studentlastname.value            )           
            row.push(record.fields["student_age"                 ].value )          
            row.push(record.fields["initiated_date"              ].value )       
            row.push(record.fields["initiator"                   ].value )            
            row.push(record.fields["relationship"                ].value )         
            row.push(record.fields["method"                      ].value )               
            row.push(record.fields["agora_reason"                ].value )         
            row.push(record.fields["k12_reason"                  ].value )           
            row.push(record.fields["type"                        ].value )                 
            row.push(record.fields["ftc_action"                  ].value )           
            row.push(record.fields["comments"                    ].value )             
            row.push(record.fields["transferring_school"         ].value )  
            row.push(record.fields["grades_documented"           ].value )    
            row.push(record.fields["status"                      ].value )               
            row.push(record.fields["processed"                   ].value )            
            row.push(record.fields["retracted"                   ].value )            
            row.push(record.fields["rescinded"                   ].value )            
            row.push(record.fields["truancy_dates"               ].value )        
            row.push(record.fields["ftc_notified_date"           ].value )    
            row.push(record.fields["effective_date"              ].value )       
            row.push(record.fields["eligible_date"               ].value )        
            row.push(record.fields["processed_date"              ].value )       
            row.push(record.fields["completed_date"              ].value )       
            row.push(record.fields["rescinded_date"              ].value )       
            row.push(record.fields["sapphire_reported_date"      ].value )
            row.push(record.fields["parent_notify_date"          ].value )   
            row.push(record.fields["district_notify_date"        ].value ) 
            row.push(record.fields["source"                      ].value )
            
            tables_array.push(row)
            
        } if sids
        
        return $kit.tools.data_table(tables_array, "pending")
        
    end
    
    def expand_withdrawal(pid)
        record  = $tables.attach("Withdrawing").by_primary_id(pid)
        created_date = record.fields["created_date"].value
        output  = ""
        output << "<div class='form'>"
        fields  = record.fields
        status  = fields["status"       ].value
        sid     = fields["student_id"   ].value
        if status == "Processed" || status == "Completed" || status == "Withdrawn"
            disabled = true
        else
            disabled = false
        end
        
        if status == "Completed" || status == "Withdrawn"
            processed_disabled = true
        elsif @processors.include?($kit.user)
           processed_disabled = false 
        else
            processed_disabled = true
        end
        
        ########################################################################
        #DOCUMENTS RELATED TO THIS WITHDRAWAL REQUEST
        output << $tools.legend_open("sub", "Documents")
            
            category_id = $tables.attach("document_category").find_field("primary_id", "WHERE name='Withdrawals'").value
            
            docs = false
            dn_type = $tables.attach("document_type").find_field("primary_id",  "WHERE name='District Withdrawal Notification' AND category_id='#{category_id}'").value
            fg_type = $tables.attach("document_type").find_field("primary_id",  "WHERE name='Final Grades' AND category_id='#{category_id}'").value
            dn_pids = $tables.attach("DOCUMENTS").document_pids(dn_type, "WITHDRAWING", "primary_id", pid) || []
            fg_pids = $tables.attach("DOCUMENTS").document_pids(fg_type, "WITHDRAWING", "primary_id", pid) || []
            
            if @doc_pids = dn_pids+fg_pids
                
                output << expand_documents
                
            else
                
                output << "No Results Found."
                
            end
            
        output << $tools.legend_close()
        ########################################################################
        
        output << $tools.legend_open("sub", "Initiator Information")
        output << $tools.div_open("initiator_container", "initiator_container")
        output << fields["initiated_date"     ].web.datetime(        :label_option=>"Initiated Date:",       :disabled=>disabled,                                        :validate=>true)
        output << fields["type"               ].web.text(            :label_option=>"Type:",                 :disabled=>true)
        output << fields["initiator"          ].web.text(            :label_option=>"Initiator:",            :disabled=>disabled,                                        :validate=>true)
        output << fields["method"             ].web.select({         :label_option=>"Method:",               :disabled=>disabled,    :dd_choices=>method_dd,             :validate=>true}, true)
        output << fields["relationship"       ].web.select({         :label_option=>"Relationship:",         :disabled=>disabled,    :dd_choices=>relationship_dd,       :validate=>true}, true)
        output << $tools.div_close()
        output << $tools.legend_close()
        output << $tools.div_open("other_container", "other_container")
        output << fields["k12_reason"         ].web.select({         :label_option=>"K12 Reason:",           :disabled=>disabled,    :dd_choices=>k12_reson_dd(created_date),          :validate=>true}, true)
        output << fields["agora_reason"       ].web.select({         :label_option=>"Agora Reason:",         :disabled=>disabled,    :dd_choices=>agora_reson_dd,        :validate=>true}, true)
        output << fields["ftc_action"         ].web.text(            :label_option=>"FTC Action:",           :disabled=>disabled)
        output << fields["transferring_school"].web.text(            :label_option=>"Transferring School:",  :disabled=>disabled)
        output << fields["effective_date"     ].web.date(            :label_option=>"Effective Date:",       :disabled=>disabled,                                        :validate=>true)
        output << fields["comments"           ].web.textarea(        :label_option=>"Comments:",             :disabled=>disabled)
        output << $tools.div_open("left_column", "left_column")
        output << fields["processed"          ].web.checkbox(        :label_option=>"Processed?",            :disabled=>processed_disabled)
        output << fields["status"             ].web.label(           :label_option=>"Status:")
        retracted = fields["retracted"        ].value
        output << $tools.newlabel("retracted_status", "Retracted?:")
        if retracted
            output << $tools.newlabel("retracted_answer", "Yes")
        else
            output << $tools.newlabel("retracted_answer", "No")
        end
        
        output << fields["ftc_notified_date"   ].to_user!.web.label( :label_option=>"FTC Initial Notification Date:")
        output << fields["eligible_date"       ].to_user!.web.label( :label_option=>"Eligible Date:")
        output << fields["processed_date"      ].to_user!.web.label( :label_option=>"Processed Date:")
        output << fields["completed_date"      ].to_user!.web.label( :label_option=>"Completed Date:")
        output << fields["rescinded_date"      ].to_user!.web.label( :label_option=>"Rescinded Date:")
        output << fields["parent_notify_date"  ].to_user!.web.label( :label_option=>"Parent Notification Generated On:")
        output << fields["district_notify_date"].to_user!.web.label( :label_option=>"District Notification Generated On:")
        cd = fields["created_date"].to_user
        cb = fields["created_by"].value
        output << "<div class='created'>Record Generated By #{cb} on #{cd}.</div>"
        output << $tools.div_close()
        output << truancy_dates(fields["truancy_dates"].value)
        if (!disabled || @processors.include?($kit.user)) && (fields["processed"].is_false? || !fields["processed"].value) && fields["completed_date"].value == ""
            retract_id = fields["retracted"].web.field_id
            output << "<div class='retract_button' id='#{retract_id}__button'>Retract Withdrawal</div>"
            output << fields["retracted"].web.checkbox(             :display=>true)
        end
        if @processors.include?($kit.user)
            if fields["processed"].is_true? && (fields["rescinded"].is_false? || !fields["rescinded"].value)
                rescind_id = fields["rescinded"].web.field_id
                output << "<div class='rescind_button' id='#{rescind_id}__button'>Rescind Withdrawal</div>"
                output << fields["rescinded"].web.checkbox(             :display=>true)
            end
        end
        
        output << $tools.newlabel("required_message", "\"*\" indicates a required field")
        output << $tools.div_close()
        output << $tools.newlabel("bottom")
        output << "</div>"
        
        return output
    end
    
    def expand_documents
        
        output = "<div style='width:990px;'>"
        
        tables_array = [
            
            #HEADERS
            [
                "Action",
                "Document Type",
                "Date Uploaded"
            ]
        ]
        
        @doc_pids.each{|pid|
            
            document = $tables.attach("DOCUMENTS").by_primary_id(pid)
            
            tables_array.push([
                
                $tools.doc_secure_link(pid, "View or Download"),
                
                $tables.attach("document_type").field_by_pid("name", document.fields["type_id"].value).value,
                
                document.fields["created_date"].to_user#,
                
                #begin $team.by_team_email(document.fields["created_by"].value).full_name rescue "Unknown" end
                
            ])
            
        }
        
        output << $kit.tools.data_table(tables_array, "withdraw_documents")
        output << "</div>"
        
        return output
        
    end
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def agora_reson_dd
        return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)",:value_field=>"code",:clause_string => "WHERE type = 'agora'"})
    end
    
    def k12_reson_dd(record_created_date_string = nil)
        
        if record_created_date_string
            record_created_date = DateTime.parse(record_created_date_string)
            date_k12_codes_changed = DateTime.new(2014,9,18,16,30,0)
            
            if record_created_date >= date_k12_codes_changed
                return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)", :value_field=>"code",:clause_string => "WHERE type = 'k12' AND codes_to_use = 'Changed 9-12-2014'"})
            else
                return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)", :value_field=>"code",:clause_string => "WHERE type = 'k12' AND codes_to_use = 'Original'"})
            end
        else
            return $tables.attach("WITHDRAW_REASONS").nva({:name_field=> "CONCAT(code, ' - ', reason)", :value_field=>"code",:clause_string => "WHERE type = 'k12' AND codes_to_use = 'Changed 9-12-2014'"})
        end
    end
    
    def method_dd
        return [
            {:name=>"Home Visit",           :value=>"Home Visit"},
            {:name=>"E-Mail",               :value=>"E-Mail"},
            {:name=>"K-Mail",               :value=>"K-Mail"},
            {:name=>"Letter",               :value=>"Letter"},
            {:name=>"Phone Call",           :value=>"Phone Call"},
            {:name=>"Attendance Procedure", :value=>"Attendance Procedure"}
        ]
    end
    
    def relationship_dd
        return [
            {:name=>"Legal Guardian",       :value=>"Legal Guardian"},
            {:name=>"Learning Coach",       :value=>"Learning Coach"},
            {:name=>"Self",                 :value=>"Self"},
            {:name=>"Admin - Attendance",   :value=>"Admin - Attendance"},
            {:name=>"Admin - Academic",     :value=>"Admin - Academic"},
            {:name=>"Admin - Compliancy",   :value=>"Admin - Compliancy"},
            {:name=>"Admin - Records",      :value=>"Admin - Records"}
        ]
    end
    
    def status_dd
        return [
            {:name=>"Requested",            :value=>"Requested"},
            {:name=>"Processed",            :value=>"Processed"},
            {:name=>"Withdraw Confirmed",   :value=>"Withdraw Confirmed"},
            {:name=>"Withdraw Retracted",   :value=>"Withdraw Retracted"}
        ]
    end
    
    def type_dd
        return [
            {:name=>"General Ed Truancy",   :value=>"General Ed Truancy"},
            {:name=>"Special Ed Truancy",   :value=>"Special Ed Truancy"},
            {:name=>"User Initiated",       :value=>"User Initiated"}
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def truancy_dates(values)
        output = "<div class='truancy_div'>"
        truancy_div = "<div class='truancy_dates'>"
        if !values.nil?
            truancy_array = values.split(",")
            truancy_array.each do |date|
                x = date.split("-")
                truancy_div << "#{x[1]}/#{x[2]}/#{x[0]}<br>"
            end
        else
            truancy_div << "No Absences"
        end
        output << "<div class='truancy_header'>Truancy Dates</div>"
        output << truancy_div
        output << "</div></div>"
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        #new_row_button_Withdrawing                       {       float:right; font-size: xx-small !important;}
        
        div.initiator_container{                                width:625px; margin-left:auto; margin-right:auto;}
        div.other_container{                                    width:625px; margin-left:auto; margin-right:auto;}
        div.left_column{                                        float:left; clear:left;}
        div.WITHDRAWING__initiated_date{                        float:left; clear:left; width:312px; margin:4px;}
        div.WITHDRAWING__type{                                  float:left; margin:4px;}
        div.WITHDRAWING__initiator{                             float:left; clear:left; width:312px; margin:4px;}
        div.WITHDRAWING__method{                                float:left; margin:4px;}
        div.WITHDRAWING__relationship{                          float:left; clear:left; width:312px; margin:4px;}
        div.WITHDRAWING__agora_reason{                          float:left; margin:4px;}
        div.WITHDRAWING__k12_reason{                            float:left; margin:4px;}
        div.WITHDRAWING__effective_date{                        float:left; clear:left; margin:4px;}
        div.WITHDRAWING__ftc_action{                            float:left; clear:left; margin:4px;}
        div.WITHDRAWING__transferring_school{                   float:left; clear:left; margin:4px;}
        div.required_message{                                   float:right; clear:both; margin-top:5px; margin-right:15px;}
        
        div.WITHDRAWING__initiated_date label{                  width:100px; display:inline-block;}
        div.WITHDRAWING__type label{                            width:70px;  display:inline-block;}
        div.WITHDRAWING__initiator label{                       width:100px; display:inline-block;}
        div.WITHDRAWING__method label{                          width:70px;  display:inline-block;}
        div.WITHDRAWING__relationship label{                    width:100px; display:inline-block;}
        div.WITHDRAWING__ftc_action label{                      width:140px; display:inline-block;}
        div.WITHDRAWING__agora_reason label{                    width:140px; display:inline-block;}
        div.WITHDRAWING__k12_reason label{                      width:140px; display:inline-block;}
        div.WITHDRAWING__effective_date label{                  width:140px; display:inline-block;}
        div.WITHDRAWING__transferring_school label{             width:140px; display:inline-block;}
        div.WITHDRAWING__comments{                              float:left; clear:left; margin:4px; margin-bottom:10px;}
        div.WITHDRAWING__comments label{                        width:140px; display:inline-block; vertical-align:top;}
        div.WITHDRAWING__processed{                             float:left; margin:4px; clear:left;}
        
        div.WITHDRAWING__status{                                float:left; clear:left; margin:5px;}
        div.retracted_status{                                   float:left; clear:left; margin:5px; width:235px;}
        div.retracted_answer{                                   float:left; margin:5px;}
        div.WITHDRAWING__ftc_notified_date{                     float:left; clear:left; margin:5px;}
        div.WITHDRAWING__eligible_date{                         float:left; clear:left; margin:5px;}
        div.WITHDRAWING__processed_date{                        float:left; clear:left; margin:5px;}
        div.WITHDRAWING__completed_date{                        float:left; clear:left; margin:5px;}
        div.WITHDRAWING__rescinded_date{                        float:left; clear:left; margin:5px;}
        div.WITHDRAWING__parent_notify_date{                    float:left; clear:left; margin:5px;}
        div.WITHDRAWING__district_notify_date{                  float:left; clear:left; margin:5px;}
        div.retract_button{                                     float:right; margin-top:8px; margin-right:15px;}
        div.rescind_button{                                     float:right; margin-top:8px; margin-right:15px;}
        div.WITHDRAWING__status label{                          width:240px; display:inline-block;}
        div.WITHDRAWING__ftc_notified_date label{               width:240px; display:inline-block;}
        div.WITHDRAWING__eligible_date label{                   width:240px; display:inline-block;}
        div.WITHDRAWING__processed_date label{                  width:240px; display:inline-block;}
        div.WITHDRAWING__completed_date label{                  width:240px; display:inline-block;}
        div.WITHDRAWING__rescinded_date label{                  width:240px; display:inline-block;}
        div.WITHDRAWING__parent_notify_date label{              width:240px; display:inline-block;}
        div.WITHDRAWING__district_notify_date label{            width:240px; display:inline-block;}
        
        div.WITHDRAWING__agora_reason select{                   width:440px;}
        div.WITHDRAWING__k12_reason select{                     width:440px;}
        div.WITHDRAWING__method select{                         width:210px;}
        div.WITHDRAWING__relationship select{                   width:190px;}
        div.WITHDRAWING__type select{                           width:210px;}
        div.WITHDRAWING__type input{                            width:210px;}
        div.WITHDRAWING__initiated_date input{                  width:190px;}
        div.WITHDRAWING__initiator input{                       width:190px;}
        div.WITHDRAWING__transferring_school input{             width:440px;}
        div.created{                                            float:left; clear:left; margin-top:15px; margin-left:2px; margin-bottom:10px; font-size:.8em;}
        
        div.truancy_div{                                        float:left;}
        div.truancy_header{                                     float:left; clear:left; padding:2px;  padding-left:10px; width:108px; border: 1px solid #3baae3; border-top-left-radius:5px; border-top-right-radius:5px;color:#2779aa; background-color:#d7ebf9;}
        div.truancy_dates{                                      float:left; clear:left; padding-top:5px; padding-left:10px; margin-top:-1px; line-height:150%; overflow-y:auto; width:110px; height:215px; border: 1px solid #3baae3; border-bottom-left-radius:5px; border-bottom-right-radius:5px; background-color:white; }
        
        div.new_div{                                            margin:10px; margin-left:20px;}
        div.no_docs{                                            float:left; clear:left; margin-left:20px;}
        textarea{                                               width:610px; height:120px; resize:none; overflow-y:scroll;}
        div.sym_link{                                           float:left; clear:left; margin:5px;}
        div.student_link{                                       float:left; clear:left; width:200px;}
        div.STUDENT__student_id{                                float:left; width:100px;}
        div.eligible_date{                                      float:left; margin-left:20px;}
        div.eligible_date{                                      cursor:inherit;}
        div.status{                                             float:left; margin-left:20px;}
        div.status label{                                       cursor:inherit;}
        div.form{                                               position:relative; margin-top:5px; margin-bottom:5px;}
        fieldset{                                               width:700px; margin-left:auto; margin-right:auto;}
        
        #new_pdf_button                                         {       float:right; font-size: xx-small !important;}
        
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