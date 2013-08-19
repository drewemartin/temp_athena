#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_COMMUNICATIONS < Athena_Table
    
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

    def after_load_k12_omnibus_disabled
        
        sids = $students.list(
            :currently_enrolled =>true,
            :join_addon         =>"LEFT JOIN student_communications ON student_communications.student_id = student.student_id",
            :where_clause_addon =>"AND k12_omnibus.registrationstatustext = 'Registering'
            AND (
                student_communications.registration_thankyou IS NOT TRUE
                OR student_communications.registration_thankyou IS NULL
            )"
        )
        
        sids.each{|sid|
            
            s = $students.get(sid)
            s.communications.existing_record || s.communications.new_record.save
            
            if !s.communications.registration_thankyou.is_true?
             
                subject = ""
                content = ""
                sender  = "office_admin"
                s.queue_kmail(subject, content, sender)
                
                s.communications.registration_thankyou.set(true).save
                
            end  
            
        } if sids
        
    end
    
    def after_load_k12_omnibus_disabled2
        
        pids = $tables.attach("COMMUNICATIONS").primary_ids(
            "WHERE CURDATE() BETWEEN start_date and end_date"
        )
        pids.each{|pid|
            
            options     = Hash.new
            param_pids  = $tables.attach("COMMUNICATIONS_PARAMETERS").primary_ids(
                "WHERE communications_id = #{pid}"
            )
            param_pids.each{|param_pid|
                
                param_record = $tables.attach("COMMUNICATIONS_PARAMETERS").by_primary_id(param_pid)
                options[:"#{param_record.fields["parameter_name"].value}"] = param_record.fields["parameter_value"].value
                
            }
            options[:student_communications]=pid
            
            sids = $students.list(options)
            sids.each{|sid|
                
                communications_record = $tables.attach("COMMUNICATIONS").by_primary_id(pid)
                
                s = $students.get(sid)
                s.queue_kmail(
                    subject = communications_record.fields["subject"].value,
                    content = communications_record.fields["content"].value,
                    sender  = communications_record.fields["sender" ].value
                )
                
                student_communications_record = $tables.attach("STUDENT_COMMUNICATIONS").record(
                    "WHERE communications_id = #{pid}
                    AND student_id = #{sid}"
                )
                if !student_communications_record
                    student_communications_record = s.communications.new_record
                    student_communications_record.fields["communications_id"].value = pid
                    student_communications_record.fields["sent"             ].value = true
                    student_communications_record.save
                else
                    student_communications_record.fields["sent"].value = true
                    
                end
                
                student_communications_record.save
                
            } if sids
            
        } if pids
        
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
                "name"              => "student_communications",
                "file_name"         => "student_communications.csv",
                "file_location"     => "student_communications",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"student_id"        } if field_order.push("student_id"          )
            structure_hash["fields"]["communications_id"] = {"data_type"=>"int",  "file_field"=>"communications_id" } if field_order.push("communications_id"   )
            structure_hash["fields"]["sent"             ] = {"data_type"=>"bool", "file_field"=>"sent"              } if field_order.push("sent"                )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end