#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SE_ACCOMMODATIONS < Athena_Table
    
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
    
    def after_load_sapphire_student_se_accommodations
        
        #UPDATE STUDENT SE ACCOMMODATIONS
        sids = $tables.attach("SAPPHIRE_STUDENT_SE_ACCOMMODATIONS").student_ids
        
        sids.each{|sid|
            
            if student = $students.get(sid)
                
                student.se_accommodations.existing_record || student.se_accommodations.new_record.save
                
                field_order.each{|field_name|
                    
                    unless field_name.match(/student_id|created_by|created_date/)
                        
                        sapphire_field_value            = $tables.attach("SAPPHIRE_STUDENT_SE_ACCOMMODATIONS").primary_ids("WHERE student_id = '#{sid}' AND accommodation_code REGEXP '#{field_name.gsub("_","-")}'")
                        sapphire_accomodation_status    = sapphire_field_value ? true : false
                        student.se_accommodations.send(field_name).set(sapphire_accomodation_status).save
                        
                    end
                    
                }
                
            end
            
        } if sids
        
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
                "name"              => "student_se_accommodations",
                "file_name"         => "student_se_accommodations.csv",
                "file_location"     => "student_se_accommodations",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"    } if field_order.push("student_id"      )
            
            #SETTING BASED ACCOMMODATIONS
            structure_hash["fields"]["sg6_12"           ] = {"data_type"=>"bool", "file_field"=>"sg6_12"        } if field_order.push("sg6_12"          )
            structure_hash["fields"]["sg5"              ] = {"data_type"=>"bool", "file_field"=>"sg5"           } if field_order.push("sg5"             )
            structure_hash["fields"]["1_1sep"           ] = {"data_type"=>"bool", "file_field"=>"1_1sep"        } if field_order.push("1_1sep"          )
            structure_hash["fields"]["1_1home"          ] = {"data_type"=>"bool", "file_field"=>"1_1home"       } if field_order.push("1_1home"         )
            structure_hash["fields"]["1_1onsite"        ] = {"data_type"=>"bool", "file_field"=>"1_1onsite"     } if field_order.push("1_1onsite"       )
            
            #NON-SETTING BASED ACCOMMODATIONS
            structure_hash["fields"]["aims"             ] = {"data_type"=>"bool", "file_field"=>"aims"          } if field_order.push("aims"            )
            structure_hash["fields"]["chngsch"          ] = {"data_type"=>"bool", "file_field"=>"chngsch"       } if field_order.push("chngsch"         )
            structure_hash["fields"]["bubble"           ] = {"data_type"=>"bool", "file_field"=>"bubble"        } if field_order.push("bubble"          )
            structure_hash["fields"]["overlay"          ] = {"data_type"=>"bool", "file_field"=>"overlay"       } if field_order.push("overlay"         )
            structure_hash["fields"]["comdev"           ] = {"data_type"=>"bool", "file_field"=>"comdev"        } if field_order.push("comdev"          )
            structure_hash["fields"]["enlg"             ] = {"data_type"=>"bool", "file_field"=>"enlg"          } if field_order.push("enlg"            )
            structure_hash["fields"]["extraspac"        ] = {"data_type"=>"bool", "file_field"=>"extraspac"     } if field_order.push("extraspac"       )
            structure_hash["fields"]["fb20"             ] = {"data_type"=>"bool", "file_field"=>"fb20"          } if field_order.push("fb20"            )
            structure_hash["fields"]["fb30"             ] = {"data_type"=>"bool", "file_field"=>"fb30"          } if field_order.push("fb30"            )
            structure_hash["fields"]["fb60"             ] = {"data_type"=>"bool", "file_field"=>"fb60"          } if field_order.push("fb60"            )
            structure_hash["fields"]["fbwmove"          ] = {"data_type"=>"bool", "file_field"=>"fbwmove"       } if field_order.push("fbwmove"         )
            structure_hash["fields"]["lineup"           ] = {"data_type"=>"bool", "file_field"=>"lineup"        } if field_order.push("lineup"          )
            structure_hash["fields"]["la9"              ] = {"data_type"=>"bool", "file_field"=>"la9"           } if field_order.push("la9"             )
            structure_hash["fields"]["la4"              ] = {"data_type"=>"bool", "file_field"=>"la4"           } if field_order.push("la4"             )
            structure_hash["fields"]["la8"              ] = {"data_type"=>"bool", "file_field"=>"la8"           } if field_order.push("la8"             )
            structure_hash["fields"]["la2"              ] = {"data_type"=>"bool", "file_field"=>"la2"           } if field_order.push("la2"             )
            structure_hash["fields"]["la3"              ] = {"data_type"=>"bool", "file_field"=>"la3"           } if field_order.push("la3"             )
            structure_hash["fields"]["la10"             ] = {"data_type"=>"bool", "file_field"=>"la10"          } if field_order.push("la10"            )
            structure_hash["fields"]["la14"             ] = {"data_type"=>"bool", "file_field"=>"la14"          } if field_order.push("la14"            )
            structure_hash["fields"]["la"               ] = {"data_type"=>"bool", "file_field"=>"la"            } if field_order.push("la"              )
            structure_hash["fields"]["la6"              ] = {"data_type"=>"bool", "file_field"=>"la6"           } if field_order.push("la6"             )
            structure_hash["fields"]["la5"              ] = {"data_type"=>"bool", "file_field"=>"la5"           } if field_order.push("la5"             )
            structure_hash["fields"]["la7"              ] = {"data_type"=>"bool", "file_field"=>"la7"           } if field_order.push("la7"             )
            structure_hash["fields"]["la13"             ] = {"data_type"=>"bool", "file_field"=>"la13"          } if field_order.push("la13"            )
            structure_hash["fields"]["la11"             ] = {"data_type"=>"bool", "file_field"=>"la11"          } if field_order.push("la11"            )
            structure_hash["fields"]["la12"             ] = {"data_type"=>"bool", "file_field"=>"la12"          } if field_order.push("la12"            )
            structure_hash["fields"]["mtr"              ] = {"data_type"=>"bool", "file_field"=>"mtr"           } if field_order.push("mtr"             )
            structure_hash["fields"]["ptss"             ] = {"data_type"=>"bool", "file_field"=>"ptss"          } if field_order.push("ptss"            )
            structure_hash["fields"]["prefseat"         ] = {"data_type"=>"bool", "file_field"=>"prefseat"      } if field_order.push("prefseat"        )
            structure_hash["fields"]["pswd"             ] = {"data_type"=>"bool", "file_field"=>"pswd"          } if field_order.push("pswd"            )
            structure_hash["fields"]["psback"           ] = {"data_type"=>"bool", "file_field"=>"psback"        } if field_order.push("psback"          )
            structure_hash["fields"]["psfront"          ] = {"data_type"=>"bool", "file_field"=>"psfront"       } if field_order.push("psfront"         )
            structure_hash["fields"]["prompts"          ] = {"data_type"=>"bool", "file_field"=>"prompts"       } if field_order.push("prompts"         )
            structure_hash["fields"]["ra"               ] = {"data_type"=>"bool", "file_field"=>"ra"            } if field_order.push("ra"              )
            structure_hash["fields"]["ramath"           ] = {"data_type"=>"bool", "file_field"=>"ramath"        } if field_order.push("ramath"          )
            structure_hash["fields"]["scribe2"          ] = {"data_type"=>"bool", "file_field"=>"scribe2"       } if field_order.push("scribe2"         )
            structure_hash["fields"]["stressbal"        ] = {"data_type"=>"bool", "file_field"=>"stressbal"     } if field_order.push("stressbal"       )
            structure_hash["fields"]["smab"             ] = {"data_type"=>"bool", "file_field"=>"smab"          } if field_order.push("smab"            )
            structure_hash["fields"]["siland2"          ] = {"data_type"=>"bool", "file_field"=>"siland2"       } if field_order.push("siland2"         )
            structure_hash["fields"]["siland1"          ] = {"data_type"=>"bool", "file_field"=>"siland1"       } if field_order.push("siland1"         )
            structure_hash["fields"]["siland3"          ] = {"data_type"=>"bool", "file_field"=>"siland3"       } if field_order.push("siland3"         )
            structure_hash["fields"]["tscblgpt"         ] = {"data_type"=>"bool", "file_field"=>"tscblgpt"      } if field_order.push("tscblgpt"        )
            structure_hash["fields"]["tscbmulti"        ] = {"data_type"=>"bool", "file_field"=>"tscbmulti"     } if field_order.push("tscbmulti"       )
            structure_hash["fields"]["tscball"          ] = {"data_type"=>"bool", "file_field"=>"tscball"       } if field_order.push("tscball"         )
            structure_hash["fields"]["tscbopen"         ] = {"data_type"=>"bool", "file_field"=>"tscbopen"      } if field_order.push("tscbopen"        )
            structure_hash["fields"]["hgl"              ] = {"data_type"=>"bool", "file_field"=>"hgl"           } if field_order.push("hgl"             )
            structure_hash["fields"]["numline"          ] = {"data_type"=>"bool", "file_field"=>"numline"       } if field_order.push("numline"         )
            structure_hash["fields"]["scribe"           ] = {"data_type"=>"bool", "file_field"=>"scribe"        } if field_order.push("scribe"          )
            structure_hash["fields"]["abacus"           ] = {"data_type"=>"bool", "file_field"=>"abacus"        } if field_order.push("abacus"          )
            structure_hash["fields"]["manip"            ] = {"data_type"=>"bool", "file_field"=>"manip"         } if field_order.push("manip"           )
            structure_hash["fields"]["music"            ] = {"data_type"=>"bool", "file_field"=>"music"         } if field_order.push("music"           )
            structure_hash["fields"]["reinforce"        ] = {"data_type"=>"bool", "file_field"=>"reinforce"     } if field_order.push("reinforce"       )
            structure_hash["fields"]["wrdprc"           ] = {"data_type"=>"bool", "file_field"=>"wrdprc"        } if field_order.push("wrdprc"          )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end