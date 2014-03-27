#!/usr/local/bin/ruby

class WITHDRAWAL_GRADES_PDF

  #---------------------------------------------------------------------------
  def initialize()
    
  end
  #---------------------------------------------------------------------------
  
  def generate_pdf(pid, pdf = nil)
    
    wd_record = $tables.attach("WITHDRAWING").by_primary_id(pid)
    sid       = wd_record.fields["student_id"].value
    
    s   = $students.attach(sid)
    
    logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
    render_required = false
    if !pdf
      render_required = true
      file_name = "final_grades_SID#{sid}_PID#{pid}.pdf"
      file_path = $config.init_path(
        "#{$paths.student_path(sid)}Withdrawal/WD_Request_#{pid}"
      )
      pdf       = Prawn::Document.new
    end
    
    #DOCUMENT GRID
    pdf.define_grid(:columns => 4, :rows => 20, :gutter => 10)
    
    #MAIN BOUNDING BOX
    pdf.bounding_box([25, 725], :width => 490, :height => 700) do
      #pdf.stroke_bounds
      #SCHOOL LOGO
      pdf.grid([0,0], [2,1]).bounding_box do
        #pdf.stroke_bounds
        pdf.move_down 15
        pdf.image logo_path, :width => 200, :height => 65
      end
      
      #PLACE THE ADDRESS
      pdf.grid([0,2], [2,3]).bounding_box do
        #pdf.stroke_bounds
        address_str =
"AGORA CYBER CHARTER SCHOOL
995 Old Eagle School Road
Suite 315
Wayne, PA 19087
ph 610.254.8218
fx 610.254.8939 or 8969
www.agora.org"
        pdf.move_down 15
        pdf.text address_str, :align => :right, :size => 10
      end
      ########################################################################
      #TITLE
      pdf.grid([3,0], [3,3]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Withdrawal Report #{$school.current_school_year} School Year</b>"
        pdf.text text, :align => :center, :size => 18, :inline_format => true
      end
      ########################################################################
      #INFO LABELS LEFT
      pdf.grid([4,0], [5,0]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>First Name:\nStudent ID #:\nTeacher:</b>"
        pdf.text text, :align => :left, :size => 11, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO LEFT
      pdf.grid([4,1], [5,1]).bounding_box do
        #pdf.stroke_bounds
        text = "#{s.first_name.value}\n#{s.sid.value}\n#{s.primary_teacher.value}"
        pdf.text text, :align => :left, :size => 11, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO LABELS RIGHT
      pdf.grid([4,2], [5,2]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Last Name:\nCurrent Grade:</b>"
        pdf.text text, :align => :left, :size => 11, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO RIGHT
      pdf.grid([4,3], [5,3]).bounding_box do
        #pdf.stroke_bounds
        text = "#{s.last_name.value}\n#{s.grade.value}"
        pdf.text text, :align => :left, :size => 11, :leading=>4, :inline_format => true
      end
      ########################################################################
      #ENROLL DATE LABEL
      pdf.grid([6,0], [6,0]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Enrollment Date:</b>"
        pdf.text text, :align => :left, :size => 11, :inline_format => true
      end
      ########################################################################
      #ENROLL DATE
      pdf.grid([6,1], [6,1]).bounding_box do
        #pdf.stroke_bounds
        text = s.school_enroll_date.to_user
        pdf.text text, :align => :left, :size => 11, :inline_format => true
      end
      ########################################################################
      #WITHDRAW DATE LABEL
      pdf.grid([6,2], [6,2]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Withdrawal Date:</b>"
        pdf.text text, :align => :left, :size => 11, :inline_format => true
      end
      ########################################################################
      #WITHDRAW DATE
      pdf.grid([6,3], [6,3]).bounding_box do
        #pdf.stroke_bounds
        text = "#{wd_record.fields["effective_date"].to_user}"
        pdf.text text, :align => :left, :size => 11, :inline_format => true
      end
      ########################################################################
      #ATTENDANCE
      pdf.grid([7,0], [7,3]).bounding_box do
        #pdf.stroke_bounds
        text = String.new
        text << "<b>Enrolled Days:</b> #{s.attendance.enrolled_days       ? s.attendance.enrolled_days.length       : 0}               "
        text << "<b>Excused Absences:</b> #{s.attendance.enrolled_days    ? s.attendance.excused_absences.length    : 0}               "
        text << "<b>Unexcused Absences:</b> #{s.attendance.enrolled_days  ? s.attendance.unexcused_absences.length  : 0}"
        pdf.text text, :size => 11, :inline_format => true
      end
      ########################################################################
      #ACADEMIC PROGRESS HEADER
      pdf.grid([8,0], [8,3]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Academic Progress:</b>"
        pdf.move_down 10
        pdf.text text, :align => :left, :size=>14, :inline_format => true
      end
      ########################################################################
        
      #LETTER BODY
      pdf.grid([9,0], [19,3]).bounding_box do
        #pdf.stroke_bounds
        
        progress_table  = [
          #HEADERS
          [
            "Class",
            "Term",
            "Percent",
            "Type"
          ]
        ]
        
        wd_term = $tables.attach("PROGRESS_REPORT_SCHEDULE").field_value("term", "WHERE '#{wd_record.fields["effective_date"].value}' BETWEEN opened_datetime AND closed_datetime") || ""
        records = $students.get(sid).academic_progress.existing_records("WHERE term='#{wd_term}'")
        records.each{|record|
          
          row = Array.new
          row.push(record.fields["course_name"  ].to_user)
          row.push(record.fields["term"         ].to_user)
          row.push(record.fields["progress"     ].to_user)
          if record.fields["data_source"  ].to_user.match("Sapphire")
            row.push("Grade")
          else
            row.push("Progress")
          end
          progress_table.push(row)
          
        } if records
        
        pdf.table(
          progress_table,
          :cell_style     => {:size=>8,:padding=>3},
          :column_widths  => [350,35,40],
          :row_colors     => ["E0E0E0", "FFFFFF"]
        )
        
      end
      ########################################################################
      
    end
      
      #INTACT STUDENT TAGS
      pdf.bounding_box([0, 25], :width => 535, :height => 25) do
        
        #STUDENT ID
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.student_id, :align => :left
        end
        #STUDENT LAST NAME
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.last_name.to_user, :align => :center
        end
        #STUDENT FIRST NAME
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.first_name.to_user, :align => :right
        end
        
      end
      ########################################################################
    #end
    pdf.render_file "#{file_path}#{file_name}" if render_required
  end

def by_studentid_old(sid, pdf = nil)
    
    s   = $students.attach(sid)
    
    logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
    render_required = false
    if !pdf
      render_required = true
      file_name = "final_grades_SID#{sid}.pdf"
      file_path = $config.init_path(
        "#{$paths.student_path(sid)}Withdrawal/WD_Request"
      )
      pdf       = Prawn::Document.new
    end
    
    #DOCUMENT GRID
    pdf.define_grid(:columns => 4, :rows => 20, :gutter => 10)
    
    #MAIN BOUNDING BOX
    pdf.bounding_box([25, 725], :width => 490, :height => 700) do
      #pdf.stroke_bounds
      #SCHOOL LOGO
      pdf.grid([0,0], [2,1]).bounding_box do
        #pdf.stroke_bounds
        pdf.move_down 15
        pdf.image logo_path, :width => 200, :height => 65
      end
      
      #PLACE THE ADDRESS
      pdf.grid([0,2], [2,3]).bounding_box do
        #pdf.stroke_bounds
        address_str =
"AGORA CYBER CHARTER SCHOOL
995 Old Eagle School Road
Suite 315
Wayne, PA 19087
ph 610.254.8218
fx 610.254.8939 or 8969
www.agora.org"
        pdf.move_down 15
        pdf.text address_str, :align => :right, :size => 10
      end
      ########################################################################
      #TITLE
      pdf.grid([3,0], [3,3]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Withdrawal Report #{$school.current_school_year} School Year</b>"
        pdf.text text, :align => :center, :size => 18, :inline_format => true
      end
      ########################################################################
      #INFO LABELS LEFT
      pdf.grid([4,0], [5,0]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>First Name:\nStudent ID #:\nTeacher:</b>"
        pdf.text text, :align => :left, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO LEFT
      pdf.grid([4,1], [5,1]).bounding_box do
        #pdf.stroke_bounds
        text = "#{s.first_name.value}\n#{s.sid.value}\n#{s.primary_teacher.value}"
        pdf.text text, :align => :left, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO LABELS RIGHT
      pdf.grid([4,2], [5,2]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Last Name:\nCurrent Grade:</b>"
        pdf.text text, :align => :left, :leading=>4, :inline_format => true
      end
      ########################################################################
      #INFO RIGHT
      pdf.grid([4,3], [5,3]).bounding_box do
        #pdf.stroke_bounds
        text = "#{s.last_name.value}\n#{s.grade.value}"
        pdf.text text, :align => :left, :leading=>4, :inline_format => true
      end
      ########################################################################
      #ENROLL DATE LABEL
      pdf.grid([6,0], [6,0]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Enrollment Date:</b>"
        pdf.text text, :align => :left, :inline_format => true
      end
      ########################################################################
      #ENROLL DATE
      pdf.grid([6,1], [6,1]).bounding_box do
        #pdf.stroke_bounds
        text = s.school_enroll_date.to_user
        pdf.text text, :align => :left, :inline_format => true
      end
      ########################################################################
      #WITHDRAW DATE LABEL
      pdf.grid([6,2], [6,2]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Withdrawal Date:</b>"
        pdf.text text, :align => :left, :inline_format => true
      end
      ########################################################################
      #WITHDRAW DATE
      pdf.grid([6,3], [6,3]).bounding_box do
        #pdf.stroke_bounds
        text = "#{$tables.attach("k12_withdrawal").by_studentid_old(sid).fields["schoolwithdrawdate"].to_user}"
        pdf.text text, :align => :left, :inline_format => true
      end
      ########################################################################
      #ATTENDANCE
      pdf.grid([7,0], [7,3]).bounding_box do
        #pdf.stroke_bounds
        text = String.new
        text << "<b>Enrolled Days:</b> #{s.attendance.enrolled_days       ? s.attendance.enrolled_days.length       : 0}          "
        text << "<b>Excused Absences:</b> #{s.attendance.enrolled_days    ? s.attendance.excused_absences.length    : 0}          "
        text << "<b>Unexcused Absences:</b> #{s.attendance.enrolled_days  ? s.attendance.unexcused_absences.length  : 0}"
        pdf.text text, :inline_format => true
      end
      ########################################################################
      #ACADEMIC PROGRESS HEADER
      pdf.grid([8,0], [8,3]).bounding_box do
        #pdf.stroke_bounds
        text = "<b>Academic Progress:</b>"
        pdf.move_down 10
        pdf.text text, :align => :left, :size=>14, :inline_format => true
      end
      ########################################################################
        
      #LETTER BODY
      pdf.grid([9,0], [19,3]).bounding_box do
        #pdf.stroke_bounds
        
        progress_table  = [
          #HEADERS
          [
            "Class",
            "Term",
            "Percent"
          ]
        ]
        
        records = $students.get(sid).academic_progress.existing_records
        records.each{|record|
          
          row = Array.new
          row.push(record.fields["course_name"  ].to_user)
          row.push(record.fields["term"         ].to_user)
          row.push(record.fields["progress"     ].to_user)
          progress_table.push(row)
          
        } if records
        
        pdf.table(
          progress_table,
          :cell_style     => {:size=>8,:padding=>3},
          :column_widths  => [375,75],
          :row_colors     => ["E0E0E0", "FFFFFF"]
        )
        
      end
      ########################################################################
      
    end
      
      #INTACT STUDENT TAGS
      pdf.bounding_box([0, 25], :width => 535, :height => 25) do
        
        #STUDENT ID
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.student_id, :align => :left
        end
        #STUDENT LAST NAME
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.last_name.to_user, :align => :center
        end
        #STUDENT FIRST NAME
        pdf.bounding_box([0, 0], :width => 535, :height => 25) do
          pdf.text s.first_name.to_user, :align => :right
        end
        
      end
      ########################################################################
    #end
    pdf.render_file "#{file_path}#{file_name}" if render_required
end

end