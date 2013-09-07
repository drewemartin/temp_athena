#!/usr/local/bin/ruby

class School

    #---------------------------------------------------------------------------
    def initialize()
        @structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def active_terms
        $tables.attach("Progress_Report_Schedule").active_terms()
    end
    
    def attendance_reports
        return $tables.attach("Attendance_Report_Schedule").records
    end
    
    def attendance_reports_by_pid(pid)
        return $tables.attach("Attendance_Report_Schedule").by_primary_id(pid)
    end
    
    def attendance_recipients(report_id)
        return $tables.attach("Attendance_Report_Recipients").by_report_id(report_id)
    end
    
    def current_school_year
        
        if $tables.attach("School_Year_Detail").exists?
            
            if !(sy = $tables.attach("School_Year_Detail").record("WHERE current IS TRUE"))
                
                sy = $tables.attach("School_Year_Detail").new_row
                sy.fields["school_year" ].value = $config.school_year_installed
                sy.fields["current"     ].value = true
                sy.save
                
                sy = $tables.attach("School_Year_Detail").record("WHERE current IS TRUE")
                
            end
            
            sy.fields["school_year"].value
            
        else
            $config.school_year_installed
        end
        
    end
    
    def current_school_year_start
        if !structure.has_key?(:current_school_year_start)
            structure[:current_school_year_start] = $tables.attach("School_Year_Detail").current.fields["start_date"]
        end
        structure[:current_school_year_start]
    end
    
    def current_school_year_end
        if !structure.has_key?(:current_school_year_end)
            structure[:current_school_year_end] = $tables.attach("School_Year_Detail").current.fields["end_date"]
        end
        structure[:current_school_year_end]
    end
    
    def current_term
        results = $tables.attach("Progress_Report_Schedule").current_term
        return results ? results.fields["term"] : false
    end
    
    def current_schooldays_total
        if !structure.has_key?(:current_schooldays_total)
            structure[:current_schooldays_total] = $tables.attach("School_Year_Detail").field_byschoolyear("school_days", current_school_year.value)
        end
        structure[:current_schooldays_total]
    end
    
    def department_by_id(id)
        return $tables.attach("Staff_Departments").by_department_id(id)
    end
    
    def ink_record_by_pid(pid)
        return $tables.attach("Ink_Orders").by_primary_id(pid)
    end
    
    def school_name
        return "agora" #FNORD - Set to pull actual school name
    end
    
    def pssa_record_by_pid(pid)
        return $tables.attach("Pssa").by_primary_id(pid)
    end
    
    def schooldays_by_range(start_date, end_date, order_option = "ASC")
        $tables.attach("Attendance_Master").schooldays_by_range(start_date, end_date, order_option)
    end
    
    def school_days(cutoff_date = nil, order_option = "ASC")
        where_clause = String.new
        where_clause << "WHERE date <= '#{cutoff_date}' " if cutoff_date
        where_clause << "ORDER BY `date` #{order_option}"
        return $tables.attach("SCHOOL_DAYS").find_fields("date", where_clause, {:value_only=>true})
    end
    
    def school_days_after(start_date)
        
        $tables.attach("school_days").find_fields("date", "WHERE date >= '#{start_date}'", {:value_only=>true})
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def classes
        if !structure.has_key?("classes")
            require "#{File.dirname(__FILE__)}/school/classes"
            structure["classes"] = Classes.new
        end
        structure["classes"]
    end
    
    def ink
        if !structure.has_key?(:ink)
            require "#{File.dirname(__FILE__)}/school/school_ink"
            structure[:ink] = School_Ink.new
        end
        structure[:ink]
    end
    
    def progress_reports
        if !structure.has_key?(:progress_reports)
            require "#{File.dirname(__FILE__)}/school/school_progress_reports"
            structure[:progress_reports] = School_Progress_Reports.new
        end
        structure[:progress_reports]
    end
    
    def pssa
        if !structure.has_key?(:pssa_assignments)
            require "#{File.dirname(__FILE__)}/school/school_pssa"
            structure[:pssa_assignments] = School_Pssa.new
        end
        structure[:pssa_assignments]
    end
    
    def scantron
        if !structure.has_key?(:scantron)
            require "#{File.dirname(__FILE__)}/school/school_scantron"
            structure[:scantron] = School_Scantron.new
        end
        structure[:scantron]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DD_Choices
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def school_years_dd()
        output = []
        if current_sy = $tables.attach("School_Year_Detail").current
            current_sy = current_sy.fields["school_year"].value
            temp = current_sy.split("-")
            max_year = temp[1].to_i
            i = max_year
            while i > max_year-20
                output.push({:name=>"#{i-1}-#{i}", :value=>"#{i-1}-#{i}"})
                i-=1
            end
            return output
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def new_row(table_name)
        this_row = $tables.attach(table_name).new_row
        this_row.field["school_name"].value = school_name if this_row.field["school_name"]
        return this_row
    end
    
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

end