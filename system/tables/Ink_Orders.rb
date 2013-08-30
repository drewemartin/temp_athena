#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class INK_ORDERS < Athena_Table
    
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

    def by_studentid_old(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY request_date DESC"
        records(where_clause) 
    end
    
    def by_primaryid(pid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id",  "=", pid   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_status(arg)
        params = Array.new
        if arg.is_a? String
            params.push( Struct::WHERE_PARAMS.new("status",  "=", arg   ) )
        elsif arg.is_a? Array
            arg.each do |each_arg|
                params.push( Struct::WHERE_PARAMS.new("status",  "=", each_arg   ) )
            end
        end
        where_clause = $db.where_clause(params, "OR")
        records(where_clause)
    end
    
    def ink_check(sid)
        ipm_db = $tables.attach("ink_printer_models").data_base
        sh_db = $tables.attach("sams_hardware").data_base
        select_sql="
        SELECT DISTINCT
            sams_hardware.student_id,
            printer_model, 
            ink_number  
        FROM #{ipm_db}.ink_printer_models
        RIGHT OUTER JOIN #{sh_db}.sams_hardware
        ON #{ipm_db}.printer_make_model = #{sh_db}.sams_model
        LEFT JOIN #{data_base}.ink_orders
        ON #{sh_db}.sams_hardware.student_id = #{data_base}.ink_orders.studentid
        WHERE sams_hardware.student_id=#{sid}"
        return $db.get_data(select_sql)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_load_k12_omnibus
        require File.dirname(__FILE__).gsub("tables","data_processing/ink_orders_email")
        Ink_Orders_Email.new
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "ink_orders",
                "file_name"         => "ink_orders.csv",
                "file_location"     => "ink_orders",
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
            structure_hash["fields"]["studentid"] = {"data_type"=>"int", "file_field"=>"studentid"} if field_order.push("studentid")
            structure_hash["fields"]["request_date"] = {"data_type"=>"date", "file_field"=>"request_date"} if field_order.push("request_date")
            structure_hash["fields"]["order_date"] = {"data_type"=>"date", "file_field"=>"order_date"} if field_order.push("order_date")
            structure_hash["fields"]["ship_date"] = {"data_type"=>"date", "file_field"=>"ship_date"} if field_order.push("ship_date")
            structure_hash["fields"]["status"] = {"data_type"=>"text", "file_field"=>"status"} if field_order.push("status")
            structure_hash["fields"]["school_year"] = {"data_type"=>"text", "file_field"=>"school_year"} if field_order.push("school_year")
            structure_hash["fields"]["printer"] = {"data_type"=>"text", "file_field"=>"printer"} if field_order.push("printer")
            structure_hash["fields"]["ink"] = {"data_type"=>"text", "file_field"=>"ink"} if field_order.push("ink")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end