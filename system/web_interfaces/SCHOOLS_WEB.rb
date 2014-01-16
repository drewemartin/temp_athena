#!/usr/local/bin/ruby


class SCHOOLS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    
    def breakaway_caption
        return "Schools"
    end
    
    def page_title
        "Schools"
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        
        output = "<div id='student_container'>"
        
        output << school_search
        
        output << "<button class='new_breakaway_button' id='school_search_dialog_button'>School Search</button>"
        
        output << $tools.button_new_row("SCHOOLS", nil, nil, "Add New School Record")
        
        output << $tools.div_open("school_record_container", "school_record_container")
        output << $tools.div_close()
        
        return output
        
    end
    
    def search_results
        
        output = String.new
        
        output << $tools.div_open("search_results", "search_results")
        output << $tools.newlabel("no_search", "Please Search For A School")
        output << $tools.div_close()
    
    end
    
    def school_results(where_clause)
        
        output = String.new
        
        tables_array = Array.new
     
        #HEADERS
        tables_array.push([
            "Edit",
            "School Name",
            "District",
            "County Name",
            "Street Address",
            "City",
            "State",
            "Zip",
            "Zip Ext",
            "School Phone",
            "Additional Phone Numbers",
            "Emails"
        ])
        
        pids = $tables.attach("SCHOOLS").primary_ids(where_clause)
        pids.each{|pid|
            
            record = $tables.attach("SCHOOLS").by_primary_id(pid)
            
            row = Array.new
            
            row.push("<button class='new_breakaway_button' id='load_school_record_button_#{pid}' onclick='send\(\"load_school_record_#{pid}\"\)\;setPreSpinner\(\"school_record_container\"\);$\(\"#school_search_dialog\"\).dialog\(\"close\"\)'>Edit</button><input id='load_school_record_#{pid}' type='hidden' value='#{pid}' name='load_school_record'")
            row.push(record.fields["school_name"   ].value)
            row.push(record.fields["district"      ].value)
            row.push(record.fields["county_name"   ].value)
            row.push(record.fields["street_address"].value)
            row.push(record.fields["city"          ].value)
            row.push(record.fields["state"         ].value)
            row.push(record.fields["zip"           ].value)
            row.push(record.fields["zip_ext"       ].value)
            row.push(record.fields["phone"         ].value)
            
            phone_numbers = String.new
            phone_records = $tables.attach("SCHOOLS_PHONE").primary_ids("WHERE schools_id = #{pid}")
            
            phone_records.each_with_index do |phone_pid, i|
                
                record = $tables.attach("SCHOOLS_PHONE").by_primary_id(phone_pid)
                
                fields = record.fields
                
                phone_numbers << "<br>" if i != 0
                phone_numbers << "#{fields["type"          ].value}:"
                phone_numbers << "#{fields["department"    ].value}:"
                phone_numbers << "#{fields["phone_number"  ].value}"
                
            end if phone_records
            
            row.push(phone_numbers)
            
            emails = String.new
            email_records = $tables.attach("SCHOOLS_EMAIL").primary_ids("WHERE schools_id = #{pid}")
            
            email_records.each_with_index do |email_pid, i|
                
                record = $tables.attach("SCHOOLS_EMAIL").by_primary_id(email_pid)
                
                fields = record.fields
                
                emails << "<br>" if i != 0
                emails << "#{fields["type"          ].value}:"
                emails << "#{fields["department"    ].value}:"
                emails << "#{fields["email_address" ].value}"
                
            end if email_records
            
            row.push(emails)
            
            tables_array.push(row)
            
        } if pids
        
        if tables_array.length > 1
            output << $kit.tools.data_table(tables_array, "schools_directory")
            output << "</div>"
            return output
        else
            return false
        end

        
    end
    
    def response
        
        if $kit.params[:load_school_record] || $kit.params[:add_new_SCHOOLS_PHONE] || $kit.params[:add_new_SCHOOLS_EMAIL] || $kit.params[:add_new_SCHOOLS]
            
            output = String.new
            
            output << $tools.legend_open("information", "Information")
            
            pid = $kit.params[:load_school_record] || $kit.params[:field_id____SCHOOLS_PHONE__schools_id] || $kit.params[:field_id____SCHOOLS_EMAIL__schools_id] || $kit.rows.first[1].primary_id
            
            output << "<input id='load_school_record_#{pid}' type='hidden' value='#{pid}' name='load_school_record'>"
            
            school_record = $tables.attach("SCHOOLS").by_primary_id(pid)
            
            fields = school_record.fields
            
            output << fields["school_name"   ].web.text(:label_option=>"School Name"    )
            output << fields["district"      ].web.text(:label_option=>"District"       )
            output << fields["county_name"   ].web.text(:label_option=>"County"         )
            output << fields["street_address"].web.text(:label_option=>"Street Address" )
            output << fields["city"          ].web.text(:label_option=>"City"           )
            output << fields["state"         ].web.text(:label_option=>"State"          )
            output << fields["zip"           ].web.text(:label_option=>"Zip"            )
            output << fields["zip_ext"       ].web.text(:label_option=>"Zip Ext"        )
            output << fields["phone"         ].web.text(:label_option=>"School Phone"   )
            
            output << $tools.legend_close()
            
            output << $tools.legend_open("add_numbers", "Additional Numbers")
            
            output << $tools.button_new_row("SCHOOLS_PHONE", "load_school_record_#{pid}")
            
            phone_records = $tables.attach("SCHOOLS_PHONE").primary_ids("WHERE schools_id = #{pid}")
            
            phone_records.each_with_index do |phone_pid,i|
                
                record = $tables.attach("SCHOOLS_PHONE").by_primary_id(phone_pid)
                
                fields = record.fields
                
                output << $tools.legend_open("sub", "##{(i+1).to_s}")
                
                output << fields["type"          ].web.select(:label_option=>"Type",         :dd_choices=>phone_type_dd )
                output << fields["department"    ].web.select(:label_option=>"Department",   :dd_choices=>departments_dd )
                output << fields["phone_number"  ].web.text(  :label_option=>"Phone Number"  )
                
                output << $tools.legend_close()
                
            end if phone_records
            
            output << $tools.legend_close()
            
            output << $tools.legend_open("email_addresses", "E-mail Addresses")
            
            output << $tools.button_new_row("SCHOOLS_EMAIL", "load_school_record_#{pid}")
            
            email_records = $tables.attach("SCHOOLS_EMAIL").primary_ids("WHERE schools_id = #{pid}")
            
            email_records.each_with_index do |email_pid,i|
                
                record = $tables.attach("SCHOOLS_EMAIL").by_primary_id(email_pid)
                
                fields = record.fields
                
                output << $tools.legend_open("sub", "##{(i+1).to_s}")
                
                output << fields["type"          ].web.text(:label_option=>"Type"          )
                output << fields["department"    ].web.text(:label_option=>"Department"    )
                output << fields["email_address" ].web.text(:label_option=>"Email Address" )
                
                output << $tools.legend_close()
                
            end if email_records
            
            output << $tools.legend_close()
            
            $kit.modify_tag_content("school_record_container", output, "update")
            
        else
            
            search_hash = Hash.new
            search_hash[:school_name]    = $kit.params[:school_name]    if $kit.params[:school_name]    && $kit.params[:school_name]    != ""
            search_hash[:district]       = $kit.params[:district]       if $kit.params[:district]       && $kit.params[:district]       != ""
            search_hash[:county_name]    = $kit.params[:county_name]    if $kit.params[:county_name]    && $kit.params[:county_name]    != ""
            search_hash[:street_address] = $kit.params[:street_address] if $kit.params[:street_address] && $kit.params[:street_address] != ""
            search_hash[:city]           = $kit.params[:city]           if $kit.params[:city]           && $kit.params[:city]           != ""
            search_hash[:state]          = $kit.params[:state]          if $kit.params[:state]          && $kit.params[:state]          != ""
            search_hash[:zip]            = $kit.params[:zip]            if $kit.params[:zip]            && $kit.params[:zip]            != ""
            
            
            if search_hash.length >= 1
                
                where_clause = "WHERE "
                
                search_hash.each_with_index do |(k,v),i|
                    
                    where_clause << "AND " if i != 0
                    where_clause << "#{k.to_s} REGEXP '#{v}' "
                    
                end
                
                results = school_results(where_clause)
                
                results = $tools.newlabel("no_results", "This search returned no results") if results == false
                
            else
                
                results = $tools.newlabel("no_results", "This search returned no results")
                
            end
            
            $kit.modify_tag_content("school_search_results", results, "update")
            
        end
        
    end
    
    def school_search
        
        output      = String.new
        search_params = "search__SCHOOL__school_name,search__SCHOOL__district,search__SCHOOL__county_name,search__SCHOOL__street_address,search__SCHOOL__city,search__SCHOOL__state,search__SCHOOL__zip"
        
        output << "<div id='school_search_fields'>"
        output << $tools.blank_input("search__SCHOOL__school_name",    "school_name",     "School Name:")
        output << $tools.blank_input("search__SCHOOL__district",       "district",        "District:")
        output << $tools.blank_input("search__SCHOOL__county_name",    "county_name",     "County:")
        output << $tools.blank_input("search__SCHOOL__street_address", "street_address",  "Street Address:")
        output << $tools.blank_input("search__SCHOOL__city",           "city",            "City:")
        output << $tools.blank_input("search__SCHOOL__state",          "state",           "State:")
        output << $tools.blank_input("search__SCHOOL__zip",            "zip",             "Zip Code:")
        output << "<button id='student_search_button' type='button' onclick=\"send('#{search_params}');setPreSpinner('school_search_results');\"></button>"
        output << "</div>"
        output << "<div id='school_search_results'></div>"
        output << "</div>"
        output.insert(0, "<div id='school_search_dialog'><div class='js_error'>Javacript Error!</div>")
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TAB_LOADERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_CSV
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def add_new_record_schools()
        
        output = String.new
        
        output << $tools.div_open("new_school_container", "new_school_container")
        
        row = $tables.attach("SCHOOLS").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "New School")
        
            fields = row.fields
            
            output << fields["school_name"   ].web.text(:label_option=>"School Name"    )
            output << fields["district"      ].web.text(:label_option=>"District"       )
            output << fields["county_name"   ].web.text(:label_option=>"County"         )
            output << fields["street_address"].web.text(:label_option=>"Street Address" )
            output << fields["city"          ].web.text(:label_option=>"City"           )
            output << fields["state"         ].web.text(:label_option=>"State"          )
            output << fields["zip"           ].web.text(:label_option=>"Zip"            )
            output << fields["zip_ext"       ].web.text(:label_option=>"Zip Ext"        )
            output << fields["phone"         ].web.text(:label_option=>"School Phone"   )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_schools_phone()
        
        output = String.new
        
        output << $tools.div_open("new_phone_container", "new_phone_container")
        
        row = $tables.attach("SCHOOLS_PHONE").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "New Phone Number")
        
            output << fields["schools_id"    ].set($kit.params[:load_school_record]).web.hidden
            output << fields["type"          ].web.select(:label_option=>"Type",         :dd_choices=>phone_type_dd )
            output << fields["department"    ].web.select(:label_option=>"Department",   :dd_choices=>departments_dd )
            output << fields["phone_number"  ].web.text(:label_option=>"Phone Number"  )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
    def add_new_record_schools_email()
        
        output = String.new
        
        output << $tools.div_open("new_email_container", "new_email_container")
        
        row = $tables.attach("SCHOOLS_EMAIL").new_row
        fields = row.fields
        
        output << $tools.legend_open("sub", "New Email Address")
        
            output << fields["schools_id"     ].set($kit.params[:load_school_record]).web.hidden
            output << fields["type"           ].web.text(:label_option=>"Type"          )
            output << fields["department"     ].web.text(:label_option=>"Department"    )
            output << fields["email_address"  ].web.text(:label_option=>"Email Address" )
            
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def phone_type_dd
        
        return [
            {:name=>"Phone", :value=>"Phone"  },
            {:name=>"Fax",   :value=>"Fax"    }
        ]
        
    end
    
    def departments_dd
        
        return [
            {:name=>"Administration", :value=>"Administration" },
            {:name=>"Attenance",      :value=>"Attenance"      },
            {:name=>"Nursing",        :value=>"Nursing"        },
            {:name=>"Registrar",      :value=>"Registrar"      }
        ]
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = "
        <style>
            
            #search_dialog_button               {display: none;}
            table.dataTable td.column_0         {text-align: center;}
            #student_container fieldset         {width:97%}
            
            #school_search_fields               {width:400px; padding:10px; margin-bottom:10px; margin-left:auto; margin-right:auto;}
            #school_search_dialog_button        {margin-bottom:10px;}
            #school_search_submit               {margin-top:5px;}
            #school_search_results              {height:500px; width:1000px; padding:10px; overflow-y:scroll;border          :1px solid #3baae3;border-radius   :5px;margin-left     :auto;margin-right    :auto;box-shadow      :inset -5px 0px 15px #869bac;background-color:#EDF0F2;}
            
            #new_row_button_SCHOOLS_PHONE       {float:right; top:-32px; margin-bottom:-32px;}
            #new_row_button_SCHOOLS_EMAIL       {float:right; top:-32px; margin-bottom:-32px;}
            
            input {font-size:10px;}
            
            .school_name                  label {width:110px; display:inline-block;}
            .district                     label {width:110px; display:inline-block;}
            .county_name                  label {width:110px; display:inline-block;}
            .street_address               label {width:110px; display:inline-block;}
            .city                         label {width:110px; display:inline-block;}
            .zip                          label {width:110px; display:inline-block;}
            .state                        label {width:110px; display:inline-block;}
            .phone                        label {width:110px; display:inline-block;}
            
            .school_name                  input {width:250px;}
            .district                     input {width:250px;}
            .county_name                  input {width:250px;}
            .street_address               input {width:250px;}
            .city                         input {width:250px;}
            .zip                          input {width:250px;}
            .state                        input {width:250px;}
            .phone                        input {width:250px;}
            
            .SCHOOLS__school_name         input {width:800px;}
            .SCHOOLS__district            input {width:800px;}
            .SCHOOLS__county_name         input {width:800px;}
            .SCHOOLS__street_address      input {width:800px;}
            .SCHOOLS__city                input {width:800px;}
            .SCHOOLS__state               input {width:800px;}
            .SCHOOLS__zip                 input {width:800px;}
            .SCHOOLS__zip_ext             input {width:800px;}
            .SCHOOLS__phone               input {width:800px;}
            
            .SCHOOLS__school_name         label {width:110px; display:inline-block;}
            .SCHOOLS__district            label {width:110px; display:inline-block;}
            .SCHOOLS__county_name         label {width:110px; display:inline-block;}
            .SCHOOLS__street_address      label {width:110px; display:inline-block;}
            .SCHOOLS__city                label {width:110px; display:inline-block;}
            .SCHOOLS__state               label {width:110px; display:inline-block;}
            .SCHOOLS__zip                 label {width:110px; display:inline-block;}
            .SCHOOLS__zip_ext             label {width:110px; display:inline-block;}
            .SCHOOLS__phone               label {width:110px; display:inline-block;}
            
            .SCHOOLS_PHONE__type          label {width:110px; display:inline-block;}
            .SCHOOLS_PHONE__department    label {width:110px; display:inline-block;}
            .SCHOOLS_PHONE__phone_number  label {width:110px; display:inline-block;}
            
            .SCHOOLS_PHONE__type          input {width:400px;}
            .SCHOOLS_PHONE__department    input {width:400px;}
            .SCHOOLS_PHONE__phone_number  input {width:400px;}
            
            .SCHOOLS_EMAIL__type          label {width:110px; display:inline-block;}
            .SCHOOLS_EMAIL__department    label {width:110px; display:inline-block;}
            .SCHOOLS_EMAIL__email_address label {width:110px; display:inline-block;}
            
            .SCHOOLS_EMAIL__type          input {width:400px;}
            .SCHOOLS_EMAIL__department    input {width:400px;}
            .SCHOOLS_EMAIL__email_address input {width:400px;}
            
        </style>"
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