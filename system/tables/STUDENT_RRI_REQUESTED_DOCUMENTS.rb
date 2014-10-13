#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RRI_REQUESTED_DOCUMENTS < Athena_Table
    
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

    def after_change_field_status(obj)
        
        ready_ids = $tables.attach("RRI_STATUS").primary_ids("WHERE status REGEXP 'ready'")
        if ready_ids && ready_ids.include?(obj.value)
            
            subject                 = ""
            content                 = ""
            
            user_email = $user.class == String ? $user : $user.email_address_k12.value
            unless $software_team.include?(user_email)
                
                $base.email.send(:recipients => $software_team,
                                 :subject => subject,
                                 :content => content
                                )
                
            end
            
        end if ready_ids
        
    end

    def after_insert(obj)
        
        record = by_primary_id(obj.primary_id)
        
        if $tables.attach("RRI_DOCUMENT_TYPES").primary_ids(
            
            "WHERE primary_id     = '#{record.fields["record_type_id"].value}'
            AND document_category = 'Transcripts'"
         
        )
            
            subject                 = ""
            content                 = ""

            user_email = $user.class == String ? $user : $user.email_address_k12.value
            unless $software_team.include?(user_email)
                
                $base.email.send(:recipients => $software_team,
                                 :subject => subject,
                                 :content => content
                                )
                
            end
            
        elsif $tables.attach("RRI_DOCUMENT_TYPES").primary_ids(
            
            "WHERE primary_id       = '#{record.fields["record_type_id"].value}'
            AND document_category   = 'Medical Records'"
            
        )
            
            subject                 = ""
            content                 = ""

            user_email = $user.class == String ? $user : $user.email_address_k12.value
            unless $software_team.include?(user_email)
                
                $base.email.send(:recipients => $software_team,
                                 :subject => subject,
                                 :content => content
                                )
                
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_rri_requested_documents",
                "file_name"         => "student_rri_requested_documents.csv",
                "file_location"     => "student_rri_requested_documents",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"student_id"        } if field_order.push("student_id"      )
            structure_hash["fields"]["rri_request_id"   ] = {"data_type"=>"int",  "file_field"=>"rri_request_id"    } if field_order.push("rri_request_id"  )
            structure_hash["fields"]["record_type_id"   ] = {"data_type"=>"int",  "file_field"=>"record_type_id"    } if field_order.push("record_type_id"  )
            structure_hash["fields"]["status"           ] = {"data_type"=>"text", "file_field"=>"status"            } if field_order.push("status"          )
            structure_hash["fields"]["date_completed"   ] = {"data_type"=>"date", "file_field"=>"date_completed"    } if field_order.push("date_completed"  )
            structure_hash["fields"]["notes"            ] = {"data_type"=>"text", "file_field"=>"notes"             } if field_order.push("notes"           )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end