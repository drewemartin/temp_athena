#!/usr/bin/env ruby

require "#{$paths.base_path}athena_table"

class TEAM_RELATE_GRADE_LEVEL < Athena_Table
  
    def initialize()
        super()
        @table_structure = nil
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
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
                "name"            => "team_relate_grade_level",
                "file_name"       => "team_relate_grade_level.csv",
                "file_location"   => "team_relate_grade_level",
                "source_address"  => nil,
                "source_type"     => nil,
                "download_times"  => nil,
                "trigger_events"  => nil,
                "audit"           => true
              
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end

    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["sams_id"]         = {"data_type"=>"int", "file_field"=>"sams_id"}       if field_order.push("sams_id")
        structure_hash["fields"]["grade"]           = {"data_type"=>"text", "file_field"=>"grade"}        if field_order.push("grade")
        structure_hash["fields"]["role"]            = {"data_type"=>"text", "file_field"=>"role"}         if field_order.push("role")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end
