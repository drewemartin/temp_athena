#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class MONTHLY_ASSESSMENT_PARTICIPATION_SUMMARY < Athena_Table
    
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
                "name"              => "monthly_assessment_participation_summary",
                "file_name"         => "monthly_assessment_participation_summary.csv",
                "file_location"     => "monthly_assessment_participation_summary",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"] = {"data_type"=>"int", "file_field"=>"student_id"} if field_order.push("student_id")
            structure_hash["fields"]["avg_total"] = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage, "file_field"=>"avg_total"} if field_order.push("avg_total")
            structure_hash["fields"]["feb_math"] = {"data_type"=>"bool", "file_field"=>"feb_math"} if field_order.push("feb_math")
            structure_hash["fields"]["march_math"] = {"data_type"=>"bool", "file_field"=>"march_math"} if field_order.push("march_math")
            structure_hash["fields"]["april_math"] = {"data_type"=>"bool", "file_field"=>"april_math"} if field_order.push("april_math")
            structure_hash["fields"]["may_math"] = {"data_type"=>"bool", "file_field"=>"may_math"} if field_order.push("may_math")
            structure_hash["fields"]["feb_math"] = {"data_type"=>"bool", "file_field"=>"feb_math"} if field_order.push("feb_math")
            structure_hash["fields"]["march_reading"] = {"data_type"=>"bool", "file_field"=>"march_reading"} if field_order.push("march_reading")
            structure_hash["fields"]["april_readin"] = {"data_type"=>"bool", "file_field"=>"april_readin"} if field_order.push("april_readin")
            structure_hash["fields"]["may_reading"] = {"data_type"=>"bool", "file_field"=>"may_reading"} if field_order.push("may_reading")
            structure_hash["fields"]["math_taken"] = {"data_type"=>"int", "file_field"=>"math_taken"} if field_order.push("math_taken")
            structure_hash["fields"]["math_total"] = {"data_type"=>"int", "file_field"=>"math_total"} if field_order.push("math_total")
            structure_hash["fields"]["avg_math"] = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage, "file_field"=>"avg_math"} if field_order.push("avg_math")
            structure_hash["fields"]["reading_taken"] = {"data_type"=>"int", "file_field"=>"reading_taken"} if field_order.push("reading_taken")
            structure_hash["fields"]["reading_total"] = {"data_type"=>"int", "file_field"=>"reading_total"} if field_order.push("reading_total")
            structure_hash["fields"]["avg_reading"] = {"data_type"=>"decimal(5,4)", :file_data_type=>:percentage, "file_field"=>"avg_reading"} if field_order.push("avg_reading")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end