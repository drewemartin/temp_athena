#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class REPORT_CARD < Athena_Table
    
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
        params.push( Struct::WHERE_PARAMS.new("studentid", "=", arg ) )
        where_clause = $db.where_clause(params)
        records(where_clause) 
    end
    
    def students_with_records
        $db.get_data_single("SELECT studentid FROM #{table_name} GROUP BY studentid") 
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
                "name"              => "report_card",
                "file_name"         => "report_card.csv",
                "file_location"     => "report_card",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["studentid"]   = {"data_type"=>"int",          "file_field"=>"StudentID"}  if field_order.push("studentid")
            structure_hash["fields"]["lastname"]    = {"data_type"=>"text",         "file_field"=>"LastName"}   if field_order.push("lastname")
            structure_hash["fields"]["firstname"]   = {"data_type"=>"text",         "file_field"=>"FirstName"}  if field_order.push("firstname")
            structure_hash["fields"]["schoolcode"]  = {"data_type"=>"text",         "file_field"=>"schoolcode"} if field_order.push("schoolcode")
            structure_hash["fields"]["coursecode"]  = {"data_type"=>"text",         "file_field"=>"coursecode"} if field_order.push("coursecode")
            structure_hash["fields"]["sectcode"]    = {"data_type"=>"text",         "file_field"=>"SectCode"}   if field_order.push("sectcode")
            structure_hash["fields"]["subject"]     = {"data_type"=>"text",         "file_field"=>"Subject"}    if field_order.push("subject")
            structure_hash["fields"]["period"]      = {"data_type"=>"text",         "file_field"=>"period"}     if field_order.push("period")
            structure_hash["fields"]["teacher"]     = {"data_type"=>"text",         "file_field"=>"Teacher"}    if field_order.push("teacher")
            structure_hash["fields"]["staffcode"]   = {"data_type"=>"text",         "file_field"=>"staffcode"}  if field_order.push("staffcode")
            structure_hash["fields"]["term"]        = {"data_type"=>"text",         "file_field"=>"Term"}       if field_order.push("term")
            structure_hash["fields"]["standard"]    = {"data_type"=>"text",         "file_field"=>"standard"}   if field_order.push("standard")
            structure_hash["fields"]["objective"]   = {"data_type"=>"text",         "file_field"=>"objective"}  if field_order.push("objective")
            structure_hash["fields"]["mark"]        = {"data_type"=>"text",         "file_field"=>"Mark"}       if field_order.push("mark")
            structure_hash["fields"]["percent"]     = {"data_type"=>"decimal(5,4)", "file_field"=>"percent"}    if field_order.push("percent")
            structure_hash["fields"]["comment"]     = {"data_type"=>"text",         "file_field"=>"Comment"}    if field_order.push("comment")
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end