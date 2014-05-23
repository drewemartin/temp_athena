#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RRO_REQUESTS < Athena_Table
    
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

    def before_load_student_rro_requests
        
        #CREATES NEW STUDENT_RRO_REQUESTS RECORDS WHERE THE STUDENT HAS OUTSTANDING STUDENT_RRO_REQUIRED_DOCUMENTS
        #AND THE MOST RECENT PREVIOUS EXISINTG STUDENT_RRO_REQUESTS RECORD FOR THAT STUDENT HAS EXPIRED.  
        
        if auto_send = $tables.attach("RRO_SETTINGS_STATUS").primary_ids("WHERE auto_send IS TRUE")
            
            sids = $tables.attach("STUDENT_RRO_REQUIRED_DOCUMENTS").student_ids(
                "WHERE status IN(#{auto_send.join(',')})
                AND (
                    
                    ADDDATE(
                        (
                            SELECT date_requested
                            FROM student_rro_requests
                            WHERE student_rro_requests.student_id = student_rro_required_documents.student_id
                            ORDER BY date_requested DESC LIMIT 1
                        ),
                        INTERVAL #{$tables.attach("RRO_SETTINGS_DOC_EXPIRATION").field_value("expiration_interval_number", "WHERE primary_id = 1")} #{$tables.attach("RRO_SETTINGS_DOC_EXPIRATION").field_value("expiration_interval_unit", "WHERE primary_id = 1")}
                    ) <= CURRENT_TIMESTAMP()
                    
                    OR
                    
                    (
                        
                        SELECT date_requested
                        FROM student_rro_requests
                        WHERE student_rro_requests.student_id = student_rro_required_documents.student_id
                        
                    ) IS NULL
                    
                )"
            )
            
            sids.each{|sid|
                
                this_record = new_row
                this_record.fields["student_id"].value = sid
                
                file_path = $reports.save_document(
                    :pdf_template    => "RECORD_REQUESTS_PDF.rb",
                    :pdf_id          => sid,
                    :category_name   => "Student Record Requests",
                    :type_name       => "Outgoing",
                    :document_relate => [
                        {
                            :table_name      => "STUDENT_RECORD_REQUESTS_OUTGOING",
                            :key_field       => "primary_id",
                            :key_field_value => this_record.primary_id
                        }
                    ]
                )
                
                this_record.fields["document_id"    ].set(file_path.split("/").last.split(".").first)
                this_record.fields["date_requested" ].set($base.right_now.to_db)
                
                this_record.save
                
            } if sids
            
            #CREATE BATCH, SEND BATCH, MARK BATCH ID IN STUDENT_RRO_REQUESTS
            if pids = $tables.attach("STUDENT_RRO_REQUESTS").primary_ids("WHERE batch_id IS NULL")
                
                attachment_name = "mailing batch #{$idatetime}.pdf"
                attachment_path = $reports.save_document(
                    :pdf_template       => "RECORD_REQUESTS_PDF.rb",
                    :batch_ids          => pids,
                    :category_name      => "Student Record Requests",
                    :type_name          => "Outgoing",
                    :document_relate    => [
                        {
                            :table_name      => "STUDENT_RECORD_REQUESTS_OUTGOING",
                            :key_field       => "primary_id",
                            :key_field_value => record.primary_id
                        }
                    ]
                )
                
                content = "Please find the attached mailing batch for student record requests outgoing."
                
            else
                
                attachment_name     = nil
                attachment_path     = nil
                content             = "There are no record requests for today."
                
            end
            
            $team.find(:email_address=>"SMcDonnell@agora.org").send_email(
                :subject                => "Student Record Requests - Outgoing",        
                :content                => content,         
                :sender                 => "Jellyfish Jellyfish Jellyfish",
                :additional_recipients  => ["jhalverson@agora.org"],
                :attachment_name        => attachment_name, 
                :attachment_path        => attachment_path#,
                #:email_relate           => [
                #    {:table_name=>nil, :key_field=>nil, :key_field_value=>nil}
                #]
            )
            
            batch_id = attachment_path.split("/").last.split(".").first
            
            pids.each{|pid|
                
                record = $tables.attach("STUDENT_RRO_REQUESTS").by_primary_id(pid)
                record.fields["batch_id"].value = batch_id
                record.save
                
            } if pids
            
        end
        
        return continue_with_load = false
        
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
                "name"              => "student_rro_requests",
                "file_name"         => "student_rro_requests.csv",
                "file_location"     => "student_rro_requests",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",        "file_field"=>"student_id"          } if field_order.push("student_id"          )
            structure_hash["fields"]["date_requested"   ] = {"data_type"=>"datetime",   "file_field"=>"date_requested"      } if field_order.push("date_requested"      )
            structure_hash["fields"]["document_id"      ] = {"data_type"=>"int",        "file_field"=>"document_id"         } if field_order.push("document_id"         )
            structure_hash["fields"]["batch_id"         ] = {"data_type"=>"int",        "file_field"=>"batch_id"            } if field_order.push("batch_id"            )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end