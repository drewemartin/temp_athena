#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DOCUMENT_TYPE < Athena_Table
    
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
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def init_pre_reqs
        
        return ["document_category"]
        
    end
    
    def load_pre_reqs
        
        pre_reqs = Array.new
        
        cat_id_truancy                  = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Truancy'")
        pre_reqs.push({:name=>"Truancy Elimination Plan"                        , :category_id => cat_id_truancy.value,                         :file_extension=>"pdf"}) if cat_id_truancy
        pre_reqs.push({:name=>"Truancy Withdrawal Report"                       , :category_id => cat_id_truancy.value,                         :file_extension=>"csv"}) if cat_id_truancy
        
        cat_id_withdrawals              = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Withdrawals'")
        pre_reqs.push({:name=>"District Withdrawal Notification"                , :category_id => cat_id_withdrawals.value,                     :file_extension=>"pdf"}) if cat_id_withdrawals
        pre_reqs.push({:name=>"District Withdrawal Notification - By District"  , :category_id => cat_id_withdrawals.value,                     :file_extension=>"pdf"}) if cat_id_withdrawals
        pre_reqs.push({:name=>"District Withdrawal Notification - Complete"     , :category_id => cat_id_withdrawals.value,                     :file_extension=>"pdf"}) if cat_id_withdrawals
        pre_reqs.push({:name=>"Final Grades"                                    , :category_id => cat_id_withdrawals.value,                     :file_extension=>"pdf"}) if cat_id_withdrawals
        pre_reqs.push({:name=>"Missing District Contact Information"            , :category_id => cat_id_withdrawals.value,                     :file_extension=>"csv"}) if cat_id_withdrawals
        
        cat_id_team_member_evaluations  = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Team Member Evaluations'")
        pre_reqs.push({:name=>"Evaluation"                                      , :category_id => cat_id_team_member_evaluations.value,         :file_extension=>"pdf"}) if cat_id_team_member_evaluations
        
        cat_id_supplies                 = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Supplies'")
        pre_reqs.push({:name=>"Ink Orders"                                      , :category_id => cat_id_supplies.value,                        :file_extension=>"csv"}) if cat_id_supplies
        pre_reqs.push({:name=>"Ink ID Requests"                                 , :category_id => cat_id_supplies.value,                        :file_extension=>"csv"}) if cat_id_supplies
        
        cat_id_enrollment               = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Enrollment'")
        pre_reqs.push({:name=>"Duplicated Students Report"                      , :category_id => cat_id_enrollment.value,                      :file_extension=>"csv"}) if cat_id_enrollment
        
        cat_id_attendance               = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Attendance'")
        pre_reqs.push({:name=>"Attendance Master"                               , :category_id => cat_id_attendance.value,                      :file_extension=>"csv"}) if cat_id_attendance
        pre_reqs.push({:name=>"Login Reminders Report"                          , :category_id => cat_id_attendance.value,                      :file_extension=>"csv"}) if cat_id_attendance
        pre_reqs.push({:name=>"Bulk Change - Overall Mode"                      , :category_id => cat_id_attendance.value,                      :file_extension=>"csv"}) if cat_id_attendance
        pre_reqs.push({:name=>"Bulk Change - Daily Mode"                        , :category_id => cat_id_attendance.value,                      :file_extension=>"csv"}) if cat_id_attendance
        pre_reqs.push({:name=>"Bulk Change - Daily Code"                        , :category_id => cat_id_attendance.value,                      :file_extension=>"csv"}) if cat_id_attendance

        cat_id_sapphire_imports         = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Sapphire Imports'")
        pre_reqs.push({:name=>"Sapphire New Students"                           , :category_id => cat_id_sapphire_imports.value,                :file_extension=>"csv"}) if cat_id_sapphire_imports
        pre_reqs.push({:name=>"Sapphire Withdrawn Students"                     , :category_id => cat_id_sapphire_imports.value,                :file_extension=>"csv"}) if cat_id_sapphire_imports
        
        cat_id_sapphire_reports         = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Sapphire Reports'")
        pre_reqs.push({:name=>"Sapphire Graduated Students"                     , :category_id => cat_id_sapphire_reports.value,                :file_extension=>"csv"}) if cat_id_sapphire_reports
        pre_reqs.push({:name=>"Sapphire Returning Students"                     , :category_id => cat_id_sapphire_reports.value,                :file_extension=>"csv"}) if cat_id_sapphire_reports
        pre_reqs.push({:name=>"Invalid Districts Report"                        , :category_id => cat_id_sapphire_reports.value,                :file_extension=>"csv"}) if cat_id_sapphire_reports
        
        cat_id_sapphire_nursing         = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Nursing'")
        pre_reqs.push({:name=>"Snap Students Update"                            , :category_id => cat_id_sapphire_nursing.value,                :file_extension=>"csv"}) if cat_id_sapphire_nursing 
        pre_reqs.push({:name=>"Snap Caregivers Update"                          , :category_id => cat_id_sapphire_nursing.value,                :file_extension=>"csv"}) if cat_id_sapphire_nursing
        
        cat_id_ilp                      = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Individualized Learning Plan'")
        pre_reqs.push({:name=>"Student ILP"                                     , :category_id => cat_id_ilp.value,                             :file_extension=>"pdf"}) if cat_id_ilp 
        
        cat_id_scantron = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Scantron'")
        pre_reqs.push({:name=>"Scantron Participation Incomplete Report" , :category_id => cat_id_scantron.value, :file_extension=>"csv"}) if cat_id_scantron
        pre_reqs.push({:name=>"Scantron Participation Incomplete Overall Report" , :category_id => cat_id_scantron.value, :file_extension=>"csv"}) if cat_id_scantron
        pre_reqs.push({:name=>"Scantron Participation Completion Overall Report" , :category_id => cat_id_scantron.value, :file_extension=>"csv"}) if cat_id_scantron
        
        cat_id_athena = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='Athena'")
        pre_reqs.push({:name=>"Converted SID To PID CSV" , :category_id => cat_id_athena.value, :file_extension=>"csv"}) if cat_id_athena
        pre_reqs.push({:name=>"Mass Kmail Students List" , :category_id => cat_id_athena.value, :file_extension=>"csv"}) if cat_id_athena
        
        cat_id_k12_reports = $tables.attach("DOCUMENT_CATEGORY").find_field("primary_id", "WHERE name='K12 Reports'")
        pre_reqs.push({:name=>"Aggregate Progress"          , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"All Students"                , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Attendance Modified"         , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"CALMS Aggregate Progress"    , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Class List Teacher View VHS" , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"ECollege Activity Duration"  , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"ECollege Detail"             , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"EITR V2"                     , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Elluminate Session"          , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Highschool Classroom"        , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Home Language"               , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Learning Coach Report"       , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Lessons Count Daily"         , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Logins"                      , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Logins - Afternoon"          , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Omnibus"                     , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Pal Assessment"              , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"SalesForce Case Report"      , :category_id => cat_id_k12_reports.value, :file_extension=>"xls"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Progress And Achievement"    , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Staff List"                  , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"STI Combined Report"         , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"STI Intervention"            , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Student Course"              , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"Withdraw"                    , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        pre_reqs.push({:name=>"High School Activity"        , :category_id => cat_id_k12_reports.value, :file_extension=>"csv"}) if cat_id_k12_reports
        
        max = pre_reqs.length
        (0...max).each{|i|
            
            if primary_ids("WHERE name = '#{pre_reqs[i][:name]}' AND category_id = '#{pre_reqs[i][:category_id]}'")
                pre_reqs[i] = nil
            end
            
        }
        
        pre_reqs.compact!
        
        return pre_reqs
        
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
                "name"              => "document_type",
                "file_name"         => "document_type.csv",
                "file_location"     => "document_type",
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
            
            structure_hash["fields"]["category_id"      ] = {"data_type"=>"int",  "file_field"=>"category_id"   } if field_order.push("category_id"     )
            structure_hash["fields"]["name"             ] = {"data_type"=>"text", "file_field"=>"name"          } if field_order.push("name"            )
            structure_hash["fields"]["file_extension"   ] = {"data_type"=>"text", "file_field"=>"file_extension"} if field_order.push("file_extension"  )

            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end