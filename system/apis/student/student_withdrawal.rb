#!/usr/local/bin/ruby

class Student_Withdrawal

    #---------------------------------------------------------------------------
    def initialize(student_object)
        @stu      = student_object
        @structure   = nil
        self.student = student_object
    end
    #---------------------------------------------------------------------------
    #Dependencies:
    #Attendance_Master
    #Jupiter_Grades
    #K12_Aggregate_Progress
    #K12_All_Students
    #K12_Calms_Aggregate_Progress
    #K12_Ecollege_Detail
    #K12_Omnibus
    #K12_Withdrawal
    #Withdrawing
    #Withdrawing_Truancy
    
    #WORD must be set up to run as an administrator. go to properties -> compatability -> select run as administrator.
    #Must turn off user account control in windows
    #WORD must have this addon: http://www.microsoft.com/en-us/download/details.aspx?id=7
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def generate_report(wd_record = nil)
        retry_index = 0
        wd_record.fields.delete("comments") if wd_record #this still needs to be dealt with
        #if @stu.active?
            puts @stu.student_id
            
            #Enter student info
            replace = Hash.new
            on_attendance_master = @stu.attendance.enrolled_days ? true : false
            replace["[enrolled]"]           = @stu.attendance.enrolled_days.length      if on_attendance_master
            replace["[excused]"]            = @stu.attendance.excused_absences.length   if on_attendance_master
            replace["[first_name]"]         = @stu.first_name.value
            replace["[grade]"]              = @stu.grade.value
            replace["[last_name]"]          = @stu.last_name.value
            replace["[primary_teacher]"]    = @stu.primary_teacher.value
            replace["[school_enroll_date]"] = @stu.school_enroll_date.value
            replace["[school_year]"]        = $school.current_school_year.value
            replace["[studentid]"]          = @stu.studentid
            replace["[unexcused]"]          = @stu.attendance.unexcused_absences.length if on_attendance_master
            replace["[effective_date]"]     = wd_record ? wd_record.fields["effective_date"].value : DateTime.now.strftime("%Y-%m-%d")
            
            recorded = false
            until recorded
                word = $base.word
                begin
                    doc  = word.Documents.Open("#{$paths.templates_path}student_individual_withdrawal_report.docx")
                    replace.each_pair{|f,r|
                        word.Selection.HomeKey(unit=6)
                        find = word.Selection.Find
                        find.Text = f
                        while word.Selection.Find.Execute
                            word.Selection.TypeText(text=r.to_s) if r
                        end
                    }
                    
                    #Enter Academic Progress
                    records = @stu.academic_progress
                    if records
                        word.Selection.EndKey(6)
                        table = doc.Tables.Add(word.Selection.Range, records.length, 2)
                        table.Borders.Enable = true
                        row_num = 1
                        records.each{|row|
                            column_num = 1
                            row.each{|field|
                                table.Cell(row_num, column_num).Range.Text = field if field
                                column_num += 1
                            }
                            row_num+=1
                        }
                    end
                    
                    #Save to Intact File for Karen to copy
                    file_path = $config.init_path("#{$paths.reports_path}Withdrawals/Student_Records/#{$ifilestamp}") #FNORD - TIMESTAMP FUNCTION NEEDED HERE
                    doc_path = "#{file_path}STUDENT_#{@stu.studentid}_#{$ifilestamp}.docx"
                    if wd_record && wd_record.fields["initiator"].value == "Attendance_Reports" && wd_record.fields["type"].value == "General Ed Truancy"
                        file_path = $config.init_path("#{file_path}Truancy")
                        doc_path = "#{file_path}STUDENT_#{@stu.studentid}_#{$ifilestamp}.docx"
                    end
                    
                    sleep 5
                 
                    doc.SaveAs(doc_path.gsub("/","\\"))
                    recorded = true
                rescue => e
                    puts e.message
                    p e.backtrace
                    puts "Find and Replace in Word Doc Failed! Retrying..."
                    retry_index +=1
                    word.Quit if word
                    break if retry_index == 3
                end
            end
            
            if wd_record
                wd_record.fields["grades_documented"].value = true 
                wd_record.fields["status"           ].value = "Report Generated" 
                wd_record.fields["complete"         ].value = true 
                wd_record.save
            end
            
            doc.close
            word.quit
            
           # Print Report
            #shell = WIN32OLE.new('Shell.Application')
            #shell.ShellExecute(doc_path, '', '', 'print', 0)
            return true
        #else
        #    puts "Student not Eligible: #{@stu.studentid}"
        #    wd_record.fields["grades_documented"].value = false if wd_record
        #    wd_record.fields["complete"].value = true if wd_record
        #    wd_record.save if wd_record
        #    return false
        #end
        
    end
    
    def eligible_record
        $tables.attach("Withdrawing").withdrawing_eligible_record(student_id)
    end
    
    def pending_record
        $tables.attach("Withdrawing").withdrawing_pending_record(student_id)
    end
    
    def processed_record
        $tables.attach("Withdrawing").withdrawing_processed_record(student_id)
    end
    
    def completed_records
        $tables.attach("Withdrawing").withdrawing_completed_records(student_id)
    end
    
    def retracted_records
        $tables.attach("Withdrawing").withdrawing_retracted_records(student_id)
    end
    
    def student
        structure["student"]
    end

    def student_id
        student.student_id
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
    
    def student=(arg)
        structure["student"] = arg
    end

end