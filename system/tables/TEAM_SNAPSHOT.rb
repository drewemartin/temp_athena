#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_SNAPSHOT < Athena_Table
    
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
                "name"              => "team_snapshot",
                "file_name"         => "team_snapshot.csv",
                "file_location"     => "team_snapshot",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    #sams id's need their own table
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["legal_first_name"         ] = {"data_type"=>"text", "file_field"=>"legal_first_name"              } if field_order.push("legal_first_name"        )
            structure_hash["fields"]["legal_middle_name"        ] = {"data_type"=>"text", "file_field"=>"legal_middle_name"             } if field_order.push("legal_middle_name"       )
            structure_hash["fields"]["legal_last_name"          ] = {"data_type"=>"text", "file_field"=>"legal_last_name"               } if field_order.push("legal_last_name"         )
            structure_hash["fields"]["suffix"                   ] = {"data_type"=>"text", "file_field"=>"suffix"                        } if field_order.push("suffix"                  )
            structure_hash["fields"]["aka"                      ] = {"data_type"=>"text", "file_field"=>"aka"                           } if field_order.push("aka"                     )
            structure_hash["fields"]["insperity_name"           ] = {"data_type"=>"text", "file_field"=>"insperity_name"                } if field_order.push("insperity_name"          )
            structure_hash["fields"]["ppid"                     ] = {"data_type"=>"int",  "file_field"=>"ppid"                          } if field_order.push("ppid"                    )
            structure_hash["fields"]["ssn"                      ] = {"data_type"=>"int",  "file_field"=>"ssn"                           } if field_order.push("ssn"                     )
            structure_hash["fields"]["dob"                      ] = {"data_type"=>"date", "file_field"=>"dob"                           } if field_order.push("dob"                     )
            structure_hash["fields"]["ethnicity"                ] = {"data_type"=>"text", "file_field"=>"ethnicity"                     } if field_order.push("ethnicity"               )
            structure_hash["fields"]["gender"                   ] = {"data_type"=>"text", "file_field"=>"gender"                        } if field_order.push("gender"                  )
            structure_hash["fields"]["mailing_address_1"        ] = {"data_type"=>"text", "file_field"=>"mailing_address_1"             } if field_order.push("mailing_address_1"       )
            structure_hash["fields"]["mailing_address_2"        ] = {"data_type"=>"text", "file_field"=>"mailing_address_2"             } if field_order.push("mailing_address_2"       )
            structure_hash["fields"]["mailing_city"             ] = {"data_type"=>"text", "file_field"=>"mailing_city"                  } if field_order.push("mailing_city"            )
            structure_hash["fields"]["mailing_zip"              ] = {"data_type"=>"text", "file_field"=>"mailing_zip"                   } if field_order.push("mailing_zip"             )
            structure_hash["fields"]["mailing_county"           ] = {"data_type"=>"text", "file_field"=>"mailing_county"                } if field_order.push("mailing_county"          )
            structure_hash["fields"]["mailing_state"            ] = {"data_type"=>"text", "file_field"=>"mailing_state"                 } if field_order.push("mailing_state"           )
            structure_hash["fields"]["shipping_address_1"       ] = {"data_type"=>"text", "file_field"=>"shipping_address_1"            } if field_order.push("shipping_address_1"      )
            structure_hash["fields"]["shipping_address_2"       ] = {"data_type"=>"text", "file_field"=>"shipping_address_2"            } if field_order.push("shipping_address_2"      )
            structure_hash["fields"]["shipping_city"            ] = {"data_type"=>"text", "file_field"=>"shipping_city"                 } if field_order.push("shipping_city"           )
            structure_hash["fields"]["shipping_zip"             ] = {"data_type"=>"int",  "file_field"=>"shipping_zip"                  } if field_order.push("shipping_zip"            )
            structure_hash["fields"]["shipping_county"          ] = {"data_type"=>"text", "file_field"=>"shipping_county"               } if field_order.push("shipping_county"         )
            structure_hash["fields"]["shipping_state"           ] = {"data_type"=>"text", "file_field"=>"shipping_state"                } if field_order.push("shipping_state"          )
            structure_hash["fields"]["work_im"                  ] = {"data_type"=>"text", "file_field"=>"work_im"                       } if field_order.push("work_im"                 )
            structure_hash["fields"]["employee_type"            ] = {"data_type"=>"text", "file_field"=>"employee_type"                 } if field_order.push("employee_type"           )
            structure_hash["fields"]["teacher_breakdown"        ] = {"data_type"=>"text", "file_field"=>"teacher_breakdown"             } if field_order.push("teacher_breakdown"       )
            structure_hash["fields"]["department"               ] = {"data_type"=>"text", "file_field"=>"department"                    } if field_order.push("department"              )
            structure_hash["fields"]["department_id"            ] = {"data_type"=>"int",  "file_field"=>"department_id"                 } if field_order.push("department_id"           )
            structure_hash["fields"]["department_category"      ] = {"data_type"=>"text", "file_field"=>"department_category"           } if field_order.push("department_category"     )
            structure_hash["fields"]["department_focus"         ] = {"data_type"=>"text", "file_field"=>"department_focus"              } if field_order.push("department_focus"        )
            structure_hash["fields"]["title"                    ] = {"data_type"=>"text", "file_field"=>"title"                         } if field_order.push("title"                   )
            structure_hash["fields"]["supervisor_team_id"       ] = {"data_type"=>"int",  "file_field"=>"supervisor_team_id"            } if field_order.push("supervisor_team_id"      )
            structure_hash["fields"]["peer_group_id"            ] = {"data_type"=>"int",  "file_field"=>"peer_group_id"                 } if field_order.push("peer_group_id"           )
            structure_hash["fields"]["highest_degree"           ] = {"data_type"=>"text", "file_field"=>"highest_degree"                } if field_order.push("highest_degree"          )
            structure_hash["fields"]["year_entered_education"   ] = {"data_type"=>"int",  "file_field"=>"year_entered_education"        } if field_order.push("year_entered_education"  )
            structure_hash["fields"]["active"                   ] = {"data_type"=>"bool", "file_field"=>"active"                        } if field_order.push("active"                  )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end