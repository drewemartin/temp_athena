#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class Fix_ILP_pdf_printouts < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize
    super()
    
    #enter_pdf_order_for_class_roster_ilps
    #remove_bad_ilp_entries
    #convert_aims_test_fields
    update_student_ilp
    
    
  end
  #---------------------------------------------------------------------------
  
  def remove_bad_ilp_entries
    #Remove all entries from student_ilp that come from
    #student_aims_tests.math_instructional_recommendation,
    #which is actually currently storing other information.
    puts "Removing bad ILP entries"
    puts Time.now
    puts
    
    table = $tables.attach("STUDENT_ILP")
    table_name = table.table_name
    db_name = table.data_base
    
    $db.get_data("DELETE FROM `#{db_name}`.`#{table_name}`
                 WHERE `#{table_name}`.`ilp_entry_category_id` = '4'
                 AND `#{table_name}`.`ilp_entry_type_id` = '22'",db_name)
    
    puts "Bad ILP entries removed"
    puts Time.now
    puts
  end
  
  def convert_aims_test_fields
    puts "Beginning AIMS test field conversion"
    puts Time.now
    puts
    
    table = $tables.attach("STUDENT_AIMS_TESTS")
    table_name = table.table_name
    db_name = table.data_base
    
    #Changing the data in the db to reflect the terminology being used for the current school year
    #This allows data fixing for end user display to be eliminated in web and report scripts
    $db.get_data("UPDATE `#{db_name}`.`#{table_name}`
                 SET `#{table_name}`.`reading_instructional_recommendation` = 'Benchmark'
                   WHERE reading_instructional_recommendation = 'Student Read'",db_name)
    $db.get_data("UPDATE `#{db_name}`.`#{table_name}`
                 SET `#{table_name}`.`reading_instructional_recommendation` = 'Strategic'
                   WHERE reading_instructional_recommendation = 'Teacher Read'",db_name)
    $db.get_data("UPDATE `#{db_name}`.`#{table_name}`
                 SET `#{table_name}`.`notes` = 'Benchmark'
                   WHERE notes = 'Student Read'",db_name)
    $db.get_data("UPDATE `#{db_name}`.`#{table_name}`
                 SET `#{table_name}`.`notes` = 'Strategic'
                   WHERE notes = 'Teacher Read'",db_name)
    
    puts "Completed AIMS test field conversion"
    puts Time.now
    puts
  end
  
  def update_student_ilp
    #This will overwrite the Student Read/Teacher Read problem for student_ilp records
    #that contain this information with the new terminology (Benchmark/Strategic) also.
    
    puts "Beginning student ILP update"
    puts Time.now
    
    sids = $tables.attach("STUDENT_AIMS_TESTS").student_ids
    i = 0
    
    sids.each do |sid|
      student = $students.get(sid)
      records = student.aims_tests.existing_records
      grade = student.grade.value ? student.grade.value : "Unknown"
      
      #Update the unused grade field to trigger the after_change event that will
      #create the necessary student_ilp records
      records.each do |record|
        record.fields["grade"].value = grade 
        record.save
        i+=1
      end
      
      if (i % 10 == 0) && (i % 100 != 0)
        print ".   "
      end
      
      if (i % 100 == 0)
        puts
        puts "#{i} AIMS records updated"
        puts Time.now
      end  
    end
    
    puts
    puts "Completed student ILP update"
    puts "#{i} records updated"
    puts Time.now
    puts  
  end
  
  def enter_pdf_order_for_class_roster_ilps
    #Assign a value from the ilp_entry_type table to the student_ilp.pdf_order column
    #to have more control over how class rosters are displayed in the pdf print out
    
    puts "Beginning pdf order update for class roster ILPs"
    puts Time.now
    puts
    
    ilp_entry_type_table = $tables.attach("ILP_ENTRY_TYPE")
    student_ilp_table = $tables.attach("STUDENT_ILP")
    
    type_table_name = ilp_entry_type_table.table_name
    s_ilp_table_name = student_ilp_table.table_name
    s_ilp_db = student_ilp_table.data_base
    
    category_ids = ["1","2","3"]
    
    category_ids.each do |cat_id|
      type_ids = ilp_entry_type_table.primary_ids("WHERE `#{type_table_name}`.`category_id` = '#{cat_id}'")
      #puts type_ids.length
      
      type_ids.each do |type_id|
        type_pdf_order = ilp_entry_type_table.field_value("pdf_order","WHERE PRIMARY_ID = #{type_id} AND category_id = #{cat_id}")
        records = student_ilp_table.primary_ids("WHERE `#{s_ilp_table_name}`.`ilp_entry_category_id` = '#{cat_id}'
                                                AND `#{s_ilp_table_name}`.`ilp_entry_type_id` = '#{type_id}'")
        num_affected_records = records ? records.length.to_s : "0"
        $db.get_data("UPDATE `#{s_ilp_db}`.`#{s_ilp_table_name}`
                      SET `#{s_ilp_table_name}`.`pdf_order` = '#{type_pdf_order}'
                      WHERE `#{s_ilp_table_name}`.`ilp_entry_category_id` = '#{cat_id}'
                      AND `#{s_ilp_table_name}`.`ilp_entry_type_id` = '#{type_id}'",s_ilp_db)
        puts "Category ID: #{cat_id}, Type ID: #{type_id}, #{num_affected_records} records"
        puts Time.now
        puts
      end
    end
    
    puts "Completed pdf order update for class roster ILPs"
    puts Time.now
    puts
    
  end
end

Fix_ILP_pdf_printouts.new