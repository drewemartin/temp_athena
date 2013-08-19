#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DISTRICTS < Athena_Table
    
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

    def by_district(district, contact_department = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("district",           "=", district           ) )
        params.push( Struct::WHERE_PARAMS.new("contact_department", "=", contact_department ) ) if contact_department
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_department(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("contact_department", "=", arg ) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY district"
        records(where_clause) 
    end
    
    def by_letter(letter, contact_department = nil, group_by_name = false)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("district", "REGEXP", "^#{letter}" ) )
        params.push( Struct::WHERE_PARAMS.new("contact_department", "=", contact_department ) ) if contact_department
        where_clause = $db.where_clause(params)
        where_clause << " GROUP BY district"
        where_clause << " ORDER BY district"
        records(where_clause) 
    end

    def by_primaryid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bydistrict(field_name, district, contact_department = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("district",           "=", district           ) )
        params.push( Struct::WHERE_PARAMS.new("contact_department", "=", contact_department ) ) if contact_department
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    
    
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
                "name"              => "districts",
                "file_name"         => "districts.csv",
                "file_location"     => "districts",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["district"]            = {"data_type"=>"text", "file_field"=>"district"}           if field_order.push("district")
            structure_hash["fields"]["contact_department"]  = {"data_type"=>"text", "file_field"=>"contact_department"} if field_order.push("contact_department")
            structure_hash["fields"]["contact_first_name"]  = {"data_type"=>"text", "file_field"=>"contact_first_name"} if field_order.push("contact_first_name")
            structure_hash["fields"]["contact_last_name"]   = {"data_type"=>"text", "file_field"=>"contact_last_name"}  if field_order.push("contact_last_name")
            structure_hash["fields"]["contact_email"]       = {"data_type"=>"text", "file_field"=>"contact_email"}      if field_order.push("contact_email")
            structure_hash["fields"]["contact_phone"]       = {"data_type"=>"text", "file_field"=>"contact_phone"}      if field_order.push("contact_phone")
            structure_hash["fields"]["contact_fax"]         = {"data_type"=>"text", "file_field"=>"contact_fax"}        if field_order.push("contact_fax")
            structure_hash["fields"]["active"]              = {"data_type"=>"text", "file_field"=>"active"}             if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end