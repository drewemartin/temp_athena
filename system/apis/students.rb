#!/usr/local/bin/ruby
require "#{$paths.api_path}/student/student"
require "#{$paths.api_path}/student_api"

class Students

    #---------------------------------------------------------------------------
    def initialize()
        @structure = nil
    end
    #---------------------------------------------------------------------------
    
    def get(sid)
        
        s=Student_API.new(sid)
        
        if s.exists?
            return s
        else
            return false
        end
        
    end
    
    def enrolled
        
        list(:complete_enrolled=>true)
        
    end
    
    def process_attendance(a)
    #:student_id
    #:date
        
        if !structure.has_key?(:attendance_processing)
            
            require "#{$paths.system_path}data_processing/Attendance_Processing"
            structure[:attendance_processing] = Attendance_Processing.new
            
        end
      
        if structure[:attendance_processing].set_student(a[:student_id], a[:date])
            structure[:attendance_processing].finalize
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attach(sid)
        return Student.new(sid)
        #if structure.has_key?(sid)
        #    return structure[sid]
        #else
        #    structure[sid] = Student.new(sid)
        #    return structure[sid]
        #end  
    end
    
    def by_title1teacher(teacher_name)
        $tables.attach("K12_Omnibus").students_by_title1teacher(teacher_name)
    end
    
    def list(options = nil)
        $tables.attach("Student_Relate").students_group(options)
    end
    
    def current_students
        $tables.attach("K12_Omnibus").current_students
    end
    
    def current_k2_students
        $tables.attach("K12_Omnibus").current_k2_students
    end
    
    def current_36_students
        $tables.attach("K12_Omnibus").current_36_students
    end
    
    def current_k6_students
        $tables.attach("K12_Omnibus").current_k6_students
    end
    
    def current_pssa_students
        $tables.attach("K12_Omnibus").current_pssa_students
    end
    
    def current_specialed_students
        $tables.attach("K12_Omnibus").current_specialed_students
    end
    
    #additional_fields_arr = [{:field_name=>"Field Header"}]
    def data_table(sids, additional_fields_arr=nil, join_string=String.new, where_addon=String.new)
        $tables.attach("student").student_data_table(sids, additional_fields_arr, join_string, where_addon) 
    end
    
    def detach(sid)
        if structure.has_key?(sid)
            structure.delete(sid)
        end
    end
    
    def k6
        $tables.attach("K12_Omnibus").current_k6_students
    end
    
    def newly_enrolled
        $tables.attach("K12_Omnibus").newly_enrolled
    end
    
    def unexcused_absences_current_students
        output = Hash.new
        $tables.attach("K12_Omnibus").current_students.each{|sid|
            student = attach(sid)
            output[sid] = Hash.new
            output[sid]["grade"] = student.grade.value
            output[sid]["unexcused_absences"] = student.attendance.unexcused_absences
            detach(sid)
        }
        return output
    end
    
    def with_progress_reports(grade_level = nil)
        return $tables.attach("K6_Progress").students_with_records(grade_level)
    end

    #If changes are made to withdrawin eligible criteria they must be made here and in the student relate table.
    def withdrawing_eligible(option)
        $tables.attach("Withdrawing").withdrawing_eligible
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def set_structure(arg)
        if arg.is_a? Hash
            arg.each_pair{|k, v| @structure[k] = v}
        end
    end
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
end