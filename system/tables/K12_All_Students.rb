#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_ALL_STUDENTS < Athena_Table
    
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

    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxSTUDENTID_ARRAYS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def students_by_primary_teacher(primaryteacher, school_year = nil)
        join_sql = String.new
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primaryteacher",                         "=",        primaryteacher  ) )
        if school_year
            join_table = "attendance_#{school_year.gsub("-","_")}"
            params.push( Struct::WHERE_PARAMS.new("#{join_table}.primary_id",   "IS NOT",   "NULL"  ) )
            join_sql = "LEFT JOIN #{join_table} ON student_id = #{join_table}.primary_id"
        end
        
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{table_name} #{join_sql} #{where_clause}") 
    end
    
    def students_by_primary_teacher_new(primaryteacher, school_year = nil)
        join_sql = String.new
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primaryteacher",     "=",        primaryteacher  ) )
        params.push( Struct::WHERE_PARAMS.new("schoolenrolldate",   ">",        $school.current_school_year_start.value     ) )
        if school_year
            join_table = "attendance_#{school_year.gsub("-","_")}"
            params.push( Struct::WHERE_PARAMS.new("#{join_table}.primary_id",   "IS NOT",   "NULL"  ) )
            join_sql = "LEFT JOIN #{join_table} ON student_id = #{join_table}.primary_id"
        end
        
        where_clause = $db.where_clause(params)
        $db.get_data_single("SELECT student_id FROM #{table_name} #{join_sql} #{where_clause}") 
    end
    
    def student_with_records
        $db.get_data_single("SELECT student_id from #{table_name}")
    end
 
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxTRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_all_students",
                "file_name"         => "agora_all_students.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_All_Students.csv", 
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "All Students" 
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_id"]                  = {"data_type"=>"int",     "file_field"=>"STUDENTID"}                   if field_order.push("student_id")
        structure_hash["fields"]["integrationid"]               = {"data_type"=>"text",    "file_field"=>"INTEGRATIONID"}               if field_order.push("integrationid")
        structure_hash["fields"]["identityid"]                  = {"data_type"=>"int",     "file_field"=>"IDENTITYID"}                  if field_order.push("identityid")
        structure_hash["fields"]["familyid"]                    = {"data_type"=>"int",     "file_field"=>"FAMILYID"}                    if field_order.push("familyid")
        structure_hash["fields"]["studentlastname"]             = {"data_type"=>"text",    "file_field"=>"STUDENTLASTNAME"}             if field_order.push("studentlastname")
        structure_hash["fields"]["studentfirstname"]            = {"data_type"=>"text",    "file_field"=>"STUDENTFIRSTNAME"}            if field_order.push("studentfirstname")
        structure_hash["fields"]["studentmiddlename"]           = {"data_type"=>"text",    "file_field"=>"STUDENTMIDDLENAME"}           if field_order.push("studentmiddlename")
        structure_hash["fields"]["studentgender"]               = {"data_type"=>"text",    "file_field"=>"STUDENTGENDER"}               if field_order.push("studentgender")
        structure_hash["fields"]["grade"]                       = {"data_type"=>"text",    "file_field"=>"GRADE"}                       if field_order.push("grade")
        structure_hash["fields"]["birthday"]                    = {"data_type"=>"date",    "file_field"=>"BIRTHDAY"}                    if field_order.push("birthday")
        structure_hash["fields"]["mailingaddress1"]             = {"data_type"=>"text",    "file_field"=>"MAILINGADDRESS1"}             if field_order.push("mailingaddress1")
        structure_hash["fields"]["mailingaddress2"]             = {"data_type"=>"text",    "file_field"=>"MAILINGADDRESS2"}             if field_order.push("mailingaddress2")
        structure_hash["fields"]["mailingcity"]                 = {"data_type"=>"text",    "file_field"=>"MAILINGCITY"}                 if field_order.push("mailingcity")
        structure_hash["fields"]["mailingzip"]                  = {"data_type"=>"text",    "file_field"=>"MAILINGZIP"}                  if field_order.push("mailingzip")
        structure_hash["fields"]["mailingstate"]                = {"data_type"=>"text",    "file_field"=>"MAILINGSTATE"}                if field_order.push("mailingstate")
        structure_hash["fields"]["studenthomephone"]            = {"data_type"=>"text",    "file_field"=>"STUDENTHOMEPHONE"}            if field_order.push("studenthomephone")
        structure_hash["fields"]["shippingaddress1"]            = {"data_type"=>"text",    "file_field"=>"SHIPPINGADDRESS1"}            if field_order.push("shippingaddress1")
        structure_hash["fields"]["shippingaddress2"]            = {"data_type"=>"text",    "file_field"=>"SHIPPINGADDRESS2"}            if field_order.push("shippingaddress2")
        structure_hash["fields"]["shippingcity"]                = {"data_type"=>"text",    "file_field"=>"SHIPPINGCITY"}                if field_order.push("shippingcity")
        structure_hash["fields"]["county"]                      = {"data_type"=>"text",    "file_field"=>"COUNTY"}                      if field_order.push("county")
        structure_hash["fields"]["shippingzip"]                 = {"data_type"=>"text",    "file_field"=>"SHIPPINGZIP"}                 if field_order.push("shippingzip")
        structure_hash["fields"]["shippingstate"]               = {"data_type"=>"text",    "file_field"=>"SHIPPINGSTATE"}               if field_order.push("shippingstate")  
        structure_hash["fields"]["physicaladdress1"]            = {"data_type"=>"text",    "file_field"=>"physicalADDRESS1"}            if field_order.push("physicaladdress1")
        structure_hash["fields"]["physicaladdress2"]            = {"data_type"=>"text",    "file_field"=>"physicalADDRESS2"}            if field_order.push("physicaladdress2")
        structure_hash["fields"]["physicalregion"]              = {"data_type"=>"text",    "file_field"=>"physicalREGION"}              if field_order.push("physicalregion")
        structure_hash["fields"]["physicalcity"]                = {"data_type"=>"text",    "file_field"=>"physicalCITY"}                if field_order.push("physicalcity")
        structure_hash["fields"]["pcounty"]                     = {"data_type"=>"text",    "file_field"=>"PCOUNTY"}                     if field_order.push("pcounty")
        structure_hash["fields"]["physicalzip"]                 = {"data_type"=>"text",    "file_field"=>"physicalZIP"}                 if field_order.push("physicalzip")
        structure_hash["fields"]["physicalstate"]               = {"data_type"=>"text",    "file_field"=>"physicalSTATE"}               if field_order.push("physicalstate")
        structure_hash["fields"]["enrollreceiveddate"]          = {"data_type"=>"date",    "file_field"=>"ENROLLRECEIVEDDATE"}          if field_order.push("enrollreceiveddate")
        structure_hash["fields"]["enrollapproveddate"]          = {"data_type"=>"date",    "file_field"=>"ENROLLAPPROVEDDATE"}          if field_order.push("enrollapproveddate")
        structure_hash["fields"]["schoolenrolldate"]            = {"data_type"=>"date",    "file_field"=>"SCHOOLENROLLDATE"}            if field_order.push("schoolenrolldate")
        structure_hash["fields"]["withdrawdate"]                = {"data_type"=>"date",    "file_field"=>"WITHDRAWDATE"}                if field_order.push("withdrawdate")
        structure_hash["fields"]["schoolwithdrawdate"]          = {"data_type"=>"date",    "file_field"=>"SCHOOLWITHDRAWDATE"}          if field_order.push("schoolwithdrawdate")
        structure_hash["fields"]["withdrawreason"]              = {"data_type"=>"text",    "file_field"=>"WITHDRAWREASON"}              if field_order.push("withdrawreason")
        structure_hash["fields"]["school"]                      = {"data_type"=>"text",    "file_field"=>"SCHOOL"}                      if field_order.push("school")
        structure_hash["fields"]["districtofresidence"]         = {"data_type"=>"text",    "file_field"=>"DISTRICTOFRESIDENCE"}         if field_order.push("districtofresidence")
        structure_hash["fields"]["initenrollyear"]              = {"data_type"=>"year(4)", "file_field"=>"INITENROLLYEAR"}              if field_order.push("initenrollyear")
        structure_hash["fields"]["lclastname"]                  = {"data_type"=>"text",    "file_field"=>"LCLASTNAME"}                  if field_order.push("lclastname")
        structure_hash["fields"]["lcfirstname"]                 = {"data_type"=>"text",    "file_field"=>"LCFIRSTNAME"}                 if field_order.push("lcfirstname")
        structure_hash["fields"]["lcrelationship"]              = {"data_type"=>"text",    "file_field"=>"LCRELATIONSHIP"}              if field_order.push("lcrelationship")
        structure_hash["fields"]["lcregistrationid"]            = {"data_type"=>"text",    "file_field"=>"LCREGISTRATIONID"}            if field_order.push("lcregistrationid")
        structure_hash["fields"]["lcemail"]                     = {"data_type"=>"text",    "file_field"=>"LCEMAIL"}                     if field_order.push("lcemail")
        structure_hash["fields"]["lglastname"]                  = {"data_type"=>"text",    "file_field"=>"LGLASTNAME"}                  if field_order.push("lglastname")
        structure_hash["fields"]["lgfirstname"]                 = {"data_type"=>"text",    "file_field"=>"LGFIRSTNAME"}                 if field_order.push("lgfirstname")
        structure_hash["fields"]["lgrelationship"]              = {"data_type"=>"text",    "file_field"=>"LGRELATIONSHIP"}              if field_order.push("lgrelationship")
        structure_hash["fields"]["lgregistrationid"]            = {"data_type"=>"text",    "file_field"=>"LGREGISTRATIONID"}            if field_order.push("lgregistrationid")
        structure_hash["fields"]["lgemail"]                     = {"data_type"=>"text",    "file_field"=>"LGEMAIL"}                     if field_order.push("lgemail")
        structure_hash["fields"]["ethnicity"]                   = {"data_type"=>"text",    "file_field"=>"ETHNICITY"}                   if field_order.push("ethnicity")
        structure_hash["fields"]["hispanicorlatino"]            = {"data_type"=>"text",    "file_field"=>"HISPANICORLATINO"}            if field_order.push("hispanicorlatino")
        structure_hash["fields"]["othethnicities"]              = {"data_type"=>"text",    "file_field"=>"OTHETHNICITIES"}              if field_order.push("othethnicities")
        structure_hash["fields"]["primaryteacher"]              = {"data_type"=>"text",    "file_field"=>"PRIMARYTEACHER"}              if field_order.push("primaryteacher")
        structure_hash["fields"]["primaryteacherid"]            = {"data_type"=>"int",     "file_field"=>"PRIMARYTEACHERID"}            if field_order.push("primaryteacherid")
        structure_hash["fields"]["specialedteacher"]            = {"data_type"=>"text",    "file_field"=>"SPECIALEDTEACHER"}            if field_order.push("specialedteacher")
        structure_hash["fields"]["specialedteacherid"]          = {"data_type"=>"int",     "file_field"=>"SPECIALEDTEACHERID"}          if field_order.push("specialedteacherid")
        structure_hash["fields"]["title1teacher"]               = {"data_type"=>"text",    "file_field"=>"TITLE1TEACHER"}               if field_order.push("title1teacher")
        structure_hash["fields"]["title1teacherid"]             = {"data_type"=>"text",    "file_field"=>"TITLE1TEACHERID"}             if field_order.push("title1teacherid")
        structure_hash["fields"]["giftedtalented"]              = {"data_type"=>"bool",    "file_field"=>"GIFTEDTALENTED"}              if field_order.push("giftedtalented")
        structure_hash["fields"]["haseslprogram"]               = {"data_type"=>"bool",    "file_field"=>"HASESLPROGRAM"}               if field_order.push("haseslprogram")
        structure_hash["fields"]["title1chapter1prog"]          = {"data_type"=>"bool",    "file_field"=>"TITLE1CHAPTER1PROG"}          if field_order.push("title1chapter1prog")
        structure_hash["fields"]["sped504plan"]                 = {"data_type"=>"bool",    "file_field"=>"SPED504PLAN"}                 if field_order.push("sped504plan")
        structure_hash["fields"]["sped504planreason"]           = {"data_type"=>"text",    "file_field"=>"SPED504PLANREASON"}           if field_order.push("sped504planreason")
        structure_hash["fields"]["isspecialed"]                 = {"data_type"=>"bool",    "file_field"=>"ISSPECIALED"}                 if field_order.push("isspecialed")
        structure_hash["fields"]["hasiep"]                      = {"data_type"=>"bool",    "file_field"=>"HASIEP"}                      if field_order.push("hasiep")
        structure_hash["fields"]["otherspecialed"]              = {"data_type"=>"bool",    "file_field"=>"OTHERSPECIALED"}              if field_order.push("otherspecialed")
        structure_hash["fields"]["specialedrecords"]            = {"data_type"=>"text",    "file_field"=>"SPECIALEDRECORDS"}            if field_order.push("specialedrecords")
        structure_hash["fields"]["freeandreducedmeals"]         = {"data_type"=>"text",    "file_field"=>"FREEANDREDUCEDMEALS"}         if field_order.push("freeandreducedmeals")
        structure_hash["fields"]["registrationstatustext"]      = {"data_type"=>"text",    "file_field"=>"REGISTRATIONSTATUSTEXT"}      if field_order.push("registrationstatustext")
        structure_hash["fields"]["registrationyear"]            = {"data_type"=>"text",    "file_field"=>"REGISTRATIONYEAR"}            if field_order.push("registrationyear")
        structure_hash["fields"]["registrationlastchangedate"]  = {"data_type"=>"text",    "file_field"=>"REGISTRATIONLASTCHANGEDATE"}  if field_order.push("registrationlastchangedate")
        structure_hash["fields"]["previousschooltype"]          = {"data_type"=>"text",    "file_field"=>"PREVIOUSSCHOOLTYPE"}          if field_order.push("previousschooltype")
        structure_hash["fields"]["admissionreason"]             = {"data_type"=>"text",    "file_field"=>"ADMISSIONREASON"}             if field_order.push("admissionreason")
        structure_hash["fields"]["admissiongrade"]              = {"data_type"=>"text",    "file_field"=>"ADMISSIONGRADE"}              if field_order.push("admissiongrade")
        structure_hash["fields"]["ssid"]                        = {"data_type"=>"text",    "file_field"=>"SSID"}                        if field_order.push("ssid")
        structure_hash["fields"]["prevschoolname"]              = {"data_type"=>"text",    "file_field"=>"PREVSCHOOLNAME"}              if field_order.push("prevschoolname")
        structure_hash["fields"]["prevschoolstate"]             = {"data_type"=>"text",    "file_field"=>"PREVSCHOOLSTATE"}             if field_order.push("prevschoolstate")
        structure_hash["fields"]["studentemail"]                = {"data_type"=>"text",    "file_field"=>"STUDENTEMAIL"}                if field_order.push("studentemail")
        structure_hash["fields"]["econdisadvan"]                = {"data_type"=>"text",    "file_field"=>"ECONDISADVAN"}                if field_order.push("econdisadvan")
        structure_hash["fields"]["cityofbirth"]                 = {"data_type"=>"text",    "file_field"=>"CITYOFBIRTH"}                 if field_order.push("cityofbirth")
        structure_hash["fields"]["districtid"]                  = {"data_type"=>"text",    "file_field"=>"DISTRICTID"}                  if field_order.push("districtid")
        structure_hash["fields"]["districtcode"]                = {"data_type"=>"text",    "file_field"=>"DISTRICTCODE"}                if field_order.push("districtcode")
        structure_hash["fields"]["isfulltime"]                  = {"data_type"=>"text",    "file_field"=>"ISFULLTIME"}                  if field_order.push("isfulltime")
        structure_hash["fields"]["transferringto"]              = {"data_type"=>"text",    "file_field"=>"TRANSFERRINGTO"}              if field_order.push("transferringto")
        structure_hash["fields"]["registrationstatus"]          = {"data_type"=>"text",    "file_field"=>"REGISTRATIONSTATUS"}          if field_order.push("registrationstatus")
        structure_hash["fields"]["hsenrollsurs"]                = {"data_type"=>"text",    "file_field"=>"HSENROLLSURS"}                if field_order.push("hsenrollsurs")
        structure_hash["fields"]["hsregsurs"]                   = {"data_type"=>"int",     "file_field"=>"HSREGSURS"}                   if field_order.push("hsregsurs")
        structure_hash["fields"]["k8enrollsurlc"]               = {"data_type"=>"int",     "file_field"=>"K8ENROLLSURLC"}               if field_order.push("k8enrollsurlc")
        structure_hash["fields"]["hsenrollsurlc"]               = {"data_type"=>"int",     "file_field"=>"HSENROLLSURLC"}               if field_order.push("hsenrollsurlc")
        structure_hash["fields"]["k8regsurlc"]                  = {"data_type"=>"int",     "file_field"=>"K8REGSURLC"}                  if field_order.push("k8regsurlc")
        structure_hash["fields"]["hsregsurlc"]                  = {"data_type"=>"int",     "file_field"=>"HSREGSURLC"}                  if field_order.push("hsregsurlc")
        structure_hash["fields"]["fundmodeldesc"]               = {"data_type"=>"text",    "file_field"=>"FUNDMODELDESC"}               if field_order.push("fundmodeldesc")
        structure_hash["fields"]["fundmodelcode"]               = {"data_type"=>"text",    "file_field"=>"FUNDMODELCODE"}               if field_order.push("fundmodelcode")
        structure_hash["fields"]["fte"]                         = {"data_type"=>"text",    "file_field"=>"FTE"}                         if field_order.push("fte")
        structure_hash["fields"]["cohort_year"]                 = {"data_type"=>"int",     "file_field"=>"COHORTYEAR"}                  if field_order.push("cohort_year")
        structure_hash["fields"]["do_not_promote"]              = {"data_type"=>"text",    "file_field"=>"DONOTPROMOTE"}                if field_order.push("do_not_promote")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end