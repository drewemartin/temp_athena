#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_CLASS_LIST < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("sams_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    alias :by_sams_id :by_studentid_old
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
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
                "name"              => "k12_class_list",
                "file_name"         => "agora_classlistteacherview_vhs.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_classlistteacherview_vhs.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Class List Teacher View VHS"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["sams_id"]             = {"data_type"=>"int",  "file_field"=>"SAMS_ID"}            if field_order.push("sams_id")
        structure_hash["fields"]["studentfirstname"]    = {"data_type"=>"text", "file_field"=>"STUDENTFIRSTNAME"}   if field_order.push("studentfirstname")
        structure_hash["fields"]["studentlastname"]     = {"data_type"=>"text", "file_field"=>"STUDENTLASTNAME"}    if field_order.push("studentlastname")
        structure_hash["fields"]["studentemail"]        = {"data_type"=>"text", "file_field"=>"STUDENTEMAIL"}       if field_order.push("studentemail")
        structure_hash["fields"]["mailingaddress1"]     = {"data_type"=>"text", "file_field"=>"MAILINGADDRESS1"}    if field_order.push("mailingaddress1")
        structure_hash["fields"]["mailingaddress2"]     = {"data_type"=>"text", "file_field"=>"MAILINGADDRESS2"}    if field_order.push("mailingaddress2")
        structure_hash["fields"]["mailingregion"]       = {"data_type"=>"text", "file_field"=>"MAILINGREGION"}      if field_order.push("mailingregion")
        structure_hash["fields"]["mailingcounty"]       = {"data_type"=>"text", "file_field"=>"MAILINGCOUNTY"}      if field_order.push("mailingcounty")
        structure_hash["fields"]["mailingcity"]         = {"data_type"=>"text", "file_field"=>"MAILINGCITY"}        if field_order.push("mailingcity")
        structure_hash["fields"]["mailingzip"]          = {"data_type"=>"text", "file_field"=>"MAILINGZIP"}         if field_order.push("mailingzip")
        structure_hash["fields"]["mailingstate"]        = {"data_type"=>"text", "file_field"=>"MAILINGSTATE"}       if field_order.push("mailingstate")
        structure_hash["fields"]["mailingcountry"]      = {"data_type"=>"text", "file_field"=>"MAILINGCOUNTRY"}     if field_order.push("mailingcountry")
        structure_hash["fields"]["gradelevel"]          = {"data_type"=>"text", "file_field"=>"GRADELEVEL"}         if field_order.push("gradelevel")
        structure_hash["fields"]["coursegradelevel"]    = {"data_type"=>"text", "file_field"=>"COURSEGRADELEVEL"}   if field_order.push("coursegradelevel")
        structure_hash["fields"]["coursecode"]          = {"data_type"=>"text", "file_field"=>"COURSECODE"}         if field_order.push("coursecode")
        structure_hash["fields"]["coursename"]          = {"data_type"=>"text", "file_field"=>"COURSENAME"}         if field_order.push("coursename")
        structure_hash["fields"]["courseid"]            = {"data_type"=>"int",  "file_field"=>"COURSEID"}           if field_order.push("courseid")
        structure_hash["fields"]["startdate"]           = {"data_type"=>"date", "file_field"=>"STARTDATE"}          if field_order.push("startdate")
        structure_hash["fields"]["enddate"]             = {"data_type"=>"date", "file_field"=>"ENDDATE"}            if field_order.push("enddate")
        structure_hash["fields"]["schoolname"]          = {"data_type"=>"text", "file_field"=>"SCHOOLNAME"}         if field_order.push("schoolname")
        structure_hash["fields"]["specialed"]           = {"data_type"=>"text", "file_field"=>"SPECIALED"}          if field_order.push("specialed")
        structure_hash["fields"]["ilp"]                 = {"data_type"=>"text", "file_field"=>"ILP"}                if field_order.push("ilp")
        structure_hash["fields"]["withdrawaldate"]      = {"data_type"=>"date", "file_field"=>"WITHDRAWALDATE"}     if field_order.push("withdrawaldate")
        structure_hash["fields"]["enrollapproveddate"]  = {"data_type"=>"date", "file_field"=>"ENROLLAPPROVEDDATE"} if field_order.push("enrollapproveddate")
        structure_hash["fields"]["gender"]              = {"data_type"=>"text", "file_field"=>"GENDER"}             if field_order.push("gender")
        structure_hash["fields"]["classroomname"]       = {"data_type"=>"text", "file_field"=>"CLASSROOMNAME"}      if field_order.push("classroomname")
        structure_hash["fields"]["classroomstart"]      = {"data_type"=>"date", "file_field"=>"CLASSROOMSTART"}     if field_order.push("classroomstart")
        structure_hash["fields"]["teacherfirstname"]    = {"data_type"=>"text", "file_field"=>"TEACHERFIRSTNAME"}   if field_order.push("teacherfirstname")
        structure_hash["fields"]["teacherlastname"]     = {"data_type"=>"text", "file_field"=>"TEACHERLASTNAME"}    if field_order.push("teacherlastname")
        structure_hash["fields"]["teacheremail"]        = {"data_type"=>"text", "file_field"=>"TEACHEREMAIL"}       if field_order.push("teacheremail")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end