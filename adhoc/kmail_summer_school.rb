#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Kmail_Summer_School < Base
  def initialize()
    super()
    parse_csv
    kmail_content
    queue_kmails
    puts "Done"
  end
  
  def parse_csv
    @grades_hash = Hash.new{|h,k| h[k] = [] }
    CSV.foreach("#{$paths.imports_path}kmail/summer_school_grades.csv") do |row|
      if !row.first.nil? && row.first.match(/\d/)
        @grades_hash[row.first] << row
      end
    end
  end
  
  def kmail_content
    @kmail_hash = Hash.new
    @grades_hash.each_pair do |k,v|
      student = $students.attach(k)
      grades_text = String.new
      v.each do |grade_row|
        grades_text << "#{grade_row[7]} -- #{grade_row[3]}\n"
      end
      courseorcourses = v.length > 1 ? "Below are your summer school courses and the corresponding grade." : "Below is your summer school course and the corresponding grade."
      content =
"
#{student.first_name.value} #{student.last_name.value}
#{student.mailing_address.value} #{student.mailing_address_line_two.value if student.mailing_address_line_two}
#{student.mailing_city.value}, #{student.mailing_state.value} #{student.mailing_zip.value}

#{$idate}

Dear #{student.first_name.value},

It is my hope that you had a wonderful and productive summer. #{courseorcourses}

#{grades_text}

Your credits are being added to your High School transcripts. Please contact your Guidance Counselor with any questions.

Sincerely,

Jane Swan
High School Principal

"
    @kmail_hash[k] = content
    $students.detach(k)
    end
  end
  
  def queue_kmails
    sender              = "office_admin"
    subject             = "Summer School Grades"
    @kmail_hash.each_pair do |k,v|
      student = $students.attach(k)
      content             = v
      student.queue_kmail(subject, content, sender)
      $students.detach(k)
    end
  end
end

Kmail_Summer_School.new
