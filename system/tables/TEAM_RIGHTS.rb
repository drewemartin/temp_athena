#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_RIGHTS < Athena_Table
    
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
    
    def has_rights?(team_id, rights_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("team_id",     "=",   team_id     ) )
        params.push( Struct::WHERE_PARAMS.new("right_id",    "=",   rights_id   ) ) 
        params.push( Struct::WHERE_PARAMS.new("allowed",     "IS",  "TRUE"      ) ) 
        where_clause = $db.where_clause(params)
        record(where_clause)
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    #def after_change_field_super_user_group(field_obj)
    #    
    #    ignore_fields = ["primary_id","team_id","created_date","created_by"]
    #    record = by_primary_id(field_obj.primary_id)
    #    record.table.field_order.each{|field_name|
    #        
    #        if !ignore_fields.include?(field_name)
    #            record.fields[field_name].set(field_obj.value).save
    #        end
    #        
    #    }
    #    
    #end
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
                "name"              => "team_rights",
                "file_name"         => "team_rights.csv",
                "file_location"     => "team_rights",
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
            
            structure_hash["fields"]["team_id"                                          ] = {"data_type"=>"int",  "file_field"=>"team_id"                                               } if field_order.push("team_id"                                                 )
            
            #SPECIAL RIGHTS
            structure_hash["fields"]["student_search"                                   ] = {"data_type"=>"bool", "file_field"=>"student_search"                                        } if field_order.push("student_search"                                          )
            structure_hash["fields"]["team_search"                                      ] = {"data_type"=>"bool", "file_field"=>"team_search"                                           } if field_order.push("team_search"                                             )
            
            #RIGHT_GROUPS
            structure_hash["fields"]["super_user_group"                                 ] = {"data_type"=>"bool", "file_field"=>"super_user_group"                                      } if field_order.push("super_user_group"                                        )
            
            #INTERFACE_RIGHTS
            structure_hash["fields"]["attendance_admin_access"                          ] = {"data_type"=>"bool", "file_field"=>"attendance_admin_access"                               } if field_order.push("attendance_admin_access"                                 )
            structure_hash["fields"]["athena_projects_access"                           ] = {"data_type"=>"bool", "file_field"=>"athena_projects_access"                                } if field_order.push("athena_projects_access"                                  )
            structure_hash["fields"]["course_relate_access"                             ] = {"data_type"=>"bool", "file_field"=>"course_relate_access"                                  } if field_order.push("course_relate_access"                                    )
            structure_hash["fields"]["districts_access"                                 ] = {"data_type"=>"bool", "file_field"=>"districts_access"                                      } if field_order.push("districts_access"                                        )
            structure_hash["fields"]["k12_reports_access"                               ] = {"data_type"=>"bool", "file_field"=>"k12_reports_access"                                    } if field_order.push("k12_reports_access"                                      )
            structure_hash["fields"]["enrollment_reports_access"                        ] = {"data_type"=>"bool", "file_field"=>"enrollment_reports_access"                             } if field_order.push("enrollment_reports_access"                               )
            structure_hash["fields"]["login_reminders_reports_access"                   ] = {"data_type"=>"bool", "file_field"=>"login_reminders_reports_access"                        } if field_order.push("login_reminders_reports_access"                          )
            structure_hash["fields"]["kmail_access"                                     ] = {"data_type"=>"bool", "file_field"=>"kmail_access"                                          } if field_order.push("kmail_access"                                            )
            structure_hash["fields"]["live_reports_access"                              ] = {"data_type"=>"bool", "file_field"=>"live_reports_access"                                   } if field_order.push("live_reports_access"                                     )
            structure_hash["fields"]["test_event_admin_access"                          ] = {"data_type"=>"bool", "file_field"=>"test_event_admin_access"                               } if field_order.push("test_event_admin_access"                                 )
            structure_hash["fields"]["withdrawal_processing_access"                     ] = {"data_type"=>"bool", "file_field"=>"withdrawal_processing_access"                          } if field_order.push("withdrawal_processing_access"                            )
            structure_hash["fields"]["rtii_behavior_vault_access"                       ] = {"data_type"=>"bool", "file_field"=>"rtii_behavior_vault_access"                            } if field_order.push("rtii_behavior_vault_access"                              )
            structure_hash["fields"]["ilp_vault_access"                                 ] = {"data_type"=>"bool", "file_field"=>"ilp_vault_access"                                      } if field_order.push("ilp_vault_access"                                        )
            structure_hash["fields"]["sapphire_data_management_access"                  ] = {"data_type"=>"bool", "file_field"=>"sapphire_data_management_access"                       } if field_order.push("sapphire_data_management_access"                         )
            
            #LIVE_REPORTS_RIGHTS
            structure_hash["fields"]["live_reports_athena_project"                      ] = {"data_type"=>"bool", "file_field"=>"live_reports_athena_project"                           } if field_order.push("live_reports_athena_project"                             )
            structure_hash["fields"]["live_reports_attendance_code_stats"               ] = {"data_type"=>"bool", "file_field"=>"live_reports_attendance_code_stats"                    } if field_order.push("live_reports_attendance_code_stats"                      )
            structure_hash["fields"]["live_reports_attendance_master"                   ] = {"data_type"=>"bool", "file_field"=>"live_reports_attendance_master"                        } if field_order.push("live_reports_attendance_master"                          )
            structure_hash["fields"]["live_reports_attendance_consecutive_absences"     ] = {"data_type"=>"bool", "file_field"=>"live_reports_attendance_consecutive_absences"          } if field_order.push("live_reports_attendance_consecutive_absences"            )
            structure_hash["fields"]["live_reports_attendance_activity"                 ] = {"data_type"=>"bool", "file_field"=>"live_reports_attendance_activity"                      } if field_order.push("live_reports_attendance_activity"                        )
            structure_hash["fields"]["live_reports_ink_orders"                          ] = {"data_type"=>"bool", "file_field"=>"live_reports_ink_orders"                               } if field_order.push("live_reports_ink_orders"                                 )
            structure_hash["fields"]["live_reports_ink_orders_manual"                   ] = {"data_type"=>"bool", "file_field"=>"live_reports_ink_orders_manual"                        } if field_order.push("live_reports_ink_orders_manual"                          )
            structure_hash["fields"]["live_reports_student_attendance_ap"               ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_attendance_ap"                    } if field_order.push("live_reports_student_attendance_ap"                      )
            structure_hash["fields"]["live_reports_student_contacts"                    ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_contacts"                         } if field_order.push("live_reports_student_contacts"                           )
            structure_hash["fields"]["live_reports_my_student_contacts"                 ] = {"data_type"=>"bool", "file_field"=>"live_reports_my_student_contacts"                      } if field_order.push("live_reports_my_student_contacts"                        )
            structure_hash["fields"]["live_reports_my_students_general"                 ] = {"data_type"=>"bool", "file_field"=>"live_reports_my_students_general"                      } if field_order.push("live_reports_my_students_general"                        )
            structure_hash["fields"]["live_reports_my_students_tests"                   ] = {"data_type"=>"bool", "file_field"=>"live_reports_my_students_tests"                        } if field_order.push("live_reports_my_students_tests"                          )
            structure_hash["fields"]["live_reports_student_rtii_behavior"               ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_rtii_behavior"                    } if field_order.push("live_reports_student_rtii_behavior"                      )
            structure_hash["fields"]["live_reports_student_assessment_exemptions"       ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_assessment_exemptions"            } if field_order.push("live_reports_student_assessment_exemptions"              )
            structure_hash["fields"]["live_reports_student_ilp"                         ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_ilp"                              } if field_order.push("live_reports_student_ilp"                                )
            structure_hash["fields"]["live_reports_student_scantron_participation"      ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_scantron_participation"           } if field_order.push("live_reports_student_scantron_participation"             )
            structure_hash["fields"]["live_reports_student_testing_events_attendance"   ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_testing_events_attendance"        } if field_order.push("live_reports_student_testing_events_attendance"          )
            structure_hash["fields"]["live_reports_student_testing_events_tests"        ] = {"data_type"=>"bool", "file_field"=>"live_reports_student_testing_events_tests"             } if field_order.push("live_reports_student_testing_events_tests"               )
            structure_hash["fields"]["live_reports_team_member_evaluations_engagement"  ] = {"data_type"=>"bool", "file_field"=>"live_reports_team_member_evaluations_engagement"       } if field_order.push("live_reports_team_member_evaluations_engagement"         )
            structure_hash["fields"]["live_reports_team_member_evaluations_academic"    ] = {"data_type"=>"bool", "file_field"=>"live_reports_team_member_evaluations_academic"         } if field_order.push("live_reports_team_member_evaluations_academic"           )
            structure_hash["fields"]["live_reports_transcripts_received"                ] = {"data_type"=>"bool", "file_field"=>"live_reports_transcripts_received"                     } if field_order.push("live_reports_transcripts_received"                       )
           
            #STUDENT_RECORD_RIGHTS
            structure_hash["fields"]["student_attendance_ap_edit"                       ] = {"data_type"=>"bool", "file_field"=>"student_attendance_ap_edit"                            } if field_order.push("student_attendance_ap_edit"                              )
            structure_hash["fields"]["student_contacts_edit"                            ] = {"data_type"=>"bool", "file_field"=>"student_contacts_edit"                                 } if field_order.push("student_contacts_edit"                                   )
            structure_hash["fields"]["student_rtii_edit"                                ] = {"data_type"=>"bool", "file_field"=>"student_rtii_edit"                                     } if field_order.push("student_rtii_edit"                                       )
            structure_hash["fields"]["tep_agreements_edit"                              ] = {"data_type"=>"bool", "file_field"=>"tep_agreements_edit"                                   } if field_order.push("tep_agreements_edit"                                     )
            structure_hash["fields"]["withdraw_requests_edit"                           ] = {"data_type"=>"bool", "file_field"=>"withdraw_requests_edit"                                } if field_order.push("withdraw_requests_edit"                                  )
            structure_hash["fields"]["ink_orders_edit"                                  ] = {"data_type"=>"bool", "file_field"=>"ink_orders_edit"                                       } if field_order.push("ink_orders_edit"                                         )
            structure_hash["fields"]["pssa_entry_edit"                                  ] = {"data_type"=>"bool", "file_field"=>"pssa_entry_edit"                                       } if field_order.push("pssa_entry_edit"                                         )
            structure_hash["fields"]["record_requests_edit"                             ] = {"data_type"=>"bool", "file_field"=>"record_requests_edit"                                  } if field_order.push("record_requests_edit"                                    )
            structure_hash["fields"]["dnc_students_edit"                                ] = {"data_type"=>"bool", "file_field"=>"dnc_students_edit"                                     } if field_order.push("dnc_students_edit"                                       )
            structure_hash["fields"]["student_attendance_edit"                          ] = {"data_type"=>"bool", "file_field"=>"student_attendance_edit"                               } if field_order.push("student_attendance_edit"                                 )
            structure_hash["fields"]["student_tests_edit"                               ] = {"data_type"=>"bool", "file_field"=>"student_tests_edit"                                    } if field_order.push("student_tests_edit"                                      )
            structure_hash["fields"]["student_specialists_edit"                         ] = {"data_type"=>"bool", "file_field"=>"student_specialists_edit"                              } if field_order.push("student_specialists_edit"                                )
            structure_hash["fields"]["student_assessments_edit"                         ] = {"data_type"=>"bool", "file_field"=>"student_assessments_edit"                              } if field_order.push("student_assessments_edit"                                )
            structure_hash["fields"]["student_ilp_edit"                                 ] = {"data_type"=>"bool", "file_field"=>"student_ilp_edit"                                      } if field_order.push("student_ilp_edit"                                        )
            structure_hash["fields"]["student_psychological_evaluation_edit"            ] = {"data_type"=>"bool", "file_field"=>"student_psychological_evaluation_edit"                 } if field_order.push("student_psychological_evaluation_edit"                   )
            
            #STUDENT_MODULE_RIGHTS 
            structure_hash["fields"]["module_student_attendance_ap"                     ] = {"data_type"=>"bool", "file_field"=>"module_student_attendance_ap"                          } if field_order.push("module_student_attendance_ap"                            )
            structure_hash["fields"]["module_student_contacts"                          ] = {"data_type"=>"bool", "file_field"=>"module_student_contacts"                               } if field_order.push("module_student_contacts"                                 )
            structure_hash["fields"]["module_student_rtii"                              ] = {"data_type"=>"bool", "file_field"=>"module_student_rtii"                                   } if field_order.push("module_student_rtii"                                     )
            structure_hash["fields"]["module_tep_agreements"                            ] = {"data_type"=>"bool", "file_field"=>"module_tep_agreements"                                 } if field_order.push("module_tep_agreements"                                   )
            structure_hash["fields"]["module_withdraw_requests"                         ] = {"data_type"=>"bool", "file_field"=>"module_withdraw_requests"                              } if field_order.push("module_withdraw_requests"                                )
            structure_hash["fields"]["module_ink_orders"                                ] = {"data_type"=>"bool", "file_field"=>"module_ink_orders"                                     } if field_order.push("module_ink_orders"                                       )
            structure_hash["fields"]["module_pssa_entry"                                ] = {"data_type"=>"bool", "file_field"=>"module_pssa_entry"                                     } if field_order.push("module_pssa_entry"                                       )
            structure_hash["fields"]["module_record_requests"                           ] = {"data_type"=>"bool", "file_field"=>"module_record_requests"                                } if field_order.push("module_record_requests"                                  )
            structure_hash["fields"]["module_dnc_students"                              ] = {"data_type"=>"bool", "file_field"=>"module_dnc_students"                                   } if field_order.push("module_dnc_students"                                     )
            structure_hash["fields"]["module_student_attendance"                        ] = {"data_type"=>"bool", "file_field"=>"module_student_attendance"                             } if field_order.push("module_student_attendance"                               )
            structure_hash["fields"]["module_student_tests"                             ] = {"data_type"=>"bool", "file_field"=>"module_student_tests"                                  } if field_order.push("module_student_tests"                                    )
            structure_hash["fields"]["module_student_specialists"                       ] = {"data_type"=>"bool", "file_field"=>"module_student_specialists"                            } if field_order.push("module_student_specialists"                              )
            structure_hash["fields"]["module_student_assessments"                       ] = {"data_type"=>"bool", "file_field"=>"module_student_assessments"                            } if field_order.push("module_student_assessments"                              )
            structure_hash["fields"]["module_student_ilp"                               ] = {"data_type"=>"bool", "file_field"=>"module_student_ilp"                                    } if field_order.push("module_student_ilp"                                      )
            structure_hash["fields"]["module_student_psychological_evaluation"          ] = {"data_type"=>"bool", "file_field"=>"module_student_psychological_evaluation"               } if field_order.push("module_student_psychological_evaluation"                 )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end