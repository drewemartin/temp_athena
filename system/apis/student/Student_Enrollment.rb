#!/usr/local/bin/ruby

class Student_Enrollment

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

    def enrollment_start
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("active", studentid)
    end
    
    def initial_enrollment_year
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("initial_enrollment_year", studentid)
    end
    
    def enrollreceiveddate
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("enrollreceiveddate", studentid)
    end
    
    def enrollapproveddate
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("enrollapproveddate", studentid)
    end
    
    def schoolenrolldate
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("schoolenrolldate", studentid)
    end
    
    def districtofresidence
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("districtofresidence", studentid)
    end
    
    def withdrawreason
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("withdrawreason", studentid)
    end
    
    def withdrawdate
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("withdrawdate", studentid)
    end
    
    def schoolwithdrawdate
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("schoolwithdrawdate", studentid)
    end
    
    def do_not_call
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("do_not_call", studentid)
    end
    
    def transferring_to
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("transferring_to", studentid)
    end
    
    def enrollment_end
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("enrollment_end", studentid)
    end
    
    def active
        $tables.attach("STUDENT_ENROLLMENT").field_bystudentid("active", studentid)
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                   
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
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
        structure["student"] = arg
    end
    
    def student
        structure["student"]
    end

    def student_id
        student.student_id
    end
    
end