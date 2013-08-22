#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_WITHDRAWAL < Athena_Table
    
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

    def by_studentid_old(sid, effective_date = nil, k12_reason = nil, agora_reason = nil) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=",        sid             ) )
        params.push( Struct::WHERE_PARAMS.new("schoolwithdrawdate", "=",        effective_date  ) ) if effective_date
        params.push( Struct::WHERE_PARAMS.new("withdrawreason",     "REGEXP",   k12_reason      ) ) if k12_reason
        params.push( Struct::WHERE_PARAMS.new("transferring_to",    "=",        agora_reason    ) ) if agora_reason
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def confirmed_withdrawal(sid, effective_date, k12_reason, agora_reason) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=",        sid             ) )
        params.push( Struct::WHERE_PARAMS.new("schoolwithdrawdate", "=",        effective_date  ) )
        params.push( Struct::WHERE_PARAMS.new("withdrawreason",     "REGEXP",   k12_reason      ) )
        params.push( Struct::WHERE_PARAMS.new("transferring_to",    "=",        agora_reason    ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT student_id FROM #{table_name}") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "k12_withdrawal",
                "file_name"         => "agora_withdraw.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_withdraw.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "Withdraw"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]                      = {"data_type"=>"int",          "file_field"=>"STUDENTID"}                      if field_order.push("student_id")
            structure_hash["fields"]["identityid"]                      = {"data_type"=>"int",          "file_field"=>"IDENTITYID"}                     if field_order.push("identityid")
            structure_hash["fields"]["familyid"]                        = {"data_type"=>"int",          "file_field"=>"FAMILYID"}                       if field_order.push("familyid")
            structure_hash["fields"]["integrationid"]                   = {"data_type"=>"text",         "file_field"=>"INTEGRATIONID"}                  if field_order.push("integrationid")
            structure_hash["fields"]["first_name"]                      = {"data_type"=>"text",         "file_field"=>"FIRSTNAME"}                      if field_order.push("first_name")
            structure_hash["fields"]["last_name"]                       = {"data_type"=>"text",         "file_field"=>"LASTNAME"}                       if field_order.push("last_name")
            structure_hash["fields"]["specialed"]                       = {"data_type"=>"text",         "file_field"=>"Special Ed"}                     if field_order.push("specialed")
            structure_hash["fields"]["sped_teach_first_name"]           = {"data_type"=>"text",         "file_field"=>"SpEd Teach First Name"}          if field_order.push("sped_teach_first_name")
            structure_hash["fields"]["sped_teach_last_name"]            = {"data_type"=>"text",         "file_field"=>"SpEd Teach Last Name"}           if field_order.push("sped_teach_last_name")
            structure_hash["fields"]["has_an_iep"]                      = {"data_type"=>"text",         "file_field"=>"Has An IEP"}                     if field_order.push("has_an_iep")
            structure_hash["fields"]["grade_level"]                     = {"data_type"=>"text",         "file_field"=>"GRADE_LEVEL"}                    if field_order.push("grade_level")
            structure_hash["fields"]["birthday"]                        = {"data_type"=>"date",         "file_field"=>"BIRTHDAY"}                       if field_order.push("birthday")
            structure_hash["fields"]["teacher_first_name"]              = {"data_type"=>"text",         "file_field"=>"Teacher First Name"}             if field_order.push("teacher_first_name")
            structure_hash["fields"]["teacher_last_name"]               = {"data_type"=>"text",         "file_field"=>"Teacher Last Name"}              if field_order.push("teacher_last_name")
            structure_hash["fields"]["title1_teacher_first_name"]       = {"data_type"=>"text",         "file_field"=>"Title 1 Teacher First Name"}     if field_order.push("title1_teacher_first_name")
            structure_hash["fields"]["title1_teacher_last_name"]        = {"data_type"=>"text",         "file_field"=>"Title 1 Teacher Last Name"}      if field_order.push("title1_teacher_last_name")
            structure_hash["fields"]["giftedtalented"]                  = {"data_type"=>"bool",         "file_field"=>"GIFTEDTALENTED"}                 if field_order.push("giftedtalented")
            structure_hash["fields"]["haseslprogram"]                   = {"data_type"=>"bool",         "file_field"=>"HASESLPROGRAM"}                  if field_order.push("haseslprogram")
            structure_hash["fields"]["title1chapter1prog"]              = {"data_type"=>"bool",         "file_field"=>"TITLE1CHAPTER1PROG"}             if field_order.push("title1chapter1prog")
            structure_hash["fields"]["sped504plan"]                     = {"data_type"=>"bool",         "file_field"=>"SPED504PLAN"}                    if field_order.push("sped504plan")
            structure_hash["fields"]["sped504planreason"]               = {"data_type"=>"text",         "file_field"=>"SPED504PLANREASON"}              if field_order.push("sped504planreason")
            structure_hash["fields"]["isspecialed"]                     = {"data_type"=>"bool",         "file_field"=>"ISSPECIALED"}                    if field_order.push("isspecialed")
            structure_hash["fields"]["hasiep"]                          = {"data_type"=>"bool",         "file_field"=>"HASIEP"}                         if field_order.push("hasiep")
            structure_hash["fields"]["hasrti"]                          = {"data_type"=>"bool",         "file_field"=>"HASRTI"}                         if field_order.push("hasrti")
            structure_hash["fields"]["hasalp"]                          = {"data_type"=>"bool",         "file_field"=>"HASALP"}                         if field_order.push("hasalp")
            structure_hash["fields"]["otherspecialed"]                  = {"data_type"=>"bool",         "file_field"=>"OTHERSPECIALED"}                 if field_order.push("otherspecialed")
            structure_hash["fields"]["specialedrecords"]                = {"data_type"=>"text",         "file_field"=>"SPECIALEDRECORDS"}               if field_order.push("specialedrecords")
            structure_hash["fields"]["freeandreducedmeals"]             = {"data_type"=>"text",         "file_field"=>"FREEANDREDUCEDMEALS"}            if field_order.push("freeandreducedmeals")
            structure_hash["fields"]["withdrawreason"]                  = {"data_type"=>"text",         "file_field"=>"WITHDRAWREASON"}                 if field_order.push("withdrawreason")
            structure_hash["fields"]["hispanicorlatino"]                = {"data_type"=>"text",         "file_field"=>"HISPANICORLATINO"}               if field_order.push("hispanicorlatino")
            structure_hash["fields"]["othethnicities"]                  = {"data_type"=>"text",         "file_field"=>"OTHETHNICITIES"}                 if field_order.push("othethnicities")
            structure_hash["fields"]["enrollreceiveddate"]              = {"data_type"=>"date",         "file_field"=>"ENROLLRECEIVEDDATE"}             if field_order.push("enrollreceiveddate")
            structure_hash["fields"]["enrollapproveddate"]              = {"data_type"=>"date",         "file_field"=>"ENROLLAPPROVEDDATE"}             if field_order.push("enrollapproveddate")
            structure_hash["fields"]["schoolenrolldate"]                = {"data_type"=>"date",         "file_field"=>"SCHOOLENROLLDATE"}               if field_order.push("schoolenrolldate")
            structure_hash["fields"]["withdrawdate"]                    = {"data_type"=>"date",         "file_field"=>"WITHDRAWDATE"}                   if field_order.push("withdrawdate")
            structure_hash["fields"]["schoolwithdrawdate"]              = {"data_type"=>"date",         "file_field"=>"SCHOOLWITHDRAWDATE"}             if field_order.push("schoolwithdrawdate")
            structure_hash["fields"]["school_name"]                     = {"data_type"=>"text",         "file_field"=>"SCHOOL_NAME"}                    if field_order.push("school_name")
            structure_hash["fields"]["districtofresidence"]             = {"data_type"=>"text",         "file_field"=>"DISTRICTOFRESIDENCE"}            if field_order.push("districtofresidence")
            structure_hash["fields"]["lc_first_name"]                   = {"data_type"=>"text",         "file_field"=>"LC First Name"}                  if field_order.push("lc_first_name")
            structure_hash["fields"]["lc_last_name"]                    = {"data_type"=>"text",         "file_field"=>"LC Last Name"}                   if field_order.push("lc_last_name")
            structure_hash["fields"]["lc_email"]                        = {"data_type"=>"text",         "file_field"=>"LC email"}                       if field_order.push("lc_email")
            structure_hash["fields"]["address1"]                        = {"data_type"=>"text",         "file_field"=>"ADDRESS1"}                       if field_order.push("address1")
            structure_hash["fields"]["address2"]                        = {"data_type"=>"text",         "file_field"=>"ADDRESS2"}                       if field_order.push("address2")
            structure_hash["fields"]["city"]                            = {"data_type"=>"text",         "file_field"=>"CITY"}                           if field_order.push("city")
            structure_hash["fields"]["state"]                           = {"data_type"=>"text",         "file_field"=>"STATE"}                          if field_order.push("state")
            structure_hash["fields"]["zip"]                             = {"data_type"=>"text",         "file_field"=>"ZIP"}                            if field_order.push("zip")
            structure_hash["fields"]["homephone"]                       = {"data_type"=>"text",         "file_field"=>"HOMEPHONE"}                      if field_order.push("homephone")
            structure_hash["fields"]["physicaladdress1"]                = {"data_type"=>"text",         "file_field"=>"physicalADDRESS1"}               if field_order.push("physicaladdress1")
            structure_hash["fields"]["physicaladdress2"]                = {"data_type"=>"text",         "file_field"=>"physicalADDRESS2"}               if field_order.push("physicaladdress2")
            structure_hash["fields"]["physicalregion"]                  = {"data_type"=>"text",         "file_field"=>"physicalREGION"}                 if field_order.push("physicalregion")
            structure_hash["fields"]["physicalcity"]                    = {"data_type"=>"text",         "file_field"=>"physicalCITY"}                   if field_order.push("physicalcity")
            structure_hash["fields"]["pcounty"]                         = {"data_type"=>"text",         "file_field"=>"PCOUNTY"}                        if field_order.push("pcounty")
            structure_hash["fields"]["physicalzip"]                     = {"data_type"=>"text",         "file_field"=>"physicalZIP"}                    if field_order.push("physicalzip")
            structure_hash["fields"]["physicalstate"]                   = {"data_type"=>"text",         "file_field"=>"physicalSTATE"}                  if field_order.push("physicalstate")
            structure_hash["fields"]["do_not_call"]                     = {"data_type"=>"bool",         "file_field"=>"Do Not Call"}                    if field_order.push("do_not_call")
            structure_hash["fields"]["transferring_to"]                 = {"data_type"=>"text",         "file_field"=>"Transferring To"}                if field_order.push("transferring_to")
            structure_hash["fields"]["initial_enrollment_year"]         = {"data_type"=>"text",         "file_field"=>"Initial Enrollment Year"}        if field_order.push("initial_enrollment_year")
            structure_hash["fields"]["student_state_id"]                = {"data_type"=>"bigint",       "file_field"=>"Student State ID"}               if field_order.push("student_state_id")
            structure_hash["fields"]["district_id"]                     = {"data_type"=>"int",          "file_field"=>"District ID"}                    if field_order.push("district_id")
            structure_hash["fields"]["district_code"]                   = {"data_type"=>"bigint",       "file_field"=>"District Code"}                  if field_order.push("district_code")
            structure_hash["fields"]["fundmodeldesc"]                   = {"data_type"=>"text",         "file_field"=>"FUNDMODELDESC"}                  if field_order.push("fundmodeldesc")
            structure_hash["fields"]["fundmodelcode"]                   = {"data_type"=>"text",         "file_field"=>"FUNDMODELCODE"}                  if field_order.push("fundmodelcode")
            structure_hash["fields"]["fte"]                             = {"data_type"=>"text",         "file_field"=>"FTE"}                            if field_order.push("fte")
            structure_hash["fields"]["cohort_year"]                     = {"data_type"=>"int",          "file_field"=>"COHORTYEAR"}                     if field_order.push("cohort_year")
            structure_hash["fields"]["do_not_promote"]                  = {"data_type"=>"text",         "file_field"=>"DONOTPROMOTE"}                   if field_order.push("do_not_promote")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end