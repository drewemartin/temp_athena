#!/usr/local/bin/ruby

class RECORD_REQUESTS_PDF

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
    
    def confirmed_batch(group=true)
        completed_batch_pdf = Prawn::Document.new
        #sids=["1038176", "767108"]
        sids = $db.get_data("
SELECT student_id
FROM `k12_omnibus`
WHERE (grade = '7th Grade'
OR grade = '8th Grade')
AND schoolenrolldate IS NOT NULL
AND schoolenrolldate <= CURDATE()
AND enrollapproveddate IS NOT NULL
ORDER BY grade, student_id"
).flatten
        #sids = $students.list(:currently_enrolled=>true, :grade=>"8th").sort_by(&:to_i)
        sids.each do |sid|
            if $tables.attach("Jupiter_Grades").by_studentid_old(sid)
                if group
                    generate_pdf(sid, completed_batch_pdf)
                    completed_batch_pdf.start_new_page
                else
                    generate_pdf(sid)
                end
            end
        end
        file_name = "7_8_Q3_Report_Cards_#{$ifilestamp}.pdf"
        file_path = $config.init_path("#{$paths.reports_path}Report_Cards")
        completed_batch_pdf.render_file("#{file_path}#{file_name}") if group
    end
    
    def generate_pdf(sid, pdf = nil)
        
        s   = $students.get(sid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        school_comment = "Quarter 3 Progress Report"
        
        render_required = false
        
        if !pdf
            render_required = true
            file_name = "#{s.studentlastname.to_user}_#{s.studentfirstname.to_user}_#{sid}_Q3_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Report_Cards/Individual")
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
                pdf.text address_str, :align => :right, :size => 8.5
            end
            
            pdf.grid([5,0], [6,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.text "<b>PERMANENT RECORDS REQUEST</b>", :align => :center, :size => 18, :inline_format=>true
            end
            
            pdf.grid([7,0], [8,1]).bounding_box do
                #pdf.stroke_bounds
                address_str =
"<b>Student Name: #{s.studentfirstname.to_user} #{s.studentlastname.to_user}
Date of Birth: #{s.birthday.to_user}, #{s.grade.to_user}</b>"
                pdf.text address_str, :align => :center, :size => 10, :inline_format=>true
            end
            
            pdf.grid([9,0], [11,1]).bounding_box do
                #pdf.stroke_bounds
                address_str =
"{SCHOOL NAME}
{SCHOOL ADD 1}
{SCHOOL ADD 2}
{SCHOOL CITY} {STATE} {ZIP}"
                pdf.text address_str, :align => :left, :size => 10
            end
            
            pdf.grid([12,0], [26,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 5
                address_str =
"<b>DISTRICT OF RESIDENCE:</b> #{s.districtofresidence.to_user} (district of responsibility)
<b>PREVIOUS SCHOOL: #{s.prevschoolname.to_user}</b> Guidance Office and/or Records Department
The above referenced student has enrolled with Agora Cyber Charter School on <b>#{s.schoolenrolldate.to_user}</b>.  In accordance with The Family Educational Rights and Privacy Act (FERPA) (20 U.S.C. \xC2\xA7 1232g; 34 CFR Part 99) we are requesting that the records be provided to Agora as a school which the student is transferring.   The student started Agora on #{s.schoolenrolldate.to_user}.
We are requesting the <b>ENTIRE</b> permanent records file including but not limited to the following records:
\xE2\x9C\x93 Cumulative Academic Records - Report Cards, Transcripts for (9-12 grades)
\xE2\x9C\x93 Attendance (including truancy documentation if applicable)
\xE2\x9C\x93 Pennsylvania System of School Assessment (PSSA/PSSAM/PASA)
\xE2\x9C\x93 Keystone Scores
\xE2\x9C\x93 SAT Scores
\xE2\x9C\x93 English Language Learners Information (ELL/WIDA/ESL)
\xE2\x9C\x93 PA Secure ID#
\xE2\x9C\x93 Dental, Health and Immunization Records
\xE2\x9C\x93 Special Education Documentation <b>(if applicable)</b>"
                pdf.text address_str, :align => :left, :size => 9.5, :inline_format=>true
            
                pdf.indent(25) do
                    address_str =
"-Individual Education Plan (IEP)
-Evaluation Reports (ER)
-Gifted Written Reports (GWR)
-Notice of Recommended Educational Placement (NOREP)
-Notice of Recommended Assignments (NORA)"
                    pdf.text address_str, :align => :left, :size => 9.5, :inline_format=>true
                end
            end
            
            pdf.grid([27,0], [31,1]).bounding_box do
                pdf.move_down 5
                pdf.dash(4,:space=>4, :phase=>0)
                pdf.stroke_bounds
                address_str = "Please send the information listed above via mail or fax to:"
                pdf.indent(5) do
                    pdf.text address_str, :align => :left, :size => 10, :inline_format=>true
                end
            end
            
            pdf.move_cursor_to 180
            pdf.indent(250) do
                pdf.text "<b>~or~</b>", :align => :left, :size => 10, :inline_format=>true
            end
            
            pdf.grid([29,0], [31,0]).bounding_box do
                pdf.move_down 5
                pdf.dash(1,:space=>0, :phase=>0)
                #pdf.stroke_bounds
                address_str =
"<b>Agora Cyber Charter School
Attention: Records
995 Old Eagle School Road, Suite 315
Wayne, PA 19087</b>"
                pdf.indent(5) do
                    pdf.text address_str, :align => :left, :size => 10, :inline_format=>true
                end
            end
            
            pdf.grid([29,1], [31,1]).bounding_box do
                pdf.move_down 12
                #pdf.stroke_bounds
                address_str = "<b>Fax - (610) 254-8939</b>"
                pdf.indent(70) do
                    pdf.text address_str, :align => :left, :size => 10, :inline_format=>true
                end
            end
            
            pdf.grid([32,0], [40,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 10
                address_str =
"Thank you in advance for your attention to this matter.  <b>If records are not available, please respond in writing to this request on your letterhead detailing why the request cannot be fulfilled.</b>  Should you have questions please feel free to contact Scott McDonnell at (610) 263-8490.

Should this information present a question regarding BILLING or Child Accounting please call (610) 254-8218.

Sincerely,
Office of the Registrar
Agora Cyber Charter School

cc: Student File"
                pdf.text address_str, :align => :left, :size => 9.5, :inline_format=>true
            end
            
            #INTACT STUDENT TAGS
            pdf.bounding_box([0, 25], :width => 535, :height => 25) do
                #STUDENT ID
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.student_id.value,
                        :align => :left,
                        :size => 10
                end
                #STUDENT LAST NAME
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.studentlastname.to_user,
                        :align => :center,
                        :size => 10
                end
                #STUDENT FIRST NAME
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.studentfirstname.to_user,
                        :align => :right,
                        :size => 10
                end
            end
            pdf.render_file "#{file_path}#{file_name}" if render_required
        end
    end
end