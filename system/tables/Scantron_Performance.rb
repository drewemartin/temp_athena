#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCANTRON_PERFORMANCE < Athena_Table
    
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
                "name"              => "scantron_performance",
                "file_name"         => "scantron_performance.csv",
                "file_location"     => "scantron_performance",
                "source_address"    => nil,
                "source_type"       => "scantron_performance",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student"]                     = {"data_type"=>"text", "file_field"=>"Student"}                        if field_order.push("student")
        structure_hash["fields"]["student_id"]                  = {"data_type"=>"int",  "file_field"=>"Student ID"}                     if field_order.push("student_id")
        structure_hash["fields"]["grade"]                       = {"data_type"=>"text", "file_field"=>"Grade"}                          if field_order.push("grade")
        structure_hash["fields"]["item_pool"]                   = {"data_type"=>"text", "file_field"=>"Item Pool"}                      if field_order.push("item_pool")
        structure_hash["fields"]["reading_scaled_score"]        = {"data_type"=>"int",  "file_field"=>"Reading Scaled Score"}           if field_order.push("reading_scaled_score")
        structure_hash["fields"]["reading_sem"]                 = {"data_type"=>"int",  "file_field"=>"Reading SEM"}                    if field_order.push("reading_sem")
        structure_hash["fields"]["math_scaled_score"]           = {"data_type"=>"int",  "file_field"=>"Math Scaled Score (English)"}    if field_order.push("math_scaled_score")
        structure_hash["fields"]["math_sem"]                    = {"data_type"=>"int",  "file_field"=>"Math SEM (English)"}             if field_order.push("math_sem")
        structure_hash["fields"]["language_arts_scaled_score"]  = {"data_type"=>"int",  "file_field"=>"Language Arts Scaled Score"}     if field_order.push("language_arts_scaled_score")
        structure_hash["fields"]["language_arts_sem"]           = {"data_type"=>"int",  "file_field"=>"Language Arts SEM"}              if field_order.push("language_arts_sem")
        structure_hash["fields"]["science_scaled_score"]        = {"data_type"=>"int",  "file_field"=>"Science Scaled Score"}           if field_order.push("science_scaled_score")
        structure_hash["fields"]["science_sem"]                 = {"data_type"=>"int",  "file_field"=>"Science SEM"}                    if field_order.push("science_sem")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end