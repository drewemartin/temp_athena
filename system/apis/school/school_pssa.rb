#!/usr/local/bin/ruby

class School_Pssa

    #---------------------------------------------------------------------------
    def initialize()
        @structure   = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def accommodations
        $tables.attach("Pssa_Accommodations").complete
    end
    
    def participating_students
        $tables.attach("PSSA_PARTICIPATION").student_with_records
    end
    def sites
        $tables.attach("Pssa_Sites").by_schoolyear()
    end
    
    def site_id_by_site_name(site_name)
        $tables.attach("Pssa_Sites").pid_by_field(field_name="site_name", site_name)
    end
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DD_Choices
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attendance_codes
        $tables.attach("Attendance_Codes").nva({:name_field=> "code_type",:value_field=>"code",:clause_string => "WHERE code REGEXP 'pssa'"})
    end
    
    def special_test_types_dd
        output = []
        output.push({:name=>"Braille", :value=>"Braille"})
        output.push({:name=>"Large Print", :value=>"Large Print"})
        return output
    end
    
    def test_types_dd
        return $tables.attach("State_Tests").dd_choices("name", "name", "WHERE category = 'PSSA'")
    end
    
    def sites_dd
        return $tables.attach("Pssa_Sites").dd_choices("site_name", "primary_id")
    end
    
    def accommodation_dd
        return $tables.attach("Pssa_Accommodations").dd_choices("CONCAT(subject,' - ',accommodation)", "primary_id")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def pssa_site_dates(site_id = $user.pssa_site_id.value)
        site_record = $tables.attach("Pssa_Sites").by_primary_id(site_id)
        if !site_record.fields["start_date"].value.nil?
            date = site_record.fields["start_date"]
            now = DateTime.now
            site_dates  = Array.new
            5.times{
                site_dates.push(date.value)
                date.add!
            }
            return site_dates
        else
            return false
        end
    end
    
    def site_reminder_content(site_id)
        if !structure.has_key?("#{site_id}_reminder_content".to_sym)
            site_fields = $tables.attach("Pssa_Sites").by_primary_id(site_id).fields
            
            file_content = File.open("#{$config.import_path}pssa_site_kmail_content/pssa_site_reminder_template.txt", "rb").read.gsub("\r","").gsub("\t","")
            file_content.gsub!("|site_name|"           , site_fields["site_name"   ].value                                               )
            file_content.gsub!("|start_date|"          , site_fields["start_date"  ].mathable.strftime("%A %B %e")                       )
            file_content.gsub!("|end_date|"            , site_fields["end_date"    ].mathable.strftime("%A %B %e")                       )
            file_content.gsub!("|mon|"                 , mon  = site_fields["start_date"  ].mathable.strftime("%A %B %e")                )
            file_content.gsub!("|tues|"                , tues = site_fields["start_date"  ].add!(:object).mathable.strftime("%A %B %e")  )
            file_content.gsub!("|wed|"                 , wed  = site_fields["start_date"  ].add!(:object).mathable.strftime("%A %B %e")  )
            file_content.gsub!("|thur|"                , thur = site_fields["start_date"  ].add!(:object).mathable.strftime("%A %B %e")  )
            file_content.gsub!("|fri|"                 , fri  = site_fields["start_date"  ].add!(:object).mathable.strftime("%A %B %e")  )
            file_content.gsub!("|math_reading_dates|"  , "#{mon} - #{wed}"                                                               )
            file_content.gsub!("|science_dates|"       , thur                                                                            )
            file_content.gsub!("|writing_dates|"       , fri                                                                             )
            file_content.gsub!("|location|"            , site_fields["location"     ].value || ""                                        )
            file_content.gsub!("|address|"             , site_fields["address"      ].value || ""                                        )
            file_content.gsub!("|city|"                , site_fields["city"         ].value || ""                                        )
            file_content.gsub!("|state|"               , site_fields["state"        ].value || ""                                        )
            file_content.gsub!("|zip_code|"            , site_fields["zip_code"     ].value || ""                                        )
            file_content.gsub!("|site_url|"            , site_fields["site_url"     ].value || ""                                        )
            file_content.gsub!("|directions|"          , site_fields["directions"   ].value || ""                                        )
            
            structure["#{site_id}_reminder_content".to_sym] = file_content
        end
        structure["#{site_id}_reminder_content".to_sym]
    end
    
    def site_name_by_id(site_id)
        $tables.attach("Pssa_Sites").field_bysiteid("site_name", site_id)
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
end