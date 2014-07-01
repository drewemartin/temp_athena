#!/usr/local/bin/ruby

class ATTENDANCE_RECORD_PDF

    #---------------------------------------------------------------------------
    def initialize()
    end
    #---------------------------------------------------------------------------
    
    def set_fonts(pdf)
        
        pdf.font_families.update("Arial" => {
            :normal      => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
            :italic      => "c:/windows/fonts/ariali.ttf",
            :bold        => "c:/windows/fonts/arialbd.ttf",
            :bold_italic => "c:/windows/fonts/arialbi.ttf"
        })
        
        pdf.font "Arial"
        
        pdf.fallback_fonts ["#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"]
        
        return pdf
        
    end
    
    def generate_pdf(sid, pdf = nil)
        
        s   = $students.get(sid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        
        render_required = false
        
        if !pdf
            render_required = true
            file_name = "#{s.studentlastname.to_user}_#{s.studentfirstname.to_user}_#{sid}_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Attendance_Record")
            pdf       = Prawn::Document.new
        end
        
        set_fonts(pdf)
        
        #DOCUMENT GRID
        pdf.define_grid(:columns => 2, :rows => 40)
        
        #MAIN BOUNDING BOX
        pdf.bounding_box([0, 730], :width => 530, :height => 700) do
            #pdf.stroke_bounds
            
            #SCHOOL LOGO
            pdf.grid([0,0], [4,0]).bounding_box do
                #pdf.stroke_bounds
                pdf.image logo_path, :width => 200, :height => 60
            end
            
            #PLACE THE ADDRESS
            pdf.grid([0,1], [4,1]).bounding_box do
                #pdf.stroke_bounds
                address_str =
                    "AGORA CYBER CHARTER SCHOOL
                    995 Old Eagle School Road
                    Suite 315
                    Wayne, PA 19087
                    ph 610.254.8218
                    fx 610.254.8939
                    www.agora.org"
                pdf.text address_str, :align => :right, :size => 7.5
            end
            
            pdf.grid([5,0], [6,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.text "<b>Student Attendance Information</b>", :align => :center, :size => 18, :inline_format=>true
            end
            
            pdf.grid([7,0], [8,1]).bounding_box do
                date_str = "Date: #{Time.now.strftime("%m/%d/%Y")}"
                pdf.text date_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([9,0], [10,1]).bounding_box do
                student_name_str = "Student Name: #{s.studentfirstname.to_user} #{s.studentlastname.to_user}"
                pdf.text student_name_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([11,0], [12,1]).bounding_box do
                student_id_str = "Student ID: #{s.student_id.value}"
                pdf.text student_id_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([13,0], [14,1]).bounding_box do
                student_dob_str = "Student DOB: #{s.birthday.to_user}"
                pdf.text student_dob_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([15,0], [16,1]).bounding_box do
                advise_str = "<b><u>Please be advised that the above named student was in attendance at Agora Cyber Charter School."
                advise_str << " The student attendance is as follows for the #{$school.current_school_year} school year:</u></b>"
                pdf.text advise_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([17,0], [18,1]).bounding_box do
                total_days_enrolled_str = "Total Days Enrolled: #{$students.attach(s.student_id.value).attendance.enrolled_days.length}"
                pdf.text total_days_enrolled_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([19,0], [20,1]).bounding_box do
                total_days_present_str = "Total Days Present: #{$students.attach(s.student_id.value).attendance.attended_days.length}"
                pdf.text total_days_present_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([21,0], [22,1]).bounding_box do
                total_days_absent_str = "Total Days Absent: #{$students.attach(s.student_id.value).attendance.excused_absences.length + $students.attach(s.student_id.value).attendance.unexcused_absences.length}"
                pdf.text total_days_absent_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([23,0], [24,1]).bounding_box do
                total_days_excused_str = "Total Days Excused: #{$students.attach(s.student_id.value).attendance.excused_absences.length}"
                pdf.text total_days_excused_str, :align => :left, :size => 12, :inline_format => true
            end
            
            pdf.grid([25,0], [26,1]).bounding_box do
                total_days_unexcused_str = "Total Days Unexcused: #{$students.attach(s.student_id.value).attendance.unexcused_absences.length}"
                pdf.text total_days_unexcused_str, :align => :left, :size => 12, :inline_format => true
            end
            
            total_unexcused = $students.attach(s.student_id.value).attendance.unexcused_absences.length
            
            if total_unexcused > 0
                
                pdf.grid([27,0], [28,1]).bounding_box do
                    unexcused_days_str = "Unexcused Days:"
                    pdf.text unexcused_days_str, :align => :left, :size => 12, :inline_format => true
                end
                
                columns = 6
                rows = (total_unexcused/columns.to_f).ceil
                
                dates = $students.attach(s.student_id.value).attendance.unexcused_absences
                
                pdf.define_grid(
                    :columns       => columns,
                    :rows          => rows,
                    :column_gutter => 16,
                    :row_gutter    => 10
                )
                
                h=29
                i=0
                while i < rows do
                    j=0
                    w=0
                    if i+h >= 40
                        pdf.start_new_page
                        h=0
                    end
                    while j < columns
                        pdf.grid([i+h,w], [i+h+1,w]).bounding_box do
                            
                            #pdf.stroke_bounds
                            pdf.move_down 5
                            
                            if date = dates.delete_at(0)
                                date = Date.parse("#{date}").strftime("%m/%d/%Y")
                                text = "#{date}"
                                
                                pdf.text text, :size => 10, :inline_format => true
                            else
                                
                                j = columns + 1
                                i = rows    + 1
                                
                            end
                            
                        end
                        w+=(1/3.0)
                        j+=1
                    end
                    i+=1
                end
                
                x = i+h
                if x >= 40
                    pdf.start_new_page
                    x=2
                end
                
                pdf.grid([x,0], [x+1,1]).bounding_box do
                    contact_str = "Should you have any questions regarding attendance, please contact"
                    contact_str << " Ashley Pickens at (610) 230-0782."
                    pdf.text contact_str, :align => :left, :size => 12, :inline_format => true
                end
            else
                pdf.grid([27,0], [28,1]).bounding_box do
                    contact_str = "Should you have any questions regarding attendance, please contact"
                    contact_str << " Ashley Pickens at (610) 230-0782."
                    pdf.text contact_str, :align => :left, :size => 12, :inline_format => true
                end
            end
        end
        pdf.render_file "#{file_path}#{file_name}" if render_required
    end
end