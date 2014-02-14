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

    #CREATE A DAILY REPORT THAT INCLUDES ALL UNVERIFIED SCHOOLS
    def after_load_k12_enrollment_info_tab_v2
        
        rows = Array.new
        
        rows.push(
            
            headers = [
                "Student ID",
                "Previous School",
                "Previous District",
                "Previous School State"
            ]
            
        )
        
        sql_str =
            "SELECT
                k12_enrollment_info_tab_v2.student_id,
                student_previous_school.previous_school,
                student_previous_school.previous_district,
                student_previous_school.previous_school_state
            FROM        #{$tables.attach("K12_ENROLLMENT_INFO_TAB_V2").data_base}.k12_enrollment_info_tab_v2
            LEFT JOIN   #{data_base}.student_previous_school ON student_previous_school.student_id = k12_enrollment_info_tab_v2.student_id
            WHERE student_previous_school.verified IS FALSE"
        
        results = $db.get_data(sql_str)
        
        rows.push(results) if results
        
        file_path = $reports.save_document({:csv_rows=>results.insert(0, headers), :category_name=>"Validation", :type_name=>"previous_school_verification"})
        
        $team.find(:email_address => "smcdonnell@agora.org").send_email(
            
            :subject                => "Previous School Verification - #{$idate}",
            :content                => "Previous School Verification - #{$idate}",
            :attachment_name        => "previous_school_verification_#{$ifilestamp}.csv",
            :attachment_path        => file_path,
            :additional_recipients  => nil
            
        )
        
    end
    
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
        
        if $tables.attach("SCHOOLS").field_value(
            
            "school_name",
            
            "WHERE  school_name = '#{Mysql.quote(this_record.fields["previous_school"       ].value || '')}'
            AND     district    = '#{Mysql.quote(this_record.fields["previous_district"     ].value || '')}'
            AND     state       = '#{Mysql.quote(this_record.fields["previous_school_state" ].value || '')}'"
            
        )
            
            this_record.fields["verified"].set(true  ).save
            
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
            
            structure_hash["fields"]["student_id"               ] = {"data_type"=>"int",  "file_field"=>"student_id"            } if field_order.push("student_id"              )
            structure_hash["fields"]["previous_school"          ] = {"data_type"=>"text", "file_field"=>"previous_school"       } if field_order.push("previous_school"         )
            structure_hash["fields"]["previous_district"        ] = {"data_type"=>"text", "file_field"=>"previous_district"     } if field_order.push("previous_district"       )
            structure_hash["fields"]["previous_school_state"    ] = {"data_type"=>"text", "file_field"=>"previous_school_state" } if field_order.push("previous_school_state"   )
            structure_hash["fields"]["verified"                 ] = {"data_type"=>"bool", "file_field"=>"verified"              } if field_order.push("verified"                )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end