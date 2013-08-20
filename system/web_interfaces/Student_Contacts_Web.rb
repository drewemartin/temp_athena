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
        
        how_to_button_contacts = $tools.button_how_to("How To: Contacts")
        
        "Contacts #{how_to_button_contacts}#{new_contact_button}"
        
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
                        "Initial Home Visit",
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
                        "Other",
                        "Other Description",
                        "RTII Behavior"
                    ]
                    
                ]
                
                records.each{|record|
                    
                    f = record.fields
                    
                    disabled = $user == f["created_by"].value ? false : true
                    
                    row = Array.new
                    ########################################################################
                    #FNORD - MOVE THE 'DISPLAY:NONE' DIV INTO WEB AS AN OPTION
                    row.push($team.by_team_email(f["created_by"].value) ? $team.by_team_email(f["created_by"].value).full_name : f["created_by"].value)
                    row.push(f["datetime"                      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["datetime"                      ].to_user()+"</div>")
                    row.push(f["successful"                    ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["successful"                    ].to_user()+"</div>")
                    row.push(f["notes"                         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">")
                    row.push(f["contact_type"                  ].web.label()) 
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
                    row.push(f["sap_follow-up"                 ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["sap_follow-up"                 ].to_user()+">/div>")
                    row.push(f["evaluation_request_psych"      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["evaluation_request_psych"      ].to_user()+">/div>")
                    row.push(f["ell"                           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["ell"                           ].to_user()+">/div>")
                    row.push(f["phlote_identification"         ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["phlote_identification"         ].to_user()+">/div>")
                    row.push(f["csy"                           ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["csy"                           ].to_user()+">/div>")
                    row.push(f["homeless"                      ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["homeless"                      ].to_user()+">/div>")
                    row.push(f["aircard"                       ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["aircard"                       ].to_user()+">/div>")
                    row.push(f["court_district_go"             ].web.default(:disabled=>disabled)+"<div style=\"display:none;\">"+f["court_district_go"             ].to_user()+">/div>")
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
                output << record.fields["successful"                  ].web.default( :label_option=>"Live Contact Made?" ,       :div_id=>"blank")
                output << record.fields["datetime"                    ].web.default( :label_option=>"Contact Attempt Time:",     :div_id=>"blank", :validate=>true)
                output << record.fields["contact_type"                ].web.select(  {:label_option=>"Contact Type:",            :div_id=>"blank", :validate=>true, :dd_choices=>type_dd}, true)
                
            output << $tools.legend_close()
            
            output << $tools.legend_open("sub", "Reason for Contact - Please select all that apply from the following:")
                
                output << record.fields["aircard"                       ].web.default( :label_option=>"Aircard",                              :div_id=>"blank")
                output << record.fields["attendance"                    ].web.default( :label_option=>"Attendance",                           :div_id=>"blank")
                output << record.fields["course_progress"               ].web.default( :label_option=>"Course Progress",                      :div_id=>"blank")
                output << record.fields["court_district_go"             ].web.default( :label_option=>"Court/district/Go",                    :div_id=>"blank")
                output << record.fields["court_preparation"             ].web.default( :label_option=>"Court Preparation",                    :div_id=>"blank")
                output << record.fields["csy"                           ].web.default( :label_option=>"CYS",                                  :div_id=>"blank")
                output << record.fields["ell"                           ].web.default( :label_option=>"ELL",                                  :div_id=>"blank")
                output << record.fields["escalation"                    ].web.default( :label_option=>"Escalation",                           :div_id=>"blank")
                output << record.fields["evaluation_request_psych"      ].web.default( :label_option=>"Evaluation Request - Psychology",      :div_id=>"blank")
                output << record.fields["communications"                ].web.default( :label_option=>"General Communications",               :div_id=>"blank")
                output << record.fields["grades"                        ].web.default( :label_option=>"Grades",                               :div_id=>"blank")
                output << record.fields["homeless"                      ].web.default( :label_option=>"Homeless",                             :div_id=>"blank")
                output << record.fields["ilp_conference"                ].web.default( :label_option=>"ILP Conference",                       :div_id=>"blank")
                output << record.fields["initial_home_visit"            ].web.default( :label_option=>"Initial Home Visit",                   :div_id=>"blank")
                output << record.fields["low_engagement"                ].web.default( :label_option=>"Low Engagement",                       :div_id=>"blank")
                output << record.fields["phlote_identification"         ].web.default( :label_option=>"PHLOTE Identification",                :div_id=>"blank")
                output << record.fields["residency"                     ].web.default( :label_option=>"Residency",                            :div_id=>"blank")
                output << record.fields["retention_risk"                ].web.default( :label_option=>"Retention Risk",                       :div_id=>"blank")
                output << record.fields["sap_follow-up"                 ].web.default( :label_option=>"SAP Follow-up",                        :div_id=>"blank")
                output << record.fields["sap_invitation"                ].web.default( :label_option=>"SAP Invitation",                       :div_id=>"blank")
                output << record.fields["scantron_performance"          ].web.default( :label_option=>"Scantron",                             :div_id=>"blank")
                output << record.fields["ses"                           ].web.default( :label_option=>"SES",                                  :div_id=>"blank")
                output << record.fields["study_island_assessments"      ].web.default( :label_option=>"Study Island",                         :div_id=>"blank")
                output << record.fields["tech_issue"                    ].web.default( :label_option=>"Technical Issue",                      :div_id=>"blank")
                output << record.fields["tep_followup"                  ].web.default( :label_option=>"TEP Follow-up",                        :div_id=>"blank")
                output << record.fields["tep_initial"                   ].web.default( :label_option=>"TEP Initiated",                        :div_id=>"blank")
                output << record.fields["test_site_selection"           ].web.default( :label_option=>"Test Site",                            :div_id=>"blank")
                output << record.fields["truancy_court_outcome"         ].web.default( :label_option=>"Truancy Court Outcome",                :div_id=>"blank")
                output << record.fields["welcome_call"                  ].web.default( :label_option=>"Welcome Call",                         :div_id=>"blank")
                output << record.fields["work_submission"               ].web.default( :label_option=>"Work Submission",                      :div_id=>"blank")
                
                output << record.fields["other"                         ].web.default( :label_option=>"'Other'",                              :div_id=>"blank")
                output << record.fields["other_description"             ].web.text(    :label_option=>"Details (if 'other')",                 :div_id=>"blank")
                
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
            
            div#blank.STUDENT_CONTACTS__datetime{                               float:left; margin-bottom:3px; width:400px;}
            div#blank.STUDENT_CONTACTS__successful{                             float:left; margin-bottom:3px; width:200px;}
            div#blank.STUDENT_CONTACTS__contact_type{                           float:left; margin-bottom:3px; width:400px;}
            
            #datetime_1{                                                        width:183px;}                                           
            div#blank.STUDENT_CONTACTS__datetime label{                         width:160px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__successful label{                       width:135px; display:inline-block;} 
            div#blank.STUDENT_CONTACTS__contact_type label{                     width:100px; display:inline-block; vertical-align:top;}
            
            div#blank.STUDENT_CONTACTS__notes textarea{                         resize:none;}
            div#blank.STUDENT_CONTACTS__contact_type textarea{                  width:500px; height:100px; resize:none;}
            
            div#blank.STUDENT_CONTACTS__tep_followup{                           float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__tep_initial{                            float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__attendance{                             float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__test_site_selection{                    float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__scantron_performance{                   float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__study_island_assessments{               float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__course_progress{                        float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__work_submission{                        float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__grades{                                 float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__communications{                         float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__retention_risk{                         float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__escalation{                             float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__welcome_call{                           float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__initial_home_visit{                     float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__tech_issue{                             float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ilp_conference{                         float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__low_engagement{                         float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ado{                                    float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__truancy_court_outcome{                  float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__court_preparation{                      float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__residency{                              float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ses{                                    float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__sap_invitation{                         float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__sap_follow-up{                          float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych{               float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych{          float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__ell{                                    float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__phlote_identification{                  float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__csy{                                    float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__homeless{                               float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__aircard{                                float:left; width:25%; margin-bottom:2px;}
            div#blank.STUDENT_CONTACTS__court_district_go{                      float:left; width:25%; margin-bottom:2px;}
            
            
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
            div#blank.STUDENT_CONTACTS__sap_follow-up input{                    float:left;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych input{         float:left;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych input{    float:left;}
            div#blank.STUDENT_CONTACTS__ell input{                              float:left;}
            div#blank.STUDENT_CONTACTS__phlote_identification input{            float:left;}
            div#blank.STUDENT_CONTACTS__csy input{                              float:left;}
            div#blank.STUDENT_CONTACTS__homeless input{                         float:left;}
            div#blank.STUDENT_CONTACTS__aircard input{                          float:left;}
            div#blank.STUDENT_CONTACTS__court_district_go input{                float:left;}

            
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
            div#blank.STUDENT_CONTACTS__sap_follow-up label{                    width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__evaluation_request_psych label{         width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__evaluation_under_review_psych label{    width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__ell label{                              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__phlote_identification label{            width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__csy label{                              width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__homeless label{                         width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__aircard label{                          width:250px; display:inline-block;}
            div#blank.STUDENT_CONTACTS__court_district_go label{                width:250px; display:inline-block;}
            
            input.STUDENT_CONTACTS__successful{                                 margin-left:0px;}
            input.datetimepick{                                                 width:145px; font-size:11px;}
            div.STUDENT_CONTACTS__notes textarea{                               width:648px; height:75px;}
            
            div.STUDENT_CONTACTS__contact_type{                                 width:100px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__successful{                                   width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__tep_initial{                                  width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__tep_followup{                                 width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__attendance{                                   width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__test_site_selection{                          width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__scantron_performance{                         width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__study_island_assessments{                     width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__course_progress{                              width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__work_submission{                              width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__grades{                                       width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__communications{                               width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__retention_risk{                               width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__escalation{                                   width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__welcome_call{                                 width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__initial_home_visit{                           width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__tech_issue{                                   width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__ilp_conference{                               width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__low_engagement{                               width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__truancy_court_outcome{                        width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__court_preparation{                            width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__residency{                                    width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__ses{                                          width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__sap_invitation{                               width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__sap_follow-up{                                width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__evaluation_request_psych{                     width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__evaluation_under_review_psych{                width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__ell{                                          width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__phlote_identification{                        width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__csy{                                          width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__homeless{                                     width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__aircard{                                      width:20px; margin-left:auto; margin-right:auto;}
            div.STUDENT_CONTACTS__court_district_go{                            width:20px; margin-left:auto; margin-right:auto;}
            
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