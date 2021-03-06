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
            
            start_date  = $tables.attach("SCHOOL_YEAR_DETAIL" ).find_field( "start_date",  "WHERE school_year = '#{$config.school_year}'")
            end_date    = $tables.attach("SCHOOL_YEAR_DETAIL" ).find_field( "end_date",    "WHERE school_year = '#{$config.school_year}'")
            
            last_day_of_school  = end_date.mathable
            eval_date           = start_date
            
            until eval_date.mathable > last_day_of_school
              
                if !$tables.attach("SCHOOL_CALENDAR").primary_ids("WHERE date = '#{eval_date.to_db}'")
                    
                    record = $tables.attach("SCHOOL_CALENDAR").new_record
                    record.fields["date"].value = eval_date.to_db
                    record.save
                    
                end
              
                eval_date.add!
              
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "school_year_detail",
                "file_name"         => "school_year_detail.csv",
                "file_location"     => "school_year_detail",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true
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