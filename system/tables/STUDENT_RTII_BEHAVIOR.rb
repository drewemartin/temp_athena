#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RTII_BEHAVIOR < Athena_Table
    
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

    #def after_change_field_skill_group(field)
    #    
    #    if defined?($kit) && field_id = $kit.param_by_field(field)
    #        
    #        targeted_behavior_dd = $tables.attach("RTII_VAULT").dd_choices(
    #            "targeted_behavior",
    #            "targeted_behavior",
    #            " WHERE skill_group = '#{field.value}' GROUP BY targeted_behavior "
    #        )
    #        
    #        if field_id.to_s.include?("field_id__")
    #            
    #            pid                 = field_id.to_s.split("__")[1]
    #            replacement_field   = by_primary_id(pid).fields["targeted_behavior"]
    #            
    #            if !targeted_behavior_dd.include?(replacement_field.value)
    #                replacement_field
    #            end
    #            
    #        else
    #            
    #            replacement_field   = new_row.fields["targeted_behavior"]
    #            
    #        end
    #        
    #        field_id            = replacement_field.web.field_id
    #        new_content         = replacement_field.web.select_replacement(:dd_choices=>targeted_behavior_dd)
    #        
    #        $kit.modify_tag_content(
    #            field_id,
    #            new_content
    #        )
    #        
    #    end
    #  
    #end
    #
    #def after_change_field_targeted_behavior(field)
    #    
    #    if defined?($kit) && field_id = $kit.param_by_field(field)
    #        
    #        intervention_dd = $tables.attach("RTII_VAULT").dd_choices(
    #            "intervention",
    #            "intervention",
    #            " WHERE targeted_behavior = '#{field.value}' GROUP BY intervention "
    #        )
    #        
    #        if field_id.to_s.include?("field_id__")
    #            
    #            pid                 = field_id.to_s.split("__")[1]
    #            replacement_field   = by_primary_id(pid).fields["intervention"]
    #            
    #        else
    #            
    #            replacement_field   = new_row.fields["intervention"]
    #            
    #        end
    #        
    #        if intervention_dd
    #            
    #            new_content         = replacement_field.web.select_replacement(:dd_choices=>intervention_dd)
    #            
    #        else
    #            
    #            new_content         = replacement_field.web.select_replacement()
    #            
    #        end
    #        
    #        
    #        $kit.modify_tag_content(
    #            replacement_field.web.field_id,
    #            new_content
    #        )
    #        
    #    end
    #  
    #end
  
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
                "name"              => "student_rtii_behavior",
                "file_name"         => "student_rtii_behavior.csv",
                "file_location"     => "student_rtii_behavior",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",  "file_field"=>"student_id"            } if field_order.push("student_id")
            structure_hash["fields"]["targeted_behavior"    ] = {"data_type"=>"text", "file_field"=>"targeted_behavior"     } if field_order.push("targeted_behavior")
            structure_hash["fields"]["skill_group"          ] = {"data_type"=>"text", "file_field"=>"skill_group"           } if field_order.push("skill_group")
            structure_hash["fields"]["intervention"         ] = {"data_type"=>"text", "file_field"=>"intervention"          } if field_order.push("intervention")
            structure_hash["fields"]["intervention_details" ] = {"data_type"=>"text", "file_field"=>"intervention_details"  } if field_order.push("intervention_details")
            structure_hash["fields"]["results"              ] = {"data_type"=>"text", "file_field"=>"results"               } if field_order.push("results")
            structure_hash["fields"]["proof"                ] = {"data_type"=>"text", "file_field"=>"proof"                 } if field_order.push("proof")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end