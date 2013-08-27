#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RELATE < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @search_options          = nil
        @table_structure  = nil
        @blank_record     = nil
        @existing_records = nil
        @params = {
            :sid          =>  nil,
            :team_id      =>  nil,
            :staff_id     =>  nil,
            :role         =>  nil,
            :role_details =>  nil,
            :source       =>  nil,
            :active       =>  nil
        }
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def by_ids(sid=nil, team_id = nil, staff_id=nil, role=nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=", sid        ) ) if sid
        params.push( Struct::WHERE_PARAMS.new("team_id",    "=", team_id    ) ) if team_id
        params.push( Struct::WHERE_PARAMS.new("staff_id",   "=", staff_id   ) ) if staff_id
        params.push( Struct::WHERE_PARAMS.new("role",       "=", role       ) ) if role
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_staffid(team_id = nil, staff_id = nil, sid = nil, active = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("team_id",    "=", team_id    ) )
        params.push( Struct::WHERE_PARAMS.new("staff_id",   "=", staff_id   ) )
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=", sid        ) ) if sid
        params.push( Struct::WHERE_PARAMS.new("active",     "IS", active    ) ) if active
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_student_staff_role(studentid, team_id, staff_id, role, role_details)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid",      "=", studentid      ) )
        params.push( Struct::WHERE_PARAMS.new("team_id",        "=", team_id        ) )
        params.push( Struct::WHERE_PARAMS.new("staff_id",       "=", staff_id       ) )
        params.push( Struct::WHERE_PARAMS.new("role",           "=", role           ) )
        params.push( Struct::WHERE_PARAMS.new("role_details",   "=", role_details   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def unique_student_role_records(studentid, role, role_details, active = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid",      "=", studentid      ) )
        params.push( Struct::WHERE_PARAMS.new("role",           "=", role           ) )
        params.push( Struct::WHERE_PARAMS.new("role_details",   "=", role_details   ) )
        
        params.push( Struct::WHERE_PARAMS.new("active",         "IS", active        ) ) if active
        
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_studentid_old(arg, active = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg ) )
        params.push( Struct::WHERE_PARAMS.new("active",    "=", active ) ) if active
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def admin36_for_studentid(student_id)
        select_sql =
            "SELECT
                staff_id
            FROM #{table_name}
            WHERE studentid = '#{student_id}'
            AND role = '3-6 Admin'
            AND active IS TRUE"
        $db.get_data_single(select_sql)
    end
    
    def admink2_for_studentid(student_id)
        select_sql =
            "SELECT
                staff_id
            FROM #{table_name}
            WHERE studentid = '#{student_id}'
            AND role = 'K-2 Admin'
            AND active IS TRUE"
        $db.get_data_single(select_sql)
    end
    
    def primaryteacher_for_studentid(student_id)
        select_sql =
            "SELECT
                staff_id
            FROM #{table_name}
            WHERE studentid = '#{student_id}'
            AND role = 'Primary Teacher'
            AND active IS TRUE"
        $db.get_data_single(select_sql)
    end
    
    def primary_teachers_by_staffid(staff_id, student_group)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("k12_omnibus.grade",              "REGEXP",   "K|1st|2nd|3rd|4th|5th|6th"    ) ) if student_group == :k6
        params.push( Struct::WHERE_PARAMS.new("staff_id",                       "=",        staff_id                       ) )
        params.push( Struct::WHERE_PARAMS.new("k12_omnibus.title1teacher",      "IS NOT",   "NULL"                         ) )
        params.push( Struct::WHERE_PARAMS.new("k12_omnibus.schoolenrolldate",   "IS NOT",   "NULL"                         ) )
        params.push( Struct::WHERE_PARAMS.new("k12_omnibus.schoolenrolldate",   "<=",       "CURDATE()"                    ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single(
            "SELECT title1teacher
            FROM #{table_name}
            LEFT JOIN k12_omnibus
                ON k12_omnibus.studentid = student_relate.studentid
            #{where_clause}
            GROUP BY title1teacher ASC"
        ) 
    end
    
    def with_records_by_samsid_k6(arg)
        select_sql =
            "SELECT
                student_relate.studentid
            FROM #{table_name}
            LEFT JOIN k12_all_students on k12_all_students.student_id = student_relate.studentid
            WHERE staff_id = '#{arg}'
            AND grade REGEXP 'K|1st|2nd|3rd|4th|5th|6th'
            AND active IS TRUE ORDER BY studentlastname, studentfirstname ASC"
        $db.get_data_single(select_sql) 
    end
    
    def with_records_by_samsid(arg)
        select_sql =
            "SELECT
                student_relate.studentid
            FROM #{table_name}
            LEFT JOIN k12_all_students on k12_all_students.student_id = student_relate.studentid
            WHERE staff_id = '#{arg}'
            AND active IS TRUE ORDER BY studentlastname, studentfirstname ASC"
        $db.get_data_single(select_sql) 
    end
    
    def with_records_by_samsid_pssa_eligible(arg)
        select_sql =
            "SELECT
                student_relate.studentid
            FROM #{table_name}
            LEFT JOIN k12_omnibus on k12_omnibus.studentid = student_relate.studentid
            LEFT JOIN pssa_student_exceptions ON pssa_student_exceptions.student_id = student_relate.studentid
            WHERE staff_id = '#{arg}'
            AND (grade REGEXP '3rd|4th|5th|6th|7th|8th|11th' OR testing_grade REGEXP '3rd|4th|5th|6th|7th|8th|11th')
            AND active IS TRUE ORDER BY studentlastname, studentfirstname ASC"
        $db.get_data_single(select_sql) 
    end
    
    def with_records_admin
        select_sql =
            "SELECT
                staff_id
            FROM #{table_name}
            WHERE role REGEXP '.*Admin.*'
            AND active IS TRUE
            GROUP BY staff_id "
        $db.get_data_single(select_sql) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STAFFID_GROUPS_BY_ROLE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def current_team_by_role(options)
        options = parse_options(options)
        $db.get_data_single(
            "SELECT #{table_name}.staff_id FROM #{table_name} 
            LEFT JOIN student
            ON student.student_id = #{table_name}.studentid
            #{options[:join_addon]}
            WHERE active IS TRUE
            #{options[:where_clause_addon]}
            GROUP BY #{table_name}.staff_id"
        )  
    end
    
    def staffids_academic_teachers(sid = nil, active = nil)
        
        roles = "Primary Teacher|High School Teacher|Middle School Teacher|Reading Specialist|Math Specialist"
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid",  "=",        sid     ) ) if sid
        params.push( Struct::WHERE_PARAMS.new("active",     "=",        active  ) ) if active
        params.push( Struct::WHERE_PARAMS.new("role",       "REGEXP",   roles   ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single(
            "SELECT #{table_name}.staff_id
            FROM #{table_name} 
            #{where_clause}
            GROUP BY #{table_name}.staff_id"
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SID_GROUPS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def students_group(options)
        start = Time.new
        
        @search_options = options
        if @search_options[:student_demographic_set]
            @search_options[:student_demographic_set].each_pair{|k,v|options[k] = v} if @search_options[:student_demographic_set]
        end
        @search_options.each_pair{|k, v|
            send(k, v) if respond_to?(k, true)
        }
        
        select_table = "#{$tables.attach("STUDENT"          ).data_base}.student"
        joined_table = "#{$tables.attach("STUDENT_RELATE"   ).data_base}.student_relate"
        
        select_sql =
        "SELECT
            #{$tables.attach("STUDENT").data_base}.student.student_id
        FROM #{$tables.attach("STUDENT").data_base}.student 
        LEFT JOIN #{joined_table} ON #{select_table}.student_id = #{joined_table}.studentid
        #{@search_options[:join_addon]}
        WHERE TRUE
        #{@search_options[:where_clause_addon]}
        GROUP BY #{select_table}.studentlastname, #{select_table}.studentfirstname, #{select_table}.student_id
        #{@search_options[:order_by_addon]}"
        
        $db.get_data_single(select_sql)
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def active_record
        
        record  = by_student_staff_role(@params[:sid], @params[:team_id], @params[:staff_id], @params[:role], @params[:role_details ])
        
        if record
            
            record.fields["active"        ].value = true  
            record.save
            
        else
            
            blank_record.clear
            blank_record.fields["studentid"     ].value = @params[:sid          ]
            blank_record.fields["team_id"       ].value = @params[:team_id      ]
            blank_record.fields["staff_id"      ].value = @params[:staff_id     ]  
            blank_record.fields["role"          ].value = @params[:role         ]
            blank_record.fields["role_details"  ].value = @params[:role_details ]  
            blank_record.fields["source"        ].value = @params[:source       ]   
            blank_record.fields["active"        ].value = true  
            blank_record.save
            
        end
        
        @existing_records.delete("#{@params[:sid]}#{@params[:team_id]}#{@params[:staff_id]}#{@params[:role]}#{@params[:role_details]}#{@params[:source]}") if @existing_records
        
    end
    
    def before_insert(a)
        
        this_course_name = a.fields["role_details" ].value
        if !this_course_name.nil?
            
            if !$tables.attach("COURSE_RELATE").primary_ids("WHERE course_name = '#{Mysql.quote(this_course_name)}'")
                record = $tables.attach("COURSE_RELATE").new_row
                record.fields["course_name"                     ].value = this_course_name
                record.fields["scantron_growth_math"            ].value = true
                record.fields["scantron_growth_reading"         ].value = true
                record.fields["scantron_participation_math"     ].value = true
                record.fields["scantron_participation_reading"  ].value = true
                record.save
            end
            
        end
        a.fields["eval_eligible_engagement" ].value = true
        a.fields["eval_eligible_academic"   ].value = true
        
    end
    
    def blank_record
        if @blank_record.nil?
            @blank_record = new_row
        end
        @blank_record
    end
    
    def field_params
        if @params.nil?
            @params = {
                :sid            =>  nil,
                :team_id        =>  nil,
                :staff_id       =>  nil,
                :role           =>  nil,
                :role_details   =>  nil,
                :source         =>  nil,
                :active         =>  nil
            }
        else
            @params[:sid            ] = nil
            @params[:team_id        ] = nil
            @params[:staff_id       ] = nil
            @params[:role           ] = nil
            @params[:role_details   ] = nil
            @params[:source         ] = nil
            @params[:active         ] = nil
        end
        @params 
    end
    
    def get_existing_records
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("role",           "=", @params[:role          ]   ) )
        params.push( Struct::WHERE_PARAMS.new("source",         "=", @params[:source        ]   ) )
        where_clause = $db.where_clause(params)
        select_sql =
            "SELECT
                CONCAT(studentid,IFNULL(team_id, ''),staff_id,role,IFNULL(role_details, ''),source)
            FROM #{table_name}
            #{where_clause}"
        @existing_records = $db.get_data_single(select_sql)
    end
    
    def deactivate_existing_records
        placeholder = "|record_string|"
        select_sql =
            "SELECT
                primary_id
            FROM #{table_name}
            WHERE CONCAT(studentid,IFNULL(team_id, ''),staff_id,role,IFNULL(role_details,''),source) = '|record_string|'"
        if @existing_records
            @existing_records.each{|record_string|
                
                results = $db.get_data(select_sql.gsub(placeholder, "#{record_string}"))
                if results
                    results.each{|result|
                        primary_id  = result[0]
                        record      = by_primary_id(primary_id)
                        if record
                            record.fields["active"].value = false
                            if record.fields["role"].value == "Family Teacher Coach"
                                
                                sid      = record.fields["studentid"    ].value
                                team_id  = record.fields["team_id"      ].value
                                staff_id = record.fields["staff_id"     ].value
                                
                                if $db.get_data_single(
                                    "SELECT primary_id
                                    FROM #{table_name}
                                    WHERE studentid = '#{sid}'
                                    AND team_id     != '#{team_id}'
                                    AND staff_id    != '#{staff_id}'
                                    AND role         = 'Family Teacher Coach'"
                                )
                                    
                                    #THIS STUDENT HAS BEEN ASSIGNED TO A DIFFERENT FAMILY TEACHER COACH
                                    #SO THEY SHOULD NOT BE INCLUDED IN PREVIOUS COACHES EVALUATION TOTALS
                                    record.fields["eval_eligible_engagement" ].value = false
                                    
                                end
                                
                            end
                            record.save
                        else
                            puts "Deactivation failed, primary_id not found: #{primary_id}"
                        end
                    }
                else
                    puts "Deactivation failed, record_string not found: #{record_string}"
                end
            } 
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______AFTER_LOAD_K12_ECOLLEGE_DETAIL
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_ecollege_detail
        #Update/Create Active Student Relationships
            high_school_teachers
            guidance_counselors
    end
    
    def guidance_counselors
        params = field_params
        params[:role            ] = "Guidance Counselor"
        params[:role_details    ] = "Guidance Counselor"
        params[:source          ] = "K12_Ecollege_Detail"
        get_existing_records
        
        pids = $tables.attach("k12_ecollege_detail").primary_ids(" WHERE sams_course_name regexp 'Finding Your Path' ")
        pids.each{|pid|
            
            record  = $tables.attach("k12_ecollege_detail").by_primary_id(pid)
            
            teach_f  = record.fields["teacher_first_name"].value
            teach_l  = record.fields["teacher_last_name" ].value
            sid      = record.fields["sams_id"           ].value
            
            params[:sid]    = sid
            tid             = $tables.attach("TEAM").primary_ids("WHERE k12_first_name = '#{teach_f}' AND k12_last_name = #{teach_l}")
            staff           = $team.by_k12_name("#{teach_f} #{teach_l}")
            if tid
                params[:team_id]  = (tid ? tid[0] : nil)
                params[:staff_id] = staff.samsid.value
                active_record
            end
            
        } if pids
        puts "#{@existing_records.length} Remaining Records." if @existing_records
        deactivate_existing_records if pids #THIS ONLY DEACTIVATES THEM IF THERE ARE ANY BECAUSE K12 RECENTLY DROPPED ALL 'FINDING YOUR PATH' COURSES
        
    end

    def high_school_teachers
        params = field_params
        params[:role    ]   = "High School Teacher"
        params[:source  ]   = "K12_Ecollege_Detail"
        get_existing_records
        
        term = $school.current_term
        @semester_clause = (term && term.match(/Q1|Q2/)) ? " AND classroom_name REGEXP 'Sem1|Sem 1' " : (term && term.match(/Q3|Q4/)) ? " AND classroom_name REGEXP 'Sem2|Sem 2' " : ""
        
        pids = $tables.attach("k12_ecollege_detail").primary_ids(" WHERE sams_course_name not regexp 'Finding Your Path' #{@semester_clause}")
        pids.each{|pid|
            
            record  = $tables.attach("k12_ecollege_detail").by_primary_id(pid)
            params[:role_details    ] = record.fields["ecollege_course_name"].value
            
            teach_f  = record.fields["teacher_first_name"].value
            teach_l  = record.fields["teacher_last_name" ].value
            sid      = record.fields["sams_id"           ].value
            
            params[:sid]    = sid
            tid             = $tables.attach("TEAM").primary_ids("WHERE k12_first_name = '#{teach_f}' AND k12_last_name = #{teach_l}")
            staff           = $team.by_k12_name("#{teach_f} #{teach_l}")
            if tid
                params[:team_id]  = (tid ? tid[0] : nil)
                params[:staff_id] = staff.samsid.value
                active_record
            end
            
        } if pids
        puts "#{@existing_records.length} Remaining Records." if @existing_records
        deactivate_existing_records
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______AFTER_LOAD_JUPITER_GRADES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_jupiter_grades
        params = field_params
        params[:role    ]   = "Middle School Teacher"
        params[:source  ]   = "Jupiter Grades"
        get_existing_records
        #" WHERE term = '#{$school.current_term.value}' " #this only works if the uers of jupiter enter the current term
        pids = $tables.attach("jupiter_grades").primary_ids
        pids.each{|pid|
            
            record  = $tables.attach("jupiter_grades").by_primary_id(pid)
            params[:role_details    ] = record.fields["subject"].value
            
            teacher = record.fields["teacher"].value
            if teacher
                
                teacher.gsub!(", ",",")
                teach_f  = teacher.split(",")[1]
                teach_l  = teacher.split(",")[0]  
                
                sid      = record.fields["studentid"].value
                
                params[:sid]    = sid
                tid             = $tables.attach("TEAM").primary_ids(
                    "WHERE (
                        k12_first_name = '#{teach_f}' AND k12_last_name = #{teach_l} OR
                        k12_first_name = '#{teach_l}' AND k12_last_name = #{teach_f}"
                )
                staff           = $team.by_k12_name("#{teach_f} #{teach_l}")
                if tid
                    params[:team_id]  = (tid ? tid[0] : nil)
                    params[:staff_id] = staff.samsid.value
                    active_record
                end
                
            end
            
        } if pids
        puts "#{@existing_records.length} Remaining Records." if @existing_records
        deactivate_existing_records
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______AFTER_LOAD_K12_OMNIBUS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load_k12_omnibus
        #Update/Create Active Student Relationships
            family_teacher_coaches
            home_room_teachers
            primary_teachers
            special_education_teachers
    end
    
    def family_teacher_coaches
        params = field_params
        params[:role            ] = "Family Teacher Coach"
        params[:role_details    ] = "Family Teacher Coach"
        params[:source          ] = "K12_Omnibus"
        get_existing_records 
        sids = $students.list(:complete_enrolled=>true)#current_students
        sids.each{|sid|
            params[:sid]    = sid
            staff_id        = $students.get(sid).title1teacherid.value  
            if staff_id && (team_member = $team.find(:sams_id=>staff_id))
                params[:team_id ] = team_member.primary_id.value
                params[:staff_id] = staff_id
                active_record
            end         
        } if sids
        puts "#{@existing_records.length} Remaining Records." if @existing_records
        deactivate_existing_records
    end
    
    def home_room_teachers
        params = field_params
        params[:role            ] = "Homeroom Teacher"
        params[:role_details    ] = "Homeroom Teacher"
        params[:source          ] = "K12_Omnibus"
        get_existing_records
        sids = $students.list(:complete_enrolled=>true,:grade=>"6th|7th|8th|9th|10th|11th|12th")
        sids.each{|sid|
            params[:sid]    = sid
            staff_id        = $students.get(sid).primaryteacherid.value
            if staff_id && (team_member = $team.find(:sams_id=>staff_id))
                params[:team_id ] = team_member.primary_id.value
                params[:staff_id] = staff_id
                active_record
            end         
        } if sids
        deactivate_existing_records
    end
    
    def primary_teachers
        params = field_params
        params[:role            ] = "Primary Teacher"
        params[:role_details    ] = "Primary Teacher"
        params[:source          ] = "K12_Omnibus"
        get_existing_records
        sids = $students.list(:complete_enrolled=>true,:grade=>"K|1st|2nd|3rd|4th|5th")#$students.current_students
        sids.each{|sid|
            params[:sid]    = sid
            staff_id        = $students.get(sid).primaryteacherid.value
            if staff_id && (team_member = $team.find(:sams_id=>staff_id))
                params[:team_id ] = team_member.primary_id.value
                params[:staff_id] = staff_id
                active_record
            end         
        } if sids
        deactivate_existing_records
    end
    
    def special_education_teachers
        params = field_params
        params[:role            ] = "Special Education Teachers"
        params[:role_details    ] = "Special Education Teachers"
        params[:source          ] = "K12_Omnibus"
        
        get_existing_records
        sids = $students.list(:complete_enrolled=>true)#$students.current_students
        sids.each{|sid|
            params[:sid]    = sid
            staff_id        = $students.get(sid).specialedteacherid.value
            if staff_id && (team_member = $team.find(:sams_id=>staff_id))
                params[:team_id ] = team_member.primary_id.value
                params[:staff_id] = staff_id
                active_record
            end         
        } if sids
        deactivate_existing_records
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______AFTER_CHANGE_SPECIALISTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def relate_specialist(specialist_record)
        
        if specialist_record.table.class.to_s.match(/math/i)
            role            = "Math Specialist"
        elsif specialist_record.table.class.to_s.match(/reading/i)
            role            = "Reading Specialist"
        end
        
        sid                 = specialist_record.fields["student_id"].value
        team_id             = specialist_record.fields["team_id"   ].value
        
        sams_id             = $team.get(team_id).sams_ids.existing_records[0].fields["sams_id"].value
        
        previous_records    = unique_student_role_records(sid, role, role_details = role, active = true)
        previous_records.each{|record|
            record.fields["active"].set(false).save
        } if previous_records
        
        relate_record       = by_student_staff_role(sid, sams_id, team_id, role, role_details = role)
        if !relate_record
            
            relate_record = new_row
            relate_record.fields["studentid"    ].value = sid
            relate_record.fields["team_id"      ].value = team_id
            relate_record.fields["staff_id"     ].value = sams_id
            relate_record.fields["role"         ].value = role
            relate_record.fields["role_details" ].value = role 
            relate_record.fields["source"       ].value = "Data Entry"  
            
        end
        relate_record.fields["active"       ].value = true
        relate_record.save
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_relate",
                "file_name"         => "student_relate.csv",
                "file_location"     => "student_relate",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["studentid"                ]= {"data_type"=>"int",  "file_field"=>"studentid"                  } if field_order.push("studentid")
            structure_hash["fields"]["team_id"                  ]= {"data_type"=>"int",  "file_field"=>"team_id"                    } if field_order.push("team_id")
            structure_hash["fields"]["staff_id"                 ]= {"data_type"=>"int",  "file_field"=>"staff_id"                   } if field_order.push("staff_id")
            structure_hash["fields"]["role"                     ]= {"data_type"=>"text", "file_field"=>"role"                       } if field_order.push("role")
            structure_hash["fields"]["role_details"             ]= {"data_type"=>"text", "file_field"=>"role_details"               } if field_order.push("role_details")
            structure_hash["fields"]["source"                   ]= {"data_type"=>"text", "file_field"=>"source"                     } if field_order.push("source")
            structure_hash["fields"]["active"                   ]= {"data_type"=>"bool", "file_field"=>"active"                     } if field_order.push("active") 
            structure_hash["fields"]["eval_eligible_engagement" ]= {"data_type"=>"bool", "file_field"=>"eval_eligible_engagement"   } if field_order.push("eval_eligible_engagement")
            structure_hash["fields"]["eval_eligible_academic"   ]= {"data_type"=>"bool", "file_field"=>"eval_eligible_academic"     } if field_order.push("eval_eligible_academic")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SID_GROUP_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def student_id
        return "#{$tables.attach('STUDENT').data_base}.student.student_id"
    end
    
    def academic_progress_course_name(arg)
        
        joined_table = "#{$tables.attach("STUDENT_ACADEMIC_PROGRESS").data_base}.student_academic_progress"
        join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id"
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            "  AND #{joined_table}.course_name REGEXP '#{arg}'  "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def aims_exempt(arg)
        
        joined_table = "#{$tables.attach("STUDENT_ASSESSMENT").data_base}.student_assessment"
        join_addon =
            " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND ( #{joined_table}.aims_exempt IS NOT TRUE ) "  if arg.to_s.match(/false/)
        where_addon =
            " AND ( #{joined_table}.aims_exempt IS TRUE ) "      if arg.to_s.match(/true/)
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end

    def aims_growth_overall(arg)
        
        joined_table = "#{$tables.attach("STUDENT_AIMS_GROWTH").data_base}.student_aims_growth"
        join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = "  AND #{joined_table}.#{arg}_growth_overall >= .5 "
        
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def aims_growth_overall_eligible(arg)
        
        joined_table = "#{$tables.attach("STUDENT_AIMS_GROWTH").data_base}.student_aims_growth"
        join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = "  AND #{joined_table}.#{arg}_growth_overall IS NOT NULL "
        
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def ap_attendance_dates(arg)
        
        joined_table = "#{$tables.attach("STUDENT_ATTENDANCE_AP").data_base}.student_attendance_ap"
        join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            "  AND #{joined_table}.date REGEXP '#{arg}'  "
        where_addon <<
            " AND #{joined_table}.staff_id = '#{@search_options[:staff_id]}'" if @search_options[:staff_id]
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def active(arg)
        
        if arg == true
            joined_table = "#{$tables.attach("K12_OMNIBUS").data_base}.k12_omnibus"
            join_addon =
                " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND #{joined_table}.student_id IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
        
        #if arg == true
        #    where_addon =
        #        " AND student.active IS TRUE"
        #    @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        #elsif arg == false
        #    where_addon =
        #        " AND student.active IS FALSE"
        #    @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        #else
        #    raise("#{arg} is not a valid option")
        #end
    end
    
    def annual_assessment_eligible(arg)
        
        joined_table = "#{$tables.attach("ANNUAL_ASSESSMENT_GROWTH").data_base}.annual_assessment_growth"
        
        if arg == :math
            join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND #{joined_table}.student_id IS NOT NULL
                AND #{joined_table}.math IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        elsif arg == :reading
            join_addon = " LEFT JOIN #{joined_table} ON #{joined_table}.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND #{joined_table}.student_id IS NOT NULL
                AND #{joined_table}.reading IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def dora_doma_eligible(arg)
        if arg == true
            join_addon =
                " LEFT JOIN alternative_assessment_students ON alternative_assessment_students.student_id = student.student_id
                LEFT JOIN life_skills_students ON life_skills_students.student_id = student.student_id"
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND alternative_assessment_students.student_id IS NULL
                AND life_skills_students.student_id IS NULL
                AND student.grade REGEXP 'K|1st|2nd' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def complete_enrolled(arg)
        if arg == true
            join_addon =
                " LEFT JOIN k12_omnibus ON k12_omnibus.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND k12_omnibus.schoolenrolldate IS NOT NULL
                AND k12_omnibus.enrollapproveddate IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def currently_enrolled(arg)
        join_addon =
            " LEFT JOIN k12_omnibus ON k12_omnibus.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        where_addon =
            " AND k12_omnibus.schoolenrolldate IS NOT NULL
            AND k12_omnibus.schoolenrolldate <= CURDATE()
            AND k12_omnibus.enrollapproveddate IS NOT NULL "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    alias :current_students_only :currently_enrolled
    
    def dropout_truancy(arg)
        if arg == true
            wr = "D2 - School Attendance/Progress Policy|D3 - W/D for Non-Attendance|I2 - Student wants to drop out of school|W/D for Non-Attendance|Drop Out"
            where_addon =
                " AND student.withdrawreason REGEXP '#{wr}'"
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def engagement_eligible(arg)
        
        join_addon =
            " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        if arg == true
            
            where_addon =
                " AND student_assessment.engagement_level IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        elsif arg == false
            
            where_addon =
                " AND student_assessment.engagement_level IS NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        else
            
            raise("#{arg} is not a valid option")
            
        end
        
    end
    
    def enrolled_before_this_week
        if arg == true
            where_addon = " AND student.schoolenrolldate < SUBDATE(CURDATE(), INTERVAL 7 DAY) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def enrolled_this_week(arg)
        if arg == true
            where_addon = " AND (
                student.schoolenrolldate >= SUBDATE(CURDATE(), INTERVAL 7 DAY)
                AND
                student.schoolenrolldate <= ADDDATE(student.schoolenrolldate, INTERVAL 7 DAY)
            ) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def enrolled_after_date(arg)
        where_addon = " AND student.schoolenrolldate > '#{@search_options[:enrolled_after_date]}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    def enrolled_before_date(arg)
        if arg == true
            join_addon =
                " LEFT JOIN student_enrollment ON student_enrollment.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon = " AND student_enrollment.schoolenrolldate < '#{@search_options[:enrolled_before_date]}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def eval_eligible(arg)
        
        if arg == "Engagement"
            
            field_name = "eval_eligible_engagement"
            
        elsif arg == "Academic"
            
            field_name = "eval_eligible_academic"
            
        end
        
        where_addon = " AND student_relate.#{field_name} IS TRUE "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def familyid(arg)
        where_addon = " AND student.familyid = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    def female(arg)
        if arg == true
            where_addon = " AND student.studentgender = 'Female' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def free_reduced(arg)
        if arg == true
            join_addon = " LEFT JOIN student_demographics ON student_demographics.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            
            where_addon = " AND student_demographics.freeandreducedmeals REGEXP 'Free & Reduced Lunch Eligible|Free Lunch Eligible|Reduced Lunch Eligible' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def grade(arg)
        if arg
            where_addon = " AND student.grade REGEXP '#{arg}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    #FNORD - THIS IS A TEMPORARY FUNCTION TO GET THROUGH UNTIL THE TEST EVENT ELIGIBILITY CAN BE REFINED!!!!!
    def keystone_eligible(arg)
        
        join_addon = " LEFT JOIN temp_keystone_participation ON temp_keystone_participation.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = " AND temp_keystone_participation.student_id IS NOT NULL "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    #FNORD - THIS IS A TEMPORARY FUNCTION TO GET THROUGH UNTIL THE TEST EVENT ELIGIBILITY CAN BE REFINED!!!!!
    def keystone_participated(arg)
        
        join_addon = " LEFT JOIN temp_keystone_participation ON temp_keystone_participation.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND temp_keystone_participation.status = 'COMPLETE' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def overall_attendance_mode(arg)
        if arg
            join_addon = " LEFT JOIN student_attendance_mode ON student_attendance_mode.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            
            where_addon =
                " AND student_attendance_mode.student_id IS NOT NULL
                AND student_attendance_mode.attendance_mode = '#{arg}' "
            
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def studentfirstname(arg)
        operator_string = @search_options[:fuzzy] ? "REGEXP" : "="
        where_addon = " AND student.studentfirstname #{operator_string} '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    def studentgender(arg)
        if arg
            where_addon = " AND student.studentgender = '#{arg}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def studentlastname(arg)
        operator_string = @search_options[:fuzzy] ? "REGEXP" : "="
        where_addon = " AND student.studentlastname #{operator_string} '#{Mysql.quote("#{arg}")}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    def new_students_only(arg)
        if arg == true
            where_addon = " AND student.schoolenrolldate = '#{$school.current_school_year_start.value}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def male(arg)
        if arg == true
            where_addon = " AND student.studentgender = 'male' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def monthly_assessment_eligible(arg)
        if arg == :overall
            join_addon = " LEFT JOIN monthly_assessment_participation_summary ON monthly_assessment_participation_summary.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND monthly_assessment_participation_summary.student_id IS NOT NULL
                 AND monthly_assessment_participation_summary.avg_total IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        elsif arg == :math
            join_addon = " LEFT JOIN monthly_assessment_participation_summary ON monthly_assessment_participation_summary.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND monthly_assessment_participation_summary.student_id IS NOT NULL
                 AND monthly_assessment_participation_summary.avg_math IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon    
        elsif arg == :reading
            join_addon = " LEFT JOIN monthly_assessment_participation_summary ON monthly_assessment_participation_summary.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND monthly_assessment_participation_summary.student_id IS NOT NULL
                 AND monthly_assessment_participation_summary.avg_reading IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def participation_eligible(arg)
        
        join_addon = " LEFT JOIN student_participation ON student_participation.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = " AND student_participation.#{arg} IS NOT NULL "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def participation(arg)
        
        join_addon = " LEFT JOIN student_participation ON student_participation.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND student_participation.#{arg} IS TRUE "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def pasa_eligible(arg)
        
        join_addon =
            " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND ( student_assessment.pasa_eligible IS TRUE ) "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def pssa_eligible(arg)
        if arg == true
            join_addon = " LEFT JOIN pssa_student_exceptions ON pssa_student_exceptions.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon = " AND (
                (student.grade REGEXP '3rd|4th|5th|6th|7th|8th|11th' AND (pssa_student_exceptions.testing_grade REGEXP '3rd|4th|5th|6th|7th|8th|11th' OR pssa_student_exceptions.testing_grade IS NULL))
                    OR
                (pssa_student_exceptions.testing_grade REGEXP '3rd|4th|5th|6th|7th|8th|11th')
            ) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def pssa_participated(arg)
        if arg == true
            join_addon = " LEFT JOIN pssa_participation ON pssa_participation.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon = " AND pssa_participation.student_id IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def registering_status_text(arg)
        where_addon = " AND student.registrationstatustext = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    def role(arg)
        if arg == true
            where_addon = " AND student_relate.role = '#{arg}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def sapphire_new_students(arg)
        if arg == true
            currently_enrolled(true)
            
            join_addon =
                " LEFT JOIN sapphire_students ON sapphire_students.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND sapphire_students.student_id IS NULL "
            if @search_options[:where_clause_addon].nil? || (!@search_options[:where_clause_addon].nil? && !@search_options[:where_clause_addon].include?(where_addon))
                @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            end
            
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def scantron_eligible(arg = ["ent_m","ext_m","ent_r","ext_r"])
        
        join_addon =
            " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        arg.each{|a|
            
            where_addon =
                " AND ( student_assessment.scantron_exempt_#{a} IS NOT TRUE ) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        }
        
        where_addon =
            " AND student.grade NOT REGEXP 'K|1st|2nd' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def scantron_growth(arg)
        
        join_addon =
            " LEFT JOIN student_scantron_performance_level ON student_scantron_performance_level.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = String.new
        
        if arg.include?("math")
            where_addon << " AND (stron_ext_nce_m-stron_ent_nce_m) > -2"
        end
        
        if arg.include?("reading")
            where_addon << " AND (stron_ext_nce_r-stron_ent_nce_r) > -2"
        end
        
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def scantron_growth_eligible(arg)
        
        join_addon =
            " LEFT JOIN student_scantron_performance_level ON student_scantron_performance_level.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        join_addon =
            " LEFT JOIN course_relate ON course_relate.course_name = student_relate.role_details "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = String.new
        
        if arg.include?("math")
            where_addon << " AND student_scantron_performance_level.stron_ent_nce_m IS NOT NULL" 
            where_addon << " AND student_scantron_performance_level.stron_ext_nce_m IS NOT NULL"
            where_addon << " AND ABS(student_scantron_performance_level.stron_ent_nce_m-stron_ext_nce_m)<50"
            
            #EITHER THE COURSE IS MARKED AS ELIGIBLE FOR THIS SUBJECT OR THERE IS NO SPECIFIC COURSE
            where_addon << " AND (course_relate.scantron_growth_math IS TRUE OR course_relate.scantron_growth_math IS NULL)" if !arg.include?("reading")
        end
        
        if arg.include?("reading")
            where_addon << " AND student_scantron_performance_level.stron_ent_nce_r IS NOT NULL" 
            where_addon << " AND student_scantron_performance_level.stron_ext_nce_r IS NOT NULL"
            where_addon << " AND ABS(student_scantron_performance_level.stron_ent_nce_r-stron_ext_nce_r)<50"
            
            #EITHER THE COURSE IS MARKED AS ELIGIBLE FOR THIS SUBJECT OR THERE IS NO SPECIFIC COURSE
            where_addon << " AND (course_relate.scantron_growth_reading IS TRUE OR course_relate.scantron_growth_reading IS NULL)" if !arg.include?("math")
        end
        
        if arg.include?("math") && arg.include?("reading")
           where_addon << " AND ((course_relate.scantron_growth_reading IS TRUE OR course_relate.scantron_growth_reading IS NULL) OR (course_relate.scantron_growth_math IS TRUE OR course_relate.scantron_growth_math IS NULL))" 
        end
        
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def scantron_participated(arg) #arg must be the field where the student is expected to have participated (i.e. stron_ent_perf_m)
        
        join_addon =
            " LEFT JOIN student_scantron_performance_level ON student_scantron_performance_level.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        if arg.class == String
            
            where_addon =
                " AND student_scantron_performance_level.#{arg} IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
           
        elsif arg.class == Array
            
            where_addon = String.new
            arg.each{|a|
                
                where_addon << " AND student_scantron_performance_level.#{a} IS NOT NULL "
                
            }
            
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        end
        
        where_addon =
            " AND student.grade NOT REGEXP 'K|1st|2nd' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def scantron_participation_eligible(arg = ["ent_m","ext_m","ent_r","ext_r"])
        
        join_addon =
            " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        join_addon =
            " LEFT JOIN course_relate ON course_relate.course_name = student_relate.role_details "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        arg.each{|a|
            
            where_addon =
                " AND ( student_assessment.scantron_exempt_#{a} IS NOT TRUE ) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
            #EITHER THE COURSE IS MARKED AS ELIGIBLE FOR THIS SUBJECT OR THERE IS NO SPECIFIC COURSE
            stron_part_field = a.match("_r") ? "scantron_growth_reading" : "scantron_growth_math"
            where_addon << " AND (course_relate.#{stron_part_field} IS TRUE OR course_relate.scantron_growth_reading IS NULL)"
            
        }
        
        where_addon =
            " AND student.grade NOT REGEXP 'K|1st|2nd' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def special_ed(arg)
        if arg == true
            where_addon = " AND student.isspecialed IS TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def staff_samsids(arg)
        
        where_addon = String.new
        if arg.class == Array
            
            arg.each{|a|
                where_addon << (where_addon.empty? ? " student_relate.staff_id = '#{a}' " : " OR student_relate.staff_id = '#{a}' ")
            }
            where_addon = " AND (#{where_addon}) "
            
        else
            where_addon = " AND student_relate.staff_id = '#{arg}' "
        end
       
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def staff_id(arg)  
        if $base.is_num?(arg)
            
            #FNORD - WORK THIS CONCEPT IN TO FIND THE MOST RECENTLY ASSIGNED OF A ROLE
            #CREATE OPTION MOST_RECENTLY_ASSIGNED(ROLE)
            #if @search_options[:role]
            #    join_addon =
            #        " LEFT JOIN (
            #            SELECT 
            #            MAX(PRIMARY_ID) AS primary_id
            #            FROM #{table_name} 
            #            WHERE role = '#{@search_options[:role]}'
            #            GROUP BY studentid)a
            #        ON #{table_name}.primary_id = a.primary_id "
            #    @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            #    where_addon =
            #        " AND a.primary_id IS NOT NULL
            #        AND student_relate.staff_id = '#{arg}' "
            #    @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            #else
            #    where_addon = " AND student_relate.staff_id = '#{arg}' "
            #    @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            #end
            where_addon = " AND student_relate.staff_id = '#{arg}' AND student_relate.active IS TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def student_communications(arg)
        
        join_addon = " LEFT JOIN student_communications ON student_communications.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND (
                (student_communications.sent IS FALSE AND student_communications.communications_id = '#{arg}' )
                OR student_communications.sent IS NULL
            ) "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def student_relate_active(arg)
        
        joined_table = "#{$tables.attach("STUDENT_RELATE").data_base}.student_relate"
        
        where_addon = " AND #{joined_table}.active IS TRUE "  if arg == true
        where_addon = " AND #{joined_table}.active IS FALSE " if arg == false
        
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def student_id(arg)
        where_addon = " AND student.student_id = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    end
    
    #def test_event_participated(arg) #arg should be test_event_id
    #    
    #    if arg
    #        
    #        join_addon =
    #            " LEFT JOIN student_tests ON student_tests.student_id = student.student_id
    #            LEFT JOIN test_event_sites ON test_event_sites.primary_id = student_tests.test_event_site_id"
    #        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
    #            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
    #        end
    #        
    #        
    #        where_addon = String.new
    #            
    #        if arg.class == String
    #            
    #            where_addon << " AND test_event_sites.test_event_id = '#{arg}'"
    #            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    #           
    #        elsif arg.class == Array
    #            
    #            where_addon << " AND ("
    #            or_clause = nil
    #            arg.each{|a|
    #                
    #                where_addon << (or_clause ? " OR test_event_sites.test_event_id = '#{a}'" : " test_event_sites.test_event_id = '#{a}'")
    #                
    #            }
    #            where_addon << ") "
    #            
    #            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
    #            
    #        end
    #        
    #        @search_options[:order_by_addon] = " ORDER BY student_id, completed ASC "
    #        
    #    else
    #        
    #        raise("#{arg} is not a valid option")
    #        
    #    end
    #    
    #end
    
    def student_test(arg)
        
        join_addon =
            " LEFT JOIN student_tests ON student_tests.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = " AND test_id = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon   
        
    end
    
    def student_test_participated(arg)
        
        join_addon =
            " LEFT JOIN student_tests ON student_tests.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = " AND test_id = '#{arg}' AND completed IS NOT NULL "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon   
        
    end
    
    def student_test_event(arg)
        
        join_addon =
            " LEFT JOIN student_tests ON student_tests.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon = " AND test_event_id = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon   
        
    end
    
    def student_test_date(arg)
        
        join_addon =
            " LEFT JOIN student_tests ON student_tests.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon << " AND test_id = '#{arg}'"
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon   
        
    end
    
    def team_id(arg)
        
        joined_table = "#{$tables.attach("STUDENT_RELATE").data_base}.student_relate"
        
        where_addon = " AND #{joined_table}.team_id = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def test_event_site(arg)
        
        join_addon =
            " LEFT JOIN student_test_dates ON student_test_dates.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        where_addon =
            " AND student_test_dates.test_event_site_id = '#{arg}' "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def tier(arg)
        if arg
            
            join_addon = " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND (
                    student_assessment.tier_level_math REGEXP '#{arg}'
                    OR
                    student_assessment.tier_level_reading REGEXP '#{arg}'
                ) "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        else
            raise("#{arg} is not a valid option")
        end 
    end

    def tier_math(arg)
        if arg
            
            join_addon = " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND student_assessment.tier_level_math REGEXP '#{arg}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def tier_reading(arg)
        if arg
            
            join_addon = " LEFT JOIN student_assessment ON student_assessment.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            
            where_addon =
                " AND student_assessment.tier_level_reading REGEXP '#{arg}' "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            
        else
            raise("#{arg} is not a valid option")
        end 
    end
    
    def withdrawal_codes_excluded(arg) #accepts an array of agora withdrawal codes
        
        join_addon =
            " LEFT JOIN k12_withdrawal ON k12_withdrawal.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        ########################################################################
        #THE FOLLOWING IS A TEMPORARY FIX THAT ONLY FIXES THE ISSUE FOR THE FAMILY COACHES:
            #ADDED K12 name MATCH IN THE STUDENT_RELATE TABLE ----- IMPORTANT!!!!----------
            #THIS MUST BE CHANGED BACK AS SOON AS THERE IS A PROPER FIX IN PLACE.
        ########################################################################
        
        join_addon =
            " LEFT JOIN k12_staff ON student_relate.staff_id = k12_staff.samspersonid "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND (k12_staff.firstname = k12_withdrawal.teacher_first_name AND k12_staff.lastname = k12_withdrawal.teacher_last_name)"
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
        ########################################################################
        ########################################################################
        
        where_addon =
            " AND k12_withdrawal.transferring_to NOT IN ('#{arg.join("','")}')"
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def withdrawal_codes_included(arg) #accepts an array of agora withdrawal codes
        
        join_addon =
            " LEFT JOIN k12_withdrawal ON k12_withdrawal.student_id = student.student_id "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        ########################################################################
        #THE FOLLOWING IS A TEMPORARY FIX THAT ONLY FIXES THE ISSUE FOR THE FAMILY COACHES:
            #ADDED K12 name MATCH IN THE STUDENT_RELATE TABLE ----- IMPORTANT!!!!----------
            #THIS MUST BE CHANGED BACK AS SOON AS THERE IS A PROPER FIX IN PLACE.
        ########################################################################
        
        join_addon =
            " LEFT JOIN k12_staff ON student_relate.staff_id = k12_staff.samspersonid "
        if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
            @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
        end
        
        where_addon =
            " AND (k12_staff.firstname = k12_withdrawal.teacher_first_name AND k12_staff.lastname = k12_withdrawal.teacher_last_name)"
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
        ########################################################################
        ########################################################################
        
        where_addon =
            " AND k12_withdrawal.transferring_to IN ('#{arg.join("','")}')"
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
        
    end
    
    def withdrawn(arg)
        
        where_addon =
            " AND student.schoolwithdrawdate IS NOT NULL "
        @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon 
        
    end
    alias :withdrawn_students_only :withdrawn
    
    def withdrawing_completed(arg)
        #(:current_students_only=>true, :withdrawal_processed=>true, :withdrawal_incomplete=>true)
        if arg == true
            join_addon =
                " LEFT JOIN withdrawing ON withdrawing.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND withdrawing.completed_date IS NOT NULL "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            order_addon =
                " ORDER BY withdrawing.eligible_date, student.studentlastname, student.studentfirstname"
            @search_options[:order_by_addon] = order_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def withdrawing_eligible(arg)
        if arg == true
            currently_enrolled(true)
            join_addon =
                " LEFT JOIN withdrawing ON withdrawing.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND withdrawing.eligible_date <= CURDATE()
                AND withdrawing.completed_date IS NULL
                AND withdrawing.processed IS NOT TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            order_addon =
                " ORDER BY withdrawing.eligible_date, student.studentlastname, student.studentfirstname"
            @search_options[:order_by_addon] = order_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def withdrawing_pending(arg)
        if arg == true
            join_addon =
                " LEFT JOIN withdrawing ON withdrawing.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND withdrawing.eligible_date > CURDATE()
                AND withdrawing.completed_date IS NULL
                AND withdrawing.processed IS NOT TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon 
            order_addon =
                " ORDER BY withdrawing.eligible_date, student.studentlastname, student.studentfirstname"
            @search_options[:order_by_addon] = order_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
    def withdrawing_processed(arg)
        #(:current_students_only=>true, :withdrawal_processed=>true, :withdrawal_incomplete=>true)
        if arg == true
            join_addon =
                " LEFT JOIN withdrawing ON withdrawing.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND withdrawing.completed_date IS NULL
                AND withdrawing.processed IS TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            order_addon =
                " ORDER BY withdrawing.eligible_date, student.studentlastname, student.studentfirstname"
            @search_options[:order_by_addon] = order_addon
        else
            raise("#{arg} is not a valid option")
        end
    end

    def withdrawing_retracted(arg)
        if arg == true
            currently_enrolled(true)
            join_addon =
                " LEFT JOIN withdrawing ON withdrawing.student_id = student.student_id "
            if @search_options[:join_addon].nil? || (!@search_options[:join_addon].nil? && !@search_options[:join_addon].include?(join_addon))
                @search_options[:join_addon] = @search_options[:join_addon].nil? ? join_addon : @search_options[:join_addon] + join_addon
            end
            where_addon =
                " AND withdrawing.retracted IS TRUE "
            @search_options[:where_clause_addon] = @search_options[:where_clause_addon].nil? ? where_addon : @search_options[:where_clause_addon] + where_addon
            order_addon =
                " ORDER BY withdrawing.eligible_date, student.studentlastname, student.studentfirstname"
            @search_options[:order_by_addon] = order_addon
        else
            raise("#{arg} is not a valid option")
        end
    end
    
end
