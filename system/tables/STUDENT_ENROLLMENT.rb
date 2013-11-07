#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ENROLLMENT < Athena_Table
    
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
    
    def active_by_studentid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("active",     "=", "1") )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "student_enrollment",
                "file_name"         => "student_enrollment.csv",
                "file_location"     => "student_enrollment",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
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
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",  "file_field"=>"student_id"              } if field_order.push("student_id")
            structure_hash["fields"]["preferredname"]           = {"data_type"=>"text", "file_field"=>"preferredname"           } if field_order.push("preferredname")
            structure_hash["fields"]["enrollreceiveddate"]      = {"data_type"=>"date", "file_field"=>"enrollreceiveddate"      } if field_order.push("enrollreceiveddate")
            structure_hash["fields"]["language"]                = {"data_type"=>"text", "file_field"=>"language"                } if field_order.push("language")
            structure_hash["fields"]["stu_lang_first_acquired"] = {"data_type"=>"text", "file_field"=>"stu_lang_first_acquired" } if field_order.push("stu_lang_first_acquired")
            structure_hash["fields"]["homelangsurv"]            = {"data_type"=>"bool", "file_field"=>"homelangsurv"            } if field_order.push("homelangsurv")
            structure_hash["fields"]["countryofbirth"]          = {"data_type"=>"text", "file_field"=>"countryofbirth"          } if field_order.push("countryofbirth")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end