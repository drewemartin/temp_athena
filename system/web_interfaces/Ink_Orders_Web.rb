#!/usr/local/bin/ruby


class INK_ORDERS_WEB

    def load
        $kit.student_data_entry
    end
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "INK_ORDERS",
            additional_params_str   = "sid"
        )
        
        how_to_button = $tools.button_how_to("How To: Ink Orders")
        
        "Ink Orders #{how_to_button}#{new_contact_button}"
        
    end
    
    def response
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
    end
    
    def student_record()
        output          = String.new
        student         = $students.attach($focus_student.student_id.value)
        ink_records     = student.ink_records
        ink_dd          = ink_number_dd
        printer_dd      = printer_model_dd
        school_years_dd = $school.school_years_dd
        output << $kit.tools.div_open("ink_orders", "ink_orders")
        if ink_records
            ink_records.each do |record|
                fields = record.fields
                pid = fields["primary_id"].value
                title = "Ink "
                title << fields["request_date"  ].web.label({:label_option=>"Request Date:", :div_id=>"summary"})
                title << fields["order_date"    ].web.label({:label_option=>"Order Date:",   :div_id=>"summary"})
                title << fields["status"        ].web.label({:label_option=>"Status:",       :div_id=>"summary"})
                title << fields["school_year"   ].web.label({:label_option=>"School Year:",  :div_id=>"summary"})
                output << $tools.expandable_section(title, "", pid)
            end
        else
            output << $kit.tools.newlabel("no_record", "No Documents Received For This Student")
        end
        output << $tools.newlabel("bottom")
        output << $kit.tools.div_close
        return output
    end
    
    def expand_ink(pid)
        output = ""
        ink_record = $school.ink_record_by_pid(pid)
        fields = ink_record.fields
        output << $kit.tools.div_open("ink_record_container")
        output << fields["request_date" ].web.date(     {:label_option=>"Request Date:"}                                        )
        output << fields["printer"      ].web.select(   {:dd_choices=>printer_model_dd,     :label_option=>"Printer:"}          )
        output << fields["status"       ].web.select(   {:dd_choices=>status_dd,            :label_option=>"Status:"}           )
        output << fields["order_date"   ].web.date(     {:label_option=>"Order Date:"}                                          )
        output << fields["ink"          ].web.select(   {:dd_choices=>ink_number_dd,        :label_option=>"Ink:"}              )
        output << fields["school_year"  ].web.select(   {:dd_choices=>school_years_dd,      :label_option=>"School Year:"}      )
        output << fields["ship_date"    ].web.date(     {:label_option=>"Ship Date:"}                                           )
        output << $tools.newlabel("bottom")
        output << $kit.tools.div_close()
        output << $tools.newlabel("bottom")
        return output
    end
    
    def add_new_record_ink_orders()
        
        output = String.new
        
        output << $tools.div_open("ink_orders_container", "ink_orders_container")
        
        fields = $tables.attach("ink_orders").new_row.fields
        
        sid = $focus_student.student_id.value
        student   = $students.attach(sid)
        #fields    = student.new_row("Ink_Orders").fields
        ink_check = student.ink_check
        if ink_check
            fields["printer"].value = ink_check[0][1]
            fields["ink"].value = ink_check[0][2]
        end
        fields["status"].value = "Pending"
        fields["school_year"].value = $school.current_school_year
        
        output << $tools.legend_open("sub", "New Ink Order")
        
            output << fields["studentid"        ].set(sid).web.hidden()
            output << fields["request_date"     ].web.date(     {:label_option=>"Request Date:"}                                    )
            output << fields["printer"          ].web.select(   {:dd_choices=>printer_model_dd,     :label_option=>"Printer:"}      )
            output << fields["status"           ].web.select(   {:dd_choices=>status_dd,            :label_option=>"Status:"}       )
            output << fields["order_date"       ].web.date(     {:label_option=>"Order Date:"}                                      )
            output << fields["ink"              ].web.select(   {:dd_choices=>ink_number_dd,        :label_option=>"Ink:"}          )
            output << fields["school_year"      ].web.select(   {:dd_choices=>school_years_dd,      :label_option=>"School Year:"}  )
            output << fields["ship_date"        ].web.date(     {:label_option=>"Ship Date:"})
        
        output << $tools.legend_close()
        
        output << $tools.div_close()
        
        return output
    end
    
    def status_dd
        return [
            {:name=>"Canceled",         :value=>"Canceled"},
            {:name=>"Completed",        :value=>"Completed"},
            {:name=>"Manual",           :value=>"Manual"},
            {:name=>"More Info Needed", :value=>"More Info Needed"},
            {:name=>"No Staples ID",    :value=>"No Staples Id"},
            {:name=>"Ordered",          :value=>"Ordered"},
            {:name=>"Pending",          :value=>"Pending"},
            {:name=>"Rejected",         :value=>"Rejected"},
            {:name=>"Shipping",         :value=>"Shipping"}
        ]
    end
    
    def ink_number_dd
        return $school.ink.ink_number_dd
    end
    
    def printer_model_dd
        return $school.ink.printer_model_dd
    end
    
    def school_years_dd
        return $school.school_years_dd
    end
    
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
             
        div.request_date{                           float:left; margin-left:10px;}
        div.status{                                 float:left; margin-left:50px;}
        div.ink_record_container{                   margin-left:auto; margin-right:auto; margin-top:10px; margin-bottom:10px; display:table;}
        div.INK_ORDERS__request_date{               float:left; margin-left:5px; margin-bottom:10px; width:250px; clear:left; }
        div.INK_ORDERS__order_date{                 float:left; margin-left:5px; margin-bottom:10px; width:250px; clear:left; }
        div.INK_ORDERS__ship_date{                  float:left; margin-left:5px; margin-bottom:10px; width:250px; clear:left; }
        div.INK_ORDERS__printer{                    float:left; margin-left:0px; margin-bottom:10px; width:250px;}
        div.INK_ORDERS__ink{                        float:left; margin-left:0px; margin-bottom:10px; width:250px;}
        div.INK_ORDERS__status{                     float:left; margin-left:0px; margin-bottom:10px; width:250px;}
        div.INK_ORDERS__school_year{                float:left; margin-left:0px; margin-bottom:10px; width:250px;}
        
        div.INK_ORDERS__request_date label{         display:inline-block; width:100px;}
        div.INK_ORDERS__order_date label{           display:inline-block; width:100px;}
        div.INK_ORDERS__ship_date label{            display:inline-block; width:100px;}
        div.INK_ORDERS__printer label{              display:inline-block; width:60px;}
        div.INK_ORDERS__ink label{                  display:inline-block; width:60px;}
        div.INK_ORDERS__status label{               display:inline-block; width:90px;}
        div.INK_ORDERS__school_year label{          display:inline-block; width:90px;}
        
        div.INK_ORDERS__request_date#summary{       float:left; margin-left:5px; margin-bottom:5px; width:210px; clear:none;}
        div.INK_ORDERS__order_date#summary{         float:left; margin-left:5px; margin-bottom:5px; width:200px; clear:none;}
        div.INK_ORDERS__status#summary{             float:left; margin-left:0px; margin-bottom:5px; width:200px; clear:none;}
        div.INK_ORDERS__school_year#summary{        float:left; margin-left:0px; margin-bottom:5px; width:190px; clear:none;}

        div.INK_ORDERS__request_date#summery label{ display:inline-block; width:auto;}
        div.INK_ORDERS__order_date#summary label{   display:inline-block; width:auto;}
        div.INK_ORDERS__status#summary label{       display:inline-block; width:auto;}
        div.INK_ORDERS__school_year#summary label{  display:inline-block; width:auto;}

        .datepick{                                  width:100px;}
        
        #new_row_button_INK_ORDERS{                 float:right; font-size: xx-small !important;}
        "
        output << "</style>"
        return output
    end
end