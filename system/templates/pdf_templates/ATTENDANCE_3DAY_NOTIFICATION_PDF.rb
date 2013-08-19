#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("templates/pdf_templates","base")}/base"

class ATTENDANCE_3DAY_NOTIFICATION_PDF < Base

  #---------------------------------------------------------------------------
  def initialize
    super()
    #confirmed_batch(withdrawing_pid_arr=["36","36"])
    generate_pdf("2578")
  end
  #---------------------------------------------------------------------------
  
  def confirmed_batch(withdrawing_pid_arr)
    #FNORD - TO DO ->
    #Add functionality to limit the file size to 5mb each.
    #Use the old progess report distribution as an example.
    
    file_name = "confirmed_batch_#{$ifilestamp}.pdf"
    file_path = $config.init_path("#{$paths.reports_path}Withdrawals/Confirmed_Batch")
    pdf       = Prawn::Document.new
    index = 0
    withdrawing_pid_arr.each{|withdrawing_pid|
      index += 1
      
      #GENERATE STUDENT INDIVIDUAL RECORD TO BE EMAILED
      email_file_path = generate_pdf(withdrawing_pid).path      
      
      w   = $tables.attach("withdrawing").by_primary_id(withdrawing_pid)
      sid = w.fields["student_id"].value
      s   = $students.attach(sid)
      
      district  = s.districtofresidence.value
      if !district.empty?
        sd_email = $tables.attach("districts").field_bydistrict("contact_email", district, contact_department = "Withdrawals")
        if sd_email
          $base.email.send() #to the district
        else
          $base.email.send() #to ???? with notification that the email address doesn't exist
        end
      end
      
      #ADD STUDENT RECORD TO INTACT UPLOAD DOCUMENT
      generate_pdf(withdrawing_pid, pdf)
      
      pdf.start_new_page if withdrawing_pid_arr.length > index
    }
    pdf.render_file "#{file_path}#{file_name}"
  end
  
  def generate_pdf(sid, pdf = nil)
    s   = $students.attach(sid)
    logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
    render_required = false
    if !pdf
      render_required = true
      file_name = "#{s.last_name.value}_#{s.first_name.value}_#{$ifilestamp}.pdf"
      file_path = $config.init_path("#{$paths.reports_path}Attendance/3_Day_Notifications")
      pdf       = Prawn::Document.new
    end
    
    #DOCUMENT GRID
    pdf.define_grid(:columns => 2, :rows => 20, :gutter => 10)
    
    #MAIN BOUNDING BOX
    pdf.bounding_box([25, 725], :width => 490, :height => 700) do
      #pdf.stroke_bounds
      #SCHOOL LOGO
      pdf.grid([0,0], [2,0]).bounding_box do
        #pdf.stroke_bounds
        pdf.move_down 15
        pdf.image logo_path, :width => 200, :height => 65
      end
      
      #PLACE THE ADDRESS
      pdf.grid([0,1], [2,1]).bounding_box do
        #pdf.stroke_bounds
        address_str =
"995 Old Eagle School Road
Suite 315
Wayne, PA 19087
ph 610.254.8218
fx 610.254.8939 or 8969
www.agora.org"
        pdf.move_down 15
        pdf.text address_str, :align => :right, :size => 10
      end
      ########################################################################
      
      #Subject Line
      pdf.grid([3,0], [4,1]).bounding_box do
        #pdf.stroke_bounds
        subject_line = "<u><b>THIS LETTER IS NOTICE THAT #{s.first_name.to_user.upcase} #{s.last_name.to_user.upcase} HAS UNEXCUSED ABSENCES</b></u>"
        pdf.text subject_line, :align => :center, :size => 16, :inline_format => true
      end
      ########################################################################
      
      #STUDENT DISTRICT BLOCK
       pdf.grid([5,0], [6,0]).bounding_box do
        #pdf.stroke_bounds
        contact_email = $tables.attach("DISTRICTS").field_bydistrict("contact_email", s.districtofresidence.to_user)
        to_address = String.new
        to_address << "#{s.districtofresidence.to_user}\n"
        to_address << "#{contact_email}\n"
        to_address << "DOB: #{s.birthday.to_user}\n"
        to_address << "GRADE: #{s.grade.to_user}"
        pdf.text to_address, :align => :left
      end
      ########################################################################
      
      #STUDENT MAILING ADDRESS
      pdf.grid([5,1], [6,1]).bounding_box do
        #pdf.stroke_bounds
        to_address = String.new
        to_address << "#{DateTime.now.strftime('%B %d, %Y')}\n"
        to_address << "#{s.fullname.to_user}\n"
        to_address << "#{s.mailing_address.to_user}\n"
        to_address << "#{s.mailing_address_line_two.to_user}\n" if !s.mailing_address_line_two.to_user.empty?
        to_address << "#{s.mailing_city.to_user} #{s.mailing_state.to_user}, #{s.mailing_zip.to_user}\n"
        pdf.text to_address, :align => :right
      end
      ########################################################################
      
      #LETTER BODY
      pdf.grid([7,0], [20,1]).bounding_box do
        #pdf.stroke_bounds
        unexcused_days = String.new
        unexcused_absences = s.attendance.unexcused_absences
        i=0
        unexcused_absences.each_key do |day|
          i+=1
          unexcused_days << "#{Date.parse(day).strftime('%m/%d/%y')}"
          unexcused_days << ", " if unexcused_absences.size != i
        end
        body_str =
"Agora Cyber Charter School is writing to notify you that Agora student, #{s.first_name.to_user} #{s.last_name.to_user}, has been absent from school without legal excuse on the following dates:
#{unexcused_days}
Internal communication has been attempted to the student's parent or guardian concerning all unexcused absences.

Per the BEC, titled under \"Compulsory Attendance and Truancy Elimination Plan\", Charter schools must report to the student's school district of residence when a student has accrued three or more days of unlawful absences.

<b><i>If you believe this letter was sent to your district in error, the student is currently enrolled with you or another district, or requires a copy of the Charter School Enrollment Form please contact Child Accounting at <u><color rgb='0645AD'>childaccounting@agora.org</color></u>.</i></b>

<b>With this letter, please contact the Attendance Office at <u><color rgb='0645AD'>attendance@agora.org</color></u>  with any questions or concerns before pursuing any action.</b>

Sincerely, 
Tracy Swift-Merrick & Michele Ward-Illich
Truancy Prevention Coordinators
"
        pdf.move_down 20
        pdf.text body_str, :inline_format => true, :align => :justify
      end
    ########################################################################
    end
    pdf.render_file "#{file_path}#{file_name}" if render_required
    return "#{file_path}#{file_name}"
  end
  
end

ATTENDANCE_3DAY_NOTIFICATION_PDF.new
