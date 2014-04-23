#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RECORD_REQUESTS_OUTGOING < Athena_Table
    
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

    def initial_record_request_batch
        
        sids    = $students.list(
            
            :currently_enrolled => true,
            :join_addon         => " LEFT JOIN #{$tables.attach("STUDENT_RECORD_REQUESTS_OUTGOING").data_base}.student_record_requests_outgoing ON student_record_requests_outgoing.student_id = student.student_id ",
            :where_clause_addon => " AND student_record_requests_outgoing.primary_id IS NULL "
            
        )
        
        if sids
            
            require "#{$paths.templates_path}pdf_templates/RECORD_REQUESTS_PDF"
            template = eval("RECORD_REQUESTS_PDF.new")
            
            sids.each{|sid|
                
                record = new_row
                
                record.fields["student_id"    ].set(sid                     )
                record.fields["record_type"   ].set("Initial Request"       )
                record.fields["date_requested"].set($base.right_now.to_db   )
                
                record.save
                
                document = $reports.save_document({
                    :pdf             => template.generate_pdf(sid, pdf = nil),
                    :category_name   => "Student Record Requests",
                    :type_name       => "Outgoing",
                    :document_relate => [
                        {
                            :table_name      => "STUDENT_RECORD_REQUESTS_OUTGOING",
                            :key_field       => "primary_id",
                            :key_field_value => record.primary_id
                        }
                    ],
                    :hash_return    => true
                })
                
                record.fields["document_id"   ].set(document[:document_id])
                
                record.save
             
            }
            
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_record_requests_outgoing",
                "file_name"         => "student_record_requests_outgoing.csv",
                "file_location"     => "student_record_requests_outgoing",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",        "file_field"=>"student_id"      } if field_order.push("student_id"      )
            structure_hash["fields"]["record_type"      ] = {"data_type"=>"text",       "file_field"=>"record_type"     } if field_order.push("record_type"     )
            structure_hash["fields"]["date_requested"   ] = {"data_type"=>"datetime",   "file_field"=>"date_requested"  } if field_order.push("date_requested"  )
            structure_hash["fields"]["document_id"      ] = {"data_type"=>"int",        "file_field"=>"document_id"     } if field_order.push("document_id"     )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end