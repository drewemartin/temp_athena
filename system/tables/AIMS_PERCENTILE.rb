#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class AIMS_PERCENTILE < Athena_Table
    
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
                "name"              => "aims_percentile",
                "file_name"         => "aims_percentile.csv",
                "file_location"     => "aims_percentile",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil#,
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
            
            structure_hash["fields"]["gom"          ] = {"data_type"=>"text",           "file_field"=>"gom"             } if field_order.push("gom"             )
            structure_hash["fields"]["grade"        ] = {"data_type"=>"int",            "file_field"=>"grade"           } if field_order.push("grade"           )
            structure_hash["fields"]["percentile"   ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"percentile"      } if field_order.push("percentile"      )
            structure_hash["fields"]["test_period"  ] = {"data_type"=>"text",           "file_field"=>"test_period"     } if field_order.push("test_period"     )
            structure_hash["fields"]["num"          ] = {"data_type"=>"int",            "file_field"=>"num"             } if field_order.push("num"             )
            
            structure_hash["fields"]["roi"          ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"roi"             } if field_order.push("roi"             )
            structure_hash["fields"]["roi_mean"     ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"roi_mean"        } if field_order.push("roi_mean"        )
            structure_hash["fields"]["roi_std_dev"  ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"roi_std_dev"     } if field_order.push("roi_std_dev"     )
            
            structure_hash["fields"]["score"        ] = {"data_type"=>"int",            "file_field"=>"score"           } if field_order.push("score"           )
            structure_hash["fields"]["score_mean"   ] = {"data_type"=>"int",            "file_field"=>"score_mean"      } if field_order.push("score_mean"      )
            structure_hash["fields"]["score_std_dev"] = {"data_type"=>"int",            "file_field"=>"score_std_dev"   } if field_order.push("score_std_dev"   )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end