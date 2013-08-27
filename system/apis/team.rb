#!/usr/local/bin/ruby
require "#{$paths.api_path}/team/team_member"
require "#{$paths.api_path}/team_api"

class Team

    #---------------------------------------------------------------------------
    def initialize()
        @structure = nil
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________API_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def filter(a)
        
        join_addon      =  " LEFT JOIN team_sams_ids  ON student_relate.staff_id  = team_sams_ids.sams_id"
        join_addon      << " LEFT JOIN team           ON team_sams_ids.team_id    = team.primary_id"
        
        where_clause    = "WHERE 1"
        where_clause << " AND role = '#{a[:role]}'" if a[:role]
        where_clause << " #{a[:where_addon]}"
        where_clause << " AND student_relate.active IS #{a[:active_students]}" if a[:active_students]
        sams_ids = $tables.attach("STUDENT_RELATE").staff_ids(
            "#{join_addon} #{where_clause}"
        )
        
        return sams_ids if a[:sams_ids]
        
        if sams_ids
            
            return team_ids = $db.get_data_single(
                "SELECT 
                    team_id
                FROM team_sams_ids
                WHERE sams_id IN('#{sams_ids.join("','")}')"
            )
            
        else
            return false
        end
        
    end
    
    def by_team_email(arg)
        
        record = $tables.attach("TEAM_EMAIL").by_email(arg)
        if record
            return get(record.fields["team_id"].value)
        else
            return false
        end
        
    end
    
    def by_sams_id(arg)
        
        record = $tables.attach("TEAM_SAMS_IDS").by_sams_id(arg)
        if record
            return get(record.fields["team_id"].value)
        else
            return false
        end
        
    end
    
    def find(a={})
        
        full_name = a[:full_name]
        a.delete(:full_name)
        
        max_passes  = 2
        pass        = 1
        
        begin
            
            where_clause = String.new
            
            if full_name
                
                if (name_array = full_name.split(" ")).length == 2
                    first_name = name_array[0]
                    last_name  = name_array[1]
                else
                    if pass == 1
                        last_name  = name_array.delete_at(-1)
                        first_name = name_array.join(" ")
                    elsif pass == 2
                        first_name = name_array.delete_at(0)
                        last_name  = name_array.join(" ")
                    end
                    
                end
                
                a[:legal_first_name] = first_name
                a[:legal_last_name ] = last_name
                
            end
            
            if a[:sams_id]
                where_clause << "LEFT JOIN team_sams_ids ON team_sams_ids.team_id = team.primary_id"
            end
            
            if a[:email_address]
                where_clause << "LEFT JOIN team_email ON team_email.team_id = team.primary_id"
            end
            
            exclude_options  = [
                :ids_only
            ]
            exact_match_only = [
                "primary_id",
                "sams_id",
                "active"
            ]
            where_clause << " WHERE 1"
            a.each_pair{|k,v|
                
                unless exclude_options.include?(k)
                    
                    evaluation_operator = exact_match_only.include?(k.to_s)? "=" : "REGEXP"
                    
                    where_clause << " AND #{k} #{evaluation_operator} '#{v}'"
                    
                end
                
            }
            
            tids = $db.get_data_single(
                
                "SELECT team.primary_id
                FROM team
                #{where_clause}
                GROUP BY team.primary_id",
                $tables.attach("TEAM").data_base
                
            )
            
            if pass <= max_passes && !tids
                raise
            end
            
        rescue
            
            pass +=1
            retry 
          
        end
        
        return tids if a[:ids_only]
        
        return (tids ? get(tids[0]) : false)
        
    end
    
    def get(team_id)
        
        t=Team_API.new(team_id)
        
        if t.exists?
            one_to_one_setup(t)
            return t
        else
            return false
        end
        
    end
    
    def new_team_member
        
        t=Team_API.new($tables.attach("TEAM").new_row.save)
        
        if t.exists?
            one_to_one_setup(t)
            return t
        else
            return false
        end
        
    end
    
    def one_to_one_setup(t)
        
        #NOT SURE WE ACTUALLY WANT TO DO THIS FOR EVERY TEAM MEMBER
        
        #Dir.glob("#{$paths.tables_path}TEAM_*.rb").each{|entry|
        #    
        #    table_name = entry.split("/")[-1].gsub(".rb","")
        #    
        #    if $tables.attach(table_name).relationship == :one_to_one
        #        
        #        table_function = table_name.gsub("TEAM_", "").downcase  
        #        t.send("#{table_function}").existing_record || t.send("#{table_function}").new_record.save
        #        
        #    end
        #    
        #}
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LISTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def department_heads
        $db.get_data_single(
          "SELECT
            team.primary_id
          FROM team
          LEFT JOIN department ON department.head_team_id = team.primary_id
          WHERE department.head_team_id IS NOT NULL"
        )
    end

    def directors
        $tables.attach("team").primary_ids("WHERE employee_type = 'Director'")
    end
   
    def family_coach_program_support
        $db.get_data_single(
          "SELECT
            supervisor_team_id
          FROM team
          WHERE department_id = (
            SELECT
                primary_id
            FROM department
            WHERE name REGEXP 'Family Coach'
          )"
        )
    end
    
    def principals
        $tables.attach("team").primary_ids("WHERE employee_type = 'Principal'")
    end

    def related_to_students
        
        $db.get_data_single(
            "SELECT
                staff_id
            FROM student_relate
            WHERE active IS TRUE
            GROUP BY staff_id"
        )
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attach(staff_id)
        if structure.has_key?(staff_id)
            return structure[staff_id]
        else
            structure[staff_id] = Team_Member.new(staff_id)
            return structure[staff_id]
        end  
    end
    
    def attach_samsid(samsid)
        if structure.has_key?(samsid)
            return structure[samsid]
        else
            structure[samsid] = Team_Member.new
            structure[samsid].samsid = samsid
            return structure[samsid]
        end  
    end
    
    def by_email(email_address)
        record   = $tables.attach("K12_Staff").by_email(email_address)
        if record
            k12_name = "#{record.fields["firstname"].value} #{record.fields["lastname"].value}"
            return by_k12_name(k12_name)
        else
            return false
        end
        
        #rework this one hr come online
        
        #staff_id = false
        #record   = $tables.attach("K12_Staff").by_email(email_address)
        #if record
        #    sams_id         = record.fields["samspersonid"].value
        #    staff_record    = $tables.attach("Staff").by_samsid_regexp(sams_id) #This will have to change once the staff_samsperson table is made
        #    if staff_record
        #        s = staff_record.fields
        #        s["samspersonid"].value.split(",").each{|id| staff_id = s["primary_id"] if id == sams_id}
        #    end
        #    if staff_id
        #        return attach(staff_id.value)
        #    else
        #        return attach_samsid(sams_id)
        #    end
        #else
        #    return false
        #end
    end
    
    def by_k12_name(k12_name)
        record = $tables.attach("K12_Staff").record_by_k12_name(k12_name)
        if record
            sams_id = record.fields["samspersonid"].value
            return attach_samsid(sams_id)
        else
            return false
        end
        
        #rework this one hr come online
        
        #staff_id = false
        #records  = $tables.attach("K12_Staff").by_k12_name(k12_name)
        #if records
        #    records.each{|record|
        #        sams_id         = record.fields["samspersonid"].value
        #        staff_record    = $tables.attach("Staff").by_samsid_regexp(sams_id) #This will have to change once the staff_samsperson table is made
        #        if staff_record
        #            s = staff_record.fields
        #            s["samspersonid"].value.split(",").each{|id| staff_id = s["primary_id"] if id == sams_id}
        #        end
        #        if staff_id
        #            return attach(staff_id.value)
        #        else
        #            return attach_samsid(sams_id)
        #        end
        #    }
        #else
        #    return false
        #end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def evaluation_template_by_role(role)
        $tables.attach("RELATE_ROLES").field_byrole("evaluation_template", role)
    end
    
    def email_senior_team(subject, content, priority = nil, attachments = nil)
        $base.email.send("srteam@agora.org", subject, content, priority, attachments)
    end
    
    def family_teacher_coaches(grade=nil)
        struct_name = "family_teacher_coaches#{grade}"
        if !structure.has_key?(struct_name)
            structure[struct_name] = $db.get_data_single("SELECT primaryteacher FROM student WHERE primaryteacher IS NOT NULL")
        end  
        structure[struct_name]
    end
    alias :ftcs :family_teacher_coaches
    
    def k6_teachers(grade=nil)
        struct_name = "k6_teachers#{grade}"
        if !structure.has_key?(struct_name)
            structure[struct_name] = $tables.attach("K12_Omnibus").k6_teachers(grade)
        end  
        structure[struct_name]
    end
    
    def specialed_teachers(grade=nil)
        struct_name = "specialed_teachers#{grade}"
        if !structure.has_key?(struct_name)
            structure[struct_name] = $tables.attach("K12_Omnibus").specialed_teachers(grade)
        end  
        structure[struct_name]
    end
    
    def specialists
        if !structure.has_key?(:specialists)
            structure[:specialists] = $tables.attach("Studen_Relate").specialists
        end  
        structure[:specialists]
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________RELATE_ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def members_by_role(role)
        if $switch
            $tables.attach("STUDENT_RELATE_7_12").current_team_by_role(:role=>role)
        else
            
            $tables.attach("Student_Relate").current_team_by_role(:role=>role)
        end
    end
    
    def peer_groups_by_role(role)
        $tables.attach("TEAM_PEER_RELATE").peer_groups_by_role(role)
    end
    
    def peer_group_members_by_role_group(role, peer_group)
        $tables.attach("TEAM_PEER_RELATE").peer_group_members_by_role_group(role, peer_group)
    end
    
    def student_base_evaluation_roles
        $tables.attach("RELATE_ROLES").student_base_evaluation_roles
    end
    
    def student_based_evaluation_exempt(role)
        #FNORD - WHEN WORKING ON HR INCLUDE THIS FIELD AS PART OF THE STAFF RECORD
        #then replace the guts of this function
        results = []
        ineligible_team_members = false
        if role == "Family Teacher Coach"
            ineligible_team_members = [
                "Calvin Smith",
                "Quincy Clegg",
                "Crystal Pritchett",
                "Naquisha Hartwell",
                "Kelly Bowes",
                "Elisa Mindlin",
                "Nancy Wagner"
            ]
        end
        
        if ineligible_team_members
            ineligible_team_members.each{|member|
                results.push($team.by_k12_name(member).samsid.value)
            }
            return results
        else
            return false
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def set_structure(arg)
        if arg.is_a? Hash
            arg.each_pair{|k, v| @structure[k] = v}
        end
    end
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
end