#!/usr/local/bin/ruby


class STUDENT_TESTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = ""
        
        if $tables.attach("test_events").primary_ids
            new_contact_button = $tools.button_new_row(
                table_name              = "STUDENT_TESTS",
                additional_params_str   = "sid",
                save_params             = "sid"
            )
        end
        
        "Test Administration#{new_contact_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        
        if !$kit.rows.empty? && field = $kit.rows.first[1].fields["serial_number"]
            if !field.updated
                student_id = $tables.attach("TEST_PACKETS").field_value("student_id", "WHERE serial_number = '#{field.value}'")
                $kit.web_error.duplicate_assignment_error(
                    additional_message="This test packet is already assigned to the student with ID# #{student_id}. You must unassign this packet first."
                )
            end
        end
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record()
        
        tabs = Array.new
        
        if $focus_student.tests.existing_records
            
            tests = $tables.attach("tests").primary_ids
            grade = $focus_student.grade.value
            
            tests.each{|test|
                
                records     = $focus_student.tests.existing_records("WHERE test_id = '#{test}'")
                test_name   = $tables.attach("tests").by_primary_id(test).fields["name"].value
                
                tabs.push(["#{test_name} (#{(records ? records.length : 0)})", test_details(records, test_name.downcase)])
                
            } if tests
            
            return $kit.tools.tabs(
                
                tabs,
                selected_tab    = 0,
                tab_id          = "tests",
                search          = false
                
            )
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_student_tests()
        
        tables_array = [
            
            #HEADERS
            [
                "StudentID",   
                "Test Event"                
            ]
            
        ]
        
        row = Array.new
        
        record = $focus_student.tests.new_record
        
        row.push( record.fields["student_id"           ].web.label() + record.fields["student_id"].web.hidden()) 
        row.push( record.fields["test_event_id"        ].web.select(:dd_choices=>test_events_dd, :validate => true) )  
        
        tables_array.push(row)
      
        return $kit.tools.data_table(tables_array, "new_test", type = "NewRecord")
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def expand_students
        
        if sids = $user.students(:currently_enrolled=>true)
            extra_fields = [
                #{:title1teacher          =>"Teacher"     },
                #{:freeandreducedmeals    =>"Low Income"  }
            ]
            tables_array = $students.data_table(sids, extra_fields)
            return $kit.tools.data_table(tables_array, "students")
            
        end
        
    end
    
    def expand_tests(sid)
        
        tables_array = [
            
            #HEADERS
            [          
                "Test Subject",         
                "Test Type",
                "Check In Date",
                "Serial Number",        
                "Completed Date",            
                "Test Administrator",
                "Test Results",
                "Assigned",
                "Code on Site",
                "Test Event Site",   
                "Drop Off Info",             
                "Pick Up Info"                
            ]
            
        ]
        
        tests = $students.get(sid).tests.existing_records
        tests.each{|test|
            row = Array.new
            
            #site_id     = test.fields["test_event_site_id"   ].value
            #site_name   = $tables.attach("test_event_sites").field_by_pid("site_name", site_id).value
            #test.fields["test_event_site_id"   ].value = site_name
            
            event_site_id = test.fields["test_event_site_id"   ].value
            
            row.push(test.fields["test_subject"         ].web.label() )         
            row.push(test.fields["test_type"            ].web.label() )
            row.push(test.fields["checked_in"           ].web.default() )
            row.push(test.fields["serial_number"        ].web.select(:dd_choices=>$dd.test_events.test_packet_serial_numbers(:test_event_id=>test.fields["test_event_id"   ].value,:grade=>$focus_student.grade.value,:subject=>test.fields["test_subject_id"].value)) )                                                              if !section_name.match(/aims/)
            row.push(test.fields["completed"            ].web.default() )            
            row.push(test.fields["test_administrator"   ].web.select({:dd_choices=>test_admin_dd}) )   if test_admin_dd #ELSE NO STAFF ASSIGNED
            row.push(test.fields["test_results"         ].web.default() ) 
            row.push(test.fields["assigned"             ].web.default() )
            row.push(test.fields["code_on_site"         ].web.default() )
            row.push(test.fields["test_event_site_id"   ].web.select({:dd_choices=>event_sites_dd}, true) )  
            row.push(test.fields["drop_off"             ].web.default() )             
            row.push(test.fields["pick_up"              ].web.default() )
            
            tables_array.push(row)
        }
      
        return $kit.tools.data_table(tables_array, "tests")            
     
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def test_events_dd
        
        $tables.attach("TEST_EVENTS").dd_choices("name", "primary_id")
        
    end
    
    def test_subjects_dd(test_id)
        
        $tables.attach("TEST_SUBJECTS").dd_choices("name", "primary_id", "WHERE test_id = '#{test_id}'")
        
    end
    
    def test_admin_dd
        if $tables.attach("K12_STAFF").primary_ids(" GROUP BY CONCAT(firstname,' ',lastname) ORDER BY position DESC ")
            
            return $tables.attach("K12_STAFF").dd_choices(
                "CONCAT(firstname,' ',lastname)",
                "samspersonid",
                " GROUP BY CONCAT(firstname,' ',lastname) ORDER BY CONCAT(firstname,' ',lastname) ASC "
            )
            
        else
            return false
        end
    end
    
    def test_types_dd
        
        $tables.attach("TESTS").dd_choices("name", "primary_id")
        
    end
    
    def reading_comp_read_dd
        return [
            {:name=>"Student Read",       :value=>"Student Read"        },
            {:name=>"Teacher Read",       :value=>"Teacher Read"        }
        ]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def test_details(records, section_name)
        
        tables_array        = Array.new
        headers             = Array.new
        
        test_record = nil
        if records
            
            test_id     = records[0].fields["test_id" ].value
            test_record = $tables.attach("tests").by_primary_id(test_id)
            
        end
        
        headers.push("Test Type")
        headers.push("Test Event")
        headers.push("Test Subject")   if !section_name.match(/aims/)
        #headers.push("Check In Date")  if !section_name.match(/aims/)
        headers.push("Serial Number")  if !section_name.match(/aims/)
        headers.push("Completed Date")
        headers.push("Test Administrator") if test_admin_dd
        headers.push("Test Event Site")
        headers.push("Test Results")
        headers.push("Code On Site")   if !section_name.match(/aims/)
        headers.push("Assigned")       if !section_name.match(/aims/)
        headers.push("Drop Off Info")  if !section_name.match(/aims/)
        headers.push("Pick Up Info")   if !section_name.match(/aims/)
        
        tables_array.push(headers)
        
        records.each{|test|
            
            row = Array.new
            
            row.push(test.fields["test_id"              ].web.select(:dd_choices=>test_types_dd,  :disabled=>true) )  
            row.push(test.fields["test_event_id"        ].web.select(:dd_choices=>test_events_dd, :disabled=>true) )  
            row.push(test.fields["test_subject_id"      ].web.select(:dd_choices=>test_subjects_dd(test.fields["test_id"].value)) ) if !section_name.match(/aims/)    
            #row.push(test.fields["checked_in"           ].web.default() )                                                           if !section_name.match(/aims/)
            row.push(
                test.fields["serial_number"        ].web.select(
                    :dd_choices=>$dd.test_events.test_packet_serial_numbers(
                        :test_event_id  => test.fields["test_event_id"      ].value,
                        :grade          => $focus_student.grade.value,
                        :subject        => test.fields["test_subject_id"    ].value
                    )
                )
            )                                                              if !section_name.match(/aims/)
            row.push(test.fields["completed"            ].web.default() )            
            row.push(test.fields["test_administrator"   ].web.select({:dd_choices=>test_admin_dd}) )   if test_admin_dd #ELSE NO STAFF ASSIGNED
            row.push(test.fields["test_event_site_id"   ].web.select({:dd_choices=>$dd.test_events.event_sites(test.fields["test_event_id"].value)}, true) )  
            
            if section_name.match(/aims|k-6 face to face assessment/i)
                row.push(aims_scores(test.primary_id))
            else
                row.push(test.fields["test_results"     ].web.default() )
            end
            row.push(test.fields["code_on_site"         ].web.default() ) if !section_name.match(/aims/)
            row.push(test.fields["assigned"             ].web.default() ) if !section_name.match(/aims/)
            row.push(test.fields["drop_off"             ].web.default() ) if !section_name.match(/aims/)          
            row.push(test.fields["pick_up"              ].web.default() ) if !section_name.match(/aims/)
            
            tables_array.push(row)
            
        } if records
        
        return $tools.data_table(tables_array, section_name, "default", true)
        
    end
    
    def aims_scores(test_id)
        
        grade = $focus_student.grade.value
        
        tables_array = [
            
            [
                "K-2 Skill Check Completed",
                "Writing Sample Received",
                "3rd - 5th Math Open-Ended Prompt Completed",
                "CORE Phonics- Letter Names Upper Case (_/26)",
                "CORE Phonics- Letter Names Lower Case (_/26)",
                "CORE Phonics- Consonant Sounds (_/23)",
                "CORE Phonics- Long Vowel Sounds (_/5)",
                "CORE Phonics- Short Vowel Sounds (_/5)",
                "CORE PHONICS- Short Vowels in CVC Words (_/10)",
                "CORE PHONICS- Short Vowels, Digraphs, and -tch trigraph (_/10)",
                "CORE PHONICS- Consonant Blends with Short Vowels (_/20)",
                "CORE PHONICS- Long Vowel Spelling (_/10)",
                "CORE PHONICS- R- and L- Controlled Words (_/10)",
                "CORE PHONICS- Variant Vowels and Dipthongs (_/10)",
                "CORE PHONICS- Multisyllabic Words (_/24)",
                "CORE-PHONICS- Spelling A First Sounds (_/5)",
                "CORE-PHONICS- Spelling B Last Sounds (_/5)",
                "CORE-PHONICS- Spelling C Whole Words (_/10)",
                "Reading Comprehension (correct/total)",
                "Reading Comprehension (Student Read or Teacher Read)",
                "LNF (integer only)",
                "LNF Errors (integer only)",
                "LSF (integer only)",
                "LSF Errors (integer only)",
                "PSF (integer only)",
                "PSF Errors (integer only)",
                "NWF (integer only)",
                "NWF Errors (integer only)",
                "R-CBM (integer only)",
                "R-CBM Errors (integer only)",
                "Reading Instructional Recommendation (K - 2)",
                "OCM (integer only)",
                "OCM Errors (integer only)",
                "NIM (integer only)",
                "NIM Errors (integer only)",
                "QDM (integer only)",
                "QDM Errors (integer only)",
                "MNM (integer only)",
                "MNM Errors (integer only)",
                "M-COMP (integer only)", #Still M-CAP field
                "Math Instructional Recommendation (K -2)",
                "Notes"
            ]
            
        ]
        
        
        if test = $focus_student.aims_tests.existing_records("WHERE test_id = '#{test_id}' ORDER BY created_date DESC")
            test = test[0]
        else
            test = $focus_student.aims_tests.new_record
            test.fields["test_id"].value = test_id
            test.save
        end
        
        row = Array.new
        
        row.push(test.fields["k2_skill_check_complete"                  ].web.default() )
        row.push(test.fields["writing_sample_received"                  ].web.default() )
        row.push(test.fields["35_math_open_prompt_complete"             ].web.default() )
        row.push(test.fields["core_phonics_letter_names_upper"          ].web.text() )
        row.push(test.fields["core_phonics_letter_names_lower"          ].web.text() )
        row.push(test.fields["core_phonics_consonant"                   ].web.text() )
        row.push(test.fields["core_phonics_long_vowel"                  ].web.text() )
        row.push(test.fields["core_phonics_short_vowel"                 ].web.text() )
        row.push(test.fields["core_phonics_short_vowel_cvc"             ].web.text() )
        row.push(test.fields["core_phonics_short_vowel_digraph"         ].web.text() )
        row.push(test.fields["core_phonics_consonant_blend"             ].web.text() )
        row.push(test.fields["core_phonics_long_vowel_spelling"         ].web.text() )
        row.push(test.fields["core_phonics_rl_control"                  ].web.text() )
        row.push(test.fields["core_phonics_variant_vowels"              ].web.text() )
        row.push(test.fields["core_phonics_multisyllabic"               ].web.text() )
        row.push(test.fields["core_phonics_spelling_a"                  ].web.text() )
        row.push(test.fields["core_phonics_spelling_b"                  ].web.text() )
        row.push(test.fields["core_phonics_spelling_c"                  ].web.text() )
        row.push(test.fields["reading_comprehension"                    ].web.text() )
        row.push(test.fields["reading_comprehension_who_read"           ].web.select(:dd_choices=>reading_comp_read_dd) )
        row.push(test.fields["lnf"                                      ].web.default(:add_class=>"limit_int") )
        row.push(test.fields["lnf_errors"                               ].web.default() )
        row.push(test.fields["lsf"                                      ].web.default() )
        row.push(test.fields["lsf_errors"                               ].web.default() )
        row.push(test.fields["psf"                                      ].web.default() )
        row.push(test.fields["psf_errors"                               ].web.default() )
        row.push(test.fields["nwf"                                      ].web.default() )
        row.push(test.fields["nwf_errors"                               ].web.default() )
        row.push(test.fields["rcbm"                                     ].web.default() )
        row.push(test.fields["rcbm_errors"                              ].web.default() )
        row.push(test.fields["reading_instructional_recommendation"     ].web.default() )
        row.push(test.fields["ocm"                                      ].web.default() )
        row.push(test.fields["ocm_errors"                               ].web.default() )
        row.push(test.fields["nim"                                      ].web.default() )
        row.push(test.fields["nim_errors"                               ].web.default() )
        row.push(test.fields["qdm"                                      ].web.default() )
        row.push(test.fields["qdm_errors"                               ].web.default() )
        row.push(test.fields["mnm"                                      ].web.default() )
        row.push(test.fields["mnm_errors"                               ].web.default() )
        row.push(test.fields["mcap"                                     ].web.default() )
        row.push(test.fields["math_instructional_recommendation"        ].web.default() )
        row.push(test.fields["notes"                                    ].web.default() )
            
        tables_array.push(row)
        
        return $kit.tools.table(
        :table_array    =>tables_array,
        :unique_name    => "aims_test",
        :footers        => false,
        :head_section   => false,
        :title          => false,
        :legend         => false,
        :caption        => false,
        :embedded_style => {
            :table  => "width:100%;",
            :th     => nil,
            :tr     => nil,
            :tr_alt => nil,
            :td     => nil
        }
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        output << "
            
            #new_row_button_STUDENT_TESTS                   { float:right; font-size: xx-small !important;}
            
            div.STUDENT_TESTS__completed               input{ width:90px;}
            div.STUDENT_TESTS__assigned                     { width:20px; margin-left:auto; margin-right:auto;}
            
            textarea                                        { resize:none;}
            
            
            div.STUDENT_AIMS_TESTS__lnf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lnf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lsf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__lsf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__psf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__psf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nwf             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nwf_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__ocm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__ocm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nim             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__nim_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__qdm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__qdm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mnm             input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mnm_errors      input{width: 50px;}
            div.STUDENT_AIMS_TESTS__rcbm            input{width: 50px;}
            div.STUDENT_AIMS_TESTS__rcbm_errors     input{width: 50px;}
            div.STUDENT_AIMS_TESTS__mcap            input{width: 50px;}
            
            div.STUDENT_AIMS_TESTS__requirement_for_aims_benchmark  {text-align: center;}
            div.STUDENT_AIMS_TESTS__mcap_read_to_student            {text-align: center;}
            
        "
        
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end