#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class New_Class < Base #Classes must begin with a capital letter
    
    def initialize()
        
        super()
        #@i = 0
        #ftp = login_athena_reports
        #ftp.chdir("k12_reports/agora_sti_intervention")
        #failpath = ftp.pwd
        #ftp.chdir("k12_reports")
        #rootpath = ftp.pwd
        #destroy_wormhole_ftp(ftp, rootpath, failpath)
        #destroy_wormhole("#{$paths.reports_path}Sapphire_Update/New_Students/Sapphire_Update")
        #puts @i
        
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
                                add_new_row_tme(latest_file,teamID)
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
    
    def add_new_row(file,table_name)
        name = file
        i = 0
        until i == 4
            name = name.chop
            i = i + 1
        end
        newrow = $tables.attach("#{table_name}").new_row
        fields = newrow.fields
    end
    
    def copy_record(file)
        oldpath = File.expand_path(file)
        newpath = "."
        FileUtils.copy_file(oldpath,newpath)
    end
    
    def add_new_row_tme(latest_file,teamID)
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
    
    def rename_TEP_uploads
        #rootpath = "#{$paths.restore_path}/Student_Records_D20130520/Student_Records"
        rootpath = "C:/xampp/htdocs/Student_Records"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                studentID_name = File.basename(entry)
                studentID = studentID_name.delete("StudentID_")
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if File.directory?("#{rootpath}/#{entry}/SY_2012-2013/TEP")
                    newpath = "#{rootpath}/#{entry}/SY_2012-2013/TEP"
                    Dir.chdir("#{newpath}")
                    name_list = []
                    Dir.entries(newpath).each{|entry_file|
                        if !entry.gsub(/\.|rb/,"").empty?
                            #check file names to see if they're correct
                            name = File.basename(entry_file)
                            if name == "." || name == ".."
                                #do nothing
                            elsif name.include?("#{studentID}_tep_agreement")
                                name_list.push(name)
                            else
                                #get file creation date
                                timestamp = File.ctime(entry_file)
                                t = timestamp.strftime("D%Y%m%dT%H%M%S")
                                #change name of file
                                new_name = "#{studentID}_tep_agreement_#{t}.pdf"
                                unique_name = unique_TEP_name(name_list, new_name)
                                File.rename(name,unique_name)
                                name_list.push(unique_name)
                            end
                        end
                    }
                end
            end
        }
    end
    
    def unique_TEP_name(name_list, new_name)
        if name_list.include?(new_name)
            #change new name
            i = 0
            until i == 4
                new_name.chop!
                i = i + 1
            end
            s = new_name[-2,2]
            m = new_name[-4,2]
            ii = 0
            until ii == 4
                new_name.chop!
                ii = ii + 1
            end
            s = s.to_i
            m = m.to_i
            if s == 59
                s = 1
                m = m + 1
            else
                s = s + 1
            end
            s = s.to_s
            m = m.to_s
            nums = ["1","2","3","4","5","6","7","8","9"]
            if nums.include?(s)
                s = "0#{s}"
            end
            if nums.include?(m)
                m = "0#{m}"
            end
            new_name = new_name + m + s + ".pdf"
            unique_TEP_name(name_list,new_name)
        end
        return new_name
    end
    
    #we want all folders starting with WD_ in a Withdrawal folder
    #iterate through each student record
    #if no Withdrawal folder, create one
    #find all folders starting with WD_
    #put all folders starting with WD_ in Withdrawal folder (that weren't already in one)
    def rearrange
        rootpath = "#{$paths.restore_path}/Student_Records_D20130520/Student_Records"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                Dir.chdir("#{rootpath}/#{entry}/SY_2012-2013")
                if !File.directory?("#{rootpath}/#{entry}/SY_2012-2013/Withdrawal")
                    Dir.mkdir("#{rootpath}/#{entry}/SY_2012-2013/Withdrawal")
                end
                Dir.glob('WD_**') do |file|
                    #puts File.expand_path(file)
                    oldpath = File.expand_path(file)
                    FileUtils.mv("#{oldpath}","#{rootpath}/#{entry}/SY_2012-2013/Withdrawal")
                end
            end
        }
    end
    
    #check to see if floating tep stuff
    #look to see if there's anything other than Withdrawal and TEP folders
    def rearrangeTEP
        rootpath = "#{$paths.restore_path}/Student_Records_D20130520/Student_Records"
        Dir.entries(rootpath).each{|entry|
            if !entry.gsub(/\.|rb/,"").empty?
                newpath = "#{rootpath}/#{entry}/SY_2012-2013"
                Dir.chdir("#{newpath}")
                Dir.entries(newpath).each{|entry|
                    if !entry.gsub(/\.|rb/,"").empty?
                        path = File.expand_path(entry)
                        name = File.basename(path)
                        if name == "Withdrawal" || name == "TEP"
                            
                        else
                            puts path
                        end
                    end
                }
            end
        }
    end
    
    
    #method found on http://www.ruby-forum.com/topic/84762
    def isEmpty?(dir)
        Dir.glob("#{dir}/*", File::FNM_DOTMATCH) do |f|
            return false unless f =~ /\.\.?/
        end
        return true
    end
    
    #get to the directory where the wormhole is
    #iterate through until you get to the end of it
    #back out and delete one by one until back at the parent directory
    #iterates through the 'wormhole' of folders and removes them
    #WARNING: START THE ROOTPATH IN THE EMPTY FOLDERS. STARTING THE ROOTPATH
    #         IN A DIRECTORY CONTAINING OTHER FILES WILL DELETE THOSE FILES.
    def destroy_wormhole(rootpath)
        if rootpath == "#{$paths.reports_path}Sapphire_Update/New_Students"
            Process.abort
        end
        Dir.chdir(rootpath)
        all_folders = Dir.entries(rootpath)
        if all_folders == [".",".."]
            Dir.chdir("..")
            Dir.rmdir(rootpath)
            @i += 1
        else
            all_folders.each{|entry|
                next if entry == "." || entry == ".."
                path = File.expand_path(entry)
                destroy_wormhole(path)
                Dir.chdir("..")
                Dir.rmdir(rootpath)
                @i += 1
            }
        end
    end
    
    def destroy_wormhole_ftp(ftp, rootpath, failpath)
        if ftp.pwd == failpath
            Process.abort
        end
        ftp.chdir(rootpath)
        all_folders = ftp.list
        if all_folders.length == 2
            ftp.chdir("..")
            ftp.rmdir(rootpath)
            @i += 1
        else
            all_folders.each{|entry|
                entry = entry.split(" ").last
                next if entry == "." || entry == ".."
                #path = File.expand_path(entry)
                destroy_wormhole_ftp(ftp, entry, failpath)
                ftp.chdir("..")
                ftp.rmdir(rootpath)
                @i += 1
            }
        end
    end
    
    def login_athena_reports
        
        ftp         = Net::FTP.new('ftp.athena-sis.com')
        tries       = 0
        max_tries   = 3
        
        begin
            
            ftp.login("athenareports", "Lemodie_23")
            ftp.passive = true
            
        rescue => e
            
            tries += 1
            retry if tries <= max_tries
            
            $base.system_notification(
                "LOGIN ATHENA REPORTS FAILED!",
                "ATTEMPTS:  #{tries}
                ERROR:      #{e.message}",
                caller[0],
                e
            )
            
        end
        
        return ftp
        
    end
    
end

New_Class.new()