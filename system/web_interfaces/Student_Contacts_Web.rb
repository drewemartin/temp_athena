#!/usr/local/bin/ruby


class STUDENT_CONTACTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "STUDENT_CONTACTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        how_to_button_contacts = $tools.button_how_to("How To: Notes")
        
        "Notes #{how_to_button_contacts}#{new_contact_button}"
        
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
        
        #if $kit.params[:student_id]
        #    sid = $kit.params[:student_id]
        #    output = student_record(sid)
        #    $kit.modify_tag_content("tabs-2", output, "update")
        #end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        output      = String.new
        
        if records  = $focus_student.contacts.existing_records
            
            output << $tools.div_open("student_contacts_container", "student_contacts_container")
            
            how_to_button_live_contact = $tools.button_how_to("How To: Live Contact")
                
                tables_array = [
                    
                    #HEADERS
                    [
                        "Created Date",
                        "Created By",
                        "Date & Time",
                        "Live Contact Made? #{how_to_button_live_contact}",
                        "Notes",
                        "Type",
                        "TEP Initial",
                        "TEP Follow-up",
                        "Attendance",
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
                        "Technical Issue",
                        "ILP Conference",
                        "Low Engagement",
                        "Truancy Court Outcome",               
                        "Court Preparation",                   
                        "Residency",                           
                        "SES",                                 
                        "SAP Invitation",                      
                        "SAP Follow-up",                       
                        "Evaluation Request - Psychology",     
                        "ELL",                                 
                        "PHLOTE Identification",               
                        "CYS",                                 
                        "Homeless",                            
                        "Aircard",
                        "Court/District/Go",
                        "Counselor One-on-One",
                        "Counselor Face to Face",
                        "Counselor Graduation Meeting",
                        "Counselor Intervention",
                        "504 Conference",
                        "Progress Monitoring",
                        "Other",
                        "Other Description",
                        "RTII Behavior"
                    ]
                    
                ]
                
                directors   = $team.directors || []
                is_director = directors.include?($team_member.primary_id.value)
                
                
                records.each{|record|
                    
                    f = record.fields
                    
                    creator         = $team.find(:email_address=>f["created_by"].value)
                    is_creator      = $kit.params[:user_id] == f["created_by"].value
                    is_supervisor   = ($team_member.primary_id.value == creator.supervisor_team_id.value)
                    
                    disabled        = (is_director || is_supervisor || is_creator) ? false : true
                    
                    row = Array.new
                    ########################################################################
                    #FNORD - MOVE THE 'DISPLAY:NONE' DIV INTO WEB AS AN OPTION
                    row.push(f["created_date"                  ].to_user)
                    row.push($team.by_team_email(f["created_by"].value) ? $team.by_team_email(f["created_by"].value).full_name : f["created_by"].value)
                    row.push(f["datetime"                      ].web.default(:disabled=>disabled, :date_range_end=>"#{$iuser}")+"<div style=\"display:none;\">"+f["datetime"                      ].to_user()+"</div>")
                    row.push(f["successful"                    ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["successful"                    ].to_user()+"</div>")
                    row.push(f["notes"                         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">")
                    row.push(f["contact_type"                  ].web.select( :disabled=>disabled, :dd_choices=>type_dd)) 
                    row.push(f["tep_initial"                   ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["tep_initial"                   ].to_user()+"</div>")
                    row.push(f["tep_followup"                  ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["tep_followup"                  ].to_user()+"</div>")
                    row.push(f["attendance"                    ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["attendance"                    ].to_user()+"</div>")
                    row.push(f["test_site_selection"           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["test_site_selection"           ].to_user()+"</div>")
                    row.push(f["scantron_performance"          ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["scantron_performance"          ].to_user()+"</div>")
                    row.push(f["study_island_assessments"      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["study_island_assessments"      ].to_user()+"</div>")
                    row.push(f["course_progress"               ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["course_progress"               ].to_user()+"</div>")
                    row.push(f["work_submission"               ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["work_submission"               ].to_user()+"</div>")
                    row.push(f["grades"                        ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["grades"                        ].to_user()+"</div>")
                    row.push(f["communications"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["communications"                ].to_user()+"</div>")
                    row.push(f["retention_risk"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["retention_risk"                ].to_user()+"</div>")
                    row.push(f["escalation"                    ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["escalation"                    ].to_user()+"</div>")
                    row.push(f["welcome_call"                  ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["welcome_call"                  ].to_user()+"</div>")
                    row.push(f["initial_home_visit"            ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["initial_home_visit"            ].to_user()+"</div>")
                    row.push(f["tech_issue"                    ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["tech_issue"                    ].to_user()+"</div>")
                    row.push(f["ilp_conference"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["ilp_conference"                ].to_user()+"</div>")
                    row.push(f["low_engagement"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["low_engagement"                ].to_user()+"</div>")
                    row.push(f["truancy_court_outcome"         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["truancy_court_outcome"         ].to_user()+">/div>")
                    row.push(f["court_preparation"             ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["court_preparation"             ].to_user()+">/div>")
                    row.push(f["residency"                     ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["residency"                     ].to_user()+">/div>")
                    row.push(f["ses"                           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["ses"                           ].to_user()+">/div>")
                    row.push(f["sap_invitation"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["sap_invitation"                ].to_user()+">/div>")
                    row.push(f["sap_followup"                  ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["sap_followup"                  ].to_user()+">/div>")
                    row.push(f["evaluation_request_psych"      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["evaluation_request_psych"      ].to_user()+">/div>")
                    row.push(f["ell"                           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["ell"                           ].to_user()+">/div>")
                    row.push(f["phlote_identification"         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["phlote_identification"         ].to_user()+">/div>")
                    row.push(f["cys"                           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["cys"                           ].to_user()+">/div>")
                    row.push(f["homeless"                      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["homeless"                      ].to_user()+">/div>")
                    row.push(f["aircard"                       ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["aircard"                       ].to_user()+">/div>")
                    row.push(f["court_district_go"             ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["court_district_go"             ].to_user()+">/div>")
                    row.push(f["counselor_one_on_one"          ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["counselor_one_on_one"          ].to_user()+">/div>")
                    row.push(f["counselor_face_to_face"        ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["counselor_face_to_face"        ].to_user()+">/div>")
                    row.push(f["counselor_graduation_meeting"  ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["counselor_graduation_meeting"  ].to_user()+">/div>")
                    row.push(f["counselor_intervention"        ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["counselor_intervention"        ].to_user()+">/div>")
                    row.push(f["504_conference"                ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["504_conference"                ].to_user()+">/div>")
                    row.push(f["progress_monitoring"           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["progress_monitoring"           ].to_user()+">/div>")
                    row.push(f["other"                         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["other"                         ].to_user()+"</div>")
                    row.push(f["other_description"             ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">")
                    row.push(f["rtii_behavior_id"              ].web.select(:disabled=>disabled, :dd_choices=>rtii_dd_options)   )
                    
                    tables_array.push(row)
                    
                }
             
                output << $kit.tools.data_table(tables_array, "contacts")
                
            output << $tools.div_close()
            
        else
            
            output << $tools.newlabel("no_record", "There are not contacts entered for this student.")
            
        end
        
        output << $tools.newlabel("bottom")
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_student_contacts()
        
        output = String.new
        
        output << $tools.div_open("student_contacts_container", "student_contacts_container")
            
            record = $focus_student.contacts.new_record
            
            output << $tools.legend_open("sub", "Notes")
                
                output << record.fields["notes"].web.default(:div_id=>"blank")
                
            output << $tools.legend_close()
            
            output << $tools.legend_open("sub", "Contact Details")
                
                output << record.fields["student_id"                  ].web.hidden()
                output << record.fields["successful"                  ].web.default( :label_option=>"Live Contact Made?" ,      :div_id=>"blank")
                output << record.fields["datetime"                    ].web.default( :label_option=>"Contact Attempt Time:",    :div_id=>"blank", :date_range_end=>"#{$iuser}")
                output << record.fields["contact_type"                ].web.select( {:label_option=>"Contact Type:",            :div_id=>"blank", :dd_choices=>type_dd}, true)
                
            output << $tools.legend_close()
            
            output << $tools.legend_open("sub", "Reason for Contact - Please select all that apply from the following:")
                
                reasons = Array.new
                reasons.push(
                    
                    record.fields["aircard"                       ].web.default( :label_option=>"Aircard",                              :div_id=>"blank"),
                    record.fields["attendance"                    ].web.default( :label_option=>"Attendance",                           :div_id=>"blank"),
                    record.fields["counselor_one_on_one"          ].web.default( :label_option=>"Counselor One-on-One",                 :div_id=>"blank"),
                    record.fields["counselor_face_to_face"        ].web.default( :label_option=>"Counselor Face to Face",               :div_id=>"blank"),
                    record.fields["counselor_graduation_meeting"  ].web.default( :label_option=>"Counselor Graduation Meeting",         :div_id=>"blank"),
                    record.fields["counselor_intervention"        ].web.default( :label_option=>"Counselor Intervention",               :div_id=>"blank"),
                    record.fields["course_progress"               ].web.default( :label_option=>"Course Progress",                      :div_id=>"blank"),
                    record.fields["court_district_go"             ].web.default( :label_option=>"Court/district/Go",                    :div_id=>"blank"),
                    record.fields["court_preparation"             ].web.default( :label_option=>"Court Preparation",                    :div_id=>"blank"),
                    record.fields["cys"                           ].web.default( :label_option=>"CYS",                                  :div_id=>"blank"),
                    record.fields["ell"                           ].web.default( :label_option=>"ELL",                                  :div_id=>"blank"),
                    record.fields["escalation"                    ].web.default( :label_option=>"Escalation",                           :div_id=>"blank"),
                    record.fields["evaluation_request_psych"      ].web.default( :label_option=>"Evaluation Request - Psychology",      :div_id=>"blank"),
                    record.fields["communications"                ].web.default( :label_option=>"General Communications",               :div_id=>"blank"),
                    record.fields["grades"                        ].web.default( :label_option=>"Grades",                               :div_id=>"blank"),
                    record.fields["homeless"                      ].web.default( :label_option=>"Homeless",                             :div_id=>"blank"),
                    record.fields["ilp_conference"                ].web.default( :label_option=>"ILP Conference",                       :div_id=>"blank"),
                    record.fields["initial_home_visit"            ].web.default( :label_option=>"Initial Face-to-Face",                 :div_id=>"blank"),
                    record.fields["low_engagement"                ].web.default( :label_option=>"Low Engagement",                       :div_id=>"blank"),
                    record.fields["phlote_identification"         ].web.default( :label_option=>"PHLOTE Identification",                :div_id=>"blank"),
                    record.fields["progress_monitoring"           ].web.default( :label_option=>"Progress Monitoring",                  :div_id=>"blank"),
                    record.fields["residency"                     ].web.default( :label_option=>"Residency",                            :div_id=>"blank"),
                    record.fields["retention_risk"                ].web.default( :label_option=>"Retention Risk",                       :div_id=>"blank"),
                    record.fields["sap_followup"                  ].web.default( :label_option=>"SAP Follow-up",                        :div_id=>"blank"),
                    record.fields["sap_invitation"                ].web.default( :label_option=>"SAP Invitation",                       :div_id=>"blank"),
                    record.fields["scantron_performance"          ].web.default( :label_option=>"Scantron",                             :div_id=>"blank"),
                    record.fields["ses"                           ].web.default( :label_option=>"SES",                                  :div_id=>"blank"),
                    record.fields["study_island_assessments"      ].web.default( :label_option=>"Study Island",                         :div_id=>"blank"),
                    record.fields["tech_issue"                    ].web.default( :label_option=>"Technical Issue",                      :div_id=>"blank"),
                    record.fields["tep_followup"                  ].web.default( :label_option=>"TEP Follow-up",                        :div_id=>"blank"),
                    record.fields["tep_initial"                   ].web.default( :label_option=>"TEP Initiated",                        :div_id=>"blank"),
                    record.fields["test_site_selection"           ].web.default( :label_option=>"Test Site",                            :div_id=>"blank"),
                    record.fields["truancy_court_outcome"         ].web.default( :label_option=>"Truancy Court Outcome",                :div_id=>"blank"),
                    record.fields["welcome_call"                  ].web.default( :label_option=>"Welcome Call",                         :div_id=>"blank"),
                    record.fields["work_submission"               ].web.default( :label_option=>"Work Submission",                      :div_id=>"blank"),
                    record.fields["504_conference"                ].web.default( :label_option=>"504 Conference",                       :div_id=>"blank")

                )
                
                output << alphabetize_contact_reasons(reasons)
                
                output << record.fields["other"                         ].web.default( :label_option=>"'Other'",                              :div_id=>"blank")
                output << record.fields["other_description"             ].web.text(    :label_option=>"Details (if 'Other')",                 :div_id=>"blank")
                
            output << $tools.legend_close()
            
            if  $focus_student.rtii_behavior.existing_records
                
                output << $tools.legend_open("sub", "RTII - Please select one of the following (only if this contact was RTII related):")
                    
                    rtii_table = $tables.attach("student_rtii_behavior")
                    output << record.fields["rtii_behavior_id" ].web.radio(
                        {
                            :radio_choices     => rtii_dd_options
                        }
                    )
                    
                output << $tools.legend_close()
                
            end
            
        output << $tools.div_close()
        
        return output
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def rtii_dd_options
        rtii_records    = $focus_student.rtii_behavior.existing_records
        rtii_array      = Array.new
        rtii_records.each{|rtii_record|
            name = "Created Date: #{rtii_record.fields['created_date'].to_user()} - #{rtii_record.fields['skill_group'].to_user()} || #{rtii_record.fields['targeted_behavior'].to_user()} || #{rtii_record.fields['intervention'].to_user()}"
            rtii_array.push({:name=>name, :value=>rtii_record.primary_id})
        } if rtii_records
        rtii_array.insert(0, {:name=>"Not Related", :value=>nil})
        return rtii_array
    end
    
    def type_dd
        return [
            {:name=>"ADO - Agora Day Out",      :value=>"ADO - Agora Day Out"       },
            {:name=>"Childline",                :value=>"Childline"                 },
            {:name=>"E-Mail",                   :value=>"E-Mail"                    },
            {:name=>"Home Visit (Unscheduled)", :value=>"Home Visit (Unscheduled)"  },
            {:name=>"Individual Face to Face",  :value=>"Individual Face to Face"   },
            {:name=>"IM - Instant Message",     :value=>"IM - Instant Message"      },
            {:name=>"K-Mail",                   :value=>"K-Mail"                    },
            {:name=>"Mailing",                  :value=>"Mailing"                   },
            {:name=>"Phone Call",               :value=>"Phone Call"                },
            {:name=>"Small Group",              :value=>"Small Group"               },
            {:name=>"Texting",                  :value=>"Texting"                   },
            {:name=>"Virtual Meeting",          :value=>"Virtual Meeting"           },
            {:name=>"End of Year Summary",      :value=>"End of Year Summary"       }
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def alphabetize_contact_reasons(reasons)
        
        output = String.new
        
        num_reasons = reasons.length
        num_rows = num_reasons/4
        remainder = num_reasons%4
        if remainder != 0
            num_rows = num_rows + 1
        end
        x = 0
        a1 = Array.new
        a2 = Array.new
        a3 = Array.new
        a4 = Array.new
        
        i = 1
        while i <= num_rows
            a1.push(reasons[x])
            x = x + 1
            i = i + 1
        end
        
        if remainder == 2 || remainder == 3 || remainder == 0
            i = 1
            while i <= num_rows
                a2.push(reasons[x])
                x = x + 1
                i = i + 1
            end
            
            if remainder == 3 || remainder == 0
                i = 1
                while i <= num_rows
                    a3.push(reasons[x])
                    x = x + 1
                    i = i + 1
                end
                
                if remainder == 0
                    i = 1
                    while i <= num_rows
                        a4.push(reasons[x])
                        x = x + 1
                        i = i + 1
                    end
                else
                    i = 1
                    while i < num_rows
                        a4.push(reasons[x])
                        x = x + 1
                        i = i + 1
                    end
                end
            else
                i = 1
                while i < num_rows
                    a3.push(reasons[x])
                    x = x + 1
                    i = i + 1
                end
                i = 1
                while i < num_rows
                    a4.push(reasons[x])
                    x = x + 1
                    i = i + 1
                end
            end
        else
            i = 1
            while i < num_rows
                a2.push(reasons[x])
                x = x + 1
                i = i + 1
            end
            i = 1
            while i < num_rows
                a3.push(reasons[x])
                x = x + 1
                i = i + 1
            end
            i = 1
            while i < num_rows
                a4.push(reasons[x])
                x = x + 1
                i = i + 1
            end
        end
        
        output << $tools.div_open("div1", "div1")
            
            i = 0
            while i < a1.length
                output << a1[i]
                i = i + 1
            end
            
        output << $tools.div_close()
        
        output << $tools.div_open("div2", "div2")
            
            i = 0
            while i < a2.length
                output << a2[i]
                i = i + 1
            end
            
        output << $tools.div_close()
        
        output << $tools.div_open("div3", "div3")
            
            i = 0
            while i < a3.length
                output << a3[i]
                i = i + 1
            end
            
        output << $tools.div_close()
        
        output << $tools.div_open("div4", "div4")
            
            i = 0
            while i < a4.length
                output << a4[i]
                i = i + 1
            end
            
        output << $tools.div_close()
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS 
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            div.student_contacts_container{                                     width:100%;}
            #new_row_button_STUDENT_CONTACTS{                                   float:right; font-size: xx-small !important;}
            
            table.dataTable td.column_4{                                        text-align:center;}
            
            div.div1{                                                           float:left;}
            div.div2{                                                           float:left;}
            div.div3{                                                           float:left;}
            div.div4{                                                           float:left;}
            
            div#blank.STUDENT_CONTACTS__datetime{                               float:left; margin-bottom:3px; width:400px;}
            div#blank.STUDENT_CONTACTS__successful{                             float:left; margin-bottom:3px; width:200px;}
            div#blank.STUDENT_CONTACTS__contact_type{                           float:left; margin-bottom:3px; width:400px;}
            
            #datetime_1{                                                        width:183px;}                                           
            div#blank.STUDENT_CONTACTS__datetime label{                         width:160px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__successful label{                       width:135px; display:inline-block;} 
            
            div#blank.STUDENT_CONTACTS__notes textarea{                         resize:none;}
            div#blank.STUDENT_CONTACTS__contact_type textarea{                  width:500px; height:100px; resize:none;}
            
            div#blank.STUDENT_CONTACTS__tep_followup{                           width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__tep_initial{                            width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__attendance{                             width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__test_site_selection{                    width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__scantron_performance{                   width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__study_island_assessments{               width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__course_progress{                        width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__work_submission{                        width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__grades{                                 width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__communications{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__retention_risk{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__escalation{                             width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__welcome_call{                           width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__initial_home_visit{                     width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__tech_issue{                             width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ilp_conference{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__low_engagement{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ado{                                    width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__truancy_court_outcome{                  width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__court_preparation{                      width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__residency{                              width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ses{                                    width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__sap_invitation{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__sap_followup{                           width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych{               width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych{          width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ell{                                    width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__phlote_identification{                  width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__cys{                                    width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__homeless{                               width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__aircard{                                width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__court_district_go{                      width:100%; height:20px; margin-bottom:2px;}         
            div#blank.STUDENT_CONTACTS__counselor_one_on_one{                   width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__counselor_face_to_face{                 width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__counselor_graduation_meeting{           width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__counselor_intervention{                 width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__504_conference{                         width:100%; height:20px; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__progress_monitoring{                    width:100%; height:20px; margin-bottom:2px;}
            
            
            div#blank.STUDENT_CONTACTS__other{                                  float:left; clear:left; width:25%; padding-top:10px;}
            div#blank.STUDENT_CONTACTS__other_description{                      float:left; clear:left; width:25%; padding-top:10px;}
         
            div#blank.STUDENT_CONTACTS__tep_followup input{                     float:left;}
            div#blank.STUDENT_CONTACTS__tep_initial input{                      float:left;}
            div#blank.STUDENT_CONTACTS__attendance input{                       float:left;}
            div#blank.STUDENT_CONTACTS__test_site_selection input{              float:left;}
            div#blank.STUDENT_CONTACTS__scantron_performance input{             float:left;}
            div#blank.STUDENT_CONTACTS__study_island_assessments input{         float:left;}
            div#blank.STUDENT_CONTACTS__course_progress input{                  float:left;}
            div#blank.STUDENT_CONTACTS__work_submission input{                  float:left;}
            div#blank.STUDENT_CONTACTS__grades input{                           float:left;}
            div#blank.STUDENT_CONTACTS__communications input{                   float:left;}
            div#blank.STUDENT_CONTACTS__retention_risk input{                   float:left;}
            div#blank.STUDENT_CONTACTS__escalation input{                       float:left;}
            div#blank.STUDENT_CONTACTS__welcome_call input{                     float:left;}
            div#blank.STUDENT_CONTACTS__initial_home_visit input{               float:left;}
            div#blank.STUDENT_CONTACTS__tech_issue input{                       float:left;}
            div#blank.STUDENT_CONTACTS__ilp_conference input{                   float:left;}
            div#blank.STUDENT_CONTACTS__low_engagement input{                   float:left;}
            div#blank.STUDENT_CONTACTS__ado input{                              float:left;}
            div#blank.STUDENT_CONTACTS__truancy_court_outcome input{            float:left;}
            div#blank.STUDENT_CONTACTS__court_preparation input{                float:left;}
            div#blank.STUDENT_CONTACTS__residency input{                        float:left;}
            div#blank.STUDENT_CONTACTS__ses input{                              float:left;}
            div#blank.STUDENT_CONTACTS__sap_invitation input{                   float:left;}
            div#blank.STUDENT_CONTACTS__sap_followup input{                     float:left;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych input{         float:left;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych input{    float:left;}
            div#blank.STUDENT_CONTACTS__ell input{                              float:left;}
            div#blank.STUDENT_CONTACTS__phlote_identification input{            float:left;}
            div#blank.STUDENT_CONTACTS__cys input{                              float:left;}
            div#blank.STUDENT_CONTACTS__homeless input{                         float:left;}
            div#blank.STUDENT_CONTACTS__aircard input{                          float:left;}
            div#blank.STUDENT_CONTACTS__court_district_go input{                float:left;}
            div#blank.STUDENT_CONTACTS__counselor_one_on_one input{             float:left;}
            div#blank.STUDENT_CONTACTS__counselor_face_to_face input{           float:left;}
            div#blank.STUDENT_CONTACTS__counselor_graduation_meeting input{     float:left;}
            div#blank.STUDENT_CONTACTS__counselor_intervention input{           float:left;}
            div#blank.STUDENT_CONTACTS__504_conference input{                   float:left;}
            div#blank.STUDENT_CONTACTS__progress_monitoring input{              float:left;}
            
            div#blank.STUDENT_CONTACTS__other input{                            float:left;}
            
            div#blank.STUDENT_CONTACTS__tep_followup label{                     width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__tep_initial label{                      width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__attendance label{                       width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__test_site_selection label{              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__scantron_performance label{             width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__study_island_assessments label{         width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__course_progress label{                  width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__work_submission label{                  width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__grades label{                           width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__communications label{                   width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__retention_risk label{                   width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__escalation label{                       width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__welcome_call label{                     width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__initial_home_visit label{               width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__tech_issue label{                       width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__ilp_conference label{                   width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__low_engagement label{                   width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__truancy_court_outcome label{            width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__court_preparation label{                width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__residency label{                        width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__ses label{                              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__sap_invitation label{                   width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__sap_followup label{                     width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych label{         width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych label{    width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__ell label{                              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__phlote_identification label{            width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__cys label{                              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__homeless label{                         width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__aircard label{                          width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__court_district_go label{                width:250px; display:inline-block;}
            
            input.STUDENT_CONTACTS__successful{                                 margin-left: 0px;}
            input.datetimepick{                                                 width:145px; font-size:11px;}
            div.STUDENT_CONTACTS__notes textarea{                               width:648px; height:75px;}
            
            div.STUDENT_CONTACTS__contact_type{                                 width:200px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__successful{                                   width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__other{                                        width:20px; margin-left:auto; margin-right:auto;}
            
            textarea{resize:none; font-size:11px;}
            fieldset.sub{width:100%;}
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