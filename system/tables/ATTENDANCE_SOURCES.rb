#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATTENDANCE_SOURCES < Athena_Table
    
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

    def type_by_source(source)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("source", "=", source) )
        where_clause = $db.where_clause(params)
        find_field("type", where_clause)
    end
    
    def source_array(type = nil)
        where_clause = type ? " WHERE type = '#{type}'" : ""
        $db.get_data_single("SELECT #{data_base}.source FROM #{data_base}.#{table_name} #{where_clause}")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def load_pre_reqs
        
        pre_reqs = [
            {
                :source                 => "Blackboard",              
                :type                   => "Live",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "K12 Logins",              
                :type                   => "Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "K12 Logins - LC",              
                :type                   => "Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "LMS",              
                :type                   => "Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "LMS - Manual",              
                :type                   => "Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "OLS",              
                :type                   => "Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            },
            {
                :source                 => "Sapphire Period Attendance",              
                :type                   => "Classroom Activity",                
                :test_event             => nil,          
                :override_attendance    => nil, 
                :grade_k=>true,     :grade_1st=>true,   :grade_2nd=>true,   :grade_3rd=>true,   :grade_4th=>true,   :grade_5th=>true,
                :grade_6th=>true,   :grade_7th=>true,   :grade_8th=>true,
                :grade_9th=>true,   :grade_10th=>true,  :grade_11th=>true,  :grade_12th=>true         
            }
        ]
        
        max = pre_reqs.length
        (0...max).each{|i|
            
            if primary_ids("WHERE source = '#{pre_reqs[i][:source]}'")
                pre_reqs[i] = nil
            end
            
        }
        
        pre_reqs.compact!
        
        return pre_reqs
        
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
                "name"              => "attendance_sources",
                "file_name"         => "attendance_sources.csv",
                "file_location"     => "attendance_sources",
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
            
            structure_hash["fields"]["source"                           ] = {"data_type"=>"text", "file_field"=>"source"                        } if field_order.push("source"                          )
            structure_hash["fields"]["type"                             ] = {"data_type"=>"text", "file_field"=>"type"                          } if field_order.push("type"                            )
            structure_hash["fields"]["test_event"                       ] = {"data_type"=>"bool", "file_field"=>"test_event"                    } if field_order.push("test_event"                      )
            structure_hash["fields"]["override_attendance"              ] = {"data_type"=>"bool", "file_field"=>"override_attendance"           } if field_order.push("override_attendance"             )
            
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