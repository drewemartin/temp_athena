#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RRO_REQUIRED_DOCUMENTS < Athena_Table
    
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

    def before_load_student_rro_required_documents
     
        #IDENTIFIES STUDENTS WITH NO STUDENT_RRO_REQUIRED_DOCUMENTS ENTRIES
        #CREATES AN ENTRY FOR EACH CURRENTLY REQUIRED DOCUMENTS FOR THOSE STUDENTS
        
        sids = $tables.attach("STUDENTS").student_ids(
            "LEFT JOIN #{data_base}.#{table_name} ON #{table_name}.student_id = students.student_id
            WHERE table_name.student_id IS NULL"
        )
        
        sids.each{|sid|
            
            student = $students.get(sid)
            
            if student.previous_school.verified.is_true?
                
                where_clause = "WHERE `#{student.grade.to_grade_field}` IS TRUE"
                if student.previous_school.previous_school_state.value == "PA"    
                    where_clause << " AND previous_school_state = 'PA' "   
                else  
                    where_clause << " AND previous_school_state != 'PA' "   
                end
                
                required_documents = $tables.attach("RRO_DOCUMENT_TYPES").primary_ids(where_clause)
                
            end
            
        } if sids
        
        
        #sids = $students.list(:currently_enrolled=> true)
        #
        #sids.each{|sid|
        #    
        #    s = $students.get(sid)
        #    
        #    pids = $tables.attach("RECORD_REQUESTS_DOCUMENT_TYPES").primary_ids(
        #        
        #        "LEFT JOIN #{$tables.attach("student_records_required").data_base}.student_records_required ON record_requests_document_types.primary_id = student_records_required.record_type_id
        #        WHERE record_requests_document_types.#{s.grade.to_grade_field} IS TRUE
        #        AND record_requests_document_types.active IS TRUE
        #        AND student_records_required.primary_id IS NULL"
        #        
        #    )
        #    
        #    pids.each{|pid|
        #        
        #        r = s.records_required.new_record
        #        r.fields["record_type_id"].set(pid)
        #        r.save
        #        
        #    } if pids
        #    
        #} if sids
        #
        #return continue_with_load = false
        
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
                "name"              => "student_rro_required_documents",
                "file_name"         => "student_rro_required_documents.csv",
                "file_location"     => "student_rro_required_documents",
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
            
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",    "file_field"=>"student_id"      } if field_order.push("student_id"      )
            structure_hash["fields"]["record_type_id"       ] = {"data_type"=>"text",   "file_field"=>"record_type_id"  } if field_order.push("record_type_id"  )
            structure_hash["fields"]["status"               ] = {"data_type"=>"text",   "file_field"=>"status"          } if field_order.push("status"          )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end