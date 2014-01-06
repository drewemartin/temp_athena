#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_STUDENT_DEMOGRAPHICS < Athena_Table
    
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

    def after_load_sapphire_student_demographics
        
        issues  = Array.new
        issues.push(
            
            [
                "Queue ID"          ,
                "Student ID"        ,
                "Athena Table"      ,
                "Athena Field"      ,
                "Athena Value"      ,
                "Sapphire Table"    ,
                "Sapphire Field"    ,
                "Sapphire Value"
            ]
            
        )
        
        pids = $tables.attach("SAPPHIRE_INTERFACE_QUEUE").primary_ids("WHERE confirmed_datetime IS NULL AND completed_datetime IS NOT NULL")
        
        pids.each{|pid|
            
            map_id      = $tables.attach("SAPPHIRE_INTERFACE_QUEUE" ).field_value("map_id", "WHERE primary_id = '#{pid}'")
            map_record  = $tables.attach("SAPPHIRE_INTERFACE_MAP"   ).by_primary_id(map_id)
            
            athena_id   = $tables.attach("SAPPHIRE_INTERFACE_QUEUE" ).field_value("athena_pid", "WHERE primary_id = '#{pid}'")
            a_table     = map_record.fields["athena_table"       ].value
            a_field     = map_record.fields["athena_field"       ].value
            a_value     = $tables.attach(a_table).field_value(a_field,      "WHERE primary_id = '#{athena_id}'")
            
            sid         = $tables.attach(a_table).field_value("student_id", "WHERE primary_id = '#{athena_id}'")
            
            s_table     = map_record.fields["sapphire_table"     ].value
            s_field     = map_record.fields["sapphire_field"     ].value
            s_value     = $tables.attach(s_table).field_value(s_field, "WHERE student_id = '#{sid}'")
            
            fields_match            = s_value == a_value
            parsed_phone_matches    = (!s_value.nil? && !a_value.nil?) && s_value.gsub('-','').gsub('(','').gsub(')','').gsub(' ','') == a_value.gsub('-','').gsub('(','').gsub(')','').gsub(' ','')
            male_match              = s_value == "M" && a_value == "Male"
            female_match            = s_value == "F" && a_value == "Female"
            ethnicity_match         = (
                s_value == "1"  && a_value == "American Indian"                                                                 ||
                s_value == "9"  && a_value == "Asian"                                                                           ||
                s_value == "3"  && a_value == "African-American"                                                                ||
                s_value == "10" && (a_value == "Native Hawaiian or other Pacific Islander" || a_value == "Pacific Islander")    ||
                s_value == "4"  && a_value == "Hispanic"                                                                        ||
                s_value == "6"  && a_value == "Multi-racial"                                                                    ||
                s_value == "7"  && (a_value == "Declined to State" || a_value == "Undefined")                                   ||
                s_value == "5"  && a_value == "White"                                                                           
            )
            
            if fields_match || parsed_phone_matches || male_match || female_match || ethnicity_match
                
                $tables.attach("SAPPHIRE_INTERFACE_QUEUE").by_primary_id(pid).fields["confirmed_datetime"].set($base.right_now.to_db).save
                
            else
                
                queue_record = $tables.attach("SAPPHIRE_INTERFACE_QUEUE" ).by_primary_id(pid)
                
                unless queue_record.field["notes"].value == "Inactive Student"
                    
                    queue_record.field["started_datetime"   ].set(nil)
                    queue_record.field["completed_datetime" ].set(nil)
                    
                    queue_record.save
                    
                    issues.push(
                        
                        [
                            pid     ,
                            sid     ,
                            a_table ,
                            a_field ,
                            a_value ,
                            s_table ,
                            s_field ,
                            s_value
                        ]
                        
                    )
                    
                end
                
            end
            
        } if pids
        
        if issues.length>1
            
            issues_table = $base.web_tools.table(
                :table_array    => issues,
                :unique_name    => "issues",
                :footers        => false,
                :head_section   => true,
                :title          => false,
                :caption        => false,
                :embedded_style => {
                    :table  => "font-family:\"Trebuchet MS\", Arial, Helvetica, sans-serif; width:100%; border-collapse:collapse;",
                    :th     => "font-size:1.4em; border:1px solid #98bf21; text-align:left; padding-top:5px; padding-bottom:4px; background-color:#A7C942; color:#fff;",
                    :tr     => nil,
                    :tr_alt => "color:#000; background-color:#EAF2D3;",
                    :td     => "font-size:1.2em; border:1px solid #98bf21; padding:3px 7px 2px 7px;",
                }
            )
            $base.system_notification(
                subject = "Sapphire Interface Queue Confirmation Failed!",
                content = issues_table
            )
            
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
                :load_type          => :append,
                :data_base          => "#{$config.school_name}_sapphire",
                :keys               => ["student_id"],
                :update             => true,
                "name"              => "sapphire_student_demographics",
                "file_name"         => "sapphire_student_demographics.csv",
                "file_location"     => "sapphire_student_demographics",
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
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",  "file_field"=>"STUDENT_ID"            } if field_order.push("student_id"              )
            structure_hash["fields"]["last_name"        ] = {"data_type"=>"text", "file_field"=>"LAST_NAME"             } if field_order.push("last_name"               )
            structure_hash["fields"]["first_name"       ] = {"data_type"=>"text", "file_field"=>"FIRST_NAME"            } if field_order.push("first_name"              )
            structure_hash["fields"]["resident_district"] = {"data_type"=>"text", "file_field"=>"RESIDENT_DISTRICT"     } if field_order.push("resident_district"       )
            structure_hash["fields"]["state_student_id" ] = {"data_type"=>"text", "file_field"=>"STATE_STUDENT_ID"      } if field_order.push("state_student_id"        )
            structure_hash["fields"]["ethnicity_desc"   ] = {"data_type"=>"text", "file_field"=>"ETHNICITY_DESC"        } if field_order.push("ethnicity_desc"          )
            structure_hash["fields"]["ethnicity"        ] = {"data_type"=>"text", "file_field"=>"ETHNICITY"             } if field_order.push("ethnicity"               )
            structure_hash["fields"]["email_address"    ] = {"data_type"=>"text", "file_field"=>"EMAIL_ADDRESS"         } if field_order.push("email_address"           )
            structure_hash["fields"]["phone_no"         ] = {"data_type"=>"text", "file_field"=>"PHONE_NO"              } if field_order.push("phone_no"                )
            structure_hash["fields"]["birth_date"       ] = {"data_type"=>"date", "file_field"=>"BIRTH_DATE"            } if field_order.push("birth_date"              )
            structure_hash["fields"]["gender"           ] = {"data_type"=>"text", "file_field"=>"GENDER"                } if field_order.push("gender"                  )
            structure_hash["fields"]["other_name"       ] = {"data_type"=>"text", "file_field"=>"OTHER_NAME"            } if field_order.push("other_name"              )
            structure_hash["fields"]["township_code"    ] = {"data_type"=>"text", "file_field"=>"TOWNSHIP_CODE"         } if field_order.push("township_code"           )
            structure_hash["fields"]["address_county"   ] = {"data_type"=>"text", "file_field"=>"ADDRESS_COUNTY"        } if field_order.push("address_county"          )
            structure_hash["fields"]["address_zip_ext"  ] = {"data_type"=>"text", "file_field"=>"ADDRESS_ZIP_EXT"       } if field_order.push("address_zip_ext"         )
            structure_hash["fields"]["address_zip"      ] = {"data_type"=>"text", "file_field"=>"ADDRESS_ZIP"           } if field_order.push("address_zip"             )
            structure_hash["fields"]["address_state"    ] = {"data_type"=>"text", "file_field"=>"ADDRESS_STATE"         } if field_order.push("address_state"           )
            structure_hash["fields"]["address_city"     ] = {"data_type"=>"text", "file_field"=>"ADDRESS_CITY"          } if field_order.push("address_city"            )
            structure_hash["fields"]["address_2"        ] = {"data_type"=>"text", "file_field"=>"ADDRESS_2"             } if field_order.push("address_2"               )
            structure_hash["fields"]["address_1"        ] = {"data_type"=>"text", "file_field"=>"ADDRESS_1"             } if field_order.push("address_1"               )
            structure_hash["fields"]["grade_level"      ] = {"data_type"=>"text", "file_field"=>"GRADE_LEVEL"           } if field_order.push("grade_level"             )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end