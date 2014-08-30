#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class Queue_Kmails < Base

    def initialize()
        
    end

    def mass_kmail(subject, message, sender, csv_path, block_reply)
        
        queue({:subject=>subject,:message=>message, :sender=>sender, :csv_path=>csv_path, :block_reply=>block_reply})
        
    end
    
    def testing_reminder(test_event_site_id, subject, message, csv_path, block)
        
        kmail_hash = Hash.new
        sender     = "office_admin"
        
        CSV.open(csv_path, "rb").each do |csv_row|
            
            sid = csv_row[0]
            
            letter = "#{message}"
            
            subjects = String.new
            
            test_subject_ids = $tables.attach("STUDENT_TESTS").field_values("test_subject_id", "WHERE student_id = '#{sid}' AND test_event_site_id = '#{test_event_site_id}' AND test_subject_id IS NOT NULL").each_with_index do |test_subject_id,i|
                
                subjects << " & " if i != 0
                subjects << $tables.attach("TEST_SUBJECTS").by_primary_id(test_subject_id).fields["name"].value
                
            end if test_subject_ids
            
            test_event_site_row = $tables.attach("Test_Event_Sites").by_primary_id(test_event_site_id)
            
            start_date          = test_event_site_row.fields["start_date"    ].to_user
            start_time          = test_event_site_row.fields["start_time"    ].value
            end_time            = test_event_site_row.fields["end_time"      ].value
            special_notes       = test_event_site_row.fields["special_notes" ].value || "N/A"
            site_id             = test_event_site_row.fields["test_site_id"  ].value
            
            site_row            = $tables.attach("Test_Sites").by_primary_id(site_id)
            
            site                = site_row.fields["region"                   ].value
            facility            = site_row.fields["facility_name"            ].value
            address             = site_row.fields["address"                  ].value
            city                = site_row.fields["city"                     ].value
            state               = site_row.fields["state"                    ].value
            zip                 = site_row.fields["zip_code"                 ].value
            site_address        = "#{address}
#{city}, #{state} #{zip}"
            site_url            = site_row.fields["site_url"                 ].value || ""
            directions          = site_row.fields["directions"               ].value || "N/A"
            
            letter.gsub!("%%site%%",                    site         ) if site
            letter.gsub!("%%subject%%",                 subjects     ) if subjects
            letter.gsub!("%%site_date%%",               start_date   ) if start_date
            letter.gsub!("%%start_time%%",              start_time   ) if start_time
            letter.gsub!("%%est_end_time%%",            end_time     ) if end_time
            letter.gsub!("%%name_of_facility%%",        facility     ) if facility
            letter.gsub!("%%site_address%%",            site_address ) if site_address
            letter.gsub!("%%site_url%%",                site_url     ) if site_url
            letter.gsub!("%%Directions%%",              directions   ) if directions
            letter.gsub!("%%Special Notes%%",           special_notes) if special_notes
            
            kmail_hash[sid] = letter
            
        end
        
        queue({:kmail_hash=>kmail_hash, :subject=>subject, :message=>message, :sender=>sender, :block_reply=>block, :log_id=>"test_reminders__test_event_site_id__#{test_event_site_id}"})
        
    end
    
    def queue(a)#subject, message, sender, csv_path, block, log_id, kmail_hash
        
        kmail_ids = Array.new
        
        if a[:kmail_hash]
            
            a[:kmail_hash].each_pair do |k,v|
                
                student = $students.attach(k)
                content = v
                kmail_ids << student.queue_kmail(a[:subject], content, a[:sender], a[:block_reply])
                $students.detach(k)
                
            end
            
        elsif a[:csv_path]
            
            CSV.open(a[:csv_path], "rb").each do |csv_row|
                
                sid        = csv_row[0]
                student    = $students.attach(sid)
                kmail_ids << student.queue_kmail(a[:subject], a[:message], a[:sender], a[:block_reply])
                $students.detach(sid)
                
            end
            
        else
            
            return false
            
        end
        
        kmail_ids_sql_str = kmail_ids.map{|x| "'#{x}'"}.join(",")
        
        duplicate_kmails = $db.get_data("SELECT primary_id FROM `kmail` WHERE primary_id IN(#{kmail_ids_sql_str}) AND error = 'DUPLICATE DETECTED'") || []
        
        kmail_log = $tables.attach("Kmail_Log").new_row
        
        kmail_log.fields["kmail_ids"   ].value = kmail_ids.join(",")
        kmail_log.fields["subject"     ].value = a[:subject]
        kmail_log.fields["message"     ].value = a[:message]
        kmail_log.fields["credential"  ].value = a[:sender]
        kmail_log.fields["block_reply" ].value = a[:block_reply]
        kmail_log.fields["identifier"  ].value = a[:log_id]
        kmail_log.fields["user_message"].value = "#{duplicate_kmails.length} duplicate k-mail#{duplicate_kmails.length == 1 ? "":"s"} #{duplicate_kmails.length == 1 ? "was":"were"} detected and #{duplicate_kmails.length == 1 ? "was":"were"} not sent."
        
        kmail_log.save
        
    end
    
end