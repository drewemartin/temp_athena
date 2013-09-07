#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class PSSA < Athena_Table
    
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
    
    def by_studentid_agora_tested(sid, test_year = nil) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid",          "=",    sid         ) )
        params.push( Struct::WHERE_PARAMS.new("test_school_year",   "=",    test_year   ) ) if test_year
        params.push( Struct::WHERE_PARAMS.new("agora_tested",       "IS",   "TRUE"      ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def by_studentid_desc(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg) )
        where_clause = $db.where_clause(params)
        where_clause << "ORDER BY test_school_year DESC"
        records(where_clause) 
    end
    
    def by_primaryid(arg) 
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_bystudentid(field_name, studentid) #returns only the most recent results
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        where_clause << "ORDER BY test_school_year DESC"
        find_field(field_name, where_clause)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SELECT_DD_CHOICES
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def test_type
        output = [
            pssa =      {"name" => "PSSA",      "value" => "PSSA"},
            pssa_m =    {"name" => "PSSA-M",    "value" => "PSSA-M"},
            pasa =      {"name" => "PASA",      "value" => "PASA"},
            retest =    {"name" => "RETEST",    "value" => "RETEST"},
            na =        {"name" => "N/A",       "value" => "N/A"}
        ]
        return output
    end
    
    def perf_level
        output = [
            below_basic = {"name" => "Below Basic",     "value" => "Below Basic"},
            basic =       {"name" => "Basic",           "value" => "Basic"},      
            proficient =  {"name" => "Proficient",      "value" => "Proficient"}, 
            advanced =    {"name" => "Advanced",        "value" => "Advanced"},
            ns =          {"name" => "No Score (NS)",   "value" => "No Score (NS)"} 
        ]
        return output
    end
    
    #def school_years
    #    years = 12
    #    start_year = 2000
    #    i = 0
    #    output = []
    #    while i < years do
    #        output.push(year = {"name" => "#{start_year+i}-#{start_year+1+i}", "value" => "#{start_year+i}-#{start_year+1+i}"})
    #        i += 1
    #    end
    #    return output
    #end
    
    def school_years
        years = 13
        start_year = 2000
        i = 0
        output = []
        while i < years do
            output.push(year = {"name" => "#{start_year+i}", "value" => "#{start_year+i}"})
            i += 1
        end
        return output
    end
    
    def grade_levels
        output = [
            k =      {"name" => "K",    "value" => "K"},
            one =    {"name" => "1",    "value" => "1"},
            two =    {"name" => "2",    "value" => "2"},
            three =  {"name" => "3",    "value" => "3"},
            four =   {"name" => "4",    "value" => "4"},
            five =   {"name" => "5",    "value" => "5"},
            six =    {"name" => "6",    "value" => "6"},
            seven =  {"name" => "7",    "value" => "7"},
            eight =  {"name" => "8",    "value" => "8"},
            nine =   {"name" => "9",    "value" => "9"},
            ten =    {"name" => "10",   "value" => "10"},
            eleven = {"name" => "11",   "value" => "11"},
            twelve = {"name" => "12",   "value" => "12"}, 
        ]
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    def after_load_pssa_results_agora
        
        agora_sids = $tables.attach("PSSA_RESULTS_AGORA").students_with_records(created_date = $idate)
        agora_sids.each{|sid|
            agora_records = $tables.attach("PSSA_RESULTS_AGORA").by_studentid_old(sid)
            agora_records.each{|agora_record|
                
                #if the test year record doesn't exist create one and fill it out, else edit it
                test_year   = agora_record.fields["tested_year" ].value
                if !by_studentid_agora_tested(sid, test_year)
                    pssa_record = new_row
                    pssa_record.fields["agora_tested"       ].value = true
                    pssa_record.fields["studentid"          ].value = sid
                    pssa_record.fields["test_school_year"   ].value = sid
                end
                pssa_record.fields["grade_when_tested"].value = agora_record.fields["grade"].value
                
                test_subject = nil
                case agora_record.fields["subject"].value
                    when "M"
                    test_subject = "math"
                    when "R"
                    test_subject = "reading"
                    when "W"
                    test_subject = "writing"
                    when "S"
                    test_subject = "science"
                end
                
                test_perf_level = nil
                case agora_record.fields["performance_level_name"].value
                    when "Adv"
                        test_perf_level = "Advanced"
                    when "Bas"
                        test_perf_level = "Basic"
                    when "Bel"
                        test_perf_level = "Below Basic"
                    when "Pro"
                        test_perf_level = "Proficient"
                end
                
            } if agora_records
        }
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "pssa",
                "file_name"         => "pssa.csv",
                "file_location"     => "pssa",
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
            structure_hash["fields"]["studentid"]           = {"data_type"=>"int",  "file_field"=>"studentid"} if field_order.push("studentid")
            structure_hash["fields"]["test_school_year"]    = {"data_type"=>"text", "file_field"=>"test_school_year"} if field_order.push("test_school_year")
            structure_hash["fields"]["grade_when_tested"]   = {"data_type"=>"text", "file_field"=>"grade_when_tested"} if field_order.push("grade_when_tested")
            structure_hash["fields"]["math_test_type"]      = {"data_type"=>"text", "file_field"=>"math_test_type"} if field_order.push("math_test_type")
            structure_hash["fields"]["math_perf_level"]     = {"data_type"=>"text", "file_field"=>"math_perf_level"} if field_order.push("math_perf_level")
            structure_hash["fields"]["math_score"]          = {"data_type"=>"int",  "file_field"=>"math_score"} if field_order.push("math_score")
            structure_hash["fields"]["reading_test_type"]   = {"data_type"=>"text", "file_field"=>"reading_test_type"} if field_order.push("reading_test_type")
            structure_hash["fields"]["reading_perf_level"]  = {"data_type"=>"text", "file_field"=>"reading_perf_level"} if field_order.push("reading_perf_level")
            structure_hash["fields"]["reading_score"]       = {"data_type"=>"int",  "file_field"=>"reading_score"} if field_order.push("reading_score")
            structure_hash["fields"]["writing_test_type"]   = {"data_type"=>"text", "file_field"=>"writing_test_type"} if field_order.push("writing_test_type")
            structure_hash["fields"]["writing_perf_level"]  = {"data_type"=>"text", "file_field"=>"writing_perf_level"} if field_order.push("writing_perf_level")
            structure_hash["fields"]["writing_score"]       = {"data_type"=>"int",  "file_field"=>"writing_score"} if field_order.push("writing_score")
            structure_hash["fields"]["science_test_type"]   = {"data_type"=>"text", "file_field"=>"science_test_type"} if field_order.push("science_test_type")
            structure_hash["fields"]["science_perf_level"]  = {"data_type"=>"text", "file_field"=>"science_perf_level"} if field_order.push("science_perf_level")
            structure_hash["fields"]["science_score"]       = {"data_type"=>"int",  "file_field"=>"science_score"} if field_order.push("science_score")
            structure_hash["fields"]["agora_tested"]        = {"data_type"=>"bool", "file_field"=>"agora_tested"} if field_order.push("agora_tested")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end