#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEST_EVENT_SITE_STAFF < Athena_Table
    
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
    
    def by_staff_id(staff_id, test_event_site_id = nil, role = nil)
        
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",               "=", staff_id           ) )
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id",     "=", test_event_site_id ) ) if test_event_site_id
        params.push( Struct::WHERE_PARAMS.new("role",                   "=", role               ) ) if role
        where_clause = $db.where_clause(params)
        record(where_clause)
        
    end
    
    def is_site_coordinator?(sams_id, site_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("staff_id",           "=", sams_id ) )
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id", "=", site_id ) )
        params.push( Struct::WHERE_PARAMS.new("role",               "=", "Site Coordinator" ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_test_event_site_id(id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("test_event_site_id",  "=", id   ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def after_change_field_not_attending(field_obj)
        
        update_team_attendance_records(field_obj)
        
    end
    
    def after_insert(row_object)
        
        temporarily_insert_team_id(row_object)
        update_team_attendance_records(row_object)
        
    end
    
    def update_team_attendance_records(obj)
        
        record = by_primary_id(obj.primary_id)
        
        start_date  = $tables.attach("TEST_EVENT_SITES").field_value("start_date",   "WHERE primary_id = '#{record.fields["test_event_site_id"].value}'")
        end_date    = $tables.attach("TEST_EVENT_SITES").field_value("end_date",     "WHERE primary_id = '#{record.fields["test_event_site_id"].value}'")
        
        if start_date && end_date
            
            start_date = Date.parse(start_date  )
            end_date   = Date.parse(end_date    )
            
            duration_array = Array.new
            
            date_check = start_date
            
            while date_check <= end_date do
                
                date_str = date_check.strftime("%Y-%m-%d")
                
                duration_array.push(date_str) if $school.school_days && $school.school_days.include?(date_str)
                
                date_check += 1
                
            end
            
            duration_array.each{|date|
                
                if !(
                    
                    test_date_record = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").record(
                        
                        "WHERE team_id          = '#{record.fields["team_id"].value             }'
                        AND date                = '#{date                                       }'
                        AND test_event_site_id  = '#{record.fields["test_event_site_id"].value  }'"
                        
                    )
                    
                )
                    
                    test_date_record = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").new_row
                    test_date_record.fields["date"              ].value = date
                    test_date_record.fields["team_id"           ].value = record.fields["team_id"].value
                    test_date_record.fields["test_event_site_id"].value = record.fields["test_event_site_id"].value
                    
                end
                
                if test_date_record.fields["status"].value == "Test Date Canceled" || record.fields["not_attending"].is_not_true?
                    
                    test_date_record.fields["status"].value = nil
                    
                elsif record.fields["not_attending"].is_true?
                    
                    test_date_record.fields["status"].value = "Not Attending"
                    
                end
                
                test_date_record.save
                
            }
            
            pids = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").primary_ids(
                
                "WHERE team_id          = '#{record.fields["team_id"].value             }'
                AND test_event_site_id  = '#{record.fields["test_event_site_id"].value  }'"
             
            )
            
            pids.each{|pid|
                
                att_date_record = $tables.attach("TEAM_TEST_EVENT_SITE_ATTENDANCE").by_primary_id(pid)
                
                if !duration_array.include?(att_date_record.fields["date"].value)
                    
                    att_date_record.fields["status"].set("Test Date Canceled").save 
                    
                end
                
            } if pids
            
        end
        
    end

    def temporarily_insert_team_id(obj)
        
        record = by_primary_id(obj.primary_id)
        if record.fields["staff_id"].value
            team_id = $team.find(:sams_id=>record.fields["staff_id"].value).primary_id.value    
            record.fields["team_id"].set(team_id).save
        end
        if record.fields["team_id"].value
            t = $team.get(record.fields["team_id"].value)    
            record.fields["staff_id"].set(t.sams_ids.existing_records.first.fields["sams_id"].value).save
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
                "name"              => "test_event_site_staff",
                "file_name"         => "test_event_site_staff.csv",
                "file_location"     => "test_event_site_staff",
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
            
            structure_hash["fields"]["test_event_site_id"   ] = {"data_type"=>"int",  "file_field"=>"test_event_site_id"} if field_order.push("test_event_site_id"  )
            structure_hash["fields"]["staff_id"             ] = {"data_type"=>"int",  "file_field"=>"staff_id"          } if field_order.push("staff_id"            )
            structure_hash["fields"]["team_id"              ] = {"data_type"=>"int",  "file_field"=>"team_id"           } if field_order.push("team_id"             )
            structure_hash["fields"]["role"                 ] = {"data_type"=>"text", "file_field"=>"role"              } if field_order.push("role"                )
            structure_hash["fields"]["not_attending"        ] = {"data_type"=>"bool", "file_field"=>"not_attending"     } if field_order.push("not_attending"       )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end