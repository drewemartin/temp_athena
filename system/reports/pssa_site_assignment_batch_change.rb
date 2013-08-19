#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Site_Assignment_Batch_Change < Base

    #---------------------------------------------------------------------------
    def initialize(report_name)
        super()
        #PSSA BATCH SITE ASSIGNMENT CHANGES
        $user = $team.by_k12_name("Dan Feldhaus")
        file_path = "#{$config.import_path}adhoc_push/pssa_site_assignments.csv"
        records = CSV.open(file_path, 'r')
        records.each{|row|
          pssa_record = $tables.attach("Pssa_Assignments").by_studentid_old(row[0])
          pssa_record.fields["site_id"        ].value = $school.pssa.site_id_by_site_name(row[1]).value
          pssa_record.fields["office_selected"].value = true
          pssa_record.fields["verified"       ].value = true 
          pssa_record.save
          #trigger verification kmail
          $tables.attach("Pssa_Assignments").send_site_confirmation_kmail(pssa_record.fields["verified"])
        }
        records.close
        File.rename(file_path,"#{file_path.split(".csv")[0]}_#{$ifilestamp}.csv")
    end
    #---------------------------------------------------------------------------

end

test = Pssa_Site_Assignment_Batch_Change.new(ARGV)