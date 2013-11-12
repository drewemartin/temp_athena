#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM < Athena_Table
    
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

    def by_staffid(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_samsid(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("samspersonid", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_samsid_regexp(arg) #If there is more than one sams id stored then this will return a match, use this until the sams is'd section gets it's own table.
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("samspersonid", "REGEXP", ".*#{arg}.*") )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystaffid(field_name, staffid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", staffid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    #def staff_names
    #    $db.get_data("SELECT primary_id, CONCAT('legal_last_name', ', ', 'legal_first_name',) FROM #{tablename}")
    #end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_insert(this_record)
        
        defaults = [ #can probably go somewhere better...
            
            "student_search",
            "live_reports_access",
            "live_reports_my_students_general",
            "live_reports_my_students_tests",
            "live_reports_my_student_contacts",
            "module_student_attendance_ap",
            "module_student_contacts",
            "module_student_rtii",
            "module_tep_agreements",
            "module_withdraw_requests",
            "module_ink_orders",
            "module_pssa_entry",
            "module_record_requests",
            "module_dnc_students",
            "module_student_attendance",
            "module_student_tests",
            "module_student_specialists",
            "module_student_assessments",
            "module_student_ilp",
            "module_student_psychological_evaluation",
            "student_contacts_edit",
            "student_ilp_edit",
            "student_tests_edit"
        ]
        
        tid = this_record.primary_id
        
        rights_record = $tables.attach("team_rights").record("WHERE team_id = '#{tid}'")
        
        if !rights_record
            
            new_row = $tables.attach("team_rights").new_row
            
            new_row.fields["team_id"].value = tid
            
            defaults.each do |default|
                
                new_row.fields[default].value = "1"
                
            end
            
            new_row.save
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SELECT_DD_CHOICES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def staff_names
        output = Array.new
        results = $db.get_data("SELECT primary_id, CONCAT(legal_last_name, ', ', legal_first_name) FROM #{data_base}.#{table_name}")
        results.each_with_index do |result, i|
            output.push(i = {"name" => result[1],    "value" => result[0]})
        end
        return output
    end
    
    def ethnicity
        output = [
            ai = {"name" => "American Indian/Alaskan Native",            "value" => "1"},
            aa = {"name" => "Black or African American",                 "value" => "3"},
            h =  {"name" => "Hispanic",                                  "value" => "4"},
            w =  {"name" => "White",                                     "value" => "5"},
            mr = {"name" => "Muti-Racial",                               "value" => "6"},
            a =  {"name" => "Asian",                                     "value" => "9"},
            nh = {"name" => "Native Hawaiian/Other Pacific Islander",    "value" => "10"}
        ]
    end
    
    def gender
        output = [
            m = {"name" => "Male",    "value" => "M"},
            f = {"name" => "Female",  "value" => "F"}
        ]
    end
    
    def status
        output = [
            a = {"name" => "Active",      "value" => "A"},
            t = {"name" => "Terminated",  "value" => "T"}
        ]
    end
    
    def status_leave
        output = [
            m = {"name" => "Military Leave",        "value" => "M"},
            s = {"name" => "Sabbatical Leave",      "value" => "S"},
            u = {"name" => "Suspension",            "value" => "U"},
            o = {"name" => "Other",                 "value" => "O"},
            h = {"name" => "Charter School",        "value" => "H"},
            w = {"name" => "Workers' Compensation", "value" => "W"}
        ]
    end
    
    def ft_pt
        output = [
            f = {"name" => "Full Time",      "value" => "F"},
            p = {"name" => "Part Time",      "value" => "P"}
        ]
    end
    
    def k12_agora
        output = [
            k = {"name" => "K12",      "value" => "K12"},
            a = {"name" => "Agora",    "value" => "Agora"}
        ]
    end
    
    def employee_type
        output = [
            t = {"name" => "Teacher",              "value" => "Teacher"},
            a = {"name" => "Advisor/Counselor",    "value" => "Advisor/Counselor"},
            s = {"name" => "Support",              "value" => "Support"}
        ]
    end
    
    def teacher_breakdown
        output = [
            k = {"name" => "Elementary School",        "value" => "Elementary School"},
            a = {"name" => "Middle School",            "value" => "Middle School"},
            a = {"name" => "High School",              "value" => "High School"},
            a = {"name" => "Special Education",        "value" => "Special Education"}
        ]
    end
    
    def highest_degree
        output = [
            a = {"name" => "High School Diploma",                       "value" => "1044"},
            b = {"name" => "High School Equivalency",                   "value" => "2409"},
            c = {"name" => "Vocational Certificate, No College Degree", "value" => "819"},
            d = {"name" => "Some College But No Degree",                "value" => "1049"},
            e = {"name" => "Associate's Degree (2 Years or More)",      "value" => "1050"},
            f = {"name" => "Bachelor's degree",                         "value" => "1051"},
            g = {"name" => "Master Degree",                             "value" => "1054"},
            h = {"name" => "Specialist's degree",                       "value" => "1055"},
            i = {"name" => "Doctoral degree",                           "value" => "1057"},
            j = {"name" => "less than HS graduate",                     "value" => "9998"}
        ]
    end

    def payroll_company
        output = [
            a = {"name" => "AccountTemps",     "value" => "AccountTemps"},
            i = {"name" => "Insperity",        "value" => "Insperity"},
            k = {"name" => "K12",              "value" => "K12"},
            p = {"name" => "PeopleShare",      "value" => "PeopleShare"}
        ]
    end
    
    def termination_reason
        output = [
            a = {"name" => "Resigned/Terminated, Remained In Education",    "value" => "1"},
            b = {"name" => "Resigned/Terminated, Left Education",           "value" => "2"},
            c = {"name" => "Furloughed/Laid Off",                           "value" => "3"},
            d = {"name" => "Retired",                                       "value" => "6"},
            e = {"name" => "Death/Illness",                                 "value" => "7"},
            f = {"name" => "Other",                                         "value" => "8"},
            g = {"name" => "Disciplinary Action",                           "value" => "14"},
            h = {"name" => "Retired PPID",                                  "value" => "15"}
        ]
    end
    
    def suffix
        output = [
            one =     {"name" => "Sr.",   "value" => "Sr."   },
            two =     {"name" => "Jr.",   "value" => "Jr."   },
            three =   {"name" => "III",   "value" => "III"   },
            four =    {"name" => "IV",    "value" => "IV"    },
            five =    {"name" => "V",     "value" => "V"     },
            six =     {"name" => "VI",    "value" => "VI"    },
            seven =   {"name" => "VII",   "value" => "VII"   },
            eight =   {"name" => "VIII",  "value" => "VIII"  },
            nine =    {"name" => "IX",    "value" => "IX"    },
            ten =     {"name" => "X",     "value" => "X"     }
        ]
    end
    
    def phone_type
        output = [
            h = {"name" => "Home",    "value" => "Home"},
            w = {"name" => "Work",    "value" => "Work"},
            c = {"name" => "Cell",    "value" => "Cell"}
        ]
    end
    
    def email_type
        output = [
            h = {"name" => "Home",    "value" => "Home"},
            w = {"name" => "Work",    "value" => "Work"},
        ]
    end
    
    def states
        output = [
            al = {"name" => "Alabama",        "value" => "AL"},
            ak = {"name" => "Alaska",         "value" => "AK"},
            az = {"name" => "Arizona",        "value" => "AZ"},
            ar = {"name" => "Arkansas",       "value" => "AR"},
            ca = {"name" => "California",     "value" => "CA"},
            co = {"name" => "Colorado",       "value" => "CO"},
            ct = {"name" => "Connecticut",    "value" => "CT"},
            de = {"name" => "Delaware",       "value" => "DE"},
            fl = {"name" => "Florida",        "value" => "FL"},
            ga = {"name" => "Georgia",        "value" => "GA"},
            hi = {"name" => "Hawaii",         "value" => "HI"},
            id = {"name" => "Idaho",          "value" => "ID"},
            il = {"name" => "Illinois",       "value" => "IL"},
            id = {"name" => "Indiana",        "value" => "IN"},
            ia = {"name" => "Iowa",           "value" => "IA"},
            ks = {"name" => "Kansas",         "value" => "KS"},
            ky = {"name" => "Kentucky",       "value" => "KY"},
            la = {"name" => "Louisiana",      "value" => "LA"},
            me = {"name" => "Maine",          "value" => "ME"},
            md = {"name" => "Maryland",       "value" => "MD"},
            ma = {"name" => "Massachusetts",  "value" => "MA"},
            mi = {"name" => "Michigan",       "value" => "MI"},
            mn = {"name" => "Minnesota",      "value" => "MN"},
            ms = {"name" => "Mississippi",    "value" => "MS"},
            mo = {"name" => "Missouri",       "value" => "MO"},
            mt = {"name" => "Montana",        "value" => "MT"},
            ne = {"name" => "Nebraska",       "value" => "NE"},
            nv = {"name" => "Nevada",         "value" => "NV"},
            nh = {"name" => "New Hampshire",  "value" => "NH"},
            nj = {"name" => "New Jersey",     "value" => "NJ"},
            nm = {"name" => "New Mexico",     "value" => "NM"},
            ny = {"name" => "New York",       "value" => "NY"},
            nc = {"name" => "North Carolina", "value" => "NC"},
            nd = {"name" => "North Dakota",   "value" => "ND"},
            oh = {"name" => "Ohio",           "value" => "OH"},
            ok = {"name" => "Oklahoma",       "value" => "OK"},
            og = {"name" => "Oregon",         "value" => "OR"},
            pa = {"name" => "Pennsylvania",   "value" => "PA"},
            ri = {"name" => "Rhode Island",   "value" => "RI"},
            sc = {"name" => "South Carolina", "value" => "SC"},
            sd = {"name" => "South Dakota",   "value" => "SD"},
            tn = {"name" => "Tennessee",      "value" => "TN"},
            tx = {"name" => "Texas",          "value" => "TX"},
            ut = {"name" => "Utah",           "value" => "UT"},
            vt = {"name" => "Vermont",        "value" => "VT"},
            va = {"name" => "Virginia",       "value" => "VA"},
            wa = {"name" => "Washington",     "value" => "WA"},
            wv = {"name" => "West Virginia",  "value" => "WV"},
            wi = {"name" => "Wisconsin",      "value" => "WI"},
            wy = {"name" => "Wyoming",        "value" => "WY"}
        ]
    end
    
    def counties
        counties = [
            ada = {"name" => "Adams", 	        "value" => "Adams" 	    },
            all = {"name" => "Allegheny", 	"value" => "Allegheny"      }, 
            arm = {"name" => "Armstrong", 	"value" => "Armstrong"      }, 
            bea = {"name" => "Beaver", 	        "value" => "Beaver" 	    }, 
            bed = {"name" => "Bedford", 	"value" => "Bedford" 	    }, 
            ber = {"name" => "Berks", 	        "value" => "Berks" 	    }, 
            bla = {"name" => "Blair", 	        "value" => "Blair" 	    }, 
            bra = {"name" => "Bradford", 	"value" => "Bradford" 	    }, 
            buc = {"name" => "Bucks", 	        "value" => "Bucks" 	    }, 
            but = {"name" => "Butler", 	        "value" => "Butler" 	    }, 
            cam = {"name" => "Cambria", 	"value" => "Cambria" 	    }, 
            cam = {"name" => "Cameron", 	"value" => "Cameron" 	    }, 
            car = {"name" => "Carbon", 	        "value" => "Carbon" 	    },
            cen = {"name" => "Centre", 	        "value" => "Centre" 	    },
            che = {"name" => "Chester", 	"value" => "Chester" 	    },
            cla = {"name" => "Clarion", 	"value" => "Clarion" 	    },
            cle = {"name" => "Clearfield",      "value" => "Clearfield"     },
            cli = {"name" => "Clinton", 	"value" => "Clinton" 	    },
            col = {"name" => "Columbia", 	"value" => "Columbia" 	    },
            cra = {"name" => "Crawford", 	"value" => "Crawford" 	    },
            cum = {"name" => "Cumberland",      "value" => "Cumberland"     },
            dau = {"name" => "Dauphin", 	"value" => "Dauphin" 	    },
            del = {"name" => "Delaware", 	"value" => "Delaware" 	    },
            elk = {"name" => "Elk",             "value" => "Elk"            },
            eri = {"name" => "Erie",            "value" => "Erie"           },
            fay = {"name" => "Fayette", 	"value" => "Fayette" 	    },
            foe = {"name" => "Forest", 	        "value" => "Forest" 	    },
            fra = {"name" => "Franklin", 	"value" => "Franklin" 	    },
            ful = {"name" => "Fulton", 	        "value" => "Fulton" 	    },
            gre = {"name" => "Greene", 	        "value" => "Greene" 	    },
            hun = {"name" => "Huntingdon",      "value" => "Huntingdon"     },
            ind = {"name" => "Indiana", 	"value" => "Indiana" 	    },
            jef = {"name" => "Jefferson", 	"value" => "Jefferson"      },
            jun = {"name" => "Juniata", 	"value" => "Juniata" 	    },
            lac = {"name" => "Lackawanna",      "value" => "Lackawanna"     },
            lan = {"name" => "Lancaster", 	"value" => "Lancaster"      },
            law = {"name" => "Lawrence", 	"value" => "Lawrence" 	    },
            leb = {"name" => "Lebanon", 	"value" => "Lebanon" 	    },
            leh = {"name" => "Lehigh", 	        "value" => "Lehigh" 	    },
            luz = {"name" => "Luzerne", 	"value" => "Luzerne" 	    },
            lyc = {"name" => "Lycoming", 	"value" => "Lycoming" 	    },
            mck = {"name" => "McKean", 	        "value" => "McKean" 	    },
            mer = {"name" => "Mercer", 	        "value" => "Mercer" 	    },
            mif = {"name" => "Mifflin", 	"value" => "Mifflin" 	    },
            mon = {"name" => "Monroe", 	        "value" => "Monroe" 	    },
            mon = {"name" => "Montgomery",      "value" => "Montgomery"     },
            mon = {"name" => "Montour", 	"value" => "Montour" 	    },
            nor = {"name" => "Northampton",     "value" => "Northampton"    },
            nor = {"name" => "Northumberland",  "value" => "Northumberland" },
            per = {"name" => "Perry", 	        "value" => "Perry" 	    },
            phi = {"name" => "Philadelphia",    "value" => "Philadelphia"   },
            pik = {"name" => "Pike",            "value" => "Pike"           },
            pot = {"name" => "Potter", 	        "value" => "Potter" 	    },
            sch = {"name" => "Schuylkill",      "value" => "Schuylkill"     },
            sny = {"name" => "Snyder", 	        "value" => "Snyder" 	    },
            som = {"name" => "Somerset", 	"value" => "Somerset" 	    },
            sul = {"name" => "Sullivan", 	"value" => "Sullivan" 	    },
            sus = {"name" => "Susquehanna",     "value" => "Susquehanna"    },
            tio = {"name" => "Tioga", 	        "value" => "Tioga" 	    },
            uni = {"name" => "Union", 	        "value" => "Union" 	    },
            ven = {"name" => "Venango", 	"value" => "Venango" 	    },
            war = {"name" => "Warren", 	        "value" => "Warren" 	    },
            was = {"name" => "Washington",      "value" => "Washington"     },
            way = {"name" => "Wayne", 	        "value" => "Wayne" 	    },
            wes = {"name" => "Westmoreland",    "value" => "Westmoreland"   },
            wyo = {"name" => "Wyoming", 	"value" => "Wyoming" 	    },
            yor = {"name" => "York",            "value" => "York"           }
        ]
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
                "name"              => "team",
                "file_name"         => "team.csv",
                "file_location"     => "team",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
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
            structure_hash["fields"]["region"                   ] = {"data_type"=>"text", "file_field"=>"region"                        } if field_order.push("region"                  )
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