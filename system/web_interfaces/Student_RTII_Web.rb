#!/usr/local/bin/ruby


class STUDENT_RTII_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "STUDENT_RTII_BEHAVIOR",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        how_to_button = $tools.button_how_to("How To: RTII Behavior")
        
        "RTII Behavior #{how_to_button}#{new_contact_button}"
        
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
        
        s           = $students.get(sid)
        
        new_rtii = $tools.button_new_row(table_name = "STUDENT_RTII_BEHAVIOR", additional_params_str = "sid")
        
        if records  = $students.get(sid).rtii_behavior.existing_records
            
            output << $tools.div_open("student_rtii_container", "student_rtii_container")
                
                records.each{|record|
                    
                    output << $tools.legend_open("sub", "RTII ID: #{record.primary_id}")
                        
                        output << rtii(record.primary_id)
                        
                    output << $tools.legend_close()
                    
                }
                
            output << $tools.div_close()
            
        else
            
            output << $tools.newlabel("no_record", "This student does not have any RTII records.")
            
        end
        
        output << $tools.newlabel("bottom")
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def add_new_record_student_rtii_behavior()
        
        output = String.new
        
        vault  = $tables.attach("rtii_vault")
        
        record = $focus_student.rtii_behavior.new_record
        
        output << record.fields["student_id"            ].web.hidden()
        
        output << $tools.div_open("required_info_container", "required_info_container")
            
            output << record.fields["skill_group"].web.select(
                {
                    :onchange       => "fill_select_option('#{record.fields["targeted_behavior" ].web.field_id}', this  );
                                        fill_select_option('#{record.fields["intervention"      ].web.field_id}', this  )",
                    :label_option   => "Skill Group:",
                    :validate       => true,
                    :dd_choices     => vault.dd_choices(
                        "skill_group",
                        "skill_group",
                        clause_string = "GROUP BY skill_group"
                    )
                },
                true
            )
            
            output << record.fields["targeted_behavior"].web.select(
                {
                    :onchange       => "fill_select_option('#{record.fields["intervention"].web.field_id}', this)",
                    :label_option   => "Targeted Behavior:",
                    :validate       => true
                },
                true
            )
            
            output << record.fields["intervention"].web.select(
                {
                    :label_option   =>"Intervention:",
                    :validate       =>true
                },
                true
            )
            
            output << record.fields["intervention_details"].web.default(
                :label_option   => "Details (if 'other'):"
            )  
            
        output << $tools.div_close()
        
        output << "<div style='padding:10px;clear:both;'><hr></div>"
        
        output << record.fields["results"                ].web.default(  :label_option=>"Results:"             )  
        output << record.fields["proof"                  ].web.default(  :label_option=>"Proof:"               )
        
        output << $tools.newlabel("required_message", "\"*\" indicates a required field")
        
        return output
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def expand_rtii(pid)
        
        output  = String.new
        
        output << $tools.div_open("student_rtii_container", "student_rtii_container")
            
            record  = $tables.attach("student_rtii_behavior").by_primary_id(pid)
            vault   = $tables.attach("rtii_vault")
            
            output << $tools.div_open("required_info_container", "required_info_container")
                
                output << record.fields["skill_group"            ].web.select( { :label_option=>"Skill Group:",        :validate=>true, :dd_choices=>vault.dd_choices("skill_group",        "skill_group",      clause_string = "GROUP BY skill_group"          )},true)  
                output << record.fields["targeted_behavior"      ].web.select( { :label_option=>"Targeted Behavior:",  :validate=>true, :dd_choices=>vault.dd_choices("targeted_behavior",  "targeted_behavior",clause_string = "GROUP BY targeted_behavior"    )},true) 
                output << record.fields["intervention"           ].web.select( { :label_option=>"Intervention:",       :validate=>true, :dd_choices=>vault.dd_choices("intervention",       "intervention",     clause_string = "GROUP BY intervention"         )},true)  
                output << record.fields["intervention_details"   ].web.default(  :label_option=>"Details (if 'other'):" )  
                
            output << $tools.div_close()
            
            output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            output << record.fields["results"                ].web.default(  :label_option=>"Results:"             )  
            output << record.fields["proof"                  ].web.default(  :label_option=>"Proof:"               )  
            
            pids   = $tables.attach("student_contacts").primary_ids("WHERE rtii_behavior_id = '#{pid}'")
            
            if pids
                
                output << "<div style='padding:10px;clear:both;'><hr></div>"
                
                tables_array = [
                    
                    #HEADERS
                    [
                        "Date & Time",
                        "Successful?",
                        "Notes",
                        "Type",
                        "TEP",
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
                    row.push(f["tep"                      ].to_user)
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
            
            output << $tools.newlabel("bottom")
            
        output << $tools.div_close()
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def fill_select_option_targeted_behavior(field_name, field_value, pid)
        
        output      = String.new
        record      = pid.empty? ? $tables.attach("STUDENT_RTII_BEHAVIOR").new_row : $tables.attach("STUDENT_RTII_BEHAVIOR").by_primary_id(pid)
        
        dd_choices  = $tables.attach("RTII_VAULT").dd_choices(
            "targeted_behavior",
            "targeted_behavior",
            " WHERE #{field_name} = '#{field_value}' GROUP BY targeted_behavior"
        )
        
        if dd_choices
            
            output << record.fields["targeted_behavior"].web.select_replacement(
                {
                    :dd_choices     => dd_choices
                },
                true
            )
            
        else
            
            output << record.fields["targeted_behavior"].web.select_replacement()
            
        end
        
        return output
        
    end
    
    def fill_select_option_intervention(field_name, field_value, pid)
        
        output      = String.new
        record      = pid.empty? ? $tables.attach("STUDENT_RTII_BEHAVIOR").new_row : $tables.attach("STUDENT_RTII_BEHAVIOR").by_primary_id(pid)
        
        dd_choices  = $tables.attach("RTII_VAULT").dd_choices(
            "intervention",
            "intervention",
            " WHERE #{field_name} = '#{field_value}' GROUP BY intervention"
        )
        
        if dd_choices
            
            output << record.fields["intervention"].web.select_replacement(
                {
                    :dd_choices     => dd_choices
                },
                true
            )
            
        else
            
            output << record.fields["intervention"].web.select_replacement()
            
        end
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def rtii(pid)
        
        output  = String.new
        
        output << $tools.div_open("student_rtii_container", "student_rtii_container")
            
            record  = $tables.attach("student_rtii_behavior").by_primary_id(pid)
            vault   = $tables.attach("rtii_vault")
            
            output << $tools.div_open("required_info_container", "required_info_container")
                
                output << record.fields["skill_group"].web.select(
                    {
                        :onchange       => "fill_select_option('#{record.fields["targeted_behavior"].web.field_id}', this );
                                            fill_select_option('#{record.fields["intervention"].web.field_id}', this      )",
                        :label_option   => "Skill Group:",
                        :validate       => true,
                        :dd_choices     => vault.dd_choices(
                            "skill_group",
                            "skill_group",
                            clause_string = "GROUP BY skill_group"
                        )
                    },
                    true
                )  
                
                skill_group             = record.fields["skill_group"       ].value
                targeted_behavior_dd    = vault.dd_choices(
                    "targeted_behavior",
                    "targeted_behavior",
                    " WHERE skill_group = '#{skill_group}' GROUP BY targeted_behavior"
                )
                
                if targeted_behavior_dd
                    
                    output << record.fields["targeted_behavior"].web.select(
                        {
                            :onchange       => "fill_select_option('#{record.fields["intervention"].web.field_id}', this)",
                            :label_option   => "Targeted Behavior:",
                            :validate       => true,
                            :dd_choices     => targeted_behavior_dd
                        },
                        true
                    )
                    
                else
                    output << record.fields["targeted_behavior"].web.select( { :label_option=>"Targeted Behavior:",   :validate=>true})
                end
                
                targeted_behavior       = record.fields["targeted_behavior" ].value
                intervention_dd         = vault.dd_choices(
                    "intervention",
                    "intervention",
                    " WHERE targeted_behavior = '#{targeted_behavior}' GROUP BY intervention"
                )
                
                if intervention_dd
                    
                    output << record.fields["intervention"].web.select(
                        {
                            :label_option   => "Intervention:",
                            :validate       => true,
                            :dd_choices     => intervention_dd
                        },
                        true
                    )
                    
                else
                    output << record.fields["intervention"           ].web.select( { :label_option=>"Intervention:",        :validate=>true}) 
                end
                
                output << record.fields["intervention_details"   ].web.default(  :label_option=>"Details (if 'other'):" )  
                
            output << $tools.div_close()
            
            output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            how_to_button_results = $tools.button_how_to("How To: RTII Behavior Results")
            how_to_button_proof = $tools.button_how_to("How To: RTII Behavior Proof")
            
            output << record.fields["results"                ].web.default(  :label_option=>"#{how_to_button_results} Results:"             )  
            output << record.fields["proof"                  ].web.default(  :label_option=>"#{how_to_button_proof} Proof:"               )  
            
            pids   = $tables.attach("student_contacts").primary_ids("WHERE rtii_behavior_id = '#{pid}'")
            
            if pids
                
                how_to_button_live_contact = $tools.button_how_to("How To: Live Contact")
                
                output << "<div style='padding:10px;clear:both;'><hr></div>"
                
                tables_array = [
                    
                    #HEADERS
                    [
                        "Date & Time",
                        "Live Contact Made? #{how_to_button_live_contact}",
                        "Notes",
                        "Type",
                        "TEP Initiated",
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
                        "Other",
                        "Details (if 'other')",
                        "RTII Behavior"
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
                    row.push(f["notes"                    ].web.default(:disabled=>true))
                    row.push(f["contact_type"             ].to_user) 
                    row.push(f["tep_initial"              ].to_user)
                    row.push(f["tep_followup"             ].to_user)
                    row.push(f["attendance"               ].to_user)
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
                    
                    rtii_record = $tables.attach("STUDENT_RTII_BEHAVIOR").by_primary_id(f["rtii_behavior_id"].value)
                    if rtii_record
                        rdate = rtii_record.fields['created_date'       ].to_user()
                        rbeha = rtii_record.fields['targeted_behavior'  ].to_user()
                        rinte = rtii_record.fields['intervention'       ].to_user()
                        rtii_text = "#{rbeha} #{rinte}"
                        rtii_text = $field.new(
                            "field"     => "rtii_details",
                            "value"     => rtii_text
                        ).web.text(:disabled=>true)
                    else
                        rtii_text = ""
                    end
                    row.push(rtii_text)
                    
                    tables_array.push(row)
                    
                }
                
                how_to_button_rtii_related_contacts = $tools.button_how_to("How To: RTII Behavior Contacts")
                
                output << $tools.newlabel("related_contacts", "Related Contacts")
                
                output << how_to_button_rtii_related_contacts
                
                output << $tools.data_table(tables_array, "contacts")
                
            end
            
            output << $tools.newlabel("bottom")
            
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
            
            div.student_rtii_container{                                     width:980px; margin-top:10px; margin-left:auto; margin-right:auto; clear:left;}
                #new_row_button_STUDENT_RTII_BEHAVIOR{                      float:right; font-size: xx-small !important;}
                
                div.required_info_container{                                width:870px; margin-top:20px; margin-left:auto; margin-right:auto; clear:left;}
                div.STUDENT_RTII_BEHAVIOR__skill_group{                     float:left; margin-bottom:5px; clear:left;}
                div.STUDENT_RTII_BEHAVIOR__targeted_behavior{               float:left; margin-bottom:5px; clear:left;}
                div.STUDENT_RTII_BEHAVIOR__intervention{                    float:left; margin-bottom:5px; clear:left;}
                div.STUDENT_RTII_BEHAVIOR__intervention_details{            float:left; margin-bottom:5px; clear:left;}
                div.STUDENT_RTII_BEHAVIOR__results{                         float:left; width:49%; margin:4px;  clear:left;}
                div.STUDENT_RTII_BEHAVIOR__proof{                           float:left; width:49%; margin:4px;}
                
                div.STUDENT_RTII_BEHAVIOR__skill_group label{               width:140px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__targeted_behavior label{         width:140px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__intervention label{              width:140px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__intervention_details label{      width:140px; display:inline-block; vertical-align:top;}
                div.STUDENT_RTII_BEHAVIOR__results label{                   width:210px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__proof label{                     width:210px; display:inline-block;}
                
                div.STUDENT_RTII_BEHAVIOR__skill_group select{              width:700px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__targeted_behavior select{        width:700px; display:inline-block;}
                div.STUDENT_RTII_BEHAVIOR__intervention select{             width:700px; display:inline-block;}
                
                div.STUDENT_RTII_BEHAVIOR__intervention_details textarea{   width:709px; height:23px; resize:none;}
                div.STUDENT_RTII_BEHAVIOR__results textarea{                width:100%; height: 50px; overflow-y: scroll; resize: none;}
                div.STUDENT_RTII_BEHAVIOR__proof textarea{                  width:100%; height: 50px; overflow-y: scroll; resize: none;}
                #how_to_button_How_To_RTII_Behavior_Contacts{               display:inline-block; margin-left:5px;}
                
                
                .related_contacts{
                    clear:left;
                    display:inline-block;
                }
                label.related_contacts{
                    font-size   : large;
                    top         : 265px;
                    left        : 20px;
                }
                
            textarea{resize:none;}
            input.datetimepick{                                         width:130px;}
            
            .summary_bar{
                display     : inline-block;
                width       : 200px;
                float       : right;
            }
            
            div.required_message{                                   float:right; clear:both;}
            
            .STUDENT_CONTACTS__notes{   width:300px; height:75px;}
            .rtii_details{              width:300px; height:75px;}
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