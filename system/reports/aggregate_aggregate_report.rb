#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Aggregate_Aggregate_Report < Base

    def initialize
        super()
        puts DateTime.now
        location    = "Course_Reports"
        filename    = "ols_student_courses"
        @rows        = Array.new
        
        #FILL ROWS WITH MEANINGFUL DATA
        set_rows
        
        #CREATE CSV FILE
        report_path = $reports.csv(location, filename, @rows)
        
        #SEND REPORT
        subject     = "OLS_STUDENT_COURSES Report"
        content     = "Please find the attached OLS_STUDENT_COURSES Report."
        $team.by_k12_name("Jenifer Halverson").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
        puts DateTime.now
    end
    
    def set_rows
        
        #IDENTIFY TABLES NEEDED
        agg     = $tables.attach("K12_Aggregate_Progress")
        course  = $tables.attach("K12_Student_Course")
        prog    = $tables.attach("K12_Progress_And_Achievement")
        calms   = $tables.attach("K12_Calms_Aggregate_Progress")
        map = $tables.attach("Course_Content_Map")
        
        #MAP K12_PROGRESS_AND_ACHIEVEMENT TO K12_AGGREGATE_PROGRESS
        subject_fields = Hash.new
        subject_fields["lals_course"]   = "la/ls_progress_percent"
        subject_fields["ma_coursecode"] = "math_progress_percent"
        subject_fields["sc_coursecode"] = "science_progress_percent"
        subject_fields["hi_coursecode"] = "history_progress_percent"
        subject_fields["mu_coursecode"] = "music_progress_percent"
        subject_fields["va_coursecode"] = "art_progress_percent"
        
        column_order    = Array.new
        students        = agg.students_with_records
        if students
            students.each{|sid| 
                
                #ITTERATE THROUGH ALL OF THE STUDENT'S K12_AGGREGATE_PROGRESS RECORDS
                agg.by_studentid_old(sid).each{|agg_progress_record|
                    class_name  = agg_progress_record.fields["classroom_name"       ].value
                    grade_level = agg_progress_record.fields["student_grade_level"  ].value
                    
                    this = Hash.new
                    this[:student_id            ] = sid         if !column_order.include?(:student_id)          ? column_order.push(:student_id         ) : true
                    this[:classroom_name        ] = class_name  if !column_order.include?(:classroom_name)      ? column_order.push(:classroom_name     ) : true
                    this[:student_grade_level   ] = grade_level if !column_order.include?(:student_grade_level) ? column_order.push(:student_grade_level) : true
                    this[:course_code           ] = nil         if !column_order.include?(:course_code)         ? column_order.push(:course_code        ) : true
                    this[:course_name           ] = nil         if !column_order.include?(:course_name)         ? column_order.push(:course_name        ) : true
                    this[:start_date            ] = nil         if !column_order.include?(:start_date)          ? column_order.push(:start_date         ) : true
                    this[:teacherfirstname      ] = nil         if !column_order.include?(:teacherfirstname)    ? column_order.push(:teacherfirstname   ) : true
                    this[:teacherlastname       ] = nil         if !column_order.include?(:teacherlastname)     ? column_order.push(:teacherlastname    ) : true
                    this[:subject               ] = nil         if !column_order.include?(:subject)             ? column_order.push(:subject            ) : true
                    this[:progress              ] = nil         if !column_order.include?(:progress)            ? column_order.push(:progress           ) : true
                    this[:progress_source       ] = "K12 AGG"   if !column_order.include?(:progress_source)     ? column_order.push(:progress_source    ) : true
                    this[:progress_not_found    ] = nil         if !column_order.include?(:progress_not_found)  ? column_order.push(:progress_not_found ) : true
                    this[:course_not_found      ] = nil         if !column_order.include?(:course_not_found)    ? column_order.push(:course_not_found   ) : true
                    this[:column_order          ] = column_order
                    
                    #GET COURSE INFO FROM K12_STUDENT_COURSE
                    course_record = course.by_classroom_name(this[:classroom_name], sid)
                    if course_record
                        this[:course_code        ] = course_record.fields["course_code"       ].value 
                        this[:course_name        ] = course_record.fields["course_name"       ].value 
                        this[:start_date         ] = course_record.fields["course_start_date" ].value 
                        this[:teacherfirstname   ] = course_record.fields["teacherfirstname"  ].value 
                        this[:teacherlastname    ] = course_record.fields["teacherlastname"   ].value
                        
                        #GET COURSE SUBJECT
                        subject_records = prog.by_studentid_old(sid)
                        subject_records.each{|subject_record|
                            subject_fields.each_pair{|field, equiv|
                                if subject_record.fields[field].value == this[:course_code]
                                    this[:subject] = equiv
                                end
                            }
                        }
                        
                        #IDENTIFY PROGRESS
                        progress = nil
                        if this[:subject]
                            
                            progress = agg_progress_record.fields[ this[:subject] ].value
                            
                        elsif this[:course_name].match(/latin|spanish|german|french/i)
                            
                            this[:subject  ] = "other_progress_percent"
                            progress = agg_progress_record.fields["other_progress_percent"].value
                            
                        elsif this[:course_code].match(/CALMS/)
                            
                            this[:progress_source] = "K12 CALMS"
                            if this[:course_name].match(/Geometry|Algebra|Math/i)
                                this[:subject] = "math_progress_percent"
                            end
                            calms_record = calms.by_coursecode_studentid(this[:course_code], sid)
                            progress     = calms_record.fields["percent_progress"].value if calms_record
                            
                        end
                        (!progress.nil? && !progress.empty?) ? this[:progress ] = progress :  this[:progress_not_found ] = true
                    else
                       this[:course_not_found   ] = true
                       this[:progress_not_found ] = true
                    end
                    @rows.push(this)
                }
            }
        end
    end
end
Aggregate_Aggregate_Report.new