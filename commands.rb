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
    grade_hash = {
            :grade_k => true, :grade_1st=>true,     :grade_2nd=>true,   :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true,
            :grade_6th=>true, :grade_7th=>true,     :grade_8th=>true,
            :grade_9th=>true, :grade_10th=>true,    :grade_11th=>true,  :grade_12th=>true,
        }
    x = {:name=>"mcap_read_to_student"                  }.merge(grade_hash)
    x
    $tables.attach("SAPPHIRE_STUDENTS").after_load_k12_withdrawal
    
    #$tables.attach("K12_STAFF").one_to_one_setup
    
    #MAKE SURE THAT ALL ACTIVE STUDENTS HAVE ALL ONE TO ONE RELATIONSHIP RECORDS
    #$tables.attach("student").re_initialize(:backup_only=>true)
    
    #test = $tables.attach("TEST_EVENTS").new_row
    #test.fields["name"      ].value = "test"
    #test.fields["test_id"   ].value = "1"
    #test.fields["start_date"].value = "2013-02-20"
    #test.fields["end_date"  ].value = "2013-05-23"
    #test.save
    
    $base.email
    
    #$tables.attach("STUDENT_COMMUNICATIONS").after_load_k12_omnibus
    #require 'github_api'
    #commit_path = 'https://api.github.com/repos/jeniferhalverson/k12/commits/73b5a6bb3f2e5406aaa2f83b230689879f9a329d'
    #github = Github.new :user => 'jeniferhalverson', :repo => 'k12'
    #github.repos.commits.all 'jeniferhalverson', 'k12'
    #test = Net::HTTP.new.get(commit_path)
    #http = Net::HTTP.new('https://api.github.com/repos/jeniferhalverson/k12/commits/73b5a6bb3f2e5406aaa2f83b230689879f9a329d', 443)
    #http.use_ssl = true
    #
    #http.start do |http|
    #  
    #  request = Net::HTTP::Get.new(source_address)
    #  request.basic_auth 'jhalverson', 'dxo84tbw'
    #  response = http.request(request)
    #  
    #end
    #before_load_team_evaluation_summary_snapshot(nil, "state_test_participation")
    
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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

  def before_load_team_evaluation_summary_snapshot(staff_ids = nil, summary_data_points = nil)
    
    start = Time.new
    puts right_now.to_user
    require "#{File.dirname(__FILE__)}/system/data_processing/team_evaluations_summary_update"
    
    p = Team_Evaluations_Summary_Update.new
    
    p.summary_update(                                       staff_ids, summary_data_points)
    p.metrics_update(                                       staff_ids)
    
    p.team_evaluation_summary_snapshot(                     staff_ids)
    p.team_evaluation_engagement_aab_snapshot(              staff_ids)
    p.team_evaluation_engagement_metrics_snapshot(          staff_ids)
    p.team_evaluation_engagement_observation_snapshot(      staff_ids)
    p.team_evaluation_engagement_professionalism_snapshot(  staff_ids)
    
    p.peer_group_evaluation_summary_snapshot
    p.department_evaluation_summary_snapshot
    puts right_now.to_user
    puts "Init completed in #{(Time.new - start)/60} minutes"
    puts ">-------------------------------------------------------->"
    
  end
  
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
  
  def import_team_member_peer_groups
    
    CSV.foreach("#{$paths.imports_path}team_member_peer_groups.csv")do|row|
      
      team_id       = row[0]
      peer_group_id = row[1]
      
      $team.get(team_id).peer_group_id.set(peer_group_id).save
      
    end
    
  end
  
  def import_testing_event_site_staff
    
    CSV.foreach("#{$paths.imports_path}pssa_site_staff.csv")do|row|
      
      site_name  = row[0]
      role       = row[1]
      staff_name = row[2]
      
      test_event_site_record = $tables.attach("TEST_EVENT_SITES").by_site_name(site_name)
      staff_record           = team.by_k12_name(staff_name)
      
      if test_event_site_record && staff_record
        
        test_event_site_id  = test_event_site_record.primary_id if test_event_site_record
        staff_id            = staff_record.samsid
        
        record = $tables.attach("test_event_site_staff").by_staff_id(staff_id, test_event_site_id, role)
        if !record
            
            record = $tables.attach("test_event_site_staff").new_row
            record.fields["test_event_site_id" ].value = test_event_site_id
            record.fields["staff_id"           ].value = staff_id.value
            record.fields["role"               ].value = role
            record.save
            
        end
        
      else
        
        puts staff_name
        
      end
      
    end
    
  end
  
  def import_testing_event_student_tests
    
    CSV.foreach("#{$paths.imports_path}pssa_student_tests.csv")do|row|
      
      student_id    = row[0]
      test_subject  = row[1]
      test_type     = "PSSA"
      
      stests_table  = $tables.attach("STUDENT_TESTS")
      
      record        = stests_table.by_studentid_old(student_id, test_subject, test_type) ||
      if !record
        
        record = stests_table.new_row
        record.fields["student_id"  ].value = student_id
        record.fields["test_subject"].value = test_subject
        record.fields["test_type"   ].value = test_type
        record.save
        
      end
      
    end
    
  end
  
  def correct_student_doc_path
    $tables.attach("student_documents").primary_ids.each{|pid|
      
      record =   $tables.attach("student_documents").by_primary_id(pid)
      x = record.fields["document_path"].value.split("/")[-1]
      record.fields["document_name"].value = x
      record.save
      
    }
  end
  
  def student_test_assignments_import
    
    CSV.foreach("#{$paths.imports_path}student_test_assignments_pssa_pasa.csv")do|row|
      
      if !$db.get_data_single(
        "SELECT
          primary_id
        FROM student_tests
        WHERE student_id  = '#{row[0]}'
        AND test_type     = '#{row[1]}'
        AND test_subject  = '#{row[2]}'"
      )
        
        s = $students.get(row[0])
        if s
          r = s.tests.new_record
          r.fields["test_type"    ].value = row[1]
          r.fields["test_subject" ].value = row[2]
          r.save
        else
          puts "SID NOT FOUND: "+row[0]
        end
        
      end
      
    end
    
  end
  
  def family_coach_supervisor_setup
    #found = 0
    #notfound = 0
    #x = $tables.attach("K12_omnibus").find_fields("primaryteacherid"," WHERE primaryteacher IS NOT NULL GROUP BY primaryteacherid",{:value_only=>true})
    #x.each{|samsid|
    #    slct_sql = "SELECT `family_coach_program_support_id`  FROM team_relate_region where family_coach_id = #{samsid}"
    #    super_sams = $db.get_data_single(slct_sql)
    #    if super_sams && (s = $team.by_sams_id(super_sams[0])   ) && (t = $team.by_sams_id(samsid)  )
    #      
    #        supervisor_id = (s.primary_id.value == t.primary_id.value) ? $team.by_sams_id("406477").primary_id.value : s.primary_id.value
    #        t.supervisor_team_id.set(   supervisor_id                                   ).save
    #        t.employee_type.set(        "Family Coach"                                  ).save
    #        t.department.set(           "Family Coaches"                                ).save
    #        t.department_category.set(  "Engagement"                                    ).save
    #        t.department_focus.set(     "Elementary School|Middle School|High School"   ).save
    #        t.title.set(                "Family Coach"                                  ).save
    #        found+=1
    #      
    #    elsif !super_sams && s = $team.by_sams_id("406477") && t = $team.by_sams_id(samsid)
    #     
    #        t.supervisor_team_id.set(   ""                                              ).save
    #        t.department.set(           "Family Coaches"                                ).save
    #        t.department_category.set(  "Engagement"                                    ).save
    #        t.department_focus.set(     "Elementary School|Middle School|High School"   ).save
    #        t.title.set(                "Family Coach"                                  ).save
    #        found+=1
    #        
    #    else
    #        notfound+=1
    #        puts "SAMSID: "+samsid
    #    end
    #  
    #}
    #puts "FOUND:#{found}"
    #puts "NOT FOUND:#{notfound}"
    
    s_id = $team.by_sams_id("406477").primary_id.value
    fcps = $db.get_data_single("SELECT `family_coach_program_support_id`  FROM team_relate_region GROUP BY family_coach_program_support_id")
    fcps.each{|samsid|
        if (t = $team.by_sams_id(samsid))
            puts t.primary_id.to_name(options=:full_name)
            t.supervisor_team_id.set( s_id ).save
            t.employee_type.set(        "Support"                                       ).save
            t.department.set(           "Family Coaches"                                ).save
            t.department_category.set(  "Engagement"                                    ).save
            t.department_focus.set(     "Elementary School|Middle School|High School"   ).save
            t.title.set(                "Family Coach Program Support"                  ).save
        else
            puts samsid
        end
    } if fcps
    
  end
  def peer_group_setup
    
    CSV.foreach("#{$paths.imports_path}peer_groups.csv")do|row|
      
      tid = $db.get_data_single("SELECT primary_id FROM team WHERE legal_last_name = '#{row[0]}' AND legal_first_name = '#{row[1]}'")
      if tid
        
        t   = $team.get(tid[0])
        t.peer_group_id.set(row[2]).save
        
      else
        
        puts row[0] +" "+ row[1]
        
      end
      
    end
    
  end
  
  def supervisor_team_id_setup
    sources = ["team_202", "team_198", "team_81", "team_by_email"]
    sources = ["team_by_email"]
    sources.each{|source|
      
      CSV.foreach("#{$paths.imports_path}#{source}.csv")do|row|
        
        case source
        when /email/
          
            t   = $team.by_team_email(row[0].downcase)
            
            if t
                t.supervisor_team_id.set(row[1]).save
                t.department.set("Middle School").save
                t.department_category.set("Academic").save
                t.employee_type.set("Teacher").save
                t.department_focus.set("Middle School").save
            else
                puts row[0]
            end
          
        else
            ts_id = source.split("team_")[1]
            t_id  = $db.get_data_single("SELECT primary_id FROM team WHERE legal_last_name = '#{row[0]}' AND legal_first_name = '#{row[1]}'")
            if t_id && t = $team.get(t_id[0])
               
                t.supervisor_team_id.set(       ts_id                               ).save
                t.department.set(               "K8"                                ).save
                t.department_category.set(      "Academic"                          ).save
                t.department_focus.set(         "Elementary School|Middle School"   ).save
              
            else
                puts source +" "+ row[0] +" "+ row[1]
            end
        end
        
      end
      
    }
    
  end
  def reset_team_eval
    
    $tables.attach("TEAM_EVALUATION_ACADEMIC_INSTRUCTION"       ).drop if $tables.attach("TEAM_EVALUATION_ACADEMIC_INSTRUCTION"       ).exists?
    $tables.attach("TEAM_EVALUATION_ACADEMIC_METRICS"           ).drop if $tables.attach("TEAM_EVALUATION_ACADEMIC_METRICS"           ).exists?
    $tables.attach("TEAM_EVALUATION_ACADEMIC_PROFESSIONALISM"   ).drop if $tables.attach("TEAM_EVALUATION_ACADEMIC_PROFESSIONALISM"   ).exists?
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS"         ).drop if $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS"         ).exists?
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION"     ).drop if $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION"     ).exists?
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM" ).drop if $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM" ).exists?
    
    $tables.attach("TEAM_EVALUATION_ACADEMIC_INSTRUCTION"       ).init
    $tables.attach("TEAM_EVALUATION_ACADEMIC_METRICS"           ).init
    $tables.attach("TEAM_EVALUATION_ACADEMIC_PROFESSIONALISM"   ).init
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_METRICS"         ).init
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_OBSERVATION"     ).init
    $tables.attach("TEAM_EVALUATION_ENGAGEMENT_PROFESSIONALISM" ).init
    
  end
  
  def team_setup_from_k12_staff(options = {:fresh_load=> false})
    
    if options[:fresh_load]
        
        $tables.attach("K12_STAFF"          ).init
        $tables.attach("K12_STAFF"          ).load 
        
        $tables.attach("TEAM"               ).drop if $tables.attach("TEAM"               ).exists?
        $tables.attach("TEAM_PHONE_NUMBERS" ).drop if $tables.attach("TEAM_PHONE_NUMBERS" ).exists?
        $tables.attach("TEAM_EMAIL"         ).drop if $tables.attach("TEAM_EMAIL"         ).exists?
        $tables.attach("TEAM_SAMS_IDS"      ).drop if $tables.attach("TEAM_SAMS_IDS"      ).exists?
        
        $tables.attach("TEAM"               ).init
        $tables.attach("TEAM_PHONE_NUMBERS" ).init
        $tables.attach("TEAM_EMAIL"         ).init
        $tables.attach("TEAM_SAMS_IDS"      ).init
      
    end
    
    $tables.attach("K12_STAFF").primary_ids(" WHERE email REGEXP 'agora.org'").each{|pid|
      
      k12_record  = $tables.attach("K12_STAFF").by_primary_id(pid)
      sams_id     = k12_record.fields["samspersonid"].value
      sams_email  = k12_record.fields["email"       ].value
      sams_phone  = k12_record.fields["homephone"   ].value
      
      if is_num?(sams_id) &&  t = $team.by_team_email(sams_email) || $team.by_sams_id(sams_id) || $team.new_team_member
        
        team_id = t.primary_id.value
        
        #TEAM RECORD
        t.legal_first_name.set(   k12_record.fields["firstname"      ].value ).save
        t.legal_last_name.set(    k12_record.fields["lastname"       ].value ).save
        t.mailing_address_1.set(  k12_record.fields["mailingaddress1"].value ).save
        t.mailing_address_2.set(  k12_record.fields["mailingaddress2"].value ).save
        t.mailing_city.set(       k12_record.fields["mailingcity"    ].value ).save
        t.mailing_state.set(      k12_record.fields["mailingstate"   ].value ).save
        t.mailing_zip.set(        k12_record.fields["mailingzip"     ].value ).save
        
        #TEAM PHONE NUMBERS RECORD
        if !$tables.attach("TEAM_PHONE_NUMBERS").by_phone_number(sams_phone, team_id)
          
          phone_record = t.phone_numbers.new_record
          phone_record.fields["phone_number"  ].value = sams_phone
          phone_record.fields["type"          ].value = "work"
          phone_record.fields["preferred"     ].value = true
          phone_record.save
          
        end

        
        #TEAM EMAIL RECORD
        if !$tables.attach("TEAM_EMAIL").by_email(sams_email, team_id)
          
          email_record = t.email.new_record
          email_record.fields["email_address" ].value = sams_email
          email_record.fields["email_type"    ].value = "work"
          email_record.fields["preferred"     ].value = true
          email_record.save
          
        end
        
        #TEAM SAMSIDS RECORD
        if !$tables.attach("TEAM_SAMS_IDS").by_sams_id(sams_id, team_id)
          
          samsid_record = t.sams_ids.new_record
          samsid_record.fields["sams_id"       ].value = sams_id
          samsid_record.save
          
        end
        
      end
      
    }
    
  end
  
  def attendance_ap_daily_setup
    
    require "#{File.dirname(__FILE__)}/system/data_processing/attendance_ap"
    ap_att_process = Attendance_AP.new
    ap_att_process.create_attendance_records(att_date = $idate)
    ap_att_process.notice_ap_attendance(att_date = $idate, staff_ids_override = nil)
    
  end
  
  def student_assessment_setup
    
    CSV.foreach("#{$paths.imports_path}student_tier_reading.csv")do|row|
      
      sid = row[0]
      s   = $students.get(sid)
      
      if s
        
        s.assessment.existing_record || s.assessment.new_record.save
        s.assessment.tier_level_reading.set(row[1]).save
        
      else
        puts sid
      end
      
    end
    
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
  
  def student_attendance_master_setup_from_attendance_master
    
    #INITIAL LOAD OF STUDENT ATTENDANCE MASTER
    $tables.attach("ATTENDANCE_MASTER").students_with_records.each{|sid|
      
      s = $students.attach(sid)
      
      record = $tables.attach("STUDENT_ATTENDANCE_MASTER").new_row
      record.fields["student_id"          ].value = sid         
      record.fields["attendance_rate"     ].value = s.attendance.rate_decimal         
      record.fields["tot_enrolled_days"   ].value = s.attendance.enrolled_days.length         
      record.fields["tot_attended_days"   ].value = s.attendance.attended_days.length         
      record.fields["tot_excused_days"    ].value = s.attendance.excused_absences.length         
      record.fields["tot_unexcused_days"  ].value = s.attendance.unexcused_absences.length         
      record.save
      
    }
    
  end
  
  def team_relate_region
    
    all_rows = Array.new
    headers = Array.new
    
    headers.push("region","family_coach_id","family_coach_program_support_id","truancy_prevention_id","advisor_id")
    CSV.foreach("#{$paths.imports_path}team_relate.csv")do|row|
      new_row       = []
      advisor_rows  = Array.new
      
      region                          = row[0]
      family_coach_id                 = "Eric Winson"
      family_coach_program_support_id = $team.by_k12_name(row[2]) ? $team.by_k12_name(row[2]).samsid.value : row[2]
      truancy_prevention_id           = $team.by_k12_name(row[3]).samsid.value     
      advisor_id                      = row[4]
      
      splitt      = advisor_id.split(",")
      splitt.each {|id1|
        staff_table_new = $team.by_k12_name(id1)
        puts id1
        samsid_advisor = staff_table_new.samsid.value
        advisor_rows.push(samsid_advisor)
      } 
      
      staff_rec = $tables.attach("k12_staff").by_k12_name(family_coach_id,"Teacher")
      staff_rec.each{ |rec|
        
        puts rec.fields["samspersonid"].value
        samsid_family_coach = rec.fields["samspersonid"].value
        new_row.push(region,samsid_family_coach, family_coach_program_support_id,truancy_prevention_id,advisor_rows.join(", "))
        all_rows.push(new_row)
      }
      
    end
    
    path = "team"
    filename = "team_relate_region"
    $reports.csv(path, filename, all_rows.insert(0,headers))
    
  end
  
  def remove_bad_tep_records
            sql_string = "SELECT * 
FROM `student_tep_absence_reasons`
WHERE `att_date` = (SELECT SUBSTRING(student_tep_absence_reasons.created_date, 1,10))"
    
    records = $db.get_data(sql_string)
    i=0
    records.each do |record|
      
      sid = record[1]
      att_date = record[2]
      
      if $students.attach(sid).exists?
      
        day_code = $tables.attach("attendance_master").by_studentid_old(sid).fields[att_date].value
        
        if $tables.attach("attendance_codes").code_array("WHERE code_type REGEXP '^excused|present'").include?(day_code)
          
          tep_record = $tables.attach("student_tep_absence_reasons").by_studentid_old(sid, att_date)
          tep_record[0].fields["student_id"].value = "5552"
          tep_record[0].save
          puts "#{sid}, #{att_date}"
          i+=1
        end
      
      end
      
    end
    puts i
  end
  
  def various_junk
    
    #require "#{$paths.system_path}reports/Attendance_Reports"
    #Attendance_Reports.new.attendance_master()
    
    #$tables.attach("student_attendance_ap").load
    #sql_str = "SELECT * FROM student_attendance WHERE TRUE "
    #CSV.open($paths.imports_path+"att_ap.csv","rb").each{|row|
    #  sql_str << " OR (student_id = #{row[0]} AND date = '#{row[1]}')"
    #}
    #puts sql_str
    #$tables.attach("student_attendance_ap").after_load_k12_omnibus
    #t = $team.get("1").has_rights?("1")
    #
    #i = 0
    #record = $tables.attach("student_tep_agreement").new_row
    #record.fields["student_id"].value = "2578"
    #record.save
    
    #$tables.attach("student_relate").after_load_jupiter_grades
    
    #record = $tables.attach("student").by_studentid_old("2578")
    #record.fields["student_id"].value = "2578"
    #record.save
    
    #require "#{File.dirname(__FILE__)}/system/data_processing/Finalize_Attendance"
    #Finalize_Attendance.new
    
    #$tables.attach("TEST_SITES").dd_choices("CONCAT(region," ",facility_name)", "primary_id", "ORDER BY region ASC")
    
    #$base.email.athena_smtp_email(
    #  recipients    = "crivera@agora.org;jhalverson@agora.org;apickens@agora.org",
    #  subject       = "Truancy Report",
    #  content       = "Please find the attached reports",
    #  attachments   = "Q:/athena_files/reports/Truancy_Withdrawal/truancy_withdrawal_D20121223T144000.zip"
    #  
    #)
    
    #$tables.attach("student_attendance_ap").after_load_k12_omnibus("2012-12-21")
    #$tables.attach("student_relate").after_load_k12_ecollege_detail
    #$tables.attach("withdrawing").withdrawing_eligible_pids
    #$tables.attach("SAPPHIRE_STUDENTS").sapphire_update_new_students
    #$tables.attach("student_attendance").after_load_k12_omnibus
    #$tables.attach("scantron_performance_level").move_source_to_dest
    
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
  
  def clean_this_stuff_up
    
    
    
    #CSV.open($paths.imports_path+"academic_plan_sids.csv","rb").each{|sid|
    #  record = $tables.attach("STUDENT_ATTENDANCE_MODE").by_studentid_old(sid[0])
    #  if record
    #    record.fields["attendance_mode"].value = "Academic Plan"
    #    record.save
    #  else
    #    puts sid
    #  end
    #}
    #$tables.attach("student_tests").primary_ids.each{|pid|
    #  record =  $tables.attach("student_tests").by_primary_id(pid)
    #}
    
    #CSV.open($paths.imports_path+"test_event_site_staff.csv","rb").each{|row|
    #  if x = $team.by_email(row[1])
    #    new_record = $tables.attach("test_event_site_staff").new_row
    #    new_record.fields["test_event_site_id"].value = row[0]
    #    new_record.fields["staff_id"          ].value = x.samsid.value
    #    new_record.save
    #  else
    #    puts row[1]
    #  end
    #}
    
    #$tables.attach("ink_staples_ids_requested").after_load_k12_omnibus
    #require "#{$paths.system_path}data_processing/ink_staples_id_request"
    #x = Ink_Staples_Id_Request.new
    #x.make_staples_xls(rows=false)
    #require "#{$paths.templates_path}pdf_templates/REPORT_CARD_7_8_PDF.rb"
    ##REPORT_CARD_7_8_PDF.new.generate_pdf("950784")
    #REPORT_CARD_7_8_PDF.new.confirmed_batch(false)
    
    #require "#{$paths.system_path}reports/truancy_withdrawals_report"
    #students = [                
    #  "736389",
    #  "795607",
    #  "860940",
    #  "874792",
    #  "886821",
    #  "892700",
    #  "898672",
    #  "909275",
    #  "909502",
    #  "914632",
    #  "942136",
    #  "943143",
    #  "964059",
    #  "993046",
    #  "1043525"
    #]
    
    #students.each{|sid|
    #  Truancy_Withdrawals_Report.new.generate(
    #    cutoff              = "2012-11-09",
    #    official_report     = true,
    #    exception_students  = [],
    #    student_list        = [sid]
    #  )
    #  i = 0
    #}
    #i = 0
    
    #require "#{$paths.system_path}reports/truancy_withdrawals_report"
    #students = [ 
    #    ["854760"	,"2012-10-25"]
    #]
    #students.each{|sid_wd_date|
    #  Truancy_Withdrawals_Report.new.generate(
    #    cutoff              = sid_wd_date[1],
    #    official_report     = true,
    #    exception_students  = [],
    #    student_list        = [sid_wd_date[0]]
    #  )
    #  i = 0
    #}
    #i = 0

    #require "#{$paths.templates_path}pdf_templates/WITHDRAWAL_GRADES_PDF.rb"
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #$tables.attach("withdrawing").primary_ids.each{|pid|
    #  status = $tables.attach("withdrawing").by_primary_id(pid).fields["status"].value
    #  if !status.nil? && !status.match(/Processed|Requested/)
    #    WITHDRAWAL_GRADES_PDF.new.generate_pdf(pid)
    #    DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.generate_pdf(pid)
    #  end
    #}
    
    #require "#{$paths.system_path}reports/Attendance_Reports"
    #Attendance_Reports.new.attendance_master()
    #
    #require "#{$paths.system_path}reports/truancy_withdrawals_report"
    #truancy_path = Truancy_Withdrawals_Report.new.generate()
    
    #$tables.attach("student_academic_progress").after_load_jupiter_grades
    ###GENERATE DISTRICT NOTIFICATIONS
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.generate_pdf("149")
    #
    #require "#{$paths.templates_path}pdf_templates/WITHDRAWAL_GRADES_PDF.rb"
    #WITHDRAWAL_GRADES_PDF.new.generate_pdf("149")
    #
    #require "#{File.dirname(__FILE__)}/system/reports/enrollment_reports"
    #x = Enrollment_Reports.new
    #x.flag_duplicates#("2012-08-17")
#    
#    table_to_change   = "attendance_master"
#    reason            = "Adjusting all students based on their attendance 3 days prior to the attendance day.
#If they have 3 consecutive absences code = ur else code = pr"
#    auth_by           = "Christina Rivera"
#    
#    excused_codes     = $tables.attach("ATTENDANCE_CODES").code_array("WHERE code_type = 'excused' OR code_type = 'present'")
#    unexcused_codes   = $tables.attach("ATTENDANCE_CODES").code_array("WHERE code_type = 'unexcused'")
#    
#    skip        = true
#    header_row  = nil
#    CSV.open( "#{$paths.reports_path}change_by_pid/change_by_pid.csv", "r" ).each{|row|
#      
#      header_row = row.slice(1,row.length) if skip
#      
#      if !skip
#        
#        pid         = row[0]
#        att_record  = $tables.attach("attendance_master").by_primary_id(pid)
#        
#        i=1
#        header_row.each{|field_to_update|
#          
#          att_date_field  = att_record.fields[field_to_update]
#          old_val         = att_date_field.value
#          new_val         = row[i]
#          
#          if (old_val != new_val) && !new_val.nil? && !new_val.empty?
#            
#            att_date_field.value = new_val
#            
#            bulk_log = $tables.attach("bulk_modification_log").new_row
#            bulk_log.fields["table"         ].value = table_to_change       
#            bulk_log.fields["pid"           ].value = pid           
#            bulk_log.fields["field"         ].value = field_to_update         
#            bulk_log.fields["from"          ].value = old_val         
#            bulk_log.fields["to"            ].value = new_val           
#            bulk_log.fields["reason"        ].value = reason       
#            bulk_log.fields["authorized_by" ].value = auth_by 
#            bulk_log.save
#           
#          else
#            puts "do nothing for pid:#{pid} current value:#{old_val} requested value:#{new_val}"
#            
#          end
#          
#          i+=1
#        }
#        
#        att_record.save
#        
#      end
#      
#      skip = false
#      
#    }
#    i=9
#    
    #
    #all_sapphire_students = $tables.attach("sapphire_students").students_with_records  
    #all_sapphire_students.each{|sid|
    #  
    #  sapp_record = $tables.attach("sapphire_students").by_studentid_old(sid)
    #  old_value   = sapp_record.fields["active"].value
    #  if current_in_sapphire.include?(sid)
    #    new_value = sapp_record.fields["active"].value = "1"
    #  else
    #    new_value = sapp_record.fields["active"].value = "0"
    #  end
    #  if old_value != new_value
    #    sapp_record.save
    #    
    #    bulk_log = $tables.attach("bulk_modification_log").new_row
    #    bulk_log.fields["table"         ].value = "sapphire_students"       
    #    bulk_log.fields["pid"           ].value = sapp_record.primary_id           
    #    bulk_log.fields["field"         ].value = "active"         
    #    bulk_log.fields["from"          ].value = old_value         
    #    bulk_log.fields["to"            ].value = new_value           
    #    bulk_log.fields["reason"        ].value = "UNDID PREVIOUS - 2ND ATTEMPT - Getting records in sync after finding that withdrawal procedures were not being followed."        
    #    bulk_log.fields["authorized_by" ].value = "jhalverson@agora.org" 
    #    bulk_log.save
    #  end
    #  
    #}
    
    
    
    
    
    #$tables.attach("student_reinstate").after_load_k12_omnibus

    #require "#{File.dirname(__FILE__)}/system/reports/enrollment_reports"
    #x = Enrollment_Reports.new
    #x.flag_duplicates#("2012-08-17")

#
#    require "#{$paths.system_path}reports/truancy_withdrawals_report"
#    students = [ 
#["309186"	,"2012-10-09"],
#["347912"	,"2012-10-17"],
#["756942"	,"2012-10-12"],
#["809285"	,"2012-10-05"],
#["885964"	,"2012-10-17"],
#["917746"	,"2012-10-17"],
#["987450"	,"2012-10-12"],
#["994543"	,"2012-10-18"],
#["997704"	,"2012-10-10"],
#["1003514"	,"2012-10-02"],
#["1008364"	,"2012-10-10"],
#["1049416"	,"2012-10-18"],
#["1060087"	,"2012-10-11"],
#["1063296"	,"2012-10-12"],
#["1002865"	,"2012-10-19"]
#
#    ]
#    students.each{|sid_wd_date|
#      Truancy_Withdrawals_Report.new.generate(
#        cutoff              = sid_wd_date[1],
#        official_report     = true,
#        exception_students  = [],
#        student_list        = [sid_wd_date[0]]
#      )
#      i = 0
#    }
#    i = 0
    
    #sids = $db.get_data_single("SELECT student_id FROM student_attendance WHERE mode = 'K8 Synchronous' AND date = '2012-10-19'")
    #sids.each{|sid|
    #  record = $tables.attach("STUDENT_ATTENDANCE").by_studentid_old(sid, att_date = "2012-10-19")
    #  if record
    #    record.fields["mode"].value = "K8 Asynchronous"
    #    record.save
    #  end
    #}
    #i = 0
    
    #RUN THE ATTENDANCE MASTER REPORT
    #require "#{$paths.system_path}reports/attendance_master_report" 
    #att_master_path = Attendance_Master_Report.new.generate("2012-10-11")
    ##att_master_path = "Q:/athena-sis/htdocs/athena_files/reports/Attendance_Master/attendance_master_D20121011T151247.csv"
    #zip_att_master_path = att_master_path.gsub(".csv",".zip")
    #zip_file = Zip::ZipFile.open(zip_att_master_path, Zip::ZipFile::CREATE)
    #zip_file.add(att_master_path.split("/")[-1], att_master_path)
    #zip_file.close
    
    
    #start_date  = "2012-09-01"
    #end_date    = "2012-09-30"
    #$students.list(:currently_enrolled=>true).each{|sid|
    #  monthly_attendance_kmail(sid, start_date, end_date) 
    #}
    #$tables.attach("sapphire_students").after_load_k12_withdrawal
    #current_in_sapphire = $db.get_data_single(
    #  "SELECT student_id FROM sapphire_enrollment_records
    #  WHERE sapphire_enrollment_records.school_year = '2013'
    #  AND withdrawl_date IS NULL
    #  GROUP BY student_id"
    #)
    #all_sapphire_students = $tables.attach("sapphire_students").students_with_records  
    #all_sapphire_students.each{|sid|
    #  
    #  sapp_record = $tables.attach("sapphire_students").by_studentid_old(sid)
    #  old_value   = sapp_record.fields["active"].value
    #  if current_in_sapphire.include?(sid)
    #    new_value = sapp_record.fields["active"].value = "1"
    #  else
    #    new_value = sapp_record.fields["active"].value = "0"
    #  end
    #  if old_value != new_value
    #    sapp_record.save
    #    
    #    bulk_log = $tables.attach("bulk_modification_log").new_row
    #    bulk_log.fields["table"         ].value = "sapphire_students"       
    #    bulk_log.fields["pid"           ].value = sapp_record.primary_id           
    #    bulk_log.fields["field"         ].value = "active"         
    #    bulk_log.fields["from"          ].value = old_value         
    #    bulk_log.fields["to"            ].value = new_value           
    #    bulk_log.fields["reason"        ].value = "UNDID PREVIOUS - 2ND ATTEMPT - Getting records in sync after finding that withdrawal procedures were not being followed."        
    #    bulk_log.fields["authorized_by" ].value = "jhalverson@agora.org" 
    #    bulk_log.save
    #  end
    #  
    #}
    
    
    #$tables.attach("WITHDRAWING").after_load_k12_withdrawal
    #$tables.attach("student_relate").after_load_k12_omnibus_disabled
    #BULK UPDATE ATTENDANCE MASTER CODE
    #source_file = "adhoc_bulk_attendance_updates/attendance_mark_pr_2012-09-28D20121004.csv"
    #require "csv"
    #skip = true
    #CSV.open("#{$paths.imports_path}#{source_file}", "r").each{|row|
    #  if !skip
    #    famid = row[0]
    #    sids = $db.get_data_single("SELECT student_id FROM k12_all_students WHERE familyid = #{famid}")
    #    sids.each{|sid|
    #      att_rec = $tables.attach("attendance_master").by_studentid_old(sid)
    #      if att_rec
    #        student_present = att_rec.fields["2012-09-28"].value == "pr" || att_rec.fields["2012-09-28"].value == "p"
    #        if !student_present
    #          old_value = att_rec.fields["2012-09-28"].value
    #          new_value = "pr"
    #          att_rec.fields["2012-09-28"].value = new_value
    #          att_rec.save
    #          bulk_log = $tables.attach("bulk_modification_log").new_row
    #          bulk_log.fields["table"         ].value = "attendance_master"       
    #          bulk_log.fields["pid"           ].value = att_rec.primary_id           
    #          bulk_log.fields["field"         ].value = "2012-09-28"         
    #          bulk_log.fields["from"          ].value = old_value         
    #          bulk_log.fields["to"            ].value = new_value           
    #          bulk_log.fields["reason"        ].value = "Back to school sign-ins. If a family member was present all related students are being marked present."        
    #          bulk_log.fields["authorized_by" ].value = "crivera@agora.org" 
    #          bulk_log.save
    #          
    #        end
    #      end
    #    } if sids
    #  end
    #  skip = false
    #}
    #i = 0
    
    #$tables.attach("").find_and_trigger_event(:after_load)
    #$tables.attach("sapphire_students").sapphire_update_returning_students
    
    ##GENERATE DISTRICT NOTIFICATIONS
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.distribute_confirmed_batch
    
    #GENERATE SAPPHIRE NOTIFICATION REPORT
    #require "#{$paths.system_path}reports/sapphire_withdrawal_report.rb"
    #Sapphire_Withdrawal_Report.new.generate
    #
    #source_file = "adhoc_bulk_attendance_updates/attendance_mark_pr_2012-09-28D20121004.csv"
    #require "csv"
    #skip = true
    #CSV.open("#{$paths.imports_path}#{source_file}", "r").each{|row|
    #  if !skip
    #    famid = row[0]
    #    sids = $db.get_data_single("SELECT student_id FROM k12_all_students WHERE familyid = #{famid}")
    #    sids.each{|sid|
    #      att_rec = $tables.attach("attendance_master").by_studentid_old(sid)
    #      if att_rec
    #        student_present = att_rec.fields["2012-09-28"].value == "pr" || att_rec.fields["2012-09-28"].value == "p"
    #        if !student_present
    #          old_value = att_rec.fields["2012-09-28"].value
    #          new_value = "pr"
    #          att_rec.fields["2012-09-28"].value = new_value
    #          att_rec.save
    #          bulk_log = $tables.attach("bulk_modification_log").new_row
    #          bulk_log.fields["table"         ].value = "attendance_master"       
    #          bulk_log.fields["pid"           ].value = att_rec.primary_id           
    #          bulk_log.fields["field"         ].value = "2012-09-28"         
    #          bulk_log.fields["from"          ].value = old_value         
    #          bulk_log.fields["to"            ].value = new_value           
    #          bulk_log.fields["reason"        ].value = "Back to school sign-ins. If a family member was present all related students are being marked present."        
    #          bulk_log.fields["authorized_by" ].value = "crivera@agora.org" 
    #          bulk_log.save
    #          
    #        end
    #      end
    #    } if sids
    #  end
    #  skip = false
    #}
    #i = 0
    #$tables.attach("sapphire_students").sapphire_update_returning_students
    #$tables.attach("student_attendance").after_load_k12_withdrawal
    
   # $tables.attach("WITHDRAWING").after_load_k12_withdrawal
    #$tables.attach("sapphire_students").sapphire_update_returning_students
    
    #require "#{$paths.system_path}reports/sapphire_withdrawal_report.rb"
    #Sapphire_Withdrawal_Report.new.generate
    #$tables.attach("withdrawing").disabled_after_load_k12_withdrawal
    
    #GENERATE DISTRICT NOTIFICATIONS
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.distribute_confirmed_batch
    
    
    #eligible = $tables.attach("student_attendance").finalize_eligible
    #require "#{File.dirname(__FILE__)}/system/reports/truancy_withdrawals_report"
    #test = Truancy_Withdrawals_Report.new.generate(cutoff = "2012-09-24", official_report = false, exception_students = [])
    
    
    #STUDENT RELATE NEEDS TO BE UPDATED
    #$tables.attach("student_relate").after_load_k12_omnibus_disabled
    
    #$tables.attach("Attendance_Master").unexcused_by_studentid("1071954", "2012-09-21")
    #$students.attach("1071954").attendance.unexcused_absences
    
    #districtss
    #$tables.attach("db_config").scheduled_missed
    
    #team_relate_region
    #i = true
    
    #truancy_withdrawal
    #x = $tables.attach("Attendance_Codes").dd_choices("code", "code", " WHERE code != 'p'")
    #x.each{|y|
    #  y[:value] = "pr" if y[:name] == "p"  
    #}
    #x
    #$tables.attach("db_config").scheduled_now
    
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    ##GENERATE DISTRICT NOTIFICATIONS
    #DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.confirmed_batch()
    #
    #require "#{File.dirname(__FILE__)}/system/reports/sapphire_withdrawal_report"
    ##GENERATE SAPPHIRE NOTIFICATION REPORT
    #Sapphire_Withdrawal_Report.new.generate()
    
    
    
    
    #require "#{File.dirname(__FILE__)}/system/templates/pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #attachment_path  = DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.generate_pdf("1", pdf = nil).path
    #sender_email     = "athena-reports@agora.org"
    #sender_secret    = "athena" 
    #recipient_email  = "jeniferhalverson@gmail.com"
    #subject          = "Just testing"
    #content          = "^.^"
    ##attachment_path  = "#{$paths.reports_path}test.pdf"
    #$base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, attachment_path)
    ##
    #
    
    #pids = $db.get_data(
    #  "SELECT student_attendance.primary_id
    #  FROM student_attendance
    #  LEFT JOIN student ON student.student_id = student_attendance.student_id
    #  WHERE date = '2012-09-14'
    #  AND student.grade REGEXP 'k|1st|2nd|3rd|4th|5th|6th'"
    #)
    #pids.each{|pid|
    #  record = $tables.attach("student_attendance").by_primary_id(pid)
    #  record.fields["mode"].value = "Flex"
    #  record.save
    #}
    
    #require "csv"
    #skip = true
    #CSV.open("#{$paths.imports_path}adhoc_attendance_present/adhoc_attendance_present.csv", "r").each{|row|
    #  if !skip
    #    sid = row[0]
    #    att_rec = $tables.attach("attendance_master").by_studentid_old(sid)
    #    if att_rec
    #      if !att_rec.fields["2012-09-14"].value.match(/p|pr/)
    #        puts sid
    #        att_rec.fields["2012-09-14"].value = "pr"
    #        att_rec.save
    #      end
    #      
    #    else
    #      puts sid
    #    end
    #  end
    #  skip = false
    #}
    #i = 0
    
    
    #$tables.attach("withdrawing").after_load_k12_withdrawal
    #pdf_batch_pids = ["1","2","3"]
    #require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
    #DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.confirmed_batch(pdf_batch_pids)
    
    #$students.current_students.length
    #$students.list(:currently_enrolled=>true).length
    #x = $students.list(:currently_enrolled=>true).length
    #i=true
    #puts x
    
    #$tables.attach("Student_Relate").after_load_k12_omnibus_disabled
    
  end
  
  def attendance_master_report(override_att_date)
    
    #RUN THE ATTENDANCE MASTER REPORT
    require "#{$paths.system_path}reports/attendance_reports" 
    att_master_path = Attendance_Reports.new.attendance_master(override_att_date)
    #att_master_path = "Q:/athena-sis/htdocs/athena_files/reports/Attendance_Master/attendance_master_D20121011T151247.csv"
    zip_att_master_path = att_master_path.gsub(".csv",".zip")
    zip_file = Zip::ZipFile.open(zip_att_master_path, Zip::ZipFile::CREATE)
    zip_file.add(att_master_path.split("/")[-1], att_master_path)
    zip_file.close
    
    #RUN THE TRUANCY WITHDRAWAL REPORT
    require "#{$paths.system_path}reports/truancy_withdrawals_report"
    truancy_path = Truancy_Withdrawals_Report.new.generate(override_att_date)
    #truancy_path = "Q:/athena-sis/htdocs/athena_files/reports/Truancy_Withdrawal/truancy_withdrawal_D20121011T151247.csv"
    zip_truancy_path = truancy_path.gsub(".csv",".zip")
    zip_file = Zip::ZipFile.open(zip_truancy_path, Zip::ZipFile::CREATE)
    zip_file.add(truancy_path.split("/")[-1], truancy_path)
    zip_file.close
    
  end
  
  def monthly_attendance_kmail(student_id, start_date, end_date)
    absences = $students.attach(student_id).attendance.unexcused_absences_by_range(start_date, end_date)
    
    if absences.empty?
      
      subject = "Congratulations for your Perfect Attendance between #{date_usr(start_date)} and #{date_usr(end_date)}"
      content =
"Congratulations! Agora Cyber Charter School is writing to notify you that |student.firstname| achieved perfect attendance between #{date_usr(start_date)} and #{date_usr(end_date)}.
Please know every Agora staff member is here to assist you as we partner for a wonderful educational experience for |student.firstname|.
Thank you very much for your attention to ensuring your student is attending school on a daily basis. 
Agora’s Attendance Office"
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
  
  def temp
    require 'csv'
    skip = true
    CSV.foreach("#{$paths.imports_path}student_attendance_exempt.csv")do|row|
      if !skip
        sid = row[0]
        reason = row[1]
        student_mode_table = $tables.attach("student_attendance_mode").by_studentid_old(sid)
        student_mode_table.fields["attendance_mode"].value = "Exempt"
        student_mode_table.fields["exempt_reason"].value = reason
        student_mode_table.save
      end
      skip = false
    end
  end
  
  def truancy_withdrawal(cutoff = "2012-09-18", official_report = false)
    #IGNORE STUDENTS WHO ARE UNDER REVIEW
    exception_students = [
    
    ]
    school_days = $school.school_days(cutoff)#THIS WILL BE TODAY -> ### $idate)
    if school_days
      truancy_span = school_days.slice(-10, 10)
      if truancy_span
        $students.list(:currently_enrolled=>true).each{|sid|
          if !exception_students.include?(sid)
            student   = $students.attach(sid)
            absences  = student.attendance.unexcused_absences
            if absences && absences.length >= 10
              
              num_within_truancy_span = 0
              truancy_dates           = Array.new
              
              absences.each_pair{|date, details|
                if truancy_span.include?(date)
                  num_within_truancy_span += 1 
                  truancy_dates.push(date)
                end
              }
              
              if num_within_truancy_span >= 10
                puts sid
                if official_report
                  #DON'T ADD A WITHDRAW REQUEST IF THE STUDENT ALREADY HAS ONE
                  withdrawal_record = $tables.attach("withdrawing").withdrawing_incompleted_records(sid)
                  if !withdrawal_record
                    withdrawal_record = $tables.attach("withdrawing").new_row
                  end
                  withdrawal_record.fields["student_id"                 ].value = sid             
                  withdrawal_record.fields["student_age"                ].value = student.age           
                  withdrawal_record.fields["initiated_date"             ].value = $idate        
                  withdrawal_record.fields["initiator"                  ].value = "Automated Process - Truancy Withdraw"                             
                  withdrawal_record.fields["agora_reason"               ].value = "6"           
                  withdrawal_record.fields["k12_reason"                 ].value = "D3"             
                  withdrawal_record.fields["type"                       ].value = "Truancy"                         
                  withdrawal_record.fields["status"                     ].value = "Requested"                               
                  withdrawal_record.fields["truancy_dates"              ].value = truancy_dates.sort.join(",")               
                  withdrawal_record.fields["effective_date"             ].value = truancy_span[-1]                   
                  withdrawal_record.save
                end
                
              end
              
            end
            
          end
        }
      end
    end 
  end

end

Athena_Commands.new(ARGV)