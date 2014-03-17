#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ISP_REIMBURSEMENT_STATUS < Athena_Table
    
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

    def after_insert(row_obj)
        
        student_id      = field_value("student_id", "WHERE primary_id = '#{row_obj.primary_id}'")
        family_id       = $students.get(student_id).familyid.value
        
        related_sids    = $tables.attach("STUDENT").field_values("student_id", "WHERE familyid = '#{family_id}'")
        related_sids.each{|sid|
            
            student = $students.get(sid)
            if !student.isp_reimbursement_status.existing_record
                
                new_row = student.isp_reimbursement_status.new_record
                row_obj.fields.each_pair do |k,v|
                    new_row.fields[k] = v if v
                end
                new_row.save
                
            end
            
        } if related_sids
        
    end

    def after_change_field(field_obj)
        
        unless caller.to_s.match(/student_isp_reimbursement_status(.*?)after_change_field/)
            
            student_id      = field_value("student_id", "WHERE primary_id = '#{field_obj.primary_id}'")
            family_id       = $students.get(student_id).familyid.value
            
            related_sids    = $tables.attach("STUDENT").field_values("student_id", "WHERE familyid = '#{family_id}'")
            related_sids.each{|sid|
                
                student = $students.get(sid)
                student.isp_reimbursement_status.existing_record || student.isp_reimbursement_status.new_record.save
                
                student.isp_reimbursement_status.send(field_obj.field_name).set(field_obj.value).save unless field_obj.field_name.match(/student_id|primary_id|created_date|created_by/)
                
            } if related_sids
            
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
                :load_type          => :append,
                :keys               => ["student_id"],
                :update             => true,
                "name"              => "student_isp_reimbursement_status",
                "file_name"         => "student_isp_reimbursement_status.csv",
                "file_location"     => "student_isp_reimbursement_status",
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
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",                "file_field"=>"student_id"                      } if field_order.push("student_id"                      )
            structure_hash["fields"]["fall_approval_status"     ] = {"data_type"=>"text",               "file_field"=>"fall_approval_status"            } if field_order.push("fall_approval_status"            )
            structure_hash["fields"]["fall_request_method"      ] = {"data_type"=>"text",               "file_field"=>"fall_request_method"             } if field_order.push("fall_request_method"             )
            structure_hash["fields"]["fall_notes"               ] = {"data_type"=>"text",               "file_field"=>"fall_notes"                      } if field_order.push("fall_notes"                      )
            structure_hash["fields"]["fall_req_contact"         ] = {"data_type"=>"bool",               "file_field"=>"fall_req_contact"                } if field_order.push("fall_req_contact"                )
            structure_hash["fields"]["fall_req_address"         ] = {"data_type"=>"bool",               "file_field"=>"fall_req_address"                } if field_order.push("fall_req_address"                )
            structure_hash["fields"]["fall_req_amount"          ] = {"data_type"=>"bool",               "file_field"=>"fall_req_amount"                 } if field_order.push("fall_req_amount"                 )
            structure_hash["fields"]["fall_req_billed_monthly"  ] = {"data_type"=>"decimal(15,2)",      "file_field"=>"fall_req_billed_monthly"         } if field_order.push("fall_req_billed_monthly"         )
            structure_hash["fields"]["fall_req_timeperiod"      ] = {"data_type"=>"bool",               "file_field"=>"fall_req_timeperiod"             } if field_order.push("fall_req_timeperiod"             )
            structure_hash["fields"]["fall_check_amount"        ] = {"data_type"=>"decimal(15,2)",      "file_field"=>"fall_check_amount"               } if field_order.push("fall_check_amount"               )
            structure_hash["fields"]["fall_run"                 ] = {"data_type"=>"datetime",           "file_field"=>"fall_run"                        } if field_order.push("fall_run"                        )
            structure_hash["fields"]["spring_approval_status"   ] = {"data_type"=>"text",               "file_field"=>"spring_approval_status"          } if field_order.push("spring_approval_status"          )
            structure_hash["fields"]["spring_request_method"    ] = {"data_type"=>"text",               "file_field"=>"spring_request_method"           } if field_order.push("spring_request_method"           )
            structure_hash["fields"]["spring_notes"             ] = {"data_type"=>"text",               "file_field"=>"spring_notes"                    } if field_order.push("spring_notes"                    )
            structure_hash["fields"]["spring_req_contact"       ] = {"data_type"=>"bool",               "file_field"=>"spring_req_contact"              } if field_order.push("spring_req_contact"              )
            structure_hash["fields"]["spring_req_address"       ] = {"data_type"=>"bool",               "file_field"=>"spring_req_address"              } if field_order.push("spring_req_address"              )
            structure_hash["fields"]["spring_req_amount"        ] = {"data_type"=>"bool",               "file_field"=>"spring_req_amount"               } if field_order.push("spring_req_amount"               )
            structure_hash["fields"]["spring_req_billed_monthly"] = {"data_type"=>"decimal(15,2)",      "file_field"=>"spring_req_billed_monthly"       } if field_order.push("spring_req_billed_monthly"       )
            structure_hash["fields"]["spring_req_timeperiod"    ] = {"data_type"=>"bool",               "file_field"=>"spring_req_timeperiod"           } if field_order.push("spring_req_timeperiod"           )
            structure_hash["fields"]["spring_check_amount"      ] = {"data_type"=>"decimal(15,2)",      "file_field"=>"spring_check_amount"             } if field_order.push("spring_check_amount"             )
            structure_hash["fields"]["spring_run"               ] = {"data_type"=>"datetime",           "file_field"=>"spring_run"                      } if field_order.push("spring_run"                      )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end