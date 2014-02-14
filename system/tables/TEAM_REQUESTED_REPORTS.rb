#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class TEAM_REQUESTED_REPORTS < Athena_Table
    
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

    def requested_datatable(tid)
        
        tables_array = Array.new
     
        #HEADERS
        tables_array.push([
            "Link",
            "Report Name",
            "Requested Date",
            "Expiration Date"
        ])
        
        pids = primary_ids("WHERE team_id = '#{tid}' AND expiration_date >= NOW()")
        
        pids.each do |pid|
            
            record = by_primary_id(pid)
            
            tables_array.push(
                [
                    create_link(record),
                    record.fields["report_name"].value.split("_").map{|x| x.capitalize}.join(" "),
                    record.fields["created_date"].to_user,
                    record.fields["expiration_date"].to_user
                ]
            )
            
        end if pids
        
        return $tools.data_table(tables_array, "requested_reports")
        
    end
    
    def create_link(record)
        
        output = String.new
        
        hidden_date = "<div style='display:none;'>#{record.fields["expiration_date"].to_user}</div>"
        
        case record.fields["status"].value
        when "Requested"
            return "#{hidden_date}File Requested"
        when "Generating"
            return "#{hidden_date}Generating File"
        when "Ready"
            ex_date = record.fields["expiration_date"].value
            
            if $idatetime >= ex_date
                
                return "#{hidden_date}Expired"
                
            else
                
                hidden_input = "<input id='ex_date__#{record.primary_id}' type='hidden' value='#{record.fields["expiration_date"].to_user}'></input>"
                return "<div style='display:none;'>#{record.fields["expiration_date"].to_user}</div><a id='request_file_link__#{record.primary_id}' class='request_file_link' href='/temp/#{record.fields["file_name"].value}'>Download File</a>#{hidden_input}"
                
            end
        end
        
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
                :data_base          => "#{$config.school_name}_master",
                "name"              => "team_requested_reports",
                "file_name"         => "team_requested_reports.csv",
                "file_location"     => "team_requested_reports.csv",
                "source_address"    => nil,
                "source_type"       => nil,
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
            structure_hash["fields"]["team_id"         ] = {"data_type"=>"int",      "file_field"=>"team_id"            } if field_order.push("team_id")
            structure_hash["fields"]["report_name"     ] = {"data_type"=>"text",     "file_field"=>"report_name"        } if field_order.push("report_name")
            structure_hash["fields"]["file_name"       ] = {"data_type"=>"text",     "file_field"=>"file_name"          } if field_order.push("file_name")
            structure_hash["fields"]["status"          ] = {"data_type"=>"text",     "file_field"=>"status"             } if field_order.push("status")
            structure_hash["fields"]["expiration_date" ] = {"data_type"=>"datetime", "file_field"=>"expiration_date"    } if field_order.push("expiration_date")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end