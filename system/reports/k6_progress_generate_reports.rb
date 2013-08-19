#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports", "base")}/base"

class K6_Progress_Generate_Reports < Base

    #---------------------------------------------------------------------------    
    def initialize
        super()
        @reprint              = true
        @term                 = "Q4"#add function to get current @term if none was passed here
        @school_year          = $school.current_school_year.value
        @teacher_reports_path = $config.init_path("#{$paths.reports_path}Progress_Reports/School_Year_#{@school_year}/#{@term}_K6_Teachers#{@reprint ? "/WITH_INTACT_TAGS" : ""}")
        
        #sids = [
        #]
        #sids.each{|sid|
        #    generate(sid)
        #}
        #
        #teachers = [
        #    "Stacy Serwinski"
        #]
        #teachers.each{|teacher|
        #    generate_byteacher(teacher)
        #    teacher_package_byteacher(teacher)
        #    distribute_teachers
        #}
        
        #teachers.each{|teacher|
        #    teacher_package_byteacher(teacher)
        #}
        
        #distribute_teachers
        
        #sids = $db.get_data_single("SELECT student_id FROM k6_progress WHERE term = '#{@term}' and first_name IS NOT NULL")
        #sids.each{|sid|
        #    generate(sid)
        #}
        #$students.current_k6_progress_reports_required(teacher_name = nil, term = @term).each{|sid|
        #    generate(sid)    
        #}
        #$team.k6_teachers.each{|teacher|
        #    teacher_package_byteacher(teacher)
        #}
        #distribute_teachers
        
        #send(command[0]) if respond_to?(command[0])
    end
    #---------------------------------------------------------------------------
    
    #def distribute_teachers
    #    teacher_files        = Hash.new{|hash, key| hash[key] = Hash.new if !hash.has_key?(key)}
    #    Dir.entries(@teacher_reports_path).each{|entry|
    #        if entry.split(".").length > 0
    #            teacher = entry.split("#{@term}_")[1].split("_D20")[0].gsub("_"," ")
    #            teacher_files[teacher]["#{@teacher_reports_path}#{entry}"] = true
    #        end
    #    }
    #    subject     = "#{@term} PR REPRINT"
    #    content     = "Please find the attached zip file containing your student's progress reports for #{@school_year} School Year - #{@term}."
    #    content     << "<br>Please take a moment to verify that all your students have been included. These may be broken up into more than one email due to email size limitations."
    #    teacher_files.each_pair{|teacher,files|
    #        i = 1
    #        to_teammembers = ["Michele Buck","Michael Floyd","Nicole Harvey","Bruce Elliott",teacher]
    #        tot_files = files.length
    #        files.each_key{|file|
    #            tot_files = teacher_files[teacher].length
    #            to_teammembers.each{|recipient|
    #                $team.by_k12_name(recipient).send_email(:subject=> "#{subject} #{teacher} - #{i} of #{tot_files}", :content=> content, :additional_recipients=> 2, :attachment_name=> [file])
    #            }
    #            #$team.by_k12_name(teacher).send_email(:subject=> "#{subject} #{teacher} - #{i} of #{tot_files}", :content=> content, :additional_recipients=> 2, :attachment_name=> [file])
    #            i+=1            
    #        } 
    #    }
    #end
    
    def distribute_teachers
        teacher_files        = Hash.new{|hash, key| hash[key] = Hash.new if !hash.has_key?(key)}
        Dir.entries(@teacher_reports_path).each{|entry|
            if entry.split(".").length > 0 && entry.include?($ifilestamp)
                teacher = entry.split("#{@term}_")[1].split("_D20")[0].gsub("_"," ")
                teacher_files[teacher]["#{@teacher_reports_path}#{entry}"] = true
            end
        }
        content     = "Please find the attached zip file containing your student's progress reports for #{@school_year} School Year - #{@term}."
        subject     = "Progress Reports #{@term}"
        teacher_files.each_pair{|teacher,files|
            i = 1
            tot_files = files.length
            files.each_key{|file|
                tot_files = teacher_files[teacher].length
                $team.by_k12_name(teacher).send_email(:subject=> "#{subject} - #{i} of #{tot_files}", :content=> content, :additional_recipients=> 2, :attachment_name=> [file])
                i+=1            
            } 
        }
    end
    
    def generate(sid)
        student = $students.attach(sid)
        puts "BEGIN GENERATION SID: #{sid}"
        student.progress.term = @term
        final   = student.progress.admin_verified?
        file    = student.progress.generate_report(@school_year, @reprint) if final
        $students.detach(sid)
        return final ? file : false
    end
    
    def generate_bygrade(grade)
        student_files = Array.new
        $team.k6_teachers(grade).each{|teacher|
            $students.by_title1teacher(teacher).each{|sid|
                file = generate(sid)
                student_files.push(file) if file
            }
        }
        return student_files
    end
    
    def generate_byteacher(teacher_name)
        student_files = Array.new
        $students.current_k6_students(teacher_name).each{|sid|
            file = generate(sid)
            student_files.push(file) if file
        }
        return student_files
    end
    
    def generate_verified
        student_files = Array.new
        $students.k6.each{|sid|
            file = generate(sid)
            student_files.push(file) if file
        }
        return student_files
    end
    
    def teacher_package_byteacher(teacher_name)
        student_files = generate_byteacher(teacher_name)
        size          = 0
        qty           = 1
        batch_index   = 1
        batch_tot     = student_files.length
        zip_path      = "#{@teacher_reports_path}#{@term}_#{teacher_name.gsub(" ","_")}_#{$ifilestamp}_#{qty}.zip"
        zip_file      = Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE)
        student_files.each{|file_path|
            file_size = (File.size(file_path).to_f/1024).ceil
            if size + file_size <= 5800
                size += file_size
                zip_file.add(file_path.split("/")[-1], file_path)
            else
                qty+=1
                zip_file.close
                zip_path    = "#{@teacher_reports_path}#{@term}_#{teacher_name.gsub(" ","_")}_#{$ifilestamp}_#{qty}.zip"
                zip_file    = Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE)
                size        = file_size
                zip_file.add(file_path.split("/")[-1], file_path)
            end
            if batch_index == batch_tot
                zip_file.close
            end
            batch_index+=1
        }
    end
    
    def teacher_package_bygrade(grade)
        student_files = Array.new
        $team.k6_teachers(grade).each{|teacher|
            teacher_package_byteacher(teacher)
        }
        return student_files
    end
    
    def mark_reported(sid)
    end
    
    def mark_all_reported
    end
    
end

K6_Progress_Generate_Reports.new