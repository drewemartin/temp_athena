#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class K12_HOME_LANGUAGE < Athena_Table
    
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
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "k12_home_language",
                "file_name"         => "agora_home_language_report.csv",
                "file_location"     => "k12_reports",
                "source_address"    => "https://reports.k12.com/agora/agora_home_language_report.csv",
                "source_type"       => "k12_report",
                "download_times"    => nil,
                "trigger_events"    => nil,
                "audit"             => nil,
                "nice_name"         => "Home Language"
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"               ]   = {"data_type"=>"int",  "file_field"=>"STUDENTID"}                  if field_order.push("student_id"                )
            structure_hash["fields"]["studentlastname"          ]   = {"data_type"=>"text", "file_field"=>"STUDENTLASTNAME"}            if field_order.push("studentlastname"           )
            structure_hash["fields"]["studentfirstname"         ]   = {"data_type"=>"text", "file_field"=>"STUDENTFIRSTNAME"}           if field_order.push("studentfirstname"          )
            structure_hash["fields"]["gradelevel"               ]   = {"data_type"=>"text", "file_field"=>"GRADELEVEL"}                 if field_order.push("gradelevel"                )
            structure_hash["fields"]["schoolenrolldate"         ]   = {"data_type"=>"date", "file_field"=>"SCHOOLENROLLDATE"}           if field_order.push("schoolenrolldate"          )
            structure_hash["fields"]["country"                  ]   = {"data_type"=>"text", "file_field"=>"COUNTRY"}                    if field_order.push("country"                   )
            structure_hash["fields"]["city"                     ]   = {"data_type"=>"text", "file_field"=>"CITY"}                       if field_order.push("city"                      )
            structure_hash["fields"]["state"                    ]   = {"data_type"=>"text", "file_field"=>"STATE"}                      if field_order.push("state"                     )
            structure_hash["fields"]["dateofentryintous"        ]   = {"data_type"=>"date", "file_field"=>"DATEOFENTRYINTOUS"}          if field_order.push("dateofentryintous"         )
            structure_hash["fields"]["name"                     ]   = {"data_type"=>"text", "file_field"=>"NAME"}                       if field_order.push("name"                      )
            structure_hash["fields"]["language"                 ]   = {"data_type"=>"text", "file_field"=>"LANGUAGE"}                   if field_order.push("language"                  )
            structure_hash["fields"]["name"                     ]   = {"data_type"=>"text", "file_field"=>"NAME"}                       if field_order.push("name"                      )
            structure_hash["fields"]["langspeakmost"            ]   = {"data_type"=>"text", "file_field"=>"LANGSPEAKMOST"}              if field_order.push("langspeakmost"             )
            structure_hash["fields"]["langread"                 ]   = {"data_type"=>"text", "file_field"=>"LANGREAD"}                   if field_order.push("langread"                  )
            structure_hash["fields"]["langwrite"                ]   = {"data_type"=>"text", "file_field"=>"LANGWRITE"}                  if field_order.push("langwrite"                 )
            structure_hash["fields"]["attended_three_years_pub" ]   = {"data_type"=>"bool", "file_field"=>"ATTENDED_THREE_YEARS_PUB"}   if field_order.push("attended_three_years_pub"  )
            structure_hash["fields"]["withdrawdate"             ]   = {"data_type"=>"text", "file_field"=>"WITHDRAWDATE"}               if field_order.push("withdrawdate"              )
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end