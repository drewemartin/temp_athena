#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_PROGRESS_AND_ACHIEVEMENT < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
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
                "name"              => "k12_progress_and_achievement",
                "file_name"         => "agora_select-MA-LALS-grade-levels-for-students.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_select-MA-LALS-grade-levels-for-students.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Progress And Achievement"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["lals_is_ambiguous"]       = {"data_type"=>"text", "file_field"=>"LALS_IS_AMBIGUOUS"}  if field_order.push("lals_is_ambiguous")
            structure_hash["fields"]["ma_is_ambiguous"]         = {"data_type"=>"text", "file_field"=>"MA_IS_AMBIGUOUS"}    if field_order.push("ma_is_ambiguous")
            structure_hash["fields"]["sc_is_ambiguous"]         = {"data_type"=>"text", "file_field"=>"SC_IS_AMBIGUOUS"}    if field_order.push("sc_is_ambiguous")
            structure_hash["fields"]["hi_is_ambiguous"]         = {"data_type"=>"text", "file_field"=>"HI_IS_AMBIGUOUS"}    if field_order.push("hi_is_ambiguous")
            structure_hash["fields"]["mu_is_ambiguous"]         = {"data_type"=>"text", "file_field"=>"MU_IS_AMBIGUOUS"}    if field_order.push("mu_is_ambiguous")
            structure_hash["fields"]["va_is_ambiguous"]         = {"data_type"=>"text", "file_field"=>"VA_IS_AMBIGUOUS"}    if field_order.push("va_is_ambiguous")
            structure_hash["fields"]["lals_numactive"]          = {"data_type"=>"text", "file_field"=>"LALS_NUMACTIVE"}     if field_order.push("lals_numactive")
            structure_hash["fields"]["ma_numactive"]            = {"data_type"=>"text", "file_field"=>"MA_NUMACTIVE"}       if field_order.push("ma_numactive")
            structure_hash["fields"]["sc_numactive"]            = {"data_type"=>"text", "file_field"=>"SC_NUMACTIVE"}       if field_order.push("sc_numactive")
            structure_hash["fields"]["hi_numactive"]            = {"data_type"=>"text", "file_field"=>"HI_NUMACTIVE"}       if field_order.push("hi_numactive")
            structure_hash["fields"]["mu_numactive"]            = {"data_type"=>"text", "file_field"=>"MU_NUMACTIVE"}       if field_order.push("mu_numactive")
            structure_hash["fields"]["va_numactive"]            = {"data_type"=>"text", "file_field"=>"VA_NUMACTIVE"}       if field_order.push("va_numactive")
            structure_hash["fields"]["lals_numstartdates"]      = {"data_type"=>"text", "file_field"=>"LALS_NUMSTARTDATES"} if field_order.push("lals_numstartdates")
            structure_hash["fields"]["ma_numstartdates"]        = {"data_type"=>"text", "file_field"=>"MA_NUMSTARTDATES"}   if field_order.push("ma_numstartdates")
            structure_hash["fields"]["sc_numstartdates"]        = {"data_type"=>"text", "file_field"=>"SC_NUMSTARTDATES"}   if field_order.push("sc_numstartdates")
            structure_hash["fields"]["hi_numstartdates"]        = {"data_type"=>"text", "file_field"=>"HI_NUMSTARTDATES"}   if field_order.push("hi_numstartdates")
            structure_hash["fields"]["mu_numstartdates"]        = {"data_type"=>"text", "file_field"=>"MU_NUMSTARTDATES"}   if field_order.push("mu_numstartdates")
            structure_hash["fields"]["va_numstartdates"]        = {"data_type"=>"text", "file_field"=>"VA_NUMSTARTDATES"}   if field_order.push("va_numstartdates")
            structure_hash["fields"]["studentstatus"]           = {"data_type"=>"text", "file_field"=>"STUDENTSTATUS"}      if field_order.push("studentstatus")
            structure_hash["fields"]["studentgrade"]            = {"data_type"=>"text", "file_field"=>"STUDENTGRADE"}       if field_order.push("studentgrade")
            structure_hash["fields"]["lals_coursegrade"]        = {"data_type"=>"text", "file_field"=>"LALS_COURSEGRADE"}   if field_order.push("lals_coursegrade")
            structure_hash["fields"]["ma_coursegrade"]          = {"data_type"=>"text", "file_field"=>"MA_COURSEGRADE"}     if field_order.push("ma_coursegrade")
            structure_hash["fields"]["sc_coursegrade"]          = {"data_type"=>"text", "file_field"=>"SC_COURSEGRADE"}     if field_order.push("sc_coursegrade")
            structure_hash["fields"]["hi_coursegrade"]          = {"data_type"=>"text", "file_field"=>"HI_COURSEGRADE"}     if field_order.push("hi_coursegrade")
            structure_hash["fields"]["mu_coursegrade"]          = {"data_type"=>"text", "file_field"=>"MU_COURSEGRADE"}     if field_order.push("mu_coursegrade")
            structure_hash["fields"]["va_coursegrade"]          = {"data_type"=>"text", "file_field"=>"VA_COURSEGRADE"}     if field_order.push("va_coursegrade")
            structure_hash["fields"]["schoolname"]              = {"data_type"=>"text", "file_field"=>"SCHOOLNAME"}         if field_order.push("schoolname")
            structure_hash["fields"]["studentid"]               = {"data_type"=>"int",  "file_field"=>"STUDENTID"}          if field_order.push("studentid")
            structure_hash["fields"]["integrationid"]           = {"data_type"=>"text", "file_field"=>"INTEGRATIONID"}      if field_order.push("integrationid")
            structure_hash["fields"]["lastname"]                = {"data_type"=>"text", "file_field"=>"LASTNAME"}           if field_order.push("lastname")
            structure_hash["fields"]["firstname"]               = {"data_type"=>"text", "file_field"=>"FIRSTNAME"}          if field_order.push("firstname")
            structure_hash["fields"]["birthday"]                = {"data_type"=>"date", "file_field"=>"BIRTHDAY"}           if field_order.push("birthday")
            structure_hash["fields"]["hasiep"]                  = {"data_type"=>"bool", "file_field"=>"HASIEP"}             if field_order.push("hasiep")
            structure_hash["fields"]["enrollapproveddate"]      = {"data_type"=>"date", "file_field"=>"ENROLLAPPROVEDDATE"} if field_order.push("enrollapproveddate")
            structure_hash["fields"]["schoolenrolldate"]        = {"data_type"=>"date", "file_field"=>"SCHOOLENROLLDATE"}   if field_order.push("schoolenrolldate")
            structure_hash["fields"]["lals_course"]             = {"data_type"=>"text", "file_field"=>"LALS_COURSE"}        if field_order.push("lals_course")
            structure_hash["fields"]["ma_coursecode"]           = {"data_type"=>"text", "file_field"=>"MA_COURSECODE"}      if field_order.push("ma_coursecode")
            structure_hash["fields"]["sc_coursecode"]           = {"data_type"=>"text", "file_field"=>"SC_COURSECODE"}      if field_order.push("sc_coursecode")
            structure_hash["fields"]["hi_coursecode"]           = {"data_type"=>"text", "file_field"=>"HI_COURSECODE"}      if field_order.push("hi_coursecode")
            structure_hash["fields"]["mu_coursecode"]           = {"data_type"=>"text", "file_field"=>"MU_COURSECODE"}      if field_order.push("mu_coursecode")
            structure_hash["fields"]["va_coursecode"]           = {"data_type"=>"text", "file_field"=>"VA_COURSECODE"}      if field_order.push("va_coursecode")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end