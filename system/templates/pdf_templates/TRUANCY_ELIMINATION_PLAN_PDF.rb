#!/usr/local/bin/ruby

class TRUANCY_ELIMINATION_PLAN_PDF

    #---------------------------------------------------------------------------
    def initialize()
        @f2f_types = [
            "ADO - Agora Day Out",                                  
            "Home Visit",                         
            "Home Visit (Unscheduled)",                                    
            "Small Group"                            
        ]
    end
    #---------------------------------------------------------------------------
    
    def generate_pdf(sid, pdf = nil)
        s   = $students.attach(sid)
        logo_path = "#{$paths.templates_path}images/agora_logo.jpg"
    
        render_required = false
        if !pdf
            render_required = true
            file_name = "withdraw_report_#{sid}_#{s.last_name.value}_#{s.first_name.value}_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Attendance/TEP")
            pdf       = Prawn::Document.new
        end
    
        #DOCUMENT GRID
        pdf.define_grid(:columns => 2, :rows => 20, :gutter => 10)
    
        #MAIN BOUNDING BOX
        page_width = 520
        page_height = 700
        pdf.bounding_box([10, 725], :width => page_width, :height => page_height) do
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
            #TITLE
            pdf.grid([3,0], [3,1]).bounding_box do
                #pdf.stroke_bounds
                text = "<b>Truancy Elimination Plan (TEP)</b>"
                pdf.text text, :align => :center, :size => 16, :inline_format => true
            end
            pdf.move_down 15
            pdf.text "The purpose of this agreement is to increase student attendance and eliminate the reasons for the unexcused absences accumulated to date.  Our mission is to prepare and inspire students to meet their academic potential and absences are a barrier to reaching this mission. We want to help in any way we can, but we need all students to communicate and engage with our teachers and staff every scheduled school day via logging into the online school, attending scheduled direct instruction and submitting work assignments in a timely manner."
            pdf.move_down 10
            pdf.text "As we complete this plan we will consider the following:"
            pdf.indent(25) do
                pdf.text "• Appropriateness of the Agora's educational model and environment", :inline_format => true
                pdf.text "• Possible elements of the school environment that inhibit student success"
                pdf.text "• Student's current academic level and needs"
                pdf.text "• Social, emotional, physical, mental and behavioral health issues"
                pdf.text "• Issues concerning family and home environment or any other issues affecting attendance"
            end
            pdf.move_down 10
            pdf.text "Agora is obligated by law, to continue to inform local school districts of the accumulation of additional unexcused absences which will result in the possible engagement of the Magisterial District Judge. In the event that habitual absences continue to occur, Agora or your local school district will contact the student's County Children and Youth Agency to determine if there are family problems that are causing the truant behavior, or possible adjudication as a \"dependent\" child under the Juvenile Act."
            pdf.move_down 10
            pdf.text "Your commitment and daily involvement in your child's education will ensure their success at Agora Cyber Charter School.  Together we would like to help your child become successful, and attending school daily is the first step. Thank you in advance for taking this matter very seriously. Your child's status at our school depends on it."
            pdf.move_down 20
            info = $tables.attach("Student_Tep_Agreement").by_studentid_old(sid).fields
            
            pdf.text "<b>Date:</b> #{info["date_conducted"].to_user}", :inline_format=>true
            pdf.text "<b>Goal:</b> #{info["goal"].to_user}", :inline_format=>true
            f2f = info["face_to_face"].value == "1" ? "Yes" : "No"
            pdf.text "<b>Face To Face:</b> #{f2f}", :inline_format=>true
            pdf.text "<b>Name of Student:</b> #{s.fullname.value}", :inline_format=>true
            pdf.bounding_box([0, pdf.cursor-20], :width=>page_width, :height=>75) do
                pdf.stroke_bounds
                pdf.text "<u>Special Needs</u>(ex. Health Concerns)", :inline_format=>true
                pdf.text info["special_needs"].to_user
            end
            pdf.move_down 20
            pdf.text "<b>Absences</b>", :inline_format=>true
            absence_header = ["<b>Date of Absence</b>", "<b>Excused (Y/N)</b>", "<b>Reasons for Absence</b>", "<b>Action Taken By Agora</b>"]
            absence_array  = Array.new
            absence_rows   = $tables.attach("Student_Tep_Absence_Reasons").by_studentid_old(sid)
            absence_rows.each do |row|
                fields = row.fields
                absence_array.push([
                    fields["att_date"    ].to_user,
                    fields["excused"     ].to_user,
                    fields["reason"      ].to_user,
                    fields["agora_action"].to_user
                ])
            end if absence_rows
            pdf.table absence_array.insert(0,absence_header), :header => true, :cell_style => { :inline_format => true }
            pdf.move_down 20
            pdf.text "<b>Strengths</b>", :inline_format=>true
            strength_header = ["<b>Description</b>", "<b>Relevance to the Plan</b>"]
            strength_array  = Array.new
            strength_rows   = $tables.attach("Student_Tep_Strengths").by_studentid_old(sid)
            strength_rows.each do |row|
                fields = row.fields
                strength_array.push([
                    fields["description"].to_user,
                    fields["relevance"  ].to_user
                ])
            end if strength_rows
            pdf.table strength_array.insert(0,strength_header), :header => true, :cell_style => { :inline_format => true }
            pdf.move_down 20
            pdf.text "<b>Assessment & Solutions</b>", :inline_format=>true
            assessment_header = ["<b>Description</b>", "<b>Solutions</b>", "<b>Responsible Parties</b>", "<b>Completion Date</b>"]
            assessment_array  = Array.new
            assessment_rows   = $tables.attach("Student_Tep_Assessments").by_studentid_old(sid)
            assessment_rows.each do |row|
                fields = row.fields
                assessment_array.push([
                    fields["description"        ].to_user,
                    fields["solution"           ].to_user,
                    fields["responsible_parties"].to_user,
                    fields["completion_date"    ].to_user
                ])
            end if assessment_rows
            pdf.table assessment_array.insert(0,assessment_header), :header => true, :cell_style => { :inline_format => true }
            pdf.move_down 20
            pdf.text "<b>Consequences for non-compliance</b>", :inline_format=>true
            consequences_array = Array.new
            consequences_rows = $tables.attach("Student_Tep_Prosncons").by_type(sid, "Consequence")
            consequences_rows.each{|row|
                fields = row.fields
                consequences_array.push([
                    fields["description"].to_user
                ])
            } if consequences_rows
            pdf.table consequences_array, :cell_style => { :width => page_width } if consequences_rows
            pdf.move_down 20
            pdf.text "<b>Benefits for Compliance</b>", :inline_format=>true
            benifits_array = Array.new
            benifits_rows = $tables.attach("Student_Tep_Prosncons").by_type(sid, "Benefit")
            benifits_rows.each do |row|
                fields = row.fields
                benifits_array.push([
                    fields["description"].to_user
                ])
            end if benifits_rows
            pdf.table benifits_array, :cell_style => { :width => page_width } if benifits_rows
            pdf.move_down 20
            pdf.text "This TEP was created collaboratively to assist the student in improving attendance, to enlist the support of parents/guardians and to document the school's attempts to provide resources to promote student success."
            pdf.move_down 20
            pdf.text "<b>Student:</b> <u>                                                                 , #{s.first_name.value} #{s.last_name.value}</u>          <b>Date:</b><u>#{info["date_conducted"].to_user.split(" ").first}</u>", :inline_format=>true
            pdf.move_down 15
            pdf.text "<b>Parent or Guardian:</b> <u>                                              , Legal Guardian</u>                   <b>Date:</b><u>#{info["date_conducted"].to_user.split(" ").first}</u>", :inline_format=>true
            pdf.move_down 15
            pdf.text "<b>Family Coach:</b> <u>                                                       , #{s.family_teacher_coach.value}</u>                     <b>Date:</b><u>#{info["date_conducted"].to_user.split(" ").first}</u>", :inline_format=>true
            pdf.move_down 20
            
            pdf.text "<b>Note on follow up meetings</b>", :inline_format=>true
            notes_header    = ["<b>Date</b>", "<b>Contacted By</b>", "<b>Face to Face</b>", "<b>Notes</b>"]
            notes_array     = Array.new
            pids   = $tables.attach("Student_Contacts").primary_ids("WHERE student_id = #{sid} AND (tep_initial IS TRUE OR tep_followup IS TRUE)")
            pids.each{|pid|
                
                record = $tables.attach("Student_Contacts").by_primary_id(pid)
                notes_array.push([
                    record.fields["datetime"   ].to_user,
                    record.fields["created_by" ].to_user,
                    @f2f_types.include?(record.fields["contact_type"].to_user) ? "Yes" : "No",
                    record.fields["notes"      ].to_user
                ])
                
            } if pids
            #
            #fields = notes_row.fields
            #notes_array.push([
            #    fields["datetime"   ].to_user,
            #    fields["created_by" ].to_user,
            #    @f2f_types.include?(fields["type"].to_user) ? "Yes" : "No",
            #    fields["notes"      ].to_user
            #])if notes_row
            pdf.table notes_array.insert(0,notes_header), :header => true, :cell_style => { :inline_format => true }
            ########################################################################
            pdf.render_file "#{file_path}#{file_name}" if render_required
            
        end
        
        return "#{file_path}#{file_name}"
        
    end
    
end