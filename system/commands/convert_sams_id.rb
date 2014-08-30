#!/usr/bin/env ruby
require "#{File.dirname(__FILE__).gsub("commands","base")}/base"

class Convert_sams_id < Base
    
    #---------------------------------------------------------------------------
    def initialize(table = nil)
        super()
        convert("student_tep_agreement", "conducted_by", "conducted_by_team_id")
        convert("student_attendance_ap", "staff_id", "team_id")
    end
    #---------------------------------------------------------------------------
    
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    #|I|n|i|t|i|a|l|i|z|a|t|i|o|n| |S|u|p|p|o|r|t|
    #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    private
    
    def convert(tableName, sams_id_field, team_id_field)
        
        pids = $tables.attach(tableName).primary_ids
        
        pids.each{|pid|
            
            record = $tables.attach(tableName).by_primary_id(pid)
            
            sid = record.fields[sams_id_field].value
            if sid
                
                tid = $db.get_data_single("SELECT team_id
                    FROM agora_master.team_sams_ids
                    WHERE sams_id = #{sid}
                ")
                
                record.fields[team_id_field].value = tid[0]
                record.save
                
            end
            
        }
        
    end

end

Convert_sams_id.new(ARGV)