#!/usr/local/bin/ruby


class DOWNLOAD_TEST
    #---------------------------------------------------------------------------
    def initialize()
        @testing = false
    end
    #---------------------------------------------------------------------------
    def load
        
    end
    
    def response
        snap_students = $tables.attach("K12_Omnibus").snap_students
        csv_string = StringIO.new
        CSV::Writer.generate(csv_string, ',') do |csv|
            snap_students.each{|row|
                csv << row
            }
        end
        return csv_string
    end
    
end
