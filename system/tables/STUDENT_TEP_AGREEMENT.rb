#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_TEP_AGREEMENT < Athena_Table
    
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
  
    def after_insert(this_record)
        
        sid      = this_record.fields["student_id"].value
        
        initial_tep_related_records(sid)
        
    end
    
    def before_insert(this_record)
        
        sid             = this_record.fields["student_id"].value
        
        existing_record = $tables.attach("STUDENT_TEP_AGREEMENT").by_studentid_old(sid)
        if existing_record
            
            initial_tep_related_records(sid)
            
            return false
            
        else
            
            return true
            
        end
        
    end
    
    def initial_tep_related_records(sid)
        
        student  = $students.get(sid)
        
        student.tep_strengths.new_record.save   if !student.tep_strengths.existing_records
        student.tep_prosncons.new_record.save   if !student.tep_prosncons.existing_records
        student.tep_assessments.new_record.save if !student.tep_assessments.existing_records
        
        absences = $students.attach(sid).attendance.unexcused_absences
        most_recent_schoolday = $school.school_days($idate, order_option = "DESC")[0]
        absences.delete(most_recent_schoolday)
        absences.each_key{|school_day|
            
            record = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").by_studentid_old(sid, school_day)
            
            if !record
                
                new_record = $tables.attach("STUDENT_TEP_ABSENCE_REASONS").new_row
                new_record.fields["student_id"   ].value = sid
                new_record.fields["att_date"     ].value = school_day
                new_record.fields["agora_action" ].value = "Kmail notification regarding the absence. Family Coach called Learning Coach/Legal Guardian regarding the absence."
                new_record.save
                
            end
            
        }
       
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
                "name"              => "student_tep_agreement",
                "file_name"         => "student_tep_agreement.csv",
                "file_location"     => "student_tep_agreement",
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
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",        "file_field"=>"student_id"      } if field_order.push("student_id")
            structure_hash["fields"]["special_needs"    ] = {"data_type"=>"text",       "file_field"=>"special_needs"   } if field_order.push("special_needs")
            structure_hash["fields"]["goal"             ] = {"data_type"=>"text",       "file_field"=>"goal"            } if field_order.push("goal")
            structure_hash["fields"]["conducted_by"     ] = {"data_type"=>"int",        "file_field"=>"conducted_by"    } if field_order.push("conducted_by")
            structure_hash["fields"]["face_to_face"     ] = {"data_type"=>"bool",       "file_field"=>"face_to_face"    } if field_order.push("face_to_face")
            structure_hash["fields"]["date_conducted"   ] = {"data_type"=>"datetime",   "file_field"=>"date_conducted"  } if field_order.push("date_conducted")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end