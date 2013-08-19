#!/usr/bin/env ruby

require "#{$paths.base_path}athena_table"

class TEAM_RELATE_REGION < Athena_Table
    
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
                "name"            => "team_relate_region",
                "file_name"       => "team_relate_region.csv",
                "file_location"   => "team_relate_region",
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
        structure_hash["fields"]["region"]                          = {"data_type"=>"text", "file_field"=>"region"}                           if field_order.push("region")
        structure_hash["fields"]["family_coach_id"]                 = {"data_type"=>"int",  "file_field"=>"family_coach_id"}                  if field_order.push("family_coach_id")
        structure_hash["fields"]["family_coach_program_support_id"] = {"data_type"=>"text", "file_field"=>"family_coach_program_support_id"}  if field_order.push("family_coach_program_support_id")
        structure_hash["fields"]["truancy_prevention_id"]           = {"data_type"=>"text", "file_field"=>"truancy_prevention_id"}            if field_order.push("truancy_prevention_id")
        structure_hash["fields"]["advisor_id"]                      = {"data_type"=>"text", "file_field"=>"advisor_id"}                       if field_order.push("advisor_id")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end

