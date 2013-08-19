#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("data_processing","base")}/base"

class STUDENT_ILP_PROCESSES < Base

    def initialize(arg = [])
        super()
    end
    
    def reeval_reminders
        
        if team_members = $tables.attach("STUDENT_ILP").find_fields(
            "created_by",
            "WHERE expiration_date = CURDATE()
            GROUP BY created_by",
            {:value_only=>true}
        )
            
            team_members.each{|email|
                
                tables_array = [
                    headers = [
                        "ILP ID",
                        "Student ID",
                        "Category",
                        "Type"
                    ]
                ]
                
                ilp_ids = $tables.attach("STUDENT_ILP").primary_ids(
                    "WHERE expiration_date = CURDATE()
                    AND created_by = '#{email}'"
                )
                
                ilp_ids.each{|pid|
                    
                    ilp = $tables.attach("STUDENT_ILP"          ).by_primary_id(pid)
                    cat = $tables.attach("ILP_ENTRY_CATEGORY"   ).field_by_pid("name", ilp.fields["ilp_entry_category_id"   ].value).value
                    typ = $tables.attach("ILP_ENTRY_TYPE"       ).field_by_pid("name", ilp.fields["ilp_entry_type_id"       ].value).value
                    
                    tables_array.push(
                        
                        row = [
                            ilp.primary_id,
                            ilp.fields["student_id"].value,
                            cat,
                            typ
                        ]
                        
                    )
                    
                }
                
                file_path = $reports.save_document({
                    :csv_rows        => tables_array,
                    :category_name   => "Individualized Learning Plan",
                    :type_name       => "Student ILP",
                    :document_relate => [
                        {
                            :table_name      => "TEAM",
                            :key_field       => "primary_id",
                            :key_field_value => $team.find(:email_address=>email).primary_id.value
                        }
                    ]
                })
                
                ilps_table = $base.web_tools.table(
                    :table_array    => tables_array,
                    :unique_name    => "ilp_reminder",
                    :footers        => false,
                    :head_section   => true,
                    :title          => false,
                    :caption        => false,
                    :embedded_style => {
                        :table  => "font-family:\"Trebuchet MS\", Arial, Helvetica, sans-serif; width:100%; border-collapse:collapse;",
                        :th     => "font-size:1.4em; border:1px solid #98bf21; text-align:left; padding-top:5px; padding-bottom:4px; background-color:#A7C942; color:#fff;",
                        :tr     => nil,
                        :tr_alt => "color:#000; background-color:#EAF2D3;",
                        :td     => "font-size:1.2em; border:1px solid #98bf21; padding:3px 7px 2px 7px;",
                    }
                )
                
                content = "<br><br>#{ilps_table}<br><br>"
                
                $team.find(:email_address=>email).send_email(
                    :subject                => "ILP Re-Evaluation Reminder",        
                    :content                => content,         
                    :sender                 => nil,
                    :additional_recipients  => nil,
                    :attachment_name        => "ILP Re-Evaluation Reminder #{$idate}.csv", 
                    :attachment_path        => file_path#,
                    #:email_relate           => [
                    #    {:table_name=>nil, :key_field=>nil, :key_field_value=>nil}
                    #]
                ) 
                
            }
            
        end
        
    end
    
end