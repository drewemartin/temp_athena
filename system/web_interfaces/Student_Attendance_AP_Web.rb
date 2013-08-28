#!/usr/local/bin/ruby


class STUDENT_ATTENDANCE_AP_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
        dates = $school.school_days(cutoff_date = $base.today.to_db.split(" ").first, order_option = "DESC")   
        @dates = dates ? dates.shift(2) : []
        
        sids  = $team_member.assigned_students(:ap_attendance_dates=>@dates.join("|")) if !@dates.empty?
        @sids = sids ? sids : []
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        how_to_button_academic_plan = $tools.button_how_to("How To: Academic Plan")
        
        "Academic Plan #{how_to_button_academic_plan}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        #if $kit.params[:student_id]
        #    output = student_record
        #    $kit.modify_tag_content("tabs-2", output, "update")
        #end
        student_record if $focus_student
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        output  = String.new
        
        sid     = $focus_student.student_id.value
        
        student = $students.attach(sid)
        
        dates   = $tables.attach("STUDENT_ATTENDANCE_AP").schooldays_by_studentid(sid)
        
        if dates
            
            tables_array = [
                
                #HEADERS
                [
                    "Team Member"
                ]
                
            ]
            dates.each{|date| tables_array[0].push(date)}
            
            staff_ids = $tables.attach("STUDENT_ATTENDANCE_AP").staffids_by_studentid(sid)
            staff_ids.each{|staff_id|
                
                row = Array.new
                
                row.push(teacher_group(staff_id, sid))
                
                dates.each{|date|
                    
                    disabled   = true #unless date == $base.today.iso_date
                    if record  = $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(sid, staff_id, date)
                        
                        row.push(attendance_group(record, disabled))  
                        
                    else
                        
                        row.push("")
                        
                    end
                    
                }
                
                tables_array.push(row)
                
            } 
            
            output << $kit.tools.data_table(tables_array, "student_attendance_ap")
            
        else
            
            output << $tools.newlabel("no_record", "This student does not have any Academic Plan records.")
            
        end
        
        return output
        
    end
    
    def working_list
        
        if $team_member.enrolled_students(:ap_attendance_dates=>@dates)
           
            output = Array.new
            
            how_to_button_ap_attendance = $tools.button_how_to("How To: AP Attendance")
            
            output.push(
                :name       => "AP Attendance (#{@sids.length}) #{how_to_button_ap_attendance}",
                :content    => css + expand_academic
                
            )
            
            return output
            
        end
        
    end 

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def expand_academic
        
        output = String.new
        
        tables_array = [
            
            #HEADERS
            [
                "Student ID",
                "First Name",
                "Last Name"
            ]
            
        ]
        
        @dates.each{|date| tables_array[0].push(date)}
        
        @sids.each{|sid|
            
            disabled = false
            
            sams_ids = $team_member.sams_ids.existing_records
            sams_ids.each{|samsid_record|
                
                samsid = samsid_record.fields["sams_id"].value
                if $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(sid, samsid)
                    
                    row = Array.new
                    
                    row.push(sid)
                    row.push($students.get(sid).studentfirstname.value)
                    row.push($students.get(sid).studentlastname.value )
                    
                    @dates.each{|date|
                        
                        if record = $tables.attach("STUDENT_ATTENDANCE_AP").by_studentid_old(sid, samsid, date)
                            
                            row.push(attendance_group(record, disabled))
                            
                        else
                            
                            row.push("")
                            
                        end
                        
                    }
                    
                    tables_array.push(row)
                    
                end
                
            } if sams_ids
            
        } if @sids
        
        output << $kit.tools.data_table(tables_array, "student_attendance_ap2")
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def attendance_group(record, disabled = false)
        
        att_group = String.new
        
        att_group << "<div class='att_group'>"
            
            att_array = Array.new
            
            att_array.push(
                [
                    "Activity",
                    "Required",
                    "Engaged"
                ]
            )
            att_array.push(
                [
                    "Live Session Attendance",
                    record.fields["live_session_attended_required"          ].web.default(:disabled=>disabled),
                    record.fields["live_session_attended_engaged"           ].web.default(:disabled=>disabled)
                ]
            )
            att_array.push(
                [
                    "Live Session Participation",
                    record.fields["live_session_participated_required"      ].web.default(:disabled=>disabled),
                    record.fields["live_session_participated_engaged"       ].web.default(:disabled=>disabled)
                ]
            )
            att_array.push(
                [
                    "Help Session",
                    record.fields["help_session_required"                   ].web.default(:disabled=>disabled),
                    record.fields["help_session_engaged"                    ].web.default(:disabled=>disabled)
                ]
            )
            att_array.push(
                [
                    "Office Hours",
                    record.fields["office_hours_required"                   ].web.default(:disabled=>disabled),
                    record.fields["office_hours_engaged"                    ].web.default(:disabled=>disabled)
                ]
            )
            att_array.push(
                [
                    "Assignment Completion",
                    record.fields["assignment_completion_required"          ].web.default(:disabled=>disabled),
                    record.fields["assignment_completion_engaged"           ].web.default(:disabled=>disabled)
                ]
            )
            att_array.push(
                [
                    "Assessment Completion",
                    record.fields["assessment_completion_requied"           ].web.default(:disabled=>disabled),
                    record.fields["assessment_completion_engaged"           ].web.default(:disabled=>disabled)
                ]
            )
            
            att_group << $tools.table(
                :table_array    => att_array,
                :unique_name    => "daily_att",
                :footers        => false,
                :head_section   => true,
                :title          => false,
                :caption        => record.fields["date"].to_user
            )
            
            att_group << record.fields["attended"].web.select(
                :disabled=>disabled,
                :label_option=>"<b>Marked student present for this course today?</b>",
                :dd_choices=>[
                    {:name=>"Yes", :value=>"1" },
                    {:name=>"No",  :value=>"0" }
                ]
            )
            
            att_group << record.fields["notes"].web.default(:disabled=>disabled, :label_option=>"<b>Notes:</b>")
            
        att_group << "</div>"
        
        return att_group
        
    end
    
    def teacher_group(staff_id, sid)
        
        table_array = Array.new
        
        staff_name = $team.by_sams_id(staff_id).full_name
        
        table_array.push([staff_name ? "<b>#{staff_name}</b>" : "Not Found"])
        
        relate_records = $tables.attach("STUDENT_RELATE").by_staffid(staff_id, sid, active = true)
        relate_records.each{|record|
            table_array.push([record.fields["role"           ].value])
            table_array.push([record.fields["role_details"   ].value])
        } if relate_records
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "teacher_group",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
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
        
            div.att_group                                                   { margin-left:auto; margin-right:auto; width:300px; margin-bottom:2px; margin-top:2px;}
            div.STUDENT_ATTENDANCE_AP__attended                             { float:left;  margin-top:10px; margin-bottom:10px; margin-left:8px;}
            div.STUDENT_ATTENDANCE_AP__notes                                { float:left;  width:300px; margin-left:8px;}
            div.STUDENT_ATTENDANCE_AP__notes                        textarea{ width:290px; margin-bottom:15px; resize:none;}
            div.STUDENT_ATTENDANCE_AP__live_session_attended_required       {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__live_session_participated_required   {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__help_session_required                {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__office_hours_required                {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__assignment_completion_required       {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__assessment_completion_requied        {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__live_session_attended_engaged        {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__live_session_participated_engaged    {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__help_session_engaged                 {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__office_hours_engaged                 {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__assignment_completion_engaged        {margin-left:auto; margin-right:auto; width:21px;}
            div.STUDENT_ATTENDANCE_AP__assessment_completion_engaged        {margin-left:auto; margin-right:auto; width:21px;}
            table#teacher_group                                             { width:150px; text-align:center;}
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