#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class RRO_DOCUMENT_TYPES < Athena_Table
    
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

    def before_load_record_requests_outgoing_document_types
        
        #FIND ALL NEW STUDENTS WITH VERIFIED SCHOOLS
        
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
                "name"              => "rro_document_types",
                "file_name"         => "rro_document_types.csv",
                "file_location"     => "rro_document_types",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true
            }
            
            @table_structure = set_fields(structure_hash)
            
        end
        
        return @table_structure
        
    end
    
    def set_fields(structure_hash)
        
        field_order = Array.new
        
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["document_category"        ] = {"data_type"=>"text", "file_field"=>"document_category"     } if field_order.push("document_category"       )
            structure_hash["fields"]["document_name"            ] = {"data_type"=>"text", "file_field"=>"document_name"         } if field_order.push("document_name"           )
           
            structure_hash["fields"]["grade_k"                  ] = {"data_type"=>"bool", "file_field"=>"grade_k"               } if field_order.push("grade_k"                 )
            structure_hash["fields"]["grade_1st"                ] = {"data_type"=>"bool", "file_field"=>"grade_1st"             } if field_order.push("grade_1st"               )
            structure_hash["fields"]["grade_2nd"                ] = {"data_type"=>"bool", "file_field"=>"grade_2nd"             } if field_order.push("grade_2nd"               )
            structure_hash["fields"]["grade_3rd"                ] = {"data_type"=>"bool", "file_field"=>"grade_3rd"             } if field_order.push("grade_3rd"               )
            structure_hash["fields"]["grade_4th"                ] = {"data_type"=>"bool", "file_field"=>"grade_4th"             } if field_order.push("grade_4th"               )
            structure_hash["fields"]["grade_5th"                ] = {"data_type"=>"bool", "file_field"=>"grade_5th"             } if field_order.push("grade_5th"               )
            structure_hash["fields"]["grade_6th"                ] = {"data_type"=>"bool", "file_field"=>"grade_6th"             } if field_order.push("grade_6th"               )
            structure_hash["fields"]["grade_7th"                ] = {"data_type"=>"bool", "file_field"=>"grade_7th"             } if field_order.push("grade_7th"               )
            structure_hash["fields"]["grade_8th"                ] = {"data_type"=>"bool", "file_field"=>"grade_8th"             } if field_order.push("grade_8th"               )
            structure_hash["fields"]["grade_9th"                ] = {"data_type"=>"bool", "file_field"=>"grade_9th"             } if field_order.push("grade_9th"               )
            structure_hash["fields"]["grade_10th"               ] = {"data_type"=>"bool", "file_field"=>"grade_10th"            } if field_order.push("grade_10th"              )
            structure_hash["fields"]["grade_11th"               ] = {"data_type"=>"bool", "file_field"=>"grade_11th"            } if field_order.push("grade_11th"              )
            structure_hash["fields"]["grade_12th"               ] = {"data_type"=>"bool", "file_field"=>"grade_12th"            } if field_order.push("grade_12th"              )
            
            structure_hash["fields"]["in_state"                 ] = {"data_type"=>"bool", "file_field"=>"in_state"              } if field_order.push("in_state"                )
            structure_hash["fields"]["out_of_state"             ] = {"data_type"=>"bool", "file_field"=>"out_of_state"          } if field_order.push("out_of_state"            )
            structure_hash["fields"]["general_education"        ] = {"data_type"=>"bool", "file_field"=>"general_education"     } if field_order.push("general_education"       )
            structure_hash["fields"]["special_education"        ] = {"data_type"=>"bool", "file_field"=>"special_education"     } if field_order.push("special_education"       )
            
            structure_hash["fields"]["active"                   ] = {"data_type"=>"bool", "file_field"=>"active"                } if field_order.push("active"                  )
            
        structure_hash["field_order"] = field_order
        
        return structure_hash
        
    end

end