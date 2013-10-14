#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_OMNIBUS < Athena_Table
    
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
    
    def by_familyid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("familyid", "=", "#{arg}") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_lcregid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("lcregistrationid", "REGEXP", ".*#{arg}.*") )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def current_students(studentid = nil)
        enroll_date = created_date ? created_date.split(" ")[0] : "CURDATE()"
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",        "=",      studentid    ) ) if studentid
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate", "IS NOT", "NULL"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate", "<=",     enroll_date  ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def current_k2_students
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("grade",              "REGEXP",   "K|1st|2nd"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"                  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()"             ) )
        params.push( Struct::WHERE_PARAMS.new("enrollapproveddate", "IS NOT",   "NULL"                  ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def current_36_students
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("grade",              "REGEXP",   "3rd|4th|5th|6th"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"                  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()"             ) )
        params.push( Struct::WHERE_PARAMS.new("enrollapproveddate", "IS NOT",   "NULL"                  ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def current_k6_students
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("grade",              "REGEXP",   "K|1st|2nd|3rd|4th|5th|6th"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()"  ) )
        params.push( Struct::WHERE_PARAMS.new("enrollapproveddate", "IS NOT",   "NULL"      ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    #def current_pssa_students(sid = nil)
    #    student_sql = sid ? "AND k12_omnibus.student_id = '#{sid}'" : ""
    #    select_sql =
    #        "SELECT student_id
    #        FROM k12_omnibus
    #        LEFT JOIN pssa_student_exceptions ON pssa_student_exceptions.student_id = k12_omnibus.student_id
    #        WHERE
    #            (
    #                (grade REGEXP '3rd|4th|5th|6th|7th|8th|11th' AND (testing_grade REGEXP '3rd|4th|5th|6th|7th|8th|11th' OR testing_grade IS NULL))
    #                    OR
    #                (testing_grade REGEXP '3rd|4th|5th|6th|7th|8th|11th')
    #            )
    #        AND schoolenrolldate IS NOT NULL
    #        AND schoolenrolldate <= CURDATE()
    #        AND enrollapproveddate IS NOT NULL
    #        #{student_sql}
    #        ORDER BY studentlastname, studentfirstname ASC"
    #    results = $db.get_data_single(select_sql)
    #    return results
    #end
    
    def current_specialed_students
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("specialedteacher",   "IS NOT",   "NULL"      ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"      ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()" ) )
        params.push( Struct::WHERE_PARAMS.new("enrollapproveddate", "IS NOT",   "NULL"      ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause} ORDER BY studentlastname, studentfirstname ASC") 
    end
    
    def newly_enrolled()
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate", "IS NOT", "NULL"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate", "<=",     "CURDATE()"  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate", ">=",     "DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)"  ) ) 
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def snap_caregivers
        sql_statement =
            "SELECT
                student_id,
                lglastname,
                lgfirstname,
                lgrelationship,
                lgemail
            FROM #{data_base}.k12_omnibus
            WHERE schoolenrolldate IS NOT NULL"
        $db.get_data(sql_statement) 
    end
    
    def snap_students
        sql_statement =
            "SELECT
                student_id,
                studentlastname,
                studentfirstname,
                studentmiddlename,
                birthday,
                studentgender,
                school,
                grade,
                primaryteacher,
                mailingaddress1,
                mailingaddress2,
                mailingcity,
                mailingstate,
                mailingzip,
                studenthomephone,
                ethnicity,
                cityofbirth,
                schoolenrolldate,
                isspecialed
            FROM #{data_base}.k12_omnibus
            WHERE schoolenrolldate IS NOT NULL"
        $db.get_data(sql_statement) 
    end
    
    def current_students_by_primary_teacher(primaryteacher)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primaryteacher",     "=",        primaryteacher  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"          ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()"     ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def current_students_by_primary_teacher_new(primaryteacher)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primaryteacher",     "=",        primaryteacher  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT",   "NULL"          ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",       "CURDATE()"     ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   ">",        $school.current_school_year_start.value     ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
    def students_by_title1teacher(teacher_name)
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name} WHERE title1teacher = '#{teacher_name}'") 
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{data_base}.#{table_name}") 
    end
    
    def title_1_teachers(grade = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("grade",              "REGEXP", grade        ) ) if grade
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "IS NOT", "NULL"       ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   "<=",     "CURDATE()"  ) )
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT title1teacher FROM #{data_base}.#{table_name} #{where_clause}") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TEAM_MEMBERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def family_teacher_coaches(grade=nil)
        grade_clause = grade ? "AND REGEXP '#{grade}'" : ""
        $db.get_data_single("SELECT primaryteacher FROM #{data_base}.k12_omnibus WHERE primaryteacher IS NOT NULL #{grade_clause} GROUP BY primaryteacher ORDER BY primaryteacher ASC") 
    end
    
    def k6_teachers(grade=nil)
        grade_clause = grade ? "AND REGEXP '#{grade}'" : ""
        $db.get_data_single(
            "SELECT title1teacher
            FROM #{data_base}.k12_omnibus
            WHERE grade REGEXP 'K|1st|2nd|3rd|4th|5th|6th'
            AND title1teacher IS NOT NULL
            #{grade_clause}
            GROUP BY title1teacher
            ORDER BY title1teacher ASC"
        ) 
    end
    
    def specialed_teachers(grade=nil)
        grade_clause = grade ? "AND REGEXP '#{grade}'" : ""
        $db.get_data_single("SELECT specialedteacher FROM #{data_base}.k12_omnibus WHERE specialedteacher IS NOT NULL #{grade_clause} GROUP BY specialedteacher ORDER BY specialedteacher ASC") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
    def after_load_k12_omnibus
        snap_update
    end
    
    def snap_update
        
        if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/)
            
            tried = 0
            begin
                ftp = Net::FTP.new('ftp.snaphealthcenter.com')
                ftp.passive = true
                ftp.login("AgoraCyberSchool", "ruprup7AdE")
                
                location = "Snap_Update"
                
                filename = "Students"
                headers  = [
                    "studentid",
                    "studentlastname",
                    "studentfirstname",
                    "studentmiddlename",
                    "birthday",
                    "studentgender",
                    "school",
                    "grade",
                    "primaryteacher",
                    "mailingaddress1",
                    "mailingaddress2",
                    "mailingcity",
                    "mailingstate",
                    "mailingzip",
                    "studenthomephone",
                    "ethnicity",
                    "cityofbirth",
                    "schoolenrolldate",
                    "isspecialed"
                ]
                students_file = $reports.csv(location, filename, snap_students.insert(0, headers)   )
                
                begin
                    
                    ftp.puttextfile(students_file)
                    ftp.rename("Students_#{$ifilestamp}.csv", "Students.csv")
                    File.delete(students_file)
                   
                rescue=>e
                    
                    $base.system_notification(
                        subject = "Snap Nursing - Export Failed",
                        content = "The file already exists. Snap did not import the 'Student' file for the previous day.",
                        caller[0],
                        e
                    )
                    
                end
                
                $reports.save_document({:csv_rows=>snap_students.insert(0, headers), :category_name=>"Nursing", :type_name=>"Snap Students Update"})
                
                filename = "Caregivers"
                headers  = [
                    "studentid",
                    "lglastname",
                    "lgfirstname",
                    "lgrelationship",
                    "lgemail"
                ]
                caregivers_file = $reports.csv(location, filename, snap_caregivers.insert(0, headers)   )
                
                begin
                    
                    ftp.puttextfile(caregivers_file)
                    ftp.rename("Caregivers_#{$ifilestamp}.csv", "Caregivers.csv")
                    File.delete(caregivers_file)
                   
                rescue=>e
                    
                    $base.system_notification(
                        subject = "Snap Nursing - Export Failed",
                        content = "The file already exists. Snap did not import the 'Caregivers' file for the previous day.",
                        caller[0],
                        e
                    )
                    
                end
                
                $reports.save_document({:csv_rows=>snap_caregivers.insert(0, headers), :category_name=>"Nursing", :type_name=>"Snap Caregivers Update"})
                
                ftp.close
                
            rescue=>e
                tried +=1
                retry unless tried == 3
                $base.system_notification(
                    subject = "Snap Nursing - Export Failed",
                    content = "Login Unsuccessful",
                    caller[0],
                    e
                )
            end
            
        end
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def special_validation(field_object)
        case field_object.field_name
        when "birthday"
            if !field_object.is_null?
                birthday = field_object.to_db
                age      = $base.age_from_date(birthday).to_i
                
                max_age = 21
                if age > max_age
                    field_object.validation_failed("Student is over maximum age allowed. (#{age})")
                end
                
                min_age = 4
                if age < min_age
                    field_object.validation_failed("Student is under minimum age allowed. (#{age})")
                end
              
            else
                field_object.validation_failed("Student's birthday was not entered.")
            end
        end
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
                "name"              => "k12_omnibus",
                "file_name"         => "agora_omnibus.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "/agora/agora_omnibus.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "Omnibus"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_id"]                  = {"data_type"=>"int",          "file_field"=>"STUDENTID"}                      if field_order.push("student_id")
        structure_hash["fields"]["integrationid"]               = {"data_type"=>"text",         "file_field"=>"INTEGRATIONID"}                  if field_order.push("integrationid")
        structure_hash["fields"]["identityid"]                  = {"data_type"=>"int",          "file_field"=>"IDENTITYID"}                     if field_order.push("identityid")
        structure_hash["fields"]["familyid"]                    = {"data_type"=>"int",          "file_field"=>"FAMILYID"}                       if field_order.push("familyid")
        structure_hash["fields"]["studentlastname"]             = {"data_type"=>"text",         "file_field"=>"STUDENTLASTNAME"}                if field_order.push("studentlastname")
        structure_hash["fields"]["studentfirstname"]            = {"data_type"=>"text",         "file_field"=>"STUDENTFIRSTNAME"}               if field_order.push("studentfirstname")
        structure_hash["fields"]["studentmiddlename"]           = {"data_type"=>"text",         "file_field"=>"STUDENTMIDDLENAME"}              if field_order.push("studentmiddlename")
        structure_hash["fields"]["studentgender"]               = {"data_type"=>"text",         "file_field"=>"STUDENTGENDER"}                  if field_order.push("studentgender")
        structure_hash["fields"]["grade"]                       = {"data_type"=>"text",         "file_field"=>"GRADE"}                          if field_order.push("grade")
        structure_hash["fields"]["birthday"]                    = {"data_type"=>"date",         "file_field"=>"BIRTHDAY"}                       if field_order.push("birthday")
        structure_hash["fields"]["mailingaddress1"]             = {"data_type"=>"text",         "file_field"=>"MAILINGADDRESS1"}                if field_order.push("mailingaddress1")
        structure_hash["fields"]["mailingaddress2"]             = {"data_type"=>"text",         "file_field"=>"MAILINGADDRESS2"}                if field_order.push("mailingaddress2")
        structure_hash["fields"]["mailingregion"]               = {"data_type"=>"text",         "file_field"=>"MAILINGREGION"}                  if field_order.push("mailingregion")
        structure_hash["fields"]["mailingcity"]                 = {"data_type"=>"text",         "file_field"=>"MAILINGCITY"}                    if field_order.push("mailingcity")
        structure_hash["fields"]["mailingzip"]                  = {"data_type"=>"text",         "file_field"=>"MAILINGZIP"}                     if field_order.push("mailingzip")
        structure_hash["fields"]["mailingstate"]                = {"data_type"=>"text",         "file_field"=>"MAILINGSTATE"}                   if field_order.push("mailingstate")
        structure_hash["fields"]["studenthomephone"]            = {"data_type"=>"text",         "file_field"=>"STUDENTHOMEPHONE"}               if field_order.push("studenthomephone")
        structure_hash["fields"]["shippingaddress1"]            = {"data_type"=>"text",         "file_field"=>"SHIPPINGADDRESS1"}               if field_order.push("shippingaddress1")
        structure_hash["fields"]["shippingaddress2"]            = {"data_type"=>"text",         "file_field"=>"SHIPPINGADDRESS2"}               if field_order.push("shippingaddress2")
        structure_hash["fields"]["shippingregion"]              = {"data_type"=>"text",         "file_field"=>"SHIPPINGREGION"}                 if field_order.push("shippingregion")
        structure_hash["fields"]["shippingcity"]                = {"data_type"=>"text",         "file_field"=>"SHIPPINGCITY"}                   if field_order.push("shippingcity")
        structure_hash["fields"]["scounty"]                     = {"data_type"=>"text",         "file_field"=>"SCOUNTY"}                        if field_order.push("scounty")
        structure_hash["fields"]["shippingzip"]                 = {"data_type"=>"text",         "file_field"=>"SHIPPINGZIP"}                    if field_order.push("shippingzip")
        structure_hash["fields"]["shippingstate"]               = {"data_type"=>"text",         "file_field"=>"SHIPPINGSTATE"}                  if field_order.push("shippingstate")
        structure_hash["fields"]["physicaladdress1"]            = {"data_type"=>"text",         "file_field"=>"physicalADDRESS1"}               if field_order.push("physicaladdress1")
        structure_hash["fields"]["physicaladdress2"]            = {"data_type"=>"text",         "file_field"=>"physicalADDRESS2"}               if field_order.push("physicaladdress2")
        structure_hash["fields"]["physicalregion"]              = {"data_type"=>"text",         "file_field"=>"physicalREGION"}                 if field_order.push("physicalregion")
        structure_hash["fields"]["physicalcity"]                = {"data_type"=>"text",         "file_field"=>"physicalCITY"}                   if field_order.push("physicalcity")
        structure_hash["fields"]["pcounty"]                     = {"data_type"=>"text",         "file_field"=>"PCOUNTY"}                        if field_order.push("pcounty")
        structure_hash["fields"]["physicalzip"]                 = {"data_type"=>"text",         "file_field"=>"physicalZIP"}                    if field_order.push("physicalzip")
        structure_hash["fields"]["physicalstate"]               = {"data_type"=>"text",         "file_field"=>"physicalSTATE"}                  if field_order.push("physicalstate")
        structure_hash["fields"]["enrollreceiveddate"]          = {"data_type"=>"date",         "file_field"=>"ENROLLRECEIVEDDATE"}             if field_order.push("enrollreceiveddate")
        structure_hash["fields"]["enrollapproveddate"]          = {"data_type"=>"date",         "file_field"=>"ENROLLAPPROVEDDATE"}             if field_order.push("enrollapproveddate")
        structure_hash["fields"]["schoolenrolldate"]            = {"data_type"=>"date",         "file_field"=>"SCHOOLENROLLDATE"}               if field_order.push("schoolenrolldate")
        structure_hash["fields"]["school"]                      = {"data_type"=>"text",         "file_field"=>"SCHOOL"}                         if field_order.push("school")
        structure_hash["fields"]["districtofresidence"]         = {"data_type"=>"text",         "file_field"=>"DISTRICTOFRESIDENCE"}            if field_order.push("districtofresidence")
        structure_hash["fields"]["initenrollyear"]              = {"data_type"=>"year",         "file_field"=>"INITENROLLYEAR"}                 if field_order.push("initenrollyear")
        structure_hash["fields"]["lclastname"]                  = {"data_type"=>"text",         "file_field"=>"LCLASTNAME"}                     if field_order.push("lclastname")
        structure_hash["fields"]["lcfirstname"]                 = {"data_type"=>"text",         "file_field"=>"LCFIRSTNAME"}                    if field_order.push("lcfirstname")
        structure_hash["fields"]["lcrelationship"]              = {"data_type"=>"text",         "file_field"=>"LCRELATIONSHIP"}                 if field_order.push("lcrelationship")
        structure_hash["fields"]["lcregistrationid"]            = {"data_type"=>"text",         "file_field"=>"LCREGISTRATIONID"}               if field_order.push("lcregistrationid")
        structure_hash["fields"]["lcemail"]                     = {"data_type"=>"text",         "file_field"=>"LCEMAIL"}                        if field_order.push("lcemail")
        structure_hash["fields"]["lglastname"]                  = {"data_type"=>"text",         "file_field"=>"LGLASTNAME"}                     if field_order.push("lglastname")
        structure_hash["fields"]["lgfirstname"]                 = {"data_type"=>"text",         "file_field"=>"LGFIRSTNAME"}                    if field_order.push("lgfirstname")
        structure_hash["fields"]["lgrelationship"]              = {"data_type"=>"text",         "file_field"=>"LGRELATIONSHIP"}                 if field_order.push("lgrelationship")
        structure_hash["fields"]["lgregistrationid"]            = {"data_type"=>"text",         "file_field"=>"LGREGISTRATIONID"}               if field_order.push("lgregistrationid")
        structure_hash["fields"]["lgemail"]                     = {"data_type"=>"text",         "file_field"=>"LGEMAIL"}                        if field_order.push("lgemail")
        structure_hash["fields"]["ethnicity"]                   = {"data_type"=>"text",         "file_field"=>"ETHNICITY"}                      if field_order.push("ethnicity")
        structure_hash["fields"]["hispanicorlatino"]            = {"data_type"=>"text",         "file_field"=>"HISPANICORLATINO"}               if field_order.push("hispanicorlatino")
        structure_hash["fields"]["othethnicities"]              = {"data_type"=>"text",         "file_field"=>"OTHETHNICITIES"}                 if field_order.push("othethnicities")
        structure_hash["fields"]["primaryteacher"]              = {"data_type"=>"text",         "file_field"=>"PRIMARYTEACHER"}                 if field_order.push("primaryteacher")
        structure_hash["fields"]["primaryteacherid"]            = {"data_type"=>"int",          "file_field"=>"PRIMARYTEACHERID"}               if field_order.push("primaryteacherid")
        structure_hash["fields"]["specialedteacher"]            = {"data_type"=>"text",         "file_field"=>"SPECIALEDTEACHER"}               if field_order.push("specialedteacher")
        structure_hash["fields"]["specialedteacherid"]          = {"data_type"=>"int",          "file_field"=>"SPECIALEDTEACHERID"}             if field_order.push("specialedteacherid")
        structure_hash["fields"]["title1teacher"]               = {"data_type"=>"text",         "file_field"=>"TITLE1TEACHER"}                  if field_order.push("title1teacher")
        structure_hash["fields"]["title1teacherid"]             = {"data_type"=>"text",         "file_field"=>"TITLE1TEACHERID"}                if field_order.push("title1teacherid")
        structure_hash["fields"]["giftedtalented"]              = {"data_type"=>"bool",         "file_field"=>"GIFTEDTALENTED"}                 if field_order.push("giftedtalented")
        structure_hash["fields"]["haseslprogram"]               = {"data_type"=>"bool",         "file_field"=>"HASESLPROGRAM"}                  if field_order.push("haseslprogram")
        structure_hash["fields"]["title1chapter1prog"]          = {"data_type"=>"bool",         "file_field"=>"TITLE1CHAPTER1PROG"}             if field_order.push("title1chapter1prog")
        structure_hash["fields"]["sped504plan"]                 = {"data_type"=>"bool",         "file_field"=>"SPED504PLAN"}                    if field_order.push("sped504plan")
        structure_hash["fields"]["sped504planreason"]           = {"data_type"=>"text",         "file_field"=>"SPED504PLANREASON"}              if field_order.push("sped504planreason")
        structure_hash["fields"]["isspecialed"]                 = {"data_type"=>"bool",         "file_field"=>"ISSPECIALED"}                    if field_order.push("isspecialed")
        structure_hash["fields"]["hasiep"]                      = {"data_type"=>"bool",         "file_field"=>"HASIEP"}                         if field_order.push("hasiep")
        structure_hash["fields"]["hasrti"]                      = {"data_type"=>"bool",         "file_field"=>"HASRTI"}                         if field_order.push("hasrti")
        structure_hash["fields"]["hasalp"]                      = {"data_type"=>"bool",         "file_field"=>"HASALP"}                         if field_order.push("hasalp")  
        structure_hash["fields"]["otherspecialed"]              = {"data_type"=>"bool",         "file_field"=>"OTHERSPECIALED"}                 if field_order.push("otherspecialed")
        structure_hash["fields"]["specialedrecords"]            = {"data_type"=>"text",         "file_field"=>"SPECIALEDRECORDS"}               if field_order.push("specialedrecords")
        structure_hash["fields"]["freeandreducedmeals"]         = {"data_type"=>"text",         "file_field"=>"FREEANDREDUCEDMEALS"}            if field_order.push("freeandreducedmeals")
        structure_hash["fields"]["registrationstatustext"]      = {"data_type"=>"text",         "file_field"=>"REGISTRATIONSTATUSTEXT"}         if field_order.push("registrationstatustext")
        structure_hash["fields"]["registrationyear"]            = {"data_type"=>"year",         "file_field"=>"REGISTRATIONYEAR"}               if field_order.push("registrationyear")
        structure_hash["fields"]["registrationlastchangedate"]  = {"data_type"=>"datetime",     "file_field"=>"REGISTRATIONLASTCHANGEDATE"}     if field_order.push("registrationlastchangedate")
        structure_hash["fields"]["previousschooltype"]          = {"data_type"=>"text",         "file_field"=>"PREVIOUSSCHOOLTYPE"}             if field_order.push("previousschooltype")
        structure_hash["fields"]["admissionreason"]             = {"data_type"=>"text",         "file_field"=>"ADMISSIONREASON"}                if field_order.push("admissionreason")
        structure_hash["fields"]["admissiongrade"]              = {"data_type"=>"text",         "file_field"=>"ADMISSIONGRADE"}                 if field_order.push("admissiongrade")
        structure_hash["fields"]["ssid"]                        = {"data_type"=>"text",         "file_field"=>"SSID"}                           if field_order.push("ssid")
        structure_hash["fields"]["prevschoolname"]              = {"data_type"=>"text",         "file_field"=>"PREVSCHOOLNAME"}                 if field_order.push("prevschoolname")
        structure_hash["fields"]["prevschoolstate"]             = {"data_type"=>"text",         "file_field"=>"PREVSCHOOLSTATE"}                if field_order.push("prevschoolstate")
        structure_hash["fields"]["studentemail"]                = {"data_type"=>"text",         "file_field"=>"STUDENTEMAIL"}                   if field_order.push("studentemail")
        structure_hash["fields"]["econdisadvan"]                = {"data_type"=>"bool",         "file_field"=>"ECONDISADVAN"}                   if field_order.push("econdisadvan")
        structure_hash["fields"]["cityofbirth"]                 = {"data_type"=>"text",         "file_field"=>"CITYOFBIRTH"}                    if field_order.push("cityofbirth")
        structure_hash["fields"]["districtid"]                  = {"data_type"=>"int",          "file_field"=>"DISTRICTID"}                     if field_order.push("districtid")
        structure_hash["fields"]["districtcode"]                = {"data_type"=>"text",         "file_field"=>"DISTRICTCODE"}                   if field_order.push("districtcode")
        structure_hash["fields"]["isfulltime"]                  = {"data_type"=>"bool",         "file_field"=>"ISFULLTIME"}                     if field_order.push("isfulltime")
        structure_hash["fields"]["transferringto"]              = {"data_type"=>"text",         "file_field"=>"TRANSFERRINGTO"}                 if field_order.push("transferringto")
        structure_hash["fields"]["enrollmentstatus"]            = {"data_type"=>"text",         "file_field"=>"ENROLLMENTSTATUS"}               if field_order.push("enrollmentstatus")
        structure_hash["fields"]["registrationstatus"]          = {"data_type"=>"text",         "file_field"=>"REGISTRATIONSTATUS"}             if field_order.push("registrationstatus")
        structure_hash["fields"]["hsenrollsurs"]                = {"data_type"=>"text",         "file_field"=>"HSENROLLSURS"}                   if field_order.push("hsenrollsurs")
        structure_hash["fields"]["hsregsurs"]                   = {"data_type"=>"int",          "file_field"=>"HSREGSURS"}                      if field_order.push("hsregsurs")
        structure_hash["fields"]["k8enrollsurlc"]               = {"data_type"=>"int",          "file_field"=>"K8ENROLLSURLC"}                  if field_order.push("k8enrollsurlc")
        structure_hash["fields"]["hsenrollsurlc"]               = {"data_type"=>"int",          "file_field"=>"HSENROLLSURLC"}                  if field_order.push("hsenrollsurlc")
        structure_hash["fields"]["k8regsurlc"]                  = {"data_type"=>"int",          "file_field"=>"K8REGSURLC"}                     if field_order.push("k8regsurlc")
        structure_hash["fields"]["hsregsurlc"]                  = {"data_type"=>"int",          "file_field"=>"HSREGSURLC"}                     if field_order.push("hsregsurlc")
        structure_hash["fields"]["fundmodeldec"]                = {"data_type"=>"text",         "file_field"=>"FUNDMODELDEC"}                   if field_order.push("fundmodeldec")
        structure_hash["fields"]["fundmodelcode"]               = {"data_type"=>"text",         "file_field"=>"FUNDMODELCODE"}                  if field_order.push("fundmodelcode")
        structure_hash["fields"]["fte"]                         = {"data_type"=>"text",         "file_field"=>"FTE"}                            if field_order.push("fte")
        structure_hash["fields"]["cohort_year"]                 = {"data_type"=>"int",          "file_field"=>"COHORTYEAR"}                     if field_order.push("cohort_year")
        structure_hash["fields"]["do_not_promote"]              = {"data_type"=>"text",         "file_field"=>"DONOTPROMOTE"}                   if field_order.push("do_not_promote")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end