#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/tv_kmail"

################################################################################
#Description: Agents check for unsent kmail and send them.
#Created By: Jenifer Halverson
################################################################################

class TV_Kmail_Agent < TV_Kmail
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    #---------------------------------------------------------------------------
    
    def initialize(agent_name)
        
        super(agent_name)
        @db_name = $tables.attach("KMAIL").data_base
        activate
        
    end
    
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d|s|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    public

    #---------------------------------------------------------------------------
    
    def activate
        
        until !kmail_exists?
            
           
            begin
                puts "\n----------------------------------------"
                puts "SENDING KMAIL ID: #{@kmail.ID }"
                
                start_time = Time.now
                
                send
                
                end_time   = Time.now
                
                diff      = start_time - end_time
                time_diff = diff.to_int
                
                if time_diff > 180
                    
                    $base.system_notification(
                        "SLOW KMAILS!",
                        "Kmails are slow. PID #{@kmail.ID}"
                    )
                    
                end
                
                puts "                  SUCCESSFUL"
                
            rescue Exception=>e
                
                @browser.close
                puts "                  FAILED: #{e}."
                puts "                  RELEASING KMAIL..."
                puts "                  TOTAL ATTEMPTS: #{release_kmail}.\n"
                
            end
            
        end
        
    end
    
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|M|e|t|h|o|d| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    #--------------------------------------------------------------------------
    
    def kmail_exists?
        
        kmail_sql =
            "SELECT
                sender,
                kmail_type,
                recipient_studentid,
                recipient_name,
                subject,
                content,
                primary_id,
                created_date
            FROM kmail
            WHERE successfull IS NULL
            AND primary_id NOT IN
                (SELECT primary_id
                FROM kmail
                WHERE error REGEXP 'ERROR.*')
            ORDER BY created_date ASC
            LIMIT 0,1"
            
        results = $db.get_data(kmail_sql, @db_name)
        
        if results
            
            results             = results[0]
            @kmail.SENDER       = results[0]
            @kmail.KMAIL_TYPE   = results[1]
            
            if @kmail.KMAIL_TYPE == 'Student'
                
                @kmail.RECIPIENT = results[2]
                
            elsif @kmail.KMAIL_TYPE == 'Administrator'
                
                @kmail.RECIPIENT = results[3]
                
            end
            
            @kmail.SUBJECT      = results[4]
            @kmail.CONTENT      = results[5].chomp
            @kmail.ID           = results[6]
            
            #if a student has a success status of true, but no send time
            #that would be an indication that it got to this point
            #but somehow faild along the way
            
            kmail_hold_sql =
                "UPDATE kmail
                SET
                    `successfull` = true
                WHERE primary_id = '#{@kmail.ID}'"
                
            $db.get_data(kmail_hold_sql, @db_name)
            
            return true
            
        else
            
            return false
            
        end
        
    end
    
    #---------------------------------------------------------------------------
    
    def release_kmail
        
        attempt_num = 1
        
        select_sql =
            "SELECT error
            FROM kmail
            WHERE primary_id = '#{@kmail.ID}'"
            
        results = $db.get_data_single(select_sql, @db_name)
        
        if results
            
            result = results[0]
            attempt_num = Integer(result)+1
            
        end
        
        kmail_release_sql =
            "UPDATE kmail
            SET
                `successfull` = null,
                `error` = #{attempt_num}
            WHERE primary_id = '#{@kmail.ID}'"
            
        results = $db.query(kmail_release_sql, @db_name)
        
        return attempt_num
        
    end
    
    def clear_attempts
        #NOTE need to add an array of attempted kmail primary id's to check and clear.
        update_sql =
            "UPDATE kmail
            SET successfull = NULL
            WHERE error NOT REGEXP 'ERROR.*'
            AND date_time_sent IS NULL
            AND successfull = true
            AND sender != 'tep_invites:tv'" # Fix this once the tep invites get corrected and sent
        results = $db.get_data(kmail_hold_sql, @db_name)
    end
  
end