#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_ENROLLMENT < Athena_Table
    
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
    
    def active_by_studentid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        params.push( Struct::WHERE_PARAMS.new("active",     "=", "1") )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_change_field_withdrawdate(changed_field)
        if !changed_field.value.nil?
            this_record = by_primary_id(changed_field.primary_id)
            this_record.fields["active"].value = false
            this_record.save
            
            sid = this_record.fields["student_id"]
            student_record = $tables.attach("STUDENT").by_studentid_old(sid)
            student_record.fields["active"].value = false
            student_record.save
        end
    end
    
    def after_insert(this_record)
        this_record.fields["active"].value = true
        sid     = this_record.fields["student_id"].value
        student = $students.attach(sid)
        student.active.value = true
        student.active.save
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_enrollment",
                "file_name"         => "student_enrollment.csv",
                "file_location"     => "student_enrollment",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
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
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",  "file_field"=>"student_id"}                 if field_order.push("student_id")
            structure_hash["fields"]["enrollment_start"]        = {"data_type"=>"date", "file_field"=>"enrollment_start"}           if field_order.push("enrollment_start")
            structure_hash["fields"]["initial_enrollment_year"] = {"data_type"=>"year", "file_field"=>"initial_enrollment_year"}    if field_order.push("initial_enrollment_year")
            structure_hash["fields"]["enrollreceiveddate"]      = {"data_type"=>"date", "file_field"=>"enrollreceiveddate"}         if field_order.push("enrollreceiveddate")
            structure_hash["fields"]["enrollapproveddate"]      = {"data_type"=>"date", "file_field"=>"enrollapproveddate"}         if field_order.push("enrollapproveddate")
            structure_hash["fields"]["schoolenrolldate"]        = {"data_type"=>"date", "file_field"=>"schoolenrolldate"}           if field_order.push("schoolenrolldate")
            structure_hash["fields"]["districtofresidence"]     = {"data_type"=>"text", "file_field"=>"districtofresidence"}        if field_order.push("districtofresidence")
            structure_hash["fields"]["withdrawreason"]          = {"data_type"=>"text", "file_field"=>"withdrawreason"}             if field_order.push("withdrawreason")
            structure_hash["fields"]["withdrawdate"]            = {"data_type"=>"date", "file_field"=>"withdrawdate"}               if field_order.push("withdrawdate")
            structure_hash["fields"]["schoolwithdrawdate"]      = {"data_type"=>"date", "file_field"=>"schoolwithdrawdate"}         if field_order.push("schoolwithdrawdate")
            structure_hash["fields"]["do_not_call"]             = {"data_type"=>"text", "file_field"=>"do_not_call"}                if field_order.push("do_not_call")
            structure_hash["fields"]["transferring_to"]         = {"data_type"=>"text", "file_field"=>"transferring_to"}            if field_order.push("transferring_to")
            structure_hash["fields"]["enrollment_end"]          = {"data_type"=>"date", "file_field"=>"enrollment_end"}             if field_order.push("enrollment_end")
            structure_hash["fields"]["active"]                  = {"data_type"=>"bool", "file_field"=>"active"}                     if field_order.push("active")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end