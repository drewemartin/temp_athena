#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("adhoc","system/base/base")

class Adhoc_sed < Base

  #---------------------------------------------------------------------------
  def initialize()
      super()
            
  end
  #---------------------------------------------------------------------------
  
    def set_sed
        pids = $tables.attach("student_attendance").primary_ids("WHERE mode IN ('SED-Changed','Withdrawn') AND official_code IS NOT NULL")
        if pids
            pids.each do |pid|
                $tables.attach("student_attendance").record("WHERE PRIMARY_ID = '#{pid}'").fields["official_code"].set('NULL').save
            end
        end
    end
  
  
  
end

Adhoc_sed.new.set_sed


