#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Report_Cards_Mail_Merge < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        @blurb = "Congratulations on completing the 2011-2012 school year! Please contact your Guidance Counselor with any questions!  Have a wonderful summer! -Mrs. Jane Swan, High School Director"
        make_csv()
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def make_csv
        data = getData
        $reports.csv("report_card_mail_merge", "20112012rc_mm", data)
    end

    def getData
        all_rows = [headers]
        sids = $students.current_students
        #sids = []
        sids.each do |sid|
            data_row = []
            student = $students.attach(sid)
            if student.report_card.exists?
                puts sid
                grade = student.grade.to_user
                school_comment = @blurb
                first_name = student.first_name.to_user
                last_name = student.last_name.to_user
                address = student.mailing_address.to_user
                address << ", #{student.mailing_address_line_two.to_user}" if student.mailing_address_line_two.value == ""
                city = student.mailing_city.to_user
                state = student.mailing_state.to_user
                zip = student.mailing_zip.to_user
                school_year = $school.current_school_year.to_user
                days_present = student.attendance.attended_days.length
                absences_excused = student.attendance.excused_absences.length
                absences_unexcused = student.attendance.unexcused_absences.length
                data_row = [sid, grade, school_comment, days_present, absences_excused, absences_unexcused, school_year, first_name, last_name, address, city, state, zip]
                subjects = student.report_card.mail_merge_data
                subjects.each_pair{|subject, details|
                    course_grades = Hash.new{|h,k| h[k]=""}
                    details.each_pair{|term, info|
                        if !info[:teacher].nil?
                            @teacher = info[:teacher]
                            course_grades[term] = info[:mark]
                        end
                    }
                    course_array = [subject, @teacher, course_grades["Q1"], course_grades["Q2"], course_grades["S1"], course_grades["Q3"], course_grades["Q4"], course_grades["S2"], course_grades["Yr"]]
                    data_row = data_row + course_array
                }
                all_rows.push(data_row)
            end
            $students.detach(sid)
        end
        return all_rows
    end
    
    def headers
        output = [
            "studentid",
            "grade",
            "school_comments",
            "days_present",
            "absences_excused",
            "absences_unexcused",
            "school_year",
            "first_name",
            "last_name",
            "address",
            "city",
            "state",
            "zip",
            "course_1",	  "teacher_1",	"grade_q1_1",	"grade_q2_1",	"grade_s1_1",	"grade_q3_1",	"grade_q4_1",	"grade_s2_1",	"grade_yr_1",
            "course_2",	  "teacher_2",	"grade_q1_2",	"grade_q2_2",	"grade_s1_2",	"grade_q3_2",	"grade_q4_2",	"grade_s2_2",	"grade_yr_2",
            "course_3",	  "teacher_3",	"grade_q1_3",	"grade_q2_3",	"grade_s1_3",	"grade_q3_3",	"grade_q4_3",	"grade_s2_3",	"grade_yr_3",
            "course_4",	  "teacher_4",	"grade_q1_4",	"grade_q2_4",	"grade_s1_4",	"grade_q3_4",	"grade_q4_4",	"grade_s2_4",	"grade_yr_4",
            "course_5",	  "teacher_5",	"grade_q1_5",	"grade_q2_5",	"grade_s1_5",	"grade_q3_5",	"grade_q4_5",	"grade_s2_5",	"grade_yr_5",
            "course_6",	  "teacher_6",	"grade_q1_6",	"grade_q2_6",	"grade_s1_6",	"grade_q3_6",	"grade_q4_6",	"grade_s2_6",	"grade_yr_6",
            "course_7",	  "teacher_7",	"grade_q1_7",	"grade_q2_7",	"grade_s1_7",	"grade_q3_7",	"grade_q4_7",	"grade_s2_7",	"grade_yr_7",
            "course_8",	  "teacher_8",	"grade_q1_8",	"grade_q2_8",	"grade_s1_8",	"grade_q3_8",	"grade_q4_8",	"grade_s2_8",	"grade_yr_8",
            "course_9",	  "teacher_9",	"grade_q1_9",	"grade_q2_9",	"grade_s1_9",	"grade_q3_9",	"grade_q4_9",	"grade_s2_9",	"grade_yr_9",
            "course_10",  "teacher_10",	"grade_q1_10",	"grade_q2_10",	"grade_s1_10",	"grade_q3_10",	"grade_q4_10",	"grade_s2_10",	"grade_yr_10",
            "course_11",  "teacher_11",	"grade_q1_11",	"grade_q2_11",	"grade_s1_11",	"grade_q3_11",	"grade_q4_11",	"grade_s2_11",	"grade_yr_11",
            "course_12",  "teacher_12",	"grade_q1_12",	"grade_q2_12",	"grade_s1_12",	"grade_q3_12",	"grade_q4_12",	"grade_s2_12",	"grade_yr_12",
            "course_13",  "teacher_13",	"grade_q1_13",	"grade_q2_13",	"grade_s1_13",	"grade_q3_13",	"grade_q4_13",	"grade_s2_13",	"grade_yr_13",
            "course_14",  "teacher_14",	"grade_q1_14",	"grade_q2_14",	"grade_s1_14",	"grade_q3_14",	"grade_q4_14",	"grade_s2_14",	"grade_yr_14",
            "course_15",  "teacher_15",	"grade_q1_15",	"grade_q2_15",	"grade_s1_15",	"grade_q3_15",	"grade_q4_15",	"grade_s2_15",	"grade_yr_15",
            "course_16",  "teacher_16",	"grade_q1_16",	"grade_q2_16",	"grade_s1_16",	"grade_q3_16",	"grade_q4_16",	"grade_s2_16",	"grade_yr_16",
            "course_17",  "teacher_17",	"grade_q1_17",	"grade_q2_17",	"grade_s1_17",	"grade_q3_17",	"grade_q4_17",	"grade_s2_17",	"grade_yr_17",
            "course_18",  "teacher_18",	"grade_q1_18",	"grade_q2_18",	"grade_s1_18",	"grade_q3_18",	"grade_q4_18",	"grade_s2_18",	"grade_yr_18",
            "course_19",  "teacher_19",	"grade_q1_19",	"grade_q2_19",	"grade_s1_19",	"grade_q3_19",	"grade_q4_19",	"grade_s2_19",	"grade_yr_19",
            "course_20",  "teacher_20",	"grade_q1_20",	"grade_q2_20",	"grade_s1_20",	"grade_q3_20",	"grade_q4_20",	"grade_s2_20",	"grade_yr_20",
            "course_21",  "teacher_21",	"grade_q1_21",	"grade_q2_21",	"grade_s1_21",	"grade_q3_21",	"grade_q4_21",	"grade_s2_21",	"grade_yr_21",
            "course_22",  "teacher_22",	"grade_q1_22",	"grade_q2_22",	"grade_s1_22",	"grade_q3_22",	"grade_q4_22",	"grade_s2_22",	"grade_yr_22",
            "course_23",  "teacher_23",	"grade_q1_23",	"grade_q2_23",	"grade_s1_23",	"grade_q3_23",	"grade_q4_23",	"grade_s2_23",	"grade_yr_23",
            "course_24",  "teacher_24",	"grade_q1_24",	"grade_q2_24",	"grade_s1_24",	"grade_q3_24",	"grade_q4_24",	"grade_s2_24",	"grade_yr_24",
            "course_25",  "teacher_25",	"grade_q1_25",	"grade_q2_25",	"grade_s1_25",	"grade_q3_25",	"grade_q4_25",	"grade_s2_25",	"grade_yr_25"
        ]
        return output
    end
end

Report_Cards_Mail_Merge.new