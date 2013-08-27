#!/usr/local/bin/ruby

require "#{$paths.base_path}athena_table"

class K12_STI_COMBINED < Athena_Table
    
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
    
    def field_bystudentid(field_name, studentid)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", studentid) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    def missed_by_studentid(arg)
        $db.get_data_single("SELECT `total_missed_interventions` FROM #{table_name} WHERE `studentid` = '#{arg}'")
    end
    
    def attended_by_studentid(arg) 
        $db.get_data_single("SELECT `total_interventions` FROM #{table_name} WHERE `studentid` = '#{arg}'") 
    end
    
    def students_with_records
        $db.get_data_single("SELECT studentid FROM #{table_name}") 
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
    #Canceled until completly developed
    #$tables.attach("Student_Risk_Level_Engagement").update_engagement_risk_level_sti_combined
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_k12",
                "name"              => "k12_sti_combined",
                "file_name"         => "agora_sti_combined_report.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_sti_combined_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => nil,
                "nice_name"         => "STI Combined Report"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
        structure_hash["fields"]["studentid"]                           = {"data_type"=>"int",      "file_field"=>"STUDENTID"}                          if field_order.push("studentid")
        structure_hash["fields"]["identityid"]                          = {"data_type"=>"int",      "file_field"=>"IDENTITYID"}                         if field_order.push("identityid")
        structure_hash["fields"]["student_firstname"]                   = {"data_type"=>"text",     "file_field"=>"STUDENT_FIRSTNAME"}                  if field_order.push("student_firstname")
        structure_hash["fields"]["student_lastname"]                    = {"data_type"=>"text",     "file_field"=>"STUDENT_LASTNAME"}                   if field_order.push("student_lastname")
        structure_hash["fields"]["grade"]                               = {"data_type"=>"text",     "file_field"=>"GRADE"}                              if field_order.push("grade")
        structure_hash["fields"]["gradelevelid"]                        = {"data_type"=>"int",      "file_field"=>"GRADELEVELID"}                       if field_order.push("gradelevelid")
        structure_hash["fields"]["school_name"]                         = {"data_type"=>"text",     "file_field"=>"SCHOOL_NAME"}                        if field_order.push("school_name")
        structure_hash["fields"]["schoolid"]                            = {"data_type"=>"int",      "file_field"=>"SCHOOLID"}                           if field_order.push("schoolid")
        structure_hash["fields"]["teacher_firstname"]                   = {"data_type"=>"text",     "file_field"=>"TEACHER_FIRSTNAME"}                  if field_order.push("teacher_firstname")
        structure_hash["fields"]["teacher_lastname"]                    = {"data_type"=>"text",     "file_field"=>"TEACHER_LASTNAME"}                   if field_order.push("teacher_lastname")
        structure_hash["fields"]["si_count"]                            = {"data_type"=>"int",      "file_field"=>"SI Count"}                           if field_order.push("si_count")
        structure_hash["fields"]["si_max_comm_date"]                    = {"data_type"=>"date",     "file_field"=>"SI Max Comm Date"}                   if field_order.push("si_max_comm_date")
        structure_hash["fields"]["elluminate_count"]                    = {"data_type"=>"int",      "file_field"=>"Elluminate Count"}                   if field_order.push("elluminate_count")
        structure_hash["fields"]["elluminate_max_comm_date"]            = {"data_type"=>"date",     "file_field"=>"Elluminate Max Comm Date"}           if field_order.push("elluminate_max_comm_date")
        structure_hash["fields"]["sg_f2f_count"]                        = {"data_type"=>"int",      "file_field"=>"SG F2F Count"}                       if field_order.push("sg_f2f_count")
        structure_hash["fields"]["sg_f2f_max_comm_date"]                = {"data_type"=>"date",     "file_field"=>"SG F2F Max Comm Date"}               if field_order.push("sg_f2f_max_comm_date")
        structure_hash["fields"]["sge_max_count"]                       = {"data_type"=>"int",      "file_field"=>"SGE Max Count"}                      if field_order.push("sge_max_count")
        structure_hash["fields"]["sge_max_comm_date"]                   = {"data_type"=>"date",     "file_field"=>"SGE Max Comm Date"}                  if field_order.push("sge_max_comm_date")
        structure_hash["fields"]["pc_phone_count"]                      = {"data_type"=>"int",      "file_field"=>"PC Phone Count"}                     if field_order.push("pc_phone_count")
        structure_hash["fields"]["pc_phone_max_comm_date"]              = {"data_type"=>"date",     "file_field"=>"PC Phone Max Comm Date"}             if field_order.push("pc_phone_max_comm_date")
        structure_hash["fields"]["pc_elluminate_count"]                 = {"data_type"=>"int",      "file_field"=>"PC Elluminate Count"}                if field_order.push("pc_elluminate_count")
        structure_hash["fields"]["pc_elluminate_max_comm_date"]         = {"data_type"=>"date",     "file_field"=>"PC Elluminate Max Comm Date"}        if field_order.push("pc_elluminate_max_comm_date")
        structure_hash["fields"]["mi_count"]                            = {"data_type"=>"int",      "file_field"=>"MI Count"}                           if field_order.push("mi_count")
        structure_hash["fields"]["mi_max_comm_date"]                    = {"data_type"=>"date",     "file_field"=>"MI Max Comm Date"}                   if field_order.push("mi_max_comm_date")
        structure_hash["fields"]["nml_elluminate_count"]                = {"data_type"=>"int",      "file_field"=>"NML Elluminate Count"}               if field_order.push("nml_elluminate_count")
        structure_hash["fields"]["nml_elluminate_max_comm_date"]        = {"data_type"=>"date",     "file_field"=>"NML Elluminate Max Comm Date"}       if field_order.push("nml_elluminate_max_comm_date")
        structure_hash["fields"]["nml_mi_count"]                        = {"data_type"=>"int",      "file_field"=>"NML MI Count"}                       if field_order.push("nml_mi_count")
        structure_hash["fields"]["nml_mi_max_comm_date"]                = {"data_type"=>"date",     "file_field"=>"NML MI Max Comm Date"}               if field_order.push("nml_mi_max_comm_date")
        structure_hash["fields"]["home_visit_count"]                    = {"data_type"=>"int",      "file_field"=>"Home Visit Count"}                   if field_order.push("home_visit_count")
        structure_hash["fields"]["home_visit_max_comm_date"]            = {"data_type"=>"date",     "file_field"=>"Home Visit Max Comm Date"}           if field_order.push("home_visit_max_comm_date")
        structure_hash["fields"]["si_learn_path_count"]                 = {"data_type"=>"int",      "file_field"=>"SI Learn Path Count"}                if field_order.push("si_learn_path_count")
        structure_hash["fields"]["si_learn_path_max_comm_date"]         = {"data_type"=>"date",     "file_field"=>"SI Learn Path Max Comm Date"}        if field_order.push("si_learn_path_max_comm_date")
        structure_hash["fields"]["spec_inter_count"]                    = {"data_type"=>"int",      "file_field"=>"Spec Inter Count"}                   if field_order.push("spec_inter_count")
        structure_hash["fields"]["spec_inter_max_comm_date"]            = {"data_type"=>"date",     "file_field"=>"Spec Inter Max Comm Date"}           if field_order.push("spec_inter_max_comm_date")
        structure_hash["fields"]["other_count"]                         = {"data_type"=>"int",      "file_field"=>"Other Count"}                        if field_order.push("other_count")
        structure_hash["fields"]["other_max_comm_date"]                 = {"data_type"=>"date",     "file_field"=>"Other Max Comm Date"}                if field_order.push("other_max_comm_date")
        structure_hash["fields"]["total_missed_interventions"]          = {"data_type"=>"int",      "file_field"=>"Total Missed Interventions"}         if field_order.push("total_missed_interventions")
        structure_hash["fields"]["total_interventions"]                 = {"data_type"=>"int",      "file_field"=>"Total Interventions"}                if field_order.push("total_interventions")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end