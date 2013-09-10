#!/usr/local/bin/ruby


class STUDENT_DOCUMENTS_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
       
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        new_contact_button = $tools.button_new_row(
            table_name              = "STUDENT_CONTACTS",
            additional_params_str   = "sid",
            save_params             = "sid"
        )
        
        upload_button = $tools.button_upload_doc("document", additional_params_str = "sid")
        
        "Documents#{upload_button}"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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

    def student_record(sid = $kit.params[:sid])
        
        output  = String.new
        
        output  = String.new
        student = $students.attach(sid)
        
        #output << $tools.button_upload_doc("document", additional_params_str = "sid")
        
        
        documents = $tables.attach("STUDENT_DOCUMENTS").by_studentid_old(sid)
        
        tables_array = [
            
            #HEADERS
            [
                "Action",
                "Document Type",
                "File Name",
                "Date Uploaded",
                "Uploaded By"
            ]
        ]
        
        documents.each do |document|
            
            document_id = "student_._#{document.fields['student_id'].value}_._#{document.fields['document_type'].value}_._#{document.fields['document_name'].value}"

            tables_array.push([
                                
                $tools.doc_secure_link(document_id, "View or Download"),
                
                document.fields["document_type"].value,
                
                document.fields["document_name"].value,
                
                document.fields["created_date"].to_user,
                
                $team.by_email(document.fields["created_by"].value).k12_fullname.value
                
            ])
        
        end if documents
        
        output << $kit.tools.data_table(tables_array, "leadership_reports")
        
        return output
        
    end 

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
    def upload_doc_document(sid)
        
        output = String.new
        
        output << "<form id='doc_upload_form' name='form' action='D20130906.rb' method='POST' enctype='multipart/form-data' >"
        output << "<input id='sidref' name='sidref' value='#{sid}' type='hidden'>"
        output << $tools.document_upload(self.class.name, "doc_upload_form", "pdf,jpg,jpeg,bmp,tiff,tif,gif,png")
        output << "</form>"
        
        return output
    
    end

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
        
        output = String.new
        output << "<style>"
        output << "
            
            #doc_upload_form_input{ float:left; clear:left;}
            div.doc_type{           float:left; margin-top:2px; margin-left:20px;}
            #upload_doc_button{     margin-right: 10px; width: 60px; float:right; font-size: xx-small !important;}

            
            
            iframe{float:right; display:none;}
            
        "
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