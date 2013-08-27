#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class SCHOOL_YEAR_DETAIL < Athena_Table
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
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

    def current
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("current", "=", "1") )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_byschoolyear(field_name, school_year)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("school_year", "=", school_year) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_change_field_finalized(field_obj)
        
        if !$tables.attach("SCHOOL_DAYS").primary_ids && field_obj.is_true? && school_days = $base.school_days
            
            school_days.each{|day|
                
                record = $tables.attach("SCHOOL_DAYS").new_row
                record.fields["date"].value = day
                record.save
                
            }
            
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "school_year_detail",
                "file_name"         => "school_year_detail.csv",
                "file_location"     => "school_year_detail",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit_table"       => false
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["school_year"]         = {"data_type"=>"text", "file_field"=>"school_year"}        if field_order.push("school_year")
            structure_hash["fields"]["start_date"]          = {"data_type"=>"date", "file_field"=>"start_date"}         if field_order.push("start_date")
            structure_hash["fields"]["end_date"]            = {"data_type"=>"date", "file_field"=>"end_date"}           if field_order.push("end_date")
            structure_hash["fields"]["school_days"]         = {"data_type"=>"int",  "file_field"=>"school_days"}        if field_order.push("school_days")
            structure_hash["fields"]["ayp_cutoff_date"]     = {"data_type"=>"date", "file_field"=>"ayp_cutoff_date"}    if field_order.push("ayp_cutoff_date")
            structure_hash["fields"]["current"]             = {"data_type"=>"bool", "file_field"=>"current"}            if field_order.push("current")
            structure_hash["fields"]["finalized"]           = {"data_type"=>"bool", "file_field"=>"finalized"}          if field_order.push("finalized")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end