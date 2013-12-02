#!/usr/local/bin/ruby

class Student_Attendance

    #---------------------------------------------------------------------------
    def initialize(student)
        @stu = student
        @structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def mode
        $tables.attach("STUDENT_ATTENDANCE_MODE").field_bystudentid("attendance_mode", studentid)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________REEVALUATE_THESE_FOR_NEW_YEAR
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def consecutive_absences(range = nil)
        #should return the absence days of a consecutive streak that ends within the range
    end
    
    def cumulative_absences(range = nil)
    end
    
    def excused_absences
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'excused'", {:value_only=>true})
        
        dates = codes ? $tables.attach("student_attendance").find_fields("date","WHERE student_id = #{@stu.studentid} AND official_code IN\('#{codes.join("','")}'\)", {:value_only=>true}) : []
        
        return dates || []
    end
    
    def excused_absences_breakdown
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'excused'", {:value_only=>true})
        
        dates = Hash.new
        
        codes.each do |code|
            
            dates[code] = $tables.attach("student_attendance").find_fields("date","WHERE student_id = #{@stu.studentid} AND official_code = '#{code}'", {:value_only=>true}) || []
            
        end
        
        return dates
    end
    
    def exists?
        return record ? true : false
    end
    
    def unexcused_absences
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'unexcused'", {:value_only=>true})
        
        dates = codes ? $tables.attach("student_attendance").find_fields("date", "WHERE student_id = #{@stu.studentid} AND official_code IN\('#{codes.join("','")}'\)", {:value_only=>true}) : []
        
        return dates || []
    end
    
    def unexcused_absences_by_range(start_date, end_date)
        code_fields = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'unexcused'")
        unexcused_days   = Hash.new
        enr_days         = enrolled_days_by_range(start_date, end_date)
        if enr_days
            enr_days.each_pair{|field_name, details|
                unexcused_days[field_name] = details if codes.include?(details.value)
            }
        end
        return unexcused_days
    end
    
    def unexcused_absences_for_previous_x(x_schooldays)
        code_fields = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'unexcused'")
        days = Hash.new
        record = record_for_previous_x(x_schooldays)
        if record
            record.fields.each_pair{|field_name, details|
                days[field_name] = details if codes.include?(details.value)
            }
            return days
        else
            return false
        end
    end
    
    def attended_days
        
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'present'", {:value_only=>true})
        
        dates = codes ? $tables.attach("student_attendance").find_fields("date", "WHERE student_id = #{@stu.studentid} AND official_code IN\('#{codes.join("','")}'\)", {:value_only=>true}) : []
        
        return dates || []
        
    end
    
    def attended_days_by_range(start_date, end_date)
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'present'")
        att_days = Hash.new
        enr_days = enrolled_days_by_range(start_date, end_date)
        if enr_days
            enr_days.each_pair{|field_name, details|
                att_days[field_name] = details if codes.include?(details.value)
            }
        end
        return att_days
    end
    
    def attended_days_for_previous_x(x_schooldays)
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = 'present'")
        att_days = Hash.new
        enr_days = enrolled_days_for_previous_x(x_schooldays)
        enr_days.each_pair{|field_name, details|
            att_days[field_name] = details if codes.include?(details.value)
        }
        return att_days
    end
    
    def enrolled_days
        
        dates = $tables.attach("student_attendance").find_fields("date", "WHERE student_id = #{@stu.studentid} AND official_code IS NOT NULL", {:value_only=>true})
        
        return dates || []
        
    end

    def enrolled_days_by_range(start_date, end_date)
        enr_days = Hash.new
        att_record = record_by_range(start_date, end_date)
        if att_record
            att_record.fields.each_pair{|field_name, details|
                unless field_name == "primary_id" || field_name == "created_by" || field_name == "created_date"
                    enr_days[field_name] = details if !details.value.nil?
                end 
            }
            return enr_days
        else
            return false
        end
    end
    
    def enrolled_days_for_previous_x(x_schooldays)
        enr_days = Hash.new
        att_record = record_for_previous_x(x_schooldays)
        if att_record
            att_record.fields.each_pair{|field_name, details|
                unless field_name == "primary_id" || field_name == "created_by" || field_name == "created_date"
                    enr_days[field_name] = details if !details.value.nil?
                end 
            }
            return enr_days
        else
            return false
        end
    end

    def rate
        if !structure.has_key?("rate")
            if !attended_days.empty?
                structure["rate"] = "#{((attended_days.length.to_f/enrolled_days.length.to_f)*100).round.to_s}%" 
            else
                structure["rate"] = "0%"
            end
        end
        structure["rate"]
    end
    
    def rate_decimal
        if !structure.has_key?(:decimal)
            if !attended_days.empty?
                structure[:decimal] = attended_days.length.to_f/enrolled_days.length.to_f
            else
                structure[:decimal] = 0
            end
        end
        structure[:decimal]
    end
    
    def rate_by_range(start_date, end_date)
        att_days = attended_days_by_range(start_date, end_date)
        if !att_days.empty?
            enr_days = enrolled_days_by_range(start_date, end_date)
            return ((att_days.length.to_f/enr_days.length.to_f)*100).round.to_s #what kind of output should this provide?
        else
            return 0
        end
    end
    
    def rate_by_range_decimal(start_date, end_date)
        att_days = attended_days_by_range(start_date, end_date)
        if !att_days.empty?
            enr_days = enrolled_days_by_range(start_date, end_date)
            return (att_days.length.to_f/enr_days.length.to_f)
        else
            return false
        end
    end
    
    def rate_for_previous_x(x_schooldays)
        att_days = attended_days_for_previous_x(x_schooldays)
        if !att_days.empty?
            enr_days = enrolled_days_for_previous_x(x_schooldays)
            return ((att_days.length.to_f/enr_days.length.to_f)*100).round.to_s #what kind of output should this provide?
        else
            return 0
        end
    end
    
    def record
        return $tables.attach("Student_Attendance_Master").by_studentid_old(@stu.studentid)
    end
    
    def record_by_range(start_date, end_date)
        a = $tables.attach("Attendance_Master")
        school_days = a.schooldays_by_range(start_date, end_date)
        if school_days
            select_str = "`primary_id`,`created_by`,`created_date`"
            school_days.each{|day| select_str << ",`#{day}`"}
            return a.selected_fields_by_studentid(@stu.studentid, select_str)
        else
            return false
        end
    end
    
    def record_for_previous_x(x_schooldays)
        a = $tables.attach("Attendance_Master")
        school_days = a.schooldays($base.today)
        #fields_str  = "`primary_id`,`created_by`,`created_date`"
        fields_str = ""
        i = 0
        while i < x_schooldays
            this_field = fields_str.empty? ? "`#{school_days.slice!(-1)}`" : ",`#{school_days.slice!(-1)}`"
            fields_str << this_field
            i += 1
        end
        return a.selected_fields_by_studentid(@stu.student_id, fields_str)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
            set_structure(struct_hash) if !struct_hash.nil?
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

end