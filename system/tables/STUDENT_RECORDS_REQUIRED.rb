#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RECORDS_REQUIRED < Athena_Table
    
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
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load_k12_omnibus
     
        sids    = $students.list(:currently_enrolled=> true)
        
        sids.each{|sid|
            
            s = $students.get(sid)
            
            pids = $tables.attach("RECORD_REQUESTS_DOCUMENT_TYPES").primary_ids(
                
                "LEFT JOIN #{$tables.attach("student_records_required").data_base}.student_records_required ON record_requests_document_types.primary_id = student_records_required.record_type_id
                WHERE record_requests_document_types.#{s.grade.to_grade_field} IS TRUE
                AND record_requests_document_types.active IS TRUE
                AND student_records_required.primary_id IS NULL"
                
            )
            
            pids.each{|pid|
                
                r = s.records_required.new_record
                r.fields["record_type_id"].set(pid)
                r.save
                
            } if pids
            
        } if sids
        
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_records_required",
                "file_name"         => "student_records_required.csv",
                "file_location"     => "student_records_required",
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
            
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",  "file_field"=>"student_id"        } if field_order.push("student_id"      )
            structure_hash["fields"]["record_type_id"       ] = {"data_type"=>"text", "file_field"=>"record_type_id"    } if field_order.push("record_type_id"  )
            structure_hash["fields"]["compliant"            ] = {"data_type"=>"bool", "file_field"=>"compliant"         } if field_order.push("compliant"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end