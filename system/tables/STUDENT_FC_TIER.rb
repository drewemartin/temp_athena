#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_FC_TIER < Athena_Table
    
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

    def after_load_k12_omnibus
        
        sids = $students.enrolled
        sids.each{|sid|
            
            s = $students.get(sid)
            s.fc_tier.existing_record || s.fc_tier.new_record.save
            
        } if sids
        
    end

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
                "name"              => "student_fc_tier",
                "file_name"         => "student_fc_tier.csv",
                "file_location"     => "student_fc_tier",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"]  = {"data_type"=>"int", "file_field"=>"student_id"}  if field_order.push("student_id")
            structure_hash["fields"]["fc_tier"]     = {"data_type"=>"text", "file_field"=>"fc_tier"}    if field_order.push("fc_tier")
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end