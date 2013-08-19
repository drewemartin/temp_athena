#!/usr/local/bin/ruby


class TEP_STUDENTS_WEB
    #---------------------------------------------------------------------------
    def initialize()
        @testing = false
    end
    #---------------------------------------------------------------------------
    def load
        $kit.output = $kit.tools.tabs([search_students, ["Tep Record", "Please Select A Student"]])
    end
    
    def response
        if $kit.params[:sid]
            sid = $kit.params[:sid]
            tep_results(sid)
            return ""
        else
            return ""
        end
    end
    
    def search_students
        return "Search", "<input class='multi-icon ui-icon ui-icon-plus' id='sid' name='sid' value='1590' onclick='send(this.id);'>"
        #return "Search", $kit.tools.search_sid
    end
    
    def tep_results(sid)
        output = ""
        student = $students.attach(sid)
        output << $kit.tools.student_demographics(student)
        tep_record = student.tep_records
        if tep_record
            tep_record.each do |tep|
                fields = tep.fields
                invite_date = fields["invite_date"].to_user
                tep_id = fields["tep_report_id"].value
                kmail_id = fields["kmail_id"].value
                spacer = "     "
                header = "Invite Date: #{invite_date} ~ ~ ~ ~ ~ Tep Meeting ID: #{tep_id} ~ ~ ~ ~ ~ K-Mail ID: #{kmail_id}"
                output << $kit.tools.legend_open("tep_result", header)
                output << fields["attended_meeting"].web.checkbox({:label_option=>"Attended Meeting:"})
                output << fields["attended_meeting_date"].web.date({:label_option=>"Date:"})
                output << fields["tep_returned"].web.checkbox({:label_option=>"TEP Agreement Returned:"})
                output << fields["tep_returned_date"].web.date({:label_option=>"Date:"})
                output << $kit.tools.legend_close()
            end
        else
            output << $kit.tools.legend_open("tep_result", "")
            output << $kit.tools.newlabel("no_record", "This student has never been invited to a TEP Meeting")
        end
        output << $tools.newlabel("bottom")
        $kit.modify_tag_content("tabs-2", output, "update")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
        
        body{                                       font-size: .8em !important;}
        
        div.add_new_button label{                   cursor:pointer;}
        div.add_new_button{                         width:130px; cursor:pointer; clear:left; border: 1px solid #3baae3; -moz-border-radius:5px; border-radius:5px; border-style:outset; padding:3px; margin-bottom:10px; background-color:#e4f1fb;}
        div.ui-icon-plus{                           float:right;}
        
        div.Tep_Students__attended_meeting{         float:left; margin-left:10px; margin-top:5px; padding-top:4px; width:200px; clear:left;}
        div.Tep_Students__attended_meeting input{   float:right;}
        div.Tep_Students__attended_meeting_date{    float:left; margin-left:40px; margin-top:5px;}
        div.Tep_Students__tep_returned{             float:left; margin-left:10px; margin-top:5px; padding-top:4px; width:200px; clear:left;}
        div.Tep_Students__tep_returned input{       float:right;}
        div.Tep_Students__tep_returned_date{        float:left; margin-left:40px; margin-top:5px;}
        
        .datepick{                    width:100px;}
        "
        output << "</style>"
        return output
    end
end