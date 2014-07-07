#!/usr/local/bin/ruby

class TEAM_MEMBER_RECORD_WEB

    #---------------------------------------------------------------------------
    def initialize()
        
        @structure                      = structure
        @peer_group_email_addresses     = nil
        
    end
    #---------------------------------------------------------------------------
    
    def load
        
        setup
        
    end
    
    def breakaway_caption
        return "Team Member Record - #{$focus_team_member.full_name}"
    end
    
    def page_title
        return $focus_team_member.full_name
    end
    
    def content
        
        team_member_record_title    =  String.new
        page_title                  =  $kit.web_script.page_title
        team_member_record_title    << page_title if !page_title.nil?
        $kit.modify_tag_content(
            
            "team_member_record_title",
            team_member_record_title,
            type="update"
            
        )
        
        team_member_record_content = String.new
        
        team_member_record_content << "#{$kit.web_script.css}"
        team_member_record_content << "#{$kit.web_script.javascript}" 
        team_member_record_content << "#{$kit.web_script.team_member_record}" if $kit.web_script.respond_to?("team_member_record")
        
        $kit.modify_tag_content(
            "team_member_record_content",
            team_member_record_content,
            type="update"
        )
        
    end
    
    def setup
        
        demographics = "<div
            class='team_member_details'
            id='team_member_details'
            style='
                display:inline-block;
                width:100%;
                border: 0px solid red;
                float: left;'>
            #{demographics_section}
        </div>"
        
        require "#{$paths.web_interfaces_path}team_member_detail_web"
        default_page = Object.const_get("TEAM_MEMBER_DETAIL_WEB").new();
        
        content =
        "<FIELDSET style='float:left;'><LEGEND id='team_member_record_title' style='width:100%;'></LEGEND>
            <div class='team_member_record_content' id='team_member_record_content' style='width:1020px; overflow:auto;'>
            </div>
        </FIELDSET>"
        
        menu    = "<div
            class='team_member_menu'
            id='team_member_menu'
            style='
                display :inline-block;
                width   :125px;
                border  :0px solid red;
                float   :right;
                clear   :right;'>
            #{menu_section}
        </div>"
        
        return "<div
            class='team_member_container'
            id='team_member_container'
            style='
                display :inline-block;
                width   :100%;
                border  :0px solid red;'>
            #{demographics+menu+content}
        </div>"
        
    end
    
    def working_list
        
        output = Array.new
      
        if $team_member.supervisor_of
            
            output.push(
                :name       => "MyTeam (#{$team_member.supervisor_of ? $team_member.supervisor_of.length : 0})",
                :content    => "#{expand_myteam}"
                
            )
            
        end
        
        if $team_member.enrolled_students && $team_member.enrolled_students.length < 2000
            
            output.push(
                :name       => "MyStudents (#{$team_member.enrolled_students ? $team_member.enrolled_students.length : 0})",
                :content    => "#{$team_member.expand_mystudents_enrolled}"
                
            )
            
        end
        
        return (output.empty? ? nil : output)
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DEMOGRAPHICS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def demographics_section
        
        output = String.new
        
        output << "<div class='team_member_demographics'>"
            
            team_member_demo_section = Array.new
            
            a1, b1 = "Identity"                                 , identity
            a2, b2 = "Contact"                                  , contact
            a3, b3 = "Peer Group ID: #{$focus_team_member.peer_group_id.value }#{peer_group_email_link || ''}" , peer_group
            a4, b4 = ""                                         , ""
            a5, b5 = ""                                         , ""
            team_member_demo_section.push([a1.to_s,a2.to_s,a3.to_s])#,a4.to_s,a5.to_s])
            team_member_demo_section.push([b1.to_s,b2.to_s,b3.to_s])#,b4.to_s,b5.to_s])
            
            #a1, b1 = "Address:"         , add_str
            #a2, b2 = "Phone Number:"    , $focus_team_member.homephone.value
            #a3, b3 = "Birthday:"        , $focus_team_member.birthday.value
            #a4, b4 = "Age:"             , $base.age_from_date($focus_team_member.birthday.value)
            #a5, b5 = "Age:"             , $base.age_from_date($focus_team_member.birthday.value)
            #team_member_demo_section.push([a1.to_s,a2.to_s,a3.to_s,a4.to_s,a5.to_s])
            #team_member_demo_section.push([b1.to_s,b2.to_s,b3.to_s,b4.to_s,b5.to_s])
            
            output << $tools.table(
                :table_array    => team_member_demo_section,
                :unique_name    => "team_member_demo_section",
                :footers        => false,
                :head_section   => true,
                :title          => false,
                :caption        => false
            )
            
            #output << "<div style='padding:10px;clear:both;'><hr></div>"
            
            #CSS
            output << "<style>"
                
                output << "table#team_member_demo_section                          { width:100%; font-size: small; text-align:center; margin-bottom: 15px; border:1px solid #E1E1E1; border-radius:6px; background:#E9EEEF;  }"
                output << "table#team_member_demo_section                        td{ width:33%; height:20px;                             }"  
                
            output << "</style>"
            
        output << "</div>"
        
        #output << $tools.button_hide("student_demographics") 
        
        return output
        
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DEMOGRAPHICS_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def contact
        
        id_array = Array.new
        
        #ADDRESS
        add_str = "#{$focus_team_member.mailing_address_1.value}<br>"
        add_str << "#{!$focus_team_member.mailing_address_2.value.nil? ? $focus_team_member.mailing_address_2.value+"<br>" : ""}"
        add_str << "#{$focus_team_member.mailing_city.value}, #{$focus_team_member.mailing_state.value} #{$focus_team_member.mailing_zip.value}"
        id_array.push(["Address:", add_str])
        
        #PHONE NUMBERS
        phone_records = $focus_team_member.phone_numbers.existing_records
        phone_records.each{|record|
            
            type    = record.fields["type"          ].value
            num_str = record.fields["phone_number"  ].to_phone_number
            id_array.push([type.capitalize+" Phone:", num_str])
            
        } if phone_records
        
        #EMAIL ADDRESSESS
        email_records = $focus_team_member.email.existing_records
        email_records.each{|record|
            
            type    = record.fields["email_type"        ].value
            elink   = record.fields["email_address"     ].to_email_link
            id_array.push([type.capitalize+" Email:", elink])
            
        } if email_records
        
        output = $tools.table(
            :table_array    => id_array,
            :unique_name    => "team_member_demo_section_contact",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        #CSS
        output << "<style>"
            
            output << "table#team_member_demo_section_contact{
                width       : 50%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#team_member_demo_section_contact                     td{ width:50%;                                          }"
            output << "table#team_member_demo_section_contact            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#team_member_demo_section_contact            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#team_member_demo_section_contact            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#team_member_demo_section_contact            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#team_member_demo_section_contact             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#team_member_demo_section_contact            td.even_row{ vertical-align:middle;                              }"
            output << "table#team_member_demo_section_contact                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
    end
    
    def identity
        
        samsids = String.new
        samsids_records = $focus_team_member.sams_ids.existing_records
        samsids_records.each{|record|
            samsid = record.fields["sams_id"].value
            samsids << (samsids.empty?  ? samsid : ",#{samsid}") 
        } if samsids_records
        
        id_array = Array.new
        
        a1, b1 = "First Name:"          , $focus_team_member.legal_first_name.value
        a2, b2 = "Last Name:"           , $focus_team_member.legal_last_name.value
        a3, b3 = "Team Member ID:"      , $focus_team_member.primary_id.value
        a4, b4 = "SAMS Person ID:"      , samsids
        a5, b5 = "Department:"          , $focus_team_member.department_id.value ? $tables.attach("DEPARTMENT").field_by_pid("name", $focus_team_member.department_id.value).value : ""
        
        id_array.push([a1.to_s,b1.to_s])
        id_array.push([a2.to_s,b2.to_s])
        id_array.push([a3.to_s,b3.to_s])
        id_array.push([a4.to_s,b4.to_s])
        id_array.push([a5.to_s,b5.to_s])
        
        output = $tools.table(
            :table_array    => id_array,
            :unique_name    => "team_member_demo_section_id",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        #CSS
        output << "<style>"
            
            output << "table#team_member_demo_section_id{
                width       : 50%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#team_member_demo_section_id                     td{ width:50%;                                          }"
            output << "table#team_member_demo_section_id            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#team_member_demo_section_id            td.column_1{ vertical-align:middle; text-align:right;            }"
            output << "table#team_member_demo_section_id             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#team_member_demo_section_id            td.even_row{ vertical-align:middle;                              }"
            output << "table#team_member_demo_section_id                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
    end
    
    def peer_group
        
        output          = String.new
        peer_group_arr  = Array.new
        peer_group_id   = $focus_team_member.peer_group_id.value
        peer_group_tids = $focus_team_member.peers_with
        peer_group_tids.each{|tid|
            
            t = $team.get(tid)
            if t
                
                peer_group_arr.push(
                    
                    [
                     
                        t.preferred_email.to_email_link(
                            :text       => t.legal_first_name.value + " " + t.legal_last_name.value,
                            :subject    => "Supervisor: #{$focus_team_member.supervisor_team_id.to_name(:full_name)}, Group: #{$focus_team_member.peer_group_id.value}",
                            :content    => ""
                        )
                        
                    ]
                    
               )
                
            end
            
        } if peer_group_tids
        
        output << "<DIV style='height:120px; overflow:auto;'>"
            
            output << $tools.table(
                :table_array    => peer_group_arr,
                :unique_name    => "team_member_demo_section_peer_group",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )   
            
        output << "</DIV>"
        
        #CSS
        output << "<style>"
            
            output << "table#team_member_demo_section_peer_group{
                width       : 50%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            
            output << "table#team_member_demo_section_peer_group             div.day { display:inline-block; width:20%;  text-align:center;}"
            output << "table#team_member_demo_section_peer_group         td.column_0 { width:20%; vertical-align:middle; text-align:center;}"
            #output << "table#team_member_demo_section_peer_group                  td { border-bottom: 1px groove black; }"
            output << "select#field_id__2__STUDENT_SPECIALIST_MATH__team_id     { width:100%;                            }"
            output << "select#field_id__2__STUDENT_SPECIALIST_READING__team_id  { width:100%;                            }"
            
        output << "</style>"
        
    end
    
    def peer_group_email_link
        
        peer_group_email_addresses = Array.new
        
        peer_group_tids = $focus_team_member.peers_with
        peer_group_tids.each{|tid|
           
            t = $team.get(tid)
            if t
                peer_group_email_addresses.push(t.preferred_email.value)
            end 
            
        } if peer_group_tids
        
        if !peer_group_email_addresses.empty?
            return $field.new(
                "field"     => "email_peer_group",
                "value"     => peer_group_email_addresses.join(";")
            ).to_email_link(
                :subject    => "Supervisor: #{$focus_team_member.supervisor_team_id.to_name(:full_name)}, Group: #{$focus_team_member.peer_group_id.value}",
                :content    => "",
                :class      => "ui-icon ui-icon-mail-closed",
                :style      => "display:inline-block; margin-left:5px;"
            )
        else
            return false
        end
        
    end
    
    def specialists_array(subject="math" || "reading")
        
        if $focus_team_member.send("specialist_#{subject}").existing_record || $focus_team_member.send("specialist_#{subject}").new_record.save
            
            spec_disable = $team_member.has_rights?("1") ? false : true
            
            spec_array = Array.new
            
            a1 = "<div class='day'>M    #{ $focus_team_member.send("specialist_#{subject}").monday.web.default(     :disabled=>spec_disable)}   </div>"
            a2 = "<div class='day'>T    #{ $focus_team_member.send("specialist_#{subject}").tuesday.web.default(    :disabled=>spec_disable)}   </div>"
            a3 = "<div class='day'>W    #{ $focus_team_member.send("specialist_#{subject}").wednesday.web.default(  :disabled=>spec_disable)}   </div>"
            a4 = "<div class='day'>Th   #{ $focus_team_member.send("specialist_#{subject}").thursday.web.default(   :disabled=>spec_disable)}   </div>"
            a5 = "<div class='day'>F    #{ $focus_team_member.send("specialist_#{subject}").friday.web.default(     :disabled=>spec_disable)}   </div>"
            
            t = $team.get($focus_team_member.specialist_math.team_id.value).exists?
            if t
                
                tname   = t.legal_first_name.value + " " + t.legal_last_name.value
                mlink   = t.preferred_email.to_email_link(:text=>"#{subject.capitalize} Specialist:",:subject=>"Student ID: #{$focus_team_member.student_id.value}",:content=>"")
                
            end
            
            spec = spec_disable ? () : $focus_team_member.send("specialist_#{subject}").team_id.web.select(:dd_choices=>$dd.team_members)
            spec_array.push(["#{mlink || "#{subject.capitalize} Specialist:" }",spec || "Not Assigned"])
            spec_array.push(["",a1.to_s+a2.to_s+a3.to_s+a4.to_s+a5.to_s])
            
            return spec_array
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MENU
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def menu_section
        
        output  = String.new
        
        output << "<input type='hidden' id='page'   name='page' value=''        >"
        output << "<input type='hidden' id='tid'    name='tid'  value='#{$focus_team_member.primary_id.value}' >"
        
        field_class     = "smenu_top ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
        
        output << $field.new("value"=>"Detailed Record"         ).web.button(:onclick=>"$('#page').val('Team_Member_Detail_Web'             );send_covered('tid');clear_team_record_content();",    :field_class=>field_class, :no_div=>true )
        output << $field.new("value"=>"Evaluations"             ).web.button(:onclick=>"$('#page').val('Team_Member_Evaluations_Web'        );send_covered('tid');clear_team_record_content();",    :field_class=>field_class, :no_div=>true )
        #output << $field.new("value"=>"Charts"                  ).web.button(:onclick=>"$('#page').val('Team_Member_Charts_Web'             );send_covered('tid');",    :field_class=>field_class, :no_div=>true )
        
        #CSS
        output << "<style>"
            
            output << "button.smenu_top    { width: 125px; float:right; clear:both; font-size: xx-small !important;}"
            
        output << "</style>"
        
        return output
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def expand_myteam
        
        tables_array = [
            
            #HEADERS
            [
                #BASIC INFORMATION
                "Team Member ID"                        ,
                "Last Name"                             ,
                "First Name"                            ,
                "Birthday"                              ,
                "Position"                              , 
                "Department"                            ,
                "Department Category"                   ,
                "Department Focus"                      ,
                "Supervisor"                            ,
                "Peer Group"                            ,
                
                #EVALUATION SUMMARY
                "Current Students"                      ,
                "All Students"                          ,
                "New Students"                          ,
                "In Year Enrolled"                      ,
                "Low Income"                            ,
                "Tier 2 or 3"                           ,
                "Special Ed"                            ,
                "Grades 7-12"                           ,
                "Scantron Fall Participation"           ,
                "Scantron Spring Participation"         ,
                "Scantron Growth Overall"               ,
                "Scantron Growth Math"                  ,
                "Scantron Growth Reading"               ,
                "AIMS Fall Participation"               ,
                "AIMS Spring Participation"             ,
                "AIMS Growth Overall"                   ,
                "SI Participation"                      ,
                "SI Participation Tier 2 or 3"          ,
                "SI Blue Ribbon"                        ,
                "SI Blue Ribbon Tier 2 or 3"            ,
                "Define U Participation"                ,
                "PSSA Participation"                    ,
                "Keystone Participation"                ,
                "Attendance Rate"                       ,
                "Retention Rate"                        ,
                "Engagement Level"                      ,
                "Course Passing Rate"                   
               
            ]
            
        ]
        
        tables_array[0] = tables_array[0] + 
        [
         
            #ACADEMIC
            "Assessment Performance"                        ,
            "Assessment Performance Attainable"             ,
            "Assessment Participation Fall"                 ,
            "Assessment Participation Fall Attainable"      ,
            "Assessment Participation Spring"               ,
            "Assessment Participation Spring Attainable"    ,  
            "Course Passing Rate"                           , 
            "Course Passing Rate Attainable"                ,
            "Study Island Participation"                    ,
            "Study Island participation Attainable"         ,
            "Study Island Achievement"                      ,
            "Study Island Achievement Attainable"           ,
            
            #ENGAGEMENT
            "Scantron Participation Fall"                   ,
            "Scantron Participation Attainable Fall"        ,
            "Scantron Participation Spring"                 ,
            "Scantron Participation Attainable Spring"      ,
            "Attendance"                                    ,
            "Attendance Attainable"                         ,
            "Truancy Prevention"                            ,
            "Truancy Prevention Attainable"                 ,
            "Evaluation Participation"                      ,
            "Evaluation Participation Attainable"           ,
            "Keystone Participation"                        ,
            "Keystone Participation Attainable"             ,
            "PSSA Participation"                            ,
            "PSSA Participation Attainable"                 ,
            "Quality Documentation"                         ,
            "Feedback"
        ]
        
        supervisor_of = $team_member.supervisor_of
        supervisor_of.each{|team_id|
            
            t = $team.get(team_id)
            row = Array.new
            
            #BASIC INFORMATION
            row.push(t.primary_id.value                                                               ) 
            row.push(t.legal_last_name.value                                                          ) 
            row.push(t.legal_first_name.value                                                         ) 
            row.push(t.dob.value                                                                      )
            
            row.push(t.employee_type.value                                                            )                                                               
            row.push(t.department_id.value                                                            )     
            row.push(t.department_category.value                                                      )
            row.push(t.department_focus.value                                                         )
            
            row.push(t.supervisor_team_id.to_name(options=:full_name)                                 )
            row.push(t.peer_group_id.web.select(:disabled=>true,:dd_choices=>$kit.dd.peer_group_id )  )
            
            #EVALUATION SUMMARY
            t.evaluation_academic_metrics.existing_record || t.evaluation_academic_metrics.new_record.save
            eval_exists = t.evaluation_summary.existing_record
            row.push(eval_exists ? t.evaluation_summary.students.value                           : "" )
            row.push(eval_exists ? t.evaluation_summary.all_students.value                       : "" )
            row.push(eval_exists ? t.evaluation_summary.new.value                                : "" )
            row.push(eval_exists ? t.evaluation_summary.in_year.value                            : "" )
            row.push(eval_exists ? t.evaluation_summary.low_income.value                         : "" )
            row.push(eval_exists ? t.evaluation_summary.tier_23.value                            : "" )
            row.push(eval_exists ? t.evaluation_summary.special_ed.value                         : "" )
            row.push(eval_exists ? t.evaluation_summary.grades_712.value                         : "" ) 
            row.push(eval_exists ? t.evaluation_summary.scantron_participation_fall.value        : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_participation_spring.value      : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_overall.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_math.value               : "" )
            row.push(eval_exists ? t.evaluation_summary.scantron_growth_reading.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_participation_fall.value            : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_participation_spring.value          : "" )
            row.push(eval_exists ? t.evaluation_summary.aims_growth_overall.value                : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_participation.value         : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_participation_tier_23.value : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_achievement.value           : "" )
            row.push(eval_exists ? t.evaluation_summary.study_island_achievement_tier_23.value   : "" )
            row.push(eval_exists ? t.evaluation_summary.define_u_participation.value             : "" )
            row.push(eval_exists ? t.evaluation_summary.pssa_participation.value                 : "" )
            row.push(eval_exists ? t.evaluation_summary.keystone_participation.value             : "" )
            row.push(eval_exists ? t.evaluation_summary.attendance_rate.value                    : "" )
            row.push(eval_exists ? t.evaluation_summary.retention_rate.value                     : "" )
            row.push(eval_exists ? t.evaluation_summary.engagement_level.value                   : "" )             
            row.push(eval_exists ? t.evaluation_summary.course_passing_rate.value                : "" )             
            
            #EVALUATION METRICS
            eval_exists = t.evaluation_academic_metrics.existing_record
            blank = t.department_category.value == "Engagement"
            t.evaluation_academic_metrics.existing_record || t.evaluation_academic_metrics.new_record.save
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_performance.value                           : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_performance_attainable.value                : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_fall.value                    : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_fall_attainable.value         : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_spring.value                  : "" ) 
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.assessment_participation_spring_attainable.value       : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.course_passing_rate.value                              : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.course_passing_rate_attainable.value                   : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_participation.value                       : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_participation_attainable.value            : "" )  
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_achievement.value                         : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_academic_metrics.study_island_achievement_attainable.value              : "" )                   
            
            eval_exists = t.evaluation_engagement_metrics.existing_record
            blank = t.department_category.value == "Academic"
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_fall.value                    : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_fall_attainable.value         : "" )
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_spring.value                  : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.scantron_participation_spring_attainable.value       : "" ) 
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.attendance.value                                     : "" )       
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.attendance_attainable.value                          : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.truancy_prevention.value                             : "" )       
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.truancy_prevention_attainable.value                  : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.evaluation_participation.value                       : "" )      
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.evaluation_participation_attainable.value            : "" )   
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.keystone_participation.value                         : "" )     
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.keystone_participation_attainable.value              : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.pssa_participation.value                             : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.pssa_participation_attainable.value                  : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.quality_documentation.value                          : "" )    
            row.push(blank ? "" : eval_exists ? t.evaluation_engagement_metrics.feedback.value                                       : "" )    
            
            tables_array.push(row)
            
        } if supervisor_of
        
        return $kit.tools.data_table(tables_array, "my_team")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_search
        
        dlg_string      = String.new
        search_params   = String.new
        
        dlg_string << "<div id='student_search_fields'>"
        searchable_fields = [
            "student_id:Student ID",
            "studentfirstname:First Name",
            "studentlastname:Last Name",
            "familyid:Family ID",
            "grade:Grade"
        ]
        fields = $tables.attach("STUDENT").new_row.fields
        searchable_fields.each{|field_details|
            field_name      = field_details.split(":")[0]
            label           = field_details.split(":")[1]
            dlg_string      << fields[field_name].web.text(:search=>true, :label_option=>"#{label}:")
            html_field_id   = fields[field_name].web.field_id(:search=>true)
            search_params   << (search_params.empty? ? html_field_id : ",#{html_field_id}")
        }
        dlg_string << "<button id='student_search_button' type='button' onclick=\"send('#{search_params}');\"></button>"
        dlg_string << "</div>"
        dlg_string << "<div id='student_search_results'></div>"
        dlg_string << "</div>"
        dlg_string.insert(0, "<div id='student_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return dlg_string
        
    end
    
    def team_search
        
        dlg_string      = String.new
        search_params   = String.new
        
        dlg_string << "<div id='team_search_fields'>"
        searchable_fields = [
            "primary_id:Team ID",
            "legal_first_name:First Name",
            "legal_last_name:Last Name"     
        ]
        fields = $tables.attach("TEAM").new_row.fields
        searchable_fields.each{|field_details|
            field_name      = field_details.split(":")[0]
            label           = field_details.split(":")[1]
            dlg_string      << fields[field_name].web.text(:search=>true, :label_option=>"#{label}:")
            html_field_id   = fields[field_name].web.field_id(:search=>true)
            search_params   << (search_params.empty? ? html_field_id : ",#{html_field_id}")
        }
        dlg_string << "<button id='team_search_button' type='button' onclick=\"send('#{search_params}');\"></button>"
        dlg_string << "</div>"
        dlg_string << "<div id='team_search_results'></div>"
        dlg_string << "</div>"
        dlg_string.insert(0, "<div id='team_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return dlg_string
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

end