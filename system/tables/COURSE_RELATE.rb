#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class COURSE_RELATE < Athena_Table
    
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

    def by_course_name(course_name)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("course_name", "=", course_name ))
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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
                "name"              => "course_relate",
                "file_name"         => "course_relate.csv",
                "file_location"     => "course_relate",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true#,
                #:relationship       => :one_to_many,
                #:relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["course_name"                      ] = {"data_type"=>"text", "file_field"=>"course_name"                         } if field_order.push("course_name"                      )
            structure_hash["fields"]["scantron_growth_math"             ] = {"data_type"=>"bool", "file_field"=>"scantron_growth_math"                } if field_order.push("scantron_growth_math"             )
            structure_hash["fields"]["scantron_growth_reading"          ] = {"data_type"=>"bool", "file_field"=>"scantron_growth_reading"             } if field_order.push("scantron_growth_reading"          )
            structure_hash["fields"]["scantron_participation_math"      ] = {"data_type"=>"bool", "file_field"=>"scantron_participation_math"         } if field_order.push("scantron_participation_math"      )
            structure_hash["fields"]["scantron_participation_reading"   ] = {"data_type"=>"bool", "file_field"=>"scantron_participation_reading"      } if field_order.push("scantron_participation_reading"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end