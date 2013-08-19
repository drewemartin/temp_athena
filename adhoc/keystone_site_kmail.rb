#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Keystone_Site_Kmail < Base
    
    def initialize()
        super()
        @kmail_hash = Hash.new
        generate_kmails
        queue_kmails
    end
    
    def student_site_pids
        return $db.get_data_single(
            "SELECT
                student_tests.primary_id
            FROM test_event_sites LEFT JOIN student_tests ON student_tests.test_event_site_id = test_event_sites.primary_id
            WHERE test_event_sites.start_date = '2012-12-04'"
        )
    end
    
    def generate_kmails
        student_site_pids.each do |pid|
            
            letter = File.read("#{$paths.templates_path}kmail/keystone_test_content.txt")
            
            student_test_row    = $tables.attach("Student_Tests").by_primary_id(pid)
            
            sid                 = student_test_row.fields["student_id"          ].value
            subject             = student_test_row.fields["test_subject"        ].value
            test_event_site_id  = student_test_row.fields["test_event_site_id"  ].value
            
            test_event_site_row = $tables.attach("Test_Event_Sites").by_primary_id(test_event_site_id)
            
            start_time          = test_event_site_row.fields["start_time"   ].value
            end_time            = test_event_site_row.fields["end_time"     ].value
            if test_event_site_row.fields["special_notes"].value
                special_notes   = test_event_site_row.fields["special_notes"].value
            else
                special_notes   = "N/A"
            end
            site_id             = test_event_site_row.fields["test_site_id" ].value
            
            site_row            = $tables.attach("Test_Sites").by_primary_id(site_id)
            
            site                = site_row.fields["region"   ].value
            address             = site_row.fields["address"         ].value
            city                = site_row.fields["city"            ].value
            state               = site_row.fields["state"           ].value
            zip                 = site_row.fields["zip_code"        ].value
            
            site_address        = "#{address}
#{city}, #{state} #{zip}"
            
            if site_row.fields["site_url"        ].value
                site_url        = site_row.fields["site_url"        ].value
            else
                site_url        = ""
            end
            if site_row.fields["directions"      ].value
                directions      = site_row.fields["directions"      ].value
            else
                directions      = "N/A"
            end
            
            letter.gsub!("<<site>>",            site)
            letter.gsub!("<<subject>>",         subject)
            letter.gsub!("<<site_date>>",       "December 4th 2012")
            letter.gsub!("<<start_time>>",      start_time)
            letter.gsub!("<<est_end_time>>",    end_time)
            letter.gsub!("<<site_address>>",    site_address)
            letter.gsub!("<<site_url>>",        site_url)
            letter.gsub!("<<Directions>>",      directions)
            letter.gsub!("<<Special Notes>>",   special_notes)
            @kmail_hash[sid] = letter
        end
    end

    def queue_kmails
        sender  = "office_admin"
        subject = "Winter Keystone Testing Reminder"
        @kmail_hash.each_pair do |k,v|
            student = $students.attach(k)
            content = v
            student.queue_kmail(subject, content, sender)
            $students.detach(k)
        end
    end
    
end

Keystone_Site_Kmail.new