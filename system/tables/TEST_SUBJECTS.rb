#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_SUBJECTS < Athena_Table
    
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
    
    def get_eligible_grades(test_id)
        
        params = Array.new
        
        params.push( Struct::WHERE_PARAMS.new("test_id",   "=", test_id   ) )
        where_clause = $db.where_clause(params)
        
        eligible_grades = Array.new
        eligible_grades.push("K"    ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_k  IS TRUE")
        eligible_grades.push("1st"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_1  IS TRUE")
        eligible_grades.push("2nd"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_2  IS TRUE")
        eligible_grades.push("3rd"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_3  IS TRUE")
        eligible_grades.push("4th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_4  IS TRUE")
        eligible_grades.push("5th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_5  IS TRUE")
        eligible_grades.push("6th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_6  IS TRUE")
        eligible_grades.push("7th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_7  IS TRUE")
        eligible_grades.push("8th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_8  IS TRUE")
        eligible_grades.push("9th"  ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_9  IS TRUE")
        eligible_grades.push("10th" ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_10 IS TRUE")
        eligible_grades.push("11th" ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_11 IS TRUE")
        eligible_grades.push("12th" ) if $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE test_id = #{test_id} AND grade_12 IS TRUE")
        
        return eligible_grades.empty? ? eligible_grades : false
        
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "test_subjects",
                "file_name"         => "test_subjects.csv",
                "file_location"     => "test_subjects",
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
            structure_hash["fields"]["name"                 ] = {"data_type"=>"text", "file_field"=>"name"              } if field_order.push("name")
            structure_hash["fields"]["test_id"              ] = {"data_type"=>"int",  "file_field"=>"test_id"           } if field_order.push("test_id")
            structure_hash["fields"]["grade_k"              ] = {"data_type"=>"bool", "file_field"=>"grade_k"           } if field_order.push("grade_k")
            structure_hash["fields"]["grade_1st"            ] = {"data_type"=>"bool", "file_field"=>"grade_1st"         } if field_order.push("grade_1st")
            structure_hash["fields"]["grade_2nd"            ] = {"data_type"=>"bool", "file_field"=>"grade_2nd"         } if field_order.push("grade_2nd")
            structure_hash["fields"]["grade_3rd"            ] = {"data_type"=>"bool", "file_field"=>"grade_3rd"         } if field_order.push("grade_3rd")
            structure_hash["fields"]["grade_4th"            ] = {"data_type"=>"bool", "file_field"=>"grade_4th"         } if field_order.push("grade_4th")
            structure_hash["fields"]["grade_5th"            ] = {"data_type"=>"bool", "file_field"=>"grade_5th"         } if field_order.push("grade_5th")
            structure_hash["fields"]["grade_6th"            ] = {"data_type"=>"bool", "file_field"=>"grade_6th"         } if field_order.push("grade_6th")
            structure_hash["fields"]["grade_7th"            ] = {"data_type"=>"bool", "file_field"=>"grade_7th"         } if field_order.push("grade_7th")
            structure_hash["fields"]["grade_8th"            ] = {"data_type"=>"bool", "file_field"=>"grade_8th"         } if field_order.push("grade_8th")
            structure_hash["fields"]["grade_9th"            ] = {"data_type"=>"bool", "file_field"=>"grade_9th"         } if field_order.push("grade_9th")
            structure_hash["fields"]["grade_10th"           ] = {"data_type"=>"bool", "file_field"=>"grade_10th"        } if field_order.push("grade_10th")
            structure_hash["fields"]["grade_11th"           ] = {"data_type"=>"bool", "file_field"=>"grade_11th"        } if field_order.push("grade_11th")
            structure_hash["fields"]["grade_12th"           ] = {"data_type"=>"bool", "file_field"=>"grade_12th"        } if field_order.push("grade_12th")
            structure_hash["fields"]["pasa_included"        ] = {"data_type"=>"bool", "file_field"=>"pasa_included"     } if field_order.push("pasa_included")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end