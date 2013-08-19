#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class STUDENT_RISK_LEVEL_ENGAGEMENT < Athena_Table
    
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
    
    def update_engagement_risk_level_sti_combined
        current_students = $tables.attach("K12_Omnibus").current_students
        current_students.each do |sid|
            stu = $students.attach(sid)
            #percent of STI's offered that the student attended. Risk level is maxed if the student has attended 0 even if they were offered 0.
            attended = true if stu.sti_attended_overall && stu.sti_attended_overall.value
            tot_attended = attended ? stu.sti_attended_overall.mathable : 0 
            offered = true if stu.sti_offered_overall
            tot_offered = offered ? stu.sti_offered_overall : 0
            risk_level = stu.sti_attended_overall && stu.sti_attended_overall.value > 0 ? stu.sti_attended_overall.mathable/stu.sti_offered_overall.to_i || 0 : 0
            if risk_level >= 0.90
                risk_level = 0
            elsif risk_level >= 0.80
                risk_level = 1
            elsif risk_level >= 0.70
                risk_level = 2
            elsif risk_level >= 0.60
                risk_level = 3
            elsif risk_level >= 0.50
                risk_level = 4
            elsif risk_level >= 0.40
                risk_level = 5
            end 
            calculate_risk(sid, risk_level, "sti_participation")
            $students.detach(sid)
        end
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "student_risk_level_engagement",
                "file_name"         => "student_risk_level_engagement.csv",
                "file_location"     => "student_risk_level_engagement",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                :relationship       => :one_to_many
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
            structure_hash["fields"]["sti_participation"]   = {"data_type"=>"decimal(5,4)",  "file_field"=>"sti_participation"}  if field_order.push("sti_participation")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

    def calculate_risk(sid, risk_level, area_of_risk) 
        influencers = ["sti_participation"]
        
        risk_record = by_studentid_old(sid)
        if !risk_record
            risk_record = new_row
            risk_record.fields["student_id"].value = sid
        end
        
        risk_record.fields[area_of_risk].value = risk_level
        
        risk_level = 0
        risk_record.fields.each_pair{|field_name, details|
            risk_level = risk_level + details.mathable if influencers.include?(field_name)
        }
        risk_record.fields["risk_level"].value = risk_level/influencers.length
        
        risk_record.save
    end
end