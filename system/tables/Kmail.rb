#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class KMAIL < Athena_Table
    
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
            AND recipient_studentid     = '#{obj.fields["recipient_studentid"   ].value}'
            AND subject                 = '#{obj.fields["subject"               ].to_db}'
            AND content                 = '#{obj.fields["content"               ].to_db}'
            AND created_by              = '#{obj.fields["created_by"            ].value}'
            AND LEFT(created_date,10)   = '#{$idate                                    }'"
           
        ) 
            obj.fields["successfull"    ].value = false
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
                "name"              => "kmail",
                "file_name"         => "kmail.csv",
                "file_location"     => "kmail",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["sender"]              = {"data_type"=>"text",     "file_field"=>"sender"}                 if field_order.push("sender")
            structure_hash["fields"]["kmail_type"]          = {"data_type"=>"text",     "file_field"=>"kmail_type"}             if field_order.push("kmail_type")
            structure_hash["fields"]["recipient_studentid"] = {"data_type"=>"int",      "file_field"=>"recipient_studentid"}    if field_order.push("recipient_studentid")
            structure_hash["fields"]["recipient_name"]      = {"data_type"=>"text",     "file_field"=>"recipient_name"}         if field_order.push("recipient_name")
            structure_hash["fields"]["subject"]             = {"data_type"=>"text",     "file_field"=>"subject"}                if field_order.push("subject")
            structure_hash["fields"]["content"]             = {"data_type"=>"text",     "file_field"=>"content"}                if field_order.push("content")
            structure_hash["fields"]["attachment"]          = {"data_type"=>"text",     "file_field"=>"attachment"}             if field_order.push("attachment")
            structure_hash["fields"]["date_time_entered"]   = {"data_type"=>"datetime", "file_field"=>"date_time_entered"}      if field_order.push("date_time_entered")
            structure_hash["fields"]["date_time_sent"]      = {"data_type"=>"datetime", "file_field"=>"date_time_sent"}         if field_order.push("date_time_sent")
            structure_hash["fields"]["successfull"]         = {"data_type"=>"bool",     "file_field"=>"successfull"}            if field_order.push("successfull")
            structure_hash["fields"]["screenshot_path"]     = {"data_type"=>"text",     "file_field"=>"screenshot_path"}        if field_order.push("screenshot_path")
            structure_hash["fields"]["error"]               = {"data_type"=>"text",     "file_field"=>"error"}                  if field_order.push("error")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end