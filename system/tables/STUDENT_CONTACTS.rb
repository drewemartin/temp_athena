#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_CONTACTS < Athena_Table
    
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
    
    def had_welcome_call(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",   "=",  sid    ) )
        params.push( Struct::WHERE_PARAMS.new("welcome_call", "IS", "TRUE" ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def had_initial_home_visit(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=",  sid    ) )
        params.push( Struct::WHERE_PARAMS.new("initial_home_visit", "IS", "TRUE" ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def successful_attempts(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=",  sid    ) )
        params.push( Struct::WHERE_PARAMS.new("successful", "IS", "TRUE" ) )
        where_clause = $db.where_clause(params)
        records(where_clause)
    end
    
    def unsuccessful_attempts(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=",  sid    ) )
        params.push( Struct::WHERE_PARAMS.new("successful", "IS", "NOT TRUE" ) )
        where_clause = $db.where_clause(params)
        records(where_clause)
    end
    
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
                "name"              => "student_contacts",
                "file_name"         => "student_contacts.csv",
                "file_location"     => "student_contacts",
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
            structure_hash["fields"]["student_id"                    ] = {"data_type"=>"int",  "file_field"=>"student_id"                    } if field_order.push("student_id")
            structure_hash["fields"]["datetime"                      ] = {"data_type"=>"datetime", "file_field"=>"datetime"                  } if field_order.push("datetime")
            structure_hash["fields"]["successful"                    ] = {"data_type"=>"bool", "file_field"=>"successful"                    } if field_order.push("successful")
            structure_hash["fields"]["notes"                         ] = {"data_type"=>"text", "file_field"=>"notes"                         } if field_order.push("notes")
            structure_hash["fields"]["contact_type"                  ] = {"data_type"=>"text", "file_field"=>"contact_type"                  } if field_order.push("contact_type")
            
            #CONTACT RELATED TO:
            structure_hash["fields"]["tep_initial"                   ] = {"data_type"=>"bool", "file_field"=>"tep_initial"                   } if field_order.push("tep_initial")
            structure_hash["fields"]["tep_followup"                  ] = {"data_type"=>"bool", "file_field"=>"tep_followup"                  } if field_order.push("tep_followup")
            structure_hash["fields"]["attendance"                    ] = {"data_type"=>"bool", "file_field"=>"attendance"                    } if field_order.push("attendance")
            
            structure_hash["fields"]["rtii_behavior_id"              ] = {"data_type"=>"int",  "file_field"=>"rtii_behavior_id"              } if field_order.push("rtii_behavior_id")
            structure_hash["fields"]["test_site_selection"           ] = {"data_type"=>"bool", "file_field"=>"test_site_selection"           } if field_order.push("test_site_selection")
            structure_hash["fields"]["scantron_performance"          ] = {"data_type"=>"bool", "file_field"=>"scantron_performance"          } if field_order.push("scantron_performance")
            structure_hash["fields"]["study_island_assessments"      ] = {"data_type"=>"bool", "file_field"=>"study_island_assessments"      } if field_order.push("study_island_assessments")
            structure_hash["fields"]["course_progress"               ] = {"data_type"=>"bool", "file_field"=>"course_progress"               } if field_order.push("course_progress")
            structure_hash["fields"]["work_submission"               ] = {"data_type"=>"bool", "file_field"=>"work_submission"               } if field_order.push("work_submission")
            structure_hash["fields"]["grades"                        ] = {"data_type"=>"bool", "file_field"=>"grades"                        } if field_order.push("grades")
            structure_hash["fields"]["communications"                ] = {"data_type"=>"bool", "file_field"=>"communications"                } if field_order.push("communications")
            structure_hash["fields"]["retention_risk"                ] = {"data_type"=>"bool", "file_field"=>"retention_risk"                } if field_order.push("retention_risk")
            structure_hash["fields"]["escalation"                    ] = {"data_type"=>"bool", "file_field"=>"escalation"                    } if field_order.push("escalation")
            structure_hash["fields"]["welcome_call"                  ] = {"data_type"=>"bool", "file_field"=>"welcome_call"                  } if field_order.push("welcome_call")
            structure_hash["fields"]["initial_home_visit"            ] = {"data_type"=>"bool", "file_field"=>"initial_home_visit"            } if field_order.push("initial_home_visit")
            structure_hash["fields"]["tech_issue"                    ] = {"data_type"=>"bool", "file_field"=>"tech_issue"                    } if field_order.push("tech_issue")
            structure_hash["fields"]["low_engagement"                ] = {"data_type"=>"bool", "file_field"=>"low_engagement"                } if field_order.push("low_engagement")
            structure_hash["fields"]["ilp_conference"                ] = {"data_type"=>"bool", "file_field"=>"ilp_conference"                } if field_order.push("ilp_conference")
            structure_hash["fields"]["truancy_court_outcome"         ] = {"data_type"=>"bool", "file_field"=>"truancy_court_outcome"         } if field_order.push("truancy_court_outcome")
            structure_hash["fields"]["court_preparation"             ] = {"data_type"=>"bool", "file_field"=>"court_preparation"             } if field_order.push("court_preparation")
            structure_hash["fields"]["residency"                     ] = {"data_type"=>"bool", "file_field"=>"residency"                     } if field_order.push("residency")
            structure_hash["fields"]["ses"                           ] = {"data_type"=>"bool", "file_field"=>"ses"                           } if field_order.push("ses")
            structure_hash["fields"]["sap_invitation"                ] = {"data_type"=>"bool", "file_field"=>"sap_invitation"                } if field_order.push("sap_invitation")
            structure_hash["fields"]["sap_followup"                  ] = {"data_type"=>"bool", "file_field"=>"sap_followup"                  } if field_order.push("sap_followup")
            structure_hash["fields"]["evaluation_request_psych"      ] = {"data_type"=>"bool", "file_field"=>"evaluation_request_psych"      } if field_order.push("evaluation_request_psych")
            structure_hash["fields"]["ell"                           ] = {"data_type"=>"bool", "file_field"=>"ell"                           } if field_order.push("ell")
            structure_hash["fields"]["phlote_identification"         ] = {"data_type"=>"bool", "file_field"=>"phlote_identification"         } if field_order.push("phlote_identification")
            structure_hash["fields"]["cys"                           ] = {"data_type"=>"bool", "file_field"=>"cys"                           } if field_order.push("cys")
            structure_hash["fields"]["homeless"                      ] = {"data_type"=>"bool", "file_field"=>"homeless"                      } if field_order.push("homeless")
            structure_hash["fields"]["aircard"                       ] = {"data_type"=>"bool", "file_field"=>"aircard"                       } if field_order.push("aircard")
            structure_hash["fields"]["court_district_go"             ] = {"data_type"=>"bool", "file_field"=>"court_district_go"             } if field_order.push("court_district_go")
            structure_hash["fields"]["other"                         ] = {"data_type"=>"bool", "file_field"=>"other"                         } if field_order.push("other")
            structure_hash["fields"]["other_description"             ] = {"data_type"=>"text", "file_field"=>"other_description"             } if field_order.push("other_description")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end