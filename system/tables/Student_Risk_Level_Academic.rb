#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RISK_LEVEL_ACADEMIC < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def update_scantron(scantron_fields, ent_ext)
        subjects            = ["math","reading","science"]
        sid                 = scantron_fields["student_id"].value
        risk_record         = by_studentid_old(sid)
        if !risk_record
            risk_record = new_row
            risk_record.fields["student_id"].value = sid
        end
        subjects.each{|subject|
            risk_level          = nil
            level = scantron_fields["stron_#{ent_ext}_perf_#{subject[0].chr}"].value
            if level == "At Risk"
                risk_level = 3
            elsif level == "Advanced"
                risk_level = 0
            elsif level == "On Target"
                risk_level = 0
            elsif level == "Not Tested"
                risk_level = 1
            end
           
            risk_record.fields["scantron_#{subject}"].value = risk_level
        }
        calculate_risk(risk_record)
        risk_record.save
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_risk_level_academic",
                "file_name"         => "student_risk_level_academic.csv",
                "file_location"     => "student_risk_level_academic",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                :relationship       => :one_to_one
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]          = {"data_type"=>"int",  "file_field"=>"student_id"}         if field_order.push("student_id")
            structure_hash["fields"]["risk_level"]          = {"data_type"=>"decimal(5,4)",  "file_field"=>"risk_level"}         if field_order.push("risk_level")
            structure_hash["fields"]["scantron_math"]       = {"data_type"=>"int",  "file_field"=>"scantron_math"}      if field_order.push("scantron_math")
            structure_hash["fields"]["scantron_reading"]    = {"data_type"=>"int",  "file_field"=>"scantron_reading"}   if field_order.push("scantron_reading")
            structure_hash["fields"]["scantron_science"]    = {"data_type"=>"int",  "file_field"=>"scantron_science"}   if field_order.push("scantron_science")
            structure_hash["fields"]["pssa_math"]           = {"data_type"=>"int",  "file_field"=>"pssa_math"}          if field_order.push("pssa_math")
            structure_hash["fields"]["pssa_reading"]        = {"data_type"=>"int",  "file_field"=>"pssa_reading"}       if field_order.push("pssa_reading")
            structure_hash["fields"]["pssa_writing"]        = {"data_type"=>"int",  "file_field"=>"pssa_writing"}       if field_order.push("pssa_writing")
            structure_hash["fields"]["pssa_science"]        = {"data_type"=>"int",  "file_field"=>"pssa_science"}       if field_order.push("pssa_science")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

    def calculate_risk(risk_record) #For now this is based on math and reading scores only.
        influencers = [
            "scantron_math",    
            "scantron_reading", 
            #"scantron_science", 
            "pssa_math",        
            "pssa_reading",     
            #"pssa_writing",     
            #"pssa_science"
        ]
        risk_level = 0
        risk_record.fields.each_pair{|field_name, details|
            risk_level = risk_level + details.mathable if influencers.include?(field_name)
        }
        risk_record.fields["risk_level"].value = risk_level/influencers.length
    end
end