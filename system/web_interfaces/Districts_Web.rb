#!/usr/local/bin/ruby


class DISTRICTS_WEB
    #---------------------------------------------------------------------------
    def load
        output = String.new
        output = $tools.tab_identifier(1)
        output = $kit.tools.tabs([["Districts", districts]])
        return output
    end
    
    def breakaway_caption
        return "Districts"
    end
    
    def page_title
        return "Districts"
    end
    
    #---------------------------------------------------------------------------    
    def response
        if $kit.params[:add_content]
            var = $kit.params[:add_content]
            expansionContent(var)
        end
        if $kit.params[:field_id____DISTRICTS__district]
            var = $kit.params[:field_id____DISTRICTS__district][0,1].downcase
            expansionContent(var)
        end
    end
    
    def districts
        output  = String.new
        output << $tools.div_open("letters")
        ("a".."z").each{|letter|
            output << "<button class='letter_button' id='#{letter}' name='add_content' value='#{letter}' onclick='send_unsaved\(\); send\(this.id\); $\(\"#alphabet_results\"\).html\(\"Loading Districts Beginning With - #{letter.upcase}\"\);'>#{letter.upcase}</button>"
        }
        output << $tools.button_new_row(table_name = "Districts")
        output << $tools.div_close
        output << $tools.div_open("alphabet_results", "alphabet_results")
        output << $tools.div_close
        return output
    end
    
    def districts_by_letter(letter)
        output  = String.new
        districts = $tables.attach("Districts").by_letter(letter, nil, true)
        if districts
            districts.each do |district|
                info        = String.new
                name        = district.fields["district"].value
                title       = "District "
                title      << $tools.newlabel("district_name", name)
                output     << $tools.expandable_section(title,  "", name.gsub(" ", "9"))
            end
        else
            output << $tools.newlabel("no_results", "There Are No Districts Beginning With The Letter \"#{letter.upcase}\"")
        end
        output << $tools.newlabel("bottom")
        $kit.modify_tag_content("alphabet_results", output, "update")
    end
    
    def expand_district(name)
        results_name = name.gsub("9", " ")
        output  = String.new
        records = $tables.attach("Districts").by_district(results_name)
        if records
            output << $tools.div_open("districts")
            records.each do |record|
                fields = record.fields
                output << $tools.div_open("district")
                output << fields["contact_department"].web.label({:label_option=>""})
                output << fields["district"].web.text(           {:label_option=>"District Name:"})
                output << fields["contact_first_name"].web.text( {:label_option=>"Contact First Name:"})
                output << fields["contact_last_name"].web.text(  {:label_option=>"Contact Last Name:"})
                output << fields["contact_email"].web.text(      {:label_option=>"Email:"})
                output << fields["contact_phone"].web.text(      {:label_option=>"Phone:"})
                output << fields["contact_fax"].web.text(        {:label_option=>"Fax:"})
                output << $tools.div_close
            end
            output << $tools.newlabel("bottom")
            output << $tools.div_close
        end
        output << $tools.newlabel("bottom")
        return output
    end

    
    def expansionContent(id)
        output = String.new
        case id
        when /^[a-z]$/
            districts_by_letter(id)
        when /^\d+$/
            districts_record(id)
        when /^[a-zA-Z]+/
            districts_records(id)
        end
    end
    
    def add_new_record_districts
        output  = String.new
        
        output << $tools.div_open("new_record_districts_container", "new_record_districts_container")
        
        row  = $tables.attach("Districts").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "District Details")
        
            fields["contact_department"].value = "Withdrawals"
            output << fields["contact_department"].web.select({:label_option=>"Department", :dd_choices=>departments_dd}, true)
            output << fields["district"].web.text(            {:label_option=>"District Name:"})
            output << fields["contact_first_name"].web.text(  {:label_option=>"Contact First Name:"})
            output << fields["contact_last_name"].web.text(   {:label_option=>"Contact Last Name:"})
            output << fields["contact_email"].web.text(       {:label_option=>"Email:"})
            output << fields["contact_phone"].web.text(       {:label_option=>"Phone:"})
            output << fields["contact_fax"].web.text(         {:label_option=>"Fax:"})
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
    end
    
    def departments_dd
        return $tables.attach("Districts").dd_choices("contact_department", "contact_department", "GROUP BY contact_department")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        div.letters{                                    margin-left:auto; margin-right:auto; margin-bottom:15px; display:table;}
        div.letter{                                     float:left; clear:left;}
        div.district{                                   float:left; margin:20px;}
        div.districts{                                  margin-bottom:10px; margin-left:auto; margin-right:auto; display:table;}
        
        div.DISTRICTS__district{                        float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_department{              float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_first_name{              float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_last_name{               float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_email{                   float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_phone{                   float:left; clear:left; margin-bottom:2px;}
        div.DISTRICTS__contact_fax{                     float:left; clear:left; margin-bottom:2px;}
        
        div.DISTRICTS__district label{                  display:inline-block; width:150px;}
        div.DISTRICTS__contact_department label{        display:inline-block; width:150px; font-size:1.4em;}
        div.DISTRICTS__contact_first_name label{        display:inline-block; width:150px;}
        div.DISTRICTS__contact_last_name label{         display:inline-block; width:150px;}
        div.DISTRICTS__contact_email label{             display:inline-block; width:150px;}
        div.DISTRICTS__contact_phone label{             display:inline-block; width:150px;}
        div.DISTRICTS__contact_fax label{               display:inline-block; width:150px;}
        
        div.DISTRICTS__district input{                  width:300px;}
        div.DISTRICTS__contact_department input{        width:300px; border:none; background-color:transparent;}
        div.DISTRICTS__contact_first_name input{        width:300px;}
        div.DISTRICTS__contact_last_name input{         width:300px;}
        div.DISTRICTS__contact_email input{             width:300px;}
        div.DISTRICTS__contact_phone input{             width:300px;}
        div.DISTRICTS__contact_fax input{               width:300px;}
        
        div.district_name{                              float:left; margin-left:20px;}
        
        #search_dialog_button{                          display:none;}
        "
        output << "</style>"
        return output
    end
end