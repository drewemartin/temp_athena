#!/usr/local/bin/ruby

class DISTRICT_NOTIFICATION_WITHDRAWAL_PDF

  #---------------------------------------------------------------------------
  def initialize()
    
  end
  #---------------------------------------------------------------------------
  
  def distribute_confirmed_batch(withdrawing_pid_arr = nil)
    #ACCEPTS AN ARRAY OF WITHDRAWING TABLE PRIMARY IDS, OR
    #IT FINDSRECORDS THAT WERE CONFIRMED TODAY.
    
    #FNORD - TO DO ->
    #Add functionality to limit the file size to 5mb each.
    #Use the old progess report distribution as an example.
    
    ############################################################################
    #ALL CORRESPONDANCE TO BE FROM THE FOLLOWING
    sender_email     = "registrardistrict@agora.org"
    sender_secret    = "district12"
    ############################################################################
    
    ############################################################################
    #GET ARRAY OF QUALIFYING WITHDRAW REQUEST RECORDS - withdrawing_pid_arr
    if !withdrawing_pid_arr
      w_db = $tables.attach("withdrawing").data_base
      withdrawing_pid_arr = $db.get_data_single(
        "SELECT
          primary_id
        FROM #{w_db}.withdrawing
        WHERE completed_date IS NOT NULL
        AND retracted IS NOT TRUE
        AND rescinded IS NOT TRUE
        AND district_notify_date IS NULL"
      )
    end
    ############################################################################
    
    ############################################################################
    #CREATE HASH OF SCHOOL DISTRICTS THAT SHOULD RECEIVE AN EMAIL - KEY = sd_name VALUE = pids
    #CREATE ARRAY OF SIDS:SD_EMAIL THAT QUALIFY FOR NOTIFICATION
    districts_hash              = Hash.new
    districts_missing_hash      = Hash.new
    withdrawing_pid_arr.each{|withdrawing_pid|
      wd_record = $tables.attach("withdrawing").by_primary_id(withdrawing_pid)
      sid       = wd_record.fields["student_id"].value
      s_obj     = $students.attach(sid)
      district  = s_obj.districtofresidence.value
      if district
        sd_email = $tables.attach("districts").field_bydistrict("contact_email", district, contact_department = "Withdrawals")
        if sd_email && sd_email.value
          districts_hash[district] = Array.new if !districts_hash.has_key?(district)
          districts_hash[district].push(withdrawing_pid)
        else
          districts_missing_hash[district] = Array.new if !districts_missing_hash.has_key?(district)
          districts_missing_hash[district].push(withdrawing_pid)
        end
      end
    }
    ############################################################################
    
    ############################################################################
    #CREATE ONE PDF OBJECT TO HOLD ALL STUDENTS - completed_batch_pdf
    completed_batch_pdf = Prawn::Document.new
    ############################################################################
    
    ############################################################################
    #ITTERATE THROUGH EACH SCHOOL DISTRICT, CREATE ONE PDF OBJECT TO HOLD ALL STUDENTS FOR THAT DISTRICT - district_batch_pdf
    #PASS THROUGH generate_pdf ONCE FOR completed_batch_pdf AND ONCE FOR district_batch_pdf
    #RENDER  AND ZIP THE RESULTS - district_batch_pdf
    #DISTRIBUTE THE RESULTS
    #UPDATE THE RECORDS OF NOTIFIED STUDENTS
    #CREATE NOTIFICATION LOG
    districts_index  = 1
    districts_length = districts_hash.length
    districts_hash.each_pair{|district, pids|
      district_batch_pdf  = Prawn::Document.new
      students            = Array.new
      pids_index  = 1
      pids_length = pids.length
      pids.each{|pid|
        wd_record = $tables.attach("withdrawing").by_primary_id(pid)
        sid       = wd_record.fields["student_id"].value
        s_obj     = $students.attach(sid)
        students.push("#{s_obj.first_name.value} #{s_obj.last_name.value}")
        #PASS THROUGH generate_pdf ONCE FOR completed_batch_pdf AND ONCE FOR district_batch_pdf
        generate_pdf(pid, completed_batch_pdf)
        completed_batch_pdf.start_new_page if (pids_length > pids_index) || (districts_length > districts_index)
        
        generate_pdf(pid, district_batch_pdf)
        district_batch_pdf.start_new_page if pids_length > pids_index
        
        pids_index +=1
      }
      districts_index += 1
      
      #RENDER  AND ZIP THE RESULTS - district_batch_pdf
      if district_aun = $tables.attach("districts_aun").find_field("aun","WHERE name='#{district}'")
        district_batch_pdf_path = $reports.save_document({
            :pdf             => district_batch_pdf,
            :category_name   => "Withdrawals",
            :type_name       => "District Withdrawal Notification - By District",
            :document_relate => [
                {
                    :table_name      => "DISTRICTS_AUN",
                    :key_field       => "aun",
                    :key_field_value => district_aun.value
                }
            ]
        })
      end
      
      email_name = "#{district}_#{$ifilestamp}.pdf"
      att_path   = district_batch_pdf_path
      #att_path = Zip::ZipFile.open(att_path, Zip::ZipFile::CREATE)
      
      #DISTRIBUTE THE RESULTS
      #$reports.move_to_athena_reports(zip_file)
      recipient_email = $tables.attach("districts").field_bydistrict("contact_email", district, contact_department = "Withdrawals").value
      subject         = "Agora Cyber Charter School - Student Withdraw"
      content         = "Please find the attached withdrawal notification form. The following student(s) have been withdrawn from Agora Cyber Charter School: #{students.join("\n")}"
      #FOR TESTING# recipient_email = "jhalverson@agora.org"
      #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, att_path)
      $base.email.athena_smtp_email(
        recipient_email = recipient_email,
        subject         = subject,
        content         = content,
        attachment_path = att_path,
        from_override   = sender_email,
        att_override    = email_name
      )
      
      #UPDATE THE RECORDS OF NOTIFIED STUDENTS
      #CREATE NOTIFICATION LOG
      pids.each{|pid|
        #UPDATE THE RECORDS OF NOTIFIED STUDENTS
        wd_record = $tables.attach("withdrawing").by_primary_id(pid)
        wd_record.fields["district_notify_date"].value = DateTime.now
        wd_record.save
        
        #CREATE NOTIFICATION LOG
        log   = $tables.attach("district_notifications").new_row
        log.fields["student_id"         ].value = wd_record.fields["student_id"].value
        log.fields["notification_type"  ].value = "Withdrawal"
        log.fields["district"           ].value = district
        log.fields["sent_to_email"      ].value = recipient_email
        log.save
      }
    }
    ############################################################################
    
    ############################################################################
    #RENDER completed_batch_pdf
    #ZIP THE RESULTS AND DISTRIBUTE
    if districts_length > 0
      
      completed_batch_pdf_path = $reports.save_document({
          :pdf             => completed_batch_pdf,
          :category_name   => "Withdrawals",
          :type_name       => "District Withdrawal Notification - Complete",
      })
      
      email_name = "all_districts_#{$ifilestamp}.pdf"
      att_path = completed_batch_pdf_path
      
      #att_path  = Zip::ZipFile.open(att_path, Zip::ZipFile::CREATE)
      #$reports.move_to_athena_reports(zip_file)
      
      recipient_email = "sfields@agora.org"
      subject         = "Withdrawal Notifications - #{$base.today.to_user}"
      content         = "Please see attached, and have a nice day!"
      #FOR TESTING# recipient_email = "jhalverson@agora.org"
      #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, att_path)
      $base.email.athena_smtp_email(
        recipient_email = recipient_email,
        subject         = subject,
        content         = content,
        attachment_path = att_path,
        from_override   = sender_email,
        att_override    = email_name
      )
    end
    ############################################################################
    
    ############################################################################
    #NOTIFY REGISTRAR DEPARTMENT ABOUT MISSING DISTRICT/DISTRICT EMAIL ADDRESSES
    if !districts_missing_hash.empty?
      recipient_email = "sfields@agora.org"
      subject         = "District Contact Information Missing"
      content         = "Please update the contact information for the following districts: #{districts_missing_hash.keys.join("\n")}"
      location        = "Withdrawals/District_Notification/To_Registrar"
      filename        = "districts_not_found_#{$ifilestamp}.csv"
      att_path        = $reports.save_document({:csv_rows=>districts_missing_hash.keys, :category_name=>"Withdrawals", :type_name=>"Missing District Contact Information"})
      #FOR TESTING# recipient_email = "jhalverson@agora.org"
      #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, att_path)
      $base.email.athena_smtp_email(
        recipient_email = recipient_email,
        subject         = subject,
        content         = content,
        attachment_path = att_path,
        from_override   = sender_email,
        att_override    = filename
      )
    end
    ############################################################################
    
    ############################################################################
    #UPDATE THE RECORDS OF NOTIFIED STUDENTS
    #CREATE NOTIFICATION LOG
    #wd_qualifying_sids_sd_email.each{|sid_email_district_pid|
    #  sid_email_district = sid_email_district.split(":")
    #  sid       = sid_email_district_pid[0]
    #  email     = sid_email_district_pid[1]
    #  district  = sid_email_district_pid[2]
    #  pid       = sid_email_district_pid[3]
    #  
    #  #UPDATE THE RECORDS OF NOTIFIED STUDENTS
    #  w   = $tables.attach("withdrawing").by_primary_id(pid)
    #  w.fields["district_notify_date"].value = DateTime.now
    #  w.save
    #  
    #  #CREATE NOTIFICATION LOG
    #  log   = $tables.attach("district_notifications").new_row
    #  log.fields["student_id"         ].value = sid
    #  log.fields["notification_type"  ].value = "Withdrawal"
    #  log.fields["district"           ].value = district
    #  log.fields["sent_to_email"      ].value = email
    #  log.save
    #}
    ############################################################################
    
    #sender_email     = "registrardistrict@agora.org"
    #sender_secret    = "district12"
    #
    #file_name = "districtnotify_withdraw_batch#{$ifilestamp}.pdf"
    #file_path = $config.init_path("#{$paths.reports_path}Withdrawals/District_Notification/Batch_PDF")
    #pdf       = Prawn::Document.new
    #index = 0
    #withdrawing_pid_arr.each{|withdrawing_pid|
    #  index += 1
    #  #GENERATE STUDENT INDIVIDUAL RECORD TO BE EMAILED
    #  
    #  log = $tables.attach("district_notifications").new_row
    #  log.fields["student_id"       ].value = sid
    #  log.fields["notification_type"].value = "Withdrawal"
    #  
    #  email_file_path = generate_pdf(withdrawing_pid).path      
    #  
    #  w   = $tables.attach("withdrawing").by_primary_id(withdrawing_pid)
    #  sid = w.fields["student_id"].value
    #  s   = $students.attach(sid)
    #  
    #  district        = s.districtofresidence.value
    #  recipient_email = nil
    #  if !district.empty?
    #    log.fields["district"].value = district
    #    sd_email = $tables.attach("districts").field_bydistrict("contact_email", district, contact_department = "Withdrawals")
    #    if sd_email && sd_email.value
    #      recipient_email = sd_email.value
    #      subject = "Agora Cyber Charter School - Student Withdraw"
    #      content = "Please see attached.  #{s.first_name.value} #{s.last_name.value} has been withdrawn from Agora Cyber Charter School"
    #      #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, email_file_path)
    #    else
    #      recipient_email = "afitzgibbons@agora.org"
    #      subject = "SID: #{sid} - No District E-mail For Student Withdrawal"
    #      content = "Please see attached student withdraw notification for #{s.first_name.value} #{s.last_name.value}.\n A district e-mail address does not exist in the system. Please take the appropriate action"
    #      #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, email_file_path)
    #    end
    #  else
    #    log.fields["district"].value = "UNKNOWN"
    #    recipient_email = "afitzgibbons@agora.org"
    #    subject = "SID: #{sid} - No District Listed For Student"
    #    content = "Please see attached student withdraw notification for #{s.first_name.value} #{s.last_name.value}.\n A district does not exist for this student. Please take the appropriate action"
    #    #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, email_file_path) 
    #  end
    #  
    #  log.fields["sent_to_email"].value = recipient_email
    #  log.save
    #  
    #  w.fields["district_notify_date"].value = DateTime.now
    #  w.save
    #  
    #  #ADD STUDENT RECORD TO INTACT UPLOAD DOCUMENT
    #  generate_pdf(withdrawing_pid, pdf)
    #  
    #  pdf.start_new_page if withdrawing_pid_arr.length > index
    #}
    #
    #batch_pdf_path = pdf.render_file "#{file_path}#{file_name}"
    ##$reports.move_to_athena_reports(batch_pdf_path)
    #
    #return batch_pdf_path
    
  end
  
  def generate_pdf(pid, pdf = nil)
    w   = $tables.attach("withdrawing").by_primary_id(pid)
    sid = w.fields["student_id"].value
    s   = $students.attach(sid)
    logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
    render_required = false
    if !pdf
      render_required = true
      file_name = "districtnotify_SID#{sid}_PID#{pid}.pdf"
      file_path = $config.init_path(  
        "#{$paths.student_path(sid)}/Withdrawal/WD_Request_#{pid}"
      )
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
      
      #SCHOOL DISTRICT
      pdf.grid([3,1], [3,1]).bounding_box do
        #pdf.stroke_bounds
        pdf.text s.districtofresidence.to_user, :align => :right
      end
      ########################################################################
        
      #STUDENT MAILING ADDRESS
      pdf.grid([3,0], [5,0]).bounding_box do
        #pdf.stroke_bounds
        to_address = String.new
        to_address << "#{DateTime.now.strftime("%b %d, %Y")}\n"
        to_address << "\n"
        to_address << "Parent or Guardian\n"
        to_address << "#{s.mailing_address.to_user}\n"
        to_address << "#{s.mailing_address_line_two.to_user}\n" if !s.mailing_address_line_two.to_user.empty?
        to_address << "#{s.mailing_city.to_user} #{s.mailing_state.to_user}, #{s.mailing_zip.to_user}\n"
        pdf.text to_address
      end
      ########################################################################
        
      #STUDENT DEMOGRAPHICS HEADER
      pdf.grid([6,0], [7,1]).bounding_box do
        #pdf.stroke_bounds
        demo_str = String.new
        demo_str << "#{s.last_name.to_user}, #{s.first_name.to_user}\n"
        demo_str << "Student PA Secure ID#: #{s.ppid.to_user}\n"
        demo_str << "Date of Birth: #{s.birthday.to_user}\n" 
        demo_str << "Grade Registered: #{s.grade.to_user}\n"
        pdf.text demo_str, :align => :center
      end
      ########################################################################
        
      #LETTER BODY
      pdf.grid([8,0], [15,1]).bounding_box do
        #pdf.stroke_bounds
        reason_code = w.fields["agora_reason"].value
        withdrawal_reason       = $tables.attach("Withdraw_Reasons").agora_reason_by_code(reason_code).to_user if reason_code
        student_enroll_date     = s.school_enroll_date.to_user
        student_effective_date  = w.fields["effective_date"].to_user
        body_str = "The above named student has been WITHDRAWN from Agora Cyber Charter School. The student was enrolled from #{student_enroll_date} to #{student_effective_date}. The student was withdrawn for the following reason: #{withdrawal_reason}. 

Please be advised that as a PA public school, Agora Cyber Charter School advises all families/students that they are required to be enrolled in a school program until the age of maturity in Pennsylvania.  It is the responsibility of the student/family to enroll with another school IMMEDIATELY to ensure the child receives continuous educational services.  Failure to do so may result in truancy charges, fines, or prosecution via your local school district.

 
If you have further questions or additional information is needed, please contact the Registrar's office at withdrawals@agora.org  or (610) 254-8218, option 5.  

Sincerely,

Registrar Office
Agora Cyber Charter School"
        pdf.text body_str
      end
      ########################################################################
        
      #REGISTRAR RECORD REQUEST INFO BOX
      pdf.grid([16,0], [19,1]).bounding_box do
        pdf.move_down 10
        info_str = "\nAll requests for student records or transcripts must be in writing
Fax 610-254-8939 or 8969
Student Records - records@agora.org ~ Student Transcripts - transcripts@agora.org
or mail to above address
~
School Districts Billing Inquiries - childaccounting@agora.org\n"
        pdf.text info_str, :align => :center
        pdf.transparent(0.5) { pdf.stroke_bounds }
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
  
  def generate_rescinded_pdf(withdrawing_pid, pdf = nil)
    w   = $tables.attach("withdrawing").by_primary_id(withdrawing_pid)
    sid = w.fields["student_id"].value
    s   = $students.attach(sid)
    logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
    render_required = false
    if !pdf
      render_required = true
      file_name = "districtnotify_withdraw_#{sid}_#{s.last_name.value}_#{s.first_name.value}_#{$ifilestamp}.pdf"
      file_path = $config.init_path("#{$paths.reports_path}Withdrawals/District_Notification")
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
      
      #SCHOOL DISTRICT
      pdf.grid([3,1], [3,1]).bounding_box do
        #pdf.stroke_bounds
        pdf.text s.districtofresidence.to_user, :align => :right
      end
      ########################################################################
        
      #STUDENT MAILING ADDRESS
      pdf.grid([3,0], [5,0]).bounding_box do
        #pdf.stroke_bounds
        to_address = String.new
        to_address << "#{DateTime.now.strftime("%b %d, %Y")}\n"
        to_address << "\n"
        to_address << "Parent or Guardian\n"
        to_address << "#{s.mailing_address.to_user}\n"
        to_address << "#{s.mailing_address_line_two.to_user}\n" if !s.mailing_address_line_two.to_user.empty?
        to_address << "#{s.mailing_city.to_user} #{s.mailing_state.to_user}, #{s.mailing_zip.to_user}\n"
        pdf.text to_address
      end
      ########################################################################
        
      #STUDENT DEMOGRAPHICS HEADER
      pdf.grid([6,0], [7,1]).bounding_box do
        #pdf.stroke_bounds
        demo_str = String.new
        demo_str << "#{s.last_name.to_user}, #{s.first_name.to_user}\n"
        demo_str << "Student PA Secure ID#: #{s.ppid.to_user}\n"
        demo_str << "Date of Birth: #{s.birthday.to_user}\n" 
        demo_str << "Grade Registered: #{s.grade.to_user}\n"
        pdf.text demo_str, :align => :center
      end
      ########################################################################
        
      #LETTER BODY
      pdf.grid([8,0], [15,1]).bounding_box do
        #pdf.stroke_bounds
        withdrawal_reason       = $tables.attach("Withdraw_Reasons").agora_reason_by_code(w.fields["agora_reason"].value).to_user
        student_enroll_date     = s.school_enroll_date.to_user
        student_effective_date  = w.fields["effective_date"].to_user
        body_str = "
Dear District Office,

Please be advised that your district was sent a notification of withdrawal for the above student in error.  The student has not been withdrawn from Agora Cyber Charter School.  Please disregard the previous correspondence concerning this student's withdrawal.

Should this student (or any students registered to your district) be withdrawn from Agora Cyber Charter School, you will receive written notification within 10 days of the date of withdraw.

If you have further questions or additional information is needed, please contact the Registrar's office directly at withdrawals@agora.org  or (610) 254-8218, option 5.  Thank you in advance for your time and attention.  

Sincerely,

Registrar Office 
Agora Cyber Charter School"
        
        pdf.text body_str
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