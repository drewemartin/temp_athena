#!/usr/local/bin/ruby

class FILE_UPLOAD_TEST

    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    def load
        return $kit.tools.tabs([test_page])
    end
    
    def response
        if $kit.params[:csv_upload]
            file = $kit.params[:csv_upload]
            interpret_csv(file)
        elsif $kit.params[:callback]
            callback = ""
        end
        return ""
    end
    #---------------------------------------------------------------------------
    def test_page
        tab_name = "TEST"
        output = ""
        output << $tools.csv_upload
        output << "<DIV class='testbox' id='testbox'>csv output</DIV>"
        return tab_name, output
    end
    
    def interpret_csv(file)
        begin
            CSV.parse(file) do |row|
                $kit.output << "#{row.to_s}<br>"
            end
            serverFile = "/upload_#{$ifilestamp}.csv"
            File.open(serverFile, "w") do |f|
                f << file
            end
            $kit.output << "success"
        rescue
            $kit.output << "failed"
        end
    end
    
    #def response
    #    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CSV CONTENTS<br>"
    #    csv_string = @kit.file_upload
    #    CSV.parse(csv_string) do |row|
    #        puts row
    #        puts "<br>"
    #    end
    #end
    
    #def upload_form
    #    puts "upload form"
    #    #puts @kit.html.header
    #    puts "<form id='upload_form_0' name='upload_form_0' enctype='multipart/form-data' action='/cgi-bin/athena_cgi.rb' style='visibility: visible;' method='post'> <input type='hidden' name='page' value='File_Upload_Test' /><input type ='hidden' id= 'user_id' name= 'user_id' value= 'esaddler@agora.org'><DIV class= 'false__file'><LABEL class ='false__file' for='insert_alpha__false__file'>Upload (CSV):</LABEL> <input class ='false__file' id='file' type='file' name='file_upload' size='50' enctype='multipart/form-data' onchange='filetype(this, \".csv\")' tabindex='1'/></DIV><DIV class= 'false__submit'><input class ='false__submit stylebutton' id ='false__false__submit' type='submit' value='Upload File' tabindex='0'/></DIV></FORM"
    #end
    
end