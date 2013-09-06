#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_STAFF < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def by_email(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("email", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_k12_name(k12_name)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("CONCAT(firstname,' ',lastname)", "=", k12_name) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def record_by_k12_name(k12_name)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("CONCAT(firstname,' ',lastname)", "=", k12_name) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY samspersonid ASC"
        record(where_clause) 
    end
    
    def field_bysamsid(field_name, samsid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("samspersonid", "=", samsid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def by_samsid(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("samspersonid", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def staff_with_records
        $db.get_data_single("SELECT samspersonid FROM #{data_base}.#{table_name} group by samspersonid") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_load_k12_staff
        
        $base.wordpress.after_load_k12_staff
        team_setup_from_k12_staff
        deactivate_team_members
        
    end
    
    def deactivate_team_members
        t_db     = $tables.attach("team").data_base
        tsids_db = $tables.attach("team_sams_ids").data_base
        k12_db = $tables.attach("k12_staff").data_base
        
        members_to_mark_inactive = $db.get_data_single(
            
            "SELECT team.primary_id 
            FROM #{t_db}.team 
            WHERE team.primary_id NOT IN(
                SELECT
                    team.primary_id 
                FROM #{t_db}.team 
                LEFT JOIN #{tsids_db}.team_sams_ids ON #{tsids_db}.team_sams_ids.team_id  = #{t_db}.team.primary_id
                LEFT JOIN #{k12_db}.k12_staff     ON #{k12_db}.k12_staff.samspersonid = #{tsids_db}.team_sams_ids.sams_id
                WHERE active IS TRUE
                AND k12_staff.samspersonid IS NOT NULL
                GROUP BY team.primary_id
            )"
            
        )
        
        members_to_mark_inactive.each{|pid|
            
            record = $tables.attach("team").by_primary_id(pid)
            record.fields["active"].set(false).save
            
        } if members_to_mark_inactive
        
    end
    
    def team_setup_from_k12_staff
        
        primary_ids.each{|pid|
          
          k12_record  = by_primary_id(pid)
          sams_id     = k12_record.fields["samspersonid"].value
          sams_email  = k12_record.fields["email"       ].value
          sams_phone  = k12_record.fields["homephone"   ].value
          
            if $base.is_num?(sams_id)
                
                t = $team.by_team_email(sams_email)
                
                if !t
                    
                    t = $team.by_sams_id(sams_id)
                    
                end
                
                if !t
                    
                    t = $team.new_team_member
                    
                    #FNORD - SINCE THIS INFO IS ONLY ADDED ONCE AND NEVER UPDATED AGAIN WE MAY NEED TO RE-EXAMINE THIS
                    #IF WE EVEN NEED TO START SENDING ACTUAL MAIL.
                    
                    #TEAM RECORD
                    t.legal_first_name.set(   k12_record.fields["firstname"      ].value ).save
                    t.legal_last_name.set(    k12_record.fields["lastname"       ].value ).save
                    t.mailing_address_1.set(  k12_record.fields["mailingaddress1"].value ).save
                    t.mailing_address_2.set(  k12_record.fields["mailingaddress2"].value ).save
                    t.mailing_city.set(       k12_record.fields["mailingcity"    ].value ).save
                    t.mailing_state.set(      k12_record.fields["mailingstate"   ].value ).save
                    t.mailing_zip.set(        k12_record.fields["mailingzip"     ].value ).save
                    
                end
              
                team_id = t.primary_id.value
                
                t.active.set(true).save
                
                #TEAM PHONE NUMBERS RECORD
                old_phone_number = t.preferred_phone
                if  old_phone_number && (old_phone_number.value != sams_phone)
                    
                    old_phone_record = $tables.attach("TEAM_PHONE_NUMBERS").by_primary_id(old_phone_number.primary_id)
                    old_phone_record.fields["preferred"].value = false
                    old_phone_record.save
                    
                end
                current_phone_number = $tables.attach("TEAM_PHONE_NUMBERS").by_phone_number(sams_phone, team_id) || t.phone_numbers.new_record 
                current_phone_number.fields["phone_number"  ].value = sams_phone
                current_phone_number.fields["type"          ].value = "work"
                current_phone_number.fields["preferred"     ].value = true
                current_phone_number.save     
                
                #TEAM EMAIL RECORD
                old_email_address = t.preferred_email
                if  old_email_address && (old_email_address.value != sams_email)
                    
                    old_email_record = $tables.attach("TEAM_EMAIL").by_primary_id(old_email_address.primary_id)
                    old_email_record.fields["preferred"].value = false
                    old_email_record.save
                    
                end
                current_email_address = $tables.attach("TEAM_EMAIL").by_email(sams_email, team_id) || t.email.new_record 
                current_email_address.fields["email_address" ].value = sams_email
                current_email_address.fields["email_type"    ].value = "work"
                current_email_address.fields["preferred"     ].value = true
                current_email_address.save    
                
                #TEAM SAMSIDS RECORD
                if !$tables.attach("TEAM_SAMS_IDS").by_sams_id(sams_id, team_id)
                  
                    samsid_record = t.sams_ids.new_record
                    samsid_record.fields["sams_id"       ].value = sams_id
                    samsid_record.save
                  
                end
              
            end
          
        }
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_staff",
                "file_name"         => "agora_staffList.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_staffList.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "Staff List"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["schoolname"]       = {"data_type"=>"text",     "file_field"=>"SCHOOLNAME"}        if field_order.push("schoolname")
            structure_hash["fields"]["samspersonid"]     = {"data_type"=>"int",      "file_field"=>"SAMSPERSONID"}      if field_order.push("samspersonid")
            structure_hash["fields"]["identityid"]       = {"data_type"=>"int",      "file_field"=>"IDENTITYID"}        if field_order.push("identityid")
            structure_hash["fields"]["lastname"]         = {"data_type"=>"text",     "file_field"=>"LASTNAME"}          if field_order.push("lastname")
            structure_hash["fields"]["firstname"]        = {"data_type"=>"text",     "file_field"=>"FIRSTNAME"}         if field_order.push("firstname")
            structure_hash["fields"]["position"]         = {"data_type"=>"text",     "file_field"=>"POSITION"}          if field_order.push("position")
            structure_hash["fields"]["email"]            = {"data_type"=>"text",     "file_field"=>"EMAIL"}             if field_order.push("email")
            structure_hash["fields"]["homephone"]        = {"data_type"=>"text",     "file_field"=>"HOMEPHONE"}         if field_order.push("homephone")
            structure_hash["fields"]["mailingaddress1"]  = {"data_type"=>"text",     "file_field"=>"MAILINGADDRESS1"}   if field_order.push("mailingaddress1")
            structure_hash["fields"]["mailingaddress2"]  = {"data_type"=>"text",     "file_field"=>"MAILINGADDRESS2"}   if field_order.push("mailingaddress2")
            structure_hash["fields"]["mailingcity"]      = {"data_type"=>"text",     "file_field"=>"MAILINGCITY"}       if field_order.push("mailingcity")
            structure_hash["fields"]["mailingstate"]     = {"data_type"=>"text",     "file_field"=>"MAILINGSTATE"}      if field_order.push("mailingstate")
            structure_hash["fields"]["mailingzip"]       = {"data_type"=>"text",     "file_field"=>"MAILINGZIP"}        if field_order.push("mailingzip")
            structure_hash["fields"]["shippingaddress1"] = {"data_type"=>"text",     "file_field"=>"SHIPPINGADDRESS1"}  if field_order.push("shippingaddress1")
            structure_hash["fields"]["shippingaddress2"] = {"data_type"=>"text",     "file_field"=>"SHIPPINGADDRESS2"}  if field_order.push("shippingaddress2")
            structure_hash["fields"]["shippingcity"]     = {"data_type"=>"text",     "file_field"=>"SHIPPINGCITY"}      if field_order.push("shippingcity")
            structure_hash["fields"]["shippingstate"]    = {"data_type"=>"text",     "file_field"=>"SHIPPINGSTATE"}     if field_order.push("shippingstate")
            structure_hash["fields"]["shippingzip"]      = {"data_type"=>"text",     "file_field"=>"SHIPPINGZIP"}       if field_order.push("shippingzip")
            structure_hash["fields"]["hiredate"]         = {"data_type"=>"date",     "file_field"=>"HIREDATE"}          if field_order.push("hiredate")
            structure_hash["fields"]["isspecialed"]      = {"data_type"=>"text",     "file_field"=>"ISSPECIALED"}       if field_order.push("isspecialed")
            structure_hash["fields"]["percentoftime"]    = {"data_type"=>"int",      "file_field"=>"PERCENTOFTIME"}     if field_order.push("percentoftime")
            structure_hash["fields"]["staffrole"]        = {"data_type"=>"text",     "file_field"=>"STAFFROLE"}         if field_order.push("staffrole")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end