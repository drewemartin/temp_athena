#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Upload_Team_Member_Evaluations < Base
    
    def initialize()
        
        super()
        upload_team_member_evaluations
        
    end
    
    def upload_team_member_evaluations
        rootpath = "C:/xampp/htdocs/for_transfer"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                teamID = entry.delete("TeamID_").to_i
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if File.directory?("#{rootpath}/#{entry}/SY_2012-2013/Evaluations")
                    newpath = "#{rootpath}/#{entry}/SY_2012-2013/Evaluations"
                    Dir.chdir("#{newpath}")
                    latest_date = 0
                    latest_time = 0
                    latest_file = "0"
                    Dir.entries(newpath).each{|entry_file|
                        if !entry.gsub(/\.|rb/,"").empty?
                            next if entry_file == "." || entry_file == ".."
                            #get name of the file and store date time stamp
                            #compare to other stored date time stamps
                            name = File.basename(entry_file)
                            date = get_date_from_evaluation(name)
                            time = get_time_from_evaluation(name)
                            if date > latest_date
                                latest_date = date
                                latest_time = time
                                latest_file = entry_file
                            elsif date == latest_date
                                if time > latest_time
                                    latest_time = time
                                    latest_file = entry_file
                                end
                            end
                        end
                    }
                    #get the newest file and add to team docs table
                    Dir.entries(newpath).each{|entry_file|
                        if !entry.gsub(/\.|rb/,"").empty?
                            name = File.basename(entry_file)
                            if name == latest_file
                                add_new_row(latest_file,teamID)
                                move_record(latest_file,teamID)
                            end
                        end
                    }
                end
            end
        }
    end
    
    def get_date_from_evaluation(name)
        date = name[-19,8]
        date = date.to_i
        return date
    end
    
    def get_time_from_evaluation(name)
        time = name[-10,6]
        time = time.to_i
        return time
    end
    
    def add_new_row(latest_file,teamID)
        name = latest_file
        i = 0
        until i == 4
            name = name.chop
            i = i + 1
        end
        newrow = $tables.attach("TEAM_DOCUMENTS").new_row
        fields = newrow.fields
        fields["team_id"].value = teamID
        fields["document_type"].value = "Evaluation"
        fields["document_name"].value = name
        fields["document_path"].value = "/Team_Member_Records/TeamID_#{teamID}/SY_2012-2013/Evaluations/#{latest_file}"
        newrow.save
    end
    
    def move_record(latest_file,teamID)
        oldpath = File.expand_path(latest_file)
        rootpath = "C:/xampp/htdocs/Team_Member_Records"
        newpath = $config.init_path("#{rootpath}/TeamID_#{teamID}/SY_2012-2013/Evaluations")
        FileUtils.mv("#{oldpath}","#{newpath}")
    end
    
end

Upload_Team_Member_Evaluations.new()