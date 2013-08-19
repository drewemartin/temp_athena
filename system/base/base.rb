#!/usr/local/bin/ruby
$VERBOSE = nil

require 'rubygems'
require 'csv'
require 'date'
require 'fileutils'
require 'firewatir'
require 'digest/md5'
require 'mysql'
require 'net/http'
require 'net/https'
require 'net/ftp'
require 'net/smtp'
require 'pdf/reader'
require 'prawn'
require 'watir'
require 'zip/zip'

require "#{File.dirname(__FILE__).gsub("athena/system/base", "athena_config")}"
$config     = Athena_Config.new

require "#{File.dirname(__FILE__)}/paths"
$paths      = Paths.new

require "#{$paths.base_path}database"
require "#{$paths.api_path}school"
require "#{$paths.api_path}students"
require "#{$paths.api_path}tables"
require "#{$paths.api_path}team"
require "#{$paths.base_path}field_tools"
require "#{$paths.base_path}reports"
require "#{$paths.base_path}row"

class Base
  
  #---------------------------------------------------------------------------
  def initialize(school_year = nil)
    
    $base       = self
    
    @structure  = nil
    
    $instance_DateTime = DateTime.now
    $itime      = $instance_DateTime.strftime("%H:%M:%S")
    $itime_hm   = $instance_DateTime.strftime("%H:%M")
    $idate      = $instance_DateTime.strftime("%Y-%m-%d")
    $idatetime  = $instance_DateTime.strftime("%Y-%m-%d %H:%M:%S")
    $ifilestamp = $instance_DateTime.strftime("D%Y%m%dT%H%M%S")
    $ifiledate  = $instance_DateTime.strftime("D_%Y-%m-%d")
    $iuser      = $instance_DateTime.strftime("%m/%d/%Y")
    
    super()
    
    $field      = Field_Tools.new
    $reports    = Reports.new
    
    $school     = School.new
    $user       = "Athena-SIS"
    $db         = Database.new
    $tables     = Tables.new
    
    $students   = Students.new
    $team       = Team.new
    
    $config.school_year = school_year if school_year
    
    Struct.new( "NAME_DESC_VALUE",
      :NAME,            
      :DESCRIPTION,     
      :VALUE            
    )
    Struct.new( "TITLE_CONTENT",
      :TITLE,   
      :CONTENT
    )
    Struct.new( "WHERE_PARAMS",
      :FIELD,           #Field to check
      :EVALUATOR,       #Evaluaor o use (ie bool operator)
      :VALUE            #Value to search for
    )
    
    @created_by     = nil
    @created_date   = nil
    
  end
  #---------------------------------------------------------------------------

  def school_days
    
    #IF SCHOOL DAYS HAVE ALREADY BEEN LOADED INTO THE TABLE IT WILL RETURN THE ENTERED VALUES
    #OTHERWISE IF THE SCHOOL CALENDARE HAS BEEN FILLED OUT IT WILL RETURN THE CONSTRUCTED ARRAY OF DATES
    #ELSE IT WILL RETURN FALSE
    
    if $tables.attach("SCHOOL_DAYS") && $tables.attach("SCHOOL_DAYS").primary_ids
      
      return $tables.attach("SCHOOL_DAYS").find_fields("date", where_clause = nil, options = {:value_only=>true})
      
    elsif (
      
      (start_date  = $tables.attach("SCHOOL_YEAR_DETAIL" ).field_by_pid( "start_date", "1")) &&
      (end_date    = $tables.attach("SCHOOL_YEAR_DETAIL" ).field_by_pid( "end_date",   "1")) &&
      ($tables.attach("SCHOOL_CALENDAR").primary_ids)
      
    )
      
      school_days = Array.new
      
      school_holidays     = $tables.attach("SCHOOL_CALENDAR"    ).find_fields(  "date",       "WHERE type = 'holiday'", options = {:value_only=>true})
      last_day_of_school  = end_date.mathable
      eval_date           = start_date
      
      until eval_date.mathable > last_day_of_school
        
        school_days.push(eval_date.to_db) if (!school_holidays.include?(eval_date.to_db) && !eval_date.mathable.strftime("%w").match(/0|6/))
        eval_date.add!
        
      end
      
      return school_days
      
    else
      
      return false
      
    end
    
  end
  
  def created_by=(arg)
    @created_by = arg
  end
  
  def created_by
    @created_by
  end
  
  def created_date=(arg)
    @created_date = arg
  end
  
  def created_date
    @created_date
  end
  
  def mean(array)
    begin
      array.inject(0) { |sum, x| sum += x } / array.size.to_f
    rescue
      array.inject(0) { |sum, x| sum += x.to_f } / array.size.to_f
    end
  end
  
    def data_points_to_score(data_point, data_point_array, max_score = 40)
        
        data_point          = self.value ? self.value.to_f : 0.0
        data_point_array    = Array.new
        
        m           = $base.mean(data_point_array)
        sd          = $base.standard_deviation(data_point_array)
        
        if data_point >= m-sd
            
            if data_point >= m+sd
              
                return (max_score/4)      #if 40 => 40
              
            else
              
                return (max_score/4)*3    #if 40 => 30
              
            end
          
        else
          
            if data_point < m-sd*2
              
                return (max_score/4)      #if 40 => 10
              
            else
              
                return (max_score/4)*2    #if 40 => 20
              
            end
          
        end
        
    end
  
  def standard_deviation(array)
    
    m = mean(array)
    
    begin
      variance = array.inject(0) { |variance, x|
        variance += (x - m) ** 2
      }
    rescue
      variance = array.inject(0) { |variance, x|
        variance += (x.to_f - m) ** 2
      }
    end
    begin
      return Math.sqrt(variance/(array.size-1))
    rescue=>e
      #$base.system_notification(
      #  subject = "Standard Deviation Not Calculated - #{$session_id}",
      #  content = "#{__FILE__} #{__LINE__}",
      #  caller[0],
      #  e
      #) 
      return false
    end
    
  end
  
  def web_tools
    
    if !structure.has_key?("tools")
      
      require "#{$paths.base_path}web_tools"
      structure["tools"] = Web_Tools.new()
      
    end
    
    structure["tools"]
    
  end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


  
    def clean_path(path_str)
        path_str.gsub!(" ","_")
        path_str.gsub!("'","_")
        return path_str
    end
    
    def fill_word_template_save_to_pdf(replace_hash, template_name, destination_path, destination_file_name)
        
        replace_hash["[today]"]         = $iuser
        
        destination_path    = $config.init_path("#{$paths.reports_path}#{destination_path}")
        pdf_doc_path        = nil
        word_doc_path       = nil
        
        wrd        = false 
        index       = 0
        until wrd || index == 3
            index += 1
            begin
                wrd                = word
                wrd.DisplayAlerts  = false
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        document    = false
        index       = 0
        until document || index == 3
            index += 1
            begin
                document = wrd.Documents.Open("#{$paths.templates_path}#{template_name}.docx", 'ReadOnly' => true)
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                wrd                = word
            end
        end
        
        replace_hash.each_pair{|f,r|
            selection   = false
            index       = 0
            until selection || index == 3
                index += 1
                begin
                    selection = wrd.Selection
                rescue => e
                    raise e if index == 2
                    $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                end
            end
            
            home_key    = false
            index       = 0
            until home_key || index == 3
                index += 1
                begin
                    home_key = selection.HomeKey(unit=6)
                rescue => e
                    raise e if index == 2
                    $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                end
            end
            
            find        = false
            index       = 0
            until find || index == 3
                index += 1
                begin
                    find = selection.Find
                rescue => e
                    raise e if index == 2
                    $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                end
            end
            
            find_text   = false
            index       = 0
            until find_text || index == 3
                index += 1
                begin
                    find_text = find.Text = f
                rescue => e
                    raise e if index == 2
                    $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                end
            end
            
            executed    = false
            index       = 0
            until executed || index == 3
                index += 1
                begin
                    while wrd.Selection.Find.Execute
                        if r.nil? || r == ""
                            rvalue = " "
                        elsif r.class == Field
                            rvalue = r.to_user.nil? || r.to_user.to_s.empty? ? " " : r.to_user.to_s
                        else
                            rvalue = r.to_s
                        end
                        wrd.Selection.TypeText(text=clean_string(rvalue))
                    end
                    
                    executed = true
                rescue => e
                    raise e if index == 2
                    $base.system_log("INDEX: #{index} MESSAGE: #{e}")
                end
            end
            
        }
        
        saved       = false
        index       = 0
        until saved || index == 3
            index += 1
            begin
                word_doc_path   = "#{destination_path}#{destination_file_name}.docx".gsub("/","\\")
                document.SaveAs(word_doc_path)
                saved           = true
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        saved       = false
        index       = 0
        until saved || index == 3
            index += 1
            begin
                pdf_doc_path    = "#{destination_path}#{destination_file_name}.pdf".gsub("/","\\")
                document.SaveAs(pdf_doc_path,17)
                saved           = true
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        closed      = false
        index       = 0
        until closed || index == 3
            index += 1
            begin
                document.close
                closed = true
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        quit        = false
        index       = 0
        until quit || index == 3
            index += 1
            begin
                wrd.quit
                quit = true
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        rm_word     = false
        index       = 0
        until rm_word || index == 3
            index += 1
            begin
                rm_word = FileUtils.rm(word_doc_path)
                rm_word = true
            rescue => e
                raise e if index == 2
                $base.system_log("INDEX: #{index} MESSAGE: #{e}")
            end
        end
        
        return pdf_doc_path
    end

    def is_num?(arg)
        begin
            Integer(arg)
        rescue
            return false
        else
            return true
        end
    end

    def age_from_date(date)
        $db.get_data_single("SELECT (YEAR(CURDATE())-YEAR('#{date}')) - (RIGHT(CURDATE(),5)<RIGHT('#{date}',5))")[0]
    end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________NEW_WORLD_ORDER
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  def db
    $db
  end

  def grades
    $grades
  end
  
  def students
    $students
  end
  
  def table
    $tables
  end
  
  def team
    $team
  end
  
  def user
    $user
  end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DATE_TIME_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  def tomorrow
    return today.add!
  end
  
  def yesterday
    return today.sub!
  end
  
  #---------------------------------------------------------------------------
  def date_add(datein, quant, unit = 'day')
    if unit == 'day'
      unit = 86400
    elsif unit == 'week'
      unit = 604800
    elsif unit == 'year'
      unit = 31536000
    elsif unit == 'sec'
      unit = 1
    end
    return dateout = datein + (quant * unit)
  end
  #---------------------------------------------------------------------------
  
  ##---------------------------------------------------------------------------
  #def date_mathable(datestr)#i.e. '2011-02-20'
  #  date_time = datestr.split(" ")
  #  if date_time.length == 1
  #    arg = datestr.split('-')
  #    arg = arg.length == 1 ? datestr.split('.') : arg
  #    y = Integer( trim_lead(arg[0],'0') )
  #    m = Integer( trim_lead(arg[1],'0') )
  #    d = Integer( trim_lead(arg[2],'0') )
  #    date = Time.local(y,m,d)
  #    return date
  #  elsif date_time.length == 2
  #    arg   = date_time[0].split('-')
  #    arg   = arg.length == 1 ? date_time[0].split('.') : arg
  #    arg   = arg.length == 1 ? date_time[0].split('/') : arg
  #    y     = Integer( trim_lead(arg[0],'0') )
  #    m     = Integer( trim_lead(arg[1],'0') )
  #    d     = Integer( trim_lead(arg[2],'0') )
  #    arg2  = date_time[1].split(':')
  #    hour  = Integer( trim_lead(arg2[0],'0') )
  #    min   = arg2[1] == '00' ? 0 : Integer( trim_lead(arg2[1],'0') )
  #    sec   = arg2[2] == '00' ? 0 : Integer( trim_lead(arg2[2],'0') )
  #    date  = y >= 1000 ? Time.local(y,m,d,hour,min,sec) : Time.local(d,y,m,hour,min,sec)
  #    return date
  #  end 
  #end
  ##---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def date_mathable(datestr)#i.e. '2011-02-20'
    date_time = datestr.split(" ")
    if date_time.length == 1
      arg = datestr.split('-')
      arg = arg.length == 1 ? datestr.split('.') : arg
      y = Integer( trim_lead(arg[0],'0') )
      m = Integer( trim_lead(arg[1],'0') )
      d = Integer( trim_lead(arg[2],'0') )
      date = Time.local(y,m,d)
      return date
    elsif date_time.length == 2
      arg   = date_time[0].split('-')
      arg   = arg.length == 1 ? date_time[0].split('.') : arg
      arg   = arg.length == 1 ? date_time[0].split('/') : arg
      y     = Integer( trim_lead(arg[0],'0') )
      m     = Integer( trim_lead(arg[1],'0') )
      d     = Integer( trim_lead(arg[2],'0') )
      arg2  = date_time[1].split(':')
      hour  = Integer( trim_lead(arg2[0],'0') )
      min   = arg2[1] == '00' ? 0 : Integer( trim_lead(arg2[1],'0') )
      sec   = arg2[2] == '00' ? 0 : Integer( trim_lead(arg2[2],'0') )
      date  = y >= 1000 ? Time.local(y,m,d,hour,min,sec) : Time.local(d,y,m,hour,min,sec)
      return date
    end 
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def date_str(date_obj)#i.e. Time Class Object
    date_str = "#{ date_obj.strftime("%Y") }-#{ date_obj.strftime("%m") }-#{ date_obj.strftime("%d") }"
    return date_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def date_sub(datein, quant, unit = 'day')
    if unit == 'day'
      unit = 86400
    elsif unit == 'week'
      unit = 604800
    elsif unit == 'min'
      unit = 60
    elsif unit == 'sec'
      unit = 1
    end
    return dateout = datein - (quant * unit)
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def date_usr(date_str)#i.e. sql date results
    results = $field.new("type"=>"date","value"=>date_str)
    return results.to_user
  end
  
  def datetime_usr(date_str)#i.e. sql date results
    results = $field.new("type"=>"datetime","value"=>date_str)
    return results.to_user
  end
  
  def date_to_db(date_str)#i.e. sql date results
    results = $field.new("type"=>"date","value"=>date_str)
    return results.to_db
  end

  def to_db(field_type, field_value)
    results = $field.new("type"=>field_type,"value"=>field_value)
    return results.to_db
  end
  
  def to_percent(a)
    results = $field.new("type"=>"decimal(5,4)","value"=>a)
    return results.to_user
  end
  
  def mathable(field_type, field_value)
    results = $field.new("type"=>field_type,"value"=>field_value)
    return results.mathable
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def iso_date(time_obj, notation = true)
    if notation
      date_str = "#{ time_obj.strftime("%Y") }-#{ time_obj.strftime("%m") }-#{ time_obj.strftime("%d") }"
    else
      date_str = "#{ time_obj.strftime("%Y") }#{ time_obj.strftime("%m") }#{ time_obj.strftime("%d") }"
    end
    
    return date_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def iso_datetime(time_obj, notation = true)
    if notation
      date_str      = iso_date(time_obj)
      time_str      = iso_time(time_obj)
      datetime_str  = "#{date_str} #{time_str}"
    else
      date_str      = iso_date(time_obj, false)
      time_str      = iso_time(time_obj, false)
      datetime_str  = "#{date_str}T#{time_str}"
    end
    
    return datetime_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def iso_time(time_obj, notation = true)
    if notation
      time_str = "#{ time_obj.strftime("%H") }:#{ time_obj.strftime("%M") }:#{ time_obj.strftime("%S") }"
    else
      time_str = "#{ time_obj.strftime("%H") }#{ time_obj.strftime("%M") }#{ time_obj.strftime("%S") }"
    end
    
    return time_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def time_str(time_obj)
    return "#{time_obj.strftime("%H")}:#{time_obj.strftime("%M")}:#{time_obj.strftime("%S")}"
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DATA_PREP_SUPPORT
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  #---------------------------------------------------------------------------
  def clean_date( date )
    date = date.strip
    #find input format. K12 reports dates come in to possible formats
    #Date as 01/15/2011 or
    #Date time as 2011-01-15 00:00:00
    
    inputdateformat  = date.split(' ')
    if date == "N/A"
      
      date = "''"
      
    elsif inputdateformat.length > 1 || inputdateformat[ 0 ].split('-')[0].length == 4#Then there is a date and a time section AND date is in proper sql date format
      
      date        = "#{inputdateformat[ 0 ]}"
      
    else #just date AND needs to be cleaned up before inserted into the db
      
      dateprep    = inputdateformat[ 0 ].split('/')
      
      yzeropos    = dateprep[ 2 ].length - 1
      year        = dateprep[ 2 ][0,1]=='0' ? dateprep[ 2 ][-yzeropos,yzeropos] : dateprep[ 2 ]                           
      
      mzeropos    = dateprep[ 0 ].length - 1
      month       = dateprep[ 0 ][0,1]=='0' ? dateprep[ 0 ][-mzeropos,mzeropos] : dateprep[ 0 ]
      
      dzeropos    = dateprep[ 1 ].length - 1
      day         = dateprep[ 1 ][0,1]=='0' ? dateprep[ 1 ][-dzeropos,dzeropos] : dateprep[ 1 ]
      
      date        = "#{year}-#{month}-#{day}"
      
    end
   
    return date
    
  end
  #---------------------------------------------------------------------------
  
  def clean_datetime(datetime_str)
    datetime_str = datetime_str.strip
    date_time = datetime_str.split(" ")
    if date_time.length == 2
      date_arr = date_time[0].split("-")
      time_arr = date_time[1].split(":")
      if date_arr.length == 3 && date_arr[0].length == 4 && time_arr.length == 3
        return datetime_str
      else
        return iso_datetime(date_mathable(datetime_str))
      end
      return false
    end
    
  end
  
  #---------------------------------------------------------------------------
  def clean_decimal(percent_str)
    percent_str = percent_str.gsub(' ', '')
    if percent_str.index('%')
      decimal = percent_str.split('%')[0]
      decimal = Integer(decimal)
    elsif percent_str.index('N/A')
      decimal = ''
    else
      decimal = percent_str
    end
    decimal = decimal == '' ? decimal : "#{decimal.to_f/100}"
    return decimal
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def is_schoolday?(date) #NOTE: When there's time, add this as a function of the Time class
    schooldays = get_current_schoolyear_dates
    if schooldays.index(date)
      return true
    else
      return false
    end
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def new_file(filename)
    report_file_path = $config.init_path("#{@file_path}#{filename}")
    new_file = File.open( "#{ report_file_path }#{filename.split("/")[-1]}_#{ @date }_#{ @time }.csv", 'w' )
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def percentage(dec_str, round = false) #Accepts string and returns string
    percent = dec_str.to_f * 100
    percent_str = round ? "#{percent.round}%" : "#{percent}%"
    return percent_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def prep_data(data, type)   
    thisValue= nil
    
    if type == "bool" && !data.nil?
      truthy = data == "true"  || data == "yes" || data == "1" || data == 1 || data == true
      falsy  = data == "false" || data == "no"  || data == "0" || data == 0 || data == false
      thisValue = '1' if truthy
      thisValue = '0' if falsy
      
    elsif type == "date" && !data.nil?  
      thisValue = "#{clean_date( data )}"
      
    elsif type == "datetime" && !data.nil?
      thisValue = clean_datetime( data )
      
    elsif type == "year" && !data.nil?  
      if data == "0" || data == ""
        thisValue = "NULL"
      else
        thisValue = data
      end
      
    elsif type == "decimal(5,4)" && !data.nil?
      thisValue = "#{clean_decimal( data )}"
      
    elsif data.nil? || data.gsub(" ", "").empty?
      thisValue   = "NULL"
      
    else
      cleanValue  = Mysql.quote( data )
      thisValue   = "#{ cleanValue }"
      
    end
    
    return thisValue
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def round(flt) #Because Ruby 187 float.round does not accept precision points.
    (flt * 100).round.to_f / 100
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def trim_tail(str, n)
    str.gsub!(/Z#{n}+/,'')
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def trim_lead(str, n)
    str.gsub!(/^#{n}+/,'')
    return str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def name_desc_value(params)
    ndv = []
    params.each do |param|   
      name        = param[0]
      desc        = param[1]
      value       = param[2]
      ndv.push(Struct::NAME_DESC_VALUE.new(
        name,
        desc,
        value)
      ) 
    end
    return ndv
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def current_schoolyear
    @current_schoolyear
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def dt
    @dt
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def date
    @date
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def datetime
    @datetime
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def instance_time
    @instance_time
  end
  #---------------------------------------------------------------------------

  #---------------------------------------------------------------------------
  #def today
  #  @today
  #end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  #def today_str
  #  @today_str
  #end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def now_str
    @now_str
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def log
    @log
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def outputname
    @outputname
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def time
    @time
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def syspath
    @syspath
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def sy_cur_end
    @sy_cur_end
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def sy_cur_start
    @sy_cur_start
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def user_id
    @user_id
  end
  #---------------------------------------------------------------------------

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def file=(myarg)
    @file.puts myarg
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def log=(myarg)
    log_file = File.open( @log_file, 'a+' ) 
    log_file.puts myarg
    log_file.close
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def syspath=(myarg) 
    @syspath = myarg
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def user_id=(myarg)
    @user_id = myarg
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  def age_from_date(date_string)
    age = nil
    $db.query("SELECT (YEAR(CURDATE())-YEAR('#{date_string}')) - (RIGHT(CURDATE(),5)<RIGHT('#{date_string}',5))").each{|result|age=result[0]}
    return age
  end
  
  def system_log(message, caller_file = caller[0], e_obj = nil)
    add_on = String.new
    
    if e_obj
      
      add_on << "ERROR:              #{e_obj.error}\n"      if e_obj.respond_to?("error")
      add_on << "ERROR BACKTRACE:    #{e_obj.backtrace}\n"  if e_obj.respond_to?("backtrace")
      add_on << "ERROR MESSAGE:      #{e_obj.message}\n"    if e_obj.respond_to?("message")
      
    end
    row = $tables.attach("SYSTEM_LOG").new_row
    row.fields["file_line_function" ].value = caller_file
    row.fields["message"            ].value = "#{message} #{add_on}"
    row.save
    
  end
  
  def system_notification(subject, content, this_caller = caller[0], e_obj = nil)
    system_log("SUBJECT: #{subject} CONTENT: #{content}", this_caller, e_obj)
    email.athena_smtp_email($sys_admin_email, subject, content, attachment_path = nil, from_override = "Athena Alert")
  end
  
  def new_file(location, filename)
    file_path = $config.init_path("#{$paths.reports_path}#{location}")
    new_file = File.open( "#{file_path}#{filename}_#{$ifilestamp}.csv", 'w' )
  end
  
  def queue_kmail(params) # params = {:db=>nil,:sender=>"",:subject=>"",:content=>"",:recipient_studentid=>sid}
    
    new_record = $tables.attach("KMAIL").new_row
    new_record.fields["sender"              ].value = params[:sender    ] 
    new_record.fields["subject"             ].value = params[:subject   ]
    new_record.fields["content"             ].value = params[:content   ]
    new_record.fields["kmail_type"          ].value = 'Student'
    new_record.fields["recipient_studentid" ].value = params[:recipient_studentid]
    new_record.save
    
    return new_record.primary_id
    
  end
  
  def queue_process(class_name, function_name = nil, args = nil)
    $tables.attach("Process_Log").queue_process(class_name, function_name, args)
  end
  
  def today
    $field.new(
      "type"=>"datetime",
      "value"=>DateTime.now
    )
    #DateTime.now.strftime("%Y-%m-%d")
  end
  
  def user_file(filename)
    date                = DateTime.now.strftime("D%Y-%m-%dT%H%M%S")
    report_file_path    = $config.init_path("#{@file_path}#{filename}")
    new_file            = File.open( "#{ report_file_path }#{filename.split("/")[-1]}_#{ date }.csv", 'w' )
  end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  def email
    if !structure.has_key?("email")
      require "#{$paths.base_path}/email"
      structure["email"] = Email.new
    end
    return structure["email"]
  end
  
  def excel
    return WIN32OLE.new('Excel.Application')
  end
  
  def word
    return WIN32OLE.new('Word.Application')
  end
  
  def wordpress
    if !structure.has_key?(:wordpress)
      require "#{$paths.base_path}wordpress"
      structure[:wordpress] = WORDPRESS.new
    end
    return structure[:wordpress]
  end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________NEEDS_TO_BE_MOVED
end #These methods are not part of the base concept, move as time permits.
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def states #NOTE: This should return and array of name_desc_value structs. Fix asap.
    states = [
      [ "Alabama", "AL" ],
      [ "Alaska", "AK" ],
      [ "Arizona", "AZ" ],
      [ "Arkansas", "AR" ],
      [ "California", "CA" ],
      [ "Colorado", "CO" ],
      [ "Connecticut", "CT" ],
      [ "Delaware", "DE" ],
      [ "Florida", "FL" ],
      [ "Georgia", "GA" ],
      [ "Hawaii", "HI" ],
      [ "Idaho", "ID" ],
      [ "Illinois", "IL" ],
      [ "Indiana", "IN" ],
      [ "Iowa", "IA" ],
      [ "Kansas", "KS" ],
      [ "Kentucky", "KY" ],
      [ "Louisiana", "LA" ],
      [ "Maine", "ME" ],
      [ "Maryland", "MD" ],
      [ "Massachusetts", "MA" ],
      [ "Michigan", "MI" ],
      [ "Minnesota", "MN" ],
      [ "Mississippi", "MS" ],
      [ "Missouri", "MO" ],
      [ "Montana", "MT" ],
      [ "Nebraska", "NE" ],
      [ "Nevada", "NV" ],
      [ "New Hampshire", "NH" ],
      [ "New Jersey", "NJ" ],
      [ "New Mexico", "NM" ],
      [ "New York", "NY" ],
      [ "North Carolina", "NC" ],
      [ "North Dakota", "ND" ],
      [ "Ohio", "OH" ],
      [ "Oklahoma", "OK" ],
      [ "Oregon", "OR" ],
      [ "Pennsylvania", "PA" ],
      [ "Rhode Island", "RI" ],
      [ "South Carolina", "SC" ],
      [ "South Dakota", "SD" ],
      [ "Tennessee", "TN" ],
      [ "Texas", "TX" ],
      [ "Utah", "UT" ],
      [ "Vermont", "VT" ],
      [ "Virginia", "VA" ],
      [ "Washington", "WA" ],
      [ "West Virginia", "WV" ],
      [ "Wisconsin", "WI" ],
      [ "Wyoming", "WY" ]
    ]
    return states
  end #This should be part of the static variables class.
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  def set_team_member
    
    if $kit
      
      $team_member = ($kit.user && $kit.user.empty?) ? false : $team.find(:email_address=>$kit.user, :active=>1)
      
      if $kit.params[:student_page_view]
        
        $kit.params[:id] = $kit.params[:student_page_view].split(".")[0]
        $kit.params[:li] = $kit.params[:student_page_view].split(".")[1]
        $kit.params[:pg] = $kit.params[:student_page_view].split(".")[2]
        $kit.params[:si] = $kit.params[:student_page_view].split(".")[3]
        
        params.delete(:student_page_view) if params.has_key?(:student_page_view)
        
      end
      
    end
    
  end

  def get_new_student_page_view
    
    if $kit.params[:id] && $kit.params[:li] && $kit.params[:pg]
      return $kit.params[:id]+"."+$kit.params[:li]+"."+$kit.params[:pg]+"."+$team_log.primary_id
    else
      return $team_log.primary_id
    end
    
  end
  
  def uid
    x = $db.get_data_single("SELECT id from wordpress.wp_users WHERE user_login = '#{$kit.user}'", "wordpress")
    return x ? x[0] : x
  end
  
  def structure
    if @structure.nil?
      @structure = Hash.new
    end
    @structure
  end
  
end