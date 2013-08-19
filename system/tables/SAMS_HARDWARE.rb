#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class SAMS_HARDWARE < Athena_Table
    
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
        records(where_clause) 
    end
    
    def by_primaryid(pid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id",  "=", pid   ) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
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
                "name"              => "sams_hardware",
                "file_name"         => "sams_hardware.csv",
                "file_location"     => "sams_hardware",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => false
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["student_id"]              = {"data_type"=>"int",  "file_field"=>"Student ID #"}       if field_order.push("student_id")
        structure_hash["fields"]["last_name"]               = {"data_type"=>"text", "file_field"=>"Last Name"}          if field_order.push("last_name")
        structure_hash["fields"]["first_name"]              = {"data_type"=>"text", "file_field"=>"First Name"}         if field_order.push("first_name")
        structure_hash["fields"]["student_status"]          = {"data_type"=>"text", "file_field"=>"Student Status"}     if field_order.push("student_status")
        structure_hash["fields"]["batch_date"]              = {"data_type"=>"date", "file_field"=>"Batch Date"}         if field_order.push("batch_date")
        structure_hash["fields"]["batch_number"]            = {"data_type"=>"int",  "file_field"=>"Batch #"}            if field_order.push("batch_number")
        structure_hash["fields"]["enrollment_date"]         = {"data_type"=>"date", "file_field"=>"Enrollment Date"}    if field_order.push("enrollment_date")
        structure_hash["fields"]["withdraw_date"]           = {"data_type"=>"date", "file_field"=>"Withdraw Date"}      if field_order.push("withdraw_date")
        structure_hash["fields"]["school"]                  = {"data_type"=>"text", "file_field"=>"School"}             if field_order.push("school")
        structure_hash["fields"]["grade"]                   = {"data_type"=>"text", "file_field"=>"Grade"}              if field_order.push("grade")
        structure_hash["fields"]["home_phone"]              = {"data_type"=>"text", "file_field"=>"Home Phone #"}       if field_order.push("home_phone")
        structure_hash["fields"]["family_id_number"]        = {"data_type"=>"int",  "file_field"=>"Family ID #"}        if field_order.push("family_id_number")
        structure_hash["fields"]["cpu_fulfiller"]           = {"data_type"=>"text", "file_field"=>"CPU Fulfiller"}      if field_order.push("cpu_fulfiller")
        structure_hash["fields"]["cpu_make_model"]          = {"data_type"=>"text", "file_field"=>"CPU Make/model"}     if field_order.push("cpu_make_model")
        structure_hash["fields"]["cpu_serial_number"]       = {"data_type"=>"text", "file_field"=>"CPU Serial #"}       if field_order.push("cpu_serial_number")
        structure_hash["fields"]["cpu_tracking_number"]     = {"data_type"=>"text", "file_field"=>"CPU Tracking #"}     if field_order.push("cpu_tracking_number")
        structure_hash["fields"]["cpu_status"]              = {"data_type"=>"text", "file_field"=>"CPU Status"}         if field_order.push("cpu_status")
        structure_hash["fields"]["monitor_fulfiller"]       = {"data_type"=>"text", "file_field"=>"Monitor Fulfiller"}  if field_order.push("monitor_fulfiller")
        structure_hash["fields"]["monitor_make_model"]      = {"data_type"=>"text", "file_field"=>"Monitor Make/model"} if field_order.push("monitor_make_model")
        structure_hash["fields"]["monitor_serial_number"]   = {"data_type"=>"text", "file_field"=>"Monitor Serial #"}   if field_order.push("monitor_serial_number")
        structure_hash["fields"]["monitor_tracking_number"] = {"data_type"=>"text", "file_field"=>"Monitor Tracking #"} if field_order.push("monitor_tracking_number")
        structure_hash["fields"]["monitor_status"]          = {"data_type"=>"text", "file_field"=>"Monitor Status"}     if field_order.push("monitor_status")
        structure_hash["fields"]["printer_fulfiller"]       = {"data_type"=>"text", "file_field"=>"Printer Fulfiller"}  if field_order.push("printer_fulfiller")
        structure_hash["fields"]["printer_make_model"]      = {"data_type"=>"text", "file_field"=>"Printer Make/model"} if field_order.push("printer_make_model")
        structure_hash["fields"]["printer_serial_number"]   = {"data_type"=>"text", "file_field"=>"Printer Serial #"}   if field_order.push("printer_serial_number")
        structure_hash["fields"]["printer_tracking_number"] = {"data_type"=>"text", "file_field"=>"Printer Tracking #"} if field_order.push("printer_tracking_number")
        structure_hash["fields"]["printer_status"]          = {"data_type"=>"text", "file_field"=>"Printer Status"}     if field_order.push("printer_status")
        structure_hash["fields"]["speaker_fulfiller"]       = {"data_type"=>"text", "file_field"=>"Speaker Fulfiller"}  if field_order.push("speaker_fulfiller")
        structure_hash["fields"]["speaker_make_model"]      = {"data_type"=>"text", "file_field"=>"Speaker Make/model"} if field_order.push("speaker_make_model")
        structure_hash["fields"]["speaker_serial_number"]   = {"data_type"=>"text", "file_field"=>"Speaker Serial #"}   if field_order.push("speaker_serial_number")
        structure_hash["fields"]["speaker_tracking_number"] = {"data_type"=>"text", "file_field"=>"Speaker Tracking #"} if field_order.push("speaker_tracking_number")
        structure_hash["fields"]["speaker_status"]          = {"data_type"=>"text", "file_field"=>"Speaker Status"}     if field_order.push("speaker_status")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end