#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ATTENDANCE_AP < Athena_Table
    
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
    
    def by_studentid_old(sid, staff_id = nil, date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid        ) )
        params.push( Struct::WHERE_PARAMS.new("staff_id",   "=", staff_id   ) ) if staff_id
        params.push( Struct::WHERE_PARAMS.new("date",       "=", date       ) ) if date
        where_clause = $db.where_clause(params)
        if !sid.nil? && !staff_id.nil? && !date.nil?
            record(where_clause)
        else
            records(where_clause)
        end
    end
    
    def schooldays_by_staffid(staff_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id", "=", staff_id ) )
        where_clause = $db.where_clause(params)
        
        $db.get_data_single(
            "SELECT date
            FROM student_attendance_ap
            #{where_clause}
            GROUP BY date
            ORDER BY date DESC"
        )
    end
    
    def schooldays_by_studentid(student_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id ) )
        where_clause = $db.where_clause(params)
        
        $db.get_data_single(
            "SELECT date
            FROM student_attendance_ap
            #{where_clause}
            GROUP BY date
            ORDER BY date DESC"
        )
    end
    
    def staffids_by_studentid(student_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id ) )
        where_clause = $db.where_clause(params)
        
        $db.get_data_single(
            "SELECT staff_id
            FROM student_attendance_ap
            #{where_clause}
            GROUP BY staff_id"
        )
    end
    
    def studentids_by_staffid(staff_id, dates = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",   "=",        staff_id    ) )
        params.push( Struct::WHERE_PARAMS.new("date",       "REGEXP",   dates       ) ) if dates
        where_clause = $db.where_clause(params)
        
        $db.get_data_single(
            "SELECT student_attendance_ap.student_id
            FROM student_attendance_ap
            LEFT JOIN student on student.student_id = student_attendance_ap.student_id
            #{where_clause}
            GROUP BY student_attendance_ap.student_id
            ORDER BY student.studentlastname, student.studentfirstname ASC"
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def before_load_student_attendance_ap(att_date = $idate)
        
        require "#{File.dirname(__FILE__).gsub("tables","data_processing")}/attendance_ap"
        ap_att_process = Attendance_AP.new
        
        begin
            ap_att_process.create_attendance_records(att_date = $idate)
        rescue=>e
            $base.system_notification(
                subject = "Student AP Attendance RECORD CREATION Failed!",
                content = "#{e.message}"
            )
        end
        
        begin
            ap_att_process.notice_ap_attendance(att_date = $idate)
        rescue=>e
            $base.system_notification(
                subject = "Student AP Attendance NOTIFICATION Failed!",
                content = "#{e.message}"
            )
        end
        
        continue_with_load = false
        
    end
    
    def after_change_field_attended(field_obj)
        record = by_primary_id(field_obj.primary_id)
        require "#{$paths.system_path}data_processing/Attendance_Processing"
        Attendance_Processing.new(record.fields["student_id"].value, record.fields["date"].value)
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
                "name"              => "student_attendance_ap",
                "file_name"         => "student_attendance_ap.csv",
                "file_location"     => "student_attendance_ap",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"                               ] = {"data_type"=>"int",  "file_field"=>"student_id"                            } if field_order.push("student_id")
            structure_hash["fields"]["staff_id"                                 ] = {"data_type"=>"int",  "file_field"=>"staff_id"                              } if field_order.push("staff_id")
            structure_hash["fields"]["date"                                     ] = {"data_type"=>"date", "file_field"=>"date"                                  } if field_order.push("date")
            structure_hash["fields"]["live_session_attended_required"           ] = {"data_type"=>"bool", "file_field"=>"live_session_attended_required"        } if field_order.push("live_session_attended_required")
            structure_hash["fields"]["live_session_attended_engaged"            ] = {"data_type"=>"bool", "file_field"=>"live_session_attended_engaged"         } if field_order.push("live_session_attended_engaged")
            structure_hash["fields"]["live_session_participated_required"       ] = {"data_type"=>"bool", "file_field"=>"live_session_participated_required"    } if field_order.push("live_session_participated_required")
            structure_hash["fields"]["live_session_participated_engaged"        ] = {"data_type"=>"bool", "file_field"=>"live_session_participated_engaged"     } if field_order.push("live_session_participated_engaged")
            structure_hash["fields"]["help_session_required"                    ] = {"data_type"=>"bool", "file_field"=>"help_session_required"                 } if field_order.push("help_session_required")
            structure_hash["fields"]["help_session_engaged"                     ] = {"data_type"=>"bool", "file_field"=>"help_session_engaged"                  } if field_order.push("help_session_engaged")
            structure_hash["fields"]["office_hours_required"                    ] = {"data_type"=>"bool", "file_field"=>"office_hours_required"                 } if field_order.push("office_hours_required")
            structure_hash["fields"]["office_hours_engaged"                     ] = {"data_type"=>"bool", "file_field"=>"office_hours_engaged"                  } if field_order.push("office_hours_engaged")
            structure_hash["fields"]["assignment_completion_required"           ] = {"data_type"=>"bool", "file_field"=>"assignment_completion_required"        } if field_order.push("assignment_completion_required")
            structure_hash["fields"]["assignment_completion_engaged"            ] = {"data_type"=>"bool", "file_field"=>"assignment_completion_engaged"         } if field_order.push("assignment_completion_engaged")
            structure_hash["fields"]["assessment_completion_requied"            ] = {"data_type"=>"bool", "file_field"=>"assessment_completion_requied"         } if field_order.push("assessment_completion_requied")
            structure_hash["fields"]["assessment_completion_engaged"            ] = {"data_type"=>"bool", "file_field"=>"assessment_completion_engaged"         } if field_order.push("assessment_completion_engaged")
            structure_hash["fields"]["attended"                                 ] = {"data_type"=>"bool", "file_field"=>"attended"                              } if field_order.push("attended")
            structure_hash["fields"]["notes"                                    ] = {"data_type"=>"text", "file_field"=>"notes"                                 } if field_order.push("notes")

        structure_hash["field_order"] = field_order
        return structure_hash
    end

end