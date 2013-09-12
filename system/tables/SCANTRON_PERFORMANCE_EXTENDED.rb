#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCANTRON_PERFORMANCE_EXTENDED < Athena_Table
    
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

    def by_studentid_old(sid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", sid) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{table_name}") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def before_load_scantron_performance_extended(arg = nil)
        
        return true if import_file_exists?
        
        if ENV["COMPUTERNAME"] == "ATHENA"
            
            return true if import_file_exists?
            
            require "#{$paths.base_path}scantron_performance_interface"
            i = Scantron_Performance_Interface.new
            if i.importing_ordered_file_scantron_performance_extended
                return true
            else
                sleep 5
                require "#{$paths.base_path}scantron_performance_interface"
                i = Scantron_Performance_Interface.new
                i.order_extended_report
                return false
            end
            
        else
            return false
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "scantron_performance_extended",
                "file_name"         => "StudentResultsExport_Extended.csv",
                "file_location"     => "scantron_performance_extended",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["reporting_date"]                              = {"data_type"=>"date", "file_field"=>"Reporting_Date"                              } if field_order.push("reporting_date")
            structure_hash["fields"]["beginning_of_date_range"]                     = {"data_type"=>"date", "file_field"=>"Beginning_Of_Date_Range"                     } if field_order.push("beginning_of_date_range")
            structure_hash["fields"]["end_of_date_range"]                           = {"data_type"=>"date", "file_field"=>"End_Of_Date_Range"                           } if field_order.push("end_of_date_range")
            structure_hash["fields"]["site_id"]                                     = {"data_type"=>"text", "file_field"=>"Site_ID"                                     } if field_order.push("site_id")
            structure_hash["fields"]["site_name"]                                   = {"data_type"=>"text", "file_field"=>"Site_Name"                                   } if field_order.push("site_name")
            structure_hash["fields"]["student_id"]                                  = {"data_type"=>"text", "file_field"=>"Student_ID"                                  } if field_order.push("student_id")
            structure_hash["fields"]["first_name"]                                  = {"data_type"=>"text", "file_field"=>"First_Name"                                  } if field_order.push("first_name")
            structure_hash["fields"]["middle_init"]                                 = {"data_type"=>"text", "file_field"=>"Middle_Init"                                 } if field_order.push("middle_init")
            structure_hash["fields"]["last_name"]                                   = {"data_type"=>"text", "file_field"=>"Last_Name"                                   } if field_order.push("last_name")
            structure_hash["fields"]["grade"]                                       = {"data_type"=>"int",  "file_field"=>"Grade"                                       } if field_order.push("grade")
            structure_hash["fields"]["enrollment_date"]                             = {"data_type"=>"date", "file_field"=>"Enrollment_Date"                             } if field_order.push("enrollment_date")
            structure_hash["fields"]["gender"]                                      = {"data_type"=>"text", "file_field"=>"Gender"                                      } if field_order.push("gender")
            structure_hash["fields"]["ethnicity"]                                   = {"data_type"=>"text", "file_field"=>"Ethnicity"                                   } if field_order.push("ethnicity")
            structure_hash["fields"]["dob"]                                         = {"data_type"=>"date", "file_field"=>"DOB"                                         } if field_order.push("dob")
            structure_hash["fields"]["citizenship"]                                 = {"data_type"=>"text", "file_field"=>"Citizenship"                                 } if field_order.push("citizenship")
            structure_hash["fields"]["lep"]                                         = {"data_type"=>"bool", "file_field"=>"LEP"                                         } if field_order.push("lep")
            structure_hash["fields"]["migratory"]                                   = {"data_type"=>"bool", "file_field"=>"Migratory"                                   } if field_order.push("migratory")
            structure_hash["fields"]["mep"]                                         = {"data_type"=>"bool", "file_field"=>"MEP"                                         } if field_order.push("mep")
            structure_hash["fields"]["smep"]                                        = {"data_type"=>"bool", "file_field"=>"SMEP"                                        } if field_order.push("smep")
            structure_hash["fields"]["disability"]                                  = {"data_type"=>"bool", "file_field"=>"Disability"                                  } if field_order.push("disability")
            structure_hash["fields"]["title_1"]                                     = {"data_type"=>"bool", "file_field"=>"Title_1"                                     } if field_order.push("title_1")
            structure_hash["fields"]["meal_assistance"]                             = {"data_type"=>"bool", "file_field"=>"Meal_Assistance"                             } if field_order.push("meal_assistance")
            structure_hash["fields"]["iep"]                                         = {"data_type"=>"bool", "file_field"=>"IEP"                                         } if field_order.push("iep")
            structure_hash["fields"]["accreading_level"]                            = {"data_type"=>"text", "file_field"=>"AccReading_Level"                            } if field_order.push("accreading_level")
            structure_hash["fields"]["accmath_level"]                               = {"data_type"=>"text", "file_field"=>"AccMath_Level"                               } if field_order.push("accmath_level")
            structure_hash["fields"]["accscience_level"]                            = {"data_type"=>"text", "file_field"=>"AccScience_Level"                            } if field_order.push("accscience_level")
            structure_hash["fields"]["acclanguage_level"]                           = {"data_type"=>"text", "file_field"=>"AccLanguage_Level"                           } if field_order.push("acclanguage_level")
            structure_hash["fields"]["reading_test_date"]                           = {"data_type"=>"date", "file_field"=>"Reading_Test_Date"                           } if field_order.push("reading_test_date")
            structure_hash["fields"]["reading_scaled_score"]                        = {"data_type"=>"int",  "file_field"=>"Reading_Scaled_Score"                        } if field_order.push("reading_scaled_score")
            structure_hash["fields"]["reading_standard_error"]                      = {"data_type"=>"int",  "file_field"=>"Reading_Standard_Error"                      } if field_order.push("reading_standard_error")
            structure_hash["fields"]["reading_percentile"]                          = {"data_type"=>"int",  "file_field"=>"Reading_Percentile"                          } if field_order.push("reading_percentile")
            structure_hash["fields"]["reading_nce"]                                 = {"data_type"=>"int",  "file_field"=>"Reading_NCE"                                 } if field_order.push("reading_nce")
            structure_hash["fields"]["vocabulary_scaled_score"]                     = {"data_type"=>"int",  "file_field"=>"Vocabulary_Scaled_Score"                     } if field_order.push("vocabulary_scaled_score")
            structure_hash["fields"]["vocabulary_standard_error"]                   = {"data_type"=>"int",  "file_field"=>"Vocabulary_Standard_Error"                   } if field_order.push("vocabulary_standard_error")
            structure_hash["fields"]["long_passage_scaled_score"]                   = {"data_type"=>"int",  "file_field"=>"Long_Passage_Scaled_Score"                   } if field_order.push("long_passage_scaled_score")
            structure_hash["fields"]["long_passage_standard_error"]                 = {"data_type"=>"int",  "file_field"=>"Long_Passage_Standard_Error"                 } if field_order.push("long_passage_standard_error")
            structure_hash["fields"]["fiction_scaled_score"]                        = {"data_type"=>"int",  "file_field"=>"Fiction_Scaled_Score"                        } if field_order.push("fiction_scaled_score")
            structure_hash["fields"]["fiction_standard_error"]                      = {"data_type"=>"int",  "file_field"=>"Fiction_Standard_Error"                      } if field_order.push("fiction_standard_error")
            structure_hash["fields"]["nonfiction_scaled_score"]                     = {"data_type"=>"int",  "file_field"=>"Nonfiction_Scaled_Score"                     } if field_order.push("nonfiction_scaled_score")
            structure_hash["fields"]["nonfiction_standard_error"]                   = {"data_type"=>"int",  "file_field"=>"Nonfiction_Standard_Error"                   } if field_order.push("nonfiction_standard_error")
            structure_hash["fields"]["reading_rate"]                                = {"data_type"=>"int",  "file_field"=>"Reading_Rate"                                } if field_order.push("reading_rate")
            structure_hash["fields"]["math_test_date"]                              = {"data_type"=>"date", "file_field"=>"Math_Test_Date"                              } if field_order.push("math_test_date")
            structure_hash["fields"]["math_test_language"]                          = {"data_type"=>"text", "file_field"=>"Math_Test_Language"                          } if field_order.push("math_test_language")
            structure_hash["fields"]["math_scaled_score"]                           = {"data_type"=>"int",  "file_field"=>"Math_Scaled_Score"                           } if field_order.push("math_scaled_score")
            structure_hash["fields"]["math_standard_error"]                         = {"data_type"=>"int",  "file_field"=>"Math_Standard_Error"                         } if field_order.push("math_standard_error")
            structure_hash["fields"]["math_percentile"]                             = {"data_type"=>"int",  "file_field"=>"Math_Percentile"                             } if field_order.push("math_percentile")
            structure_hash["fields"]["math_nce"]                                    = {"data_type"=>"int",  "file_field"=>"Math_NCE"                                    } if field_order.push("math_nce")
            structure_hash["fields"]["number_&_operations_scaled_score"]            = {"data_type"=>"int",  "file_field"=>"Number_&_Operations_Scaled_Score"            } if field_order.push("number_&_operations_scaled_score")
            structure_hash["fields"]["number_&_operations_standard_error"]          = {"data_type"=>"int",  "file_field"=>"Number_&_Operations_Standard_Error"          } if field_order.push("number_&_operations_standard_error")
            structure_hash["fields"]["algebra_scaled_score"]                        = {"data_type"=>"int",  "file_field"=>"Algebra_Scaled_Score"                        } if field_order.push("algebra_scaled_score")
            structure_hash["fields"]["algebra_standard_error"]                      = {"data_type"=>"int",  "file_field"=>"Algebra_Standard_Error"                      } if field_order.push("algebra_standard_error")
            structure_hash["fields"]["geometry_scaled_score"]                       = {"data_type"=>"int",  "file_field"=>"Geometry_Scaled_Score"                       } if field_order.push("geometry_scaled_score")
            structure_hash["fields"]["geometry_standard_error"]                     = {"data_type"=>"int",  "file_field"=>"Geometry_Standard_Error"                     } if field_order.push("geometry_standard_error")
            structure_hash["fields"]["measurement_scaled_score"]                    = {"data_type"=>"int",  "file_field"=>"Measurement_Scaled_Score"                    } if field_order.push("measurement_scaled_score")
            structure_hash["fields"]["measurement_standard_error"]                  = {"data_type"=>"int",  "file_field"=>"Measurement_Standard_Error"                  } if field_order.push("measurement_standard_error")
            structure_hash["fields"]["data_analysis_&_probability_scaled_score"]    = {"data_type"=>"int",  "file_field"=>"Data_Analysis_&_Probability_Scaled_Score"    } if field_order.push("data_analysis_&_probability_scaled_score")
            structure_hash["fields"]["data_analysis_&_probability_standard_error"]  = {"data_type"=>"int",  "file_field"=>"Data_Analysis_&_Probability_Standard_Error"  } if field_order.push("data_analysis_&_probability_standard_error")
            structure_hash["fields"]["science_test_date"]                           = {"data_type"=>"date", "file_field"=>"Science_Test_Date"                           } if field_order.push("science_test_date")
            structure_hash["fields"]["science_scaled_score"]                        = {"data_type"=>"int",  "file_field"=>"Science_Scaled_Score"                        } if field_order.push("science_scaled_score")
            structure_hash["fields"]["science_standard_error"]                      = {"data_type"=>"int",  "file_field"=>"Science_Standard_Error"                      } if field_order.push("science_standard_error")
            structure_hash["fields"]["science_percentile"]                          = {"data_type"=>"int",  "file_field"=>"Science_Percentile"                          } if field_order.push("science_percentile")
            structure_hash["fields"]["science_nce"]                                 = {"data_type"=>"int",  "file_field"=>"Science_NCE"                                 } if field_order.push("science_nce")
            structure_hash["fields"]["living_things_scaled_score"]                  = {"data_type"=>"int",  "file_field"=>"Living_Things_Scaled_Score"                  } if field_order.push("living_things_scaled_score")
            structure_hash["fields"]["living_things_standard_error"]                = {"data_type"=>"int",  "file_field"=>"Living_Things_Standard_Error"                } if field_order.push("living_things_standard_error")
            structure_hash["fields"]["ecology_scaled_score"]                        = {"data_type"=>"int",  "file_field"=>"Ecology_Scaled_Score"                        } if field_order.push("ecology_scaled_score")
            structure_hash["fields"]["ecology_standard_error"]                      = {"data_type"=>"int",  "file_field"=>"Ecology_Standard_Error"                      } if field_order.push("ecology_standard_error")
            structure_hash["fields"]["science_process_scaled_score"]                = {"data_type"=>"int",  "file_field"=>"Science_Process_Scaled_Score"                } if field_order.push("science_process_scaled_score")
            structure_hash["fields"]["science_process_standard_error"]              = {"data_type"=>"int",  "file_field"=>"Science_Process_Standard_Error"              } if field_order.push("science_process_standard_error")
            structure_hash["fields"]["language_arts_test_date"]                     = {"data_type"=>"date", "file_field"=>"Language_Arts_Test_Date"                     } if field_order.push("language_arts_test_date")
            structure_hash["fields"]["language_arts_scaled_score"]                  = {"data_type"=>"int",  "file_field"=>"Language_Arts_Scaled_Score"                  } if field_order.push("language_arts_scaled_score")
            structure_hash["fields"]["language_arts_standard_error"]                = {"data_type"=>"int",  "file_field"=>"Language_Arts_Standard_Error"                } if field_order.push("language_arts_standard_error")
            structure_hash["fields"]["language_arts_percentile"]                    = {"data_type"=>"int",  "file_field"=>"Language_Arts_Percentile"                    } if field_order.push("language_arts_percentile")
            structure_hash["fields"]["language_arts_nce"]                           = {"data_type"=>"int",  "file_field"=>"Language_Arts_NCE"                           } if field_order.push("language_arts_nce")
            structure_hash["fields"]["parts_of_speech_scaled_score"]                = {"data_type"=>"int",  "file_field"=>"Parts_Of_Speech_Scaled_Score"                } if field_order.push("parts_of_speech_scaled_score")
            structure_hash["fields"]["parts_of_speech_standard_error"]              = {"data_type"=>"int",  "file_field"=>"Parts_Of_Speech_Standard_Error"              } if field_order.push("parts_of_speech_standard_error")
            structure_hash["fields"]["sentence_structure_scaled_score"]             = {"data_type"=>"int",  "file_field"=>"Sentence_Structure_Scaled_Score"             } if field_order.push("sentence_structure_scaled_score")
            structure_hash["fields"]["sentence_structure_standard_error"]           = {"data_type"=>"int",  "file_field"=>"Sentence_Structure_Standard_Error"           } if field_order.push("sentence_structure_standard_error")
            structure_hash["fields"]["punctuation_scaled_score"]                    = {"data_type"=>"int",  "file_field"=>"Punctuation_Scaled_Score"                    } if field_order.push("punctuation_scaled_score")
            structure_hash["fields"]["punctuation_standard_error"]                  = {"data_type"=>"int",  "file_field"=>"Punctuation_Standard_Error"                  } if field_order.push("punctuation_standard_error")
            structure_hash["fields"]["capitalization_scaled_score"]                 = {"data_type"=>"int",  "file_field"=>"Capitalization_Scaled_Score"                 } if field_order.push("capitalization_scaled_score")
            structure_hash["fields"]["capitalization_standard_error"]               = {"data_type"=>"int",  "file_field"=>"Capitalization_Standard_Error"               } if field_order.push("capitalization_standard_error")
            structure_hash["fields"]["math_predicted_scaledscore"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_ScaledScore"                  } if field_order.push("math_predicted_scaledscore")
            structure_hash["fields"]["math_error_of_prediction"]                    = {"data_type"=>"int",  "file_field"=>"Math_Error_of_Prediction"                    } if field_order.push("math_error_of_prediction")
            structure_hash["fields"]["math_prediction_name_short"]                  = {"data_type"=>"text", "file_field"=>"Math_Prediction_Name_Short"                  } if field_order.push("math_prediction_name_short")
            structure_hash["fields"]["math_predicted_name_long"]                    = {"data_type"=>"text", "file_field"=>"Math_Predicted_Name_Long"                    } if field_order.push("math_predicted_name_long")
            structure_hash["fields"]["math_predicted_validity_0"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_0"                   } if field_order.push("math_predicted_validity_0")
            structure_hash["fields"]["math_predicted_validity_1"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_1"                   } if field_order.push("math_predicted_validity_1")
            structure_hash["fields"]["math_predicted_validity_2"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_2"                   } if field_order.push("math_predicted_validity_2")
            structure_hash["fields"]["math_predicted_validity_3"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_3"                   } if field_order.push("math_predicted_validity_3")
            structure_hash["fields"]["math_predicted_validity_4"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_4"                   } if field_order.push("math_predicted_validity_4")
            structure_hash["fields"]["math_predicted_validity_5"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_5"                   } if field_order.push("math_predicted_validity_5")
            structure_hash["fields"]["math_predicted_validity_6"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_6"                   } if field_order.push("math_predicted_validity_6")
            structure_hash["fields"]["math_predicted_validity_7"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_7"                   } if field_order.push("math_predicted_validity_7")
            structure_hash["fields"]["math_predicted_validity_8"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_8"                   } if field_order.push("math_predicted_validity_8")
            structure_hash["fields"]["math_predicted_validity_9"]                   = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_9"                   } if field_order.push("math_predicted_validity_9")
            structure_hash["fields"]["math_predicted_validity_10"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_10"                  } if field_order.push("math_predicted_validity_10")
            structure_hash["fields"]["math_predicted_validity_11"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_11"                  } if field_order.push("math_predicted_validity_11")
            structure_hash["fields"]["math_predicted_validity_12"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_12"                  } if field_order.push("math_predicted_validity_12")
            structure_hash["fields"]["math_predicted_validity_13"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_13"                  } if field_order.push("math_predicted_validity_13")
            structure_hash["fields"]["math_predicted_validity_14"]                  = {"data_type"=>"int",  "file_field"=>"Math_Predicted_Validity_14"                  } if field_order.push("math_predicted_validity_14")
            structure_hash["fields"]["reading_predicted_scaledscore"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_ScaledScore"               } if field_order.push("reading_predicted_scaledscore")
            structure_hash["fields"]["reading_error_of_prediction"]                 = {"data_type"=>"int",  "file_field"=>"Reading_Error_of_Prediction"                 } if field_order.push("reading_error_of_prediction")
            structure_hash["fields"]["reading_prediction_name_short"]               = {"data_type"=>"text", "file_field"=>"Reading_Prediction_Name_Short"               } if field_order.push("reading_prediction_name_short")
            structure_hash["fields"]["reading_predicted_name_long"]                 = {"data_type"=>"text", "file_field"=>"Reading_Predicted_Name_Long"                 } if field_order.push("reading_predicted_name_long")
            structure_hash["fields"]["reading_predicted_validity_0"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_0"                } if field_order.push("reading_predicted_validity_0")
            structure_hash["fields"]["reading_predicted_validity_1"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_1"                } if field_order.push("reading_predicted_validity_1")
            structure_hash["fields"]["reading_predicted_validity_2"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_2"                } if field_order.push("reading_predicted_validity_2")
            structure_hash["fields"]["reading_predicted_validity_3"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_3"                } if field_order.push("reading_predicted_validity_3")
            structure_hash["fields"]["reading_predicted_validity_4"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_4"                } if field_order.push("reading_predicted_validity_4")
            structure_hash["fields"]["reading_predicted_validity_5"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_5"                } if field_order.push("reading_predicted_validity_5")
            structure_hash["fields"]["reading_predicted_validity_6"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_6"                } if field_order.push("reading_predicted_validity_6")
            structure_hash["fields"]["reading_predicted_validity_7"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_7"                } if field_order.push("reading_predicted_validity_7")
            structure_hash["fields"]["reading_predicted_validity_8"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_8"                } if field_order.push("reading_predicted_validity_8")
            structure_hash["fields"]["reading_predicted_validity_9"]                = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_9"                } if field_order.push("reading_predicted_validity_9")
            structure_hash["fields"]["reading_predicted_validity_10"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_10"               } if field_order.push("reading_predicted_validity_10")
            structure_hash["fields"]["reading_predicted_validity_11"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_11"               } if field_order.push("reading_predicted_validity_11")
            structure_hash["fields"]["reading_predicted_validity_12"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_12"               } if field_order.push("reading_predicted_validity_12")
            structure_hash["fields"]["reading_predicted_validity_13"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_13"               } if field_order.push("reading_predicted_validity_13")
            structure_hash["fields"]["reading_predicted_validity_14"]               = {"data_type"=>"int",  "file_field"=>"Reading_Predicted_Validity_14"               } if field_order.push("reading_predicted_validity_14")
            structure_hash["fields"]["science_predicted_scaledscore"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_ScaledScore"               } if field_order.push("science_predicted_scaledscore")
            structure_hash["fields"]["science_error_of_prediction"]                 = {"data_type"=>"int",  "file_field"=>"Science_Error_of_Prediction"                 } if field_order.push("science_error_of_prediction")
            structure_hash["fields"]["science_prediction_name_short"]               = {"data_type"=>"text", "file_field"=>"Science_Prediction_Name_Short"               } if field_order.push("science_prediction_name_short")
            structure_hash["fields"]["science_predicted_name_long"]                 = {"data_type"=>"text", "file_field"=>"Science_Predicted_Name_Long"                 } if field_order.push("science_predicted_name_long")
            structure_hash["fields"]["science_predicted_validity_0"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_0"                } if field_order.push("science_predicted_validity_0")
            structure_hash["fields"]["science_predicted_validity_1"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_1"                } if field_order.push("science_predicted_validity_1")
            structure_hash["fields"]["science_predicted_validity_2"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_2"                } if field_order.push("science_predicted_validity_2")
            structure_hash["fields"]["science_predicted_validity_3"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_3"                } if field_order.push("science_predicted_validity_3")
            structure_hash["fields"]["science_predicted_validity_4"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_4"                } if field_order.push("science_predicted_validity_4")
            structure_hash["fields"]["science_predicted_validity_5"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_5"                } if field_order.push("science_predicted_validity_5")
            structure_hash["fields"]["science_predicted_validity_6"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_6"                } if field_order.push("science_predicted_validity_6")
            structure_hash["fields"]["science_predicted_validity_7"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_7"                } if field_order.push("science_predicted_validity_7")
            structure_hash["fields"]["science_predicted_validity_8"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_8"                } if field_order.push("science_predicted_validity_8")
            structure_hash["fields"]["science_predicted_validity_9"]                = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_9"                } if field_order.push("science_predicted_validity_9")
            structure_hash["fields"]["science_predicted_validity_10"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_10"               } if field_order.push("science_predicted_validity_10")
            structure_hash["fields"]["science_predicted_validity_11"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_11"               } if field_order.push("science_predicted_validity_11")
            structure_hash["fields"]["science_predicted_validity_12"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_12"               } if field_order.push("science_predicted_validity_12")
            structure_hash["fields"]["science_predicted_validity_13"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_13"               } if field_order.push("science_predicted_validity_13")
            structure_hash["fields"]["science_predicted_validity_14"]               = {"data_type"=>"int",  "file_field"=>"Science_Predicted_Validity_14"               } if field_order.push("science_predicted_validity_14")
            structure_hash["fields"]["language_arts_predicted_scaledscore"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_ScaledScore"         } if field_order.push("language_arts_predicted_scaledscore")
            structure_hash["fields"]["language_arts_error_of_prediction"]           = {"data_type"=>"int",  "file_field"=>"Language_Arts_Error_of_Prediction"           } if field_order.push("language_arts_error_of_prediction")
            structure_hash["fields"]["language_arts_prediction_name_short"]         = {"data_type"=>"text", "file_field"=>"Language_Arts_Prediction_Name_Short"         } if field_order.push("language_arts_prediction_name_short")
            structure_hash["fields"]["language_arts_predicted_name_long"]           = {"data_type"=>"text", "file_field"=>"Language_Arts_Predicted_Name_Long"           } if field_order.push("language_arts_predicted_name_long")
            structure_hash["fields"]["language_arts_predicted_validity_0"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_0"          } if field_order.push("language_arts_predicted_validity_0")
            structure_hash["fields"]["language_arts_predicted_validity_1"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_1"          } if field_order.push("language_arts_predicted_validity_1")
            structure_hash["fields"]["language_arts_predicted_validity_2"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_2"          } if field_order.push("language_arts_predicted_validity_2")
            structure_hash["fields"]["language_arts_predicted_validity_3"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_3"          } if field_order.push("language_arts_predicted_validity_3")
            structure_hash["fields"]["language_arts_predicted_validity_4"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_4"          } if field_order.push("language_arts_predicted_validity_4")
            structure_hash["fields"]["language_arts_predicted_validity_5"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_5"          } if field_order.push("language_arts_predicted_validity_5")
            structure_hash["fields"]["language_arts_predicted_validity_6"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_6"          } if field_order.push("language_arts_predicted_validity_6")
            structure_hash["fields"]["language_arts_predicted_validity_7"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_7"          } if field_order.push("language_arts_predicted_validity_7")
            structure_hash["fields"]["language_arts_predicted_validity_8"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_8"          } if field_order.push("language_arts_predicted_validity_8")
            structure_hash["fields"]["language_arts_predicted_validity_9"]          = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_9"          } if field_order.push("language_arts_predicted_validity_9")
            structure_hash["fields"]["language_arts_predicted_validity_10"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_10"         } if field_order.push("language_arts_predicted_validity_10")
            structure_hash["fields"]["language_arts_predicted_validity_11"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_11"         } if field_order.push("language_arts_predicted_validity_11")
            structure_hash["fields"]["language_arts_predicted_validity_12"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_12"         } if field_order.push("language_arts_predicted_validity_12")
            structure_hash["fields"]["language_arts_predicted_validity_13"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_13"         } if field_order.push("language_arts_predicted_validity_13")
            structure_hash["fields"]["language_arts_predicted_validity_14"]         = {"data_type"=>"int",  "file_field"=>"Language_Arts_Predicted_Validity_14"         } if field_order.push("language_arts_predicted_validity_14")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end