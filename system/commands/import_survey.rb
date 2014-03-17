#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Import_Survey < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    
    ##DO NOT DELETE!!!
    puts start = Time.new
    #############################################################
    
    ilp_cat_id  = $tables.attach("ILP_ENTRY_CATEGORY").field_value( "primary_id", "WHERE name = 'Student Information Survey'")
    ilp_type_id = $tables.attach("ILP_ENTRY_TYPE").field_value(     "primary_id", "WHERE category_id = '#{ilp_cat_id}' AND name = 'Previous School Experience'")
    sids = $students.list(:currently_enrolled=>true)
    sids.each{|sid|
      
      student = $students.get(sid)
      
      if ilp_record = student.ilp.existing_records(
        "WHERE ilp_entry_category_id  = '#{ilp_cat_id   }'
        AND ilp_entry_type_id         = '#{ilp_type_id  }'"
      )
        
        field_value = student.previousschooltype.value
        ilp_record[0].fields["description"].set(field_value).save
        
      end
      
    } if sids
    
    ilp_cat_id      = $tables.attach("ILP_ENTRY_CATEGORY").field_value("primary_id", "WHERE name = 'Student Information Survey'")
    skip            = true
    csv_field_names = nil
    CSV.foreach("#{$paths.imports_path}survey.csv")do|row|
      
      if skip
        
        csv_field_names = Array.new
        
        row.each{|field|
          csv_field_names.push(field)
        }
        
        skip = false
        
      else
        
        sid = row[0].chomp if row[0]
        
        if student = $students.get(sid)
          
          i = 0
          row.each{|field_value|
            
            if ilp_type_id = $tables.attach("ILP_ENTRY_TYPE").field_value(
              
              "primary_id",
              
              "WHERE category_id = '#{ilp_cat_id}'
              AND name = '#{csv_field_names[i]}'"
              
            )
              
              verify_required_types_exist(sid, ilp_cat_id)
              
              if ilp_record = student.ilp.existing_records(
                "WHERE ilp_entry_category_id  = '#{ilp_cat_id   }'
                AND ilp_entry_type_id         = '#{ilp_type_id  }'
                AND description IS NULL"
              )
               
                ilp_record[0].fields["description"].set(field_value).save
                
              end
              
            end
            
            i+=1
            
          }
          
        end
        
      end
      
    end
    
    puts "#{(Time.new - start)/60} minutes"
    
  end
  #---------------------------------------------------------------------------

  def verify_required_types_exist(sid, category_id)
    
    student = $students.get(sid)
    
    missing_entries = $tables.attach("ILP_ENTRY_TYPE").primary_ids(
        "LEFT JOIN student_ilp ON student_ilp.ilp_entry_type_id = ilp_entry_type.primary_id
            AND student_ilp.student_id = '#{student.student_id.value}'
        WHERE category_id = '#{category_id}'
            AND student_ilp.ilp_entry_type_id IS NULL
            AND ILP_ENTRY_TYPE.required IS TRUE"
    )
    
    if missing_entries
        
        $base.created_by = "Athena-SIS"
        
        missing_entries.each{|type_id|
            
            ilp_type_record = $tables.attach("ILP_ENTRY_TYPE").by_primary_id(type_id)
            
            student_ilp_record = student.ilp.new_record
            student_ilp_record.fields["ilp_entry_category_id"   ].set(category_id   )
            student_ilp_record.fields["ilp_entry_type_id"       ].set(type_id       )
            student_ilp_record.fields["description"             ].set(ilp_type_record.fields["default_description" ].value       )
            student_ilp_record.fields["solution"                ].set(ilp_type_record.fields["default_solution"    ].value       )
            student_ilp_record.save
            
        }
        
        $base.created_by = nil
        
    end
    
  end

end

Import_Survey.new(ARGV)