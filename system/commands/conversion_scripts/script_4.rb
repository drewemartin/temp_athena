#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands/conversion_scripts","base")}/base"

class SCRIPT_4 < Base
    
    #---------------------------------------------------------------------------
    def initialize
        super()
        
        aims_percentile_load
        student_aims_test_results_load
        after_load_scantron_extended
        student_attendance_official_code
        team_evaluation_summary_snapshot
        
    end
    #---------------------------------------------------------------------------
    
    def aims_percentile_load
        puts "#POPULATE TABLE: aims_percentile FUNCTION: load"
        
        FileUtils.cp(
            "#{$paths.conversion_path}aims_percentile.csv",
            "#{$paths.imports_path}aims_percentile.csv"
        )
        $tables.attach("AIMS_PERCENTILE").load
    end
    
    def student_aims_test_results_load
        
        puts "#POPULATE TABLE: student_aims_test_results FUNCTION: load"
        
        FileUtils.cp(
            "#{$paths.conversion_path}student_aims_test_results.csv",
            "#{$paths.imports_path}student_aims_test_results.csv"
        )
        $tables.attach("STUDENT_AIMS_TEST_RESULTS").load
        
    end
    
    def after_load_scantron_extended
        
        puts "#POPULATE TABLE: student_scantron_performance_level FUNCTION: after_load_scantron_performance_extended"
        
        $tables.attach("STUDENT_SCANTRON_PERFORMANCE_LEVEL").after_load_scantron_performance_extended
        
    end
    
    def student_attendance_official_code
        
        puts "#POPULATE TABLE: student_attendance FIELD: official_code"
        
        sql_str = "INSERT INTO student_attendance_master ( student_id,"
        
        #INSERT ALL ATTENDANCE MASTER STUDENTS INTO STUDENT ATTENDANCE MASTER
        school_days = $base.school_days
        school_days.each{|date|
          sql_str << "`code_#{date}`"
          sql_str << "," unless date == school_days[-1]
        }
        
        sql_str << ") SELECT student_id,"
        school_days.each{|date|
          sql_str << "`#{date}`"
          sql_str << "," unless date == school_days[-1]
        }
        sql_str << " FROM attendance_master"
        
        $db.query(sql_str)
        
        $tables.attach("STUDENT_ATTENDANCE").primary_ids.each{|pid|
          
            sid           = $db.get_data_single("SELECT student_id    FROM student_attendance WHERE primary_id = '#{pid}'")[0]
            date          = $db.get_data_single("SELECT date          FROM student_attendance WHERE primary_id = '#{pid}'")[0]
            
            code          = $db.get_data_single("SELECT code          FROM student_attendance WHERE primary_id = '#{pid}'")[0]
            official_code = $db.get_data_single("SELECT official_code FROM student_attendance WHERE primary_id = '#{pid}'")[0]
            
            #UPDATE STUDENT_ATTENDANCE
            update_sql =
            "UPDATE student_attendance
            SET official_code = (
                SELECT `#{date}`
                FROM attendance_master
                WHERE student_id = #{sid})
            WHERE primary_id = #{pid}"
            
            $db.query(update_sql)
            
            #UPDATE STUDENT_ATTENDANCE_MASTER
            update_sql =
            "UPDATE student_attendance_master
                SET `activity_#{date}` = '#{code}', `code_#{date}` = '#{official_code}'  
            WHERE student_id = #{sid}"
            
            $db.query(update_sql)
          
        }
       
    end
    
    def team_evaluation_summary_snapshot
        
        puts "#RUN team_evaluation_summary_snapshot"
        
        Dir["#{$paths.tables_path}team_evaluation*.rb"].each{|table_name|
            
            if table_name.match(/snapshot/i)
              $tables.attach(table_name.split("/")[-1].gsub(".rb","").upcase).truncate
            end
            
        }
        $tables.attach("DEPARTMENT_EVALUATION_SUMMARY_SNAPSHOT").truncate
        $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").truncate
        $tables.attach("team_evaluation_summary_snapshot").before_load_team_evaluation_summary_snapshot
        
    end
    
end