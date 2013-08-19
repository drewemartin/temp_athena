#!/usr/local/bin/ruby


class K6_PROGRESS_WEB
    #---------------------------------------------------------------------------
    def initialize()
        @testing = false
    end
    #---------------------------------------------------------------------------
    def load
        return $kit.tools.tabs([student_list, ["Masteries", "Please Select A Student"], ["Q1", "Please Select A Student"], ["Q2", "Please Select A Student"], ["Q3", "Please Select A Student"], ["Q4", "Please Select A Student"]])
    end
    
    def response
        if $kit.params[:sid]
            sid = $kit.params[:sid]
            progress_results(sid)
            return ""
        else
            return ""
        end
    end
    
    def student_list
        i=0
        row0 = "row0"
        row1 = "row1"
        output = String.new
        header = false
        users_students = $user.students(:k6)#.shift(10)
        if users_students
            users_students.each do |sid|
                row_number = i%2 == 0 ? row0 : row1
                s_web = $students.attach(sid).web
                teacher_list_row = s_web.progress.teacher_list_row(row_number)
                output << s_web.progress.teacher_list_row_header if !header
                output << teacher_list_row
                $students.detach(sid)
                header = true
                i+=1   
            end
            output << $tools.newlabel("bottom")
        else
            output << $tools.newlabel("message", "There are no students associated with this account.")
        end
        return "Students", output
    end
    
    #---------------------------------------------------------------------------
    def progress_results(studentid)
        student = $students.attach(studentid)
        if student
            student_progress     = student.progress
            quarters             = ["Q1","Q2","Q3","Q4"]
            student_demographics = $kit.tools.student_demographics(student)
            masteries            = "#{student_demographics} #{masteries_content(student_progress.masteries)}"
            $kit.modify_tag_content("tabs-2", masteries, "update")
            quarters.each_with_index do |q, i|
                student_progress.term   = q
                admin_verified          = student_progress.admin_verified?
                disabled                = (admin_verified || student_progress.term_closed?) ? true : false
                if student_progress.progress
                    progress                = quarters_content(student_progress, disabled)
                else
                    progress                = "No Progress For This Quarter"
                end
                quarter_results         = "#{student_demographics} #{progress}"
                $kit.modify_tag_content("tabs-#{i+3}", quarter_results, "update")
            end
        else
            $kit.modify_tag_content("tabs-2", "Not A Student", "update")
        end
        $students.detach(studentid)
    end
    #---------------------------------------------------------------------------
    def quarters_content(student, disabled = false)
        zero_three = [{:name=>"0", :value=>"0"},{:name=>"1", :value=>"1"},{:name=>"2", :value=>"2"},{:name=>"3", :value=>"3"}]
        verification = [{:name => "Not Reviewed", :value => "NULL"}, {:name => "Reviewed - Not Accepted", :value => "0"},{:name => "Reviewed - Accepted", :value => "1"}]
        
        form_content = ""
        form_content << $kit.tools.legend_open(                             "Attendance", "Attendance")
        form_content << student.days_present.web.text(                      {:label_option=>"Days Present:", :disabled=>true})
        form_content << student.absences_excused.web.text(                  {:label_option=>"Excused Absences:", :disabled=>true})
        form_content << student.absences_unexcused.web.text(                {:label_option=>"Unexcused Absences:", :disabled=>true})
        form_content << $kit.tools.legend_close()
        form_content << $kit.tools.legend_open(                             "Course Progress", "Course Progress")
        form_content << $kit.tools.newlabel(                                "subject",     "Subject")
        form_content << $kit.tools.newlabel(                                "progress",    "Progress")
        form_content << $kit.tools.newlabel(                                "subject",     "Subject")
        form_content << $kit.tools.newlabel(                                "progress",    "Progress")
        student_progress = student.progress
        if student_progress
            student_progress.each do |course|
                fields = course.fields
                form_content << fields["course_subject_school"].web.text(   {:disabled=>true})
                form_content << fields["progress"].to_user!.web.text(                {:disabled=>true})
            end
            form_content << student.comments.web.textarea(                  {:label_option=>"Comments", :disabled=>disabled})
        end
        form_content << $kit.tools.legend_close()
        form_content << $kit.tools.legend_open(                             "goals", "Goals")
        form_content << student.math_goals.web.textarea(                    {:label_option=>"Math Goals:", :disabled=>disabled} )
        form_content << student.reading_goals.web.textarea(                 {:label_option=>"Reading Goals:", :disabled=>disabled} )
        form_content << $kit.tools.legend_close()
        form_content << $kit.tools.legend_open(                             "expected_participation", "Expected Participation"      )
        form_content << student.adequate_progress.web.select(               {:dd_choices=>zero_three,  :label_option=>"Adequate Progress:", :disabled=>disabled} )
        form_content << student.assessment_completion.web.select(           {:dd_choices=>zero_three,  :label_option=>"Assessment Completion:", :disabled=>disabled} )
        form_content << student.work_submission.web.select(                 {:dd_choices=>zero_three,  :label_option=>"Work Submission:", :disabled=>disabled} )
        form_content << $kit.tools.legend_close()
        form_content << $kit.tools.legend_open(                             "verified", "Verified"      )
        if $user.is_k6_teacher?
            form_content << student.teacher_verified.web.select(            {:dd_choices=>verification, :label_option=>"Verification Status:", :disabled=>disabled})
        else
            form_content << student.admin_verified.web.select(              {:dd_choices=>verification, :label_option=>"Verification Status:", :disabled=>false})
        end
        form_content << $kit.tools.legend_close()
        if snapshot = student.masteries_snapshot
            form_content << $kit.tools.legend_open("masteries","Masteries")
            form_content << masteries_content(snapshot, disabled)
            form_content << $kit.tools.legend_close()
        end
        return form_content
    end
    #---------------------------------------------------------------------------
    def masteries_content(masteries, disabled=false)
        one_three = [{:name=>"1", :value=>"1"},{:name=>"2", :value=>"2"},{:name=>"3", :value=>"3"}]
        form_content    = ""
        reading_content = ""
        math_content    = ""
        writing_content = ""
        history_content = ""
        science_content = ""
        pe_content      = ""
        line_div        = "<DIV class = 'line_div'></DIV>"
        masteries.each do |mastery|
            fields = mastery.fields
            id = fields["mastery_id"].value
            mastery_description_fields = $tables.attach("K6_Mastery_Sections").by_primary_id(id).fields
            mastery_description = mastery_description_fields["description"].value
            mastery_field = $kit.tools.newlabel( "mastery_#{id} mastery", mastery_description)
            level_field = fields["mastery_level"].web.select({:dd_choices => one_three, :disabled=>disabled})
            mastery_row = "#{mastery_field}#{level_field}#{line_div}"
            
            case mastery_description_fields["content_area"].value
            when "Reading"
                reading_content << mastery_row
            when "Mathematics"
                math_content    << mastery_row
            when "Writing"
                writing_content << mastery_row
            when "History"
                history_content << mastery_row
            when "Science"
                science_content << mastery_row
            when "Physical Education"
                pe_content << mastery_field
                pe_content << fields["mastery_level"].web.text()
                pe_content << line_div
            end
        end
        if reading_content != ""
            legend_open  = $kit.tools.legend_open("sub", "Reading")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << reading_content << legend_close
        end
        if math_content != ""
            legend_open  = $kit.tools.legend_open("sub", "Mathematics")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << math_content << legend_close
        end
        if writing_content != ""
            legend_open  = $kit.tools.legend_open("sub", "Writing")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << writing_content << legend_close
        end
        if history_content != ""
            legend_open  = $kit.tools.legend_open("sub", "History")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << history_content << legend_close
        end
        if science_content != ""
            legend_open  = $kit.tools.legend_open("sub", "Science")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << science_content << legend_close
        end
        if pe_content != ""
            legend_open  = $kit.tools.legend_open("sub", "Physical Education")
            legend_close = $kit.tools.legend_close
            form_content << legend_open << pe_content << legend_close
        end
        return form_content
    end
    #---------------------------------------------------------------------------
    def demographic_content(student, q)
        form_content = ""
        name = "#{(student.first_name(q).value).gsub("'", "&#39;")} #{(student.last_name(q).value).gsub("'", "&#39;")}"
        form_content << $kit.tools.newlabel("name", "Name: #{name}")
        form_content << student.grade_level(q).web.newlabel(               "Grade Level:" )
        form_content << student.school_year(q).web.newlabel(               "School Year:" )
        form_content << student.enroll_date(q).web.newlabel(               "Enroll Date:" )
        return form_content
    end
    #---------------------------------------------------------------------------
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #div#preload { display: none; }
    #    .ui-tabs{display:none;}
    def css
        output = "<style>"
        output << "
        
        body{                                                   font-size: .9em !important;}
        
        div.teacher_header{                                     float:left; padding:2px; margin-left:475px;}
        div.admin_header{                                       float:left; padding:2px; margin-left:85px; }
        
        div.name_header{                                        float:left; padding:2px; margin-left:10px; width:320px;}
        
        div.id_header{                                          float:left; padding:2px; margin-left:20px; width:90px;}
        div.q1_header{                                          float:left; margin-left:20px;}
        div.q2_header{                                          float:left; margin-left:20px;}
        div.q3_header{                                          float:left; margin-left:20px;}
        div.q4_header{                                          float:left; margin-left:20px;}
        
        div.aq1_header{                                         float:left; margin-left:30px;}
        div.aq2_header{                                         float:left; margin-left:20px;}
        div.aq3_header{                                         float:left; margin-left:20px;}
        div.aq4_header{                                         float:left; margin-left:20px;}
        
        div.filler{                                             float:left; width:25px; height: 10px;}
        div.student_row{                                        float:left; clear:left; width:100%}
        div.student_link{                                       float:left; clear:left; width:350px;}
        div.student_link label{                                 display:inline-block; padding:3px; color:#00c; text-decoration:underline;}
        div.id_field{                                           float:left; padding:2px; margin-left:10px; width:72px; margin-top:1px;}
        div.v_status{                                           float:left; margin-left:29px; margin-top:3px; width:16px;}
        div.v_status_filler{                                    float:left; margin-left:25px; margin-top:3px; width:5px;}
        div.bottom{                                             clear:left;}
        div.submit{                                             clear:left; margin-left:5px; margin-bottom:10px;}
              
        div.student_progress{                                   position:relative; clear:left;}
        div.K6_Progress__days_present{                          float:left; clear:left;}
        div.K6_Progress__absences_excused{                      float:left; clear:left;}
        div.K6_Progress__absences_unexcused{                    float:left; clear:left;}
        div.k6_Progress__days_present label{                    width:200px; display:inline-block;}      
        div.k6_Progress__absences_excused label{                width:200px; display:inline-block;}      
        div.k6_Progress__absences_unexcused label{              width:200px; display:inline-block;}  
        input.K6_Progress__days_present{                        width:60px;}
        input.K6_Progress__absences_excused{                    width:60px;}
        input.K6_Progress__absences_unexcused{                  width:60px;}
        div.subject{                                            width:200px; float:left;}
        div.progress{                                           width:200px; float:left;}
        div.Student_Academic_Progress__course_subject_school{   width:200px; float:left;}
        div.Student_Academic_Progress__progress{                width:200px; float:left;}
        div.K6_Progress_Courses__course_subject_school{         width:200px; float:left;}
        div.K6_Progress_Courses__progress{                      width:200px; float:left;}
        input.Student_Academic_Progress__course_subject_school{ width:180px;}
        input.Student_Academic_Progress__progress{              width:180px;}
        input.K6_Progress_Courses__course_subject_school{       width:180px;}
        input.K6_Progress_Courses__progress{                    width:180px;}
        div.K6_Progress__comments textarea{                     width:800px; float:left; padding-top:2px; clear:left;}
        div.K6_Progress__comments label{                        width:800px; float:left; padding-top:2px; clear:left;}
        div.K6_Progress__math_goals{                            float:left; clear:left;}
        div.K6_Progress__math_goals label{                      width:140px; display:inline-block; vertical-align:top;}      
        div.K6_Progress__math_goals textarea{                   width:600px; height:200px; display:inline-block; overflow-x:hidden; overflow-y:scroll; resize:none;}      
        div.K6_Progress__reading_goals{                         float:left; clear:left;}
        div.K6_Progress__reading_goals label{                   width:140px; display:inline-block; vertical-align:top;}
        div.K6_Progress__reading_goals textarea{                width:600px; height:200px; display:inline-block; overflow-x:hidden; overflow-y:scroll; resize:none;}
        div.K6_Progress__adequate_progress{                     float:left; clear:left;}
        div.K6_Progress__adequate_progress label{               width:230px; display:inline-block;}  
        div.K6_Progress__assessment_completion{                 float:left; clear:left;}
        div.K6_Progress__assessment_completion label{           width:230px; display:inline-block;}      
        div.K6_Progress__work_submission{                       float:left; clear:left;}
        div.K6_Progress__work_submission label{                 width:230px; display:inline-block;} 
        div.K6_Progress__end_of_year_placement{                 float:left; clear:left;}
        div.K6_Progress_Verification__verification{             float:left; clear:left;}
        div.form_save{                                          clear:left; margin:15px;}
        
        div.K6_Progress_Mastery__mastery_level{                 float:right; height:40px; width:10%; padding:5px;}
        div.K6_Progress_Mastery__mastery_level select{          margin-left:15px;}
        div.K6_Progress_Mastery__mastery_level input{           display:inline; line-height:40px; width:60px;}
        div.K6_Progress_Mastery__mastery_level label{           display:inline; line-height:40px;}
        div.1{                                                  float:left; clear:left;}
        div.line_div{                                           float:left; clear:left; width:100%; height:1px; border-bottom: 1px solid #d1d1d1;}
        div.line_div:last-child{                                border-bottom:none;}
        div.K6_PROGRESS_MASTERY_SNAPSHOT__mastery_level{        float:right; height:40px; width:10%; padding:5px;}
        div.K6_PROGRESS_MASTERY_SNAPSHOT__mastery_level select{ margin-left:15px;}
        div.K6_PROGRESS_MASTERY_SNAPSHOT__mastery_level input{  display:inline; line-height:40px; width:60px;}
        div.K6_PROGRESS_MASTERY_SNAPSHOT__mastery_level label{  display:inline; line-height:40px;}
        "
        
        for i in (1..270)
        output << "
        div.mastery_#{i}{       display:table; float:left; clear:left; padding: 5px; width:85%; height:40px;}
        div.mastery_#{i} newlabel{ display:table-cell; vertical-align:middle; font-size:.8em;}"
        end
        
        output << "</style>"
        return output
    end
    
end