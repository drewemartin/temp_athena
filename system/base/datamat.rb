#!/usr/local/bin/ruby

class Datamat

    #---------------------------------------------------------------------------
    def initialize()
        @to_type = nil
        @option  = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def add
        return add_day
    end
    
    def add!(params=nil)
        self.value = add_day
        return self if params == :object
        return self
    end 
    
    def iso_date
        if self.value && mathable.is_a?(DateTime)
            return mathable.strftime("%Y-%m-%d")
        end 
    end
    
    def iso_date!
        if self.value && mathable.is_a?(DateTime)
            self.value = mathable.strftime("%Y-%m-%d")
            return self
        end 
    end
    
    def is_null?
        result = false
        if self.value.is_a?(String)
            result = true if self.value.nil? || self.value.downcase == "null" || self.value.strip.empty?
        end
        
        if self.value.class == NilClass
            result = true
        end
        
        if datatype == "date" 
            result = true if self.value == 0
        end
        
        return result
    end
    
    def is_false?
        if !self.value.nil?
            false_values = ["false", "no", "n", "0"]
            if false_values.include?(self.value.to_s.downcase)
                return true
            else
                return false
            end
        else
            return false
        end
    end
    
    def is_true?
        if !self.value.nil?
            true_values = ["true", "yes", "1", "y"]
            if true_values.include?(self.value.to_s.downcase)
                return true
            else
                return false
            end
        else
            return false
        end
    end
    
    def is_not_true?
        if !self.value.nil?
            true_values = ["true", "yes", "1", "y"]
            if true_values.include?(self.value.to_s.downcase)
                return false
            else
                return true
            end
        else
            return true
        end
    end
    
    def to_db
        if !is_null?
            @to_type = "db"
            case datatype
            when "bool"
                prep_bool
            when "date"
                prep_date 
            when "datetime"
                prep_datetime
            when "year"
                prep_year
            when "decimal(5,4)"
                prep_decimal(4)
            when "decimal(10,2)"
                prep_decimal(2)
            when "text"
                prep_text
            when "int"
                Integer(self.value)
            else
                self.value
            end
        else
            "NULL"
        end
    end

    def to_db!
        if !is_null?
            @to_type = "db"
            case datatype
            when "bool"
                self.value = prep_bool
            when "date"
                self.value = prep_date 
            when "datetime"
                self.value = prep_datetime
            when "year"
                self.value = prep_year
            when "decimal(5,4)"
                self.value = prep_decimal(4)
            when "decimal(10,2)"
                self.value = prep_decimal(2)
            when "text"
                self.value = prep_text
            when "int"
                self.value
            else
                self.value
            end
            return self
        else
            self.value = "NULL"
            return self
        end
    end


    
    def to_user(option=nil)
        @option = option
        if !is_null?
            @to_type = "user"
            case datatype
            when "bool"
                prep_bool
            when "date"
                prep_date
            when "datetime"
                prep_datetime
            when "time"
                mathable.strftime("%l:%M %p")
            when "year"
                prep_year
            when "decimal(5,4)"
                prep_percent
            when "decimal(10,2)"
                #nothing to do at this time
                self.value
            when "text"
                #nothing to do at this time
                self.value
            when "int"
                #nothing to do at this time
                self.value
            else
                self.value
            end
        elsif @option && @option[:na]
            "N/A"
        else
            ""
        end
    end
    
    def to_user!(option=nil)
        @option = option
        if !is_null?
            @to_type = "user"
            case datatype
            when "bool"
                self.value = prep_bool
            when "date"
                self.value = prep_date
            when "datetime"
                self.value = prep_datetime
            when "year"
                self.value = prep_year
            when "decimal(5,4)"
                self.value = prep_percent
            when "decimal(10,2)"
                #nothing to do at this time
                self
            when "text"
                #nothing to do at this time
                self
            when "int"
                #nothing to do at this time
                self
            else
                self
            end
            return self
        else
            self.value = ""
            return self
        end
    end
    
    def to_web
        if self.value.class == String
            return self.value.gsub("'","&#39;")
        end
    end
    
    def to_web!
        if self.value.class == String
            self.value = self.value.gsub("'","&#39;")
        end
        return self
    end
    
    def mathable
        if !is_null?
            case datatype
            when "date"
                begin
                    if !self.value.is_a? DateTime
                        datestr = self.value.strip.split(" ")[0]
                        d = datestr.split(".").first.split('-') if (datestr[-2,1] == "."||datestr[-1,1] == ".") && !d
                        d = datestr.split('-') if datestr.index('-') && !d
                        d = datestr.split('/') if datestr.index('/') && !d
                        d = datestr.split('.') if datestr.index('.') && !d
                        y = d[0].length > 2 ? Integer(trim_lead(d[0],'0')) : Integer(trim_lead(d[2],'0'))
                        m = d[0].length > 2 ? Integer( trim_lead(d[1],'0') ) : Integer( trim_lead(d[0],'0') )
                        d = d[0].length > 2 ? Integer( trim_lead(d[2],'0') ) : Integer( trim_lead(d[1],'0') )
                        date = DateTime.new(y,m,d)
                        return date
                    else
                        return self.value
                    end
                rescue
                    return false 
                end
            when "datetime"
                
                if !self.value.is_a? DateTime
                    
                    if self.value.include?("D")
                        
                        this_date = self.value.split("T")[0].gsub("D","").insert(4,"-").insert(7,"-").split("-")
                        this_time = self.value.split("T")[1].insert(2,":").insert(5,":").split(":")
                        datetime  = DateTime.new(this_date[0].to_i,this_date[1].to_i,this_date[2].to_i,this_time[0].to_i,this_time[1].to_i,this_time[2].to_i)
                        
                    else
                        
                        date_time = self.value.strip.split(" ")
                        datestr = date_time[0]
                        d = datestr.split('-') if datestr.index('-')
                        d = datestr.split('/') if datestr.index('/')
                        d = datestr.split('.') if datestr.index('.')
                        y = d[0].length == 4 ? Integer(d[0])                    : Integer(d[2])
                        m = d[0].length == 4 ? Integer( trim_lead(d[1],'0') )   : Integer( trim_lead(d[0],'0') )
                        d = d[0].length == 4 ? Integer( trim_lead(d[2],'0') )   : Integer( trim_lead(d[1],'0') )
                        
                        if !date_time[1]
                            datetime = DateTime.new(y,m,d)
                        else
                            t     = date_time[1].split('.')[0].split(':')
                            hour  = t[0] == '00' ? 0 : Integer( trim_lead(t[0],'0') )
                            min   = t[1] == '00' ? 0 : Integer( trim_lead(t[1],'0') )
                            sec   = t[2] == '00' ? 0 : Integer( trim_lead(t[2],'0') )
                            if date_time.length == 3
                                hour = hour + 12    if hour != 12 && date_time[2]   == "PM"
                                hour = 0            if hour == 12 && date_time[2]   == "AM"
                            end
                            datetime = DateTime.new(y,m,d,hour,min,sec)
                        end
                        
                    end
                    
                    return datetime
                    
                else
                    
                    return self.value
                    
                end
                
            when "time"
                
                this_time = self.value.split(":")
                DateTime.new(2023, 5, 23, this_time[0].to_i, this_time[1].to_i, this_time[2].to_i)
                
            when "decimal(5,4)"
                if !self.value.is_a? Float
                    return Float(self.value)
                else
                    return self.value
                end
            when "decimal(10,2)"
                if !self.value.is_a? Float
                    return Float(self.value)
                else
                    return self.value
                end
            when "int"
                if !self.value.is_a? Integer
                    return Integer(self.value)
                else
                    return self.value
                end
            end
        else
            return false
        end
    end
    
    def mathable!
        self.value = mathable
        return self
    end
    
    def add_day_at_midnight
        return add_day_midnight
    end
    
    def sub
        return sub_day
    end
    
    def sub!
        self.value = sub_day
        return self
    end
    
    def round
        
        if !self.value.nil?
            
            begin
                $base.round(self.value.to_f)
            rescue
                return "N/A"
            end
            
        else
            
            return "N/A"
            
        end
        
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SPECIAL_FIELD_SUPPORTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def initial
        
        if self.value.class == String && !self.value.nil? && !self.value.empty?
            
            return self.value[0].chr.capitalize+"."
            
        end
      
    end
    
    def to_email_link(arg={:text=>nil,:subject=>nil,:content=>nil, :class=>nil, :style=>nil})
        
        if self.field_name.match(/email/)
            
            return "<a href='mailto:#{self.value}?Subject=#{arg[:subject]}&Body=#{arg[:content]}' style='color:#3BAAE3; text-decoration:underline; #{arg[:style]}' class='#{arg[:class]}'>#{arg[:text] || self.value}</a>"
            
        else
            #this operation cannot be done on this field!
            return self.value
        end
        
    end
    
    def to_grade_int
        
        case self.value
        when /k/i
            return 0
        when /1st/i
            return 1
        when /2nd/i
            return 2
        when /3rd/i
            return 3
        when /4th/i
            return 4
        when /5th/i
            return 5
        when /6th/i
            return 6
        when /7th/i
            return 7
        when /8th/i
            return 8
        when /9th/i
            return 9
        when /10th/i
            return 10
        when /11th/i
            return 11
        when /12th/i
            return 12
        end
        
    end
    
    def to_grade_field
        
        case self.value
        when /k/i
            return "grade_k"
        when /1st/i
            return "grade_1st"
        when /2nd/i
            return "grade_2nd"
        when /3rd/i
            return "grade_3rd"
        when /4th/i
            return "grade_4th"
        when /5th/i
            return "grade_5th"
        when /6th/i
            return "grade_6th"
        when /7th/i
            return "grade_7th"
        when /8th/i
            return "grade_8th"
        when /9th/i
            return "grade_9th"
        when /10th/i
            return "grade_10th"
        when /11th/i
            return "grade_11th"
        when /12th/i
            return "grade_12th"
        end
        
    end
    
    def to_name(options=:full_name)
        
        if (self.field_name.match(/team_id/) || (self.table_name == "team" && self.field_name == "primary_id") ) && !self.value.nil?
            t = $team.get(self.value)
            if t
                case options
                when :full_name
                    return t.legal_first_name.value + " " + t.legal_last_name.value
                when :first
                    return t.legal_first_name.value
                when :last
                    return t.legal_last_name.value
                end
                
            else
                
                return self.value
                
            end
            
        elsif self.field_name.match(/student_id/) && !self.value.nil?
            s = $students.get(self.value)
            if s
                case options
                when :full_name
                    return s.studentfirstname.value + " " + s.studentlastname.value
                when :first
                    return s.studentfirstname.value
                when :last
                    return s.studentlastname.value
                end
                
            else
                
                return self.value
                
            end
            
        else
            #this operation cannot be done on this field!
            return self.value
        end
        
    end
    
    def to_phone_number
        if self.value.class == String
            output = self.value
            output.insert(0, "(") if output.length > 0
            output.insert(4, ") ") if output.length > 4
            output.insert(9, "-") if output.length > 9
            return output
        end
    end
    
    def to_department_group_average
        
        if self.table.field_order.include?("team_id")|| self.table.field_order.include?("department_id")
            
            data_point_array    = Array.new
            
            if self.table.field_order.include?("team_id")
                
                team_id             = table.by_primary_id(primary_id).fields["team_id"].value
                group_tids          = $team.get(team_id).department_with
                
            elsif self.table.field_order.include?("department_id")
                
                department_id       = table.by_primary_id(primary_id).fields["department_id"].value
                
                group_tids          = $tables.attach("TEAM").primary_ids(
                    " WHERE department_id = '#{department_id}' "
                )
                
            end
            
            group_tids.each{|tid|
                
                t = $team.get(tid)
                if t.enrolled_students
                    
                    this_table_name = self.table.table_name.gsub("team_","").gsub("department_","").gsub("_snapshot","")
                    t_data_point = eval("t."+this_table_name+"."+self.field_name)
                    data_point_array.push(t_data_point ? t_data_point.value.to_f : 0.0) if t_data_point && !t_data_point.nil?
                    
                end
              
            } if group_tids
            
            return data_point_array.empty? ? 0.0 : $base.round($base.mean(data_point_array))
            
        end
        
    end
    
    def to_department_group_average!
        
        self.value = to_department_group_average
        self
        
    end
    
    def to_peer_group_average(options = nil)
        
        if self.table.field_order.include?("team_id") || self.table.field_order.include?("peer_group_id")
            
            data_point_array    = Array.new
            
            if self.table.field_order.include?("team_id")
                
                team_id             = table.by_primary_id(primary_id).fields["team_id"].value
                
                if options[:existing]
                    
                    where_clause    = options[:existing].nil? ? "" : "WHERE created_date REGEXP '#{options[:existing]}'"
                    peer_id         = $team.get(team_id).peer_group_id
                    existing_fields = $tables.attach("PEER_GROUP_EVALUATION_SUMMARY_SNAPSHOT").find_field(
                        self.field_name,
                        "#{where_clause} ORDER BY created_date DESC"
                        )
                    return existing_fields ? existing_fields[0] : nil
                    
                end
                
                group_tids          = $team.get(team_id).peers_with
                
            elsif self.table.field_order.include?("peer_group_id")
                
                peer_id             = table.by_primary_id(primary_id).fields["peer_group_id"].value
                department          = table.by_primary_id(primary_id).fields["department_id"].value
                
                group_tids          = $tables.attach("TEAM").primary_ids(
                    " WHERE peer_group_id = '#{peer_id}'
                    AND department_id = '#{department}' "
                )
                
            end
            
            group_tids.each{|tid|
                
                t = $team.get(tid)
                if t.enrolled_students
                    
                    this_table_name = self.table.table_name.gsub("team_","").gsub("peer_group_","").gsub("_snapshot","")
                    t_data_point = eval("t."+this_table_name+"."+self.field_name)
                    data_point_array.push(t_data_point ? t_data_point.value.to_f : 0.0) if t_data_point && !t_data_point.nil?
                    
                end
                
            } if group_tids
            
            return data_point_array.empty? ? 0.0 : $base.round($base.mean(data_point_array))
            
        end
        
    end
    
    def to_peer_group_average!
        
        self.value = to_peer_group_average
        self
        
    end
    
    def deviation_from_peer_group_norm(max_score = nil, max_score_attainable_requested = nil, sd_only = nil)
        
        if self.table.field_order.include?("team_id") && self.datatype == "decimal(5,4)"
            
            if self.value.nil?
                
                proficient_by_default = true
                
            end
            
            data_point_array        = Array.new
            
            team_id                 = table.by_primary_id(primary_id).fields["team_id"].value
            
            focus_team_member       = $team.get(team_id)
            if !focus_team_member.peer_group_id.value.nil?
                
                peer_group_tids = $team.get(team_id).peers_with
                if peer_group_tids && peer_group_tids.length > 1
                    
                    high_score  = nil
                    low_score   = nil
                    peer_group_tids.each{|peer_tid|
                        
                        peer            = $team.get(peer_tid)
                        peer_data_point = eval("peer."+self.table.table_name.gsub("team_","")+"."+self.field_name)
                        if peer_data_point && !peer_data_point.value.nil?
                            
                            this_data_point = peer_data_point.value.to_f
                            high_score      = this_data_point if !high_score || this_data_point > high_score
                            low_score       = this_data_point if !low_score  || this_data_point < low_score
                            data_point_array.push(this_data_point)
                            
                        else
                            
                            #SOMEONE IN THE PEER GROUP DOES NOT HAVE DATA FOR THIS DATAPOINT
                            #SO WE WILL NOT INCLUDE IT.
                            #THE ONLY "OK" REASON TO HIT THIS PART OF THE CODE IS THAT ONE OF THE PEERS DOES NOT
                            #QUALIFY DUE TO NOT HAVING ANY ELIGIBLE STUDENTS FOR A FOR THIS DATAPOINT.
                            
                        end
                        
                      
                    } if peer_group_tids
                  
                else
                    
                    #EITHER THEY HAVEN'T BEEN ASSIGNED A PEER GROUP
                    #OR THEY ARE THE ONLY ONES IN THE GROUP.
                    proficient_by_default = true #WAITING FOR CONFIRMATION FROM TIM ON THIS
                    
                end
                
            else
                
                proficient_by_default = true #WAITING FOR CONFIRMATION FROM TIM ON THIS
                
            end
            
            if data_point_array.length == 1 
                
                proficient_by_default = true
                
            else
                
                m                       = $base.mean(data_point_array)
                sd                      = $base.standard_deviation(data_point_array)
                
                if false && sd && $user == "Athena-SIS"
                    
                    puts field_name
                    puts sd
                    puts m-sd*3
                    puts m-sd*2
                    puts m-sd*1
                    puts m
                    puts m+sd*1
                    puts m+sd*2
                    puts m+sd*3
                    
                end
                
            end
           
            if max_score_attainable_requested
                
                return proficient_by_default ? nil : (m+sd <= 1)
                
            elsif sd_only
                
                return proficient_by_default ? 0.0 : sd
                
            end
            
            if proficient_by_default || sd
                
                if max_score
                    
                    if proficient_by_default || self.value.to_f >= m-sd 
                        
                        if !proficient_by_default && m+sd > 1
                            
                            if self.value.to_f > m
                              
                                return max_score.to_f               #if 40 => 40
                              
                            else
                              
                                return (max_score.to_f/4)*3         #if 40 => 30
                              
                            end
                            
                        end
                        
                        if !proficient_by_default && self.value.to_f > m+sd
                          
                            return max_score.to_f               #if 40 => 40
                          
                        else
                          
                            return (max_score.to_f/4)*3         #if 40 => 30
                          
                        end
                      
                    else
                      
                        if self.value.to_f < m-sd*2
                          
                            return (max_score.to_f/4)           #if 40 => 10
                          
                        else
                          
                            return (max_score.to_f/4)*2         #if 40 => 20
                          
                        end
                      
                    end
                    
                else
                    
                    return 0 if sd == 0
                    
                    if !proficient_by_default && m+sd > 1 && self.value.to_f >= m-sd 
                        
                        if self.value.to_f < m
                            
                            return 0.0               
                            
                        else
                            
                            return 2.0        
                            
                        end
                        
                        
                    elsif !proficient_by_default && self.value.to_f <= m-sd*3
                        
                        return -3.0
                     
                    elsif !proficient_by_default && self.value.to_f < m-sd*2
                        
                        return -2.5
                     
                    elsif !proficient_by_default && self.value.to_f == m-sd*2
                        
                        return -2.0
                       
                    elsif !proficient_by_default && self.value.to_f < m-sd
                        
                        return -1.5
                      
                    elsif !proficient_by_default && self.value.to_f == m-sd
                        
                        return -1.0
                       
                    elsif !proficient_by_default && self.value.to_f < m
                        
                        return -0.5
                        
                    elsif self.value.to_f == m || proficient_by_default
                        
                        return 0.0
                        
                    elsif self.value.to_f < m+sd
                        
                        return 0.5
                        
                    elsif self.value.to_f == m+sd
                        
                        return 1.0
                     
                    elsif self.value.to_f < m+sd*2
                        
                        return 1.5
                     
                    elsif self.value.to_f == m+sd*2
                        
                        return 2.0
                       
                    elsif self.value.to_f < m+sd*3
                        
                        return 2.5
                     
                    elsif self.value.to_f == m+sd*3
                        
                        return 3.0
                        
                    end
                    
                end
                
            else
                
                return false
                
            end
         
        else
            
            return false #BECAUSE THIS FUNTION DOESN'T APPLY TO THE FIELD
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def prep_bool
        truthy =  is_true?
        falsy  =  is_false?
        if truthy || falsy
            if @to_type == "user"
                return "Yes" if truthy
                return "No" if falsy
            end
            if @to_type == "db"
                return '1' if truthy
                return '0' if falsy
            end    
        else
            raise "#{__FILE__}#{__LINE__}:self.value is not bool."
        end
    end
    
    def prep_date
        date = nil
        if self.value == "N/A"
            return "NULL"   
        elsif !self.value.is_a? Time
            date = mathable
        elsif self.value.is_a? Time
            date = self.value
        end
        if date == 0
            $base.system_notification("PREP DATE FAILED - #{table}", "FIELD: #{field_name} VALUE: #{value}")
        end
        return date.strftime("%m/%d/%Y")        if @to_type == "user" && @option.nil? || @option == :standard
        return date.strftime("%A %B %d, %Y")    if @to_type == "user" && @option == :long
        return date.strftime("%Y-%m-%d")        if @to_type == "db"
    end
    
    def prep_datetime
        date_time = mathable
        
        return date_time.strftime("%m/%d/%Y %I:%M:%S %p") if @to_type == "user"
        return date_time.strftime("%Y-%m-%d %H:%M:%S"   ) if @to_type == "db"
    end
    
    def prep_decimal(dp = 4)
        self.value.strip! if self.value.class == String
        if self.value == "N/A"
            return "NULL"
        end
        if self.file_data_type == :percentage
            return self.value.split('%')[0].to_f/100
        end
        if self.file_data_type == :percent_number
            return self.value.to_f/100
        end       
        return ((self.value.to_f*10**dp).round/(10.0**dp)).to_s
        #if self.value.is_a?(String) && percent_str.index('%')
        #    decimal = percent_str.split('%')[0]
        #    return decimal.to_f/100
        #elsif table.table_name == "k12_calms_aggregate_progress" || table.table_name == "jupiter_grades"#percent_str.to_f > 1
        #    return percent_str.to_f/100
        #elsif percent_str.to_f < 1
        #    return percent_str
        #else
        #    return percent_str
        #end
    end
    
    def prep_percent
        if !self.value.is_a? Float
            self.value = self.value.to_f
        end
        return "#{(self.value * 100.0).round}%"
    end
    
    def prep_text
        if self.value
            self.value.gsub("/r","")
            return self.value.strip.empty? ? "NULL" : Mysql.quote(self.value.strip)
        end 
    end
    
    def prep_year
        if self.value.length == 4 && Integer(self.value)
            return self.value
        else
            return "NULL"
        end
    end
    
    def sub_day(quant = 1) 
        return $db.get_data_single("SELECT DATE_SUB('#{to_db}', INTERVAL #{quant} DAY)")[0] 
    end
    
    def add_day(quant = 1)
        return $db.get_data_single("SELECT DATE_ADD('#{to_db}', INTERVAL #{quant} DAY)")[0] 
    end
    
    def add_day_midnight(quant = 1)
        return $db.get_data_single("SELECT DATE_FORMAT(DATE_ADD('#{to_db}', INTERVAL #{quant} DAY), '%Y-%m-%d 00:00:00')")[0] 
    end

    def trim_lead(str, n)
        
        if str
            trimmed_str = str.gsub(/^#{n}+/,'')
            trimmed_str = "0" if str.empty?
            return trimmed_str
        end
        
        return str
        
    end
 
end