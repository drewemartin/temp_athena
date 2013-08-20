#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_LOGINS < Athena_Table
    
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

    def by_familyid(arg, last_login = nil, official_attendance = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("familyid",   "=",        arg) )
        params.push( Struct::WHERE_PARAMS.new("role",       "REGEXP",   "1000|1001") )       if official_attendance
        params.push( Struct::WHERE_PARAMS.new("last_login", "REGEXP",   "#{last_login}.*") ) if last_login
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_regkey(arg, last_login = nil, official_attendance = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("regkey",     "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("role",       "REGEXP",   "1000|1001") )       if official_attendance
        params.push( Struct::WHERE_PARAMS.new("last_login", "REGEXP", "#{last_login}.*") ) if last_login
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_last_login(arg)
        where_clause =
            "WHERE last_login REGEXP '.*#{arg}.*'
            AND (role = '1000' OR role = '1001')"   
        records(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_logins
        this_hour = DateTime.now.strftime("%H")
        if (!this_hour.include?("0") && Integer(this_hour) > 15) && $field.is_schoolday?(DateTime.now)
            require "#{File.dirname(__FILE__).gsub("tables","reports")}/Login_Reminders_Report"
            Login_Reminders_Report.new
        end
    end
    def DISABLE_after_load_k12_logins
        #find the present students
        #$students.list(:current_students)
        omni             = $tables.attach("K12_Omnibus")
        master           = $tables.attach("Attendance_Master")
        current_students = omni.current_students
        att_day          = master.schooldays(cutoff_date = today.iso_date)[-1]
        present_students = Array.new
        missing_login    = Array.new
        by_last_login(att_day).each{|record|
            fid  = record.fields["familyid"].value
            reg  = record.fields["regkey"].value
            lcoaches = $tables.attach("K12_Learning_Coach").by_familyid(fid)
            if lcoaches
                lcoaches.each{|coach|
                    sid = coach.fields["student_id"].value
                    if !present_students.index(sid) && current_students.index(sid)
                        k8  = $students.student(sid).grade.match(/K|1st|2nd|3rd|4th|5th|6th|7th|8th/)
                        present_students.push(sid) if k8
                    end
                }
            end
            students = omni.by_familyid(fid)
            if students
                students.each{|student|
                    sid = student.fields["studentid"].value
                    if !present_students.index(sid) && current_students.index(sid)
                        k8  = $students.student(sid).grade.match(/K|1st|2nd|3rd|4th|5th|6th|7th|8th/)
                        present_students.push(sid) if k8
                    end
                }
            end
            lcoach_reg = omni.by_lcregid(reg)
            if lcoach_reg
                lcoach_reg.each{|student|
                    sid = student.fields["studentid"].value
                    if !present_students.index(sid) && current_students.index(sid)
                        k8  = $students.student(sid).grade.match(/K|1st|2nd|3rd|4th|5th|6th|7th|8th/)
                        present_students.push(sid) if k8
                    end
                }
            end
            missing_login.push(fid) if !lcoaches && !students && !missing_login.index(fid)
        }
        #create report
        file  = $base.user_file("Attendance/k8_present")
        file.puts "Student ID"
        present_students.each{|s| file.puts s}
        file.close
        
        #update attendance master
        master.batch_present(students, att_day)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "k12_logins",
                "file_name"         => "agora_logins.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_logins.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["accountid"]       = {"data_type"=>"int",      "file_field"=>"ACCOUNTID"}      if field_order.push("accountid")
        structure_hash["fields"]["identityid"]      = {"data_type"=>"int",      "file_field"=>"IDENTITYID"}     if field_order.push("identityid")
        structure_hash["fields"]["familyid"]        = {"data_type"=>"int",      "file_field"=>"FAMILYID"}       if field_order.push("familyid")
        structure_hash["fields"]["integrationid"]   = {"data_type"=>"text",     "file_field"=>"INTEGRATIONID"}  if field_order.push("integrationid")
        structure_hash["fields"]["status"]          = {"data_type"=>"text",     "file_field"=>"STATUS"}         if field_order.push("status")
        structure_hash["fields"]["schoolid"]        = {"data_type"=>"int",      "file_field"=>"SCHOOLID"}       if field_order.push("schoolid")
        structure_hash["fields"]["role"]            = {"data_type"=>"int",      "file_field"=>"ROLE"}           if field_order.push("role")
        structure_hash["fields"]["rolename"]        = {"data_type"=>"text",     "file_field"=>"ROLENAME"}       if field_order.push("rolename")
        structure_hash["fields"]["lastname"]        = {"data_type"=>"text",     "file_field"=>"LASTNAME"}       if field_order.push("lastname")
        structure_hash["fields"]["firstname"]       = {"data_type"=>"text",     "file_field"=>"FIRSTNAME"}      if field_order.push("firstname")
        structure_hash["fields"]["homephone"]       = {"data_type"=>"text",     "file_field"=>"HOMEPHONE"}      if field_order.push("homephone")
        structure_hash["fields"]["regkey"]          = {"data_type"=>"text",     "file_field"=>"REGKEY"}         if field_order.push("regkey")
        structure_hash["fields"]["first_login"]     = {"data_type"=>"datetime", "file_field"=>"FIRST_LOGIN"}    if field_order.push("first_login")
        structure_hash["fields"]["last_login"]      = {"data_type"=>"datetime", "file_field"=>"LAST_LOGIN"}     if field_order.push("last_login")
        structure_hash["fields"]["num_logins"]      = {"data_type"=>"int",      "file_field"=>"NUM_LOGINS"}     if field_order.push("num_logins")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end