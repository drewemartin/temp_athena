#!/usr/local/bin/ruby

class Student_Pssa_Assignments

    #---------------------------------------------------------------------------
    def initialize(student_object)
        @structure   = nil
        self.student = student_object
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def accommodations #returns an array of rows
        $tables.attach("Pssa_Assignments_Accommodations").by_studentid_old(student_id)
    end
    
    def accommodations_by_pid(pid)
        return $tables.attach("Pssa_Assignments_Accommodations").by_primary_id(pid)
    end

    def assignment_record
        $tables.attach("Pssa_Assignments").by_studentid_old(student_id)    
    end
    
    def attendance_by_date(date)
        $tables.attach("PSSA_ATTENDANCE").by_studentid_date(student_id, date)
    end
    
    def attendance_all_sites
        $tables.attach("PSSA_ATTENDANCE").by_studentid_old(student_id)
    end
    
    def attendance_by_site(site_id)
        if !site_id.nil?
            $tables.attach("PSSA_ATTENDANCE").by_studentid_siteid(student_id, site_id)
        else
            return false
        end
    end
    
    def comments
        $tables.attach("Pssa_Assignments").field_bystudentid("comments", student_id)
    end
    
    def currently_eligible
        $tables.attach("K12_Omnibus").current_pssa_students(student_id)
    end
    
    def drop_off
        $tables.attach("Pssa_Assignments").field_bystudentid("drop_off", student_id)
    end   
    
    def test_subjects #returns and array of fields
        #3 thru 8 and 11 get reading and math.  5, 8, and 11 get writing, 4, 8, and 11 get science
        tests = Array.new
        grade = pssa_grade.value
        if grade.match(/3rd|4th|5th|6th|7th|8th|11th/)
            tests.push(reading_type,math_type)
        end
        if grade.match(/5th|8th|11th/)
            tests.push(writing_type)
        end
        if grade.match(/4th|8th|11th/)
            tests.push(science_type)
        end
        return tests
    end
    
    def math_type
        $tables.attach("Pssa_Assignments").field_bystudentid("math", student_id)
    end
    
    def office_selected
        $tables.attach("Pssa_Assignments").field_bystudentid("office_selected", student_id)
    end
    
    def one_on_one_admin
        $tables.attach("Pssa_Assignments").field_bystudentid("one_on_one_admin", student_id)
    end
    
    def one_on_one_location
        $tables.attach("Pssa_Assignments").field_bystudentid("one_on_one_location", student_id)
    end
    
    def pssa_grade
       $tables.attach("PSSA_STUDENT_EXCEPTIONS").field_bystudentid("testing_grade", student_id)  || student.grade
    end
    
    def local_district_contact
        $tables.attach("Pssa_Assignments").field_bystudentid("local_district_contact", student_id)
    end
    
    def local_district_contact_method
        $tables.attach("Pssa_Assignments").field_bystudentid("local_district_contact_method", student_id)
    end
    
    def local_district_location
        $tables.attach("Pssa_Assignments").field_bystudentid("local_district_location", student_id)
    end
    
    def pick_up
        $tables.attach("Pssa_Assignments").field_bystudentid("pick_up", student_id)
    end
    
    def reading_type
        $tables.attach("Pssa_Assignments").field_bystudentid("reading", student_id)
    end
    
    def science_type
        $tables.attach("Pssa_Assignments").field_bystudentid("science", student_id)
    end
    
    def site_address
        $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["address"]
    end
    
    def site_city
        $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["city"]
    end
    
    def site_end_date
        $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["end_date"]
    end
    
    def site_id
        $tables.attach("Pssa_Assignments").field_bystudentid("site_id", student_id)
    end
    
    def site_name
        !site_id.value.nil? ? $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["site_name"] : false
    end
    
    def site_state
        $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["state"]
    end
    
    def site_start_date
        if !site_id.value.nil?
            $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["start_date"]
        else
            return false
        end
    end
    
    def site_zip_code
        $tables.attach("Pssa_Sites").by_primary_id(site_id.value).fields["zip_code"]
    end
    
    def special_test_type
        $tables.attach("Pssa_Assignments").field_bystudentid("special_test_type", student_id)
    end
    
    def writing_type
        $tables.attach("Pssa_Assignments").field_bystudentid("writing", student_id)
    end
    
    def verification
        $tables.attach("Pssa_Assignments").field_bystudentid("verified", student_id)
    end
    
    def verified?
        return (verification && verification.value == "1") ? true : false
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def queue_site_reminder_kmail
        subject = "|student.firstnameLastname|'s PSSA Site Details for #{site_start_date.to_user(:long)}"
        content = $school.pssa.site_reminder_content(site_id.value)
        params = Hash.new
        params[:db                  ] = "athena20112012"
        params[:sender              ] = "agorapssa:tv"
        params[:subject             ] = subject
        params[:content             ] = content
        params[:recipient_studentid ] = student.studentid
        $base.queue_kmail(params)
        return student.studentid, subject, content
    end
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

    def student
        structure["student"]
    end
    
    def student=(arg)
        structure["student"] = arg
    end
    
    def student_id
        student.student_id
    end
    
end