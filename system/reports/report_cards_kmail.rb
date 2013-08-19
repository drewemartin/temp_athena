#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class REPORT_CARDS_KMAIL < Base

  #---------------------------------------------------------------------------
  def initialize()
    super()
    
    #KMAIL DETAILS:
    sender   = "office_admin"
    subject  = "Quarter 3 Progress Report"
    
    blurb    = ""
    
#    blurb =
#"Due to an error in the system, some grades were not reflected accurately in your previous k-mail report of your semester 2 grades.  Below you will find your corrected grades.  We apologize for the inconvenience.
#
#Congratulations on completing the 2011-2012 school year! Please contact your Guidance Counselor with any questions! 
#Have a wonderful summer!
#Mrs. Jane Swan, High School Director"
#    ms_blurb =
#"Congratulations on completing the 2011-2012 school year! Please contact your Guidance Counselor with any questions! 
#Have a wonderful summer!
#Mrs. Jane Swan, High School Director"
#    fa_blurb =
#"Congratulations on completing the 2011-2012 school year! Please contact your Guidance Counselor with any questions! 
#Have a wonderful summer!
#Mrs. Jane Swan, High School Director" 
#    hs_blurb =
#"Congratulations on completing the 2011-2012 school year! Please contact your Guidance Counselor with any questions! 
#Have a wonderful summer!
#Mrs. Jane Swan, High School Director" 
    
    #FOR ADHOC:
    sids = [
    ]
    #FOR BATCH
    #sids = $students.current_students if sids.empty?
    sids = $db.get_data("
SELECT student_id
FROM `k12_omnibus`
WHERE (grade = '7th Grade'
OR grade = '8th Grade')
AND schoolenrolldate IS NOT NULL
AND schoolenrolldate <= CURDATE()
AND enrollapproveddate IS NOT NULL
ORDER BY grade, student_id"
).flatten
    
    sids.each{|sid|
      if records = $tables.attach("Jupiter_Grades").by_studentid_old(sid)

        #if ["127163","27097","604586","214823","814610","814613"].include?(sid)
        #  blurb = "\nPlease continue to complete Incomplete assignments throughout the 2nd Semester.  All assignments must be completed by the end of the school year."
        #else
        #  blurb = ""
        #end
        s = $students.attach(sid)
        grades_content = s.report_card.content(records)
        content = grades_content.insert(0, blurb ? "#{blurb}\n\n" : "")
        
        s.queue_kmail(subject, content, sender)
        
        $students.detach(sid)
        
      end
      
    }
  end
  #---------------------------------------------------------------------------
  
end

REPORT_CARDS_KMAIL.new