#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class ATHENA_PROJECT < Athena_Table
    
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

    def after_change_field_status(field_obj)
        
        case field_obj.value
        when ""
        end
        record = by_primary_id(field_obj.primary_id)
        
    end
    
    def after_insert(row_obj)
        
        table_array = Array.new
        
        record = by_primary_id(row_obj.primary_id)
        record.table.field_order.each{|field_name|
            field_value = field_name.match(/team_id/) ? record.fields[field_name].to_name : record.fields[field_name].value
            table_array.push(["#{field_name}:", field_value])
        }
        
        content_table = $tools.table(
            :table_array    => table_array,
            :unique_name    => "project",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => "New Project"
        )
        
        $team.find(:full_name=>"Jenifer Halverson").send_email(
            :subject                => "Athena Project #{row_obj.primary_id}",
            :content                => content_table,
            :additional_recipients  => "kayoung@agora.org"
        )
        
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
                "name"              => "athena_project",
                "file_name"         => "athena_project.csv",
                "file_location"     => "athena_project",
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
            
            structure_hash["fields"]["system_id"                ] = {"data_type"=>"int",  "file_field"=>"system_id"                 } if field_order.push("system_id")
            structure_hash["fields"]["project_name"             ] = {"data_type"=>"text", "file_field"=>"project_name"              } if field_order.push("project_name")
            structure_hash["fields"]["project_type"             ] = {"data_type"=>"text", "file_field"=>"project_type"              } if field_order.push("project_type")
            structure_hash["fields"]["brief_description"        ] = {"data_type"=>"text", "file_field"=>"brief_description"         } if field_order.push("brief_description")
            structure_hash["fields"]["department"               ] = {"data_type"=>"text", "file_field"=>"department"                } if field_order.push("department")
            structure_hash["fields"]["requester_team_id"        ] = {"data_type"=>"text", "file_field"=>"requester_team_id"         } if field_order.push("requester_team_id")
            structure_hash["fields"]["requested_priority_level" ] = {"data_type"=>"text", "file_field"=>"requested_priority_level"  } if field_order.push("requested_priority_level")
            structure_hash["fields"]["requested_completion_date"] = {"data_type"=>"date", "file_field"=>"requested_completion_date" } if field_order.push("requested_completion_date")
            structure_hash["fields"]["priority_level"           ] = {"data_type"=>"text", "file_field"=>"priority_level"            } if field_order.push("priority_level")
            structure_hash["fields"]["estimated_completion_date"] = {"data_type"=>"date", "file_field"=>"estimated_completion_date" } if field_order.push("estimated_completion_date")
            structure_hash["fields"]["status"                   ] = {"data_type"=>"text", "file_field"=>"status"                    } if field_order.push("status")
            structure_hash["fields"]["development_phase"        ] = {"data_type"=>"text", "file_field"=>"development_phase"         } if field_order.push("development_phase")
            
        structure_hash["field_order"] = field_order
        
        return structure_hash
        
    end

end