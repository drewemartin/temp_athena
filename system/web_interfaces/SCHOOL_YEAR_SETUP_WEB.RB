#!/usr/local/bin/ruby

class SCHOOL_YEAR_SETUP_WEB

    #---------------------------------------------------------------------------
    def initialize()
        if !$tables.attach("SCHOOL_YEAR_DETAIL").primary_ids
            $tables.attach("SCHOOL_YEAR_DETAIL").new_row.save
        end
        @disabled = $tables.attach("SCHOOL_YEAR_DETAIL").field_by_pid("finalized", "1").is_true? ? true : false
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        
        return "School Year Setup"
        
    end
    
    def page_title
        
        return "School Year Setup"
        
    end
    
    def load 
        
        "<div class='school_year_content' id='school_year_content'>#{school_year_content}</div>"
        
    end
    
    def response
        if $kit.params.has_key?(:school_year)
            $kit.modify_tag_content("school_year_content", school_year_content, "update")
        end
    end
    
    def school_year_content
        
        output = String.new
        
        record = $tables.attach("SCHOOL_YEAR_DETAIL").record("WHERE school_year = '#{$config.school_year}'")
        output << record.fields["start_date"        ].web.default(   :disabled=>@disabled, :label_option=>"First Day of School:")
        output << record.fields["end_date"          ].web.default(   :disabled=>@disabled, :label_option=>"Last Day of School:")
        output << record.fields["finalized"         ].web.select(    :disabled=>@disabled, :label_option=>"Calendar Finalized?", :dd_choices=>$dd.bool)
        
        output << school_holidays
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FILL_SELECT_OPTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def fill_select_option_breakaway_container(field_name, field_value, pid)
        
        #PROVIDE A DROP DOWN WITH THE AVAILABLE SCHOOL YEARS TO ADD
        #THIS SHOULD BE A RANGE OF THE LAST ADDED SCHOOL YEAR TO THE NEXT SCHOOL YEAR
        #WHERE THE SCHOOL YEAR DOES NOT ALREADY EXIST.
        
        #ONCE THE SCHOOL YEAR IS SELECTED IT SHOULD HIT A FILL SELECT FUNCTION
        #THIS FUNCTION WILL CREATE THE NEW SCHOOL YEAR AND INIT THE SCHOOL YEAR CALENDAR TABLES
        
        #ONCE THE SCHOOL YEAR CALENDAR IS FINALIZED A PROCESS WILL BE QUEUED TO INITIALIZE
        #THE REMAINDER OF THE TABLE.
        
        $config.school_year = field_value
        
        if !$tables.attach("SCHOOL_CALENDAR").exists?
            
            $tables.attach("SCHOOL_CALENDAR" ).init
            
            new_school_year = $tables.attach("SCHOOL_YEAR_DETAIL" ).new_row
            new_school_year.fields["school_year"].value = field_value
            new_school_year.save
           
        end
        
        "#{breakaway_caption} #{load}"
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def school_holidays
        
        output      = String.new
        
        table_array = Array.new
        
        output << $tools.button_new_row(table_name = "SCHOOL_CALENDAR")
        
        table_array.push(
            
            #HEADERS
            [
                "Date",
                "Type",
                "Details"
            ]
            
        )
        
        pids = $tables.attach("SCHOOL_CALENDAR").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("SCHOOL_CALENDAR").by_primary_id(pid)    
            table_array.push(
                [
                    record.fields["date"    ].to_user,
                    record.fields["type"    ].value,
                    record.fields["details" ].value
                ]
            )
            
        } if pids
        
        output << $tools.data_table(table_array, "school_holidays")
        
    end
    
    def add_new_record_school_calendar 
        
        table_array = Array.new
        
        table_array.push(
            
            #HEADERS
            [
                "Date",
                "Type",
                "Details"
            ]
            
        )
        
        record = $tables.attach("SCHOOL_CALENDAR").new_row
        
        table_array.push(
            [
                record.fields["date"    ].web.default,
                record.fields["type"    ].web.select(:dd_choices=>[
                        {:name=>"Holiday",  :value=>"holiday"   },
                        {:name=>"Other",    :value=>"Other"     }
                    ]
                ),
                record.fields["details" ].web.select(:dd_choices=>[
                        {:name=>"Martin Luther King Day"        , :value=>"Martin Luther King Day"        },
                        {:name=>"Memorial Day"                  , :value=>"Memorial Day"                  },
                        {:name=>"Presidents Day"                , :value=>"Presidents Day"                },
                        {:name=>"Professional Development"      , :value=>"Professional Development"      },
                        {:name=>"Spring Break"                  , :value=>"Spring Break"                  },
                        {:name=>"Teacher Inservice"             , :value=>"Teacher Inservice"             },
                        {:name=>"Thanksgiving"                  , :value=>"Thanksgiving"                  },
                        {:name=>"Winter Break"                  , :value=>"Winter Break"                  }
                    ]
                )
            ]
        )
       
        return $tools.data_table(table_array, "school_calendar", type = "NewRecord")
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def css
        output = "<style>"
        
        output << "
            
            div.SCHOOL_YEAR_DETAIL__start_date  {margin-bottom: 5px;}
            div.SCHOOL_YEAR_DETAIL__end_date    {margin-bottom: 5px;}
            div.SCHOOL_YEAR_DETAIL__finalized   {margin-bottom: 5px;}
            div.school_year_content             {margin-bottom: 15px;}
            
        "
        
        output << "</style>"
        return output
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type='text/javascript'>"
        output << "</script>"
        return output
    end
    
end