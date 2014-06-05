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
        tabs.push(["Settings",              settings            ])
        tabs.push(["Scantron",              scantron            ])
        tabs.push(["SE Accommodations",     se_accommodations   ])
       
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
            
        else
            
            return "There are no Scantrons to display for this student."
            
        end
        
    end
    
    def se_accommodations
        
        if record = $focus_student.se_accommodations.existing_record      
            
            se = $tables.attach("SAPPHIRE_STUDENT_SE_ACCOMMODATIONS")
            
            table_array = Array.new
            
            table_array.push([
                
                #SE_SETTING
                $tools.table(
                    :table_array    => [
                        [record.fields["sg6_12"           ].web.default(:disabled=>true, :label_option=>"sg6_12     #{subjects_by_code("sg6_12"     )}", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'sg6-12'        GROUP BY accommodation_code"))],
                        [record.fields["sg5"              ].web.default(:disabled=>true, :label_option=>"sg5        #{subjects_by_code("sg5"        )}", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'sg5'           GROUP BY accommodation_code"))],
                        [record.fields["1_1sep"           ].web.default(:disabled=>true, :label_option=>"1_1sep     #{subjects_by_code("1_1sep"     )}", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP '1-1sep'        GROUP BY accommodation_code"))],
                        [record.fields["1_1home"          ].web.default(:disabled=>true, :label_option=>"1_1home    #{subjects_by_code("1_1home"    )}", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP '1-1home'       GROUP BY accommodation_code"))],
                        [record.fields["1_1onsite"        ].web.default(:disabled=>true, :label_option=>"1_1onsite  #{subjects_by_code("1_1onsite"  )}", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP '1-1onsite'     GROUP BY accommodation_code"))],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank],
                        [blank]
                        
                    ],
                    :unique_name    => "se_setting",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => "SE Setting"
                ),
                
                #SE_ACCOMMODATIONS
                $tools.table(
                    :table_array    => [
                        [record.fields["aims"             ].web.default(:disabled=>true, :label_option=>"aims"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'aims'              GROUP BY accommodation_code")) ],
                        [record.fields["chngsch"          ].web.default(:disabled=>true, :label_option=>"chngsch"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'chngsch'           GROUP BY accommodation_code")) ],
                        [record.fields["bubble"           ].web.default(:disabled=>true, :label_option=>"bubble"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'bubble'            GROUP BY accommodation_code")) ],
                        [record.fields["overlay"          ].web.default(:disabled=>true, :label_option=>"overlay"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'overlay'           GROUP BY accommodation_code")) ],
                        [record.fields["comdev"           ].web.default(:disabled=>true, :label_option=>"comdev"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'comdev'            GROUP BY accommodation_code")) ],
                        [record.fields["enlg"             ].web.default(:disabled=>true, :label_option=>"enlg"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'enlg'              GROUP BY accommodation_code")) ],
                        [record.fields["extraspac"        ].web.default(:disabled=>true, :label_option=>"extraspac", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'extraspac'         GROUP BY accommodation_code")) ],
                        [record.fields["fb20"             ].web.default(:disabled=>true, :label_option=>"fb20"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'fb20'              GROUP BY accommodation_code")) ],
                        [record.fields["fb30"             ].web.default(:disabled=>true, :label_option=>"fb30"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'fb30'              GROUP BY accommodation_code")) ],
                        [record.fields["fb60"             ].web.default(:disabled=>true, :label_option=>"fb60"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'fb60'              GROUP BY accommodation_code")) ],
                        [record.fields["fbwmove"          ].web.default(:disabled=>true, :label_option=>"fbwmove"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'fbwmove'           GROUP BY accommodation_code")) ],
                        [record.fields["lineup"           ].web.default(:disabled=>true, :label_option=>"lineup"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'lineup'            GROUP BY accommodation_code")) ],
                        [record.fields["la9"              ].web.default(:disabled=>true, :label_option=>"la9"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la9'               GROUP BY accommodation_code")) ],
                        [record.fields["la4"              ].web.default(:disabled=>true, :label_option=>"la4"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la4'               GROUP BY accommodation_code")) ],
                        [record.fields["la8"              ].web.default(:disabled=>true, :label_option=>"la8"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la8'               GROUP BY accommodation_code")) ],
                        [record.fields["la2"              ].web.default(:disabled=>true, :label_option=>"la2"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la2'               GROUP BY accommodation_code")) ],
                        [record.fields["la3"              ].web.default(:disabled=>true, :label_option=>"la3"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la3'               GROUP BY accommodation_code")) ],
                        [record.fields["la10"             ].web.default(:disabled=>true, :label_option=>"la10"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la10'              GROUP BY accommodation_code")) ],
                        [record.fields["la14"             ].web.default(:disabled=>true, :label_option=>"la14"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la14'              GROUP BY accommodation_code")) ],
                        [record.fields["la"               ].web.default(:disabled=>true, :label_option=>"la"       , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la'                GROUP BY accommodation_code")) ],
                        [record.fields["la6"              ].web.default(:disabled=>true, :label_option=>"la6"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la6'               GROUP BY accommodation_code")) ],
                        [record.fields["la5"              ].web.default(:disabled=>true, :label_option=>"la5"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la5'               GROUP BY accommodation_code")) ],
                        [record.fields["la7"              ].web.default(:disabled=>true, :label_option=>"la7"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la7'               GROUP BY accommodation_code")) ],
                        [record.fields["la13"             ].web.default(:disabled=>true, :label_option=>"la13"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la13'              GROUP BY accommodation_code")) ],
                        [record.fields["la11"             ].web.default(:disabled=>true, :label_option=>"la11"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la11'              GROUP BY accommodation_code")) ],
                        [record.fields["la12"             ].web.default(:disabled=>true, :label_option=>"la12"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'la12'              GROUP BY accommodation_code")) ],
                        [record.fields["mtr"              ].web.default(:disabled=>true, :label_option=>"mtr"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'mtr'               GROUP BY accommodation_code")) ],
                        [record.fields["ptss"             ].web.default(:disabled=>true, :label_option=>"ptss"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'ptss'              GROUP BY accommodation_code")) ],
                        [record.fields["prefseat"         ].web.default(:disabled=>true, :label_option=>"prefseat" , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'prefseat'          GROUP BY accommodation_code")) ],
                        [record.fields["pswd"             ].web.default(:disabled=>true, :label_option=>"pswd"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'pswd'              GROUP BY accommodation_code")) ],
                        [record.fields["psback"           ].web.default(:disabled=>true, :label_option=>"psback"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'psback'            GROUP BY accommodation_code")) ],
                        [record.fields["psfront"          ].web.default(:disabled=>true, :label_option=>"psfront"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'psfront'           GROUP BY accommodation_code")) ],
                        [record.fields["prompts"          ].web.default(:disabled=>true, :label_option=>"prompts"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'prompts'           GROUP BY accommodation_code")) ],
                        [record.fields["ra"               ].web.default(:disabled=>true, :label_option=>"ra"       , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'ra'                GROUP BY accommodation_code")) ],
                        [record.fields["ramath"           ].web.default(:disabled=>true, :label_option=>"ramath"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'ramath'            GROUP BY accommodation_code")) ],
                        [record.fields["scribe2"          ].web.default(:disabled=>true, :label_option=>"scribe2"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'scribe2'           GROUP BY accommodation_code")) ],
                        [record.fields["stressbal"        ].web.default(:disabled=>true, :label_option=>"stressbal", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'stressbal'         GROUP BY accommodation_code")) ],
                        [record.fields["smab"             ].web.default(:disabled=>true, :label_option=>"smab"     , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'smab'              GROUP BY accommodation_code")) ],
                        [record.fields["siland2"          ].web.default(:disabled=>true, :label_option=>"siland2"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'siland2'           GROUP BY accommodation_code")) ],
                        [record.fields["siland1"          ].web.default(:disabled=>true, :label_option=>"siland1"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'siland1'           GROUP BY accommodation_code")) ],
                        [record.fields["siland3"          ].web.default(:disabled=>true, :label_option=>"siland3"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'siland3'           GROUP BY accommodation_code")) ],
                        [record.fields["tscblgpt"         ].web.default(:disabled=>true, :label_option=>"tscblgpt" , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'tscblgpt'          GROUP BY accommodation_code")) ],
                        [record.fields["tscbmulti"        ].web.default(:disabled=>true, :label_option=>"tscbmulti", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'tscbmulti'         GROUP BY accommodation_code")) ],
                        [record.fields["tscball"          ].web.default(:disabled=>true, :label_option=>"tscball"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'tscball'           GROUP BY accommodation_code")) ],
                        [record.fields["tscbopen"         ].web.default(:disabled=>true, :label_option=>"tscbopen" , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'tscbopen'          GROUP BY accommodation_code")) ],
                        [record.fields["hgl"              ].web.default(:disabled=>true, :label_option=>"hgl"      , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'hgl'               GROUP BY accommodation_code")) ],
                        [record.fields["numline"          ].web.default(:disabled=>true, :label_option=>"numline"  , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'numline'           GROUP BY accommodation_code")) ],
                        [record.fields["scribe"           ].web.default(:disabled=>true, :label_option=>"scribe"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'scribe'            GROUP BY accommodation_code")) ],
                        [record.fields["abacus"           ].web.default(:disabled=>true, :label_option=>"abacus"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'abacus'            GROUP BY accommodation_code")) ],
                        [record.fields["manip"            ].web.default(:disabled=>true, :label_option=>"manip"    , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'manip'             GROUP BY accommodation_code")) ],
                        [record.fields["music"            ].web.default(:disabled=>true, :label_option=>"music"    , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'music'             GROUP BY accommodation_code")) ],
                        [record.fields["reinforce"        ].web.default(:disabled=>true, :label_option=>"reinforce", :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'reinforce'         GROUP BY accommodation_code")) ],
                        [record.fields["wrdprc"           ].web.default(:disabled=>true, :label_option=>"wrdprc"   , :title=>se.field_value("accommodation_desc", "WHERE accommodation_code REGEXP 'wrdprc'            GROUP BY accommodation_code")) ]
                    ],
                    :unique_name    => "se_accommodations",
                    :footers        => false,
                    :head_section   => false,
                    :title          => false,
                    :caption        => "General"
                    
                )
                
            ])
            
            return $tools.table(
                :table_array    => table_array,
                :unique_name    => "se_accommodations_complete",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => false
            )
            
        else
            
            return "There are no SE Accommodations to display for this student."
            
        end
        
        
    end
    
    def settings
        
        $focus_student.assessment.existing_record || $focus_student.assessment.new_record.save         
        
        table_array = Array.new
        
        table_array.push([
            
            #ELIGIBILITIES
            $tools.table(
                :table_array    => [
                    [$focus_student.assessment.pasa_eligible.web.default(           :label_option=>"PASA"                         )],
                    [$focus_student.assessment.religious_exempt.web.default(        :label_option=>"PASA/PSSA Religious Exemption")],
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
    
    def subjects_by_code(code)
        
        results = $db.get_data_single(
            
            "SELECT GROUP_CONCAT(DISTINCT LEFT(assessment_type_code,3))
            FROM agora_sapphire.sapphire_student_se_accommodations
            WHERE student_id = '#{$focus_student.student_id.value}'
            AND accommodation_code REGEXP '#{code.gsub("_","-")}'"
            
        )
        
        return results ? results[0] : ""
        
    end
    
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
        
        output << "table#se_accommodations_complete label{display:    inline-block;   }"
        output << "table#se_accommodations_complete input{float:      left;           }"
        
#<td class="column_0" style="">
#<div class="STUDENT_SE_ACCOMMODATIONS__la10 " title="Local Assess - Print out test">
#<label for
        
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