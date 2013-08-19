#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class EMAIL < Athena_Table
    
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
                "name"              => "email",
                "file_name"         => "email.csv",
                "file_location"     => "email",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["subject"          ] = {"data_type"=>"text", "file_field"=>"subject"           } if field_order.push("subject"         )
            structure_hash["fields"]["content"          ] = {"data_type"=>"text", "file_field"=>"content"           } if field_order.push("content"         )
            structure_hash["fields"]["sender"           ] = {"data_type"=>"text", "file_field"=>"sender"            } if field_order.push("sender"          )
            structure_hash["fields"]["recipients"       ] = {"data_type"=>"text", "file_field"=>"recipients"        } if field_order.push("recipients"      )
            structure_hash["fields"]["attachment_name"  ] = {"data_type"=>"text", "file_field"=>"attachment_name"   } if field_order.push("attachment_name" )
            structure_hash["fields"]["attachment_path"  ] = {"data_type"=>"text", "file_field"=>"attachment_path"   } if field_order.push("attachment_path" )
            structure_hash["fields"]["success"          ] = {"data_type"=>"bool", "file_field"=>"success"           } if field_order.push("success"         )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end