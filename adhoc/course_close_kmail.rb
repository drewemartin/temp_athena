#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Course_Close_Kmail < Base
    
    def initialize()
        super()
        generate_kmails
    end
    
    def generate_kmails
        sender  = "office_admin"
        subject = "Completion of Elective Courses"
        message = "Dear Family,
Way to go! We have identified that your student completed their <<course>> course. As a result, this course will be removed from your student's course list within three days. Please let your teacher know if this is a problem.
Thank you,
Agora Administration"
        csv_path = "#{$paths.imports_path}kmail/APR_K-6_CloseOut.csv"
        CSV.open(csv_path, "rb").each do |row|
            course  = row[1]
            content = message.gsub("<<course>>", course)
            student = $students.attach(row[0])
            student.queue_kmail(subject, content, sender)
            $students.detach(row[0])
        end
    end
end

Course_Close_Kmail.new