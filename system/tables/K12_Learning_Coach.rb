#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_LEARNING_COACH < Athena_Table
    
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

    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_familyid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("family_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
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
                "name"              => "k12_learning_coach",
                "file_name"         => "agora_learning_coach_report.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_learning_coach_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        
        structure_hash["fields"]["student_id"                   ] = {"data_type"=>"int",  "file_field"=>"Student ID"                } if field_order.push("student_id"              )
        structure_hash["fields"]["enroll_received"              ] = {"data_type"=>"date", "file_field"=>"Enroll Received"           } if field_order.push("enroll_received"         )
        structure_hash["fields"]["enroll_approved"              ] = {"data_type"=>"date", "file_field"=>"Enroll Approved"           } if field_order.push("enroll_approved"         )
        structure_hash["fields"]["school_enroll"                ] = {"data_type"=>"date", "file_field"=>"School Enroll"             } if field_order.push("school_enroll"           )
        structure_hash["fields"]["family_id"                    ] = {"data_type"=>"int",  "file_field"=>"Family ID"                 } if field_order.push("family_id"               )
        structure_hash["fields"]["email_address"                ] = {"data_type"=>"text", "file_field"=>"Email Address"             } if field_order.push("email_address"           )
        structure_hash["fields"]["cell_phone"                   ] = {"data_type"=>"text", "file_field"=>"Cell Phone"                } if field_order.push("cell_phone"              )
        structure_hash["fields"]["work_phone"                   ] = {"data_type"=>"text", "file_field"=>"Work Phone"                } if field_order.push("work_phone"              )
        structure_hash["fields"]["home_phone"                   ] = {"data_type"=>"text", "file_field"=>"Home Phone"                } if field_order.push("home_phone"              )
        structure_hash["fields"]["student_last_name"            ] = {"data_type"=>"text", "file_field"=>"Student Last Name"         } if field_order.push("student_last_name"       )
        structure_hash["fields"]["student_first_name"           ] = {"data_type"=>"text", "file_field"=>"Student First Name"        } if field_order.push("student_first_name"      )
        structure_hash["fields"]["adult_last_name"              ] = {"data_type"=>"text", "file_field"=>"Adult Last Name"           } if field_order.push("adult_last_name"         )
        structure_hash["fields"]["adult_first_name"             ] = {"data_type"=>"text", "file_field"=>"Adult First Name"          } if field_order.push("adult_first_name"        )
        structure_hash["fields"]["adult_mailing_address1"       ] = {"data_type"=>"text", "file_field"=>"Adult Mailing Address1"    } if field_order.push("adult_mailing_address1"  )
        structure_hash["fields"]["adult_mailing_address2"       ] = {"data_type"=>"text", "file_field"=>"Adult Mailing Address2"    } if field_order.push("adult_mailing_address2"  )
        structure_hash["fields"]["adult_mailing_city"           ] = {"data_type"=>"text", "file_field"=>"Adult Mailing City"        } if field_order.push("adult_mailing_city"      )
        structure_hash["fields"]["adult_mailing_state"          ] = {"data_type"=>"text", "file_field"=>"Adult Mailing State"       } if field_order.push("adult_mailing_state"     )
        structure_hash["fields"]["adult_mailing_zip"            ] = {"data_type"=>"text", "file_field"=>"Adult Mailing Zip"         } if field_order.push("adult_mailing_zip"       )
        structure_hash["fields"]["relationship"                 ] = {"data_type"=>"text", "file_field"=>"Relationship"              } if field_order.push("relationship"            )
        structure_hash["fields"]["living_with"                  ] = {"data_type"=>"text", "file_field"=>"Living With"               } if field_order.push("living_with"             )
        structure_hash["fields"]["learning_coach"               ] = {"data_type"=>"text", "file_field"=>"Learning Coach"            } if field_order.push("learning_coach"          )
        structure_hash["fields"]["emergency_contact"            ] = {"data_type"=>"text", "file_field"=>"Emergency Contact"         } if field_order.push("emergency_contact"       )
        structure_hash["fields"]["legal_guardian"               ] = {"data_type"=>"text", "file_field"=>"Legal Guardian"            } if field_order.push("legal_guardian"          )
        
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end