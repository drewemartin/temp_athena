#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class KMAIL < Athena_Table
    
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