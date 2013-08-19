#!/usr/local/bin/ruby


class STUDENT_ASSESSMENTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "Assessments"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record
        
        tabs = Array.new
        tabs.push(["Settings",            settings   ])
        tabs.push(["Scantron",            scantron   ])
       
        $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            tab_id          = "assessments",
            search          = false
        )
        
    end
    
    def scantron
        
        if $focus_student.scantron_performance_level.existing_record
            
            return $tools.table(
                :table_array    => [
                    [
                        $tools.table(
                            :table_array    => [
                                ["Performance Level"],
                                ["Score"            ],
                                ["Test Date"        ],
                                ["NCE"              ],
                                ["Growth"           ]
                            ],
                            :unique_name    => "scantron_headers",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :caption        => blank
                        ),
                        $tools.table(
                            :table_array    => [
                                [$focus_student.scantron_performance_level.stron_ent_perf_m.value         ],
                                [$focus_student.scantron_performance_level.stron_ent_score_m.value        ],
                                [$focus_student.scantron_performance_level.stron_ent_test_date_m.to_user  ],
                                [$focus_student.scantron_performance_level.stron_ent_nce_m.value          ],
                                [$focus_student.scantron_performance_level.growth_math.to_user            ]   
                            ],
                            :unique_name    => "scantron_sub",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :caption        => "Math Entrance" 
                        ),
                        $tools.table(
                            :table_array    => [
                                [$focus_student.scantron_performance_level.stron_ext_perf_m.value          ], 
                                [$focus_student.scantron_performance_level.stron_ext_score_m.value         ], 
                                [$focus_student.scantron_performance_level.stron_ext_test_date_m.to_user   ], 
                                [$focus_student.scantron_performance_level.stron_ext_nce_m.value           ],
                                [""                                                                        ]
                            ],
                            :unique_name    => "scantron_sub",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :caption        => "Math Exit" 
                        ),
                        $tools.table(
                            :table_array    => [
                                [$focus_student.scantron_performance_level.stron_ent_perf_r.value        ],
                                [$focus_student.scantron_performance_level.stron_ent_score_r.value       ],
                                [$focus_student.scantron_performance_level.stron_ent_test_date_r.to_user ],
                                [$focus_student.scantron_performance_level.stron_ent_nce_r.value         ],
                                [$focus_student.scantron_performance_level.growth_reading.to_user        ]   
                            ],
                            :unique_name    => "scantron_sub",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :caption        => "Reading Entrance" 
                        ),
                        $tools.table(
                            :table_array    => [
                                [$focus_student.scantron_performance_level.stron_ext_perf_r.value         ],
                                [$focus_student.scantron_performance_level.stron_ext_score_r.value        ],
                                [$focus_student.scantron_performance_level.stron_ext_test_date_r.to_user  ],
                                [$focus_student.scantron_performance_level.stron_ext_nce_r.value          ],
                                [""                                                                       ]   
                            ],
                            :unique_name    => "scantron_sub",
                            :footers        => false,
                            :head_section   => false,
                            :title          => false,
                            :caption        => "Reading Exit" 
                        )
                    ]
                ],
                :unique_name    => "scantron",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
        end
        
    end
    
    def settings
        
        $focus_student.assessment.existing_record || $focus_student.assessment.new_record.save         
        
        table_array = Array.new
        
        table_array.push([
            
            #ELIGIBILITIES
            $tools.table(
                :table_array    => [
                    [$focus_student.assessment.pasa_eligible.web.default(             :label_option=>"PASA"                         )],
                    [blank],
                    [blank],
                    [blank],
                    [blank],
                    [blank]
                    
                ],
                :unique_name    => "eligibilities",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Eligibilities"
            ),
            #EXEMPTIONS
            $tools.table(
                :table_array    => [
                    [$focus_student.assessment.aims_exempt.web.default(             :label_option=>"AIMS"                           )],
                    [$focus_student.assessment.scantron_exempt_ent_m.web.default(   :label_option=>"Scantron Entrance Math"         )],
                    [$focus_student.assessment.scantron_exempt_ent_r.web.default(   :label_option=>"Scantron Entrance Reading"      )],
                    [$focus_student.assessment.scantron_exempt_ext_m.web.default(   :label_option=>"Scantron Exit Math"             )],
                    [$focus_student.assessment.scantron_exempt_ext_r.web.default(   :label_option=>"Scantron Exit Reading"          )],
                    [$focus_student.assessment.study_island_exempt.web.default(     :label_option=>"Study Island"                   )]
                ],
                :unique_name    => "exemptions",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Exemptions"
            ),
            #ENGAGEMENT TIER
            $tools.table(
                :table_array    => [
                    [$focus_student.assessment.tier_level_math.web.select(          :label_option=>"Tier Level Math",    :dd_choices=> $dd.range(1,3)   )],
                    [$focus_student.assessment.tier_level_reading.web.select(       :label_option=>"Tier Level Reading", :dd_choices=> $dd.range(1,3)   )],
                    [$focus_student.assessment.engagement_level.web.select(         :label_option=>"Engagement Level",   :dd_choices=> $dd.range(1,3)   )],
                    [blank],
                    [blank],
                    [blank]
                ],
                :unique_name    => "other",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Engagement/Tier Level"
            )
            
        ])
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "settings",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
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
    
    def blank
        "<div style='opacity:0;'>Nothing to Display</div>"
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        
        output << "div#tabs_assessments .ui-tabs-nav {
            font-size: x-small;
        }"
        
        output << "table#settings{
            width       : 100%;
            height      : 100%;
            font-size   : small;
            text-align  : left;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#settings      caption{ font-size: medium; text-align:left;}"
        output << "table#settings           td{ height:30px; width:33%}"
        
        output << "table#settings table{
            width       : 100%;
            height      : 100%;
            font-size   : small;
            text-align  : left;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#settings table         td{ height:30px;}"
        output << "table#settings table        div{ float:left; width:100%; margin-bottom:2px;}"
        output << "table#settings table      input{ float:left;}"
        output << "table#settings table     select{ float:left; margin-left:4px; margin-right:2px;}"
        output << "table#settings table      label{ width:80%; display:inline-block;}"
        output << "table#settings table .even_row {
            background-color: #AED0EA;
        }"
        output << "table#settings table  .odd_row {
            background-color: #E1E1E1;
        }"
        
        output << "table#scantron{
            width       : 100%;
            height      : 100%;
            font-size   : small;
            text-align  : left;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#scantron      caption{ font-size: medium; text-align:center;}"
        output << "table#scantron           td{ height:30px; width:20%}"
        
        output << "table#scantron_headers     { font-size: medium; text-align:left;}"
        output << "table#scantron_headers   td{ text-align:right;}"
        
        output << "table#scantron_sub{
            width       : 100%;
            height      : 100%;
            font-size   : small;
            text-align  : left;
            margin-left : auto;
            margin-right: auto;
        }"
        output << "table#scantron_sub           td{ text-align:center;}"
        output << "table#scantron_sub   .even_row {
            background-color: #AED0EA;
        }"
        output << "table#scantron_sub   .odd_row {
            background-color: #E1E1E1;
        }"
        
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end