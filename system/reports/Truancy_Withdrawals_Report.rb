#!/usr/local/bin/ruby

class Truancy_Withdrawals_Report

    #---------------------------------------------------------------------------
    def initialize()
        
        
    end
    #---------------------------------------------------------------------------
   
    def generate(cutoff = $base.yesterday.iso_date, official_report = false, exception_students = [], student_list = nil)
        
        location    = "Truancy_Withdrawal"
        filename    = "truancy_withdrawal"
        rows        = Array.new
        
        school_days = $school.school_days(cutoff)
        if school_days
            truancy_span = school_days.slice(-10, 10)
            if truancy_span
                student_list = $students.list(:currently_enrolled=>true) if !student_list
                student_list.each{|sid|
                    if !exception_students.include?(sid)
                        #IGNORE STUDENTS WHO ARE UNDER REVIEW
                        student   = $students.attach(sid)
                        absences  = student.attendance.unexcused_absences
                        if absences && absences.length >= 10
                          
                            num_within_truancy_span = 0
                            truancy_dates           = Array.new
                            
                            absences.each{|date|
                                if truancy_span.include?(date)
                                    num_within_truancy_span += 1 
                                    truancy_dates.push(date)
                                end
                            }
                            
                            if num_within_truancy_span >= 10
                                puts sid
                                withdrawal_record = $tables.attach("withdrawing").new_row
                                withdrawal_record.fields["student_id"                 ].value = sid             
                                withdrawal_record.fields["student_age"                ].value = student.age           
                                withdrawal_record.fields["initiated_date"             ].value = $idate        
                                withdrawal_record.fields["initiator"                  ].value = "Automated Process - Truancy Withdraw"
                                withdrawal_record.fields["relationship"               ].value = "Admin - Attendance"
                                withdrawal_record.fields["method"                     ].value = "Attendance Procedure"  
                                withdrawal_record.fields["agora_reason"               ].value = "6"           
                                withdrawal_record.fields["k12_reason"                 ].value = "SPA9"             
                                withdrawal_record.fields["type"                       ].value = "Truancy"                         
                                withdrawal_record.fields["status"                     ].value = "Requested"                               
                                withdrawal_record.fields["truancy_dates"              ].value = truancy_dates.sort.join(",")               
                                withdrawal_record.fields["effective_date"             ].value = truancy_span[-1]
                                rows.push(withdrawal_record)
                                if official_report
                                    #puts "Withdraw reporting turned off"
                                    withdrawal_record.save
                                else
                                    withdrawal_record.fields["status"                     ].value = "NOT REQUESTED" 
                                end
                              
                            end
                            
                        end
                        
                    end
                }
                
            end
            
        end
        
        if rows
            file_path = $reports.save_document({:csv_rows=>rows, :category_name=>"Truancy", :type_name=>"Truancy Withdrawal Report"})
            #$reports.move_to_athena_reports(file_path)
            return file_path
        else
            return false
        end
        
    end

end