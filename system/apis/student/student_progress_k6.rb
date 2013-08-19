#!/usr/local/bin/ruby

class Student_Progress_K6

    #---------------------------------------------------------------------------
    def initialize(student_object)
        @structure   = nil
        self.student = student_object
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def absences_excused(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term)
            params = {
                "type"  =>  "int",
                "field" =>  "absences_excused",
                "value" =>  student.attendance.exists? ? student.attendance.excused_absences.length : nil
            }
            return $field.new(params)
        elsif term_closed?(this_term)
            return k6_progress.field_bystudentid("absences_excused", student_id, this_term)
        else
            return false
        end
    end

    def absences_unexcused(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term)
            params = {
                "type"  =>  "int",
                "field" =>  "absences_unexcused",
                "value" =>  student.attendance.exists? ? student.attendance.unexcused_absences.length : nil
            }
            return $field.new(params)
        elsif term_closed?(this_term)
            return k6_progress.field_bystudentid("absences_unexcused", student_id, this_term)
        else
            return false
        end
    end
    
    def adequate_progress(this_term = nil)
        this_term = term if !this_term
        return k6_progress.field_bystudentid("adequate_progress", student_id, this_term)
    end
    
    def admin_verified?
        if (term_open? || term_closed?) && admin_verified.value == "1"
            return true
        end
        return false
    end 
    
    def assessment_completion(this_term = nil)
        this_term = term if !this_term
        return k6_progress.field_bystudentid("assessment_completion", student_id, this_term)
    end

    def comments(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term) || term_closed?(this_term)
            return k6_progress.field_bystudentid("comments", student_id, this_term)
        else
            return false
        end
    end
    
    def days_present(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term)
            params = {
                "type"  =>  "int",
                "field" =>  "days_present",
                "value" =>  student.attendance.exists? ? student.attendance.attended_days.length : nil
            }
            return $field.new(params)
        elsif term_closed?(this_term)
            return k6_progress.field_bystudentid("days_present", student_id, this_term)
        else
            return false
        end
    end

    def end_of_year_placement
        return k6_progress.field_bystudentid("end_of_year_placement", student_id, term)
    end

    def enroll_date
        if term_open?
            return student.school_enroll_date
        elsif term_closed?
            return k6_progress.field_bystudentid("enroll_date", student_id, term)
        else
            return false
        end
    end
    
    def first_name
        if term_open?
            return student.first_name
        elsif term_closed?
            return k6_progress.field_bystudentid("first_name", student_id, term)
        else
            return false
        end
    end
    
    def grade_level
        if term_open?
            return student.grade
        elsif term_closed?
            return k6_progress.field_bystudentid("grade_level", student_id, term)
        else
            return false
        end
    end

    def last_name
        if term_open?
            return student.last_name
        elsif term_closed?
            return k6_progress.field_bystudentid("last_name", student_id, term)
        else
            return false
        end
    end

    def masteries
        if term_closed?
            return $tables.attach("K6_PROGRESS_MASTERY_SNAPSHOT").by_studentid_old(student_id, term)
        else
            return $tables.attach("K6_Progress_Mastery").by_studentid_old(student_id)
        end
        
    end
    
    #def masteries_snapshot
    #    if term_closed?
    #        return $tables.attach("K6_PROGRESS_MASTERY_SNAPSHOT").by_studentid_old(student_id, term)
    #    else
    #        return false
    #    end
    #end
    
    def math_goals(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term) || term_closed?(this_term)
            return k6_progress.field_bystudentid("math_goals", student_id, this_term)
        else
            return false
        end
    end
    
    def progress(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term)
            return $tables.attach("Student_Academic_Progress").by_studentid_old(student_id)
        elsif term_closed?(this_term)
            return $tables.attach("K6_Progress_Courses").by_studentid_old(student_id, this_term)
        else
            return false
        end
    end
    
    def progress_record #this doesn't appear to be being called
        $tables.attach("K6_Progress").by_studentid_old(student_id, term)
    end
    
    def reading_goals(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term) || term_closed?(this_term)
            return k6_progress.field_bystudentid("reading_goals", student_id, this_term)
        else
            return false
        end
    end

    def reported_datetime
        if term_open? || term_closed?
            return k6_progress.field_bystudentid("reported_datetime", student_id, term)
        else
            return false
        end
    end

    def school_year
        if term_open?
            return $school.current_school_year
        elsif term_closed?
            return k6_progress.field_bystudentid("school_year", student_id, term)
        else
            return false
        end
    end

    def student_id
        student.student_id
    end

    def teacher
        if term_open?
            return student.title_one_teacher
        elsif term_closed?
            return k6_progress.field_bystudentid("teacher", student_id, term)
        else
            return false
        end
    end
    
    def term
        structure[:term]
    end
    
    def admin_verified
        if term_open? || term_closed?
            return k6_progress.field_bystudentid("admin_verified", student_id, term)
        else
            return false
        end
    end
    
    def teacher_verified
        if term_open? || term_closed?
            return k6_progress.field_bystudentid("teacher_verified", student_id, term)
        else
            return false
        end
    end
    
    def work_submission(this_term = nil)
        this_term = term if !this_term
        if term_open?(this_term) || term_closed?(this_term)
            return k6_progress.field_bystudentid("work_submission", student_id, this_term)
        else
            return false
        end
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def progress_snapshot
        
        #Check to make sure the quarter is not closed before running this(programatically)
        #for first quarter delete attendance days after X 
        record = $tables.attach("K6_Progress").by_studentid_old(student_id,term)
        if record
            record.fields["term"        ].value = term
            record.fields["school_year" ].value = $school.current_school_year
            
            record.fields.each_pair{|field_name, details|
                if respond_to?(field_name)
                    if field_name == "student_id" || field_name == "term"
                        details.value = send(field_name)
                    else
                        details.value = send(field_name).value
                    end
                end
            }
            record.save
        end
        #progress
        if x=progress
            blank_record = $tables.attach("K6_Progress_Courses").new_row
            x.each{|r|
                blank_record.clear            
                blank_record.fields["student_id"             ].value =    r.fields["student_id"             ].value                        
                blank_record.fields["classroom_name"         ].value =    r.fields["classroom_name"         ].value                
                blank_record.fields["course_code"            ].value =    r.fields["course_code"            ].value                      
                blank_record.fields["course_name"            ].value =    r.fields["course_name"            ].value                      
                blank_record.fields["course_subject_k12"     ].value =    r.fields["course_subject_k12"     ].value       
                blank_record.fields["course_subject_school"  ].value =    r.fields["course_subject_school"  ].value     
                blank_record.fields["start_date"             ].value =    r.fields["start_date"             ].value                           
                blank_record.fields["progress"               ].value =    r.fields["progress"               ].value                           
                blank_record.fields["teacher_name"           ].value =    r.fields["teacher_name"           ].value                 
                blank_record.fields["teacher_staff_id"       ].value =    r.fields["teacher_staff_id"       ].value         
                blank_record.fields["class_risk_level"       ].value =    r.fields["class_risk_level"       ].value         
                blank_record.fields["class_risk_level_recent"].value =    r.fields["class_risk_level_recent"].value 
                blank_record.fields["engagement_level"       ].value =    r.fields["engagement_level"       ].value         
                blank_record.fields["data_source"            ].value =    r.fields["data_source"            ].value                   
                blank_record.fields["term"                   ].value =    r.fields["term"                   ].value
                blank_record.fields["school_year"            ].value =    r.fields["school_year"            ].value 
                blank_record.save                                                   
            } 
        end                                                                        
    end
    
    def masteries_snapshot
        
        records = $tables.attach("K6_Progress_Mastery").by_studentid_old(student_id)
        if records
            records.each{|record|
                snapshot = $tables.attach("K6_PROGRESS_MASTERY_SNAPSHOT").new_row
                snapshot.fields["student_id"    ].value = record.fields["student_id"      ].value   
                snapshot.fields["school_year"   ].value = record.fields["school_year"     ].value  
                snapshot.fields["term"          ].value = term        
                snapshot.fields["mastery_id"    ].value = record.fields["mastery_id"      ].value   
                snapshot.fields["mastery_level" ].value = record.fields["mastery_level"   ].value
                snapshot.save
            }
        end
    end 

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #This entire funtion needs to be reworked before next run!!! FNORD!
    def generate_report(school_year=$config.school_year.value, reprint = false)
        reprints = reprint ? "/WITH_INTACT_TAGS" : ""
        puts "ENTERED 'generate_report'"
        session_school_year=(school_year)
        puts "1"
        student_first_name  = first_name.value
        puts "2"
        student_last_name   = self.last_name.value
        puts "3"
        file_path           = $config.init_path("#{$paths.reports_path}Progress_Reports/School_Year_#{session_school_year}/#{term}_K6_Students#{reprints}")
        puts "4"
        word_doc_path       = "#{file_path}STUDENT_#{student_id}.docx"
        puts "5"
        pdf_doc_path        = "#{file_path}#{term}_#{student_last_name}_#{student_first_name}_#{student_id}.pdf"
        puts "6"
        if File.exists?(pdf_doc_path)
            puts "REPORT PREVIOUSLY GENERATED"
            record = progress_record
            record.fields["reported_datetime"].value = $idatetime
            record.save
            return pdf_doc_path
        else
            puts "#{student.student_id} #{DateTime.now.strftime("%H:%M")}"
            teacher     = self.teacher.value
            #each of these need to be set up to handle different school years
            puts "GETTING PROGRESS DETAILS"
            replace = Hash.new
            replace["[grade_level]"             ] = grade_level.value 
            replace["[school_year]"             ] = session_school_year
            replace["[first_name]"              ] = student_first_name
            replace["[last_name]"               ] = student_last_name
            replace["[student_id]"              ] = student.student_id
            replace["[today]"                   ] = $iuser
            replace["[school_enroll_date]"      ] = student.school_enroll_date.value
            replace["[teacher]"                 ] = teacher
            replace["[a_p_1]"                   ] = days_present("Q1"           ) || ""
            replace["[a_p_2]"                   ] = days_present("Q2"           ) || ""
            replace["[a_p_3]"                   ] = days_present("Q3"           ) || ""
            replace["[a_p_4]"                   ] = days_present("Q4"           ) || ""
            replace["[a_e_1]"                   ] = absences_excused("Q1"       ) || ""
            replace["[a_e_2]"                   ] = absences_excused("Q2"       ) || ""
            replace["[a_e_3]"                   ] = absences_excused("Q3"       ) || ""
            replace["[a_e_4]"                   ] = absences_excused("Q4"       ) || ""
            replace["[a_u_1]"                   ] = absences_unexcused("Q1"     ) || ""
            replace["[a_u_2]"                   ] = absences_unexcused("Q2"     ) || ""
            replace["[a_u_3]"                   ] = absences_unexcused("Q3"     ) || ""
            replace["[a_u_4]"                   ] = absences_unexcused("Q4"     ) || ""
            replace["[math_goals_1]"            ] = math_goals("Q1"             ) || ""
            replace["[math_goals_2]"            ] = math_goals("Q2"             ) || ""
            replace["[math_goals_3]"            ] = math_goals("Q3"             ) || ""
            replace["[math_goals_4]"            ] = math_goals("Q4"             ) || ""
            replace["[reading_goals_1]"         ] = reading_goals("Q1"          ) || ""
            replace["[reading_goals_2]"         ] = reading_goals("Q2"          ) || ""
            replace["[reading_goals_3]"         ] = reading_goals("Q3"          ) || ""
            replace["[adequate_1]"              ] = adequate_progress("Q1"      ) || ""
            replace["[adequate_2]"              ] = adequate_progress("Q2"      ) || ""
            replace["[adequate_3]"              ] = adequate_progress("Q3"      ) || ""
            replace["[adequate_4]"              ] = adequate_progress("Q4"      ) || ""
            replace["[assessment_1]"            ] = assessment_completion("Q1"  ) || ""
            replace["[assessment_2]"            ] = assessment_completion("Q2"  ) || ""
            replace["[assessment_3]"            ] = assessment_completion("Q3"  ) || ""
            replace["[assessment_4]"            ] = assessment_completion("Q4"  ) || ""
            replace["[submission_1]"            ] = work_submission("Q1"        ) || ""
            replace["[submission_2]"            ] = work_submission("Q2"        ) || ""
            replace["[submission_3]"            ] = work_submission("Q3"        ) || ""
            replace["[submission_4]"            ] = work_submission("Q4"        ) || ""
            replace["[comments]"                ] = comments                      || ""
            
            puts "GETTING COURSE PROGRESS"
            #progress###############################################################
            p_h = Hash.new
            terms = ["Q1","Q2","Q3","Q4"]
            i_terms     = 0
            terms.each{|term|
                progress = progress(term)
                if progress
                    progress.each{|p|
                        #if term_active?(term) && !p.fields["course_subject_school"].value.nil?
                            subject             = p.fields["course_subject_school" ].value
                            p_h[subject]        = {"Q1"=>nil,"Q2"=>nil,"Q3"=>nil,"Q4"=>nil} if !p_h.has_key?(subject)
                            p_h[subject][term]  = p.fields["progress"].to_user
                        #end
                    }
                end
                i_terms+=1
            }
            i=1
            p_h.each_pair{|subject,progress|
                replace["[p#{i}]"] = subject
                terms.each{|term|
                    replace["[p#{i}_#{term}]"] = progress[term]
                }
                i+=1
            }
            i = 1
            while i <= 10
                replace["[p#{i}]"] = " " if !replace.has_key?("[p#{i}]")
                terms.each{|term|
                    replace["[p#{i}_#{term}]"] = " " if !replace.has_key?("[p#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #masteries##############################################################
            m_hash = {
                "Reading"               => "rm",
                "Mathematics"           => "mm",
                "Writing"               => "wm",
                "History"               => "hm",
                "Science"               => "sm",
                "Physical Education"    => "pm"   
            }
           # mastery_records = masteries_snapshot
            ########################################################################
            
            #reading masteries######################################################
            rm_h    = Hash.new
            terms   = ["Q2","Q4"]
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "Reading"
                                desc             = mastery_section.fields["description" ].value
                                rm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !rm_h.has_key?(desc)
                                rm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            
            i=1
            rm_h.each_pair{|k,v|
                replace["[rm#{i}_d]"] = k
                terms.each{|term|
                    replace["[rm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 15
                replace["[rm#{i}_d]"] = " " if !replace.has_key?("[rm#{i}_d]")
                terms.each{|term|
                    replace["[rm#{i}_#{term}]"] = " " if !replace.has_key?("[rm#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #mathematics masteries######################################################
            mm_h    = Hash.new
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "Mathematics"
                                desc             = mastery_section.fields["description" ].value
                                mm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !mm_h.has_key?(desc)
                                mm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            i=1
            mm_h.each_pair{|k,v|
                replace["[mm#{i}_d]"] = k
                terms.each{|term|
                    replace["[mm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 20
                replace["[mm#{i}_d]"] = " " if !replace.has_key?("[mm#{i}_d]")
                terms.each{|term|
                    replace["[mm#{i}_#{term}]"] = " " if !replace.has_key?("[mm#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #writing masteries######################################################
            wm_h    = Hash.new
            terms   = ["Q2","Q4"]
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "Writing"
                                desc             = mastery_section.fields["description" ].value
                                wm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !wm_h.has_key?(desc)
                                wm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            i=1
            wm_h.each_pair{|k,v|
                replace["[wm#{i}_d]"] = k
                terms.each{|term|
                    replace["[wm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 8
                replace["[wm#{i}_d]"] = " " if !replace.has_key?("[wm#{i}_d]")
                terms.each{|term|
                    replace["[wm#{i}_#{term}]"] = " " if !replace.has_key?("[wm#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #history masteries######################################################
            hm_h    = Hash.new
            terms   = ["Q2","Q4"]
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "History"
                                desc             = mastery_section.fields["description" ].value
                                hm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !hm_h.has_key?(desc)
                                hm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            i=1
            hm_h.each_pair{|k,v|
                replace["[hm#{i}_d]"] = k
                terms.each{|term|
                    replace["[hm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 5
                replace["[hm#{i}_d]"] = " " if !replace.has_key?("[hm#{i}_d]")
                terms.each{|term|
                    replace["[hm#{i}_#{term}]"] = " " if !replace.has_key?("[hm#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #science masteries######################################################
            sm_h    = Hash.new
            terms   = ["Q2","Q4"]
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "History"
                                desc             = mastery_section.fields["description" ].value
                                sm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !sm_h.has_key?(desc)
                                sm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            i=1
            sm_h.each_pair{|k,v|
                replace["[sm#{i}_d]"] = k
                terms.each{|term|
                    replace["[sm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 1
                replace["[sm#{i}_d]"] = " " if !replace.has_key?("[sm#{i}_d]")
                terms.each{|term|
                    replace["[sm#{i}_#{term}]"] = " " if !replace.has_key?("[sm#{i}_#{term}]")
                }
                i+=1
            end
            ########################################################################
            
            #PE masteries######################################################
            pm_h    = Hash.new
            terms   = ["Q2","Q4"]
            i_terms = 0
            placeholder_term = term
            terms.each{|this_term|
                term = this_term
                results = masteries
                if results
                    results.each{|r|
                        if term_open? #&& !r.fields["mastery_level"].value.nil?
                            mastery_id       = r.fields["mastery_id" ].value
                            mastery_section  = $tables.attach("K6_Mastery_Sections").by_primary_id(mastery_id)
                            content_area     = mastery_section.fields["content_area"].value
                            if content_area == "Physical Education"
                                desc             = mastery_section.fields["description" ].value
                                pm_h[desc]       = {"Q2"=>nil,"Q4"=>nil} if !pm_h.has_key?(desc)
                                pm_h[desc][term] = r.fields["mastery_level"].value
                            end
                        end
                    }
                end
                i_terms+=1
            }
            i=1
            pm_h.each_pair{|k,v|
                replace["[pm#{i}_d]"] = k
                terms.each{|term|
                    replace["[pm#{i}_#{term}]"] = v[term]
                }
                i+=1
            }
            i = 1
            while i <= 1
                replace["[pm#{i}_d]"] = " " if !replace.has_key?("[pm#{i}_d]")
                terms.each{|term|
                    replace["[pm#{i}_#{term}]"] = " " if !replace.has_key?("[pm#{i}_#{term}]")
                }
                i+=1
            end
            ##########################################################################
            grade_ = Integer(student.grade.value.split(" ")[0].split("th")[0].split("rd")[0].split("nd")[0])
            
            eoy = end_of_year_placement.value
            if eoy == "Promoted"
                replace["[end_of_year_placement]"] = "#{student.first_name.value} will be promoted to grade #{grade_ + 1} for the 2012-2013 school year."
            elsif eoy == "Retained"
                replace["[end_of_year_placement]"] = "#{student.first_name.value} will be retained in grade #{grade_} for the 2012-2013 school year."
            elsif eoy == "Placed"
                replace["[end_of_year_placement]"] = "#{student.first_name.value} will be placed in #{grade_ + 1} grade for the 2012-2013 school year."
            elsif eoy == "Promoted Pending Summer School"
                replace["[end_of_year_placement]"] = "If student attends Summer School at Agora and masters grade level standanrds, he/she will be promoted to the #{grade_ + 1} grade for the 2012-2013 school year."
            end
            
            term = placeholder_term
            puts "CREATING DOCUMENT"
            failed = 0
            document_created = false
            until document_created || failed == 3
                begin
                    puts "CONNECTING TO WORD"
                    word = $base.word
                    puts "OPENING WORD TEMPLATE"
                    doc  = word.Documents.Open("#{$paths.templates_path}student_progress_report_k6__with_masteries.docx")
                    puts "BEGINNING FIND AND REPLACE"
                    replace.each_pair{|f,r|
                        #footer
                        word.ActiveWindow.View.Type = 3
                        word.ActiveWindow.ActivePane.View.SeekView = 10
                        word.Selection.HomeKey(unit=6)
                        find = word.Selection.Find
                        find.Text = f
                        while word.Selection.Find.Execute
                            if r.nil? || r == ""
                                rvalue = " "
                            elsif r.class == Field
                                rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                            else
                                rvalue = r.to_s
                            end
                            word.Selection.TypeText(text=rvalue.gsub("’","'"))
                        end
                        
                        #main body
                        word.ActiveWindow.ActivePane.View.SeekView = 0
                        word.Selection.HomeKey(unit=6)
                        find = word.Selection.Find
                        find.Text = f
                        while word.Selection.Find.Execute
                            if r.nil? || r == ""
                                rvalue = " "
                            elsif r.class == Field
                                rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                            else
                                rvalue = r.to_s
                            end
                            word.Selection.TypeText(text=rvalue.gsub("’","'"))
                        end
                    }
                    puts "SAVING WORD DOC"
                    doc.SaveAs(word_doc_path.gsub("/","\\"))
                    puts "CONVERTING TO PDF"
                    doc.SaveAs(pdf_doc_path.gsub("/","\\"),17)
                    doc.close
                    document_created = true
                    word.quit
                    puts "REMOVING WORD DOC"
                    FileUtils.rm(word_doc_path) if File.exists?(word_doc_path)
                    puts "WORD DOC REMOVED"
                    
                    record = progress_record
                    record.fields["reported_datetime"].value = $idatetime
                    record.save
                rescue => e
                    puts e
                    failed+=1
                    puts "Failed Attempt #{failed}."
                    $base.system_notification(
                        subject = "K6 Progress Report Failed - SID: #{student_id}",
                        content = "#{__FILE__} #{__LINE__}",
                        caller[0],
                        e
                    ) if failed == 3
                end
            end
            
            
            #MARK AS REPORTED - FNORD
            
            puts "RETURNING PDF PATH"
            return pdf_doc_path
        end
    end
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def term=(arg)
        structure[:term] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def term_closed?(this_term = nil)
        this_term = term if !this_term
        answer = false
        results = $tables.attach("Progress_Report_Schedule").by_term(this_term)
        if results
            after_close  = $instance_DateTime > results.fields["closed_datetime"].mathable
            answer = true if after_close
        end
        return answer
    end
    
    def term_open?(this_term = nil)
        this_term = term if !this_term
        answer = false
        results = $tables.attach("Progress_Report_Schedule").by_term(this_term)
        if results
            after_open    = $instance_DateTime > results.fields["opened_datetime"].mathable
            before_close  = $instance_DateTime < results.fields["closed_datetime"].mathable
            answer = true if (after_open && before_close)
        end
        return answer
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def k6_progress
        if !structure.has_key?("k6_progress")
            structure["k6_progress"] = $tables.attach("K6_Progress")
        end
        structure["k6_progress"]
    end
    
    def student
        structure["student"]
    end
    
    def student=(arg)
        structure["student"] = arg
    end
    
    def term_active?
        return structure["term_active_#{term}"] = false if term == "Q1" || term == "Q2"
        if !structure.has_key?("term_active_#{term}")
            results = $tables.attach("Progress_Report_Schedule").by_term(term, $config.school_year.value)
            if results && results.fields["opened_datetime"].value && !results.fields["closed_datetime"].value
                structure["term_active_#{term}"] = true
            else
                structure["term_active_#{term}"] = false
            end
        end
        structure["term_active_#{term}"]
    end
    
end