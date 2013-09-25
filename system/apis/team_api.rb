#!/usr/local/bin/ruby -W0

class Team_API
    
    #---------------------------------------------------------------------------
    def initialize(team_id = nil)
        @structure              = nil
        @team_id                = team_id
        @where                  = " WHERE team_id = '#{@team_id}'"
        define_accessor_methods
        verify_requirements     if self.exists?
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
    
    def expand_mystudents
        #return expand_mystudents_enrolled
        tabs = Array.new
        tabs.push(["Enrolled",              expand_mystudents_enrolled  ])
        tabs.push(["Withdrawn",             expand_mystudents_withdrawn ])
        
        css = "<style>div#tabs_my_students .ui-tabs-nav {
            font-size: x-small;
        }</style>"
        
        content = $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            tab_id          = "my_students",
            search          = false
        )
        
        return css+content
        
    end
    
    def expand_mystudents_enrolled
        
        tables_array = [
            
            #HEADERS
            [
             
                "Student ID"                ,
                "Last Name"                 ,
                "First Name"                ,
                "Grade Level"               ,
                "Family ID"                 ,
                "Birthday"                  ,
                "Family Coach"              ,
                "Enroll Date"               ,
                "Special Ed Teacher"        ,
                "District of Residence"     ,
                "SI Level"                  ,
                "Attendance Mode"           ,
                "Scantron Ent Math"         ,
                "Scantron Exit Math"        ,
                "Scantron Ent Reading"      ,
                "Scantron Exit Reading"
                
            ]
            
        ]
        
        sids = self.enrolled_students
        
        sids.each{|sid|
            
            s = $students.get(sid)
            row = Array.new
            
            row.push(s.student_id.value                                 ) 
            row.push(s.studentlastname.value                            ) 
            row.push(s.studentfirstname.value                           ) 
            row.push(s.grade.value                                      ) 
            row.push(s.familyid.value                                   ) 
            row.push(s.birthday.value                                   ) 
            row.push(s.primaryteacher.value                             ) 
            row.push(s.schoolenrolldate.to_user                         ) 
            row.push(s.specialedteacher.value                           ) 
            row.push(s.districtofresidence.value                        )
            
            si_level = s.study_island_level.color_code
            row.push(!si_level ?  "" : si_level.web.label(:style=>"color:#{(si_level.value.nil? ? "" : si_level.value.downcase)};") )
            
            row.push(s.attendance_mode.existing_record ? s.attendance_mode.existing_record.fields["attendance_mode"].value : "" )
            
            scantron_exists = s.scantron_performance_level.existing_record
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ent_perf_m.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ext_perf_m.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ent_perf_r.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ext_perf_r.value : "" )
            
            tables_array.push(row)
            
        } if sids
        
        return $kit.tools.data_table(tables_array, "my_enrolled_students")
        
    end
    
    def expand_mystudents_withdrawn
        
        tables_array = [
            
            #HEADERS
            [
             
                "Student ID"                ,
                "Last Name"                 ,
                "First Name"                ,
                "Grade Level"               ,
                "Family ID"                 ,
                "Birthday"                  ,
                "Family Coach"              ,
                "Enroll Date"               ,
                "Special Ed Teacher"        ,
                "District of Residence"     ,
                "SI Level"                  ,
                "Attendance Mode"           ,
                "Scantron Ent Math"         ,
                "Scantron Exit Math"        ,
                "Scantron Ent Reading"      ,
                "Scantron Exit Reading"
                
            ]
            
        ]
        
        sids = self.withdrawn_students
        
        sids.each{|sid|
            
            s = $students.get(sid)
            row = Array.new
            
            row.push(s.student_id.value                                 ) 
            row.push(s.studentlastname.value                            ) 
            row.push(s.studentfirstname.value                           ) 
            row.push(s.grade.value                                      ) 
            row.push(s.familyid.value                                   ) 
            row.push(s.birthday.value                                   ) 
            row.push(s.primaryteacher.value                             ) 
            row.push(s.schoolenrolldate.value                           ) 
            row.push(s.specialedteacher.value                           ) 
            row.push(s.districtofresidence.value                        )
            
            si_level = s.study_island_level.color_code
            row.push(!si_level ?  "" : si_level.web.label(:style=>"color:#{(si_level.value.nil? ? "" : si_level.value.downcase)};") )
            
            row.push(s.attendance_mode.existing_record ? s.attendance_mode.existing_record.fields["attendance_mode"].value : "" )
            
            scantron_exists = s.scantron_performance_level.existing_record
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ent_perf_m.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ext_perf_m.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ent_perf_r.value : "" )
            row.push(scantron_exists ?  s.scantron_performance_level.stron_ext_perf_r.value : "" )
            
            tables_array.push(row)
            
        } if sids
        
       return $kit.tools.data_table(tables_array, "my_withdrawn_students")
        
    end
    
    def department_record
        $tables.attach("DEPARTMENT").by_primary_id(self.department_id.value)
    end
    
    def document_paths(options={:type=>nil, :name=>nil})
        
        where_clause = "WHERE team_id = #{@team_id} "
        where_clause << "AND document_type = '#{options[:type]}' " if options[:type]
        where_clause << "AND document_name = '#{options[:name]}' " if options[:name]
        where_clause << "ORDER BY created_date DESC "
      
        $tables.attach("TEAM_DOCUMENTS").primary_ids(where_clause)
        
    end
    
    def exists?
        if $tables.attach("TEAM").field_by_pid("primary_id", @team_id)
            return self
        else
            return false
        end
    end
    
    def full_name
        self.primary_id.to_name(:full_name)
    end
    
    def preferred_email
        
        return $tables.attach("TEAM_EMAIL").find_field(
            "email_address",
            " WHERE team_id = '#{@team_id}'
            AND preferred IS TRUE "
        )
        
    end
    
    def preferred_phone
        
        return $tables.attach("TEAM_PHONE_NUMBERS").find_field(
            "phone_number",
            " WHERE team_id = '#{@team_id}'
            AND preferred IS TRUE "
        )
        
    end
    
    def role_details
        
        sams_ids = self.sams_ids.existing_fields("sams_id", {:value_only=>true}).join("|")
        sr_db = $tables.attach("student_relate").data_base
        return $db.get_data_single(
            
            "SELECT role_details
             FROM #{sr_db}.student_relate
             WHERE staff_id REGEXP '#{sams_ids}'
             AND active = TRUE
             GROUP BY role_details
            ",
            $tables.attach("STUDENT_RELATE").data_base
        )
    end
    
    def super_user?
        
        if !structure[:super_user_evaluated]
            structure[:is_super_user       ] = ($team_member.rights.super_user_group.is_true? || (self.department_category.value == "Software"))
            structure[:super_user_evaluated] = true
        end
        
        return structure[:is_super_user]
        
    end
    
    def last_login_id
        tl_db = $tables.attach("team_log").data_base
        x = $db.get_data_single(
            
            "SELECT primary_id
            FROM #{tl_db}.team_log
            WHERE team_id = '#{@team_id}'
            ORDER BY created_date DESC ",
            $tables.attach("TEAM_LOG").data_base            
        )
        
        return x ? x[0] : x
        
    end  
    
    def send_email(a={})
        #:subject               => nil,        
        #:content               => nil,         
        #:sender                => nil,
        #:additional_recipients => nil,
        #:attachment_name       => nil,  
        #:attachment_path       => nil,
        #:email_relate          => [
        #    {:table_name=>nil, :key_field=>nil, :key_field_value=>nil},
        #    {:table_name=>nil, :key_field=>nil, :key_field_value=>nil}
        #]
        
        $base.email.send(
            :subject            => a[:subject           ],        
            :content            => a[:content           ],         
            :sender             => a[:sender            ],
            :recipients         => a[:additional_recipients ] ? a[:additional_recipients].push(self.preferred_email.value) : [self.preferred_email.value],
            :attachment_name    => a[:attachment_name   ], 
            :attachment_path    => a[:attachment_path   ],
            :email_relate       => a[:email_relate      ]
        )
        
        #(subject, content, attachment = nil, additional_recipients = nil)
        #recipients = [self.preferred_email.value]
        #if additional_recipients.class == String
        #    additional_recipients=additional_recipients.split(",")
        #end
        #
        #additional_recipients.each{|rec|recipients.push(rec)} if additional_recipients
        #
        #$base.email.athena_smtp_email(recipients, subject, content, attachment)
        
    end
    
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________RELATED_STUDENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def assigned_students(options = nil)
        
        if options.nil?
            
            options = {
                :team_id                => self.primary_id.value
            }
            
        else
            
            options[:team_id                ] = self.primary_id.value
            
        end
        
        sids = $tables.attach("STUDENT_RELATE").students_group(options)
        
        if sids && options[:student_table] && options[:table_field]
            
            if options[:where_clause]
                
                where_arr       = options[:where_clause].split(" ")
                where_arr.delete_at(0)
                where_arr       = where_arr.join(" ").insert(0,"AND ")
                
            end
            
            where_clause    = " WHERE student_id IN (#{sids.join(",")}) #{where_arr}"
            $tables.attach(options[:student_table]).find_fields(options[:table_field], where_clause, {:value_only=>options[:value_only]}) 
            
        else
            
            return sids
            
        end
        
    end
    
    def enrolled_students(options = nil)
        
        if options.nil?
            
            options = {
                :student_relate_active  => true,
                :team_id                => self.primary_id.value
            }
            
        else
            
            options[:student_relate_active  ] = true
            options[:team_id                ] = self.primary_id.value
            
        end
        
        sids = $tables.attach("STUDENT_RELATE").students_group(options)
        
        if sids && options[:student_table] && options[:table_field]
            
            if options[:where_clause]
                
                where_arr       = options[:where_clause].split(" ")
                where_arr.delete_at(0)
                where_arr       = where_arr.join(" ").insert(0,"AND ")
                
            end
            
            where_clause    = " WHERE student_id IN (#{sids.join(",")}) #{where_arr}"
            $tables.attach(options[:student_table]).find_fields(options[:table_field], where_clause, {:value_only=>options[:value_only]}) 
            
        else
            
            return sids
            
        end
        
    end
    
    def withdrawn_students(options = nil)
        
        if options.nil?
            
            options = {
                :withdrawn              => true,
                :team_id                => self.primary_id.value
            }
            
        else
            
            options[:withdrawn              ] = true
            options[:team_id                ] = self.primary_id.value
            
        end
        
        sids = $tables.attach("STUDENT_RELATE").students_group(options)
        
        if sids && options[:student_table] && options[:table_field]
            
            if options[:where_clause]
                
                where_arr       = options[:where_clause].split(" ")
                where_arr.delete_at(0)
                where_arr       = where_arr.join(" ").insert(0,"AND ")
                
            end
            
            where_clause = " WHERE student_id IN (#{sids.join(",")}) #{where_arr}"
            $tables.attach(options[:student_table]).find_fields(options[:table_field], where_clause, {:value_only=>options[:value_only]}) 
            
        else
            
            return sids
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________RELATED_TEAM_MEMBERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_with
        t_db = $tables.attach("team").data_base
        $db.get_data_single(
            
            "SELECT primary_id
            FROM #{t_db}.team
            WHERE active IS TRUE
            AND department = '#{self.department_id.value}'",
            $tables.attach("TEAM").data_base 
            
        )
        
    end
    
    def peers_with
        t_db = $tables.attach("team").data_base
        $db.get_data_single(
            
            "SELECT primary_id
            FROM #{t_db}.team
            WHERE active IS TRUE
            AND department_id = '#{self.department_id.value}'
            AND peer_group_id = '#{self.peer_group_id.value}'",
            $tables.attach("TEAM").data_base 
            
        )
        
    end
    
    def supervisor_of(options = {})
        
        where_clause    = "WHERE supervisor_team_id = #{@team_id} "
        
        t_db = $tables.attach("team").data_base
        
        if $team.department_heads && $team.department_heads.include?(@team_id)
            
            where_clause << "OR department_id = '#{self.department_id.value}'"
            
        end
        
        if self.department_category.value == "Software"
            
            where_clause =
                "WHERE active IS TRUE"
            where_clause << " AND department_category ='Engagement'" if false
            where_clause << " AND primary_id IN (
                '243',
                '1',
                '623',
                '100',
                '103',
                '106',
                '101',
                '117',
                '662'
            )" if true
            
            results = $db.get_data_single(
                "SELECT primary_id
                FROM #{t_db}.team
                #{where_clause}",
                $tables.attach("TEAM").data_base
            )
            
            return !results ? results : results.shift(10) #USE THIS TO LIMIT RESULTS WHEN TESTING
            
        end
        
        return $db.get_data_single(
            "SELECT primary_id
            FROM #{t_db}.team
            #{where_clause}
            AND primary_id != #{@team_id}",
            $tables.attach("TEAM").data_base 
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def new_record(table_name)
        this_row = $tables.attach(table_name).new_row
        this_row.fields["team_id" ].value = @team_id
        return this_row
    end
    
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

    def team_id=(arg)
        structure["team_id"] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________BUILD_API
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def create_method(name, &block)
        self.class.send(:define_method, name, &block)
    end

    def define_accessor_methods
        #BUILD TABLE FIELD ACCESSOR METHODS FOR MAIN OBJECT
        table = $tables.attach(self.class.to_s.gsub("_API",""))
        table.fields.each_key{|f_name|
            create_method(f_name.to_sym) {
                $tables.attach(self.class.to_s.gsub("_API","")).field_by_pid(f_name, @team_id) 
            }
        }if table.relationship == :one_to_one
        
        #BUILD SUB-TABLE METHODS
        Dir.glob("#{$paths.tables_path}TEAM_*.rb").each{|entry|
            function_table_name = entry.split("/")[-1].gsub(".rb","").upcase
            function_name       = function_table_name.gsub(/TEAM_/i,"").downcase.to_sym
            create_method(function_name) {
                if !structure.has_key?(function_name)
                    dynamic_name = function_table_name.insert(-1,"_API")
                    Object.const_set(
                        dynamic_name,
                        Class.new() {
                            def initialize(team_id_arg)
                                @team_id    = team_id_arg
                                @structure  = Hash.new
                                @where      = " WHERE team_id = '#{@team_id}'"
                                define_methods
                            end
                            def define_methods
                                #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO ONE RELATIONSHIPS
                                table = $tables.attach(self.class.to_s.gsub("_API",""))
                                
                                #IF THERE CAN BE ONLY ONE RECORD PER STUDENT
                                if table.relationship == :one_to_one
                                    
                                    #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO ONE RELATIONSHIPS
                                    create_method(:existing_record) {
                                        $tables.attach(self.class.to_s.gsub("_API","")).by_tid(@team_id) 
                                    }
                                    
                                    #CREATE A FUNCTION FOR EACH FIELD OF THAT RECORD
                                    table.fields.each_key{|f_name|
                                        create_method(f_name.to_sym) {
                                            $tables.attach(self.class.to_s.gsub("_API","")).field_by_tid(f_name, @team_id) 
                                        }
                                    }
                                    
                                    self.existing_record
                                    
                                #IF THE STUDENT CAN HAVE MANY RECORDS IN THIS TABLE
                                elsif table.relationship == :one_to_many
                                    
                                    #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO MANY RELATIONSHIPS
                                    create_method(:existing_records) {
                                        $tables.attach(self.class.to_s.gsub("_API","")).by_tid(@team_id) 
                                    }
                                    
                                    #BUILD FUNCTION THAT GET SPECIFIED FIELD NAME FROM ALL EXISTING RECORDS
                                    create_method(:existing_fields) { |field_name, options|
                                        $tables.attach(self.class.to_s.gsub("_API","")).find_fields(field_name, @where, options) 
                                    }
                                    
                                end
                                
                                if self.class.to_s.match(/snapshot/i)
                                    
                                    create_method(:by_snapshot_date) { |snapshot_date|
                                        
                                        if pids = $tables.attach(self.class.to_s.gsub("_API","")).primary_ids("#{@where} AND created_date REGEXP '#{snapshot_date}'")
                                            pid = pids[0]
                                            #CREATE A FUNCTION FOR EACH FIELD OF THAT RECORD
                                            table.fields.each_key{|f_name|
                                                create_method(f_name.to_sym) {
                                                    if x = $tables.attach(self.class.to_s.gsub("_API","")).field_by_pid(f_name, pid)
                                                        return x[0]
                                                    end
                                                }
                                            }
                                            return true
                                        else
                                            return false
                                        end
                                        
                                    }
                                    
                                end
                                
                                create_method(:field_values) {|field_name, where_addon|
                                    $tables.attach(self.class.to_s.gsub("_API","")).find_fields(field_name, "#{@where} #{where_addon}", options = {:value_only=>true})
                                }
                                create_method(:field_values_to_user) {|field_name, where_addon|
                                    $tables.attach(self.class.to_s.gsub("_API","")).find_fields(field_name, "#{@where} #{where_addon}", options = {:value_only=>true,:to_user=>true})
                                }
                            end
                            def create_method(name, &block)
                                self.class.send(:define_method, name, &block)
                            end
                            def new_record
                                this_record = $tables.attach(self.class.to_s.gsub("_API","")).new_row
                                this_record.fields["team_id" ].value = @team_id
                                return this_record
                            end
                        }
                    )
                    
                    structure[function_name] = eval(dynamic_name).new(@team_id)
                end
                structure[function_name]
            }
        }
    end

    def verify_requirements
        
        required_one_to_one_tables = [
            "rights"
        ]
        
        required_one_to_one_tables.each{|required_table|
            
            send(required_table).existing_record || send(required_table).new_record.save
            
        }
        
    end

end