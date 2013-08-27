#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_PAL_ASSESSMENT < Athena_Table
    
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

    def by_studentid_old(student_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", student_id) )
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
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_pal_assessment",
                "file_name"         => "agora_pal_assessment_report.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_pal_assessment_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Pal Assessment"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["familyid"]                        = {"data_type"=>"int",          "file_field"=>"FAMILYID"}                                                                               if field_order.push("familyid")
            structure_hash["fields"]["student_id"]                      = {"data_type"=>"int",          "file_field"=>"STUDENTID"}                                                                              if field_order.push("student_id")
            structure_hash["fields"]["identityid"]                      = {"data_type"=>"int",          "file_field"=>"IDENTITYID"}                                                                             if field_order.push("identityid")
            structure_hash["fields"]["integrationid"]                   = {"data_type"=>"text",         "file_field"=>"INTEGRATIONID"}                                                                          if field_order.push("integrationid")
            structure_hash["fields"]["name"]                            = {"data_type"=>"text",         "file_field"=>"NAME"}                                                                                   if field_order.push("name")
            structure_hash["fields"]["abbreviation"]                    = {"data_type"=>"text",         "file_field"=>"ABBREVIATION"}                                                                           if field_order.push("abbreviation")
            structure_hash["fields"]["schoolid"]                        = {"data_type"=>"int",          "file_field"=>"SCHOOLID"}                                                                               if field_order.push("schoolid")
            structure_hash["fields"]["lastname"]                        = {"data_type"=>"text",         "file_field"=>"LASTNAME"}                                                                               if field_order.push("lastname")
            structure_hash["fields"]["firstname"]                       = {"data_type"=>"text",         "file_field"=>"FIRSTNAME"}                                                                              if field_order.push("firstname")
            structure_hash["fields"]["middlename"]                      = {"data_type"=>"text",         "file_field"=>"MIDDLENAME"}                                                                             if field_order.push("middlename")
            structure_hash["fields"]["gradelevel"]                      = {"data_type"=>"text",         "file_field"=>"GRADELEVEL"}                                                                             if field_order.push("gradelevel")
            structure_hash["fields"]["enrollreceiveddate"]              = {"data_type"=>"date",         "file_field"=>"ENROLLRECEIVEDDATE"}                                                                     if field_order.push("enrollreceiveddate")
            structure_hash["fields"]["enrollapproveddate"]              = {"data_type"=>"date",         "file_field"=>"ENROLLAPPROVEDDATE"}                                                                     if field_order.push("enrollapproveddate")
            structure_hash["fields"]["schoolenrolldate"]                = {"data_type"=>"date",         "file_field"=>"SCHOOLENROLLDATE"}                                                                       if field_order.push("schoolenrolldate")
            structure_hash["fields"]["withdrawdate"]                    = {"data_type"=>"date",         "file_field"=>"WITHDRAWDATE"}                                                                           if field_order.push("withdrawdate")
            structure_hash["fields"]["withdrawreason"]                  = {"data_type"=>"text",         "file_field"=>"WITHDRAWREASON"}                                                                         if field_order.push("withdrawreason")
            structure_hash["fields"]["placementconfcompleteddate"]      = {"data_type"=>"date",         "file_field"=>"PLACEMENTCONFCOMPLETEDDATE"}                                                             if field_order.push("placementconfcompleteddate")
            structure_hash["fields"]["palassigeneddate"]                = {"data_type"=>"date",         "file_field"=>"PALASSIGENEDDATE"}                                                                       if field_order.push("palassigeneddate")
            structure_hash["fields"]["palassigned"]                     = {"data_type"=>"text",         "file_field"=>"PALASSIGNED"}                                                                            if field_order.push("palassigned")
            structure_hash["fields"]["teamassigneddate"]                = {"data_type"=>"date",         "file_field"=>"TEAMASSIGNEDDATE"}                                                                       if field_order.push("teamassigneddate")
            structure_hash["fields"]["teamassigned"]                    = {"data_type"=>"text",         "file_field"=>"TEAMASSIGNED"}                                                                           if field_order.push("teamassigned")
            structure_hash["fields"]["gender"]                          = {"data_type"=>"text",         "file_field"=>"GENDER"}                                                                                 if field_order.push("gender")
            structure_hash["fields"]["initenrollyear"]                  = {"data_type"=>"year",         "file_field"=>"INITENROLLYEAR"}                                                                         if field_order.push("initenrollyear")
            structure_hash["fields"]["regstatus"]                       = {"data_type"=>"text",         "file_field"=>"REGSTATUS"}                                                                              if field_order.push("regstatus")
            structure_hash["fields"]["online_enrollment"]               = {"data_type"=>"text",         "file_field"=>"Online Enrollment"}                                                                      if field_order.push("online_enrollment")
            structure_hash["fields"]["decode_xss_fulltime"]             = {"data_type"=>"bool",         "file_field"=>"DECODE(XSS.FULLTIME,1,YES,0,NO)"}                                                        if field_order.push("decode_xss_fulltime")
            structure_hash["fields"]["documentsreceived"]               = {"data_type"=>"bool",         "file_field"=>"DOCUMENTSRECEIVED"}                                                                      if field_order.push("documentsreceived")
            structure_hash["fields"]["decode_ei_eligibilitystatus"]     = {"data_type"=>"text",         "file_field"=>"DECODE(EI.ELIGIBILITYSTATUS,0,ELIGIBLE,1,ELIGIBLEBUTWAITLISTED,2,NOTELIGIBLE)"}          if field_order.push("decode_ei_eligibilitystatus")
            structure_hash["fields"]["eligibilityreason"]               = {"data_type"=>"text",         "file_field"=>"ELIGIBILITYREASON"}                                                                      if field_order.push("eligibilityreason")
            structure_hash["fields"]["assignedpalriskassessment"]       = {"data_type"=>"int",          "file_field"=>"ASSIGNEDPALRISKASSESSMENT"}                                                              if field_order.push("assignedpalriskassessment")
            structure_hash["fields"]["palriskassmttext"]                = {"data_type"=>"text",         "file_field"=>"PALRISKASSMTTEXT"}                                                                       if field_order.push("palriskassmttext")
            structure_hash["fields"]["assignedteacherriskassessment"]   = {"data_type"=>"int",          "file_field"=>"ASSIGNEDTEACHERRISKASSESSMENT"}                                                          if field_order.push("assignedteacherriskassessment")
            structure_hash["fields"]["teacherriskassmttext"]            = {"data_type"=>"text",         "file_field"=>"TEACHERRISKASSMTTEXT"}                                                                   if field_order.push("teacherriskassmttext")
            structure_hash["fields"]["read_std"]                        = {"data_type"=>"bool",         "file_field"=>"Read Std"}                                                                               if field_order.push("read_std")
            structure_hash["fields"]["math_std"]                        = {"data_type"=>"bool",         "file_field"=>"Math Std"}                                                                               if field_order.push("math_std")
            structure_hash["fields"]["engagm_level"]                    = {"data_type"=>"text",         "file_field"=>"Engagm Level"}                                                                           if field_order.push("engagm_level")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end