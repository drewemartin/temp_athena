#!/usr/local/bin/ruby


class TEAM_MEMBER_CHARTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
      
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Evaluations Chart"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
    end
    
    def response
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def team_member_record(tid = $kit.params[:tid])
        return summary
        eval_type       = $focus_team_member.department.fields["type"].value
        
        tabs = Array.new
        tabs.push(["Summary",                   summary ])
        
        #if eval_type == "Engagement"
        #    
        #    tabs.push(["Metrics",           engagement_metrics           ]) 
        #    tabs.push(["Observation",       engagement_observation       ])
        #    tabs.push(["Professionalism",   engagement_professionalism   ])
        #    
        #end
        
        $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            tab_id          = "evaluation",
            search          = false
        )
        
    end
    
    def summary
        
        included_fields = [
            
            #"students",
            #"all_students",
            
            "new:New Students",
            "in_year:Enrolled In Year",
            "low_income:Economically Disadvantaged",
            "tier_23:Tier 2/3",
            "special_ed:Special Education",
            "grades_712:Grades 7-12",
            "scantron_participation_fall:Scantron Participation Fall",
            "scantron_participation_spring:Scantron Participation Spring",
            
            #"scantron_growth",
            #"aims_participation_fall",
            #"aims_participation_spring",
            #"aims_growth",
            #"study_island_participation",
            #"study_island_participation_tier_23",
            #"study_island_achievement",
            #"study_island_achievement_tier_23",
            #"define_u_participation",
            #"pssa_participation",
            #"keystone_participation",

            "attendance_rate:Attendance Rate",
            "retention_rate:Retention Rate"#,
            #"engagement_level",
            #"score"
            
        ]
        
        data_points = Array.new
        included_fields.each{|field_name|
            
            field_name = field_name.split(":")
            data_points.push($focus_team_member.evaluation_summary_snapshot.field_values_to_user(field_name[0], where_addon = "GROUP BY created_date ASC").insert(0,field_name[1]))
            
        }
        
        xAxis_categories = $focus_team_member.evaluation_summary_snapshot.field_values("DATE_FORMAT(created_date, '%c/%e')", where_addon = "GROUP BY created_date ASC")
        
        $tools.line_chart(
            :data_points       => data_points, #array of arrays
            :class             => "test", #string
            :title             => "test", #string
            :subtitle          => "test", #string
            :xAxis_categories  => xAxis_categories, #array
            :yAxis_title       => "test"  #string
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________UPLOAD_PDF_FORMS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
   
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
        
        output = "<script type=\"text/javascript\">"
        output << "</script>"
        
        return output
    end
    
end