#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class WITHDRAWING < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def by_studentid_old(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id", "=", arg) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY `effective_date` DESC"
        records(where_clause) 
    end
    
    def by_primaryid(arg)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", arg) )
        where_clause = $db.where_clause(params)
        record(where_clause) 
    end
    
    def field_by_primaryid(field_name, primary_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("primary_id", "=", primary_id) )
        where_clause = $db.where_clause(params)
        find_field(field_name, where_clause)
    end
    
    #def grades_required
    #    where_clause = "WHERE status = 'ADMIN Verified' OR status = 'Initial Submission'"
    #    records(where_clause)
    #end
    
    def incomplete_by_studentid(student_id)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",        student_id      ) )
        params.push( Struct::WHERE_PARAMS.new("status",         "!=",       "Completed"     ) ) 
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY `effective_date` DESC"
        record(where_clause)
    end
    
    
    #def records_to_process
    #    $db.get_data_single("SELECT primary_id FROM #{table_name} WHERE status = 'PENDING - GRADES' AND comments regexp '.*need.*grade.*' AND DATE_ADD(effective_date,INTERVAL 2 DAY) < CURDATE()") 
    #end
    
    def records_to_process
        #this should check for records that are not complete after the switch
        where_clause = " WHERE (status !=  'Withdrawn' OR STATUS IS NULL) AND DATE_ADD(effective_date,INTERVAL 2 DAY) <= CURDATE()"
        records(where_clause)
    end
    
    #def withdrawing_eligible_record(arg)
    #    where_clause = "
    #    WHERE student_id = #{arg}
    #    AND eligible_date <= CURDATE()
    #    AND completed_date IS NULL
    #    AND processed IS NOT TRUE
    #    AND retracted IS NOT TRUE"
    #    record(where_clause) 
    #end
    #
    #def withdrawing_ineligible_record(arg)
    #    where_clause = "
    #    WHERE student_id = #{arg}
    #    AND eligible_date > CURDATE()
    #    AND completed_date IS NULL
    #    AND processed IS NOT TRUE
    #    AND retracted IS NOT TRUE "
    #    record(where_clause)
    #end
    
    def withdrawing_processed_record(arg)
        where_clause = "
        WHERE student_id = #{arg}
        AND completed_date IS NULL
        AND processed IS TRUE
        AND retracted IS NOT TRUE"
        record(where_clause)
    end
    
    def withdrawing_retracted_records(arg)
        where_clause = "
        WHERE student_id = #{arg}
        AND retracted IS TRUE"
        records(where_clause)
    end
    
############################################################################

    def withdrawing_incompleted_records(student_id = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",        student_id      ) ) if student_id
        params.push( Struct::WHERE_PARAMS.new("status",         "!=",       "Completed"     ) ) 
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY `effective_date` DESC"
        records(where_clause)
    end

    def withdrawing_completed_records(student_id = nil, effective_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",        student_id          ) ) if student_id
        params.push( Struct::WHERE_PARAMS.new("effective_date", "=",        effective_date      ) ) if effective_date
        params.push( Struct::WHERE_PARAMS.new("completed_date", "IS NOT",   "NULL"              ) )
        where_clause = $db.where_clause(params)
        where_clause << " ORDER BY `effective_date` DESC"
        records(where_clause)
    end
    
    def withdrawing_processed_records(student_id = nil, effective_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",    student_id          ) ) if student_id
        params.push( Struct::WHERE_PARAMS.new("effective_date", "=",    effective_date      ) ) if effective_date
        params.push( Struct::WHERE_PARAMS.new("completed_date", "IS",   "NULL"              ) )
        params.push( Struct::WHERE_PARAMS.new("processed",      "IS",   "TRUE"              ) )
        #params.push( Struct::WHERE_PARAMS.new("retracted",      "IS",   "FALSE"             ) )
        where_clause = $db.where_clause(params)
        where_clause << " AND (retracted IS FALSE || retracted IS NULL)"
        where_clause << " ORDER BY `effective_date` DESC"
        records(where_clause)
    end
    
    def withdrawing_eligible_record(student_id = nil, effective_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",    student_id          ) ) if student_id
        params.push( Struct::WHERE_PARAMS.new("effective_date", "=",    effective_date      ) ) if effective_date
        params.push( Struct::WHERE_PARAMS.new("eligible_date",  "<=",   "CURDATE()"         ) )
        params.push( Struct::WHERE_PARAMS.new("completed_date", "IS",   "NULL"              ) )
        #params.push( Struct::WHERE_PARAMS.new("processed",      "!=",   "1"                 ) )
        #params.push( Struct::WHERE_PARAMS.new("retracted",      "!=",   "1"                 ) )
        where_clause = $db.where_clause(params)
        where_clause << " AND (processed IS FALSE || processed IS NULL)"
        where_clause << " AND (retracted IS FALSE || retracted IS NULL)"
        where_clause << " ORDER BY `effective_date` DESC"
        record(where_clause) 
    end
    
    def withdrawing_eligible_records()
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("eligible_date",  "<=",   "CURDATE()"         ) )
        params.push( Struct::WHERE_PARAMS.new("completed_date", "IS",   "NULL"              ) )
        where_clause = $db.where_clause(params)
        where_clause << " AND (processed IS FALSE || processed IS NULL)"
        where_clause << " AND (retracted IS FALSE || retracted IS NULL)"
        where_clause << " ORDER BY `effective_date` DESC"
        records(where_clause) 
    end
    
    def withdrawing_pending_record(student_id = nil, effective_date = nil)
        params = Array.new
        params.push( Struct::WHERE_PARAMS.new("student_id",     "=",    student_id          ) ) if student_id
        params.push( Struct::WHERE_PARAMS.new("effective_date", "=",    effective_date      ) ) if effective_date
        params.push( Struct::WHERE_PARAMS.new("eligible_date",  ">",   "CURDATE()"          ) )
        params.push( Struct::WHERE_PARAMS.new("completed_date", "IS",   "NULL"              ) )
        #params.push( Struct::WHERE_PARAMS.new("processed",      "!=",   "1"                 ) )
        #params.push( Struct::WHERE_PARAMS.new("retracted",      "!=",   "1"                 ) )
        where_clause = $db.where_clause(params)
        where_clause << " AND (processed IS FALSE || processed IS NULL)"
        where_clause << " AND (retracted IS FALSE || retracted IS NULL)"
        where_clause << " ORDER BY `effective_date` DESC"
        record(where_clause) 
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_change_field_processed(field)
        pid = field.primary_id
        record = $tables.attach("Withdrawing").by_primary_id(pid)
        if field.is_true?
            record.fields["processed_date"].value = $idatetime
            record.fields["status"].value = "Processed"
        else
            record.fields["processed_date"].value = nil
            record.fields["status"].value = "Requested"
        end
        record.save
    end
    
    def after_change_field_rescinded(field)
        pid = field.primary_id
        record = $tables.attach("Withdrawing").by_primary_id(pid)
        record.fields["rescinded_date"].value = $idatetime
        record.fields["status"].value = "Completed"
        record.save
    end
    
    def after_change_field_retracted(field)
        if field.value
            pid = field.primary_id
            record = $tables.attach("Withdrawing").by_primary_id(pid)
            record.fields["status"          ].value = "Completed"
            record.fields["completed_date"  ].value = DateTime.now
            record.save
        end
    end
    
    def after_change_field_effective_date(field)
        pid = field.primary_id
        record = $tables.attach("Withdrawing").by_primary_id(pid)
        if field.mathable <= DateTime.now
            
            record.fields["eligible_date"].value = $base.right_now.add_day_at_midnight
        else
            record.fields["eligible_date"].value =  field.value
        end
        record.save
    end
    
    def after_insert(row)
        pid = row.fields["primary_id"].primary_id
        record = $tables.attach("Withdrawing").by_primary_id(pid)
        effective_date_field = record.fields["effective_date"]
        if !effective_date_field.value.nil?
            if effective_date_field.mathable < DateTime.now
                record.fields["eligible_date"].value = $base.tomorrow.to_db.slice(0,10)
            else
                record.fields["eligible_date"].value = effective_date_field.value
            end
        end
        record.save
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______AFTER_LOAD_K12_WITHDRAWAL
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def after_load_k12_withdrawal
        
        ##DETECT AND NOTIFY IF THERE ARE WITHDRAWING RECORDS THAT SHOULD BE CONFIRMED, BUT CANNOT BECAUSE OF A MISMATCH.
        #mismatched_pids = $db.get_data_single(
        #    "SELECT         
        #        withdrawing.primary_id            
        #    FROM withdrawing
        #    LEFT JOIN k12_withdrawal ON withdrawing.student_id = k12_withdrawal.student_id
        #    WHERE withdrawing.processed IS TRUE
        #    AND withdrawing.completed_date IS NULL
        #    AND k12_withdrawal.student_id IS NOT NULL
        #    AND k12_withdrawal.schoolwithdrawdate       = withdrawing.effective_date
        #    AND (
        #        (k12_withdrawal.transferring_to != withdrawing.agora_reason)
        #            OR
        #        (LEFT(k12_withdrawal.withdrawreason,2) != withdrawing.k12_reason)
        #    )"
        #)
        #if mismatched_pids
        #    location    = "Withdrawals/Withdrawing_Mismatch"
        #    filename    = "withdrawing_mismatch"
        #    rows        = Array.new
        #    mismatched_pids.each{|pid|
        #        rows.push($tables.attach("withdrawing").by_primary_id(pid))    
        #    }
        #    file_path           = $reports.csv(location, filename, rows)
        #    sender_email        = "registrardistrict@agora.org"
        #    sender_secret       = "district12"
        #    recipient_email     = "afitzgibbons@agora.org"
        #    subject             = "Withdrawing Mismatch Occurred!"
        #    content             = "Please find the attached report. It looks like some k12/agora reasons do not matched what was entered into TotalView. Thank You :)"
        #    $base.email.smtp_email(sender_email, sender_secret, recipient_email, subject, content, file_path)
        #end
        
        #CONFIRM WITHDRAWALS AND REPORT ACCORDINGLY
        k12_db = $tables.attach("k12_withdrawal").data_base
        pids = $db.get_data_single(
            "SELECT         
                withdrawing.primary_id            
            FROM #{data_base}.withdrawing
            LEFT JOIN #{k12_db}.k12_withdrawal ON #{data_base}.withdrawing.student_id = #{k12_db}.k12_withdrawal.student_id
            WHERE withdrawing.completed_date IS NULL
            AND k12_withdrawal.student_id IS NOT NULL "
        )
        
        if pids
            
            #MARK EACH AS WITHDRAWN AND CREATE INDIVIDUAL STUDENT REPORTS
            
            pids.each{|pid|
                
                sid = $tables.attach("withdrawing").by_primary_id(pid).fields["student_id"].value
                
                $reports.save_document({
                    :pdf_template    => "DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb",
                    :pdf_id          => pid,
                    :category_name   => "Withdrawals",
                    :type_name       => "District Withdrawal Notification",
                    :document_relate => [
                        {
                            :table_name      => "STUDENT",
                            :key_field       => "student_id",
                            :key_field_value => sid
                        },
                        {
                            :table_name      => "WITHDRAWING",
                            :key_field       => "primary_id",
                            :key_field_value => pid
                        }
                    ]
                })
                
                $reports.save_document({
                    :pdf_template    => "WITHDRAWAL_GRADES_PDF.rb",
                    :pdf_id          => pid,
                    :category_name   => "Withdrawals",
                    :type_name       => "Final Grades",
                    :document_relate => [
                        {
                            :table_name      => "STUDENT",
                            :key_field       => "student_id",
                            :key_field_value => sid
                        },
                        {
                            :table_name      => "WITHDRAWING",
                            :key_field       => "primary_id",
                            :key_field_value => pid
                        }
                    ]
                })
                
                record = $tables.attach("withdrawing").by_primary_id(pid)
                record.fields["status"          ].value = "Withdrawn"
                record.fields["completed_date"  ].value = DateTime.now
                record.save
                
            }
            
        end
        
        #GENERATE DISTRICT NOTIFICATIONS
        require "#{$paths.templates_path}pdf_templates/DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.rb"
        DISTRICT_NOTIFICATION_WITHDRAWAL_PDF.new.distribute_confirmed_batch
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                "name"              => "withdrawing",
                "file_name"         => "withdrawing.csv",
                "file_location"     => "withdrawing",
                "source_address"    => nil,
                "source_type"       => nil,
                "download_times"    => nil,
                "trigger_events"    => true,
                "audit"             => true
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            structure_hash["fields"]["student_id"]              = {"data_type"=>"int",      "file_field"=>"Student ID #"}                 if field_order.push("student_id")
            structure_hash["fields"]["student_age"]             = {"data_type"=>"int",      "file_field"=>"Student Age Today"}            if field_order.push("student_age")
            structure_hash["fields"]["initiated_date"]          = {"data_type"=>"datetime", "file_field"=>"Date WD Initiated"}            if field_order.push("initiated_date")
            structure_hash["fields"]["initiator"]               = {"data_type"=>"text",     "file_field"=>"Initiator of Withdrawal"}      if field_order.push("initiator")
            structure_hash["fields"]["relationship"]            = {"data_type"=>"text",     "file_field"=>"Relationship of Initiator"}    if field_order.push("relationship")
            structure_hash["fields"]["method"]                  = {"data_type"=>"text",     "file_field"=>"Method of Contact"}            if field_order.push("method")
            structure_hash["fields"]["agora_reason"]            = {"data_type"=>"text",     "file_field"=>"Agora Withraw Reason"}         if field_order.push("agora_reason")
            structure_hash["fields"]["k12_reason"]              = {"data_type"=>"text",     "file_field"=>"K12 WD Reason"}                if field_order.push("k12_reason")
            structure_hash["fields"]["type"]                    = {"data_type"=>"text",     "file_field"=>"type"}                         if field_order.push("type")
            structure_hash["fields"]["ftc_action"]              = {"data_type"=>"text",     "file_field"=>"ftc_action"}                   if field_order.push("ftc_action")
            structure_hash["fields"]["comments"]                = {"data_type"=>"text",     "file_field"=>"NOTES (Details/Comments)"}     if field_order.push("comments")
            structure_hash["fields"]["transferring_school"]     = {"data_type"=>"text",     "file_field"=>"transferring_school"}          if field_order.push("transferring_school")
            structure_hash["fields"]["grades_documented"]       = {"data_type"=>"bool",     "file_field"=>"grades_documented"}            if field_order.push("grades_documented")
            structure_hash["fields"]["status"]                  = {"data_type"=>"text",     "file_field"=>"ADMIN ONLY - Status"}          if field_order.push("status")
            structure_hash["fields"]["processed"]               = {"data_type"=>"bool",     "file_field"=>"processed"}                    if field_order.push("processed")
            structure_hash["fields"]["retracted"]               = {"data_type"=>"bool",     "file_field"=>"retracted"}                    if field_order.push("retracted")
            structure_hash["fields"]["rescinded"]               = {"data_type"=>"bool",     "file_field"=>"rescinded"}                    if field_order.push("rescinded")
            structure_hash["fields"]["truancy_dates"]           = {"data_type"=>"text",     "file_field"=>"TRUANCY (Code 6 Only) Dates"}  if field_order.push("truancy_dates")
            structure_hash["fields"]["ftc_notified_date"]       = {"data_type"=>"datetime", "file_field"=>"ftc_notified_date"}            if field_order.push("ftc_notified_date")
            structure_hash["fields"]["effective_date"]          = {"data_type"=>"date",     "file_field"=>"Effective WD Date"}            if field_order.push("effective_date")
            structure_hash["fields"]["eligible_date"]           = {"data_type"=>"datetime", "file_field"=>"eligible_date"}                if field_order.push("eligible_date")            
            structure_hash["fields"]["processed_date"]          = {"data_type"=>"datetime", "file_field"=>"processed_date"}               if field_order.push("processed_date")
            structure_hash["fields"]["completed_date"]          = {"data_type"=>"datetime", "file_field"=>"completed_date"}               if field_order.push("completed_date")
            structure_hash["fields"]["rescinded_date"]          = {"data_type"=>"datetime", "file_field"=>"rescinded_date"}               if field_order.push("rescinded_date")
            structure_hash["fields"]["sapphire_reported_date"]  = {"data_type"=>"datetime", "file_field"=>"sapphire_reported_date"}       if field_order.push("sapphire_reported_date")
            structure_hash["fields"]["parent_notify_date"]      = {"data_type"=>"datetime", "file_field"=>"parent_notify_date"}           if field_order.push("parent_notify_date")
            structure_hash["fields"]["district_notify_date"]    = {"data_type"=>"datetime", "file_field"=>"district_notify_date"}         if field_order.push("district_notify_date")            
            structure_hash["fields"]["source"]                  = {"data_type"=>"text",     "file_field"=>"source"}                       if field_order.push("source")
        structure_hash["field_order"] = field_order
        return structure_hash
    end
    
end
