#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ILP_ENTRY_TYPE < Athena_Table
    
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

    def init_pre_reqs
        
        return ["ILP_ENTRY_CATEGORY","SAPPHIRE_DICTIONARY_PERIODS"]
        
    end
    
    def load_pre_reqs
        
        pre_reqs = Array.new
        
        aims_assessment_results(pre_reqs)
        sapphire_periods(pre_reqs)
        
        return pre_reqs
        
    end
    
    def aims_assessment_results(pre_reqs)
        
        cat_id = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids("WHERE name = 'AIMS Assessment'")[0]
        grade_hash  = {
            :grade_k => true, :grade_1st=>true,     :grade_2nd=>true,   :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true,
            :grade_6th=>true, :grade_7th=>true,     :grade_8th=>true,
            :grade_9th=>true, :grade_10th=>true,    :grade_11th=>true,  :grade_12th=>true,
        }                
        pre_reqs.push({:category_id=>cat_id, :name=>"LNF"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"LNF Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"LSF"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"LSF Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"PSF"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"PSF Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"NWF"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"NWF Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"RCBM"                                 }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"RCBM Errors"                          }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"Reading Instructional Recommendation" }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"2nd Grade Reading Comprehension Check"}.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"OCM"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"OCM Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"NIM"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"NIM Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"QDM"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"QDM Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"MNM"                                  }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"MNM Errors"                           }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"MCAP"                                 }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"Math Instructional Recommendation"    }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"Notes"                                }.merge(grade_hash))
        pre_reqs.push({:category_id=>cat_id, :name=>"MCAP read to student"                 }.merge(grade_hash))  
        
        max = pre_reqs.length
        (0...max).each{|i|
            
            if primary_ids("WHERE category_id = '#{pre_reqs[i][:category_id]}' AND name = '#{pre_reqs[i][:name]}'")
                pre_reqs[i] = nil
            end
            
        }
        
        pre_reqs.compact!
        
        return pre_reqs
        
    end
    
    def sapphire_periods(pre_reqs)
        
        sapphire_periods        = $tables.attach("SAPPHIRE_DICTIONARY_PERIODS"  ).primary_ids("WHERE start_time IS NOT NULL AND end_time IS NOT NULL")
        sapphire_courses_cat_id = $tables.attach("ILP_ENTRY_CATEGORY"           ).primary_ids("WHERE name = 'Sapphire Course Schedule'")
        
        if sapphire_periods && sapphire_courses_cat_id
            
            sapphire_courses_cat_id = sapphire_courses_cat_id[0]
            
            sapphire_periods.each{|pid|
                
                record      = $tables.attach("SAPPHIRE_DICTIONARY_PERIODS").by_primary_id(pid)
                period_code = record.fields["period_code"       ].value
                start_time  = record.fields["start_time"        ].to_user
                end_time    = record.fields["end_time"          ].to_user
                description = "#{record.fields["period_decription" ].value} #{start_time} to #{end_time}"
                
                if !primary_ids("WHERE name = '#{period_code}' AND default_description = '#{description}'")
                    
                    pre_reqs.push(
                     
                        {
                            :grade_k                => true, :grade_1st=>true, :grade_2nd=>true, :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true, :grade_6th=>true, :grade_7th=>true, :grade_8th=>true, :grade_9th=>true, :grade_10th=>true, :grade_11th=>true, :grade_12th=>true,
                            :category_id            => sapphire_courses_cat_id,
                            :name                   => period_code,
                            :default_description    => description,
                            :manual                 => false
                        }
                        
                    )
                    
                end
                
            }
            
        end
        
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
                "name"              => "ilp_entry_type",
                "file_name"         => "ilp_entry_type.csv",
                "file_location"     => "ilp_entry_type",
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
            
            structure_hash["fields"]["category_id"                      ] = {"data_type"=>"int",  "file_field"=>"category_id"                   } if field_order.push("category_id"                     )
            structure_hash["fields"]["name"                             ] = {"data_type"=>"text", "file_field"=>"name"                          } if field_order.push("name"                            )
            structure_hash["fields"]["default_description"              ] = {"data_type"=>"text", "file_field"=>"default_description"           } if field_order.push("default_description"             )
            structure_hash["fields"]["default_solution"                 ] = {"data_type"=>"text", "file_field"=>"default_solution"              } if field_order.push("default_solution"                )
            structure_hash["fields"]["manual"                           ] = {"data_type"=>"bool", "file_field"=>"manual"                        } if field_order.push("manual"                          )
            structure_hash["fields"]["required"                         ] = {"data_type"=>"bool", "file_field"=>"required"                      } if field_order.push("required"                        )
            structure_hash["fields"]["max_entries"                      ] = {"data_type"=>"int",  "file_field"=>"max_entries"                   } if field_order.push("max_entries"                     )
            
            structure_hash["fields"]["grade_k"                          ] = {"data_type"=>"bool", "file_field"=>"grade_k"                       } if field_order.push("grade_k"                         )
            structure_hash["fields"]["grade_1st"                        ] = {"data_type"=>"bool", "file_field"=>"grade_1st"                     } if field_order.push("grade_1st"                       )
            structure_hash["fields"]["grade_2nd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_2nd"                     } if field_order.push("grade_2nd"                       )
            structure_hash["fields"]["grade_3rd"                        ] = {"data_type"=>"bool", "file_field"=>"grade_3rd"                     } if field_order.push("grade_3rd"                       )
            structure_hash["fields"]["grade_4th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_4th"                     } if field_order.push("grade_4th"                       )
            structure_hash["fields"]["grade_5th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_5th"                     } if field_order.push("grade_5th"                       )
            structure_hash["fields"]["grade_6th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_6th"                     } if field_order.push("grade_6th"                       )
            structure_hash["fields"]["grade_7th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_7th"                     } if field_order.push("grade_7th"                       )
            structure_hash["fields"]["grade_8th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_8th"                     } if field_order.push("grade_8th"                       )
            structure_hash["fields"]["grade_9th"                        ] = {"data_type"=>"bool", "file_field"=>"grade_9th"                     } if field_order.push("grade_9th"                       )
            structure_hash["fields"]["grade_10th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_10th"                    } if field_order.push("grade_10th"                      )
            structure_hash["fields"]["grade_11th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_11th"                    } if field_order.push("grade_11th"                      )
            structure_hash["fields"]["grade_12th"                       ] = {"data_type"=>"bool", "file_field"=>"grade_12th"                    } if field_order.push("grade_12th"                      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end