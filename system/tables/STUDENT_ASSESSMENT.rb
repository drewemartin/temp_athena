#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ASSESSMENT < Athena_Table
    
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
            s.assessment.existing_record || s.assessment.new_record.save
            
        }
        
    end
    
    def after_load_k12_pal_assessment
        
        sids = $students.enrolled
        sids.each{|sid|
            
            s = $students.get(sid)
            if s
                
                engagement_level_record = $tables.attach("K12_PAL_ASSESSMENT").by_studentid_old(sid)
                if engagement_level_record
                    
                    level = engagement_level_record.fields["engagm_level"].value
                    level = 3.0 if level == "High"
                    level = 2.0 if level == "Average"
                    level = 1.0 if level == "Low"
                    s.assessment.existing_record || s.assessment.new_record.save
                    s.assessment.engagement_level.set(level).save
                    
                end
                
            end
            
        }
        
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
                "name"              => "student_assessment",
                "file_name"         => "student_assessment.csv",
                "file_location"     => "student_assessment",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_one,
                :load_type          => :append,
                :keys               => ["student_id"],
                :update             => true,
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",   "file_field"=>"student_id"               } if field_order.push("student_id"              )
            structure_hash["fields"]["aims_exempt"              ] = {"data_type"=>"bool",  "file_field"=>"aims_exempt"              } if field_order.push("aims_exempt"             )
            structure_hash["fields"]["scantron_exempt_ent_m"    ] = {"data_type"=>"bool",  "file_field"=>"scantron_exempt_ent_m"    } if field_order.push("scantron_exempt_ent_m"   )
            structure_hash["fields"]["scantron_exempt_ent_r"    ] = {"data_type"=>"bool",  "file_field"=>"scantron_exempt_ent_r"    } if field_order.push("scantron_exempt_ent_r"   )
            structure_hash["fields"]["scantron_exempt_ext_m"    ] = {"data_type"=>"bool",  "file_field"=>"scantron_exempt_ext_m"    } if field_order.push("scantron_exempt_ext_m"   )
            structure_hash["fields"]["scantron_exempt_ext_r"    ] = {"data_type"=>"bool",  "file_field"=>"scantron_exempt_ext_r"    } if field_order.push("scantron_exempt_ext_r"   )
            structure_hash["fields"]["study_island_exempt"      ] = {"data_type"=>"bool",  "file_field"=>"study_island_exempt"      } if field_order.push("study_island_exempt"     )
            structure_hash["fields"]["pasa_eligible"            ] = {"data_type"=>"bool",  "file_field"=>"pasa_eligible"            } if field_order.push("pasa_eligible"           )
            structure_hash["fields"]["tier_level_math"          ] = {"data_type"=>"text",  "file_field"=>"tier_level_math"          } if field_order.push("tier_level_math"         )
            structure_hash["fields"]["tier_level_reading"       ] = {"data_type"=>"text",  "file_field"=>"tier_level_reading"       } if field_order.push("tier_level_reading"      )
            structure_hash["fields"]["engagement_level"         ] = {"data_type"=>"int",   "file_field"=>"engagement_level"         } if field_order.push("engagement_level"        )
            structure_hash["fields"]["religious_exempt"         ] = {"data_type"=>"bool",  "file_field"=>"religious_exempt"         } if field_order.push("religious_exempt"        )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end