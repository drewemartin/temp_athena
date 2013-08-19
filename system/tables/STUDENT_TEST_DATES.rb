#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_TEST_DATES < Athena_Table
    
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
    
    def by_studentid_old(sid, date = nil, test_event_site_id = nil, after_attendance_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=", sid                    ) )
        params.push( Struct::WHERE_PARAMS.new("date",               "=", date                   ) ) if date
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=", test_event_site_id     ) ) if test_event_site_id
        params.push( Struct::WHERE_PARAMS.new("date",               ">", after_attendance_date  ) ) if after_attendance_date
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_studentid_siteid(sid, date = nil, test_event_site_id = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",         "=", sid                    ) )
        params.push( Struct::WHERE_PARAMS.new("date",               "=", date                   ) ) if date
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=", test_event_site_id     ) ) if test_event_site_id
        where_clause = $db.where_clause(params)
        if date && test_event_site_id
            
            record(where_clause)
            
        else
            
            records(where_clause)
            
        end
        
    end
    
    def pids_by_sid_test_event_site_id(student_id, test_event_site_id)
        $db.get_data_single(
            "SELECT
                primary_id
            FROM #{table_name}
            WHERE student_id        = '#{student_id}'
            AND test_event_site_id  = '#{test_event_site_id}'
            GROUP BY date
            ORDER BY date ASC"
        )
    end
    
    def sids_by_test_event_site_id(test_event_site_id)
        $db.get_data_single(
            "SELECT
                #{table_name}.student_id
            FROM #{table_name}
            LEFT JOIN student ON student.student_id = #{table_name}.student_id
            WHERE test_event_site_id = '#{test_event_site_id}'
            GROUP BY #{table_name}.student_id
            ORDER BY student.studentlastname ASC"
        )
    end
    
    def test_event_site_dates(test_event_site_id)
        $db.get_data_single(
            "SELECT date
            FROM #{table_name}
            WHERE test_event_site_id = '#{test_event_site_id}'
            GROUP BY date
            ORDER BY date ASC"
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def aft_load
        
        #after_load_k12_omnibus
        
        pids = $db.query(
            "SELECT student_tests.primary_id
             FROM student_tests, test_event_sites
             WHERE student_tests.test_event_site_id = test_event_sites.primary_id
             AND student_tests.completed IS NOT NULL
             AND curdate( )
             BETWEEN test_event_sites.start_date
             AND test_event_sites.end_date"
        )
        
        pids.each {|pid|
            
            record          = $tables.attach("STUDENT_TESTS").primary_id(pid)
            student_id      = record.fields["student_id"].value
            
            if $students.list(:currently_enrolled=>true,:student_id=>student_id)
                
                event_site_id   = record.fields["test_event_site_id"].value
                date            = $db.get_data_single("SELECT CURDATE()")[0]
                
                new_record = $tables.attach("STUDENT_TEST_DATES").new_row
                new_record.fields["student_id"          ].value = student_id
                new_record.fields["test_event_site_id"  ].value = event_site_id
                new_record.fields["date"                ].value = date
                
                new_record.save
                
            end
         
        }
      
    end
    
    def after_change_field_attendance_code(field_obj)
        record = by_primary_id(field_obj.primary_id)
        require "#{$paths.system_path}data_processing/Attendance_Processing"
        Attendance_Processing.new(record.fields["student_id"].value, record.fields["date"].value)
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
                "name"              => "student_test_dates",
                "file_name"         => "student_test_dates.csv",
                "file_location"     => "student_test_dates",
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
            structure_hash["fields"]["student_id"           ] = {"data_type"=>"int",  "file_field"=>"student_id"        } if field_order.push("student_id")
            #The event site is kept because you may have scheduled this date for different sites
            structure_hash["fields"]["test_event_site_id"   ] = {"data_type"=>"int",  "file_field"=>"test_event_site_id"} if field_order.push("test_event_site_id")
            structure_hash["fields"]["date"                 ] = {"data_type"=>"date", "file_field"=>"date"              } if field_order.push("date")
            structure_hash["fields"]["attendance_code"      ] = {"data_type"=>"text", "file_field"=>"attendance_code"   } if field_order.push("attendance_code")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end