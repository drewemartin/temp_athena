#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

##
class Redo_Student_Sales_Force_Case < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize
    super()
    
    load_all_sales_force_case_reports
    
  end
  #---------------------------------------------------------------------------
  
  def load_all_sales_force_case_reports
    puts Time.now
    student_sales_force_case = $tables.attach("STUDENT_SALES_FORCE_CASE")
    folder = "C:/student_sales_force_case/"
    
    file_num = 0
    num_loaded = 0
    failures = 0
    failed_files = Array.new
    if File.directory? folder
      Dir.entries(folder).each do |file|
        unless [".",".."].include? file
          file_num += 1
          
          puts
          puts "Beginning file: #{file}"
          puts Time.now
          puts
          
          FileUtils.cp "#{folder}#{file}", "#{$paths.imports_path}student_sales_force_case.csv"
          begin
            puts "Loading file ##{file_num}"
            puts Time.now
            puts
            loaded = student_sales_force_case.load
            
            puts "File ##{file_num} loaded successfully"
            puts Time.now
          rescue => e
            puts "Error loading file number #{file_num} into table, file name #{file}"
            puts "ERROR: #{e.message}"
            puts "BACKTRACE: #{e.backtrace}"
            puts Time.now
            
            failures += 1
            failed_files << file
            
            puts
            puts "Hit any key to proceed"
            $stdin.gets
            next
          end
          
          if loaded
            num_loaded += 1
          else
            puts "Unknown load failure on file number #{file_num}, file name #{file}"
            puts "Variable loaded = #{loaded.to_s}"
            failures += 1
            failed_files << file
            
            puts
            puts "Hit any key to proceed"
            $stdin.gets
          end
          sleep 1 ##sleep for 1 second in between loads to make sure the imported files get unique timestamps and don't overwrite each other
        end
      end
    end
    
    puts
    puts "#{file_num} files processed, #{num_loaded} successfully loaded, #{failures} load failures"
    puts Time.now
    puts
    puts "#{failed_files.length} failed files:" unless failed_files.length == 0
    failed_files.each_with_index do |failure, i|
      puts "##{i+1}: #{failure.to_s}"
    end
  end
  
end

Redo_Student_Sales_Force_Case.new