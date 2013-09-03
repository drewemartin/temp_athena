#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class K6_Progress_Snapshot_Report < Base

    #---------------------------------------------------------------------------
    def initialize
        super()
        term = "Q4"
        #snapshot
        
        #progress_report_batch(term)
        
        #grade_levels = 'K|1st|2nd'
        #progress_report_batch_by_grade_level(term, grade_levels)
        
        #@word = $base.word
        #@word.DisplayAlerts = false
        #@school_year = $school.current_school_year
        @structure          = nil
        #@grade_levels       = grade_levels
        
        #create_report
        
        #snapshot
        
        #generate_report("17529", "Q4")
        
        #term = "Q4"
        #students = $db.get_data_single("SELECT student_id FROM k6_progress_snapshot WHERE first_name IS NOT NULL and term = '#{term}' and reported_datetime IS NULL GROUP BY student_id order by grade_level desc")
        #students.each{|sid|
        #    program_start_time  = Time.new
        #    generate_report(sid, term)
        #    puts "#{sid} COMPLETED IN: #{(Time.new - program_start_time)/60}"
        #}
        
        #'3rd|4th|5th|6th'
        #'K|1st|2nd'
        teachers = $db.get_data_single(
            "SELECT teacher
            FROM k6_progress_snapshot
            WHERE term = '#{term}'
            AND teacher IS NOT NULL
            AND grade_level REGEXP 'K|1st|2nd'
            GROUP BY teacher "
        )
        @teacher_reports_path = $config.init_path("#{$paths.reports_path}Progress_Reports/School_Year_#{$school.current_school_year}/#{term}_K6_Teachers")
        #teachers.each{|teacher|
        #    
        #    teacher_package(teacher, term)
        #}
        
        #distribute_teachers(term)
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def distribute_teachers(term)
        teacher_files        = Hash.new{|hash, key| hash[key] = Hash.new if !hash.has_key?(key)}
        Dir.entries(@teacher_reports_path).each{|entry|
            if entry.split(".").length > 0 #&& entry.include?($ifilestamp)
                teacher = entry.split("#{term}_")[1].split("_D20")[0].gsub("_"," ")
                teacher_files[teacher]["#{@teacher_reports_path}#{entry}"] = true
            end
        }
        content     = "Please find the attached zip file containing your student's progress reports for #{@school_year} School Year - #{term}."
        subject     = "Progress Reports #{term}"
        teacher_files.each_pair{|teacher,files|
            i = 1
            tot_files = files.length
            files.each_key{|file|
                tot_files = teacher_files[teacher].length
                if !$team.by_k12_name(teacher)
                    puts teacher
                else
                    recipients = [
                        $team.by_k12_name(teacher).email.value,
                        $team.by_k12_name('Bruce Elliott').email.value
                    ]
                    $base.email.send(recipients, subject, content, priority = nil, attachments = [file])
                    
                    #$team.by_k12_name(teacher).send_email(:subject=> "#{subject} - #{i} of #{tot_files}", :content=> content, :additional_recipients=> 2, :attachment_name=> [file])
                end
                #$team.by_k12_name(teacher).send_email(:subject=> "#{subject} - #{i} of #{tot_files}", :content=> content, :additional_recipients=> 2, :attachment_name=> [file])
                i+=1            
            }
        }
    end
    
    def teacher_package(teacher_name, term)
        student_files = Array.new
        students = $db.get_data_single("SELECT student_id FROM k6_progress_snapshot WHERE term = '#{term}' and teacher = '#{teacher_name}' GROUP BY student_id")
        students.each{|sid|
            student_files.push(progress_report_pdf(sid, term))
        }
        size          = 0
        qty           = 1
        batch_index   = 1
        batch_tot     = student_files.length
        zip_path      = "#{@teacher_reports_path}#{term}_#{teacher_name.gsub(" ","_")}_#{$ifilestamp}_#{qty}.zip"
        zip_file      = Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE)
        student_files.each{|file_path|
            file_size = (File.size(file_path).to_f/1024).ceil
            if size + file_size <= 5800
                size += file_size
                zip_file.add(file_path.split("/")[-1], file_path)
            else
                qty+=1
                zip_file.close
                zip_path    = "#{@teacher_reports_path}#{term}_#{teacher_name.gsub(" ","_")}_#{$ifilestamp}_#{qty}.zip"
                zip_file    = Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE)
                size        = file_size
                zip_file.add(file_path.split("/")[-1], file_path)
            end
            if batch_index == batch_tot
                zip_file.close
            end
            batch_index+=1
        }
    end

    def column_structs
        if !structure.has_key?(:content_row) || !structure.has_key?(:columns)
            structure[:content_row] = Hash.new
            structure[:columns    ] = Array.new
            $tables.attach("K6_Progress").field_order.each{|column_name|
                if !column_name.match(/created_by|created_date|primary_id/)
                    structure[:columns    ].push(column_name) 
                    structure[:content_row][column_name] = nil
                end
            }
            $school.classes.subjects(@grade_levels).each{|column_name|
                structure[:columns    ].push(column_name)
                structure[:content_row][column_name] = nil
            }
            #@grade_levels.each{|grade|
            #    $tables.attach("K6_Mastery_Sections").by_grade_level(grade).each{|section|
            #        column_name = section.fields["primary_id"].value
            #        structure[:columns    ].push(column_name)
            #        structure[:content_row][column_name] = nil
            #    }  
            #}
        end
    end
    
    def clean_content_row
        content_row.each_key{|key|
            content_row[key] = nil
        }
        return content_row
    end
    
    def snapshot
        
        active_terms    = $school.active_terms
        students        = $db.get_data_single("SELECT student_id FROM k6_progress WHERE first_name IS NOT NULL AND term = 'Q4' and grade_level regexp 'K' GROUP BY student_id")
        students.each{|sid|
            s = 0
            active_terms.each{|row|
                term            = row.fields["term"].value
                student         = $students.attach(sid).progress
                student.term    = term
                
                record = $tables.attach("K6_PROGRESS_SNAPSHOT").by_studentid_term(sid, term)
                if !record
                    record = $tables.attach("K6_PROGRESS_SNAPSHOT").new_row
                    
                    if progress_record = student.progress_record
                        progress_record.table.field_order.each{|field_name|
                            record.fields[field_name].value = progress_record.fields[field_name].value
                        }
                    else
                        puts "PROGRESS RECORD NOT FOUND!!! SID: #{sid} TERM: #{term}"
                        student.progress_record
                    end
                    
                    if x=student.progress
                        x.each{|row|
                            column  = row.fields["course_subject_school"].value
                            score   = row.fields["progress"].value
                            record.fields[column].value = score
                        }
                    else
                        #puts "COURSE RECORDS NOT FOUND!!! SID: #{sid} TERM: #{term}"
                    end
                    
                    if x=student.masteries
                        x.each{|row|
                            column  = row.fields["mastery_id"].value
                            score   = row.fields["mastery_level"].value || "N/A"
                            record.fields[column].value = score
                        }
                    else
                        #puts "MASTERY RECORDS NOT FOUND!!! SID: #{sid} TERM: #{term}" #Probaby ok for this year - since only snapshot on Q2 and Q4 
                    end
                    
                    record.save
                end
                
            }
            
        }
        
    end
    
    def find_replace_array
        results = [
            "[s_d_1]"                               ,
            "[s_v_1_Q1]"                            ,
            "[s_v_1_Q2]"                            ,
            "[s_v_1_Q3]"                            ,
            "[s_v_1_Q4]"                            ,
            "[s_d_2]"                               ,
            "[s_v_2_Q1]"                            ,
            "[s_v_2_Q2]"                            ,
            "[s_v_2_Q3]"                            ,
            "[s_v_2_Q4]"                            ,
            "[s_d_3]"                               ,
            "[s_v_3_Q1]"                            ,
            "[s_v_3_Q2]"                            ,
            "[s_v_3_Q3]"                            ,
            "[s_v_3_Q4]"                            ,
            "[s_d_4]"                               ,
            "[s_v_4_Q1]"                            ,
            "[s_v_4_Q2]"                            ,
            "[s_v_4_Q3]"                            ,
            "[s_v_4_Q4]"                            ,
            "[s_d_5]"                               ,
            "[s_v_5_Q1]"                            ,
            "[s_v_5_Q2]"                            ,
            "[s_v_5_Q3]"                            ,
            "[s_v_5_Q4]"                            ,
            "[s_d_6]"                               ,
            "[s_v_6_Q1]"                            ,
            "[s_v_6_Q2]"                            ,
            "[s_v_6_Q3]"                            ,
            "[s_v_6_Q4]"                            ,
            "[s_d_7]"                               ,
            "[s_v_7_Q1]"                            ,
            "[s_v_7_Q2]"                            ,
            "[s_v_7_Q3]"                            ,
            "[s_v_7_Q4]"                            ,
            "[s_d_8]"                               ,
            "[s_v_8_Q1]"                            ,
            "[s_v_8_Q2]"                            ,
            "[s_v_8_Q3]"                            ,
            "[s_v_8_Q4]"                            ,
            "[s_d_8]"                               ,
            "[s_v_9_Q1]"                            ,
            "[s_v_9_Q2]"                            ,
            "[s_v_9_Q3]"                            ,
            "[s_v_9_Q4]"                            ,
            "[s_d_9]"                               ,
            "[s_v_10_Q1]"                           ,
            "[s_v_10_Q2]"                           ,
            "[s_v_10_Q3]"                           ,
            "[s_v_10_Q4]"                           ,
            "[days_present_Q1]"                     ,
            "[days_present_Q2]"                     ,
            "[days_present_Q3]"                     ,
            "[days_present_Q4]"                     ,
            "[absences_excused_Q1]"                 ,
            "[absences_excused_Q2]"                 ,
            "[absences_excused_Q3]"                 ,
            "[absences_excused_Q4]"                 ,
            "[absences_unexcused_Q1]"               ,
            "[absences_unexcused_Q2]"               ,
            "[absences_unexcused_Q3]"               ,
            "[absences_unexcused_Q4]"               ,
            "[adequate_progress_Q1]"                ,
            "[adequate_progress_Q2]"                ,
            "[adequate_progress_Q3]"                ,
            "[adequate_progress_Q4]"                ,
            "[assessment_completion_Q1]"            ,
            "[assessment_completion_Q2]"            ,
            "[assessment_completion_Q3]"            ,
            "[assessment_completion_Q4]"            ,
            "[work_submission_Q1]"                  ,
            "[work_submission_Q2]"                  ,
            "[work_submission_Q3]"                  ,
            "[work_submission_Q4]"                  ,
            "[math_goals_Q1]"                       ,
            "[reading_goals_Q1]"                    ,
            "[math_goals_Q2]"                       ,
            "[reading_goals_Q2]"                    ,
            "[math_goals_Q3]"                       ,
            "[reading_goals_Q3]"                    ,
            "[math_goals_Q4]"                       ,
            "[reading_goals_Q4]"                    ,
            "[m_d_Reading_1]"                       ,
            "[m_v_Reading_1_Q2]"                    ,
            "[m_v_Reading_1_Q4]"                    ,
            "[m_d_Reading_2]"                       ,
            "[m_v_Reading_2_Q2]"                    ,
            "[m_v_Reading_2_Q4]"                    ,
            "[m_d_Reading_3]"                       ,
            "[m_v_Reading_3_Q2]"                    ,
            "[m_v_Reading_3_Q4]"                    ,
            "[m_d_Reading_4]"                       ,
            "[m_v_Reading_4_Q2]"                    ,
            "[m_v_Reading_4_Q4]"                    ,
            "[m_d_Reading_5]"                       ,
            "[m_v_Reading_5_Q2]"                    ,
            "[m_v_Reading_5_Q4]"                    ,
            "[m_d_Reading_6]"                       ,
            "[m_v_Reading_6_Q2]"                    ,
            "[m_v_Reading_6_Q4]"                    ,
            "[m_d_Reading_7]"                       ,
            "[m_v_Reading_7_Q2]"                    ,
            "[m_v_Reading_7_Q4]"                    ,
            "[m_d_Reading_8]"                       ,
            "[m_v_Reading_8_Q2]"                    ,
            "[m_v_Reading_8_Q4]"                    ,
            "[m_d_Reading_9]"                       ,
            "[m_v_Reading_9_Q2]"                    ,
            "[m_v_Reading_9_Q4]"                    ,
            "[m_d_Reading_10]"                      ,
            "[m_v_Reading_10_Q2]"                   ,
            "[m_v_Reading_10_Q4]"                   ,
            "[m_d_Reading_11]"                      ,
            "[m_v_Reading_11_Q2]"                   ,
            "[m_v_Reading_11_Q4]"                   ,
            "[m_d_Reading_12]"                      ,
            "[m_v_Reading_12_Q2]"                   ,
            "[m_v_Reading_12_Q4]"                   ,
            "[m_d_Reading_13]"                      ,
            "[m_v_Reading_13_Q2]"                   ,
            "[m_v_Reading_13_Q4]"                   ,
            "[m_d_Reading_14]"                      ,
            "[m_v_Reading_14_Q2]"                   ,
            "[m_v_Reading_14_Q4]"                   ,
            "[m_d_Reading_15]"                      ,
            "[m_v_Reading_15_Q2]"                   ,
            "[m_v_Reading_15_Q4]"                   ,
            "[m_d_Mathematics_1]"                   ,
            "[m_v_Mathematics_1_Q2]"                ,
            "[m_v_Mathematics_1_Q4]"                ,
            "[m_d_Mathematics_2]"                   ,
            "[m_v_Mathematics_2_Q2]"                ,
            "[m_v_Mathematics_2_Q4]"                ,
            "[m_d_Mathematics_3]"                   ,
            "[m_v_Mathematics_3_Q2]"                ,
            "[m_v_Mathematics_3_Q4]"                ,
            "[m_d_Mathematics_4]"                   ,
            "[m_v_Mathematics_4_Q2]"                ,
            "[m_v_Mathematics_4_Q4]"                ,
            "[m_d_Mathematics_5]"                   ,
            "[m_v_Mathematics_5_Q2]"                ,
            "[m_v_Mathematics_5_Q4]"                ,
            "[m_d_Mathematics_6]"                   ,
            "[m_v_Mathematics_6_Q2]"                ,
            "[m_v_Mathematics_6_Q4]"                ,
            "[m_d_Mathematics_7]"                   ,
            "[m_v_Mathematics_7_Q2]"                ,
            "[m_v_Mathematics_7_Q4]"                ,
            "[m_d_Mathematics_8]"                   ,
            "[m_v_Mathematics_8_Q2]"                ,
            "[m_v_Mathematics_8_Q4]"                ,
            "[m_d_Mathematics_9]"                   ,
            "[m_v_Mathematics_9_Q2]"                ,
            "[m_v_Mathematics_9_Q4]"                ,
            "[m_d_Mathematics_10]"                  ,
            "[m_v_Mathematics_10_Q2]"               ,
            "[m_v_Mathematics_10_Q4]"               ,
            "[m_d_Mathematics_11]"                  ,
            "[m_v_Mathematics_11_Q2]"               ,
            "[m_v_Mathematics_11_Q4]"               ,
            "[m_d_Mathematics_12]"                  ,
            "[m_v_Mathematics_12_Q2]"               ,
            "[m_v_Mathematics_12_Q4]"               ,
            "[m_d_Mathematics_13]"                  ,
            "[m_v_Mathematics_13_Q2]"               ,
            "[m_v_Mathematics_13_Q4]"               ,
            "[m_d_Mathematics_14]"                  ,
            "[m_v_Mathematics_14_Q2]"               ,
            "[m_v_Mathematics_14_Q4]"               ,
            "[m_d_Mathematics_15]"                  ,
            "[m_v_Mathematics_15_Q2]"               ,
            "[m_v_Mathematics_15_Q4]"               ,
            "[m_d_Mathematics_16]"                  ,
            "[m_v_Mathematics_16_Q2]"               ,
            "[m_v_Mathematics_16_Q4]"               ,
            "[m_d_Mathematics_17]"                  ,
            "[m_v_Mathematics_17_Q2]"               ,
            "[m_v_Mathematics_17_Q4]"               ,
            "[m_d_Mathematics_18]"                  ,
            "[m_v_Mathematics_18_Q2]"               ,
            "[m_v_Mathematics_18_Q4]"               ,
            "[m_d_Mathematics_19]"                  ,
            "[m_v_Mathematics_19_Q2]"               ,
            "[m_v_Mathematics_19_Q4]"               ,
            "[m_d_Mathematics_20]"                  ,
            "[m_v_Mathematics_20_Q2]"               ,
            "[m_v_Mathematics_20_Q4]"               ,
            "[m_d_Writing_1]"                       ,
            "[m_v_Writing_1_Q2]"                    ,
            "[m_v_Writing_1_Q4]"                    ,
            "[m_d_Writing_2]"                       ,
            "[m_v_Writing_2_Q2]"                    ,
            "[m_v_Writing_2_Q4]"                    ,
            "[m_d_Writing_3]"                       ,
            "[m_v_Writing_3_Q2]"                    ,
            "[m_v_Writing_3_Q4]"                    ,
            "[m_d_Writing_4]"                       ,
            "[m_v_Writing_4_Q2]"                    ,
            "[m_v_Writing_4_Q4]"                    ,
            "[m_d_Writing_5]"                       ,
            "[m_v_Writing_5_Q2]"                    ,
            "[m_v_Writing_5_Q4]"                    ,
            "[m_d_Writing_6]"                       ,
            "[m_v_Writing_6_Q2]"                    ,
            "[m_v_Writing_6_Q4]"                    ,
            "[m_d_Writing_7]"                       ,
            "[m_v_Writing_7_Q2]"                    ,
            "[m_v_Writing_7_Q4]"                    ,
            "[m_d_Writing_8]"                       ,
            "[m_v_Writing_8_Q2]"                    ,
            "[m_v_Writing_8_Q4]"                    ,
            "[m_d_History_1]"                       ,
            "[m_v_History_1_Q2]"                    ,
            "[m_v_History_1_Q4]"                    ,
            "[m_d_History_2]"                       ,
            "[m_v_History_2_Q2]"                    ,
            "[m_v_History_2_Q4]"                    ,
            "[m_d_History_3]"                       ,
            "[m_v_History_3_Q2]"                    ,
            "[m_v_History_3_Q4]"                    ,
            "[m_d_History_4]"                       ,
            "[m_v_History_4_Q2]"                    ,
            "[m_v_History_4_Q4]"                    ,
            "[m_d_History_5]"                       ,
            "[m_v_History_5_Q2]"                    ,
            "[m_v_History_5_Q4]"                    ,
            "[m_d_Science_1]"                       ,
            "[m_v_Science_1_Q2]"                    ,
            "[m_v_Science_1_Q4]"                    ,
            "[m_v_Physical_Education_1_Q2]"         ,
            "[m_v_Physical_Education_1_Q4]"         ,
            "[m_v_Physical_Education_2_Q2]"         ,
            "[m_v_Physical_Education_2_Q4]"         ,
            "[end_of_year_placement]"               
        ]
        return results
    end
    
    def find_replace_hash
        results = Hash.new
            results["[s_d_1]"                              ] = nil
            results["[s_v_1_Q1]"                           ] = nil
            results["[s_v_1_Q2]"                           ] = nil
            results["[s_v_1_Q3]"                           ] = nil
            results["[s_v_1_Q4]"                           ] = nil
            results["[s_d_2]"                              ] = nil
            results["[s_v_2_Q1]"                           ] = nil
            results["[s_v_2_Q2]"                           ] = nil
            results["[s_v_2_Q3]"                           ] = nil
            results["[s_v_2_Q4]"                           ] = nil
            results["[s_d_3]"                              ] = nil
            results["[s_v_3_Q1]"                           ] = nil
            results["[s_v_3_Q2]"                           ] = nil
            results["[s_v_3_Q3]"                           ] = nil
            results["[s_v_3_Q4]"                           ] = nil
            results["[s_d_4]"                              ] = nil
            results["[s_v_4_Q1]"                           ] = nil
            results["[s_v_4_Q2]"                           ] = nil
            results["[s_v_4_Q3]"                           ] = nil
            results["[s_v_4_Q4]"                           ] = nil
            results["[s_d_5]"                              ] = nil
            results["[s_v_5_Q1]"                           ] = nil
            results["[s_v_5_Q2]"                           ] = nil
            results["[s_v_5_Q3]"                           ] = nil
            results["[s_v_5_Q4]"                           ] = nil
            results["[s_d_6]"                              ] = nil
            results["[s_v_6_Q1]"                           ] = nil
            results["[s_v_6_Q2]"                           ] = nil
            results["[s_v_6_Q3]"                           ] = nil
            results["[s_v_6_Q4]"                           ] = nil
            results["[s_d_7]"                              ] = nil
            results["[s_v_7_Q1]"                           ] = nil
            results["[s_v_7_Q2]"                           ] = nil
            results["[s_v_7_Q3]"                           ] = nil
            results["[s_v_7_Q4]"                           ] = nil
            results["[s_d_8]"                              ] = nil
            results["[s_v_8_Q1]"                           ] = nil
            results["[s_v_8_Q2]"                           ] = nil
            results["[s_v_8_Q3]"                           ] = nil
            results["[s_v_8_Q4]"                           ] = nil
            results["[s_d_8]"                              ] = nil
            results["[s_v_9_Q1]"                           ] = nil
            results["[s_v_9_Q2]"                           ] = nil
            results["[s_v_9_Q3]"                           ] = nil
            results["[s_v_9_Q4]"                           ] = nil
            results["[s_d_9]"                              ] = nil
            results["[s_v_10_Q1]"                          ] = nil
            results["[s_v_10_Q2]"                          ] = nil
            results["[s_v_10_Q3]"                          ] = nil
            results["[s_v_10_Q4]"                          ] = nil
            results["[days_present_Q1]"                    ] = nil
            results["[days_present_Q2]"                    ] = nil
            results["[days_present_Q3]"                    ] = nil
            results["[days_present_Q4]"                    ] = nil
            results["[absences_excused_Q1]"                ] = nil
            results["[absences_excused_Q2]"                ] = nil
            results["[absences_excused_Q3]"                ] = nil
            results["[absences_excused_Q4]"                ] = nil
            results["[absences_unexcused_Q1]"              ] = nil
            results["[absences_unexcused_Q2]"              ] = nil
            results["[absences_unexcused_Q3]"              ] = nil
            results["[absences_unexcused_Q4]"              ] = nil
            results["[adequate_progress_Q1]"               ] = nil
            results["[adequate_progress_Q2]"               ] = nil
            results["[adequate_progress_Q3]"               ] = nil
            results["[adequate_progress_Q4]"               ] = nil
            results["[assessment_completion_Q1]"           ] = nil
            results["[assessment_completion_Q2]"           ] = nil
            results["[assessment_completion_Q3]"           ] = nil
            results["[assessment_completion_Q4]"           ] = nil
            results["[work_submission_Q1]"                 ] = nil
            results["[work_submission_Q2]"                 ] = nil
            results["[work_submission_Q3]"                 ] = nil
            results["[work_submission_Q4]"                 ] = nil
            results["[math_goals_Q1]"                      ] = nil
            results["[reading_goals_Q1]"                   ] = nil
            results["[math_goals_Q2]"                      ] = nil
            results["[reading_goals_Q2]"                   ] = nil
            results["[math_goals_Q3]"                      ] = nil
            results["[reading_goals_Q3]"                   ] = nil
            results["[math_goals_Q4]"                      ] = nil
            results["[reading_goals_Q4]"                   ] = nil
            results["[m_d_Reading_1]"                      ] = nil
            results["[m_v_Reading_1_Q2]"                   ] = nil
            results["[m_v_Reading_1_Q4]"                   ] = nil
            results["[m_d_Reading_2]"                      ] = nil
            results["[m_v_Reading_2_Q2]"                   ] = nil
            results["[m_v_Reading_2_Q4]"                   ] = nil
            results["[m_d_Reading_3]"                      ] = nil
            results["[m_v_Reading_3_Q2]"                   ] = nil
            results["[m_v_Reading_3_Q4]"                   ] = nil
            results["[m_d_Reading_4]"                      ] = nil
            results["[m_v_Reading_4_Q2]"                   ] = nil
            results["[m_v_Reading_4_Q4]"                   ] = nil
            results["[m_d_Reading_5]"                      ] = nil
            results["[m_v_Reading_5_Q2]"                   ] = nil
            results["[m_v_Reading_5_Q4]"                   ] = nil
            results["[m_d_Reading_6]"                      ] = nil
            results["[m_v_Reading_6_Q2]"                   ] = nil
            results["[m_v_Reading_6_Q4]"                   ] = nil
            results["[m_d_Reading_7]"                      ] = nil
            results["[m_v_Reading_7_Q2]"                   ] = nil
            results["[m_v_Reading_7_Q4]"                   ] = nil
            results["[m_d_Reading_8]"                      ] = nil
            results["[m_v_Reading_8_Q2]"                   ] = nil
            results["[m_v_Reading_8_Q4]"                   ] = nil
            results["[m_d_Reading_9]"                      ] = nil
            results["[m_v_Reading_9_Q2]"                   ] = nil
            results["[m_v_Reading_9_Q4]"                   ] = nil
            results["[m_d_Reading_10]"                     ] = nil
            results["[m_v_Reading_10_Q2]"                  ] = nil
            results["[m_v_Reading_10_Q4]"                  ] = nil
            results["[m_d_Reading_11]"                     ] = nil
            results["[m_v_Reading_11_Q2]"                  ] = nil
            results["[m_v_Reading_11_Q4]"                  ] = nil
            results["[m_d_Reading_12]"                     ] = nil
            results["[m_v_Reading_12_Q2]"                  ] = nil
            results["[m_v_Reading_12_Q4]"                  ] = nil
            results["[m_d_Reading_13]"                     ] = nil
            results["[m_v_Reading_13_Q2]"                  ] = nil
            results["[m_v_Reading_13_Q4]"                  ] = nil
            results["[m_d_Reading_14]"                     ] = nil
            results["[m_v_Reading_14_Q2]"                  ] = nil
            results["[m_v_Reading_14_Q4]"                  ] = nil
            results["[m_d_Reading_15]"                     ] = nil
            results["[m_v_Reading_15_Q2]"                  ] = nil
            results["[m_v_Reading_15_Q4]"                  ] = nil
            results["[m_d_Mathematics_1]"                  ] = nil
            results["[m_v_Mathematics_1_Q2]"               ] = nil
            results["[m_v_Mathematics_1_Q4]"               ] = nil
            results["[m_d_Mathematics_2]"                  ] = nil
            results["[m_v_Mathematics_2_Q2]"               ] = nil
            results["[m_v_Mathematics_2_Q4]"               ] = nil
            results["[m_d_Mathematics_3]"                  ] = nil
            results["[m_v_Mathematics_3_Q2]"               ] = nil
            results["[m_v_Mathematics_3_Q4]"               ] = nil
            results["[m_d_Mathematics_4]"                  ] = nil
            results["[m_v_Mathematics_4_Q2]"               ] = nil
            results["[m_v_Mathematics_4_Q4]"               ] = nil
            results["[m_d_Mathematics_5]"                  ] = nil
            results["[m_v_Mathematics_5_Q2]"               ] = nil
            results["[m_v_Mathematics_5_Q4]"               ] = nil
            results["[m_d_Mathematics_6]"                  ] = nil
            results["[m_v_Mathematics_6_Q2]"               ] = nil
            results["[m_v_Mathematics_6_Q4]"               ] = nil
            results["[m_d_Mathematics_7]"                  ] = nil
            results["[m_v_Mathematics_7_Q2]"               ] = nil
            results["[m_v_Mathematics_7_Q4]"               ] = nil
            results["[m_d_Mathematics_8]"                  ] = nil
            results["[m_v_Mathematics_8_Q2]"               ] = nil
            results["[m_v_Mathematics_8_Q4]"               ] = nil
            results["[m_d_Mathematics_9]"                  ] = nil
            results["[m_v_Mathematics_9_Q2]"               ] = nil
            results["[m_v_Mathematics_9_Q4]"               ] = nil
            results["[m_d_Mathematics_10]"                 ] = nil
            results["[m_v_Mathematics_10_Q2]"              ] = nil
            results["[m_v_Mathematics_10_Q4]"              ] = nil
            results["[m_d_Mathematics_11]"                 ] = nil
            results["[m_v_Mathematics_11_Q2]"              ] = nil
            results["[m_v_Mathematics_11_Q4]"              ] = nil
            results["[m_d_Mathematics_12]"                 ] = nil
            results["[m_v_Mathematics_12_Q2]"              ] = nil
            results["[m_v_Mathematics_12_Q4]"              ] = nil
            results["[m_d_Mathematics_13]"                 ] = nil
            results["[m_v_Mathematics_13_Q2]"              ] = nil
            results["[m_v_Mathematics_13_Q4]"              ] = nil
            results["[m_d_Mathematics_14]"                 ] = nil
            results["[m_v_Mathematics_14_Q2]"              ] = nil
            results["[m_v_Mathematics_14_Q4]"              ] = nil
            results["[m_d_Mathematics_15]"                 ] = nil
            results["[m_v_Mathematics_15_Q2]"              ] = nil
            results["[m_v_Mathematics_15_Q4]"              ] = nil
            results["[m_d_Mathematics_16]"                 ] = nil
            results["[m_v_Mathematics_16_Q2]"              ] = nil
            results["[m_v_Mathematics_16_Q4]"              ] = nil
            results["[m_d_Mathematics_17]"                 ] = nil
            results["[m_v_Mathematics_17_Q2]"              ] = nil
            results["[m_v_Mathematics_17_Q4]"              ] = nil
            results["[m_d_Mathematics_18]"                 ] = nil
            results["[m_v_Mathematics_18_Q2]"              ] = nil
            results["[m_v_Mathematics_18_Q4]"              ] = nil
            results["[m_d_Mathematics_19]"                 ] = nil
            results["[m_v_Mathematics_19_Q2]"              ] = nil
            results["[m_v_Mathematics_19_Q4]"              ] = nil
            results["[m_d_Mathematics_20]"                 ] = nil
            results["[m_v_Mathematics_20_Q2]"              ] = nil
            results["[m_v_Mathematics_20_Q4]"              ] = nil
            results["[m_d_Writing_1]"                      ] = nil
            results["[m_v_Writing_1_Q2]"                   ] = nil
            results["[m_v_Writing_1_Q4]"                   ] = nil
            results["[m_d_Writing_2]"                      ] = nil
            results["[m_v_Writing_2_Q2]"                   ] = nil
            results["[m_v_Writing_2_Q4]"                   ] = nil
            results["[m_d_Writing_3]"                      ] = nil
            results["[m_v_Writing_3_Q2]"                   ] = nil
            results["[m_v_Writing_3_Q4]"                   ] = nil
            results["[m_d_Writing_4]"                      ] = nil
            results["[m_v_Writing_4_Q2]"                   ] = nil
            results["[m_v_Writing_4_Q4]"                   ] = nil
            results["[m_d_Writing_5]"                      ] = nil
            results["[m_v_Writing_5_Q2]"                   ] = nil
            results["[m_v_Writing_5_Q4]"                   ] = nil
            results["[m_d_Writing_6]"                      ] = nil
            results["[m_v_Writing_6_Q2]"                   ] = nil
            results["[m_v_Writing_6_Q4]"                   ] = nil
            results["[m_d_Writing_7]"                      ] = nil
            results["[m_v_Writing_7_Q2]"                   ] = nil
            results["[m_v_Writing_7_Q4]"                   ] = nil
            results["[m_d_Writing_8]"                      ] = nil
            results["[m_v_Writing_8_Q2]"                   ] = nil
            results["[m_v_Writing_8_Q4]"                   ] = nil
            results["[m_d_History_1]"                      ] = nil
            results["[m_v_History_1_Q2]"                   ] = nil
            results["[m_v_History_1_Q4]"                   ] = nil
            results["[m_d_History_2]"                      ] = nil
            results["[m_v_History_2_Q2]"                   ] = nil
            results["[m_v_History_2_Q4]"                   ] = nil
            results["[m_d_History_3]"                      ] = nil
            results["[m_v_History_3_Q2]"                   ] = nil
            results["[m_v_History_3_Q4]"                   ] = nil
            results["[m_d_History_4]"                      ] = nil
            results["[m_v_History_4_Q2]"                   ] = nil
            results["[m_v_History_4_Q4]"                   ] = nil
            results["[m_d_History_5]"                      ] = nil
            results["[m_v_History_5_Q2]"                   ] = nil
            results["[m_v_History_5_Q4]"                   ] = nil
            results["[m_d_Science_1]"                      ] = nil
            results["[m_v_Science_1_Q2]"                   ] = nil
            results["[m_v_Science_1_Q4]"                   ] = nil
            results["[m_v_Physical_Education_1_Q2]"        ] = nil
            results["[m_v_Physical_Education_1_Q4]"        ] = nil
            results["[m_v_Physical_Education_2_Q2]"        ] = nil
            results["[m_v_Physical_Education_2_Q4]"        ] = nil
            results["[end_of_year_placement]"              ] = nil
        return results
    end
    
    def progress_report_batch(term)
        
        student = true
        while student
            program_start_time = Time.new
            student = $db.get_data_single(
                "SELECT student_id
                FROM k6_progress_snapshot
                WHERE term = '#{term}'
                AND reported_datetime IS NULL
                LIMIT 1"
            )
            if student
                sid = student[0]
                $db.query(
                    "UPDATE k6_progress_snapshot
                    SET reported_datetime = CURRENT_TIMESTAMP()
                    WHERE term = '#{term}'
                    AND student_id = '#{sid}'"
                )
                progress_report_pdf(sid, term)
                puts "#{sid} COMPLETED IN: #{(Time.new - program_start_time)/60}"
            end
        end
        
    end
    
    def progress_report_batch_by_grade_level(term, grade_levels)
        
        student = true
        while student
            program_start_time = Time.new
            student = $db.get_data_single(
                "SELECT student_id
                FROM k6_progress_snapshot
                WHERE term = '#{term}'
                AND grade_level REGEXP '#{grade_levels}'
                AND reported_datetime IS NULL
                LIMIT 1"
            )
            if student
                sid = student[0]
                $db.query(
                    "UPDATE k6_progress_snapshot
                    SET reported_datetime = CURRENT_TIMESTAMP()
                    WHERE term = '#{term}'
                    AND student_id = '#{sid}'"
                )
                progress_report_pdf(sid, term)
                puts "#{sid} COMPLETED IN: #{(Time.new - program_start_time)/60}"
            end
        end
      
    end
    
    def progress_report_pdf(student_id, term)
        
        record                          = $tables.attach("K6_PROGRESS_SNAPSHOT").by_studentid_term(student_id, term)
     
        student_name                    = "#{record.fields["last_name"].value}_#{record.fields["first_name"].value}"
        file_name                       = "#{term}_#{student_name}_#{student_id}"
        destination_path                = "Progress_Reports/School_Year_#{$school.current_school_year}/#{term}_K6_Students"
        template_name                   = "k6_progress_report_with_masteries"
        
        pdf_file_path                   = "#{$paths.reports_path}/#{destination_path}/#{file_name}.pdf"
        
        if File.exists?(pdf_file_path)
            return pdf_file_path
        else
            replace_hash                    = find_replace_hash
            
            active_terms                    = ["Q1","Q2","Q3","Q4"]
            active_terms.delete(term)
            
            ignore_fields                   = ["primary_id","created_by","created_date","term","teacher_verified","admin_verified"]
            current_info_fields             = ["first_name","last_name","student_id","enroll_date","teacher","school_year","grade_level","comments"] 
            
            subjects = [
                "Art",           
                "History",       
                "Language Arts",
                "Literature",    
                "Mathematics",   
                "Music",         
                "Phonics",       
                "Science",       
                "Spelling"
            ]
            
            subjects_fields     = Hash.new
            
            masteries_fields    = Hash.new
            
            record.fields.each_pair{|field_name, details|
                if !ignore_fields.include?(field_name)
                    if is_num?(field_name)
                        if (term == "Q2" || term == "Q4") && !details.value.nil?
                            masteries_fields[field_name] = {:Q2=>nil, :Q4=>nil} if !masteries_fields.has_key?(field_name)
                            masteries_fields[field_name][term.to_sym] = details.to_user
                        end
                    elsif subjects.include?(field_name)
                        if !details.value.nil?
                            subjects_fields[field_name] = {:Q1=>nil,:Q2=>nil,:Q3=>nil,:Q4=>nil} if !subjects_fields.has_key?(field_name)
                            subjects_fields[field_name][term.to_sym] = details.to_user
                        end
                    elsif term == "Q4" && field_name == "end_of_year_placement"
                        x       = record.fields["grade_level"].value
                        grade   = (x.split(" ")[0].split("th")[0].split("rd")[0].split("nd")[0].split("st")[0])
                        grade_  = is_num?(grade) ? Integer(grade) : 0
                        student = record.fields["first_name"].value
                        eoy = details.value
                        if eoy == "Promoted"
                            this_grade = grade_ + 1
                            this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                            blurb = "#{student} will be promoted to #{this_grade} for the 2012-2013 school year."
                        elsif eoy == "Accelerated"
                            this_grade = grade_ + 2
                            this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                            blurb = "#{student} will be placed in #{this_grade} for the 2012-2013 school year."
                        elsif eoy == "Retained"
                            this_grade = grade_
                            this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                            blurb = "#{student} will be retained in #{this_grade} for the 2012-2013 school year."
                        elsif eoy == "Placed"
                            this_grade = grade_ + 1
                            this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                            blurb = "#{student} will be placed in #{this_grade} for the 2012-2013 school year."
                        elsif eoy == "Promoted Pending Summer School"
                            this_grade = grade_ + 1
                            this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                            blurb = "If #{student} attends Summer School at Agora and masters grade level standards, he/she will be promoted to #{this_grade} for the 2012-2013 school year."
                        end
                        replace_hash["[#{field_name}]"] = blurb
                    elsif current_info_fields.include?(field_name)
                        replace_hash["[#{field_name}]"] = details.to_user
                    else
                        replace_hash["[#{field_name}_#{term}]"] = details.to_user
                    end 
                end
            }
            active_terms.each{|active_term|
                active_record = $tables.attach("K6_PROGRESS_SNAPSHOT").by_studentid_term(student_id, active_term)
                active_record.fields.each_pair{|field_name, details|
                    if !ignore_fields.include?(field_name)
                        if is_num?(field_name) 
                            if (term == "Q2" || term == "Q4") && !details.value.nil?
                                masteries_fields[field_name] = {:Q2=>nil, :Q4=>nil} if !masteries_fields.has_key?(field_name)
                                masteries_fields[field_name][active_term.to_sym] = details.to_user
                            end
                        elsif subjects.include?(field_name)
                            if !details.value.nil?
                                subjects_fields[field_name] = {:Q1=>nil,:Q2=>nil,:Q3=>nil,:Q4=>nil} if !subjects_fields.has_key?(field_name)
                                subjects_fields[field_name][active_term.to_sym] = details.to_user
                            end
                        elsif active_term == "Q4" && field_name == "end_of_year_placement"
                            x       = record.fields["grade_level"].value
                            grade   = (x.split(" ")[0].split("th")[0].split("rd")[0].split("nd")[0].split("st")[0])
                            grade_  = is_num?(grade) ? Integer(grade) : 0
                            student = record.fields["first_name"].value
                            eoy = details.value
                            if eoy == "Promoted"
                                this_grade = grade_ + 1
                                this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                                blurb = "#{student} will be promoted to #{this_grade} for the 2012-2013 school year."
                            elsif eoy == "Accelerated"
                                this_grade = grade_ + 2
                                this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                                blurb = "#{student} will be placed in #{this_grade} for the 2012-2013 school year."
                            elsif eoy == "Retained"
                                this_grade = grade_
                                this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                                blurb = "#{student} will be retained in #{this_grade} for the 2012-2013 school year."
                            elsif eoy == "Placed"
                                this_grade = grade_ + 1
                                this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                                blurb = "#{student} will be placed in #{this_grade} for the 2012-2013 school year."
                            elsif eoy == "Promoted Pending Summer School"
                                this_grade = grade_ + 1
                                this_grade = (this_grade == 0) ? "Kindergarten" : "grade #{this_grade}"
                                blurb = "If #{student} attends Summer School at Agora and masters grade level standards, he/she will be promoted to #{this_grade} for the 2012-2013 school year."
                            end
                            replace_hash["[#{field_name}]"] = blurb
                        elsif !current_info_fields.include?(field_name)
                            replace_hash["[#{field_name}_#{active_term}]"] = details.to_user
                        end
                    end
                }
            }
            
            i = 1
            subjects_fields.each_pair{|k,v|
                replace_hash["[s_d_#{i}]"] = k
                v.each_pair{|t, value|
                    replace_hash["[s_v_#{i}_#{t.to_s}]"]=value
                }
                i+=1
            }
            
            i = Hash.new
            masteries_fields.each_pair{|k,v|
                description                                                             = $tables.attach("K6_Mastery_Sections").description_by_pid(k).value
                content_area                                                            = $tables.attach("K6_Mastery_Sections").content_area_by_pid(k).value
                
                i[content_area]                                                         = 1 if !i.has_key?(content_area)
                replace_hash["[m_d_#{content_area.gsub(" ","_")}_#{i[content_area]}]"]       = description
               
                v.each_pair{|t, value|
                    field_name = "[m_v_#{content_area}_#{i[content_area]}_#{t.to_s}]".gsub(" ","_")
                    replace_hash[field_name]=value
                }
                i[content_area]+=1
            }
            
            return fill_word_template_save_to_pdf(replace_hash, template_name, destination_path, file_name)
        end
        
    end
    
    def create_report
        rows            = Array.new
        header          = column_row
        rows.push(header)
        active_terms    = $school.active_terms
        content         = content_row
        students        = $db.get_data_single("SELECT student_id FROM k6_progress WHERE first_name IS NOT NULL GROUP BY student_id")
        students.shift(10).each{|sid|
            puts sid
            
            clean_content_row
            active_terms.each{|row|
                student         = $students.attach(sid).progress
                student.term    = row.fields["term"].value
                if @grade_levels.find{|x|$students.attach(sid).grade.value.match(x)} && student.progress_record
                    
                    student.progress_record.fields.each_pair{|field_name, details|
                        content[field_name] = details.value
                    }
                    if x=student.progress
                        x.each{|row|
                            column  = row.fields["course_subject_school"].value
                            score   = row.fields["progress"].value
                            content[column] = score
                        }
                    end
                    if x=student.masteries
                        x.each{|row|
                            column  = row.fields["mastery_id"].value
                            score   = row.fields["mastery_level"].value
                            content[column] = score
                        }
                    end
                    this_row = Array.new
                    header.each{|c| this_row.push(content[c])}
                    rows.push(this_row)
                end
            }
            $students.detach(sid)
        }
        location = "Progress_Reports/School_Year_#{$school.current_school_year}/Overview_Report"
        filename = "K6_Progress_Report_Overview"
        $reports.csv(location, filename, rows)
    end
    
    def column_row
        results = Array.new
        $tables.attach("K6_Progress").field_order.each{|column_name|
            if !column_name.match(/created_by|created_date|primary_id/)
                results.push(column_name) 
            end
        }
        $school.classes.subjects(@grade_levels).each{|column_name|
            results.push(column_name)
        }
        @grade_levels.each{|grade|
            $tables.attach("K6_Mastery_Sections").by_grade_level(grade).each{|section|
                column_name = section.fields["primary_id"].value
                results.push(column_name)
            }  
        }
        return results
    end
    
    def content_row
        if !structure.has_key?(:content_row)
            results = Hash.new
            $tables.attach("K6_Progress").field_order.each{|column_name|
                if !column_name.match(/created_by|created_date|primary_id/)
                    results[column_name] = nil
                end
            }
            $school.classes.subjects(@grade_levels).each{|column_name|
                results[column_name] = nil
            }
            @grade_levels.each{|grade|
                $tables.attach("K6_Mastery_Sections").by_grade_level(grade).each{|section|
                    column_name = section.fields["primary_id"].value
                    results[column_name] = nil
                }  
            }
            structure[:content_row] = results
        end
        return structure[:content_row]
    end
    
    def header_row
        
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

end

K6_Progress_Snapshot_Report.new