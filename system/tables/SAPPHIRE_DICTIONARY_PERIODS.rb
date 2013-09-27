#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAPPHIRE_DICTIONARY_PERIODS < Athena_Table
    
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

    def after_change_field(field_obj)
        
        record          = by_primary_id(field_obj.primary_id)
        
        start_time      = record.fields["start_time"        ]
        end_time        = record.fields["end_time"          ]
        time_frame      = (start_time.value&&end_time.value ? "#{start_time.to_user} to #{end_time.to_user}" : "")
        description     = "#{record.fields["period_decription" ].value} #{time_frame}"
        
        ilp_type_record = $tables.attach("ILP_ENTRY_TYPE").record("WHERE name = '#{record.fields["period_code"].value}'")
        ilp_type_record.fields["default_description"].value = description
        ilp_type_record.save
        
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
                "name"              => "sapphire_dictionary_periods",
                "file_name"         => "sapphire_dictionary_periods.csv",
                "file_location"     => "sapphire_dictionary_periods",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
           
            structure_hash["fields"]["period_code"      ] = {"data_type"=>"text",   "file_field"=>"period_code"         } if field_order.push("period_code"         )
            structure_hash["fields"]["school_type"      ] = {"data_type"=>"text",   "file_field"=>"school_type"         } if field_order.push("school_type"         )
            structure_hash["fields"]["period_decription"] = {"data_type"=>"text",   "file_field"=>"period_decription"   } if field_order.push("period_decription"   )
            structure_hash["fields"]["start_time"       ] = {"data_type"=>"time",   "file_field"=>"start_time"          } if field_order.push("start_time"          )
            structure_hash["fields"]["end_time"         ] = {"data_type"=>"time",   "file_field"=>"end_time"            } if field_order.push("end_time"            )
            structure_hash["fields"]["sequence"         ] = {"data_type"=>"int",    "file_field"=>"sequence"            } if field_order.push("sequence"            )
            structure_hash["fields"]["schedule"         ] = {"data_type"=>"bool",   "file_field"=>"schedule"            } if field_order.push("schedule"            )
            structure_hash["fields"]["daily_attendance" ] = {"data_type"=>"bool",   "file_field"=>"daily_attendance"    } if field_order.push("daily_attendance"    )
            structure_hash["fields"]["delete"           ] = {"data_type"=>"bool",   "file_field"=>"delete"              } if field_order.push("delete"              )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end