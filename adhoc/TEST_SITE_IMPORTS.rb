#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class TEST_SITE_IMPORTS < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    
    student_tests
    
  end
  #---------------------------------------------------------------------------

  def student_tests
    
    CSV.open($paths.imports_path+"student_site_assignments.csv","rb").each{|row|
      
      sid                 = row[0]
      site_name           = row[1]
      
      test_event_id       = "2"
      test_type           = "K-6 Face To Face Assessment"
      test_subject        = "General"
      test_event_site_id  = site_name ? $tables.attach("TEST_EVENT_SITES").by_site_name(site_name, test_event_id).primary_id : nil
      
      test_record         = $tables.attach("student_tests").new_row
      
      test_record.fields["student_id"         ].value = sid
      test_record.fields["test_type"          ].value = test_type
      test_record.fields["test_subject"       ].value = test_subject
      test_record.fields["test_event_site_id" ].value = test_event_site_id
      
      test_record.save
      
    }
    
  end
  
  def site_staff
    
    staff_not_found = Array.new
    
    CSV.open($paths.imports_path+"staff_site_assignments.csv","rb").each{|row|
      
      site_name           = row[0]
      fname               = row[1]
      lname               = row[2]
      role                = row[3]
      
      if staff_id            = $team.by_k12_name(fname+" "+lname).sams_id.value
        
        test_event_id       = "2"
        test_event_site_id  = $tables.attach("TEST_EVENT_SITES").by_site_name(site_name, test_event_id).primary_id
        
        site_staff_record   = $tables.attach("TEST_EVENT_SITE_STAFF").new_row
        
        site_staff_record.fields["test_event_site_id" ].value = test_event_site_id
        site_staff_record.fields["staff_id"           ].value = staff_id
        site_staff_record.fields["role"               ].value = role
        
        site_staff_record.save
        
      else
        
        staff_not_found.push(fname+" "+lname)
        
      end
      
    }
    
    staff_not_found.each{|x|
      puts x
    }
    
  end
  
end

TEST_SITE_IMPORTS.new(ARGV)