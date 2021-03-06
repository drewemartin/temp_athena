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
    
    def batch(pids = [], pdf = nil)
        
        batch_pdf = pdf || Prawn::Document.new
        
        pids.each do |pid|
            
            sid = $tables.attach("STUDENT_RRO_REQUESTS").field_value("student_id", "WHERE primary_id = '#{pid}'")
            
            generate_pdf(sid, batch_pdf)
            batch_pdf.start_new_page unless (pids.index(pid) == pids.length-1)
            
        end
        
        file_name = "Outgoing_Record_Requests_#{$ifilestamp}.pdf"
        file_path = $config.init_path("#{$paths.reports_path}Records_Requests")
        
        batch_pdf.render_file("#{file_path}#{file_name}")
        
    end
    
    def generate_pdf(sid, pdf = nil)
        
        previous_school_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_student_id(sid)
        
        s   = $students.get(sid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
        
        render_required = false
        
        if !pdf
            render_required = true
            file_name = "#{s.studentlastname.to_user}_#{s.studentfirstname.to_user}_#{sid}_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Records_Requests")
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
                pdf.text "<b>PERMANENT RECORDS REQUEST</b>", :align => :center, :size => 18, :inline_format=>true
            end
            
            pdf.grid([7,0], [8,1]).bounding_box do
                #pdf.stroke_bounds
                address_str =
"<b>Student Name: #{s.studentfirstname.to_user} #{s.studentlastname.to_user}
Date of Birth: #{s.birthday.to_user}, #{s.grade.to_user}</b>"
                pdf.text address_str, :align => :center, :size => 9, :inline_format=>true
            end
            
            pdf.grid([9,0], [11,1]).bounding_box do
                address_record = $tables.attach("SCHOOLS").by_primary_id(previous_school_record.fields["school_pid"].value)
                #pdf.stroke_bounds
                address_str =
"#{address_record.fields["school_name"].value}
#{address_record.fields["street_address"].value}
#{address_record.fields["city"].value} #{address_record.fields["state"].value} #{address_record.fields["zip"].value}"
                pdf.text address_str, :align => :left, :size => 9
            end
            
            pdf.grid([12,0], [30,1]).bounding_box do
                #pdf.stroke_bounds
                pdf.move_down 5
                address_str =
"<b>DISTRICT OF RESIDENCE:</b> #{s.districtofresidence.to_user} (district of responsibility)
<b>PREVIOUS SCHOOL: #{s.prevschoolname.to_user}</b> Guidance Office and/or Records Department
The above referenced student has enrolled with Agora Cyber Charter School on <b>#{s.schoolenrolldate.to_user}</b>.  In accordance with The Family Educational Rights and Privacy Act (FERPA) (20 U.S.C. \xC2\xA7 1232g; 34 CFR Part 99) we are requesting that the records be provided to Agora as a school which the student is transferring.   The student started Agora on #{s.schoolenrolldate.to_user}.
We are requesting the following permanent records:
    
"
                pdf.text address_str, :align => :left, :size => 8.5, :inline_format=>true
                
                categories = $tables.attach("RRO_DOCUMENT_TYPES").field_values(
                    "document_category",
                    "LEFT JOIN #{$tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").data_base}.student_rro_required_documents ON rro_document_types.primary_id = student_rro_required_documents.record_type_id
                    WHERE student_id = #{sid}
                    AND document_category IS NOT NULL
                    GROUP BY document_category
                    ORDER BY document_category ASC"
                )
                categories.each{|cat|
                    
                    pdf.text "\xE2\x9C\x93 #{cat}", :align => :left, :size => 8.5, :inline_format=>true
                    
                    req_docs = $tables.attach("RRO_DOCUMENT_TYPES").field_values(
                        "document_name",
                        "LEFT JOIN #{$tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").data_base}.student_rro_required_documents ON rro_document_types.primary_id = student_rro_required_documents.record_type_id
                        WHERE student_id = #{sid}
                        AND document_category = '#{cat}'"
                    )
                    req_docs.each{|doc|
                        
                        pdf.indent(25) do
                            
                            pdf.text "-#{doc}", :align => :left, :size => 8.5, :inline_format=>true
                            
                        end
                        
                    } if req_docs
                    
                } if categories
                
                no_cat_req_docs = $tables.attach("RRO_DOCUMENT_TYPES").field_values(
                    "document_name",
                    "LEFT JOIN #{$tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").data_base}.student_rro_required_documents ON rro_document_types.primary_id = student_rro_required_documents.record_type_id
                    WHERE student_id = #{sid}
                    AND document_category IS NULL"
                )
                no_cat_req_docs.each{|doc|
                    
                    pdf.text "\xE2\x9C\x93 #{doc}", :align => :left, :size => 8.5, :inline_format=>true
                    
                } if no_cat_req_docs
                
            end
            
            pdf.grid([30,0], [33,1]).bounding_box do
                pdf.move_down 3
                pdf.dash(4,:space=>4, :phase=>0)
                pdf.stroke_bounds
                address_str = "Please send the information listed above via mail or fax to:"
                pdf.indent(5) do
                    pdf.text address_str, :align => :left, :size => 8, :inline_format=>true
                end
            end
            
            pdf.move_cursor_to 180
            pdf.indent(250) do
                pdf.move_down 40
                pdf.text "<b>~or~</b>", :align => :left, :size => 8, :inline_format=>true
            end
            
            pdf.grid([31,0], [32,0]).bounding_box do
               
                pdf.dash(1,:space=>0, :phase=>0)
                #pdf.stroke_bounds
                address_str =
"<b>Agora Cyber Charter School
Attention: Records
995 Old Eagle School Road, Suite 315
Wayne, PA 19087</b>"
                pdf.indent(5) do
                    pdf.text address_str, :align => :left, :size => 8, :inline_format=>true
                end
            end
            
            pdf.grid([31,1], [32,1]).bounding_box do
                pdf.move_down 12
                #pdf.stroke_bounds
                address_str = "<b>Fax - (610) 254-8939</b>"
                pdf.indent(70) do
                    pdf.text address_str, :align => :left, :size => 8, :inline_format=>true
                end
            end
            
            pdf.grid([34.5,0], [40,1]).bounding_box do
                #pdf.stroke_bounds
                
                address_str =
"Thank you in advance for your attention to this matter.  <b>If records are not available, please respond in writing to this request on your letterhead detailing why the request cannot be fulfilled.</b>  Should you have questions please feel free to contact Scott McDonnell at (610) 263-8490.

Should this information present a question regarding BILLING or Child Accounting please call (610) 254-8218.

Sincerely,
Office of the Registrar
Agora Cyber Charter School

cc: Student File"
                pdf.text address_str, :align => :left, :size => 7.5, :inline_format=>true
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
        end
        pdf.render_file "#{file_path}#{file_name}" if render_required
    end
end