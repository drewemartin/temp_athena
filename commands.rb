#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/system/base/base"
require "csv"

class Athena_Commands < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  def set_actives_to_most_recent_relation
    a = Time.now
    
    student_relate = $tables.attach("student_relate")
    
    roles_string_formatted = String.new
    
    roles = [
      'Learning Center Classroom Coach',
      'Family Teacher Coach',
      'Truancy Prevention Coordinator'
    ]
    roles.each_with_index do |role, index|
      if roles[index] == roles.last
        roles_string_formatted << "'#{role}'"
      else
        roles_string_formatted << "'#{role}',"
      end
    end
    
    
    
    active_pids_without_most_recent_relation = student_relate.field_values("PRIMARY_ID","WHERE active IS TRUE AND role IN (#{roles_string_formatted})")
    counter = 0
    active_pids_without_most_recent_relation.each do |pid|
      student_relate.by_primary_id(pid).fields["most_recent_relation"].set(true).save
      counter += 1
    end
    
    c = Time.now
    puts "#{counter} rows affected in #{(c - a).round} seconds"
    
  end
  
  def set_past_withdrawn_students_most_recent_relations
    a = Time.now
    student_relate = $tables.attach("student_relate")
    
    roles_string_formatted = String.new
    
    roles = [
      'Learning Center Classroom Coach',
      'Family Teacher Coach',
      'Truancy Prevention Coordinator'
    ]
    roles.each_with_index do |role, index|
      if roles[index] == roles.last
        roles_string_formatted << "'#{role}'"
      else
        roles_string_formatted << "'#{role}',"
      end
    end
    
    currently_active_sids = student_relate.field_values("studentid","WHERE active IS TRUE
                                                        AND most_recent_relation IS TRUE
                                                        AND role IN (#{roles_string_formatted})
                                                        GROUP BY studentid")

    withdrawing_sids = $tables.attach('withdrawing').field_values("student_id","WHERE student_id
                                                                  NOT IN (#{currently_active_sids.join(',')})
                                                                  GROUP BY student_id")
    
    puts "size of withdrawing_sids: #{withdrawing_sids.size}"
    
    

    pids_to_set_to_most_recent_relation = Array.new
    sids_with_no_selected_roles = Array.new
    withdrawing_sids.each_with_index do |sid, index|
      any_roles = $db.get_data("SELECT role
                                FROM student_relate
                                WHERE studentid = #{sid}
                                AND role IN (#{roles_string_formatted})
                                AND created_date >= '2014-07-01'",
                                "agora_master")
      if any_roles
        roles.each do |role|
          role_specific_pids = student_relate.field_values("PRIMARY_ID","WHERE studentid = '#{sid}'
                                                          AND role = '#{role}'
                                                          AND created_date >= '2014-07-01'
                                                          ORDER BY created_date DESC")
          if role_specific_pids
            this_years_pids_via_zz_table = $db.get_data("SELECT modified_pid
                                            FROM zz_student_relate
                                            WHERE modified_pid
                                            IN (#{role_specific_pids.join(',')})
                                            AND modified_date > '2014-07-01'
                                            ORDER BY modified_date DESC","agora_master")
            if this_years_pids_via_zz_table && !this_years_pids_via_zz_table.first.empty?
              puts "this_years_pids_via_zz_table structure: #{this_years_pids_via_zz_table}"
              this_years_pids_via_zz_table = this_years_pids_via_zz_table[0][0]
              if !pids_to_set_to_most_recent_relation.include?(this_years_pids_via_zz_table)
                pids_to_set_to_most_recent_relation << this_years_pids_via_zz_table
                student_relate.by_primary_id(this_years_pids_via_zz_table).fields['most_recent_relation'].set(true).save
              end 
            end
          end
        end
        withdrawing_sids.delete_at(index)
        next
      else
        sids_with_no_selected_roles << sid
        withdrawing_sids.delete_at(index)
        next
      end
    end
    
    puts "Total PIDs Affected: #{pids_to_set_to_most_recent_relation.size}"
    puts "Total Time: #{(Time.now - a).round} seconds"
  end
  
  def test_hermes_servers
    hermes_servers = ["2"]#["2","3","4","5"]
    active_servers = Array.new
    
    #Check that Athena can reach the mysqld server for each of the hermes computers.
    #Only send to those that connect successfully
    ping = Hash.new
    hermes_servers.each do |server|
        begin
            ping[server] = Mysql::new()     #pass in creds here, obviously           
            active_servers << server if ping[server]
            puts "Connected successfully to server \##{server}." if ping[server]
        rescue Mysql::Error => e
            puts "Connection to server \##{server} failed!"
            $base.system_notification(  "Hermes #{server} server down!",
                                            "Hermes server at IP address #{server} is down. Check that the machine is on and that the mysqld server is running.
                                            <br>
                                            <br>
                                            Error message: #{e.message}")
            next
        end
    end
    active_servers = active_servers.uniq
    num_servers = active_servers.length
    
    puts "There #{num_servers == 1 ? "is" : "are"} #{num_servers} Hermes server#{num_servers == 1 ? "" : "s"} running."
    if num_servers == 0
      $base.system_notification("All Hermes kmail servers are down!",
                                "Athena is unable to connect to any of the Hermes mysqld servers. There are kmails waiting to be dispatched!")
    end
    selected_db = "agora_20142015"
    active_servers.each do |server|
      ping[server].select_db(selected_db).query("INSERT INTO kmail_test (master_pid, student_id,sender,subject,content,sending,successful,error,created_by)
                         VALUES ('856','1193','drowan','testing remote db insert!!!!','It works!',TRUE,TRUE,NULL,'Dave!')")
      last_insert_obj = ping[server].query("SELECT LAST_INSERT_ID();")
      last_insert = ping[server].query("SELECT LAST_INSERT_ID();").fetch_row[0]
      puts last_insert_obj.class
      puts last_insert
      puts ". . . . ."
    end
    
  end
  
  def fix_student_attendance_mode
    puts "Beginning process"
    puts time_began = Time.now
    puts
    
    stud_attendance = $tables.attach("STUDENT_ATTENDANCE")
    attendance_records = stud_attendance.records("WHERE date = '2014-12-01' AND mode = 'No Live Sessions'")# AND student_id = '1193'")
    num_records =  attendance_records.length
    
    attendance_modes = $tables.attach("STUDENT_ATTENDANCE_MODE")
    i = 0
    loop_time_every_1000 = Time.now
    
    attendance_records.each do |attendance_record|
      sid = attendance_record.fields["student_id"].value
      
      stud_mode = attendance_modes.by_student_id(sid)
      stud_mode = stud_mode.fields["attendance_mode"].value
    
      attendance_record.fields["mode"].value = stud_mode
      #attendance_record.save
      i += 1
      if i % 20 == 1
        print "~"
      elsif i % 1000 == 0
        puts
        puts
        puts "#{i}/#{num_records} records updated"
        puts "#{(Time.now - time_began)/60} minutes elapsed"
        puts "Approximately #{((Time.now - loop_time_every_1000)/60)*((num_records - i)/1000)} minutes remaining" ##This calculates a little off
        loop_time_every_1000 = Time.now                                                                           ##One loop seems to be missed
      end                                                                                                         ##So that last loop says 0 minutes remaining
    
    end
    
    puts
    puts
    puts "#{i}/#{num_records} records updated"
    puts "Process completed"
    puts time_completed = Time.now
    puts "#{(time_completed - time_began)/60} minutes elapsed"
  end
  
  def add_new_student_tests
    csv_path = "#{$paths.imports_path}student_tests_upload.csv"
    student_tests_table = $tables.attach("student_tests")
    
    #test_id = "5"
    row_num = 1
    successful = 0
    failure = 0
    CSV.open(csv_path, "rb").each do |csv_row|
      
      if row_num == 1
        row_num += 1
        next    ##skip row of headers
      end
      sid = csv_row[0]
      stud_test_pid = csv_row[1]
      test_event_site_id = csv_row[2]
      
      st_record = student_tests_table.by_primary_id(stud_test_pid)
       
      if st_record
        if st_record.fields["student_id"].value == sid
          if test_event_site_id
            st_record.fields["test_event_site_id"].set(test_event_site_id).save
            records_updated += 1
          end
        else
          puts "Student ID #{sid} does not match record with PID #{stud_test_pid} at row #{row_num}."
        end
      else 
        puts "There is no student tests record with PID #{stud_test_pid}. Reference row: #{row_num}"
      end
      row_num += 1
      if records_updated%100==0 && records_updated != 0
        puts "#{records_updated} records updated"
      end
      if row_num%100 == 0
        puts "iterated over #{row_num} rows so far"
      end
    end
    
    puts "#{records_updated} records updated/#{row_num-1} rows"
  end
  
  def update_student_test_site_selection
    puts Time.now
    file_name = "student_tests_site_selection_upload.csv"
    file_path = "#{$paths.imports_path}#{file_name}"
    #puts file_path
    stud_tests = $tables.attach("STUDENT_TESTS")
    
    row_num = 1
    successful = 0
    failure = 0
    
    CSV.open(file_path,"rb").each do |csv_row|
      
      if row_num == 1
        row_num += 1
        next      ##skip headers
      end
      
      test_pid = csv_row[0]
      sid = csv_row[1]
      test_event_site_id = csv_row[2]
      
      unless test_pid && sid && test_event_site_id
        puts "Missing info on row #{row_num}"
        failure += 1
        row_num += 1
        puts ". . . skipping this row. . ."
        next          ##skip this row because there is missing data (blank csv cells)
      end
      
      if record = stud_tests.by_primary_id(test_pid)
        if record.fields["student_id"] == sid
          record.fields["test_event_site_id"].value = test_event_site_id
          #record.save
          successful += 1
        else
          puts "Student ID #{sid} on row #{row_num} does not match entry with PID #{test_pid}"
          failure += 1
        end
      else
        puts "No test with PID #{test_pid} at row #{row_num}"
        failure += 1
      end
      row_num += 1
      
      if row_num % 100 == 2 && row_num != 2
        puts "#{row_num} rows reviewed, #{successful} successful saves, #{failure} failures"
      end
    end
    
    puts "#{row_num - 2} rows reviewed, #{successful} successful saves, #{failure} failures"
    puts Time.now
  end
  
  def add_test_event_site_staff
    puts Time.now
    
    file_name = "test_event_staff_upload.csv"
    file_path = "#{$paths.imports_path}#{file_name}"
    #puts file_path
    test_site_staff = $tables.attach("TEST_EVENT_SITE_STAFF")
    
    row_num = 1
    successful = 0
    failure = 0
    
    CSV.open(file_path, "rb").each do |csv_row|
      
      if row_num == 1
        row_num += 1
        next        ##skip the headers
      end
      
      team_id = csv_row[0]
      test_event_site_id = csv_row[1]
      role = csv_row[2]
      
      unless team_id && test_event_site_id && role
        puts "Missing info on row #{row_num}"
        failure += 1
        row_num += 1
        puts ". . . skipping this row. . ."
        next          ##skip this row because there is missing data (blank csv cells)
      end
      
      unless test_site_staff.records("WHERE test_event_site_id = '#{test_event_site_id}'
                                                        AND team_id = '#{team_id}'
                                                        AND role = '#{role}'")
        record = test_site_staff.new_row
        record.fields["team_id"].value = team_id
        record.fields["test_event_site_id"].value = test_event_site_id
        record.fields["role"].value = role
        #record.save
        successful += 1
      else
        puts "Duplicate record at row #{row_num}"
        failure += 1
      end
      row_num += 1
      
      if row_num % 100 == 2 && row_num != 2
        puts "#{row_num - 2} rows reviewed, #{successful} successful saves, #{failure} failures"
      end
    end
    
    puts "#{row_num - 2} rows reviewed, #{successful} successful saves, #{failure} failures"
    puts Time.now
  end
  
  
  
  def update_team_table_with_department_ids
    
    $db.query(
      "INSERT INTO department (name, type, focus, head_team_id)
      (SELECT department, department_category, department_focus, primary_id
      FROM team 
      WHERE department IS NOT NULL
      AND employee_type REGEXP 'Director|Principal'
      GROUP BY department)"
    )
    
    $db.query(
      "UPDATE team
      LEFT JOIN department ON department = name
      SET department = department.PRIMARY_ID"
    )
    
    #IN TEAM TABLE DEPARTMENT FIELD
    #REMOVE INDEX 
    #CHANGE THE DEPARTMENT FIELD TYPE TO INT(11)
    #REMOVE COLLATION
    #CHANGE THE NAME TO DEPARTMENT_ID
    #CHANGE DEFAULT TO NONE
    #ADD INDEX
    
    #IN ZZ_TEAM TABLE DEPARTMENT FIELD
    #REMOVE INDEX 
    #CHANGE THE DEPARTMENT FIELD TYPE TO INT(11)
    #REMOVE COLLATION
    #CHANGE THE NAME TO DEPARTMENT_ID
    #CHANGE DEFAULT TO NONE
    #ADD INDEX
    
  end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  def ap_attendance_notice_ap_attendance(att_date = $idate)
    
    require "#{File.dirname(__FILE__)}/system/data_processing/attendance_ap"
    ap_att_process = Attendance_AP.new
    ap_att_process.notice_ap_attendance(att_date)
    
  end
  
  def ap_attendance_create_attendance_records(att_date = $idate)
    
    require "#{File.dirname(__FILE__)}/system/data_processing/attendance_ap"
    ap_att_process = Attendance_AP.new
    ap_att_process.create_attendance_records(att_date)
    
  end

  def attendance_ap_daily_setup
    
    require "#{File.dirname(__FILE__)}/system/data_processing/attendance_ap"
    ap_att_process = Attendance_AP.new
    ap_att_process.create_attendance_records(att_date = $idate)
    ap_att_process.notice_ap_attendance(att_date = $idate, staff_ids_override = nil)
    
  end
  
  def team_evaluation_summary_setup(team_ids = nil)
    
    #$tables.attach("TEAM_EVALUATION_SUMMARY").drop if $tables.attach("TEAM_EVALUATION_SUMMARY").exists?
    #$tables.attach("TEAM_EVALUATION_SUMMARY").init
    #
    team_ids = team_ids || $team.related_to_students
    team_ids.each{|team_id|
      
      t = $team.by_sams_id(team_id)
      
      if t
        
        if students = t.enrolled_students
          
          new                                 = t.enrolled_students(:new_students_only          =>true)
          in_year                             = t.enrolled_students(:enrolled_after_date        =>$school.current_school_year_start.value)
          low_income                          = t.enrolled_students(:free_reduced               =>true)
          tier_23                             = t.enrolled_students(:tier                       =>"Tier 2|Tier 3")
          special_ed                          = t.enrolled_students(:special_ed                 =>true)
          grades_712                          = t.enrolled_students(:grade                      =>"7th|8th|9th|10th|11th|12th")
          
          scantron_eligible                   = t.enrolled_students(:scantron_eligible          =>true)
          if scantron_eligible 
            scantron_participation_fall       = t.enrolled_students(:scantron_eligible          =>true, :scantron_participated      =>["stron_ent_perf_m","stron_ent_perf_r"])
            scantron_participation_spring     = t.enrolled_students(:scantron_eligible          =>true, :scantron_participated      =>["stron_ext_perf_m","stron_ext_perf_r"])
            scantron_performance_fall         = nil
            scantron_performance_spring       = nil
            scantron_growth                   = nil 
          end
          
          aimsfall_event_ids                  = $db.get_data_single("SELECT primary_id FROM test_events WHERE name REGEXP 'Aims Fall'")
          if aimsfall_event_ids
            aimsfall_eligible                 = t.enrolled_students(:test_event_participated    =>aimsfall_event_ids)
            aimsfall_participated             = t.enrolled_students(:test_event_eligible        =>"aims") 
          end
          
          aimsspring_event_ids                = $db.get_data_single("SELECT primary_id FROM test_events WHERE name REGEXP 'Aims Spring'")
          if aimsspring_event_ids
            aimsspring_eligible               = t.enrolled_students(:test_event_participated    =>aimsspring_event_ids)
            aimsspring_participated           = t.enrolled_students(:test_event_eligible        =>"aims") 
          end
          
          aims_growth                         = nil
          study_island_participation          = nil
          study_island_participation_tier_23  = nil
          study_island_blue_ribbon            = nil
          study_island_blue_ribbon_tier_23    = nil
          define_u_participation              = nil
          pssa_participation                  = nil
          
          keystone_event_ids                  = $db.get_data_single("SELECT primary_id FROM test_events WHERE name REGEXP 'Keystone'")
          if keystone_event_ids
            keystone_eligible                 = t.enrolled_students(:test_event_participated    =>keystone_event_ids)
            keystone_participated             = t.enrolled_students(:test_event_eligible        =>"keystone") 
          end
          
          attendance_rates                    = t.enrolled_students(:student_table=>"student_attendance_master", :table_field=>"attendance_rate", :value_only=>true)
          all_students                        = t.assigned_students 
          
          #RETENTION RATE CALCULATION#############################################################################
          #get withdrawn students who did not withdraw for one of the following reasons:
            
            #"6" ,        #Student illegally absent (10 consecutive days) & compulsory attendance is not being pursued	
            #"7" ,        #Issued General Employment Certificate	                                                        
            #"12",        #Committed to correctional institution	                                                        
            #"13",        #Enlisted in military service	                                                                
            #"17",        #Expelled	                                                                                        
            #"24",        #Over 17 and voluntarily leaving school after passing required attendance age (17 or older)	        
            #"25",        #Under 17 and not continuing education at this time and has discussed options with Agora Personnel	
            #"26",        #Plan to pursue GED	                                                                                
            #"27",        #Runaway or Student No Longer at Residence	                                                        
            #"28"        #Whereabouts of family unknown (Residency Compliance)                                              
            
            withdrawn_students = t.assigned_students(:withdrawal_codes=>
              
              [
               
                "6" ,        #Student illegally absent (10 consecutive days) & compulsory attendance is not being pursued	
                "7" ,        #Issued General Employment Certificate	                                                        
                "12",        #Committed to correctional institution	                                                        
                "13",        #Enlisted in military service	                                                                
                "17",        #Expelled	                                                                                        
                "24",        #Over 17 and voluntarily leaving school after passing required attendance age (17 or older)	        
                "25",        #Under 17 and not continuing education at this time and has discussed options with Agora Personnel	
                "26",        #Plan to pursue GED	                                                                                
                "27",        #Runaway or Student No Longer at Residence	                                                        
                "28"         #Whereabouts of family unknown (Residency Compliance)   
                
              ]
              
            )
            retention_rate = withdrawn_students ? students.length.to_f/(withdrawn_students.length.to_f+students.length.to_f) : nil
            
          ########################################################################################################
          
          
          
          engagement_levels                   = t.enrolled_students(:engagement_eligible=>true, :student_table=>"student_assessment", :table_field=>"engagement_level", :value_only=>true )
          
          summary_record  = t.evaluation_summary.existing_record || t.evaluation_summary.new_record
          summary_record.fields["students"                                 ].value = students.length
          summary_record.fields["all_students"                             ].value = all_students.length if all_students
          summary_record.fields["new"                                      ].value = new        ?         new.length.to_f  / students.length.to_f : 0
          summary_record.fields["in_year"                                  ].value = in_year    ?     in_year.length.to_f  / students.length.to_f : 0
          summary_record.fields["low_income"                               ].value = low_income ?  low_income.length.to_f  / students.length.to_f : 0
          summary_record.fields["tier_23"                                  ].value = tier_23    ?     tier_23.length.to_f  / students.length.to_f : 0
          summary_record.fields["special_ed"                               ].value = special_ed ?  special_ed.length.to_f  / students.length.to_f : 0
          summary_record.fields["grades_712"                               ].value = grades_712 ?  grades_712.length.to_f  / students.length.to_f : 0
          
          if scantron_eligible
            summary_record.fields["scantron_participation_fall"            ].value = scantron_eligible ? (scantron_participation_fall   ? scantron_participation_fall.length.to_f   / scantron_eligible.length.to_f : 0) : 0
            summary_record.fields["scantron_participation_spring"          ].value = scantron_eligible ? (scantron_participation_spring ? scantron_participation_spring.length.to_f / scantron_eligible.length.to_f : 0) : 0
            summary_record.fields["scantron_performance_fall"              ].value = nil
            summary_record.fields["scantron_performance_spring"            ].value = nil
            summary_record.fields["scantron_growth"                        ].value = nil
          end
          
          if aimsfall_event_ids
            summary_record.fields["aims_participation_fall"                ].value = aimsfall_eligible ? (aimsfall_participated ? aimsfall_participated.length/aimsfall_eligible.length : 0) : 0
          end
          
          if aimsspring_event_ids
            summary_record.fields["aims_participation_spring"              ].value = aimsspring_eligible ? (aimsspring_participated ? aimsspring_participated.length/aimsspring_eligible.length : 0) : 0
          end
          
          summary_record.fields["aims_growth"                              ].value = nil
          summary_record.fields["study_island_participation"               ].value = nil
          summary_record.fields["study_island_participation_tier_23"       ].value = nil
          summary_record.fields["study_island_blue_ribbon"                 ].value = nil
          summary_record.fields["study_island_blue_ribbon_tier_23"         ].value = nil
          summary_record.fields["define_u_participation"                   ].value = nil
          summary_record.fields["pssa_participation"                       ].value = nil
          
          if keystone_event_ids
            summary_record.fields["keystone_participation"                 ].value = keystone_eligible ? (keystone_participated ? keystone_participated.length.to_f/keystone_eligible.length.to_f : 0) : 0
          end
          
          summary_record.fields["attendance_rate"                          ].value = attendance_rates ? eval(attendance_rates.join("+"))/attendance_rates.length.to_f : 0
          summary_record.fields["retention_rate"                           ].value = retention_rate
          summary_record.fields["engagement_level"                         ].value = engagement_levels ? eval(engagement_levels.join("+"))/engagement_levels.length.to_f : 0
          
          summary_record.save
          
        end
        
      end
      
    }
    
  end

  def import_fc_tracker
    
    dates     = Hash.new
    first_row = true
    
    CSV.open($paths.imports_path+"sample_tracker_import2.csv","rb").each{|row|
      
      if first_row
        
        first_row = false
        
        index = 0
        row.each{|column|
          
          dates[index] = row[index]
          index += 1
          
        }
       
      else
        
        sid                       = row[0]
        welcome_call_column       = row[1]
        initial_home_visit_column = row[2]
        
        welcome_call              = false
        initial_home_visit        = false
        
        index = 0
        row.each{|column|
          
          if index >=3 && !column.nil?
            
            #POSSIBLE VALUES:
            #  Call Completed
            #  Call Attempted
            #  F2F Completed
            #  F2F Attempted
            #  Other Completed
            #  Other Attempted
            #  Mailing Completed
            
            record = $tables.attach("student_contacts").new_row
            
            record.fields["student_id"          ].value = sid
            record.fields["datetime"            ].value = dates[index]
            record.fields["successful"          ].value = true              if column.match("Completed")
            
            record.fields["contact_type"        ].value = "Phone Call"      if column.match("Call")
            record.fields["contact_type"        ].value = "Home Visit"      if column.match("F2F")
            record.fields["contact_type"        ].value = "Mailing"         if column.match("Mailing")
            record.fields["contact_type"        ].value = "Virtual Meeting" if column.match("Other")
            
            if !welcome_call_column.nil? && !welcome_call && column.match("Call")
              
              welcome_call = true if column.match("Completed")
              record.fields["welcome_call"  ].value = true
              
            end
            
            if !initial_home_visit_column.nil? && !initial_home_visit && column.match("F2F")
              
              initial_home_visit = true if column.match("Completed")
              record.fields["initial_home_visit"  ].value = true
              
            end
            
            record.save
            
          end
          
          first_column = false
          index += 1
          
        }
        
      end
      
      
    }
    
  end
  
  def monthly_attendance_kmail(student_id, start_date, end_date)
    absences = $students.attach(student_id).attendance.unexcused_absences_by_range(start_date, end_date)
    
    if absences.empty?
      
      subject = "Congratulations for your Perfect Attendance between #{date_usr(start_date)} and #{date_usr(end_date)}"
      content =
"Congratulations! Agora Cyber Charter School is writing to notify you that |student.firstname| achieved perfect attendance between #{date_usr(start_date)} and #{date_usr(end_date)}.
Please know every Agora staff member is here to assist you as we partner for a wonderful educational experience for |student.firstname|.
Thank you very much for your attention to ensuring your student is attending school on a daily basis. 
Agora's Attendance Office"
      $students.attach(student_id).queue_kmail(subject, content, sender = "attendance_reports")
      
    else
      
      date_values = absences.keys
      
      usr_frndly_dates = Array.new
      date_values.each{ |datee|
        newdate = date_usr(datee)
        usr_frndly_dates.push(newdate)
      }
      
      joined_dates = usr_frndly_dates.join(", ")
      subject = "Attendance Report from #{date_usr(start_date)} to #{date_usr(end_date)}"
      content =
"Hello,

We are writing to inform you of the attendance record for |student.firstname|. From #{date_usr(start_date)} to #{date_usr(end_date)} the following was recorded as unexcused:  #{joined_dates} 
Thank you very much for your attention to ensuring your student is attending school on a daily basis.  If a written excuse is not received within three days of the absence, the absence is permanently added to the student's file.  However if you believe these dates are in error, please feel free to contact the Attendance Office and we will be happy to review the specifics with you.

A few reminders about attendance:

-You can contact the Attendance Office by sending a kmail to Attendance Office under the administrator account or call 610-263-8541.  Please know we can not adjust attendance over the phone.

-A Synchronous Learner is expected to log into their online courses and live sessions each school day.

-An Asynchronous Learner is expected to login in their online courses each school day.

-In grades 9-12 the student must log in under their own student id to be considered present for online courses and live sessions.

-When sending in a kmail to excuse dates, please include your child's first and last name. If you have it readily available, please also include your child's student ID#.

-If a student accumulates three unexcused absences, you will be invited to a Truancy Elimination Prevention (TEP) meeting by your Family Coach and Agora must notify the school district which in turn may notify the magisterial district judge. 

-At 10 consecutive unexcused days we are required to withdraw a student from Agora. 

Our school wants to help you avoid any further absences or clear up any concerns.
We have supports that are available to you and your family, please contact us if we can assist you. We share a common goal to ensure that your child reaches their full potential.

If you have any questions, please contact kmail Attendance Office (under the Administrator account).

"
      $students.attach(student_id).queue_kmail(subject, content, sender = "attendance_reports")
    end
    
  end

  def districtss
    CSV.foreach("#{$paths.imports_path}district_update.csv")do |row|
      #new_row = []
      district_name = row[0]
      district_addr1 = row[1]
      district_addr2 = row[2]
      city = row[3]
      state = row[4]
      zipcode = row[5]
      district_table = $tables.attach("districts").by_district(district_name, "Attendance")
      
      
      district_table.fields["district"].value = district_name
      district_table.fields["district_addr1"].value = district_addr1
      district_table.fields["district_addr2"].value = district_addr2
      district_table.fields["city"].value = city
      district_table.fields["state"].value = state
      district_table.fields["zipcode"].value = zipcode
      old_district_table = $tables.attach("districts").by_district(district_name,"Attendance") 
      if old_district_table

      district_table.fields["contact_department"].value = old_district_table.fields["contact_department"].value
      district_table.fields["contact_first_name"].value = old_district_table.fields["contact_first_name"].value
      district_table.fields["contact_last_name"].value = old_district_table.fields["contact_last_name"].value
      district_table.fields["contact_email"].value = old_district_table.fields["contact_email"].value
      district_table.fields["contact_phone"].value = old_district_table.fields["contact_phone"].value
      district_table.fields["contact_fax"].value = old_district_table.fields["contact_fax"].value
      district_table.fields["active"].value = old_district_table.fields["active"].value
      
      else
        
        district_table.fields["contact_department"].value = "Attendance"
      end
      district_table.save
    end
  end
  
  def team_relate_region
   all_rows = Array.new
   headers = Array.new
   
   headers.push("region","family_coach_id","family_coach_program_support_id","truancy_prevention_id","advisor_id")
   CSV.foreach("#{$paths.imports_path}team_relate_region.csv")do|row|
      new_row       = []
      advisor_rows  = Array.new
      
      region                          = row[0]
      family_coach_id                 = $team.by_k12_name(row[1]) ? $team.by_k12_name(row[1]).samsid.value : row[1]
      family_coach_program_support_id = $team.by_k12_name(row[2]) ? $team.by_k12_name(row[2]).samsid.value : row[z]
      truancy_prevention_id           = $team.by_k12_name(row[3]).samsid.value     
      advisor_id                      = row[4]
      
      splitt      = advisor_id.split(",")
      splitt.each {|id1|
        staff_table_new = $team.by_k12_name(id1)
        samsid_advisor = staff_table_new.samsid.value
        advisor_rows.push(samsid_advisor)
      } 
      
      staff_table = $team.by_k12_name(fid)
      samsid_family_coach = staff_table.samsid.value
      new_row.push(region,family_coach_id, family_coach_program_support_id,truancy_prevention_id,advisor_rows.join(", "))
      all_rows.push(new_row)
   end
   path = "team"
   filename = "team_relate_region"
   $reports.csv(path, filename, all_rows.insert(0,headers))
  end
  
  def team_relate_grade_change
    all_rows = Array.new
    headers = Array.new
    headers.push("sams_id","grade","role")
    CSV.foreach("#{$paths.imports_path}team_relate_grade_level.csv")do|row|
      new_row = []
      sid = row[0]
      staff_table = $team.by_k12_name(sid)
      samsidd = staff_table.samsid.value
      new_row.push(samsidd, row[1], row[2])
      all_rows.push(new_row)
    end
    path = "team"
    filename = "team_relate_grade_level"
    $reports.csv(path, filename, all_rows.insert(0,headers))
  end
  
  def undo_changes
    #GET ATTENDANCE MASTER PID AND FIELD NAME OF RELEVANT RECORDS
    effected_change_records = $db.get_data(
      "SELECT
        modified_pid,
        modified_field
      FROM zz_attendance_master
      LEFT JOIN attendance_master
        ON modified_pid = attendance_master.primary_id
      LEFT JOIN student
        ON attendance_master.student_id = student.student_id
      WHERE
        modified_date REGEXP '2012-09-12' AND
        modified_by = 'Athena-SIS' AND
        student.grade REGEXP '7th|8th|9th|10th|11th|12th'
      GROUP BY CONCAT(modified_pid,modified_field)"
    )
    
    if effected_change_records
      effected_change_records.each{|changed_record|
        modfied_pid     = changed_record[0]
        modified_field  = changed_record[1]
        original_value  = nil
        
        #GET ALL HISTORICAL RECORDS
        audit_record_pids = $db.get_data(
          "SELECT
            primary_id
          FROM zz_attendance_master
          WHERE
            modified_pid    = '#{modfied_pid}'    AND
            modified_field  = '#{modified_field}' AND
            modified_date REGEXP '2012-09-12'     AND
            modified_by     = 'Athena-SIS'
          ORDER BY modified_date DESC"
        )
        
        if audit_record_pids
          #GET THE ORIGINAL VALUE IF ATHENA MADE THE CHANGE, OR LAST HUMAN MADE CHANGE
          audit_record_pids.each{|audit_pid|
            changed_date      = $db.get_data_single("SELECT modified_date FROM zz_attendance_master WHERE primary_id = #{audit_pid}")[0]
            last_changed_by   = last_change(modfied_pid, after_datetime = changed_date)
            if last_changed_by == "Athena-SIS"
              original_value = $db.get_data_single("SELECT `#{modified_field}` FROM zz_attendance_master WHERE primary_id = '#{audit_pid}'")[0]
            else
              break
            end
          }
        end
        
        #SAVE THE ORIGINAL VALUE
        if original_value
          att_record = $tables.attach("attendance_master").by_primary_id(modfied_pid)
          att_record.fields[modified_field].value = original_value
          att_record.save
        end
        
      }
      
    end
  end
  
  def last_change(pid, after_datetime = nil)
    after_datetime_string = after_datetime ? " AND modified_date > '#{after_datetime}'" : nil
    sql_string =
      "SELECT
        modified_by
      FROM zz_attendance_master
      WHERE modified_pid = '#{pid}'
      #{after_datetime_string}"
    results = $db.get_data_single(sql_string)
    return results ? results[0] : false
  end
  

end

Athena_Commands.new(ARGV)
