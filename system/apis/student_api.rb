#!/usr/local/bin/ruby

class Student_API
    
    #---------------------------------------------------------------------------
    def initialize(student_id = nil)
        @structure  = nil
        @sid        = student_id
        define_accessor_methods
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def currently_enrolled?
        $students.list(:student_id=>@sid,:currently_enrolled=>true)
    end
    
    def exists?
        if $tables.attach("STUDENT").field_by_sid("primary_id", @sid)
            return self
        else
            return false
        end
    end
    
    def full_name
        "#{self.studentfirstname.value} #{self.studentlastname.value}"
    end
    
    def meets_criteria(options = nil)
        
        if options.nil?
            
            options = {
                :student_id => @sid
            }
            
        else
            
            options[:student_id] = @sid
            
        end
        
        sid = $tables.attach("STUDENT_RELATE").students_group(options)
        
        return (sid ? true : false)
        
    end

    def queue_kmail(subject, content, sender)
        params = Hash.new
        params[:sender              ] = "#{sender}:tv"
        params[:subject             ] = subject
        params[:content             ] = content
        params[:recipient_studentid ] = @sid
        return $base.queue_kmail(params)
    end   
    
    def related_team_records(option = nil)
        
        where_clause = " WHERE studentid = '#{@sid}'
            AND active IS TRUE "
        where_clause <<
            " AND role REGEXP 'Primary Teacher|High School Teacher|Middle School Teacher' " if option == :academic
        where_clause <<
            " AND role REGEXP 'Primary Teacher|High School Teacher|Middle School Teacher|Reading Specialist|Math Specialist'
              AND (role_details NOT REGEXP 'Service Learning|PE \\\\(Middle School\\\\)|Advanced Physical' OR role_details IS NULL) " if option == :academic_plan
        return $tables.attach("STUDENT_RELATE").records(where_clause)
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def new_row(table_name)
        this_row = $tables.attach(table_name).new_row
        this_row.fields["student_id" ].value = student_id if this_row.fields["student_id" ]
        this_row.fields["studentid"  ].value = student_id if this_row.fields["studentid"  ]
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

    def student_id=(arg)
        structure["student_id"] = arg
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________BUILD_API
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def create_method(name, &block)
        self.class.send(:define_method, name, &block)
    end

    def define_accessor_methods
        #BUILD TABLE FIELD ACCESSOR METHODS FOR MAIN STUDENT OBJECT
        table = $tables.attach(self.class.to_s.gsub("_API",""))
        table.fields.each_key{|f_name|
            create_method(f_name.to_sym) {
                $tables.attach(self.class.to_s.gsub("_API","")).field_by_sid(f_name, @sid) 
            }
        }if table.relationship == :one_to_one
        
        #BUILD SUB-TABLE METHODS
        Dir.glob("#{$paths.tables_path}STUDENT_*.rb").each{|entry|
            function_table_name = entry.split("/")[-1].gsub(".rb","").upcase
            function_name       = function_table_name.gsub(/STUDENT_/i,"").downcase.to_sym
            create_method(function_name) {
                if !structure.has_key?(function_name)
                    dynamic_name = function_table_name.insert(-1,"_API")
                    Object.const_set(
                        dynamic_name,
                        Class.new() {
                            def initialize(sid_arg)
                                @sid        = sid_arg
                                @structure  = Hash.new
                                define_methods
                            end
                            def define_methods
                                #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO ONE RELATIONSHIPS
                                table = $tables.attach(self.class.to_s.gsub("_API",""))
                                
                                #IF THERE CAN BE ONLY ONE RECORD PER STUDENT
                                if table.relationship == :one_to_one
                                    
                                    #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO ONE RELATIONSHIPS
                                    create_method(:existing_record) {
                                        $tables.attach(self.class.to_s.gsub("_API","")).by_studentid(@sid) 
                                    }
                                    
                                    #CREATE A FUNCTION FOR EACH FIELD OF THAT RECORD
                                    table.fields.each_key{|f_name|
                                        create_method(f_name.to_sym) {
                                            $tables.attach(self.class.to_s.gsub("_API","")).field_by_sid(f_name, @sid) 
                                        }
                                    }
                                    
                                    self.existing_record
                                    
                                #IF THE STUDENT CAN HAVE MANY RECORDS IN THIS TABLE
                                elsif table.relationship == :one_to_many
                                    
                                    #BUILD SUB-TABLE FIELD/RECORD ACCESSOR METHODS FOR ONE TO MANY RELATIONSHIPS
                                    create_method(:existing_records) { |where_clause_addon|
                                        $tables.attach(self.class.to_s.gsub("_API","")).by_studentid(@sid, where_clause_addon)
                                    }
                                end
                                
                            end
                            def create_method(name, &block)
                                self.class.send(:define_method, name, &block)
                            end
                            def new_record
                                this_record = $tables.attach(self.class.to_s.gsub("_API","")).new_row
                                this_record.fields["student_id" ].value = @sid if this_record.fields["student_id" ]
                                this_record.fields["studentid"  ].value = @sid if this_record.fields["studentid"  ]
                                return this_record
                            end
                        }
                    )
                    
                    structure[function_name] = eval(dynamic_name).new(@sid)
                end
                structure[function_name]
            }
        }
    end

end