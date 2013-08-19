#!/usr/local/bin/ruby

class STUDENT_PROGRESS_K6_WEB

    #---------------------------------------------------------------------------
    def initialize(student_object)
        @structure     = nil
        self.student   = student_object
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def student_row_admin(row_num = nil)
        output = String.new
        
        open_div = row_num ? "<div class='student_row #{row_num}'>" : ""
        
        student_link_params = {
            :link_text      => student.fullname.to_web,
            :field_class    => "student_link",
            :field_name     => "sid",
            :callback       => false
        }
        student_link = student.sid.web.sym_link(student_link_params)
        
        sid_label_params = {
            :field_class    => "id_field",
        }
        sid = student.sid.value
        sid_label = student.sid.web.label(sid_label_params)
        admin_tag = $kit.tools.label("admin_tag", "Admin Verified:")
        expansion_button = $kit.tools.west_south_toggle(sid)
        expansion_div = "<DIV class = expansion_div id='expansion_#{sid}'></DIV>"
        
        verification_content = String.new
        [:Q1,:Q2,:Q3,:Q4].each do |q|
            student.progress.term = q
            v_record = student.progress.admin_verified
            if !student.progress.admin_verified || !student.progress.admin_verified.value
                ver = student.progress.term_open? ? $kit.tools.multiple_icon_ver("ui-icon-minus", v_record) : $kit.tools.icon_minus
            elsif !student.progress.admin_verified.is_true?
                ver = student.progress.term_open? ? $kit.tools.multiple_icon_ver("ui-icon-notice", v_record) : $kit.tools.icon_notice
            elsif student.progress.admin_verified.is_true?
                ver = student.progress.term_open? ? $kit.tools.multiple_icon_ver("ui-icon-check", v_record) : $kit.tools.icon_check
            end
            verification_content << ver
        end
        
        close_div = row_num ? "</div>" : ""
        
        output << open_div << student_link << sid_label << admin_tag << verification_content << expansion_button << expansion_div << close_div
    end
    
    def teacher_list_row(row_num = nil)
        output = String.new
        
        open_div = row_num ? "<div class='student_row #{row_num}'>" : ""
        
        student_link_params = {
            :link_text      => student.fullname.to_web,
            :field_class    => "student_link",
            :field_name     => "sid",
            :callback       => false
        }
        student_link = student.sid.web.sym_link(student_link_params)
        
        sid_label_params = {
            :field_class    => "id_field",
        }
        sid_label = student.sid.web.label(sid_label_params)
        
        verification_content = String.new
        [:Q1,:Q2,:Q3,:Q4].each do |q|
            student.progress.term = q
            v_record = student.progress.teacher_verified
            if !student.progress.teacher_verified || !student.progress.teacher_verified.value
                verification_content << $kit.tools.icon_minus 
            elsif !student.progress.teacher_verified.is_true?
                verification_content << $kit.tools.icon_notice
            elsif student.progress.teacher_verified.is_true?
                verification_content << $kit.tools.icon_check
            end
        end
        
        admin_verification_content = String.new
        [:Q1,:Q2,:Q3,:Q4].each do |q|
            student.progress.term = q
            v_record = student.progress.admin_verified
            if !student.progress.admin_verified || !student.progress.admin_verified.value
                admin_verification_content << $kit.tools.icon_minus 
            elsif !student.progress.admin_verified.is_true?
                admin_verification_content << $kit.tools.icon_notice
            elsif student.progress.admin_verified.is_true?
                admin_verification_content << $kit.tools.icon_check
            end
        end
        
        close_div = row_num ? "</div>" : ""
        
        output << open_div << student_link << sid_label << verification_content << "<div class = 'filler'></div>" << admin_verification_content<< close_div
    end

    def teacher_list_row_header
        output = String.new
        
        output << $kit.tools.label("teacher_header", "Teacher Verified")
        output << $kit.tools.label("admin_header",   "Admin Verified")
        
        output << $kit.tools.label("name_header", "Name")
        output << $kit.tools.label("id_header", "Student ID")
        
        output << $kit.tools.label("q1_header", "Q1")
        output << $kit.tools.label("q2_header", "Q2")
        output << $kit.tools.label("q3_header", "Q3")
        output << $kit.tools.label("q4_header", "Q4")
        
        output << $kit.tools.label("filler", "")
        
        output << $kit.tools.label("aq1_header", "Q1")
        output << $kit.tools.label("aq2_header", "Q2")
        output << $kit.tools.label("aq3_header", "Q3")
        output << $kit.tools.label("aq4_header", "Q4")
        return output
    end
    
    def teacher_list_row_header2
        output = String.new
        
        
        output << $kit.tools.label("name_header", "Name")
        output << $kit.tools.label("id_header", "Student ID")
        
        output << $kit.tools.label("q1_header", "Q1")
        output << $kit.tools.label("q2_header", "Q2")
        output << $kit.tools.label("q3_header", "Q3")
        output << $kit.tools.label("q4_header", "Q4")
        
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def student
        structure[:student]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def student=(arg)
        structure[:student] = arg
    end
    
end