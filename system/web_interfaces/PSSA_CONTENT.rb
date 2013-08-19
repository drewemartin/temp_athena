#!/usr/local/bin/ruby


class PSSA_CONTENT
    #---------------------------------------------------------------------------
    def initialize()
        @attendance_codes = [
            {:name=>"present",  :value=>"present"   },
            {:name=>"unexcused",:value=>"unexcused" }
        ]
        @js_save          = "save_attendance(this.form);"
        @dd_style         = "STYLE='font-family: monospace; font-size: 12pt; width:55px;'"
        
        if (sid = $kit.current_record) && (site_id = $kit.site_id)
            #$kit.html.basic_header #FNORD this function does not exists. 
            puts attendance(sid, site_id)
        end
    end
    #---------------------------------------------------------------------------

    def attendance(sid, site_id)
        form_content = String.new
        student      = $students.attach(sid)
        if attendance_days  = student.pssa_assignments.attendance_by_site(site_id)
            attendance_days.each{|row|
                fields      = row.fields
                code        = fields["attendance_code"].value
                code_choice = [{:name=>code,:value=>code}]
                disabled    = !code.nil? && !code.match(/unexcused|present/) ? true : false
                form_content << fields["attendance_code"].web.select(arg={:dd_choices=>disabled ? code_choice : @attendance_codes,:disabled=>disabled,:onchange=>"save_attendance(this.form,'student_#{sid}');"})
            }
        end
        $students.detach(sid)
        return form_content
    end
end