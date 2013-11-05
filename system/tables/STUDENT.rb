#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class STUDENT < Athena_Table
    
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
        record(where_clause) 
    end
    alias :by_student_id :by_studentid_old
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def field_byidentityid(field_name, identityid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("identityid", "=", identityid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def students_with_records(where_clause = nil)
        $db.get_data_single("SELECT student_id FROM #{table_name} #{where_clause}")
    end
    
    #additional_fields_arr = [{:field_name=>"Field Header"}]
    def student_data_table(sids, additional_fields_arr=nil, join_string=String.new, where_addon=String.new)
        where_clause    = " WHERE (student_id = '#{sids[0]}'"
        sids[1 ... sids.length].each{|sid|
            where_clause << " OR student_id = '#{sid}'"    
        }
        where_clause << ") "
        
        headers     = Array.new
        sql_string  = String.new
        sql_string << " Select"
            
            #DEFAULT FIELDS RETURNED ON ALL RESULTS
            sql_string << " student_id,"           if headers.push("Student ID"            )   
            sql_string << " studentlastname,"      if headers.push("Last Name"             )
            sql_string << " studentfirstname,"     if headers.push("First Name"            )
            sql_string << " grade,"                if headers.push("Grade Level"           )
            sql_string << " familyid,"             if headers.push("Family ID"             )
            sql_string << " birthday,"             if headers.push("Birthday"              )
            sql_string << " primaryteacher,"       if headers.push("Family Coach"          )
            sql_string << " schoolenrolldate,"     if headers.push("Enroll Date"           )
            sql_string << " specialedteacher,"     if headers.push("Special Ed Teacher"    )
            sql_string << " districtofresidence"   if headers.push("District of Residence" )
            
            #CALLER DEFINED FIELDS
            if additional_fields_arr
                additional_fields_arr.each{|field_hash|
                    field_hash.each_pair{|fieldname,fieldheader|
                        sql_string << " ,#{fieldname.to_s}"   if headers.push( fieldheader )
                    }
                }
            end
            
        sql_string << join_string    
        sql_string << " FROM #{data_base}.student"          
        sql_string << where_clause
        sql_string << where_addon
        
        tables_array = $db.get_data( sql_string ).insert(0, headers)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS_FIELDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_change_active_disabled(field)
        if !field.value.nil?
            notify_users = $tables.attach("USER_DISTRIBUTION").by_group("after_change_withdrawdate")
            notify_users.each{|user|
                record = $tables.attach("USER_ACTION_ITEMS").new_row
                record.fields["sams_id"      ].value = user.fields["sams_id"].value
                record.fields["table_name"   ].value = field.table_name
                record.fields["table_fields" ].value = field.field_name
                record.fields["table_pid"    ].value = field.primary_id
                record.fields["message"      ].value = "Withdraw Date Changed"
                record.fields["completed"    ].value = false
                record.save
            }
        end
    end
    
    def after_change_withdrawdate_disabled(field)
        if !field.value.nil?
            notify_users = $tables.attach("USER_DISTRIBUTION").by_group("after_change_withdrawdate")
            notify_users.each{|user|
                record = $tables.attach("USER_ACTION_ITEMS").new_row
                record.fields["sams_id"      ].value = user.fields["sams_id"].value
                record.fields["table_name"   ].value = field.table_name
                record.fields["table_fields" ].value = field.field_name
                record.fields["table_pid"    ].value = field.primary_id
                record.fields["message"      ].value = "Withdraw Date Changed"
                record.fields["completed"    ].value = false
                record.save
            }
        end
    end
    
    def after_change_schoolenrolldate_disabled(field)
        if !field.value.nil?
            notify_users = $tables.attach("USER_DISTRIBUTION").by_group("after_change_schoolenrolldate")
            notify_users.each{|user|
                record = $tables.attach("USER_ACTION_ITEMS").new_row
                record.fields["sams_id"      ].value = user.fields["sams_id"].value
                record.fields["table_name"   ].value = field.table_name
                record.fields["table_fields" ].value = field.field_name
                record.fields["table_pid"    ].value = field.primary_id
                record.fields["message"      ].value = "School Enroll Date Changed"
                record.fields["completed"    ].value = false
                record.save
            }
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS_TABLES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load_k12_omnibus
        
        reactivate_reinstates
        #mark_active_students
        #mark_enrolled_students
        
    end
    
    def after_load_k12_withdrawal
        
        #mark_withdrawn_students
        
        #IDENTIFY NEWLY WITHDRAWN STUDENTS
        #MARK THEM APPROPRIATELY
        k12_db = $tables.attach("K12_WITHDRAWAL").data_base
        pids = primary_ids(
            "LEFT JOIN #{k12_db}.k12_withdrawal
            ON k12_withdrawal.student_id = student.student_id
            WHERE active IS NOT FALSE
            AND k12_withdrawal.withdrawdate IS NOT NULL"
        )
        
        pids.each{|pid|
            
            record = by_primary_id(pid)
            record.fields["active"].value = 0
            record.save
            
        } if pids
        
    end
    
    def mark_active_students
        
    end
    
    def mark_enrolled_students
        
        sids = $students.enrolled
        sids.each{|sid|
            
            record = by_student_id(sid)
            record.fields["enrolled"].value = true
            record.save
            
        } if sids
        
    end
    
    def mark_withdrawn_students
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS_TABLES_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def reactivate_reinstates
        
        #IDENTIFY NEWLY REINSTATED STUDENTS
        #MARK THEM APPROPRIATELY
        
        o_db = $tables.attach("K12_OMNIBUS").data_base
        pids = primary_ids(
            "LEFT JOIN #{o_db}.k12_omnibus ON k12_omnibus.student_id = student.student_id
            WHERE k12_omnibus.student_id IS NOT NULL
            AND k12_omnibus.enrollmentstatus = 'Approved'
            AND k12_omnibus.schoolenrolldate IS NOT NULL
            AND student.active IS NOT TRUE"
            
        )
        
        pids.each{|pid|
            
            record = by_primary_id(pid)
            record.fields["active"].value = 1      
            record.save
            
            sid = record.fields["student_id"].value
            
            attendance_mode_record = $tables.attach("student_attendance_mode").by_studentid(sid)
            if attendance_mode_record
                attendance_mode_record.fields["attendance_mode"].value = "Synchronous"
                attendance_mode_record.save
            end
            
        } if pids
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student",
                "file_name"         => "student.csv",
                "file_location"     => "student",
                "source_address"    => nil, 
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
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
            
            structure_hash["fields"]["student_id"                       ]       = {"data_type"=>"int",          "file_field"=>"student_id"                       }       if field_order.push("student_id")
            structure_hash["fields"]["active"                           ]       = {"data_type"=>"bool",         "file_field"=>"active"                           }       if field_order.push("active")
            structure_hash["fields"]["region"                           ]       = {"data_type"=>"text",         "file_field"=>"region"                           }       if field_order.push("region")
            
            #IMPORTING FROM K12_OMNIBUS                                                                                                      
            structure_hash["fields"]["integrationid"                    ]       = {"data_type"=>"text",         "file_field"=>"integrationid"                    }       if field_order.push("integrationid")
            structure_hash["fields"]["identityid"                       ]       = {"data_type"=>"int",          "file_field"=>"identityid"                       }       if field_order.push("identityid")
            structure_hash["fields"]["familyid"                         ]       = {"data_type"=>"int",          "file_field"=>"familyid"                         }       if field_order.push("familyid")
            structure_hash["fields"]["studentlastname"                  ]       = {"data_type"=>"text",         "file_field"=>"studentlastname"                  }       if field_order.push("studentlastname")
            structure_hash["fields"]["studentfirstname"                 ]       = {"data_type"=>"text",         "file_field"=>"studentfirstname"                 }       if field_order.push("studentfirstname")
            structure_hash["fields"]["studentmiddlename"                ]       = {"data_type"=>"text",         "file_field"=>"studentmiddlename"                }       if field_order.push("studentmiddlename")
            structure_hash["fields"]["studentgender"                    ]       = {"data_type"=>"text",         "file_field"=>"studentgender"                    }       if field_order.push("studentgender")
            structure_hash["fields"]["districtofresidence"              ]       = {"data_type"=>"text",         "file_field"=>"districtofresidence"              }       if field_order.push("districtofresidence")
            structure_hash["fields"]["grade"                            ]       = {"data_type"=>"text",         "file_field"=>"grade"                            }       if field_order.push("grade")
            structure_hash["fields"]["birthday"                         ]       = {"data_type"=>"date",         "file_field"=>"birthday"                         }       if field_order.push("birthday")
            structure_hash["fields"]["mailingaddress1"                  ]       = {"data_type"=>"text",         "file_field"=>"mailingaddress1"                  }       if field_order.push("mailingaddress1")
            structure_hash["fields"]["mailingaddress2"                  ]       = {"data_type"=>"text",         "file_field"=>"mailingaddress2"                  }       if field_order.push("mailingaddress2")
            structure_hash["fields"]["mailingcity"                      ]       = {"data_type"=>"text",         "file_field"=>"mailingcity"                      }       if field_order.push("mailingcity")
            structure_hash["fields"]["mailingzip"                       ]       = {"data_type"=>"text",         "file_field"=>"mailingzip"                       }       if field_order.push("mailingzip")
            structure_hash["fields"]["mailingstate"                     ]       = {"data_type"=>"text",         "file_field"=>"mailingstate"                     }       if field_order.push("mailingstate")
            structure_hash["fields"]["studenthomephone"                 ]       = {"data_type"=>"text",         "file_field"=>"studenthomephone"                 }       if field_order.push("studenthomephone")
            structure_hash["fields"]["shippingaddress1"                 ]       = {"data_type"=>"text",         "file_field"=>"shippingaddress1"                 }       if field_order.push("shippingaddress1")
            structure_hash["fields"]["shippingaddress2"                 ]       = {"data_type"=>"text",         "file_field"=>"shippingaddress2"                 }       if field_order.push("shippingaddress2")
            structure_hash["fields"]["shippingcity"                     ]       = {"data_type"=>"text",         "file_field"=>"shippingcity"                     }       if field_order.push("shippingcity")
            structure_hash["fields"]["shippingzip"                      ]       = {"data_type"=>"text",         "file_field"=>"shippingzip"                      }       if field_order.push("shippingzip")
            structure_hash["fields"]["shippingstate"                    ]       = {"data_type"=>"text",         "file_field"=>"shippingstate"                    }       if field_order.push("shippingstate")
            structure_hash["fields"]["physicaladdress1"                 ]       = {"data_type"=>"text",         "file_field"=>"physicaladdress1"                 }       if field_order.push("physicaladdress1")
            structure_hash["fields"]["physicaladdress2"                 ]       = {"data_type"=>"text",         "file_field"=>"physicaladdress2"                 }       if field_order.push("physicaladdress2")
            structure_hash["fields"]["physicalregion"                   ]       = {"data_type"=>"text",         "file_field"=>"physicalregion"                   }       if field_order.push("physicalregion")
            structure_hash["fields"]["physicalcity"                     ]       = {"data_type"=>"text",         "file_field"=>"physicalcity"                     }       if field_order.push("physicalcity")
            structure_hash["fields"]["pcounty"                          ]       = {"data_type"=>"text",         "file_field"=>"pcounty"                          }       if field_order.push("pcounty")
            structure_hash["fields"]["physicalzip"                      ]       = {"data_type"=>"text",         "file_field"=>"physicalzip"                      }       if field_order.push("physicalzip")
            structure_hash["fields"]["physicalstate"                    ]       = {"data_type"=>"text",         "file_field"=>"physicalstate"                    }       if field_order.push("physicalstate")
            structure_hash["fields"]["lclastname"                       ]       = {"data_type"=>"text",         "file_field"=>"lclastname"                       }       if field_order.push("lclastname")
            structure_hash["fields"]["lcfirstname"                      ]       = {"data_type"=>"text",         "file_field"=>"lcfirstname"                      }       if field_order.push("lcfirstname")
            structure_hash["fields"]["lcrelationship"                   ]       = {"data_type"=>"text",         "file_field"=>"lcrelationship"                   }       if field_order.push("lcrelationship")
            structure_hash["fields"]["lcregistrationid"                 ]       = {"data_type"=>"text",         "file_field"=>"lcregistrationid"                 }       if field_order.push("lcregistrationid")
            structure_hash["fields"]["lcemail"                          ]       = {"data_type"=>"text",         "file_field"=>"lcemail"                          }       if field_order.push("lcemail")
            structure_hash["fields"]["lglastname"                       ]       = {"data_type"=>"text",         "file_field"=>"lglastname"                       }       if field_order.push("lglastname")
            structure_hash["fields"]["lgfirstname"                      ]       = {"data_type"=>"text",         "file_field"=>"lgfirstname"                      }       if field_order.push("lgfirstname")
            structure_hash["fields"]["lgrelationship"                   ]       = {"data_type"=>"text",         "file_field"=>"lgrelationship"                   }       if field_order.push("lgrelationship")
            structure_hash["fields"]["lgregistrationid"                 ]       = {"data_type"=>"text",         "file_field"=>"lgregistrationid"                 }       if field_order.push("lgregistrationid")
            structure_hash["fields"]["lgemail"                          ]       = {"data_type"=>"text",         "file_field"=>"lgemail"                          }       if field_order.push("lgemail")
            structure_hash["fields"]["ethnicity"                        ]       = {"data_type"=>"text",         "file_field"=>"ethnicity"                        }       if field_order.push("ethnicity")
            structure_hash["fields"]["hispanicorlatino"                 ]       = {"data_type"=>"text",         "file_field"=>"hispanicorlatino"                 }       if field_order.push("hispanicorlatino")
            structure_hash["fields"]["othethnicities"                   ]       = {"data_type"=>"text",         "file_field"=>"othethnicities"                   }       if field_order.push("othethnicities")
            structure_hash["fields"]["primaryteacher"                   ]       = {"data_type"=>"text",         "file_field"=>"primaryteacher"                   }       if field_order.push("primaryteacher")
            structure_hash["fields"]["primaryteacherid"                 ]       = {"data_type"=>"int",          "file_field"=>"primaryteacherid"                 }       if field_order.push("primaryteacherid")
            structure_hash["fields"]["specialedteacher"                 ]       = {"data_type"=>"text",         "file_field"=>"specialedteacher"                 }       if field_order.push("specialedteacher")
            structure_hash["fields"]["specialedteacherid"               ]       = {"data_type"=>"int",          "file_field"=>"specialedteacherid"               }       if field_order.push("specialedteacherid")
            structure_hash["fields"]["title1teacher"                    ]       = {"data_type"=>"text",         "file_field"=>"title1teacher"                    }       if field_order.push("title1teacher")
            structure_hash["fields"]["title1teacherid"                  ]       = {"data_type"=>"text",         "file_field"=>"title1teacherid"                  }       if field_order.push("title1teacherid")
            structure_hash["fields"]["giftedtalented"                   ]       = {"data_type"=>"bool",         "file_field"=>"giftedtalented"                   }       if field_order.push("giftedtalented")
            structure_hash["fields"]["haseslprogram"                    ]       = {"data_type"=>"bool",         "file_field"=>"haseslprogram"                    }       if field_order.push("haseslprogram")
            structure_hash["fields"]["title1chapter1prog"               ]       = {"data_type"=>"bool",         "file_field"=>"title1chapter1prog"               }       if field_order.push("title1chapter1prog")
            structure_hash["fields"]["sped504plan"                      ]       = {"data_type"=>"bool",         "file_field"=>"sped504plan"                      }       if field_order.push("sped504plan")
            structure_hash["fields"]["sped504planreason"                ]       = {"data_type"=>"text",         "file_field"=>"sped504planreason"                }       if field_order.push("sped504planreason")
            structure_hash["fields"]["isspecialed"                      ]       = {"data_type"=>"bool",         "file_field"=>"isspecialed"                      }       if field_order.push("isspecialed")
            structure_hash["fields"]["hasiep"                           ]       = {"data_type"=>"bool",         "file_field"=>"hasiep"                           }       if field_order.push("hasiep")
            structure_hash["fields"]["hasrti"                           ]       = {"data_type"=>"bool",         "file_field"=>"hasrti"                           }       if field_order.push("hasrti")
            structure_hash["fields"]["hasalp"                           ]       = {"data_type"=>"bool",         "file_field"=>"hasalp"                           }       if field_order.push("hasalp")  
            structure_hash["fields"]["otherspecialed"                   ]       = {"data_type"=>"bool",         "file_field"=>"otherspecialed"                   }       if field_order.push("otherspecialed")
            structure_hash["fields"]["specialedrecords"                 ]       = {"data_type"=>"text",         "file_field"=>"specialedrecords"                 }       if field_order.push("specialedrecords")
            structure_hash["fields"]["freeandreducedmeals"              ]       = {"data_type"=>"text",         "file_field"=>"freeandreducedmeals"              }       if field_order.push("freeandreducedmeals")
            structure_hash["fields"]["registrationstatustext"           ]       = {"data_type"=>"text",         "file_field"=>"registrationstatustext"           }       if field_order.push("registrationstatustext")
            structure_hash["fields"]["registrationyear"                 ]       = {"data_type"=>"year",         "file_field"=>"registrationyear"                 }       if field_order.push("registrationyear")
            structure_hash["fields"]["registrationlastchangedate"       ]       = {"data_type"=>"datetime",     "file_field"=>"registrationlastchangedate"       }       if field_order.push("registrationlastchangedate")
            structure_hash["fields"]["previousschooltype"               ]       = {"data_type"=>"text",         "file_field"=>"previousschooltype"               }       if field_order.push("previousschooltype")
            structure_hash["fields"]["admissionreason"                  ]       = {"data_type"=>"text",         "file_field"=>"admissionreason"                  }       if field_order.push("admissionreason")
            structure_hash["fields"]["admissiongrade"                   ]       = {"data_type"=>"text",         "file_field"=>"admissiongrade"                   }       if field_order.push("admissiongrade")
            structure_hash["fields"]["ssid"                             ]       = {"data_type"=>"text",         "file_field"=>"ssid"                             }       if field_order.push("ssid")
            structure_hash["fields"]["prevschoolname"                   ]       = {"data_type"=>"text",         "file_field"=>"prevschoolname"                   }       if field_order.push("prevschoolname")
            structure_hash["fields"]["prevschoolstate"                  ]       = {"data_type"=>"text",         "file_field"=>"prevschoolstate"                  }       if field_order.push("prevschoolstate")
            structure_hash["fields"]["studentemail"                     ]       = {"data_type"=>"text",         "file_field"=>"studentemail"                     }       if field_order.push("studentemail")
            structure_hash["fields"]["econdisadvan"                     ]       = {"data_type"=>"bool",         "file_field"=>"econdisadvan"                     }       if field_order.push("econdisadvan")
            structure_hash["fields"]["cityofbirth"                      ]       = {"data_type"=>"text",         "file_field"=>"cityofbirth"                      }       if field_order.push("cityofbirth")
            structure_hash["fields"]["districtid"                       ]       = {"data_type"=>"int",          "file_field"=>"districtid"                       }       if field_order.push("districtid")
            structure_hash["fields"]["districtcode"                     ]       = {"data_type"=>"text",         "file_field"=>"districtcode"                     }       if field_order.push("districtcode")
            structure_hash["fields"]["isfulltime"                       ]       = {"data_type"=>"bool",         "file_field"=>"isfulltime"                       }       if field_order.push("isfulltime")
            structure_hash["fields"]["transferringto"                   ]       = {"data_type"=>"text",         "file_field"=>"transferringto"                   }       if field_order.push("transferringto")
            structure_hash["fields"]["enrollmentstatus"                 ]       = {"data_type"=>"text",         "file_field"=>"enrollmentstatus"                 }       if field_order.push("enrollmentstatus")
            structure_hash["fields"]["registrationstatus"               ]       = {"data_type"=>"text",         "file_field"=>"registrationstatus"               }       if field_order.push("registrationstatus")
            structure_hash["fields"]["hsenrollsurs"                     ]       = {"data_type"=>"text",         "file_field"=>"hsenrollsurs"                     }       if field_order.push("hsenrollsurs")
            structure_hash["fields"]["hsregsurs"                        ]       = {"data_type"=>"int",          "file_field"=>"hsregsurs"                        }       if field_order.push("hsregsurs")
            structure_hash["fields"]["k8enrollsurlc"                    ]       = {"data_type"=>"int",          "file_field"=>"k8enrollsurlc"                    }       if field_order.push("k8enrollsurlc")
            structure_hash["fields"]["hsenrollsurlc"                    ]       = {"data_type"=>"int",          "file_field"=>"hsenrollsurlc"                    }       if field_order.push("hsenrollsurlc")
            structure_hash["fields"]["k8regsurlc"                       ]       = {"data_type"=>"int",          "file_field"=>"k8regsurlc"                       }       if field_order.push("k8regsurlc")
            structure_hash["fields"]["hsregsurlc"                       ]       = {"data_type"=>"int",          "file_field"=>"hsregsurlc"                       }       if field_order.push("hsregsurlc")
            structure_hash["fields"]["fundmodeldesc"                    ]       = {"data_type"=>"text",         "file_field"=>"fundmodeldesc"                    }       if field_order.push("fundmodeldesc")
            structure_hash["fields"]["fundmodelcode"                    ]       = {"data_type"=>"text",         "file_field"=>"fundmodelcode"                    }       if field_order.push("fundmodelcode")
            structure_hash["fields"]["fte"                              ]       = {"data_type"=>"text",         "file_field"=>"fte"                              }       if field_order.push("fte")
            structure_hash["fields"]["cohort_year"                      ]       = {"data_type"=>"int",          "file_field"=>"cohort_year"                      }       if field_order.push("cohort_year")
            structure_hash["fields"]["schoolenrolldate"                 ]       = {"data_type"=>"date",         "file_field"=>"schoolenrolldate"                 }       if field_order.push("schoolenrolldate")                                                                                                                  
            structure_hash["fields"]["withdrawdate"                     ]       = {"data_type"=>"date",         "file_field"=>"withdrawdate"                     }       if field_order.push("withdrawdate")
            structure_hash["fields"]["schoolwithdrawdate"               ]       = {"data_type"=>"date",         "file_field"=>"schoolwithdrawdate"               }       if field_order.push("schoolwithdrawdate")
            structure_hash["fields"]["transferring_to"                  ]       = {"data_type"=>"text",         "file_field"=>"transferring_to"                  }       if field_order.push("transferring_to")
            structure_hash["fields"]["withdrawreason"                   ]       = {"data_type"=>"text",         "file_field"=>"withdrawreason"                   }       if field_order.push("withdrawreason")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end