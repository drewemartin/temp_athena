#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_AIMS_TEST_RESULTS < Athena_Table
    
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

    def after_load_aims_test_results
        
        pids = $tables.attach("AIMS_TEST_RESULTS").primary_ids#("WHERE primary_id = 31")
        pids.each{|pid|
            
            record  = $tables.attach("AIMS_TEST_RESULTS").by_primary_id(pid)
            student = $students.get(record.fields["student_id"].value)
            
            if student
                
                gom = record.fields["gom"].value.downcase.gsub("-","_")
                
                student_record = record("WHERE student_id = #{student.student_id.value} AND gom = '#{gom}'")
                if !student_record
                    student_record = student.aims_test_results.new_record
                    student_record.fields["gom"].value = gom
                    student_record.save
                end
                
                student_record.fields["fall_correct"     ].value = record.fields["fall_correct"     ].value
                student_record.fields["fall_error"       ].value = record.fields["fall_error"       ].value
                
                aims_percentile = record.fields["fall_percentile"  ].value
                student_record.fields["fall_percentile"  ].value = aims_percentile ? aims_percentile.to_f/100 : (percentile(:test_record=> record, :test_period=> "fall"     ) || nil )
                
                student_record.fields["winter_correct"   ].value = record.fields["winter_correct"   ].value
                student_record.fields["winter_error"     ].value = record.fields["winter_error"     ].value
                
                aims_percentile = record.fields["winter_percentile"  ].value
                student_record.fields["winter_percentile"].value = aims_percentile ? aims_percentile.to_f/100 : (percentile(:test_record=> record, :test_period=> "winter"   ) || nil )
                
                student_record.fields["spring_correct"   ].value = record.fields["spring_correct"   ].value
                student_record.fields["spring_error"     ].value = record.fields["spring_error"     ].value
                
                aims_percentile = record.fields["spring_percentile"  ].value
                student_record.fields["spring_percentile"].value = aims_percentile ? aims_percentile.to_f/100 : (percentile(:test_record=> record, :test_period=> "spring"   ) || nil )
                
                student_record.fields["winter_roi"       ].value = roi(      :test_record=> student_record, :test_period=> "winter")
                student_record.fields["winter_growth"    ].value = growth(   :test_record=> student_record, :test_period=> "winter")
                student_record.fields["spring_roi"       ].value = roi(      :test_record=> student_record, :test_period=> "spring")
                student_record.fields["spring_growth"    ].value = growth(   :test_record=> student_record, :test_period=> "spring")
                
                student_record.save
                
            end
            
        }
        
        update_student_growth_overall
        
    end
    
    def growth(a = {})
    #    :test_record    => nil,
    #    :test_period    => nil
    #)
        
        fall_percentile                 = a[:test_record].fields["fall_percentile"                  ].value
        second_test_period_percentile   = a[:test_record].fields["#{a[:test_period]}_percentile"    ].value
        
        tries = 1
        begin
            
            if fall_percentile && second_test_period_percentile
                
                if fall_percentile == second_test_period_percentile  
                    return true
                    
                elsif fall_percentile.to_f < second_test_period_percentile.to_f  
                    return true
                    
                else
                    
                    a[:percentile_attainable] = fall_percentile
                    
                    if !percentile(a)
                        
                        a[:percentile_attainable] = false
                        a[:percentile_reduction ] = fall_percentile
                        fall_percentile           = percentile(a)
                        raise "This percentile was not attainable"
                        
                    else
                        return false
                    end
                    
                end
                
            else
                
                return nil
                
            end
            
        rescue
            
            if tries <= 5
                tries+=1
                retry
            else
                return false
            end
            
        end
        
    end
    
    def percentile(a = {})
    #    :test_record    => nil,
    #    :test_period    => nil
    #)
        ap_db = $tables.attach("aims_percentile").data_base
        if (score = a[:test_record].fields["#{a[:test_period]}_correct"].value) && rows = $db.get_data(
            
            "SELECT
                score,
                percentile
                
            FROM #{ap_db}.aims_percentile
            WHERE gom       = '#{a[:test_record].fields["gom"].value                                             }'
            AND grade       = '#{$students.get(a[:test_record].fields["student_id"].value).grade.to_grade_int    }' 
            AND test_period = '#{a[:test_period ]                                                                }'
            #{a[:percentile_attainable] ? "AND percentile >= '#{a[:percentile_attainable]}'" : nil               }
            #{a[:percentile_reduction ] ? "AND percentile < '#{a[:percentile_reduction ]}'"  : nil               }
            AND score IS NOT NULL
            ORDER BY score ASC"
            
        )
            
            return true         if a[:percentile_attainable]
            return rows[-1][1]  if a[:percentile_reduction ]
            
            this_score      = rows[0][0]
            this_percentile = rows[0][1]
            
            rows.each{|row|
                
                if score.to_f >= row[0].to_f
                    this_score      = row[0]
                    this_percentile = row[1]
                end
                
            }
            
            return this_percentile
            
        else
            return false
        end
        
    end
    
    def roi(a = {})
    #    :test_record    => nil,
    #    :test_period    => nil
    #)
        
        first_score  = a[:test_record].fields["fall_correct" ].value
        
        if a[:test_period   ] == "winter"
            
            weeks        = 18.0
            second_score = a[:test_record].fields["winter_correct" ].value
            
        elsif a[:test_period] == "spring"
            
            weeks = 36.0
            second_score = a[:test_record].fields["spring_correct" ].value
            
        end
        
        if first_score && second_score
            
            return (second_score.to_f-first_score.to_f)/weeks
            
        else
            return nil
        end
        
    end
    
    def update_student_growth_overall
        
        student_ids("WHERE student_id IS NOT NULL").each{|sid|
            
            student = $students.get(sid)
            if student
                
                student.aims_growth.existing_record || student.aims_growth.new_record.save
                
                ["winter","spring"].each{|season|
                    
                    if $db.get_data_single("SELECT
                            student_id
                        FROM #{data_base}.student_aims_test_results
                        WHERE #{season}_growth IS NOT NULL
                        AND student_id = #{sid}"
                    )
                        
                        results = $db.get_data_single(
                            "SELECT
                                (SELECT
                                    COUNT(student_id)
                                FROM #{data_base}.student_aims_test_results
                                WHERE #{season}_growth IS TRUE
                                AND student_id = #{sid})/
                                (SELECT
                                    COUNT(student_id)
                                FROM #{data_base}.student_aims_test_results
                                WHERE #{season}_growth IS NOT NULL
                                AND student_id = #{sid})"
                        )
                        
                        student.aims_growth.send("#{season}_growth_overall").set(results[0].to_f).save
                        
                    else
                        student.aims_growth.send("#{season}_growth_overall").set(nil).save
                    end  
                    
                }
                
            end
            
        }
        
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
                "name"              => "student_aims_test_results",
                "file_name"         => "student_aims_test_results.csv",
                "file_location"     => "student_aims_test_results",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true,
                :relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["student_id"       ] = {"data_type"=>"int",            "file_field"=>"student_id"       } if field_order.push("student_id"          )
            structure_hash["fields"]["gom"              ] = {"data_type"=>"text",           "file_field"=>"gom"              } if field_order.push("gom"                 )
            
            structure_hash["fields"]["fall_correct"     ] = {"data_type"=>"int",            "file_field"=>"fall_correct"     } if field_order.push("fall_correct"        )
            structure_hash["fields"]["fall_error"       ] = {"data_type"=>"int",            "file_field"=>"fall_error"       } if field_order.push("fall_error"          )
            structure_hash["fields"]["fall_percentile"  ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"fall_percentile"  } if field_order.push("fall_percentile"     )
            
            structure_hash["fields"]["winter_correct"   ] = {"data_type"=>"int",            "file_field"=>"winter_correct"   } if field_order.push("winter_correct"      )
            structure_hash["fields"]["winter_error"     ] = {"data_type"=>"int",            "file_field"=>"winter_error"     } if field_order.push("winter_error"        )
            structure_hash["fields"]["winter_percentile"] = {"data_type"=>"decimal(5,4)",   "file_field"=>"winter_percentile"} if field_order.push("winter_percentile"   )
            
            structure_hash["fields"]["spring_correct"   ] = {"data_type"=>"int",            "file_field"=>"spring_correct"   } if field_order.push("spring_correct"      )
            structure_hash["fields"]["spring_error"     ] = {"data_type"=>"int",            "file_field"=>"spring_error"     } if field_order.push("spring_error"        )
            structure_hash["fields"]["spring_percentile"] = {"data_type"=>"decimal(5,4)",   "file_field"=>"spring_percentile"} if field_order.push("spring_percentile"   )
            
            structure_hash["fields"]["winter_roi"       ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"winter_roi"       } if field_order.push("winter_roi"          )
            structure_hash["fields"]["winter_growth"    ] = {"data_type"=>"bool",           "file_field"=>"winter_growth"    } if field_order.push("winter_growth"       )
            structure_hash["fields"]["spring_roi"       ] = {"data_type"=>"decimal(5,4)",   "file_field"=>"spring_roi"       } if field_order.push("spring_roi"          )
            structure_hash["fields"]["spring_growth"    ] = {"data_type"=>"bool",           "file_field"=>"spring_growth"    } if field_order.push("spring_growth"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end