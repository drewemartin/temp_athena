#!/usr/local/bin/ruby

class COURSE_RELATE_WEB

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return "Course Relate"
    end
    
    def page_title
        return "Course Relate"
    end
    
    def load
        course_relate
    end
    
    def response
        course_relate
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def course_relate 
        
        output = "<div id='student_container'>"
        
        table_array = Array.new
        
        table_array.push(
            
            #HEADERS
            [
                "Course Name",
                "Scantron Math Growth",
                "Scantron Reading Growth",
                "Scantron Math Participation",
                "Scantron Reading Participation"
            ]
            
        )
        
        pids = $tables.attach("COURSE_RELATE").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("COURSE_RELATE").by_primary_id(pid)    
            table_array.push(
                [
                    record.fields["course_name"                     ].value,
                    record.fields["scantron_growth_math"            ].web.select({:dd_choices=>$dd.bool}, true),
                    record.fields["scantron_growth_reading"         ].web.select({:dd_choices=>$dd.bool}, true),
                    record.fields["scantron_participation_math"     ].web.select({:dd_choices=>$dd.bool}, true),
                    record.fields["scantron_participation_reading"  ].web.select({:dd_choices=>$dd.bool}, true)
                ]
            )
            
        } if pids
       
        output << $tools.data_table(table_array, "course_relate")
        
        output << "</div>"
    
        return output
    #$tools.table(
    #        :table_array    => table_array,
    #        :unique_name    => "course_relate",
    #        :footers        => false,
    #        :head_section   => false,
    #        :title          => false,
    #        :caption        => false
    #    )
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def css
        output = "<style>"
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