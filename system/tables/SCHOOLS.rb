#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SCHOOLS < Athena_Table
    
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
    
    def after_insert(record_object)#Need to check to see if there are any existing schools in student_previous_school table that match this new school and mark them as verified.
        
        pids = $tables.attach("STUDENT_PREVIOUS_SCHOOL").primary_ids(
            "WHERE  previous_school     = \"#{record_object.fields["school_name" ].value}\"
            AND     previous_district   = \"#{record_object.fields["district"    ].value}\""
        )
        
        pids.each{|pid|
            
            this_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_primary_id(pid)
            this_record.fields["verified"].set(true).save
            
        } if pids
        
    end
    
    def after_change_field_district(field_object)
        
        this_record = by_primary_id(field_object.primary_id)
        
        old_value = $db.get_data_single(
            
            "SELECT
                district
            FROM #{data_base}.zz_schools
            WHERE modified_pid = '#{field_object.primary_id}'
            ORDER BY modified_date DESC"
            
        )[0]
        
        #CHANGE STATUS OF SCHOOLS THAT WERE PREVIOUSLY VERIFIED TO THE OLD VALUE TO FALSE
        if pids = $tables.attach("STUDENT_PREVIOUS_SCHOOL").primary_ids(
            
            "WHERE  previous_school     = \"#{this_record.fields["school_name"].value}\"
            AND     previous_district   = \"#{old_value}\""
            
        )
            
            pids.each{|pid|
                
                prevsch_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_primary_id(pid)
                prevsch_record.fields["verified"].set(false).save
                
            }
            
        end
        
        #CHANGE STATUS OF SCHOOLS THAT CURRENTLY VERIFY TO THE NEW VALUE TO TRUE
        if pids = $tables.attach("STUDENT_PREVIOUS_SCHOOL").primary_ids(
            
            "WHERE  previous_school     = \"#{field_object.value}\"
            AND     previous_district   = \"#{this_record.fields["district"].value}\""
            
        )
            
            pids.each{|pid|
                
                prevsch_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_primary_id(pid)
                prevsch_record.fields["verified"].set(true).save
                
            }
            
        end
        
    end

    def after_change_field_school_name(field_object)#need to check to see if there are any schools in student_previous school that are no longer verified since the change (search for schools that match the previous value per audit trail)
        
        this_record = by_primary_id(field_object.primary_id)
        
        old_value = $db.get_data_single(
            
            "SELECT
                school_name
            FROM #{data_base}.zz_schools
            WHERE modified_pid = '#{field_object.primary_id}'
            ORDER BY modified_date DESC"
            
        )[0]
        
        #CHANGE STATUS OF SCHOOLS THAT WERE PREVIOUSLY VERIFIED TO THE OLD VALUE TO FALSE
        if pids = $tables.attach("STUDENT_PREVIOUS_SCHOOL").primary_ids(
            
            "WHERE  previous_school     = \"#{old_value}\"
            AND     previous_district   = \"#{this_record.fields["district"].value}\""
            
        )
            
            pids.each{|pid|
                
                prevsch_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_primary_id(pid)
                prevsch_record.fields["verified"].set(false).save
                
            }
            
        end
        
        #CHANGE STATUS OF SCHOOLS THAT CURRENTLY VERIFY TO THE NEW VALUE TO TRUE
        if pids = $tables.attach("STUDENT_PREVIOUS_SCHOOL").primary_ids(
            
            "WHERE  previous_school     = \"#{field_object.value}\"
            AND     previous_district   = \"#{this_record.fields["district"].value}\""
            
        )
            
            pids.each{|pid|
                
                prevsch_record = $tables.attach("STUDENT_PREVIOUS_SCHOOL").by_primary_id(pid)
                prevsch_record.fields["verified"].set(true).save
                
            }
            
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
                "name"              => "schools",
                "file_name"         => "schools.csv",
                "file_location"     => "schools",
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
            
            structure_hash["fields"]["school_name"      ] = {"data_type"=>"text", "file_field"=>"School Name"   } if field_order.push("school_name"     )
            structure_hash["fields"]["district"         ] = {"data_type"=>"text", "file_field"=>"District"      } if field_order.push("district"        )
            structure_hash["fields"]["county_name"      ] = {"data_type"=>"text", "file_field"=>"County Name"   } if field_order.push("county_name"     )
            structure_hash["fields"]["street_address"   ] = {"data_type"=>"text", "file_field"=>"Street Address"} if field_order.push("street_address"  )
            structure_hash["fields"]["city"             ] = {"data_type"=>"text", "file_field"=>"City"          } if field_order.push("city"            )
            structure_hash["fields"]["state"            ] = {"data_type"=>"text", "file_field"=>"State"         } if field_order.push("state"           )
            structure_hash["fields"]["zip"              ] = {"data_type"=>"text", "file_field"=>"ZIP"           } if field_order.push("zip"             )
            structure_hash["fields"]["zip_ext"          ] = {"data_type"=>"text", "file_field"=>"ZIP 4-digit"   } if field_order.push("zip_ext"         )
            structure_hash["fields"]["phone"            ] = {"data_type"=>"text", "file_field"=>"Phone"         } if field_order.push("phone"           )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end