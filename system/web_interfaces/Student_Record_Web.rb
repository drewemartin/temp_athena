#!/usr/local/bin/ruby

class STUDENT_RECORD_WEB

    #---------------------------------------------------------------------------
    def initialize()
        
        @structure = structure
        @team_email_addresses   = nil
        
    end
    #---------------------------------------------------------------------------
    
    def load
        
        setup
        
    end
    
    def breakaway_caption
        return "Student Record - #{$focus_student.full_name}"
    end
    
    def page_title
        return "#{$config.school_year.split('-')[1]} #{$focus_student.full_name}"
    end
    
    def content
        
        student_record_content = String.new
        student_record_content << "#{$kit.web_script.css}"              if $kit.web_script.respond_to?("css"             ) 
        student_record_content << "#{$kit.web_script.javascript}"       if $kit.web_script.respond_to?("javascript"      ) 
        student_record_content << "#{$kit.web_script.student_record}"   if $kit.web_script.respond_to?("student_record"  ) 
        $kit.modify_tag_content(
            "student_record_content",
            student_record_content,
            type="update"
        )
        
    end
    
    def setup
        
        demographics = "<div
            class='student_details'
            id='student_details'
            style='
                display:inline-block;
                width:100%;
                border: 0px solid red;
                float: left;'>
            #{demographics_section}
        </div>"
        
        content =
        "<FIELDSET style='float:left;'><LEGEND id='student_record_title' style='width:100%;'></LEGEND>
            <div class='student_record_content' id='student_record_content' style='width:1020px; min-height:52px; overflow:auto;'></div>
        </FIELDSET>"
        
        menu    = "<div
            class='student_menu'
            id='student_menu'
            style='
                display:inline-block;
                width:125px;
                border: 0px solid red;
                float: right;
                clear:right;'>
            #{menu_section}
        </div>"
        
        return "<div
            class='student_container'
            id='student_container'
            style='
                display:inline-block;
                width:100%;
                border: 0px solid red;'>
            #{demographics+menu+content}
        </div>"
        
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
        
        output  = String.new
        
        output << "<div class='student_demographics'>"
            
            demo_section = Array.new
            
            a1, b1 = "Identity"                                 , identity
            a2, b2 = "Contact"                                  , contact
            a3, b3 = "Team Members#{team_email_link || ''}"     , team_members
            a4, b4 = "Assessments"                              , assessments
            a5, b5 = "Attendance"                               , attendance
            demo_section.push([a1.to_s,a2.to_s,a3.to_s,a4.to_s,a5.to_s])
            demo_section.push([b1.to_s,b2.to_s,b3.to_s,b4.to_s,b5.to_s])
            
            output << $tools.table(
                :table_array    => demo_section,
                :unique_name    => "demo_section",
                :footers        => false,
                :head_section   => true,
                :title          => false,
                :caption        => false
            )
            
            #CSS
            output << "<style>"
                
                output << "table#demo_section                          { width:100%; font-size: small; text-align:center; margin-bottom: 15px; border:1px solid #E1E1E1; border-radius:6px; background:#E9EEEF;  }"
                output << "table#demo_section                        td{ width:20%; height:20px;                             }"  
                
            output << "</style>"
            
        output << "</div>"
        
        return output
        
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DEMOGRAPHICS_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def assessments
        
        sec_array = Array.new
        
        scantron_record     = $focus_student.scantron_performance_level
        assessment_record   = $focus_student.assessment
        leap_record         = $focus_student.leap
        
        a1, b1 = "Scantron Math     Ent:"   , ( scantron_record.stron_ent_perf_m ? scantron_record.stron_ent_perf_m.value : "") 
        a2, b2 = "Scantron Reading  Ent:"   , ( scantron_record.stron_ent_perf_r ? scantron_record.stron_ent_perf_r.value : "")
        a3, b3 = "Scantron Math     Ext:"   , ( scantron_record.stron_ext_perf_m ? scantron_record.stron_ext_perf_m.value : "")
        a4, b4 = "Scantron Reading  Ext:"   , ( scantron_record.stron_ext_perf_r ? scantron_record.stron_ext_perf_r.value : "")
        si_level = $focus_student.study_island_level.color_code
        a5, b5 = "Study Island Level:"    , (!si_level ?  "" : si_level.web.label(:style=>"color:#{(si_level.value.nil? ? "" : si_level.value.downcase)};"))
                
        if [].include? $kit.user
            a6, b6 = "Tier Level Math:"         , ( assessment_record.tier_level_math    ? assessment_record.tier_level_math.web.select(:dd_choices=>tiers)    : "")
            a7, b7 = "Tier Level Reading:"      , ( assessment_record.tier_level_reading ? assessment_record.tier_level_reading.web.select(:dd_choices=>tiers) : "")
        else
            a6, b6 = "Tier Level Math:"         , ( assessment_record.tier_level_math    ? assessment_record.tier_level_math.value    : "")
            a7, b7 = "Tier Level Reading:"      , ( assessment_record.tier_level_reading ? assessment_record.tier_level_reading.value : "")
        end
        
        a8, b8 = "LEAP Level:"   , ( leap_record.existing_record ? leap_record.leap_level.value : "0")
        
        sec_array.push([a8.to_s,b8.to_s])
        sec_array.push([a6.to_s,b6.to_s])
        sec_array.push([a7.to_s,b7.to_s])
        sec_array.push([a1.to_s,b1.to_s])
        sec_array.push([a2.to_s,b2.to_s])
        sec_array.push([a3.to_s,b3.to_s])
        sec_array.push([a4.to_s,b4.to_s])
        sec_array.push([a5.to_s,b5.to_s])
        
        output = "<DIV style='height:120px; overflow:auto;'>"
        
        output << $tools.table(
            :table_array    => sec_array,
            :unique_name    => "demo_section_assessment",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        output << "</DIV>"
        
        #CSS
        output << "<style>"
            
            output << "table#demo_section_assessment{ 
                width       : 80%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#demo_section_assessment                    td{ width:50%;                                          }"
            output << "table#demo_section_assessment           td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#demo_section_assessment           td.column_1{ vertical-align:middle; text-align:right;            }"
            output << "table#demo_section_assessment            td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#demo_section_assessment           td.even_row{ vertical-align:middle;                              }"
            output << "table#demo_section_assessment                    th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
        
    end
    
    def attendance
        
        student             = $students.attach($focus_student.student_id.value)#FNORD - DELETE THIS OBJECT ASAP
        
        excused_breakdown = student.attendance.excused_absences_breakdown
        
        att_array = Array.new
        a1, b1 = "Enroll Date:"     , $focus_student.schoolenrolldate.to_user
        a2, b2 = "Days Enrolled:"   , student.attendance.enrolled_days.length
        a3, b3 = "Days Attended:"   , student.attendance.attended_days.length
        a4, b4 = "Days Excused:"    , student.attendance.excused_absences.length
        a5, b5 = "Days Unexcused:"  , student.attendance.unexcused_absences.length
        a6, b6 = "me:"              , excused_breakdown["me"].length
        a7, b7 = "t:"               , excused_breakdown["t"].length
        a8, b8 = "e:"               , excused_breakdown["e"].length
        
        
        att_array.push([a1.to_s,b1.to_s])
        att_array.push([a2.to_s,b2.to_s])
        att_array.push([a3.to_s,b3.to_s])
        att_array.push([a4.to_s,b4.to_s])
        att_array.push([a5.to_s,b5.to_s])
        att_array.push([a6.to_s,b6.to_s])
        att_array.push([a7.to_s,b7.to_s])
        att_array.push([a8.to_s,b8.to_s])
        
        output = "<DIV style='height:120px; overflow:auto;'>"
        
        output << $tools.table(
            :table_array    => att_array,
            :unique_name    => "demo_section_att",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        output << "</DIV>"
        
        #CSS
        output << "<style>"
            
            output << "table#demo_section_att{ 
                width       : 80%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#demo_section_att                    td{ width:50%;                                          }"
            output << "table#demo_section_att           td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#demo_section_att           td.column_1{ vertical-align:middle; text-align:right;            }"
            output << "table#demo_section_att            td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#demo_section_att           td.even_row{ vertical-align:middle;                              }"
            output << "table#demo_section_att                    th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
        
    end
    
    def contact
        
        id_array = Array.new
        
        add_str = "#{$focus_student.mailingaddress1.value}<br>"
        add_str << "#{!$focus_student.mailingaddress2.value.nil? ? $focus_student.mailingaddress2.value+"<br>" : ""}"
        add_str << "#{$focus_student.mailingcity.value}, #{$focus_student.mailingstate.value} #{$focus_student.mailingzip.value}"
        
        a1, b1 = "Mailing Address:"                                     , add_str
        a2, b2 = "Phone:"                                       , $focus_student.studenthomephone.to_phone_number
        a3, b3 = "LC (#{$focus_student.lcrelationship.value}):"    , "#{$focus_student.lcfirstname.value} #{$focus_student.lclastname.value}" 	
        a4, b4 = "LG (#{$focus_student.lgrelationship.value}):"    , "#{$focus_student.lgfirstname.value} #{$focus_student.lglastname.value}"
        
        id_array.push([a1.to_s,b1.to_s])
        id_array.push([a2.to_s,b2.to_s])
        id_array.push([a3.to_s,b3.to_s])
        id_array.push([a4.to_s,b4.to_s])
        
        output = $tools.table(
            :table_array    => id_array,
            :unique_name    => "demo_section_contact",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        #CSS
        output << "<style>"
            
            output << "table#demo_section_contact{
                width       : 85%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#demo_section_contact                     td{ width:50%;                                          }"
            output << "table#demo_section_contact            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#demo_section_contact            td.column_1{ vertical-align:middle; text-align:right;            }"
            
            output << "table#demo_section_contact            tr.row_0 td.column_0 { width:10%; vertical-align:middle; text-align:left;   }"
            output << "table#demo_section_contact            tr.row_0 td.column_1 { width:90%; vertical-align:middle; text-align:right;   }"
            
            output << "table#demo_section_contact             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#demo_section_contact            td.even_row{ vertical-align:middle;                              }"
            output << "table#demo_section_contact                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
    end
    
    def identity
        
        id_array = Array.new
        
        a1, b1 = "First Name:"      , $focus_student.studentfirstname.value
        a2, b2 = "Last Name:"       , $focus_student.studentlastname.value
        a3, b3 = "StudentID:"       , "#{$focus_student.student_id.value}#{$focus_student.student_id.web.hidden(:field_id=>"student_id", :field_name=>"student_id")}"
        a4, b4 = "FamilyID:"        , $focus_student.familyid.value
        a5, b5 = "Grade:"           , $focus_student.grade.value
        a6, b6 = "Birthday:"        , $focus_student.birthday.to_user
        #a7, b7 = "Age:"             , $base.age_from_date($focus_student.birthday.value) if $focus_student.birthday.value
        
        
        id_array.push([a1.to_s,b1.to_s])
        id_array.push([a2.to_s,b2.to_s])
        id_array.push([a3.to_s,b3.to_s])
        id_array.push([a4.to_s,b4.to_s])
        id_array.push([a5.to_s,b5.to_s])
        id_array.push([a6.to_s,b6.to_s])
        #id_array.push([a7.to_s,b7.to_s])
        
        output = $tools.table(
            :table_array    => id_array,
            :unique_name    => "demo_section_id",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
        #CSS
        output << "<style>"
            
            output << "table#demo_section_id{
                width       : 80%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            output << "table#demo_section_id                     td{ width:50%;                                          }"
            output << "table#demo_section_id            td.column_0{ vertical-align:middle; text-align:left;             }"
            output << "table#demo_section_id            td.column_1{ vertical-align:middle; text-align:right;            }"
            output << "table#demo_section_id             td.odd_row{ vertical-align:middle; font-weight:normal;          }"
            output << "table#demo_section_id            td.even_row{ vertical-align:middle;                              }"
            output << "table#demo_section_id                     th{ width:300px; border-bottom: 1px solid #000000;      }"
            
        output << "</style>"
        
        return output
    end
    
    def team_members
        
        output      = String.new
        team_array  = Array.new
        
        team_records = $focus_student.related_team_records
        team_records.each{|record|
            
            t = $team.by_sams_id(record.fields["staff_id"].value)
            if t
                
                if !record.fields["role"].value.nil?
                    record.fields["role"].value = record.fields["role"].value.gsub(
                        "Teacher - Middle School",    "MS - #{record.fields["role_details"].value}"
                    ).gsub(
                        "Teacher - High School",      "HS - #{record.fields["role_details"].value}"
                    ).gsub(
                        "Teacher - Elementary School","EL - #{record.fields["role_details"].value}"
                    )
                else
                    record.fields["role"].value = "Role not Specified!! ELBERT!!!"
                end
                
                
                team_array.push(
                    
                    [
                        record.fields["role"].web.label+
                        t.preferred_email.to_email_link(:text=>t.legal_first_name.value + " " + t.legal_last_name.value,:subject=>"Student ID: #{$focus_student.student_id.value}",:content=>"")
                        
                    ]
                    
                )
                
            end
            
        } if team_records
        
        output << "<DIV style='height:120px; overflow:auto;'>"
            
            output << $tools.table(
                :table_array    => team_array,
                :unique_name    => "demo_section_team",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
        output << "</DIV>"
        
        #CSS
        output << "<style>"
            
            output << "table#demo_section_team{
                width       : 80%;
                font-size   : x-small;
                text-align  : center;
                margin-left : auto;
                margin-right: auto;
            }"
            
            output << "table#demo_section_team             div.day { display:inline-block; width:20%;  text-align:center;}"
            output << "table#demo_section_team         td.column_0 { width:20%; vertical-align:middle; text-align:left;  }"
            output << "table#demo_section_team         td.column_1 { width:60%; vertical-align:middle; text-align:left;  }"
            #output << "table#demo_section_team                  td { border-bottom: 1px groove black; }"
            output << "select#field_id__2__STUDENT_SPECIALIST_MATH__team_id     { width:100%;                            }"
            output << "select#field_id__2__STUDENT_SPECIALIST_READING__team_id  { width:100%;                            }"
            
        output << "</style>"
        
    end
  
    def team_email_link
        
        team_email_addresses = Array.new
        
        team_records = $focus_student.related_team_records
        team_records.each{|record|
            
            t = $team.by_sams_id(record.fields["staff_id"].value)
            if t
                team_email_addresses.push(t.preferred_email.value) if !team_email_addresses.include?(t.preferred_email.value)
            end 
            
        } if team_records
        
        if !team_email_addresses.empty?
            return $field.new(
                "field"     => "email_team",
                "value"     => team_email_addresses.join(";")
            ).to_email_link(
                :subject    => "#{$focus_student.studentfirstname.value} #{$focus_student.studentlastname.initial} #{$focus_student.student_id.value}",
                :content    => "",
                :class      => "ui-icon ui-icon-mail-closed",
                :style      => "display:inline-block; margin-left:5px;"
            )
        else
            return false
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MENU
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def menu_section
        
        output  = String.new
        
        output << "<input type='hidden' id='page'   name='page' value=''        >"
        output << "<input type='hidden' id='sid'    name='sid'  value='#{$focus_student.student_id.value}' >"
        
        field_class     = "smenu_top ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
        
        output << $field.new("value"=>"Academic Plan"           ).web.button(:onclick=>"$('#page').val('Student_Attendance_AP_Web'              );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_attendance_ap.is_true?
        output << $field.new("value"=>"Assessments"             ).web.button(:onclick=>"$('#page').val('STUDENT_ASSESSMENTS_WEB'                );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_assessments.is_true?
        output << $field.new("value"=>"Attendance"              ).web.button(:onclick=>"$('#page').val('STUDENT_ATTENDANCE_WEB'                 );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_attendance.is_true?
        output << $field.new("value"=>"Individual Learning Plan").web.button(:onclick=>"$('#page').val('STUDENT_ILP_WEB'                        );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_ilp.is_true?
        output << $field.new("value"=>"Ink Orders"              ).web.button(:onclick=>"$('#page').val('INK_ORDERS_WEB'                         );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_ink_orders.is_true?
        output << $field.new("value"=>"ISP"                     ).web.button(:onclick=>"$('#page').val('STUDENT_ISP_WEB'                        );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_isp.is_true?
        output << $field.new("value"=>"No Call Requests"        ).web.button(:onclick=>"$('#page').val('DNC_STUDENTS_WEB'                       );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_dnc_students.is_true?
        output << $field.new("value"=>"Notes"                   ).web.button(:onclick=>"$('#page').val('Student_Contacts_Web'                   );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_contacts.is_true?
        output << $field.new("value"=>"Psychological Evaluation").web.button(:onclick=>"$('#page').val('STUDENT_PSYCHOLOGICAL_EVALUATION_WEB'   );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_psychological_evaluation.is_true?
        output << $field.new("value"=>"PSSA Records"            ).web.button(:onclick=>"$('#page').val('PSSA_ENTRY_WEB'                         );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_pssa_entry.is_true?
        output << $field.new("value"=>"Record Requests"         ).web.button(:onclick=>"$('#page').val('RECORD_REQUESTS_WEB'                    );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_record_requests.is_true?
        output << $field.new("value"=>"RTII Behavior"           ).web.button(:onclick=>"$('#page').val('Student_RTII_Web'                       );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_rtii.is_true?
        output << $field.new("value"=>"Sales Force"             ).web.button(:onclick=>"$('#page').val('STUDENT_SALES_FORCE_WEB'                );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_sales_force_case.is_true?
        output << $field.new("value"=>"Specialists"             ).web.button(:onclick=>"$('#page').val('STUDENT_SPECIALISTS_WEB'                );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_specialists.is_true?
        output << $field.new("value"=>"TEP"                     ).web.button(:onclick=>"$('#page').val('Tep_Agreements_Web'                     );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_tep_agreements.is_true?
        output << $field.new("value"=>"Test Events"             ).web.button(:onclick=>"$('#page').val('STUDENT_TESTS_WEB'                      );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_student_tests.is_true?
        output << $field.new("value"=>"Withdraw Records"        ).web.button(:onclick=>"$('#page').val('WITHDRAW_REQUESTS_WEB'                  );send_unsaved();clear_student_record_content();send_covered('sid');",    :field_class=>field_class, :no_div=>true ) if $team_member.super_user? || $team_member.rights.module_withdraw_requests.is_true?
        
        #output << $field.new("value"=>"Documents"               ).web.button(:onclick=>"$('#page').val('Student_Documents_Web'       );send('sid');",    :field_class=>field_class, :no_div=>true )
        #output << $field.new("value"=>"Testing Event"           ).web.button(:onclick=>"$('#page').val('Student_Tests_Web'           );send('sid');",    :field_class=>field_class, :no_div=>true )
        
        
        #CSS
        output << "<style>"
            
            output << "button.smenu_top    { width: 125px; float:right; clear:both; font-size: xx-small !important;}"
            
        output << "</style>"
        
        return output
        
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MENU_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    def tiers
        
        tiers = [{:name=>"Tier 1",:value=>"Tier 1"},{:name=>"Tier 2",:value=>"Tier 2"},{:name=>"Tier 3",:value=>"Tier 3"}]
        
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