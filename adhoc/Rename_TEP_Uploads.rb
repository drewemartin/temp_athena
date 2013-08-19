#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Rename_TEP_Uploads < Base #Classes must begin with a capital letter
    
    def initialize()
        
        super()
        rename_TEP_uploads
        
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
                                puts t
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
    
end

Rename_TEP_Uploads.new()