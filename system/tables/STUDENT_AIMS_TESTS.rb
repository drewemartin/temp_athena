#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_AIMS_TESTS < Athena_Table
    
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

    def after_change(row_obj)
        
        ilp_tracking_fields = {
            
            #:lnf                                     => "LNF"                                   ,
            #:lnf_errors                              => "LNF Errors"                            ,
            #:lsf                                     => "LSF"                                   ,
            #:lsf_errors                              => "LSF Errors"                            ,
            #:psf                                     => "PSF"                                   ,
            #:psf_errors                              => "PSF Errors"                            ,
            #:nwf                                     => "NWF"                                   ,
            #:nwf_errors                              => "NWF Errors"                            ,
            #:rcbm                                    => "RCBM"                                  ,
            #:rcbm_errors                             => "RCBM Errors"                           ,
            :reading_instructional_recommendation    => "Reading Instructional Recommendation"  ,
            #:"2nd_grade_reading_comprehension_check" => "2nd Grade Reading Comprehension Check" ,
            #:ocm                                     => "OCM"                                   ,
            #:ocm_errors                              => "OCM Errors"                            ,
            #:nim                                     => "NIM"                                   ,
            #:nim_errors                              => "NIM Errors"                            ,
            #:qdm                                     => "QDM"                                   ,
            #:qdm_errors                              => "QDM Errors"                            ,
            #:mnm                                     => "MNM"                                   ,
            #:mnm_errors                              => "MNM Errors"                            ,
            #:mcap                                    => "MCAP"                                  ,
            #:math_instructional_recommendation       => "Math Instructional Recommendation"     ,
            :notes                                   => "Math Instructional Recommendation"      ,
            #:mcap_read_to_student                    => "MCAP read to student"
            
        }
        
        sid             = field_by_pid("student_id", row_obj.primary_id).value
        student         = $students.get(sid)
        ilp_cat_id      = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids("WHERE name = 'AIMS Assessment'")[0]
        
        test_id         = field_by_pid("test_id", row_obj.primary_id).value
        test_event_id   = $tables.attach("STUDENT_TESTS").field_by_pid("test_event_id", test_id         ).value
        test_event_name = $tables.attach("TEST_EVENTS"  ).field_by_pid("name",          test_event_id   ).value
        
        ilp_tracking_fields.each_pair{|field_name, nice_name|
           
            if row_obj.fields.keys.find{|x|x==field_name.to_s}
                
                ilp_type_id = $tables.attach("ILP_ENTRY_TYPE").primary_ids("WHERE name = '#{nice_name}' AND category_id = #{ilp_cat_id}")[0]
                if (
                    
                    ilp_records  = student.ilp.existing_records(
                        "WHERE ilp_entry_category_id    = '#{ilp_cat_id}'
                        AND ilp_entry_type_id           = '#{ilp_type_id}'
                        AND description                 = '#{test_event_name}'"
                    )
                    
                )
                    
                    ilp_record = ilp_records[0]
                    
                else
                    
                    ilp_record = student.ilp.new_record
                    ilp_record.fields["ilp_entry_category_id"   ].value = ilp_cat_id
                    ilp_record.fields["ilp_entry_type_id"       ].value = ilp_type_id
                    ilp_record.fields["description"             ].value = test_event_name
                    
                end
                
                ilp_record.fields["solution"].value = row_obj.fields[field_name.to_s].value
                ilp_record.save
                
            end
            
        } if ilp_cat_id
        
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
                "name"              => "student_aims_tests",
                "file_name"         => "student_aims_tests.csv",
                "file_location"     => "student_aims_tests",
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
            
            structure_hash["fields"]["item"                                     ] = {"data_type"=>"text", "file_field"=>"item"                                  } if field_order.push("item"                                    )
            structure_hash["fields"]["test_id"                                  ] = {"data_type"=>"int",  "file_field"=>"test_id"                               } if field_order.push("test_id"                                 )
            structure_hash["fields"]["student_id"                               ] = {"data_type"=>"int",  "file_field"=>"student_id"                            } if field_order.push("student_id"                              )
            structure_hash["fields"]["student_last_name"                        ] = {"data_type"=>"text", "file_field"=>"student_last_name"                     } if field_order.push("student_last_name"                       )
            structure_hash["fields"]["student_first_name"                       ] = {"data_type"=>"text", "file_field"=>"student_first_name"                    } if field_order.push("student_first_name"                      )
            structure_hash["fields"]["grade"                                    ] = {"data_type"=>"text", "file_field"=>"grade"                                 } if field_order.push("grade"                                   )
            structure_hash["fields"]["school_enrollment_date"                   ] = {"data_type"=>"date", "file_field"=>"school_enrollment_date"                } if field_order.push("school_enrollment_date"                  )
            structure_hash["fields"]["family_coach"                             ] = {"data_type"=>"text", "file_field"=>"family_coach"                          } if field_order.push("family_coach"                            )
            structure_hash["fields"]["general_ed_teacher"                       ] = {"data_type"=>"text", "file_field"=>"general_ed_teacher"                    } if field_order.push("general_ed_teacher"                      )
            structure_hash["fields"]["special_ed_teacher"                       ] = {"data_type"=>"text", "file_field"=>"special_ed_teacher"                    } if field_order.push("special_ed_teacher"                      )
            structure_hash["fields"]["requirement_for_aims_benchmark"           ] = {"data_type"=>"bool", "file_field"=>"requirement_for_aims_benchmark"        } if field_order.push("requirement_for_aims_benchmark"          )
            structure_hash["fields"]["screener"                                 ] = {"data_type"=>"text", "file_field"=>"screener"                              } if field_order.push("screener"                                )
            structure_hash["fields"]["face_to_face_or_virtual"                  ] = {"data_type"=>"text", "file_field"=>"face_to_face_or_virtual"               } if field_order.push("face_to_face_or_virtual"                 )
            structure_hash["fields"]["screening_date"                           ] = {"data_type"=>"date", "file_field"=>"screening_date"                        } if field_order.push("screening_date"                          )
            structure_hash["fields"]["site"                                     ] = {"data_type"=>"text", "file_field"=>"site"                                  } if field_order.push("site"                                    )
            
            structure_hash["fields"]["lnf"                                      ] = {"data_type"=>"int",  "file_field"=>"lnf"                                   } if field_order.push("lnf"                                     )
            structure_hash["fields"]["lnf_errors"                               ] = {"data_type"=>"int",  "file_field"=>"lnf_errors"                            } if field_order.push("lnf_errors"                              )
            structure_hash["fields"]["lsf"                                      ] = {"data_type"=>"int",  "file_field"=>"lsf"                                   } if field_order.push("lsf"                                     )
            structure_hash["fields"]["lsf_errors"                               ] = {"data_type"=>"int",  "file_field"=>"lsf_errors"                            } if field_order.push("lsf_errors"                              )
            structure_hash["fields"]["psf"                                      ] = {"data_type"=>"int",  "file_field"=>"psf"                                   } if field_order.push("psf"                                     )
            structure_hash["fields"]["psf_errors"                               ] = {"data_type"=>"int",  "file_field"=>"psf_errors"                            } if field_order.push("psf_errors"                              )
            structure_hash["fields"]["nwf"                                      ] = {"data_type"=>"int",  "file_field"=>"nwf"                                   } if field_order.push("nwf"                                     )
            structure_hash["fields"]["nwf_errors"                               ] = {"data_type"=>"int",  "file_field"=>"nwf_errors"                            } if field_order.push("nwf_errors"                              )
            structure_hash["fields"]["rcbm"                                     ] = {"data_type"=>"int",  "file_field"=>"rcbm"                                  } if field_order.push("rcbm"                                    )
            structure_hash["fields"]["rcbm_errors"                              ] = {"data_type"=>"int",  "file_field"=>"rcbm_errors"                           } if field_order.push("rcbm_errors"                             )
            structure_hash["fields"]["reading_instructional_recommendation"     ] = {"data_type"=>"text", "file_field"=>"reading_instructional_recommendation"  } if field_order.push("reading_instructional_recommendation"    )
            structure_hash["fields"]["2nd_grade_reading_comprehension_check"    ] = {"data_type"=>"text", "file_field"=>"2nd_grade_reading_comprehension_check" } if field_order.push("2nd_grade_reading_comprehension_check"   )
            
            structure_hash["fields"]["ocm"                                      ] = {"data_type"=>"int",  "file_field"=>"ocm"                                   } if field_order.push("ocm"                                     )
            structure_hash["fields"]["ocm_errors"                               ] = {"data_type"=>"int",  "file_field"=>"ocm_errors"                            } if field_order.push("ocm_errors"                              )
            structure_hash["fields"]["nim"                                      ] = {"data_type"=>"int",  "file_field"=>"nim"                                   } if field_order.push("nim"                                     )
            structure_hash["fields"]["nim_errors"                               ] = {"data_type"=>"int",  "file_field"=>"nim_errors"                            } if field_order.push("nim_errors"                              )
            structure_hash["fields"]["qdm"                                      ] = {"data_type"=>"int",  "file_field"=>"qdm"                                   } if field_order.push("qdm"                                     )
            structure_hash["fields"]["qdm_errors"                               ] = {"data_type"=>"int",  "file_field"=>"qdm_errors"                            } if field_order.push("qdm_errors"                              )
            structure_hash["fields"]["mnm"                                      ] = {"data_type"=>"int",  "file_field"=>"mnm"                                   } if field_order.push("mnm"                                     )
            structure_hash["fields"]["mnm_errors"                               ] = {"data_type"=>"int",  "file_field"=>"mnm_errors"                            } if field_order.push("mnm_errors"                              )
            structure_hash["fields"]["mcap"                                     ] = {"data_type"=>"int",  "file_field"=>"mcap"                                  } if field_order.push("mcap"                                    )
            structure_hash["fields"]["math_instructional_recommendation"        ] = {"data_type"=>"text", "file_field"=>"math_instructional_recommendation"     } if field_order.push("math_instructional_recommendation"       )
            structure_hash["fields"]["notes"                                    ] = {"data_type"=>"text", "file_field"=>"notes"                                 } if field_order.push("notes"                                   )
            structure_hash["fields"]["mcap_read_to_student"                     ] = {"data_type"=>"bool", "file_field"=>"mcap_read_to_student"                  } if field_order.push("mcap_read_to_student"                    )
            
            structure_hash["fields"]["reading_comprehension"                    ] = {"data_type"=>"text", "file_field"=>"reading_comprehension"                  } if field_order.push("reading_comprehension"                   )
            structure_hash["fields"]["reading_comprehension_who_read"           ] = {"data_type"=>"text", "file_field"=>"reading_comprehension_who_read"         } if field_order.push("reading_comprehension_who_read"          )
            structure_hash["fields"]["core_phonics_short_vowel_cvc"             ] = {"data_type"=>"text", "file_field"=>"core_phonics_short_vowel_cvc"           } if field_order.push("core_phonics_short_vowel_cvc"            )
            structure_hash["fields"]["core_phonics_letter_names_upper"          ] = {"data_type"=>"text", "file_field"=>"core_phonics_letter_names_upper"        } if field_order.push("core_phonics_letter_names_upper"         )
            structure_hash["fields"]["core_phonics_letter_names_lower"          ] = {"data_type"=>"text", "file_field"=>"core_phonics_letter_names_lower"        } if field_order.push("core_phonics_letter_names_lower"         )
            structure_hash["fields"]["core_phonics_consonant"                   ] = {"data_type"=>"text", "file_field"=>"core_phonics_consonant"                 } if field_order.push("core_phonics_consonant"                  )
            structure_hash["fields"]["core_phonics_long_vowel"                  ] = {"data_type"=>"text", "file_field"=>"core_phonics_long_vowel"                } if field_order.push("core_phonics_long_vowel"                 )
            structure_hash["fields"]["core_phonics_short_vowel"                 ] = {"data_type"=>"text", "file_field"=>"core_phonics_short_vowel"               } if field_order.push("core_phonics_short_vowel"                )
            structure_hash["fields"]["core_phonics_short_vowel_digraph"         ] = {"data_type"=>"text", "file_field"=>"core_phonics_short_vowel_digraph"       } if field_order.push("core_phonics_short_vowel_digraph"        )
            structure_hash["fields"]["core_phonics_consonant_blend"             ] = {"data_type"=>"text", "file_field"=>"core_phonics_consonant_blend"           } if field_order.push("core_phonics_consonant_blend"            )
            structure_hash["fields"]["core_phonics_long_vowel_spelling"         ] = {"data_type"=>"text", "file_field"=>"core_phonics_long_vowel_spelling"       } if field_order.push("core_phonics_long_vowel_spelling"        )
            structure_hash["fields"]["core_phonics_rl_control"                  ] = {"data_type"=>"text", "file_field"=>"core_phonics_rl_control"                } if field_order.push("core_phonics_rl_control"                 )
            structure_hash["fields"]["core_phonics_variant_vowels"              ] = {"data_type"=>"text", "file_field"=>"core_phonics_variant_vowels"            } if field_order.push("core_phonics_variant_vowels"             )
            structure_hash["fields"]["core_phonics_multisyllabic"               ] = {"data_type"=>"text", "file_field"=>"core_phonics_multisyllabic"             } if field_order.push("core_phonics_multisyllabic"              )
            structure_hash["fields"]["core_phonics_spelling_a"                  ] = {"data_type"=>"text", "file_field"=>"core_phonics_spelling_a"                } if field_order.push("core_phonics_spelling_a"                 )
            structure_hash["fields"]["core_phonics_spelling_b"                  ] = {"data_type"=>"text", "file_field"=>"core_phonics_spelling_b"                } if field_order.push("core_phonics_spelling_b"                 )
            structure_hash["fields"]["core_phonics_spelling_c"                  ] = {"data_type"=>"text", "file_field"=>"core_phonics_spelling_c"                } if field_order.push("core_phonics_spelling_c"                 )
            
            structure_hash["fields"]["k2_skill_check_complete"                  ] = {"data_type"=>"bool", "file_field"=>"k2_skill_check_complete"                } if field_order.push("k2_skill_check_complete"                 )
            structure_hash["fields"]["writing_sample_received"                  ] = {"data_type"=>"bool", "file_field"=>"writing_sample_received"                } if field_order.push("writing_sample_received"                 )
            structure_hash["fields"]["35_math_open_prompt_complete"             ] = {"data_type"=>"text", "file_field"=>"35_math_open_prompt_complete"           } if field_order.push("35_math_open_prompt_complete"            )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end