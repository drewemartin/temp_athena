#!/usr/local/bin/ruby


class STUDENT_TESTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "STUDENT_TESTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
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
        row.push( record.fields["test_event_id"        ].web.select(:dd_choices=>test_events_dd) )  
        
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
            row.push(test.fields["serial_number"        ].web.text() )        
            row.push(test.fields["completed"            ].web.default() )            
            row.push(test.fields["test_administrator"   ].web.select({:dd_choices=>test_admin_dd}) )   if test_admin_dd #ELSE NO STAFF ASSIGNED
            row.push(test.fields["test_results"         ].web.default() ) 
            row.push(test.fields["assigned"             ].web.default() )            
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
        headers.push("Test Subject")
        headers.push("Check In Date")
        headers.push("Serial Number")
        headers.push("Completed Date")
        headers.push("Test Administrator")
        headers.push("Test Results")
        
        #if section_name.match(/aims|k-6 face to face assessment/i)
        #    headers.push("AIMS")
        #end
        #if section_name == "aims"
        #    headers.push("AIMS")
        #end
        
        headers.push("Assigned")
        headers.push("Test Event Site")
        headers.push("Drop Off Info")
        headers.push("Pick Up Info")
        
        tables_array.push(headers)
        
        records.each{|test|
            
            row = Array.new
            
            row.push(test.fields["test_id"              ].web.select(:dd_choices=>test_types_dd,  :disabled=>true) )  
            row.push(test.fields["test_event_id"        ].web.select(:dd_choices=>test_events_dd, :disabled=>true) )  
            row.push(test.fields["test_subject_id"      ].web.select(:dd_choices=>test_subjects_dd(test.fields["test_id"].value)) )          
            row.push(test.fields["checked_in"           ].web.default() )
            row.push(test.fields["serial_number"        ].web.text() )        
            row.push(test.fields["completed"            ].web.default() )            
            row.push(test.fields["test_administrator"   ].web.select({:dd_choices=>test_admin_dd}) )   if test_admin_dd #ELSE NO STAFF ASSIGNED
            #row.push(test.fields["test_results"         ].web.default() )
            
            if section_name.match(/aims|k-6 face to face assessment/i)
            #if section_name == "aims"
                row.push(aims_scores(test.primary_id))
            else
                row.push(test.fields["test_results"         ].web.default() )
                #if test.fields["test_id"].value == $tables.attach("tests").find_field("primary_id", "WHERE name='AIMS'").value
                #    row.push(aims_scores(test.primary_id))
                #elsif test.fields["test_id"].value == $tables.attach("tests").find_field("primary_id", "WHERE name='K-6 Face To Face Assessment'").value
                #    row.push(aims_scores(test.primary_id))
                #elsif test.fields["test_id"].value == $tables.attach("tests").find_field("primary_id", "WHERE name='May K-6 Face To Face Assessment'").value
                #    row.push(aims_scores(test.primary_id))
                #else row.push("")
                #end
            end
            
            row.push(test.fields["assigned"             ].web.default() )            
            row.push(test.fields["test_event_site_id"   ].web.select({:dd_choices=>$dd.test_events.event_sites(test.fields["test_event_id"].value)}, true) )  
            row.push(test.fields["drop_off"             ].web.default() )             
            row.push(test.fields["pick_up"              ].web.default() )
            
            tables_array.push(row)
            
        } if records
        
        return $tools.data_table(tables_array, section_name, "default", true)
        
    end
    
    def aims_scores(test_id)
        
        grade = $focus_student.grade.value
        
        tables_array = [
            
            #if  grade == "Kindergarten" || grade == "1st Grade" || grade == "2nd Grade"# || grade == "10th Grade"
                
                #HEADERS
                [
                    "LNF",
                    "LNF Errors",
                    "LSF",
                    "LSF Errors",
                    "PSF",
                    "PSF Errors",
                    "NWF",
                    "NWF Errors",
                    "R-CBM",
                    "R-CBM Errors",
                    "OCM",
                    "OCM Errors",
                    "NIM",
                    "NIM Errors",
                    "QDM",
                    "QDM Errors",
                    "MNM",
                    "MNM Errors",
                    "M-CAP",
                    "M-CAP Read to Student",
                    "Requirement for AIMS Benchmark"
                ]
                
            #else#if grade == "3rd Grade" || grade == "4th Grade" || grade == "5th Grade" || grade == "6th Grade"# || grade == "10th Grade"
                
                #HEADERS
                #[
                    #"Requirement for AIMS Benchmark",
                    #"R-CBM",
                    #"R-CBM Errors",
                    #"M-CAP",
                    #"M-CAP Read to Student"
                #]
                
            #else
                
                #HEADERS
                #[
                #    ""
                #]
                
            #end
        ]
        
        
        if test = $focus_student.aims_tests.existing_records("WHERE test_id = '#{test_id}' ORDER BY created_date DESC")
            test = test[0]
        else
            test = $focus_student.aims_tests.new_record
            test.fields["test_id"].value = test_id
            test.save
        end
        
        #tests.each{|test|
            
            row = Array.new
            
            #if grade == "Kindergarten" || grade == "1st Grade" || grade == "2nd Grade"# || grade == "10th Grade"
                
                row.push(test.fields["lnf"                              ].web.default() )
                row.push(test.fields["lnf_errors"                       ].web.default() )
                row.push(test.fields["lsf"                              ].web.default() )
                row.push(test.fields["lsf_errors"                       ].web.default() )
                row.push(test.fields["psf"                              ].web.default() )
                row.push(test.fields["psf_errors"                       ].web.default() )
                row.push(test.fields["nwf"                              ].web.default() )
                row.push(test.fields["nwf_errors"                       ].web.default() )
                row.push(test.fields["rcbm"                             ].web.default() )
                row.push(test.fields["rcbm_errors"                      ].web.default() )
                row.push(test.fields["ocm"                              ].web.default() )
                row.push(test.fields["ocm_errors"                       ].web.default() )
                row.push(test.fields["nim"                              ].web.default() )
                row.push(test.fields["nim_errors"                       ].web.default() )
                row.push(test.fields["qdm"                              ].web.default() )
                row.push(test.fields["qdm_errors"                       ].web.default() )
                row.push(test.fields["mnm"                              ].web.default() )
                row.push(test.fields["mnm_errors"                       ].web.default() )
                row.push(test.fields["mcap"                             ].web.default() )
                row.push(test.fields["mcap_read_to_student"             ].web.default() )
                row.push(test.fields["requirement_for_aims_benchmark"   ].web.default() )
                
            #else#if grade == "3rd Grade" || grade == "4th Grade" || grade == "5th Grade" || grade == "6th Grade"# || grade == "10th Grade"
                
                #row.push(test.fields["requirement_for_aims_benchmark"   ].web.default() )
                #row.push(test.fields["rcbm"                             ].web.default() )
                #row.push(test.fields["rcbm_errors"                      ].web.default() )
                #row.push(test.fields["mcap"                             ].web.default() )
                #row.push(test.fields["mcap_read_to_student"             ].web.default() )
                
            #end
            
            tables_array.push(row)
            
        #} if tests
        
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