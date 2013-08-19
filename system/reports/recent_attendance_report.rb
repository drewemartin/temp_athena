#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Recent_Attendance_Report < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        recent_attendance_report
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def recent_attendance_report(x_schooldays = 7)
        #get student data
        unexcused_absences = Hash.new
        students = $students.current_students
        students.each{|sid|
            puts sid
            student = $students.attach(sid)
            unexcused_absences[sid] = Hash.new
            unexcused_absences[sid]["grade"] = student.grade.value
            unexcused_absences[sid]["unexcused_absences"] = student_absences = student.attendance.unexcused_absences_for_previous_x(x_schooldays) || {}
            $students.detach(sid)
        }
        
        output = {
            "k-6"=>{
                "1"     => 0,
                "2"     => 0,
                "3"     => 0,
                "4+"    => 0   
            },
            "7-9"=>{
                "1"     => 0,
                "2"     => 0,
                "3"     => 0,
                "4+"    => 0  
            },
            "10-12"=>{
                "1"     => 0,
                "2"     => 0,
                "3"     => 0,
                "4+"    => 0  
            }
        }
        unexcused_absences.each_pair{|sid, record|
            grade           = record["grade"]
            num_absences    = record["unexcused_absences"].length
            grade_group     = "k-6"     if grade.match(/K|1st|2nd|3rd|4th|5th|6th/)
            grade_group     = "7-9"     if grade.match(/7th|8th|9th/)
            grade_group     = "10-12"   if grade.match(/10th|11th|12th/)
            if num_absences == 1
                output[grade_group]["1"] += 1
            elsif num_absences == 2
                output[grade_group]["2"] += 1
            elsif num_absences == 3
                output[grade_group]["3"] += 1
            elsif num_absences >= 20 
                output[grade_group]["4+"] += 1
            end 
        }
        
        excel = WIN32OLE::new('excel.Application')
        book  = excel.Workbooks.Open("#{$config.import_path}attendance/templates/recent_attendance.xlsx")
        sheet = book.worksheets("recent_attendance")
        
        sheet.range("b3").value = output["k-6"]["1"]
        sheet.range("c3").value = output["k-6"]["2"]
        sheet.range("d3").value = output["k-6"]["3"]
        sheet.range("e3").value = output["k-6"]["4+"]
        
        sheet.range("b4").value = output["7-9"]["1"]
        sheet.range("c4").value = output["7-9"]["2"]
        sheet.range("d4").value = output["7-9"]["3"]
        sheet.range("e4").value = output["7-9"]["4+"]
        
        sheet.range("b5").value = output["10-12"]["1"]
        sheet.range("c5").value = output["10-12"]["2"]
        sheet.range("d5").value = output["10-12"]["3"]
        sheet.range("e5").value = output["10-12"]["4+"]
        
        file_path = $config.init_path("#{$paths.reports_path}Attendance/Recent_Attendance")
        save_path = "#{file_path}RECENTATT_#{$ifilestamp}.xlsx"
        book.SaveAs(save_path.gsub("/","\\"))
        excel.Quit
        $team.email_senior_team("Weekly Attendance #{$idate}", "Please find the attached 'Recent Attendance' report", priority = nil, attachments = save_path)
    end
    
end

Recent_Attendance_Report.new