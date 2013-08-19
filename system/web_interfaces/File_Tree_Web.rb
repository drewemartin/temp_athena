#!/usr/local/bin/ruby


class FILE_TREE_WEB
    #---------------------------------------------------------------------------
    def initialize()
        @testing = false
    end
    #---------------------------------------------------------------------------
    def load
        return "<DIV class='main'>
                <DIV class='jquery_file_tree' id='jquery_file_tree'></DIV>
                </DIV>"
    end
    
    def response
        return ""
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        output = "<style>"
        output << "
            div.jquery_file_tree{ width: 600px; height: 400px; border: solid 2px #3baae3; overflow-y: scroll; padding: 5px; margin-left:auto; margin-right:auto; background:white;}
            div.main{ background: #f2f5f7; border: 1px solid #DDDDDD; -moz-border-radius: 6px 6px 6px 6px; padding:20px; -moz-box-shadow: inset 1px 1px 2px gray;}
        "
        output << "</style>"
        return output
    end
end