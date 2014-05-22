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
        
        t_stu       = $tables.attach("STUDENT")
        t_prev_sch  = $tables.attach("STUDENT_PREVIOUS_SCHOOL")
        t_s_rro_rec = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS")
        
        sids = t_stu.student_ids(
            "LEFT JOIN #{t_s_rro_rec.data_base}.#{t_s_rro_rec.table_name} ON #{t_s_rro_rec.table_name}.student_id = #{t_stu.table_name}.student_id
            LEFT JOIN #{t_prev_sch.data_base}.#{t_prev_sch.table_name} ON #{t_prev_sch.table_name}.student_id = #{t_stu.table_name}.student_id
            WHERE #{t_prev_sch.table_name}.verified IS TRUE
            AND #{t_s_rro_rec.table_name}.student_id IS NULL"
        )
        
        sids.each{|sid|
            
            required_documents = $tables.attach("RRO_DOCUMENT_TYPES").required_documents(sid)
            
            required_documents.each{|pid|
                
                req_doc = new_row()
                req_doc.fields["student_id"     ].value = sid
                req_doc.fields["record_type_id" ].value = pid
                req_doc.fields["status"         ].value = 1
                req_doc.save
                
            } if required_documents
            
        } if sids
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+s-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
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
            
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",      "file_field"=>"student_id"      } if field_order.push("student_id"      )
            structure_hash["fields"]["record_type_id"       ] = {"data_type"=>"int",      "file_field"=>"record_type_id"  } if field_order.push("record_type_id"  )
            structure_hash["fields"]["status"               ] = {"data_type"=>"int",      "file_field"=>"status"          } if field_order.push("status"          )
            structure_hash["fields"]["received_date"        ] = {"data_type"=>"datetime", "file_field"=>"received_date"   } if field_order.push("received_date"   )
            structure_hash["fields"]["notes"                ] = {"data_type"=>"text",     "file_field"=>"notes"           } if field_order.push("notes"           )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end