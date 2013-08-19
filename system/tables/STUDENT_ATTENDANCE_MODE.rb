#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ATTENDANCE_MODE < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg        ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def current_mode_by_studentid(sid)
        override = field_bystudentid("override", sid)
        return override.value.nil? ? field_bystudentid("attendance_mode", sid) : override
    end
    
    def field_bystudentid(field_name, sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def create_att_mode_records
        $students.current_students.each do |sid|
            if !by_studentid_old(sid)
                student = $students.attach(sid)
                attendance_mode = student.grade.match(/K|1st|2nd|3rd|4th|5th|6th|7th|8th/) ? "K8 Synchronous" : "HS Synchronous"
                student_attendance_mode_row = student.new_row("Student_Attendance_Mode")
                student_attendance_mode_row.fields["attendance_mode"].value = attendance_mode
                student_attendance_mode_row.save
            end
        end
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_attendance_mode",
                "file_name"         => "student_attendance_mode.csv",
                "file_location"     => "student_attendance_mode",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]      = {"data_type"=>"int",  "file_field"=>"student_id"}     if field_order.push("student_id")
            structure_hash["fields"]["attendance_mode"] = {"data_type"=>"text", "file_field"=>"attendance_mode"}if field_order.push("attendance_mode")
            
            #If this is used in web it should have the options "k8_synchronous", "k8_asynchronous", "hs_synchronous", "hs_asynchronous"
            structure_hash["fields"]["override"]        = {"data_type"=>"text", "file_field"=>"override"}       if field_order.push("override")
            structure_hash["fields"]["exempt_reason"]   = {"data_type"=>"text", "file_field"=>"exempt_reason"}  if field_order.push("exempt_reason")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end