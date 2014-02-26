#!/usr/local/bin/ruby

class Web_Error

    #---------------------------------------------------------------------------
    def initialize()
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   
     def invalid_user
          
          error_message  = "Please make sure you're logged in."
          email_subject  = "Athena Support Request - Not Logged In"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          message        = "<h1>#{error_message} If you continue to receive this message contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>.</h1>"
          replacement    = message
          $kit.error_message(
               message,
               replacement
          )
          
     end
   
     def invalid_credentials
          
          error_message  = "Please refresh your page and try again."
          email_subject  = "Athena Support Request - Authentification"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          message        = "<h1>#{error_message} If you continue to receive this message contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>.</h1>"
          replacement    = message
          $kit.error_message(
               message,
               replacement
          )
          
     end
     
     def invalid_entry(a={})
          
          $kit.error_message("`#{a[:value_entered]}` was not a valid entry. #{a[:error_details]}")
          
     end
     
     def document_not_complete(additional_info = nil)
          
          error_message  = "The document you were looking for could not be created because it has not been completed. <br><h3>#{additional_info}</h3><br>"
          email_subject  = "Athena Support Request - Document Not Created - Incomplete"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          $kit.error_message(
               "#{error_message} If you continue to receive this message and you believe it is in error, please contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>."
          )
          
     end
     
     def document_not_found
          
          error_message  = "The document you were looking for could not be found."
          email_subject  = "Athena Support Request - Document Not Found"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          $kit.error_message(
               "#{error_message} If you continue to receive this message contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>."
          )
          
     end
     
     def down_for_maintenance
          $kit.error_message(
               "Thank you for waiting while your system is being maintained.",
               "<img src='http://athena-sis.com/sitemaintenance.jpg' alt='' title='sitemaintenance' width='700' height='422' />"
          )
     end
     
     def duplicate_assignment_error(additional_message)
          
          error_message  = "Duplicate Assignment Detected! <BR> #{additional_message}"
          email_subject  = "Athena Support Request - Duplicate Assignment"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          $kit.error_message(
               "#{error_message} If you continue to receive this message, and you believe it is in error, contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>."
          )
          
     end

     def unexpected_error
          
          error_message  = "An unexpected error has occurred."
          email_subject  = "Athena Support Request - Unexpected Error"
          email_content  = "REFERENCE NUMBER: #{$kit.user_log_record.primary_id}"
          support_email  = "jhalverson@agora.org;esaddler@agora.org"
          
          $kit.error_message(
               "#{error_message} If you continue to receive this message contact <a href='mailto:#{support_email}?Subject=#{email_subject}&Body=#{email_content}'>support</a>."
          )
          
     end
     
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
end