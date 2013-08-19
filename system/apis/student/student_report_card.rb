#!/usr/local/bin/ruby

class Student_Report_Card
    
    #---------------------------------------------------------------------------
    def initialize(student_object)
        @structure   = nil
        self.student = student_object
        @sender      = "report_cards"
        @records     = nil
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+    
    
    def content(records)
        content = String.new
        content << header
        subjects = Hash.new
        if records
            records.each{|record|
                fields  = record.fields
                subject = "#{fields["subject"  ].value}"
                term    = fields["term"     ].value
                if !subjects.has_key?(subject)
                    subjects[subject] = {
                        "Q1" => {:teacher => nil, :mark => nil, :comment => nil},
                        "Q2" => {:teacher => nil, :mark => nil, :comment => nil},
                        "Q3" => {:teacher => nil, :mark => nil, :comment => nil},
                        "Q4" => {:teacher => nil, :mark => nil, :comment => nil},
                        "S1" => {:teacher => nil, :mark => nil, :comment => nil},
                        "S2" => {:teacher => nil, :mark => nil, :comment => nil},
                        "Yr" => {:teacher => nil, :mark => nil, :comment => nil}
                    }
                end
                teacher = fields["teacher"].value.gsub(" ","").split(",") if fields["teacher"].value
                subjects[subject][term][:teacher] = "#{teacher[1]} #{teacher[0]}" if fields["teacher"].value
                subjects[subject][term][:mark   ] = fields["mark"   ].value
                subjects[subject][term][:comment] = fields["comment"].value
            } 
        end
        subjects.each_pair{|subject, details|
            teachers = String.new
            details.each_value{|v| teachers << (teachers.empty? ? "#{v[:teacher]}" : " & #{v[:teacher]}") if v[:teacher] && !teachers.include?(v[:teacher])}
            content << "#{line}\n#{subject} - #{teachers}\n  Marks:\n"
            comments = "  Comments:\n"
            details.each_pair{|k,v|
                content  << "    #{k}: #{v[:mark]}\n" if !v[:mark].nil?
                comment = v[:comment].gsub("<br>","\n      *").gsub("ƒ??","'") if ! v[:comment].nil?
                comments << "    #{k}:\n      *#{comment}\n" if ! v[:comment].nil?
            }
            content << comments if comments.split("  Comments:\n").length > 1
        }
        
        content << footer
        
        content.gsub!("Yr","Overall"  )
        content.gsub!("Q1","Quarter One")
        content.gsub!("Q2","Quarter Two")
        content.gsub!("Q3","Quarter Three")
        content.gsub!("S1","First Semester")
        
        puts @subject
        puts "\n#{content}\n\n\n"
        return content
    end
    
    def line
        "------------------------------------------------------------------"
    end
    
    #def queue_kmail(subject, blurb = nil, sample = false)
    #    params = Hash.new
    #    params[:db                  ] = "athena20112012" if !sample
    #    params[:sender              ] = "#{@sender}:tv"
    #    params[:subject             ] = subject
    #    params[:content             ] = content.insert(0, blurb ? "#{blurb}\n\n" : "")
    #    params[:recipient_studentid ] = student.studentid
    #    $base.queue_kmail(params)
    #end
    
    def queue_kmail(subject, blurb = nil, sample = false)
        sender  = "office_admin"
        subject = subject
        content_x = content.insert(0, blurb ? "#{blurb}\n\n" : "")
        student.queue_kmail(subject, content_x, sender)
        $students.detach(student.studentid)
    end
    
    def exists?
        answer = false
        answer = true if @records = $tables.attach("Report_Card").by_studentid_old(student.studentid)
        return answer
    end

    def header
        results = String.new 
        results << "Agora Cyber Charter School\n"
        results << "School Report Card #{$school_year}\n"
        results << "#{student.first_name.value} #{student.last_name.value}\n"
        results << "#{student.grade.value}\n"
        results << "ID: #{student.studentid}\n"
        gpa_record = $tables.table("Report_Card_GPA").by_studentid_old(student.studentid)
        results << "GPA: #{gpa_record.fields["gpa"].value}\n" if gpa_record
        return results 
    end
    
    def footer
        "\nIf you have any questions please contact your subject area teacher.\n"
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
    
    def student
        structure["student"]
    end
    
    def student=(arg)
        structure["student"] = arg
    end
    
end