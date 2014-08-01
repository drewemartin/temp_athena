#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_KMAIL < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure        = nil
        @duplicate_kmail_error  = false
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

    def before_insert(obj)
        
        #IF THIS INSTANCE IS A USER SESSION CHECK TO MAKE SURE THAT THE SUBJECT AND CONTENT ARE
        #NOT A DUPLICATE, IF IT IS A DUPLICATE ENTER IT INTO THE SYSTEM AS ERROR AND MARK AS SUCCESSFULL
        #RETURN FALSE AND HANDLE BY DELIVERING AN ERROR TO THE USER THAT THEY MUST CONTACT SUPPORT TO GET THIS DUPLICATE SENT
        #AT THAT POINT SUPPORT CAN SIMPLY MARK SUCCESSFULL = NULL AND CLEAR OUT THE ERROR CODE TO GET THE KMAIL TO RUN
      
        if primary_ids(
            
            "WHERE sender               = '#{obj.fields["sender"                ].value}'
            AND student_id              = '#{obj.fields["student_id"            ].value}'
            AND subject                 = '#{obj.fields["subject"               ].to_db}'
            AND content                 = '#{obj.fields["content"               ].to_db}'
            AND created_by              = '#{obj.fields["created_by"            ].value}'
            AND LEFT(created_date,10)   = '#{$idate                                    }'"
           
        ) 
            obj.fields["successful"     ].value = false
            obj.fields["error"          ].value = "DUPLICATE DETECTED"
            
            if $kit
                
                #DELIVER AN ERROR MESSAGE EXPLAINING WHY THESE KMAILS WILL NOT GO
                $kit.web_error.duplicate_kmail_error(additional_message="Duplicates are marked as sent and ignored by the system.") if !@duplicate_kmail_error
                @duplicate_kmail_error = true
                
            end
            
            #EITHER WAY MAKE SURE TO NOTIFY THE ADMINS
            $base.system_notification(
                
                subject = "MASS KMAIL - FAILED",
                content = "There was at least one kmail suspected of being a duplicate. This is based on the sender, student, subject, content and date."
                
            )
            
        else
            
            #DO NOTHING - ALL IS WELL.
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_kmail",
                "file_name"         => "student_kmail.csv",
                "file_location"     => "student_kmail",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int",      "file_field"=>"student_id"}             if field_order.push("student_id")
            structure_hash["fields"]["sender"]              = {"data_type"=>"text",     "file_field"=>"sender"}                 if field_order.push("sender")
            structure_hash["fields"]["subject"]             = {"data_type"=>"text",     "file_field"=>"subject"}                if field_order.push("subject")
            structure_hash["fields"]["content"]             = {"data_type"=>"text",     "file_field"=>"content"}                if field_order.push("content")
            structure_hash["fields"]["block_reply"]         = {"data_type"=>"bool",     "file_field"=>"block_reply"}            if field_order.push("block_reply")
            structure_hash["fields"]["sending"]             = {"data_type"=>"bool",     "file_field"=>"sending"}                if field_order.push("sending")
            structure_hash["fields"]["successful"]          = {"data_type"=>"bool",     "file_field"=>"successful"}             if field_order.push("successful")
            structure_hash["fields"]["date_time_sent"]      = {"data_type"=>"datetime", "file_field"=>"date_time_sent"}         if field_order.push("date_time_sent")
            structure_hash["fields"]["error"]               = {"data_type"=>"text",     "file_field"=>"error"}                  if field_order.push("error")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end