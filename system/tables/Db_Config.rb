#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DB_CONFIG < Athena_Table
    #This table can eventually hold most of the data stored in the private methods of table classes
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

    def attendance_reports
        params = Array.new
        where_clause = "WHERE table_name IN ('K12_HS_ACTIVITY', 'K12_OMNIBUS', 'K12_WITHDRAWAL', 'K12_LOGINS', 'K12_ELLUMINATE_SESSION', 'K12_LESSONS_COUNT_DAILY') ORDER BY import_schedule"
        records(where_clause)
    end
    
    def by_table_name(table_name)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("table_name", "=", table_name) )
        where_clause = $db.where_clause(params)
        record(where_clause)
    end
    
    def dependancies_updated?(table_names)
        updated = false
        table_names.each{|table_name|
            table_uptodate = $db.get_data_single(
                "SELECT
                    table_name
                WHERE table_name = '#{table_name}'
                AND import_complete_datetime < LEFT(CURDATE(),)"
            )
            
        }
    end
    
    def finalize_ok
        select_sql = String.new
        select_sql << "SELECT COUNT(*)"
        select_sql << " FROM #{table_name}"
        select_sql << " WHERE import_complete_datetime >= CURDATE()"
        select_sql << " AND import_complete_datetime > load_started_datetime"
        select_sql << " AND phase_completed <=> phase_total"
        select_sql << " AND table_name IN ('K12_ECOLLEGE_ACTIVITY', 'K12_HS_ACTIVITY', 'K12_OMNIBUS', 'K12_WITHDRAWAL', 'K12_LOGINS', 'K12_ELLUMINATE_SESSION', 'K12_LESSONS_COUNT_DAILY')"
        $db.get_data_single(select_sql)
    end
    
    def k12_reports
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("table_name", "REGEXP", "K12_") )
        where_clause = $db.where_clause(params)
        records(where_clause)
    end
    
    def scheduled_now 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("import_schedule", "REGEXP", ".*#{$itime_hm}.*") )
        where_clause = $db.where_clause(params)
        where_clause << " AND (import_occurance = 'Daily' OR import_occurance = DATE_FORMAT(NOW(),\"%W\")) "
        records(where_clause) 
    end
    
    def scheduled_missed
    #TO HELP LOAD SCHEDULED REPORTS IF THE SERVER WENT OFFLINE FOR A PERIOD OF TIME.
    #AS OF NOW THIS ONLY CATCHES THE FIRST TIME SCHEDULED
        where_clause =
            " WHERE LEFT(import_schedule,5) < '#{$itime_hm}'
            AND (import_occurance = 'Daily' OR import_occurance = DATE_FORMAT(NOW(),\"%W\"))
            AND LEFT(load_complete_datetime,10) = LEFT(DATE_SUB(NOW(),INTERVAL 1 DAY),10)
            ORDER BY LEFT(import_schedule,5) ASC "
        records(where_clause) 
    end
    
    def tables(table_name = false)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("table_name", "=", table_name) ) if table_name
        where_clause = table_name ? $db.where_clause(params) : ""
        records(where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
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
                "name"              => "db_config",
                "file_name"         => "db_config.csv",
                "file_location"     => "db_config",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["table_name"               ] = {"data_type"=>"text",     "file_field"=>"table_name"}               if field_order.push("table_name")
            structure_hash["fields"]["import_schedule"          ] = {"data_type"=>"text",     "file_field"=>"import_schedule"}          if field_order.push("import_schedule")
            structure_hash["fields"]["import_occurance"         ] = {"data_type"=>"text",     "file_field"=>"import_occurance"}         if field_order.push("import_occurance")
            
            structure_hash["fields"]["last_import_datetime"     ] = {"data_type"=>"datetime", "file_field"=>"last_import_datetime"}     if field_order.push("last_import_datetime")
            structure_hash["fields"]["last_import_status"       ] = {"data_type"=>"text",     "file_field"=>"last_import_status"}       if field_order.push("last_import_status")
            
            structure_hash["fields"]["load_started_datetime"    ] = {"data_type"=>"datetime", "file_field"=>"load_started_datetime"}    if field_order.push("load_started_datetime")
            structure_hash["fields"]["load_complete_datetime"   ] = {"data_type"=>"datetime", "file_field"=>"load_complete_datetime"}   if field_order.push("load_complete_datetime")
            
            structure_hash["fields"]["after_load_status"        ] = {"data_type"=>"text",     "file_field"=>"after_load_status"}        if field_order.push("after_load_status")
            structure_hash["fields"]["phase_total"              ] = {"data_type"=>"text",     "file_field"=>"phase_total"}              if field_order.push("phase_total")
            structure_hash["fields"]["phase_completed"          ] = {"data_type"=>"text",     "file_field"=>"phase_completed"}          if field_order.push("phase_completed")
            
            structure_hash["fields"]["import_complete_datetime" ] = {"data_type"=>"datetime", "file_field"=>"import_complete_datetime"} if field_order.push("import_complete_datetime")
            
            structure_hash["fields"]["last_error_datetime"      ] = {"data_type"=>"datetime", "file_field"=>"last_error_datetime"}      if field_order.push("last_error_datetime")
            
            structure_hash["field_order"] = field_order
            
        return structure_hash
    end

end