#!/usr/local/bin/ruby

class Team_Member
    
    #---------------------------------------------------------------------------
    def initialize(staff_id = nil)
        @structure    = nil
        self.staff_id = staff_id
    end
    #---------------------------------------------------------------------------

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
    def k12_first_name
        if !structure.has_key?("k12_first_name") && samsid
            results = $tables.attach("K12_Staff").field_bysamsid("firstname",samsid.value)
            structure["k12_first_name"] = results if results
        end
        structure["k12_first_name"]
    end
    
    def k12_fullname
        if !structure.has_key?("k12_fullname") && samsid && k12_first_name && k12_last_name
            params = {
                "type"  => "text",
                "field" => "team_member_fullname",
                "value" => "#{k12_first_name.value} #{k12_last_name.value}"
            }
            structure["k12_fullname"] = $field.new(params)
        end
        structure["k12_fullname"]
    end
    alias :k12_name :k12_fullname
    
    def k12_last_name
        if !structure.has_key?("k12_last_name") && samsid
            results = $tables.attach("K12_Staff").field_bysamsid("lastname",samsid.value)
            structure["k12_last_name"] = results if results
        end
        structure["k12_last_name"]
    end
    
    def aka
        if !structure.has_key?("aka")
            results = $tables.attach("Staff").field_bystaffid("aka",staff_id)
            structure["aka"] = results if results
        end
        structure["aka"]
    end
    
    def department
        if !structure.has_key?("department")
            results = $tables.attach("Staff").field_bystaffid("department",staff_id)
            structure["department"] = results if results
        end
        structure["department"]
    end
    
    def dob
        if !structure.has_key?("dob")
            results = $tables.attach("Staff").field_bystaffid("dob",staff_id)
            structure["dob"] = results if results
        end
        structure["dob"]
    end
    
    def email_records
        if !structure.has_key?("email_addresses")
            results = $tables.attach("Staff_Email_Addresses").by_staffid(staff_id)
            structure["email_addresses"] = results if results
        end
        structure["email_addresses"]
    end
    
    def employee_type
        if !structure.has_key?("employee_type")
            results = $tables.attach("Staff").field_bystaffid("employee_type",staff_id)
            structure["employee_type"] = results if results
        end
        structure["employee_type"]
    end
    
    def ethnicity
        if !structure.has_key?("ethnicity")
            results = $tables.attach("Staff").field_bystaffid("ethnicity",staff_id)
            structure["ethnicity"] = results if results
        end
        structure["ethnicity"]
    end
    
    def evaluation_peer_group
        $tables.attach("TEAM_PEER_RELATE").field_by_samsid("peer_group", sams_id)
    end
    
    def evaluation_record(role) #Role is required as some people may have more than one assignment
        $tables.attach("EVALUATION_METRICS").by_samsid_role(samsid.value, role)
    end
    
    def gender
        if !structure.has_key?("gender")
            results = $tables.attach("Staff").field_bystaffid("gender",staff_id)
            structure["gender"] = results if results
        end
        structure["gender"]
    end
    
    def highest_degree
        if !structure.has_key?("highest_degree")
            results = $tables.attach("Staff").field_bystaffid("highest_degree",staff_id)
            structure["highest_degree"] = results if results
        end
        structure["highest_degree"]
    end
    
    def legal_first_name
        if !structure.has_key?("legal_first_name")
            results = $tables.attach("Staff").field_bystaffid("legal_first_name",staff_id)
            structure["legal_first_name"] = results if results
        end
        structure["legal_first_name"]
    end
    
    def legal_last_name
        if !structure.has_key?("legal_last_name")
            results = $tables.attach("Staff").field_bystaffid("legal_last_name",staff_id)
            structure["legal_last_name"] = results if results
        end
        structure["legal_last_name"]
    end
    
    def legal_middle_name
        if !structure.has_key?("legal_middle_name")
            results = $tables.attach("Staff").field_bystaffid("legal_middle_name",staff_id)
            structure["legal_middle_name"] = results if results
        end
        structure["legal_middle_name"]
    end
    
    def mailing_address_1
        if !structure.has_key?("mailing_address_1")
            results = $tables.attach("Staff").field_bystaffid("mailing_address_1",staff_id)
            structure["mailing_address_1"] = results if results
        end
        structure["mailing_address_1"]
    end
    
    def mailing_address_2
        if !structure.has_key?("mailing_address_2")
            results = $tables.attach("Staff").field_bystaffid("mailing_address_2",staff_id)
            structure["mailing_address_2"] = results if results
        end
        structure["mailing_address_2"]
    end
    
    def mailing_city
        if !structure.has_key?("mailing_city")
            results = $tables.attach("Staff").field_bystaffid("mailing_city",staff_id)
            structure["mailing_city"] = results if results
        end
        structure["mailing_city"]
    end
    
    def mailing_county
        if !structure.has_key?("mailing_county")
            results = $tables.attach("Staff").field_bystaffid("mailing_county",staff_id)
            structure["mailing_county"] = results if results
        end
        structure["mailing_county"]
    end
    
    def mailing_state
        if !structure.has_key?("mailing_state")
            results = $tables.attach("Staff").field_bystaffid("mailing_state",staff_id)
            structure["mailing_state"] = results if results
        end
        structure["mailing_state"]
    end
    
    def mailing_zip
        if !structure.has_key?("mailing_zip")
            results = $tables.attach("Staff").field_bystaffid("mailing_zip",staff_id)
            structure["mailing_zip"] = results if results
        end
        structure["mailing_zip"]
    end
    
    def phone_numbers_records
        if !structure.has_key?("phone_numbers")
            results = $tables.attach("Staff_Phone_Numbers").by_staffid(staff_id)
            structure["phone_numbers"] = results if results
        end
        structure["phone_numbers"]
    end
    
    def ppid
        if !structure.has_key?("ppid")
            results = $tables.attach("Staff").field_bystaffid("ppid",staff_id)
            structure["ppid"] = results if results
        end
        structure["ppid"]
    end
    
    def shipping_address_1
        if !structure.has_key?("shipping_address_1")
            results = $tables.attach("Staff").field_bystaffid("shipping_address_1",staff_id)
            structure["shipping_address_1"] = results if results
        end
        structure["shipping_address_1"]
    end
    
    def shipping_address_2
        if !structure.has_key?("shipping_address_2")
            results = $tables.attach("Staff").field_bystaffid("shipping_address_2",staff_id)
            structure["shipping_address_2"] = results if results
        end
        structure["shipping_address_2"]
    end
    
    def shipping_city
        if !structure.has_key?("shipping_city")
            results = $tables.attach("Staff").field_bystaffid("shipping_city",staff_id)
            structure["shipping_city"] = results if results
        end
        structure["shipping_city"]
    end
    
    def shipping_county
        if !structure.has_key?("shipping_county")
            results = $tables.attach("Staff").field_bystaffid("shipping_county",staff_id)
            structure["shipping_county"] = results if results
        end
        structure["shipping_county"]
    end
    
    def shipping_state
        if !structure.has_key?("shipping_state")
            results = $tables.attach("Staff").field_bystaffid("shipping_state",staff_id)
            structure["shipping_state"] = results if results
        end
        structure["shipping_state"]
    end
    
    def shipping_zip
        if !structure.has_key?("shipping_zip")
            results = $tables.attach("Staff").field_bystaffid("shipping_zip",staff_id)
            structure["shipping_zip"] = results if results
        end
        structure["shipping_zip"]
    end
    
    def ssn
        if !structure.has_key?("ssn")
            results = $tables.attach("Staff").field_bystaffid("ssn",staff_id)
            structure["ssn"] = results if results
        end
        structure["ssn"]
    end
    
    def suffix
        if !structure.has_key?("suffix")
            results = $tables.attach("Staff").field_bystaffid("suffix",staff_id)
            structure["suffix"] = results if results
        end
        structure["suffix"]
    end
    
    def supervisor
        if !structure.has_key?("supervisor")
            results = $tables.attach("Staff").field_bystaffid("supervisor",staff_id)
            structure["supervisor"] = results if results
        end
        structure["supervisor"]
    end
    
    def teacher_breakdown
        if !structure.has_key?("teacher_breakdown")
            results = $tables.attach("Staff").field_bystaffid("teacher_breakdown",staff_id)
            structure["teacher_breakdown"] = results if results
        end
        structure["teacher_breakdown"]
    end
    
    def work_im
        if !structure.has_key?("work_im")
            results = $tables.attach("Staff").field_bystaffid("work_im",staff_id)
            structure["work_im"] = results if results
        end
        structure["work_im"]
    end
    
    def year_entered_education
        if !structure.has_key?("year_entered_education")
            results = $tables.attach("Staff").field_bystaffid("year_entered_education",staff_id)
            structure["year_entered_education"] = results if results
        end
        structure["year_entered_education"]
    end
    
    def email_address_k12
        if !structure.has_key?("email_address_k12") && samsid
            results = $tables.attach("K12_Staff").field_bysamsid("email",samsid.value)
            structure["email_address_k12"] = results if results
        end
        structure["email_address_k12"]
    end
    alias :email :email_address_k12
    
    def has_students? #FNORD - This will need to be changed. student relate will need to enter he staff id instead of the samspersonid
        if !structure.has_key?("has_students")
            if students
                structure["has_students"] = true
            else
                structure["has_students"] = false
            end
        end
        structure["has_students"]
    end
    
    def has_team?
        if !structure.has_key?("has_team")
            if team_members
                structure["has_team"] = true
            else
                structure["has_team"] = false
            end
        end
        structure["has_team"]
    end
    
    def last_name
        if !structure.has_key?("last_name")
            results = $tables.attach("Staff").field_bystaffid("last_name",staff_id)
            structure["last_name"] = results if results
        end
        structure["last_name"]
    end
    
    def output_type
        structure["output_type"]
    end
    
    def progress_admin?
        if !structure.has_key?(:progress_admin)
            results = $tables.attach("Student_Relate").with_records_admin
            if results
                structure[:progress_admin] = true if results.include?(samsid.value)
            else
                structure[:progress_admin] = false
            end
        end
        structure[:progress_admin]
    end
    
    def primary_teachers_for_related_students(student_group = nil) #returns an array of teachers (k12_names) of students related to the team member.
        $tables.attach("Student_Relate").primary_teachers_by_staffid(samsid.value, student_group)
    end
    
    def pssa_site_ids 
        if structure[:pssa_site].nil?
            structure[:pssa_site] = $tables.attach("PSSA_SITES_STAFF").sites_by_k12name(k12_name.value)
        end
        structure[:pssa_site]
    end
    
    def pssa_site_students(site_id)
        structure[:pssa_site_students] = $tables.attach("Pssa_Assignments").by_siteid(site_id)
    end
    
    def pssa_students #returns only student's who are eligible to take the pssa's this school year.
        if structure[:pssa_students].nil?
            structure[:pssa_students] = $tables.attach("Student_Relate").with_records_by_samsid_pssa_eligible(samsid.value)
        end
        structure[:pssa_students]
    end
    
    def samsid
        if !structure.has_key?("samsid")
            results = $tables.attach("Staff").field_bystaffid("samspersonid", staff_id.value)
            structure["samsid"] = results
        end
        structure["samsid"]
    end
    alias :sams_id :samsid
    
    def staff_id
        structure["staff_id"]
    end
    
    #def students(option = nil)
    #    if !option
    #        $tables.attach("Student_Relate").with_records_by_samsid(samsid.value)
    #    elsif option == :k6
    #        $tables.attach("Student_Relate").with_records_by_samsid_k6(samsid.value)
    #    end
    #end

    def team_members
        if !structure.has_key?("team_members")
            team_array = Array.new
            records = $tables.attach("Team_Relate").by_lead_sams_id(samsid)
            if records
                records.each{|record|
                    samsid = record.fields["sams_id"].value
                    staff_records = $tables.attach("Staff").by_samsid(samsid)
                    if staff_records
                        staff_records.each do |staff_record|
                            staffid = staff_record.fields["primary_id"].value
                            team_array.push($staff[staffid])
                        end
                    end
                }
                if team_array.length > 0
                    structure["team_members"] = team_array
                end
            end
            #The code below if to be used once we can switch to using staffid ubiquitously
            #team_array = Array.new
            #members = $tables["team_relate"].by_lead_staff_id(samspersonid)
            #if members
            #    members.each{|member| team_array.push($staff[member.staff_id])}
            #end
            #@team_members = team_array
        end
        return structure["team_members"]
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def send_email(subject, content, attachment = nil)
        $config.athena_smtp_email(email_address_k12.value, subject, content, attachment)
    end 
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________QUESTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def is_ftc?
        answer = false
        answer = true if $team.family_teacher_coaches.include?(k12_name.value)
        return answer
    end
    
    def is_k6_teacher?
        answer = false
        answer = true if $team.k6_teachers.include?(k12_name.value)
        return answer
    end
    
    def is_pssa_site_staff?
        answer = false
        answer = true if $tables.attach("PSSA_SITES_STAFF").by_k12name(k12_name.value)
        return answer
    end
    
    def is_specialed_teacher?
        answer = false
        answer = true if $team.specialed_teachers.include?(k12_name.value)
        return answer
    end
    
    def is_teacher?
        answer = false
        answer = true if $team.k6_teachers.include?(k12_name.value)
        return answer
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STUDENT_LISTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def student_demographic_set
        if !structure.has_key?(:student_demographic_set)
            structure[:student_demographic_set] = Hash.new
        end
        structure[:student_demographic_set]
    end
    
    def student_demographic_set=(arg)
        if arg.is_a? Hash
            structure[:student_demographic_set] = arg
        elsif arg.nil?
            
        else
            raise "#{__FILE__} #{__LINE__} student_demographic_set must be a set with options, or Nilclass"
        end
        
    end
    
    def students(options = nil)
        options = Hash.new if !options
        options[:staff_id               ] = samsid.value unless options[:school_wide]
        options[:student_demographic_set] = student_demographic_set
        $tables.attach("Student_Relate").students_group(options)
    end

################################################################################ THESE SHOULD BE DELETABLE --->    
    #def all_students(options)
    #    options[:staff_id] = samsid.value
    #    options[:demographic_set] = structure[:demographic_set]
    #    if $switch == "High School"
    #        $tables.attach("STUDENT_RELATE_7_12").students(options)
    #    elsif $switch
    #        $tables.attach("STUDENT_MASTER_RELATE").students(options)
    #    else
    #        $tables.attach("Student_Relate").all_students_by_samsid(options)
    #    end
    #end
    #
    #def current_students(options)
    #    options[:staff_id]              = samsid.value
    #    options[:demographic_set] = structure[:demographic_set]
    #    options[:current_students_only] = true
    #    if $switch == "High School"
    #        $tables.attach("STUDENT_RELATE_7_12").students(options)
    #    elsif $switch
    #        $tables.attach("STUDENT_MASTER_RELATE").students(options)
    #    else
    #        $tables.attach("Student_Relate").current_students_by_samsid(options)
    #    end
    #end
    #
    #def withdrawn_students(options)
    #    options[:staff_id]                  = samsid.value
    #    options[:demographic_set]           = structure[:demographic_set]
    #    options[:withdrawn_students_only]   = true
    #    if $switch == "High School"
    #        $tables.attach("STUDENT_RELATE_7_12").students(options)
    #    elsif $switch
    #        $tables.attach("STUDENT_MASTER_RELATE").students(options)
    #    else
    #        $tables.attach("Student_Relate").withdrawn_students_by_samsid(options)
    #    end
    #end
################################################################################ <--- THESE SHOULD BE DELETABLE
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def output_type=(arg)
        structure["output_type"] = arg
    end
    
    #This is makeshift until we get the staff tables populated
    def samsid=(arg) 
        params = {
            "type"  => "int",
            "field" => "samsid",
            "value" => arg
        }
        structure["samsid"] = $field.new(params)
    end

    def staff_id=(arg) 
        params = {
            "type"  => "int",
            "field" => "staff_id",
            "value" => arg
        }
        structure["staff_id"] = $field.new(params)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def metrics
        if !structure.has_key?("metrics")
            require "#{File.dirname(__FILE__)}/team_metrics"
            structure["metrics"] = Team_Metrics.new(self)
        end
        structure["metrics"]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
    def new_row(table_name)
        this_row = $tables.attach(table_name).new_row
        this_row.field["samsid"     ].value = samsid    if this_row.field["samsid"     ]
        this_row.field["staff_id"   ].value = staff_id  if this_row.field["staff_id"   ]
        return this_row
    end  
    
end
