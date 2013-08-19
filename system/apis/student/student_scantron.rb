#!/usr/local/bin/ruby

class Student_Scantron

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
    
    #returns true if participated in both reading and math
    def participated_entrance?
        m = math_performance_entrance       && !math_performance_entrance.value.nil?    && math_performance_entrance.value      != "Not Tested"
        r = reading_performance_entrance    && !reading_performance_entrance.value.nil? && reading_performance_entrance.value   != "Not Tested"
        return (m || r)
    end
    
    #returns true if participated in both reading and math
    def participated_exit?
        m = math_performance_exit           && !math_performance_exit.value.nil?        && math_performance_exit.value      != "Not Tested"
        r = reading_performance_exit        && !reading_performance_exit.value.nil?     && reading_performance_exit.value   != "Not Tested"
        return (m || r)
    end
    
    def participated_entrance_math?
        return math_performance_entrance       && !math_performance_entrance.value.nil?    && math_performance_entrance.value  != "Not Tested"
    end
    
    def participated_exit_math?
        return math_performance_exit           && !math_performance_exit.value.nil?        && math_performance_exit.value      != "Not Tested"
    end
    
    def participated_math?
        participated_entrance_math? || participated_exit_math?
    end
    
    def participated_entrance_reading?(subject = nil)
        return reading_performance_entrance    && !reading_performance_entrance.value.nil? && reading_performance_entrance.value     != "Not Tested"
    end
    
    def participated_exit_reading?
        return reading_performance_exit        && !reading_performance_exit.value.nil?     && reading_performance_exit.value         != "Not Tested"
    end
    
    def participated_reading?
        participated_entrance_reading? || participated_exit_reading?
    end
    
    def math_performance_entrance
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_perf_m", student_id)
    end
    
    def math_performance_exit
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ext_perf_m", student_id)
    end
    
    def reading_performance_entrance
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_perf_r", student_id)
    end
    
    def reading_performance_exit
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ext_perf_r", student_id)
    end
    
    def science_performance_entrance
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ent_perf_s", student_id)
    end
    
    def science_performance_exit
        $tables.attach("Scantron_Performance_Level").field_bystudentid("stron_ext_perf_s", student_id)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
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