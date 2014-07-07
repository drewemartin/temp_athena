#!/usr/local/bin/ruby

class WORDPRESS
    
    #---------------------------------------------------------------------------
    def initialize()
        #super()
        @table_structure = nil
        #@user_groups = set_user_groups
        #@full_access_users =
        #    [
        #        "tkreider@agora.org",
        #        "esaddler@agora.org",
        #        "jhalverson@agora.org",
        #        "dcambridge@agora.org",
        #        "crivera@agora.org",
        #        "kyoung@agora.org"
        #    ]
        
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_load_k12_staff #Since this is not a table class this funtion is called from the K12_Staff table class.
        user_ids = $tables.attach("K12_Staff").staff_with_records
        user_ids.each{|id|
            member      = $team.attach_samsid(id)
            user_login  = member.email.value
            if user_login && user_login.include?("@agora.org")
                user_id = get_user_id(user_login.downcase)
                #set_user_rights(member,user_id)
            end
        }
        i=0
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def add_group(groupname)
        insert_sql = 
            "INSERT INTO wordpress.wp_uam_accessgroups
            (`groupname`,`read_access`,`write_access`)
            VALUES('#{groupname.to_s}','group','group')"
        id = $db.insert(insert_sql)
    end
    
    def add_user(user_login)
        uniq_pass  = "agora_#{user_login.split("@")[0]}"
        user_pass  = Digest::MD5.hexdigest(uniq_pass)
        nice_name  = user_login.gsub("@","").gsub(".","-")
        insert_sql = 
            "INSERT INTO wordpress.wp_users
            (`user_login`,`user_pass`,`user_nicename`,`user_email`,`display_name`,`user_registered`)
            VALUES('#{user_login}','#{user_pass}','#{nice_name}','#{user_login}','#{user_login}','#{$idatetime}')"
        user_id = $db.insert(insert_sql)
        meta = {
            :first_name	                            =>"",                    
            :last_name	                            =>"",                    
            :nickname	                            =>user_login,               
            :description	                    =>"",                  
            :rich_editing	                    =>"true",             
            :comment_shortcuts	                    =>"false",
            :admin_color	                    =>"fresh", 
            :use_ssl	                            =>"0", 
            :show_admin_bar_front	            =>"true", 
            :show_admin_bar_admin	            =>"false", 
            :aim	                            =>"",
            :yim	                            =>"",
            :jabber	                            =>"",
            :wp_capabilities	                    =>"a:1:{s:10:\"subscriber\";s:1:\"1\";}", 
            :wp_user_level	                    =>"0"
        }
        meta.each_pair{|k,v|
            insert_sql = 
                "INSERT INTO wordpress.wp_usermeta
                (`user_id`,`meta_key`,`meta_value`)
                VALUES('#{user_id}','#{k}','#{v}')"
            results = $db.query(insert_sql)    
        }
        
        subject = "Athena Log-in Information"
        content = "An Athena account has been created for you. Please go to http://athena-sis.com to sign in.<br>
            Your username and password are below.<br><br>
            Username: #{user_login}<br>
            Password: #{uniq_pass}"
        $base.email.send(
            :subject            => subject,
            :content            => content,
            :sender             => "donotreply@athena-sis.com",
            :recipients         => user_login,
            :attachment_name    => nil,
            :attachment_path    => nil,
            :email_relate       => [
                {:table_name=>nil, :key_field=>nil, :key_field_value=>nil},
                {:table_name=>nil, :key_field=>nil, :key_field_value=>nil}
            ]
        )
        
        return user_id
    end
    
    def get_group_id(groupname)
        return group_exists?(groupname) || add_group(groupname)
    end
    
    def get_user_id(user_login)
        return user_exists?(user_login) || add_user(user_login)
    end
    
    def get_user_rights(user_id)
        select_sql =
            "SELECT
                group_id
            FROM wordpress.wp_uam_accessgroup_to_object
            WHERE object_id = '#{user_id}'
            AND object_type = 'user'"
        return $db.get_data_single(select_sql) || Array.new
    end
    
    def group_exists?(groupname)
        select_sql =
            "SELECT
                id
            FROM wordpress.wp_uam_accessgroups
            WHERE groupname = '#{groupname.to_s}'"
        results = $db.get_data_single(select_sql)
        return results ? results[0] : false
    end
    
    def user_exists?(user_login)
        select_sql =
            "SELECT
                id
            FROM wordpress.wp_users
            WHERE user_login = '#{user_login}'"
        results = $db.get_data_single(select_sql)
        return results ? results[0] : false
    end
    
    #def set_user_groups
    #    #return hash of id=>group_name
    #    groups = Hash.new
    #    
    #    #Attendance
    #    groups[:editor_tep_attendance       ] = {:id=>nil,:rule=>[]}
    #    groups[:editor_dnc_students         ] = {:id=>nil,:rule=>[]}
    #    groups[:editor_student_attendance   ] = {:id=>nil,:rule=>[]}
    #    
    #    #General - All Users
    #    groups[:athena_general              ] = {:id=>nil,:rule=>[:all_access]}
    #    groups[:athena_system_notes         ] = {:id=>nil,:rule=>[]}
    #    
    #    #General Operations
    #    groups[:editor_ink_order            ] = {:id=>nil,:rule=>[]}
    #    
    #    #Progress Reports
    #    groups[:editor_progress_reports_k6  ] = {:id=>nil,:rule=>["is_k6_teacher?"]}
    #    groups[:admini_progress_reports_k6  ] = {:id=>nil,:rule=>[]}
    #    
    #    #PSSA's
    #    groups[:reader_pssa_results         ] = {:id=>nil,:rule=>["is_teacher?","is_ftc?","is_specialed_teacher?"]}
    #    groups[:editor_pssa_results         ] = {:id=>nil,:rule=>[]}
    #    groups[:editor_pssa_assignments     ] = {:id=>nil,:rule=>["is_ftc?","is_specialed_teacher?"]}
    #    groups[:reader_pssa_assignments     ] = {:id=>nil,:rule=>[]}
    #    groups[:admini_pssa_assignments     ] = {:id=>nil,:rule=>[]}
    #    groups[:editor_pssa_attendance      ] = {:id=>nil,:rule=>["is_pssa_site_staff?"]}
    #    
    #    #Record Requests
    #    groups[:editor_record_requests      ] = {:id=>nil,:rule=>[]}
    #    
    #    #Report Access
    #    groups[:k12_reports                 ] = {:id=>nil,:rule=>[]}
    #    groups[:login_reminders_reports     ] = {:id=>nil,:rule=>[]}
    #    
    #    #Wihdrawal Processing
    #    groups[:editor_withdrawal_processing] = {:id=>nil,:rule=>["is_ftc?"]}
    #    
    #    groups.each_pair{|groupname,details|
    #        details[:id] = get_group_id(groupname)    
    #    }
    #    return groups
    #end
    
    #def set_user_rights(member,user_id)
    #    user_rights = Array.new
    #    @user_groups.each_value{|details|
    #        rule_applies = false
    #        details[:rule].each{|rule|
    #            rule_applies = true if rule == :all_access || member.send(rule)
    #            }
    #        rule_applies = true if @full_access_users.include?(member.email_address_k12.value)
    #        user_rights.push(details[:id]) if rule_applies
    #    }
    #    
    #    current_rights  = get_user_rights(user_id)
    #    #add rights
    #    
    #    user_rights.each{|right|
    #        if !current_rights.include?(right)
    #            insert_sql = 
    #                "INSERT INTO wordpress.wp_uam_accessgroup_to_object
    #                (`object_id`,`object_type`,`group_id`)
    #                VALUES('#{user_id}','user','#{right}')"
    #            results = $db.query(insert_sql)
    #        end   
    #    }
    #    #ENABLE THIS ONCE ALL THE RULES ARE SET!################################
    #    #remove rights
    #    #current_rights.each{|right|
    #    #    if !user_rights.include?(right)
    #    #        delete_sql = 
    #    #            "DELETE FROM wordpress.wp_uam_accessgroup_to_object
    #    #            WHERE `object_id` = '#{user_id}'
    #    #            AND `object_type` = 'user'
    #    #            AND `group_id`    = '#{right}'"
    #    #        results = $db.query(delete_sql)
    #    #    end   
    #    #}
    #end

end