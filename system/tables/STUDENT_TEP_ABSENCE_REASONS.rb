#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_TEP_ABSENCE_REASONS < Athena_Table
    
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
    
    def by_studentid_old(sid, att_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=", sid        ) )
        params.push( Struct::WHERE_PARAMS.new("att_date",       "=", att_date   ) ) if att_date
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_omnibus_disabled
        
        sids = $tables.attach("Student_Tep_Agreement").student_ids
        
        sids.each do |sid|
            
            student = $students.get(sid)
            
            if student
            
                absences = $students.attach(sid).attendance.unexcused_absences
                absences.delete($idate)
                
                records = student.tep_absence_reasons.existing_records
                #records = by_studentid_old(sid)
                records_dates = Array.new
                records.each do |record|
                    
                    record_att_date = record.fields["att_date"].value
                    
                    if !absences.keys.include?(record_att_date)
                        record.fields["excused"].value = "1"
                        record.save
                    end
                    
                    records_dates.push(record_att_date)
                    
                end if records
                
                new_record_dates = absences.keys - records_dates
                
                new_record_dates.each do |new_record_date|
                    
                    new_record = student.tep_absence_reasons.new_record
                    new_record.fields["att_date"].value = new_record_date
                    new_record.fields["agora_action"].value = "Kmail notification regarding the absence. Family Coach called Learning Coach/Legal Guardian regarding the absence."
                    new_record.save
                    
                end if !new_record_dates.empty?
                
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
                "name"              => "student_tep_absence_reasons",
                "file_name"         => "student_tep_absence_reasons.csv",
                "file_location"     => "student_tep_absence_reasons",
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
            structure_hash["fields"]["student_id"   ] = {"data_type"=>"int",  "file_field"=>"student_id"    } if field_order.push("student_id")
            structure_hash["fields"]["att_date"     ] = {"data_type"=>"date", "file_field"=>"att_date"      } if field_order.push("att_date")
            structure_hash["fields"]["reason"       ] = {"data_type"=>"text", "file_field"=>"reason"        } if field_order.push("reason")
            structure_hash["fields"]["agora_action" ] = {"data_type"=>"text", "file_field"=>"agora_action"  } if field_order.push("agora_action")
            structure_hash["fields"]["excused"      ] = {"data_type"=>"bool", "file_field"=>"excused"       } if field_order.push("excused")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end