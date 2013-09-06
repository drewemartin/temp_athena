#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class RELATE_ROLES < Athena_Table
    
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
    
    def field_byrole(field_name, role)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("role", "=", role) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def student_base_evaluation_roles
        $db.get_data_single("SELECT role FROM #{data_base}.#{table_name} WHERE student_based_evaluation IS TRUE ORDER BY role ASC")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "relate_roles",
                "file_name"         => "relate_roles.csv",
                "file_location"     => "relate_roles",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["role"] = {"data_type"=>"text", "file_field"=>"role"} if field_order.push("role")
            structure_hash["fields"]["student_based_evaluation"] = {"data_type"=>"bool", "file_field"=>"student_based_evaluation"} if field_order.push("student_based_evaluation")
            structure_hash["fields"]["evaluation_template"] = {"data_type"=>"text", "file_field"=>"evaluation_template"} if field_order.push("evaluation_template")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end