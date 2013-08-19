#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class K6_Progress_Q1 < Base

    #---------------------------------------------------------------------------
    def initialize()
        super()
        @structure = nil
        blank_record = $tables.attach("K6_Progress_Courses").new_row
        file_path = "#{$config.import_path}k6_progress_q1/K6_Progress_Q1.csv"
        skip = true
        csv_field_names = Array.new
        CSV.open( file_path , 'r' ) do |csv_row|
            if skip
                csv_row.each{|field|
                    csv_field_names.push(field)
                }
            else
                progress_records = Hash.new 
                i = 2
                until i == 9
                    progress_records[csv_field_names[i]] = csv_row[i]
                    i+=1
                end
                progress_records.each_pair{|k,v|
                    blank_record.clear
                    blank_record.fields["student_id"            ].value = csv_row[0]        
                    blank_record.fields["course_subject_school" ].value = k         
                    blank_record.fields["progress"              ].value = v
                    blank_record.fields["teacher_name"          ].value = csv_row[1] 
                    blank_record.fields["term"                  ].value = "Q1"
                    blank_record.save
                }
            end
            skip = false
        end
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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

K6_Progress_Q1.new