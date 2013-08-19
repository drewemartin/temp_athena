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
        
        add_new_button = @disabled ? "" : $tools.button_new_row(table_name = "SCHOOL_CALENDAR")
        return "School Year Setup"
        
    end
    
    def load
        
        output = String.new
        output << $tables.attach("SCHOOL_YEAR_DETAIL").field_by_pid("start_date",   "1").web.default(   :disabled=>@disabled, :label_option=>"First Day of School:")
        output << $tables.attach("SCHOOL_YEAR_DETAIL").field_by_pid("end_date",     "1").web.default(   :disabled=>@disabled, :label_option=>"Last Day of School:")
        output << $tables.attach("SCHOOL_YEAR_DETAIL").field_by_pid("finalized",    "1").web.select(    :disabled=>@disabled, :label_option=>"Calendar Finalized?", :dd_choices=>$dd.bool)
        
        return "#{output}#{school_holidays}"
        
    end
    
    def response
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def school_holidays
        
        table_array = Array.new
        
        add_new_button = @disabled ? "" : $tools.button_new_row(table_name = "SCHOOL_CALENDAR")
        
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
        
       return "<div
            class='student_container'
            id='student_container'>
            #{add_new_button}#{$tools.data_table(table_array, "school_calendar")}
        </div>"
        
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
    
    def add_new_record_school_year_detail
        
        #PROVIDE A DROP DOWN WITH THE AVAILABLE SCHOOL YEARS TO ADD
        #THIS SHOULD BE A RANGE OF THE LAST ADDED SCHOOL YEAR TO THE NEXT SCHOOL YEAR
        #WHERE THE SCHOOL YEAR DOES NOT ALREADY EXIST.
        
        #ONCE THE SCHOOL YEAR IS SELECTED IT SHOULD HIT A FILL SELECT FUNCTION
        #THIS FUNCTION WILL CREATE THE NEW SCHOOL YEAR AND INIT THE SCHOOL YEAR CALENDAR TABLES
        
        #ONCE THE SCHOOL YEAR CALENDAR IS FINALIZED A PROCESS WILL BE QUEUED TO INITIALIZE
        #THE REMAINDER OF THE TABLE.
        
        
        
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