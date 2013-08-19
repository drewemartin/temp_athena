#!/usr/local/bin/ruby

class RTII_BEHAVIOR_VAULT_WEB

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def breakaway_caption
        return "RTII Behavior Vault"
    end
    
    def page_title
        return "RTII Behavior Vault"
    end
    
    def load
        rtii_vault
    end
    
    def response
        
        if $kit.params[:add_new_RTII_VAULT]
            $kit.modify_tag_content("breakaway_container", rtii_vault, "update")
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
 
    def rtii_vault 
        
        table_array = Array.new
        
        add_new_button = $tools.button_new_row(table_name = "RTII_VAULT")
        
        table_array.push(
            
            #HEADERS
            [
                "skill_group",
                "targeted_behavior",
                "intervention"
            ]
            
        )
        
        pids = $tables.attach("RTII_VAULT").primary_ids
        pids.each{|pid|
            
            record = $tables.attach("RTII_VAULT").by_primary_id(pid)    
            table_array.push(
                [
                    record.fields["skill_group"         ].value,
                    record.fields["targeted_behavior"   ].value,
                    record.fields["intervention"        ].value
                ]
            )
            
        } if pids
       return "<div
            class='student_container'
            id='student_container'>
            #{add_new_button}#{$tools.data_table(table_array, "rtii_vault")}
        </div>"
        
    end

    def add_new_record_rtii_vault 
        
        output = String.new
        
        output << $tools.div_open("rtii_vault_container", "rtii_vault_container")
        
        row = $tables.attach("RTII_VAULT").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "RTII Details")
        
            output << fields["skill_group"].web.text(:label_option=>"Skill Group:")
            output << fields["targeted_behavior"].web.text(:label_option=>"Targeted Behavior:")
            output << fields["intervention"].web.text(:label_option=>"Intervention:")
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def intervention_dd
        return $tables.attach("RTII_VAULT").dd_choices(
            "intervention",
            "primary_id",
            "intervention"
        )
    end
    
    def skill_group_dd
        return $tables.attach("RTII_VAULT").dd_choices(
            "skill_group",
            "primary_id",
            "skill_group"
        )
    end
    
    def targeted_behavior_dd
        return $tables.attach("RTII_VAULT").dd_choices(
            "targeted_behavior",
            "primary_id",
            "targeted_behavior"
        )
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def css
        output = "<style>
        
        #new_row_button_RTII_VAULT{                     margin-bottom:10px;}
        
        div.RTII_VAULT__skill_group         {margin-bottom: 2px;}
        div.RTII_VAULT__targeted_behavior   {margin-bottom: 2px;}
        div.RTII_VAULT__intervention        {margin-bottom: 2px;}
        
        div.RTII_VAULT__skill_group         label{display: inline-block; width: 130px;}
        div.RTII_VAULT__targeted_behavior   label{display: inline-block; width: 130px;}
        div.RTII_VAULT__intervention        label{display: inline-block; width: 130px;}
        
        </style>"
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