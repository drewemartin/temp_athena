#!/usr/local/bin/ruby

class REPORT_CARD_7_8_PDF

    #---------------------------------------------------------------------------
    def initialize()
    end
    #---------------------------------------------------------------------------
    
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
        s   = $students.attach(sid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        school_comment = "Quarter 3 Progress Report"
        
        render_required = false
        if !pdf
            render_required = true
            file_name = "#{s.last_name.value}_#{s.first_name.value}_#{sid}_Q3_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Report_Cards/Individual")
            pdf       = Prawn::Document.new
        end
        
        #DOCUMENT GRID
        pdf.define_grid(:columns => 2, :rows => 40, :gutter => 5)
        
        #MAIN BOUNDING BOX
        page_width = 520
        page_height = 700
        pdf.bounding_box([10, 725], :width => page_width, :height => page_height) do
            #pdf.stroke_bounds
            #SID & Grade
            pdf.grid([0,0], [0,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 3
                pdf.text "<b>Student ID:</b> #{sid}         <b>Grade:</b> #{s.grade.value}",
                    :inline_format => true,
                    :size          => 10
                pdf.stroke_horizontal_rule
            end
            
            #Date
            pdf.grid([0,1], [0,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 3
                pdf.text "<b>#{$base.date_usr($idate)}</b>",
                    :inline_format => true,
                    :align         => :right,
                    :size          => 10
                pdf.stroke_horizontal_rule
            end
            
            #SCHOOL LOGO
            pdf.grid([1,0], [4,0]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 8
                pdf.image logo_path,
                    :width  => 190,
                    :height => 50
            end
            
            #Comments
            pdf.grid([1,1], [4,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.text "<b>#{school_comment}</b>",
                    :inline_format => true,
                    :align         => :center,
                    :valign        => :center,
                    :size          => 12
            end
            
            #Attendance
            pdf.grid([5,0], [5,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.stroke_horizontal_rule
                days_present        = s.attendance.attended_days.length
                absences_excused    = s.attendance.excused_absences.length
                absences_unexcused  = s.attendance.unexcused_absences.length
                pdf.move_down 3
                pdf.text "<b>Present:</b> #{days_present}     <b>Excused:</b> #{absences_excused}     <b>Unexcused:</b> #{absences_unexcused}",
                    :inline_format => true,
                    :align         => :right,
                    :size          => 8
            end
            
            #Mailing Address
            pdf.grid([7,0], [10,0]).bounding_box do
                if s.mailing_address_line_two.value.downcase.match("do not")
                    puts sid
                    s.mailing_address_line_two.value = ""
                end if !s.mailing_address_line_two.value.nil?
                #pdf.stroke_bounds
                address = s.mailing_address.to_user
                address << ", #{s.mailing_address_line_two.to_user}" if !s.mailing_address_line_two.value.nil?
                city  = s.mailing_city.to_user
                state = s.mailing_state.to_user
                zip   = s.mailing_zip.to_user
                pdf.text "To the Parent/Guardians of:
#{s.first_name.to_user} #{s.last_name.to_user}
#{address}
#{city}, #{state} #{zip}",
                    :inline_format=>true,
                    :align  => :center,
                    :valign => :center,
                    :size   => 10
            end
        
            pdf.grid([7,1], [10,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.text "<b>#{$school.current_school_year.to_user} School Year</b>",
                    :inline_format=>true,
                    :align  => :center,
                    :valign => :center,
                    :size   => 14
            end
            
            pdf.move_down 20
            
            grades_header = [
                "<b>Course</b>",
                "<b>Teacher</b>",
                "<b>Progress</b>",
                "<b>%</b>",
                "<b>Comments</b>"
            ]
            
            grades_array = Array.new
            subjects = Hash.new
            records = $tables.attach("Jupiter_Grades").by_studentid_old(sid)
            records.each do |record|
                fields  = record.fields
                subject = fields["subject" ].value
                term    = fields["term"    ].value
                if !subjects.has_key?(subject)
                    subjects[subject] = {
                        "Yr" => {:teacher => nil, :mark => nil, :percent => nil, :comment => nil}
                    }
                end
                teacher = fields["teacher"].value.gsub(" ","").split(",") if fields["teacher"].value
                subjects[subject][term][:teacher] = "#{teacher[1]} #{teacher[0]}" if fields["teacher"].value
                subjects[subject][term][:mark   ] = fields["mark"   ].value
                subjects[subject][term][:percent] = fields["percent"   ].value ? "#{fields["percent"   ].value.to_f*100}%" : ""
                subjects[subject][term][:comment] = fields["comment"].value
            end if records
            
            subjects.each_pair do |subject, details|
                course_grades = Hash.new{|h,k| h[k]=""}
                teacher = String.new
                comment = String.new
                details.each_pair do|term, info|
                    if !info[:teacher].nil?
                        teacher              = info[:teacher]
                        course_grades[term]  = {"mark" => info[:mark], "percent" => info[:percent]}
                        comment              = info[:comment]
                    end
                end
                course_array = [
                    subject,
                    teacher,
                    course_grades["Yr"]["mark"],
                    course_grades["Yr"]["percent"],
                    comment
                ]
                grades_array.push(course_array)
            end
            grades_array.sort!
            
            #grades_array = [
            #    ["Course 1", "Mr. Mr.",     "A", "B", "C", "D", "E", "F", "U"],
            #    ["Course 2", "Mr. Smith",   "B", "A", "B", "S", "S", "C", "F"],
            #    ["Course 3", "Mr. Calahun", "C", "A", "C", "B", "A", "F", "D"]
            #]
            
            pdf.table(grades_array.insert(0,grades_header),
                :header         => true,
                :column_widths  => {0=>140, 1=>100, 2=>45, 3=>35, 4=>200},
                :row_colors     => ["FFFFFF", "E0E0E0"],
                :cell_style     => { :inline_format => true, :border_width => 1, :padding=>2, :size=>8 }
            ) do |table|
                table.row(0).background_color = "365F91"
                table.row(0).text_color       = "FFFFFF"
                table.column(2..8).align      = :center
            end
            
            #Grading Scale
            
            grading_scale = [
                ["A", "90%-100%"],
                ["B", "80%-89%" ],
                ["C", "70%-79%" ],
                ["D", "60%-69%" ],
                ["F", "<60%"    ],
                ["",  ""        ],
                ["P", "60%-100%"],
                ["F", "<60%"    ]
            ]
            
            pdf.move_down 20
            pdf.text "Grading Scale",
                :inline_format => true,
                :size          => 8
            pdf.table grading_scale,
                :column_widths  => {0=>15, 1=>60},
                :cell_style     => {:border_width => 1, :padding=>2, :height => 15, :size=>8, :align => :center }
                
            #INTACT STUDENT TAGS
            pdf.bounding_box([0, 25], :width => 535, :height => 25) do
                #STUDENT ID
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.student_id,
                        :align => :left,
                        :size => 10
                end
                #STUDENT LAST NAME
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.last_name.to_user,
                        :align => :center,
                        :size => 10
                end
                #STUDENT FIRST NAME
                pdf.bounding_box([0, 0], :width => 535, :height => 25) do
                    pdf.text s.first_name.to_user,
                        :align => :right,
                        :size => 10
                end
            end
            pdf.render_file "#{file_path}#{file_name}" if render_required
        end
    end
end