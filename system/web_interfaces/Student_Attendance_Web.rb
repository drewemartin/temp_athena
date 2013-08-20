#!/usr/local/bin/ruby


class STUDENT_ATTENDANCE_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        @code_choices = $tables.attach("Attendance_Codes").dd_choices("code", "code", " WHERE `code` IS NOT NULL ORDER BY `code_type`, `code`  ASC ")
        @code_choices.each{|y|
            y[:value] = "pr" if y[:name] == "pt"
            y[:value] = "pr" if y[:name] == "pap"
            y[:value] = "pr" if y[:name] == "p"
            y[:value] = "ur" if y[:name] == "u"
            y[:value] = "ur" if y[:name] == "ut"
            y[:value] = "ur" if y[:name] == "uap" 
        }
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = addable_day_choices ? $tools.button_new_row(
            table_name              = "STUDENT_ATTENDANCE",
            additional_params_str   = "sid",
            save_params             = "sid"
        ) : ""
        
        how_to_button = $tools.button_how_to("How To: How Attendance Is Decided", "How To: How Attendance Is Decided")
        
        "Attendance#{how_to_button}#{new_contact_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        if $kit.params[:student_id]
            sid = $kit.params[:student_id]
            student_record(sid)
        elsif $kit.params[:refresh]
            working_list(false)
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STUDENT_RECORD_AND_WORKING_LIST
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        output                  = String.new
        
        sid                     = $focus_student.student_id.value
        student                 = $students.attach(sid)
        
        #output << $tools.student_demographics(student)
        
        if student.attendance.record
            
            how_to_button_attendance_override = $tools.button_how_to("How To: Attendance Override")
            
            output << $focus_student.attendance_mode.attendance_mode.web.select({:label_option=>"#{how_to_button_attendance_override} Override Student Attendance Mode", :dd_choices=>modes_dd}, true)
            
            attendance_records = $tables.attach("Student_Attendance").by_studentid_old(sid)
            weeks = attendance_weeks(sid)
            weeks.each do |week|
                week_number = week[0]
                dates = week[1]
        
                output << $tools.newlabel("week", "Week ##{week_number}")
                output << $tools.div_open("weekdays_div")
                dates.each do |date|
                    if !date.nil?
                        date_string = date.first
                        output << $tools.div_open("weekday_div")
                        output << $tools.div_open("day_header")
                        output << $tools.newlabel("dotw", Date.parse(date_string).strftime("%a"))
                        output << $tools.newlabel("att_date", Date.parse(date_string).strftime("%m/%d/%y"))
                        output << $tools.div_close()
                        if date.last
                            date_record = $tables.attach("Student_Attendance").by_studentid_old(sid, date.first)
                            fields = date_record.fields
                            
                            disabled = fields["complete"].is_true?
                            
                            #how_to_button_attendance_modes = $tools.button_how_to("How To: Attendance Modes")
                            
                            output << fields["mode"].web.select({:label_option=>"Mode", :dd_choices=>modes_dd, :disabled=>disabled}, true)
                            
                            if fields["code"].value
                                #CLEAN UP ATTENDANCE LOG STRING
                                fields["code"].value = fields["code"].gsub(",","<BR>")
                                fields["code"].value = fields["code"].gsub("p-k12_elluminate_session",  "Blackboard")
                                fields["code"].value = fields["code"].gsub("p-k12_lessons_count_daily", "OLS")
                                fields["code"].value = fields["code"].gsub("p-k12_hs_activity",         "LMS")
                                fields["code"].value = fields["code"].gsub("p-k12_ecollege_activity",   "LMS2")
                                fields["code"].value = fields["code"].gsub("p-k12_logins",              "Logged In")
                            
                            end
                            output << $tools.newlabel("activity", "Activity Log")
                            output << fields["code"].web.label()
                            
                        else
                            output << $tools.newlabel("no_record", "No Attendance Record")
                        end
                    else
                        output << $tools.div_open("weekday_div")
                        output << $tools.div_open("day_header")
                        output << $tools.div_close
                    end
                    
                    #how_to_button_attendance_codes = $tools.button_how_to("How To: Attendance Codes")
                    
                    attendance_code = date_string ? $tables.attach("STUDENT_ATTENDANCE_MASTER").field_bystudentid("code_#{date_string}", sid):false
                    output << attendance_code.web.select({:label_option=>"Code", :dd_choices=>@code_choices, :add_class=>"code", :disabled=>disabled}, false, true) if !attendance_code.nil? && attendance_code
                    output << $tools.div_close()
                end
        
                output << $tools.div_close
            end
        else
            output << $tools.newlabel("no_record", "There are no attendance records for this student.")
        end
        
        return output
        
    end
    
    def add_new_record_student_attendance()
        
        output  = String.new
        
        sid                     = $focus_student.student_id.value
        student = $students.attach(sid)
        fields  = student.new_row("Student_Attendance").fields
        
        mode    = $tables.attach("student_attendance_mode").current_mode_by_studentid(sid).value
        sources = $tables.attach("attendance_modes").sources_by_mode(mode)
        fields["mode"].value = mode
        fields["sources"].value = sources.value if sources
        
        output << fields["student_id"   ].web.hidden()
        output << fields["date"         ].web.select({:dd_choices=>addable_day_choices})
        output << fields["mode"         ].web.hidden()
        #attendance_record = student.attendance.record.fields[date_string]
        #output << attendance_record.web.select({:label_option=>"Code", :dd_choices=>@code_choices})
        #output << fields["code"         ].web.select({:label_option=>"Code", :dd_choices=>@code_choices})
        output << fields["sources"      ].web.hidden()
        
        return output
    end
    
    def attendance_weeks(sid)
        #Get All Student Attendance Dates
        attendance_dates = Array.new
        attendance_records = $tables.attach("Student_Attendance").by_studentid_old(sid)
        attendance_records.each do |record|
            fields = record.fields
            date_string = fields["date"].value
            attendance_dates.push(date_string)
        end
        
        #Generate Array of all school days, marking if student has a record for that day
        attendance_weeks = Hash.new{|h,k| h[k] = [nil, nil, nil, nil, nil]}
        @first_cweek       = nil
        @fall_winter_weeks = nil
        @this_sweek        = false
        $school.school_days.each_with_index do |school_date, i|
            date = Date.parse(school_date)
            if i==0
                @first_cweek = date.cweek
                @fall_winter_weeks = 52-@first_cweek
            end
            if date.cweek >= @first_cweek
                sweek = date.cweek - @first_cweek + 1
            else
                sweek = date.cweek + @fall_winter_weeks
            end
            if date.cweek == Date.today.cweek - 1
                @this_sweek = sweek
            end
            has_record = attendance_dates.include?(school_date) ? true : false
            index = date.wday() - 1
            attendance_weeks["#{sweek}"][index] = [school_date, has_record]
        end
        
        #Puts current week at the top
        weeks_array = attendance_weeks.sort_by{|number, date| number.to_i}
        if @this_sweek
            this_week = weeks_array.delete_at(@this_sweek)
            weeks_array.insert(0, this_week)
        end
        return weeks_array
    end
    
    def addable_day_choices
        students_days       = Array.new
        addable_days_dd     = Array.new
        attendance_records  = $focus_student.attendance.existing_records
        attendance_records.each{|record|
            students_days << record.fields["date"].value
        } if attendance_records
        
        addable_days = $school.school_days($base.today.iso_date) || []
        addable_days -= students_days
        if !addable_days.empty?
            addable_days.each do |day|
                addable_days_dd << {:name=>day,:value=>day}
            end
            return addable_days_dd
        else
            return false
        end
        
    end
    
    def student_link_params(sid)
        student = $students.attach(sid)
        student_link_params = {
            :link_text      => student.fullname.to_web,
            :field_class    => "student_link",
            :field_name     => "sid",
            :onclick        => "select_student"
        }
        return student_link_params
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
# These should be encapsulated results that could be called from other
# interfaces to easily mix and match results.
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def modes_dd
        return $tables.attach("ATTENDANCE_MODES").dd_choices("mode","mode")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        
        output << "
        #new_row_button_STUDENT_ATTENDANCE{                     float:right; font-size: xx-small !important;}
        
        div.weekdays_div{                                       clear:left; margin-left:auto; margin-right:auto; margin-bottom:15px; display:table;}
        div.weekday_div{                                        float:left; margin-left:1px; margin-right:1px; width:175px; height:210px; border: 1px solid black; border-radius:5px;}
        div.week{                                               clear:left; margin-left:65px; margin-top:10px; margin-bottom:5px;}
        div.day_header{                                         float:left; clear:left; width:169px; height:18px; padding:3px; background-color:#3BAAE3; border-bottom: 1px solid black; border-top-left-radius:5px; border-top-right-radius:5px;}
        div.dotw{                                               float:left; color:white;}
        div.att_date{                                           float:right; color:white;}
        div.STUDENT_ATTENDANCE_MODE__attendance_mode{           clear:left; margin-bottom:10px; margin-left:65px;}
        div.STUDENT_ATTENDANCE__mode{                           width:150px; margin-left:auto; margin-right:auto; margin-top:5px; text-align:center;}
        div.STUDENT_ATTENDANCE__code{                           width:160px; height:80px; margin-left:auto; margin-right:auto; text-align:center; border: 1px solid black; overflow-y:scroll; background-color:white}
        div.code{                                               width:60px; margin-left:auto; margin-right:auto; margin-top:5px; text-align:center;}
        div.activity{                                           width:150px; margin-left:auto; margin-right:auto; margin-top:5px; text-align:center;}

        div.incomplete_title{                                   float:left; clear:left; margin-left:10px; font-size:1.2em;}
        div.complete_title{                                     float:left; clear:left; margin-left:10px; font-size:1.2em;}
        
        div.item_container{                                     float:left; clear:left; width:1000px; height:200px; margin:5px 0px 20px 10px; border:1px solid #386E8B; border-radius: 5px 5px; overflow-y:scroll;}
        div.bgdiv{                                              background:url('/athena/images/row_separator_25px.png') repeat left top; min-height:200px;}
        div.overlay{                                            box-shadow: inset 1px 0px 15px #869BAC; height:200px; width:1000px; position:fixed; pointer-events: none;}
        div.list_item{                                          float:left; clear:left; margin:5px 15px; height:15px;}
        div.USER_ACTION_ITEMS__student_id{                      float:left; width:70px; margin-top:-1px;}
        div.USER_ACTION_ITEMS__action{                          float:left; width:215px; height:20px; margin-top:-1px;}
        div.USER_ACTION_ITEMS__created_date{                    float:left; width:190px; margin-top:-1px;}
        div.USER_ACTION_ITEMS__completed{                       float:left; margin-top:-2px;}
        div.student_link{                                       width:250px;}
        body{                                                   line-height:16px;}
        "
        
        output << "</style>"
        return output
        
    end
    
end