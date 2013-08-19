#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Weekly_Attendance_Report < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        weekly_attendance_report
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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

Weekly_Attendance_Report.new