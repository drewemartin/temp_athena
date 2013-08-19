#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Attendance_Rollup_Report < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        ftc_attendance_rate_current
        #ftc_attendance_rates_over_time_chart
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def ftc_attendance_rate_current #returns an array ("FTC K12 Name","Attendance Rate Roll-Up")
        rows = Array.new
        $team.ftcs.each{|ftc_k12_name|
            ftc = $team.by_k12_name(ftc_k12_name)
            att_whole = ftc.students.length
            att_part  = 0
            ftc.students.each{|sid|
                #attendance rate
                att_part = att_part + $students.attach(sid).attendance.rate_decimal
                students.detach(sid)
            }
            rows.push([ftc_k12_name, "#{(att_part/att_whole*100).round.to_s}%"])
        }
        location = "Metrics/FTC_Metrics"
        filename = "FTC_ATTENDANCE"
        $reports.csv(location, filename, rows)
    end
    
    def ftc_attendance_rates_over_time_chart 
        header_row = ["Week Ending"]
        rows = Array.new
        #$team.ftcs.each{|ftc_k12_name|
            #ftc = $team.by_k12_name(ftc_k12_name)
            attedance_over_time_ranges.each{|range|
                start_date = range[:start]
                end_date   = range[:end]
                date_rate_row = Array.new
                $team.ftcs.each{|ftc_k12_name|
                    header_row.push(ftc_k12_name) if !header_row.include?(ftc_k12_name)
                    ftc = $team.by_k12_name(ftc_k12_name)
                    
                    att_whole = 0
                    att_part  = 0
                    ftc.students.each{|sid|
                        #attendance rate
                        student_rate = $students.attach(sid).attendance.rate_by_range_decimal(start_date, end_date)
                        if student_rate
                            att_part  = att_part + student_rate
                            att_whole = att_whole + 1
                        end
                        students.detach(sid)
                    }
                    if att_part == 0 || att_whole == 0
                        puts "stop"
                    end
                    if att_whole > 0
                        ftc_att_rate = "#{(att_part/att_whole*100).round.to_s}%"
                        date_rate_row.push(end_date) if !date_rate_row.include?(end_date)
                        date_rate_row.push(ftc_att_rate)  
                    end
                    #USE FOR TESTING SMALLER BATCHES
                    #break if $team.ftcs.index(ftc_k12_name) == 0
                }
                rows.push(date_rate_row) if date_rate_row.length > 0
            }
        #}
        rows.insert(0,header_row)
        location = "Metrics/FTC_Metrics"
        filename = "FTC_ATTENDANCE"
        $reports.csv(location, filename, rows)
    end
    
    def ftc_attendance_rates_over_time_by_ftc #this will report with ftc's in first column, one column each for weeking ending dates
        header_row = ["Week Ending"]
        rows = Array.new
        #$team.ftcs.each{|ftc_k12_name|
            #ftc = $team.by_k12_name(ftc_k12_name)
            attedance_over_time_ranges.each{|range|
                start_date = range[:start]
                end_date   = range[:end]
                date_rate_row = Array.new
                $team.ftcs.each{|ftc_k12_name|
                    header_row.push(ftc_k12_name) if !header_row.include?(ftc_k12_name)
                    ftc = $team.by_k12_name(ftc_k12_name)
                    
                    att_whole = 0
                    att_part  = 0
                    ftc.students.each{|sid|
                        #attendance rate
                        student_rate = $students.attach(sid).attendance.rate_by_range_decimal(start_date, end_date)
                        if student_rate
                            att_part  = att_part + student_rate
                            att_whole = att_whole + 1
                        end
                        students.detach(sid)
                    }
                    if att_part == 0 || att_whole == 0
                        puts "stop"
                    end
                    if att_whole > 0
                        ftc_att_rate = "#{(att_part/att_whole*100).round.to_s}%"
                        date_rate_row.push(end_date) if !date_rate_row.include?(end_date)
                        date_rate_row.push(ftc_att_rate)  
                    end
                    #USE FOR TESTING SMALLER BATCHES
                    #break if $team.ftcs.index(ftc_k12_name) == 0
                }
                rows.push(date_rate_row) if date_rate_row.length > 0
            }
        #}
        rows.insert(0,header_row)
        location = "Metrics/FTC_Metrics"
        filename = "FTC_ATTENDANCE"
        $reports.csv(location, filename, rows)
    end
    
    def attedance_over_time_ranges #returns and array of hashes (start_date=>date,end_date=>value)
        ranges        = Array.new
        previous_week = 0
        day_field = $field.new({"type"=>"date","value"=>nil})
        school_days = $school.school_days($idate)
        first_start_date = school_days[0]
        last_end_date    = school_days[-1]
        day_field.value  = first_start_date
        complete = false
        until complete
            this_week = day_field.mathable.strftime("%W")
            if this_week != previous_week && this_week != "00"
                ranges.push({:start=>nil,:end=>nil}) if this_week != previous_week
                previous_week = this_week
            end   
            ranges[ranges.length-1][:start] = day_field.value if day_field.mathable.strftime("%a") == "Mon" || day_field.value == first_start_date
            ranges[ranges.length-1][:end]   = day_field.value if day_field.mathable.strftime("%a") == "Fri" || day_field.value == last_end_date
            complete  = true if day_field.value == last_end_date
            day_field.add!
        end
        return ranges
    end
    
    def weekly_attendance_report 
        #get student data
        unexcused_absences = $students.unexcused_absences_current_students
        output = {
            "k-6"=>{
                "<3"    => 0,
                "3-9"   => 0,
                "10-19" => 0,
                "20+"   => 0   
            },
            "7-9"=>{
                "<3"    => 0,
                "3-9"   => 0,
                "10-19" => 0,
                "20+"   => 0
            },
            "10-12"=>{
                "<3"    => 0,
                "3-9"   => 0,
                "10-19" => 0,
                "20+"   => 0
            }
        }
        unexcused_absences.each_pair{|sid, record|
            grade           = record["grade"]
            num_absences    = record["unexcused_absences"].length
            grade_group     = "k-6"     if grade.match(/K|1st|2nd|3rd|4th|5th|6th/)
            grade_group     = "7-9"     if grade.match(/7th|8th|9th/)
            grade_group     = "10-12"   if grade.match(/10th|11th|12th/)
            if num_absences < 3
                output[grade_group]["<3"] += 1
            elsif num_absences >= 3 && num_absences <= 9
                output[grade_group]["3-9"] += 1
            elsif num_absences >= 10 && num_absences <= 19
                output[grade_group]["10-19"] += 1
            elsif num_absences >= 20 
                output[grade_group]["20+"] += 1
            end 
        }
        
        excel = WIN32OLE::new('excel.Application')
        book  = excel.Workbooks.Open("#{$config.import_path}templates/weekly_attendance.xlsx")
        sheet = book.worksheets("weekly_attendance")
        
        sheet.range("b3").value = output["k-6"]["<3"]
        sheet.range("c3").value = output["k-6"]["3-9"]
        sheet.range("d3").value = output["k-6"]["10-19"]
        sheet.range("e3").value = output["k-6"]["20+"]
        
        sheet.range("b4").value = output["7-9"]["<3"]
        sheet.range("c4").value = output["7-9"]["3-9"]
        sheet.range("d4").value = output["7-9"]["10-19"]
        sheet.range("e4").value = output["7-9"]["20+"]
        
        sheet.range("b5").value = output["10-12"]["<3"]
        sheet.range("c5").value = output["10-12"]["3-9"]
        sheet.range("d5").value = output["10-12"]["10-19"]
        sheet.range("e5").value = output["10-12"]["20+"]
        
        file_path = $config.init_path("#{$paths.reports_path}Attendance/Weekly_Overview")   
        save_path = "#{file_path}WEEKLYATT_#{$ifilestamp}.xlsx"
        
        book.SaveAs(save_path.gsub("/","\\"))
        excel.Quit
        $team.email_senior_team("Weekly Attendance #{$idate}", "Please find the attached attendance report", priority = nil, attachments = save_path)
    end
    
end

Attendance_Rollup_Report.new