#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RRI_RECIPIENTS < Athena_Table
    
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_rri_recipients",
                "file_name"         => "student_rri_recipients.csv",
                "file_location"     => "student_rri_recipients",
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
            
            structure_hash["fields"]["rri_request_id"   ] = {"data_type"=>"int",  "file_field"=>"rri_request_id"} if field_order.push("rri_request_id"  )
            structure_hash["fields"]["attn"             ] = {"data_type"=>"text", "file_field"=>"attn"          } if field_order.push("attn"            )
            structure_hash["fields"]["via_mail"         ] = {"data_type"=>"bool", "file_field"=>"via_mail"      } if field_order.push("via_mail"        )
            structure_hash["fields"]["address_1"        ] = {"data_type"=>"text", "file_field"=>"address_1"     } if field_order.push("address_1"       )
            structure_hash["fields"]["address_2"        ] = {"data_type"=>"text", "file_field"=>"address_2"     } if field_order.push("address_2"       )
            structure_hash["fields"]["city"             ] = {"data_type"=>"text", "file_field"=>"city"          } if field_order.push("city"            )
            structure_hash["fields"]["state"            ] = {"data_type"=>"text", "file_field"=>"state"         } if field_order.push("state"           )
            structure_hash["fields"]["zip"              ] = {"data_type"=>"text", "file_field"=>"zip"           } if field_order.push("zip"             )
            structure_hash["fields"]["via_fax"          ] = {"data_type"=>"bool", "file_field"=>"via_fax"       } if field_order.push("via_fax"         )
            structure_hash["fields"]["fax_number"       ] = {"data_type"=>"text", "file_field"=>"fax_number"    } if field_order.push("fax_number"      )
            structure_hash["fields"]["via_email"        ] = {"data_type"=>"bool", "file_field"=>"via_email"     } if field_order.push("via_email"       )
            structure_hash["fields"]["email_address"    ] = {"data_type"=>"text", "file_field"=>"email_address" } if field_order.push("email_address"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end