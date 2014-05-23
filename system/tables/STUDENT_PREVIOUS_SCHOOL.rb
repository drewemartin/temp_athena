#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_PREVIOUS_SCHOOL < Athena_Table
    
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
    
    def after_insert(row_object)
        
        verify_school_exists(row_object)
        
    end
    
    def after_change_field_previous_school(field_object)
        
        verify_school_exists(field_object)
        
    end
    
    def after_change_field_previous_district(field_object)
        
        verify_school_exists(field_object)
        
    end
    
    def after_change_field_previous_school_state(field_object)
        
        verify_school_exists(field_object)
        
    end
    
    def verify_school_exists(obj)
        
        this_record = by_primary_id(obj.primary_id)
     
        if school_pid = $tables.attach("SCHOOLS").field_value(
            
            "primary_id",
            
            "WHERE  school_name = '#{Mysql.quote(this_record.fields["previous_school"       ].value || '')}'
            AND     district    = '#{Mysql.quote(this_record.fields["previous_district"     ].value || '')}'
            AND     state       = '#{Mysql.quote(this_record.fields["previous_school_state" ].value || '')}'"
            
        )
            
            this_record.fields["school_pid"].set(school_pid).save
            this_record.fields["verified"  ].set(true      ).save
            
        else
            
            this_record.fields["verified"].set(false ).save
            
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_previous_school",
                "file_name"         => "student_previous_school.csv",
                "file_location"     => "student_previous_school",
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
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",      "file_field"=>"student_id"            } if field_order.push("student_id"              )
            structure_hash["fields"]["previous_school"          ] = {"data_type"=>"text",     "file_field"=>"previous_school"       } if field_order.push("previous_school"         )
            structure_hash["fields"]["previous_district"        ] = {"data_type"=>"text",     "file_field"=>"previous_district"     } if field_order.push("previous_district"       )
            structure_hash["fields"]["previous_school_state"    ] = {"data_type"=>"text",     "file_field"=>"previous_school_state" } if field_order.push("previous_school_state"   )
            structure_hash["fields"]["previous_school_type"     ] = {"data_type"=>"text",     "file_field"=>"previous_school_type"  } if field_order.push("previous_school_type"    )
            structure_hash["fields"]["verified"                 ] = {"data_type"=>"bool",     "file_field"=>"verified"              } if field_order.push("verified"                )
            structure_hash["fields"]["school_pid"               ] = {"data_type"=>"int",      "file_field"=>"school_pid"            } if field_order.push("school_pid"              )
            structure_hash["fields"]["request_sent"             ] = {"data_type"=>"bool",     "file_field"=>"request_sent"          } if field_order.push("request_sent"            )
            structure_hash["fields"]["request_sent_date"        ] = {"data_type"=>"datetime", "file_field"=>"request_sent_date"     } if field_order.push("request_sent_date"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end