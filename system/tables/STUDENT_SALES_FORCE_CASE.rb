#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_SALES_FORCE_CASE < Athena_Table
    
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

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
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
                :keys               => ["case_number"],
                :load_type          => :append,
                :update             => false,
                "name"              => "student_sales_force_case",
                "file_name"         => "student_sales_force_case.csv",
                "file_location"     => "student_sales_force_case",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => false,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]      = {"data_type"=>"int",  "file_field"=>"SAMS_STUDENTID"}          if field_order.push("student_id")
            structure_hash["fields"]["epr_student_id"]  = {"data_type"=>"int",  "file_field"=>"EPR_STUDENTID"}           if field_order.push("epr_student_id")
            structure_hash["fields"]["idenity_id"]      = {"data_type"=>"int",  "file_field"=>"SAMS_STUDENT_IDENITYID"}  if field_order.push("idenity_id")
            structure_hash["fields"]["created_on_date"] = {"data_type"=>"date", "file_field"=>"CREATED_ON_DATE"}         if field_order.push("created_on_date")
            structure_hash["fields"]["changed_on_date"] = {"data_type"=>"date", "file_field"=>"CHANGED_ON_DATE"}         if field_order.push("changed_on_date")
            structure_hash["fields"]["case_number"]     = {"data_type"=>"text",  "file_field"=>"CASE_NUMBER"}            if field_order.push("case_number")
            structure_hash["fields"]["contact_phone"]   = {"data_type"=>"text", "file_field"=>"CONTACT_PHONE"}           if field_order.push("contact_phone")
            structure_hash["fields"]["contact_name"]    = {"data_type"=>"text", "file_field"=>"CONTACT_NAME"}            if field_order.push("contact_name")
            structure_hash["fields"]["description"]     = {"data_type"=>"text", "file_field"=>"DESCRIPTION"}             if field_order.push("description")
            structure_hash["fields"]["category"]        = {"data_type"=>"text", "file_field"=>"CATEGORY"}                if field_order.push("category")
            structure_hash["fields"]["sub_category"]    = {"data_type"=>"text", "file_field"=>"SUB_CATEGORY"}            if field_order.push("sub_category")
            structure_hash["fields"]["topic"]           = {"data_type"=>"text", "file_field"=>"TOPIC"}                   if field_order.push("topic")
            structure_hash["fields"]["resolution"]      = {"data_type"=>"text", "file_field"=>"RESOLUTION"}              if field_order.push("resolution")
            structure_hash["fields"]["status"]          = {"data_type"=>"text", "file_field"=>"STATUS"}                  if field_order.push("status")
            structure_hash["fields"]["case_school"]     = {"data_type"=>"text", "file_field"=>"CASE_SCHOOL"}             if field_order.push("case_school")
            structure_hash["fields"]["origin"]          = {"data_type"=>"text", "file_field"=>"ORIGIN"}                  if field_order.push("origin")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end