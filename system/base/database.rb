#!/usr/local/bin/ruby

class Database
  
  #---------------------------------------------------------------------------
  def initialize
    super()
    
  end
  #---------------------------------------------------------------------------

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

  def get_data( sql, selected_db = nil )
    begin
      results = query( sql, selected_db ) 
    rescue
      return false
    end
    
    data = Array.new
    
    begin
      i = 0
      results.each do |row| 
        data.push( row ) 
        i+=1 
      end
      
      if i == 0
        return false 
      end
      
    rescue
      return false
    end
    
    return data
  end

  def get_data_single( sql, selected_db = nil )
    begin
      results = query( sql, selected_db ) 
    rescue
      return false
    end
    
    data = Array.new
    
    begin 
      i = 0
      results.each do |row|
        data.push( row[0] )
        i+=1 
      end
      
      if i == 0
        return false 
      end
    rescue
      return false
    end
    
    return data
  end

  def get_field(table_name, primary_id, field, selected_db)
    select_sql =
      "SELECT `#{field}`
      FROM `#{table_name}`
      WHERE `primary_id` = #{primary_id}"
    results = query(select_sql, selected_db)
    if results
      field_value = nil
      results.each{|value| field_value = value[0]}
      return field_value
    else
      return false
    end
  end
  
  def insert(sql, selected_db = nil)
    query(sql, selected_db)
    return @last_insert.fetch_row[0]
  end
  
  def query(sql, selected_db = nil)
    tries = 0
    begin
      
      m = Mysql::new($config.db_domain, $config.db_user, $config.db_pass)
      m.query("CREATE DATABASE IF NOT EXISTS `#{selected_db || $config.db_name}`") unless selected_db == "information_schema"
      m.select_db(selected_db || $config.db_name)
      
      if false
        
        m.query(
          "INSERT INTO `agora_20132014`.`temp_query_log` (
            `PRIMARY_ID` ,
            `query_text` 
          )
          VALUES (NULL , '#{Mysql.quote(sql)}');"
        )
        
      end
      
      results         = m.query(sql)
      
      @last_insert    = m.query("SELECT LAST_INSERT_ID();")
      
      m.kill(m.thread_id)
      
      return results
      
    rescue Mysql::Error => e
      
      if (e.errno == 2006 || e.errno == 2003) && tries < 5
        tries+=1
        retry
      else
        
        content = "SQL QUERY FAILED\n"
        content << "Error code:       #{e.errno}\n"
        content << "Error message:    #{e.error}\n"
        content << "Error SQLSTATE:   #{e.sqlstate}\n" if e.respond_to?("sqlstate")
        content << "Statement Attempted: \n#{sql}\n"
        content << "Caller:             #{caller[0]}\n"
        content << "BACKTRACE:        #{e.backtrace}"
        
        if ENV["COMPUTERNAME"].match(/ATHENA|HERMES/)
          $base.system_notification("SQL QUERY FAILED!",content)
        else
          puts content
          raise e
          $base.system_log(content)
        end
        
      end
      
    end
  end
  
  def where_clause(params, multi_operator = "AND") #accepts an array of 'WHERE_PARAM' structures.
    where_clause = params.empty? ? "" : "WHERE "
    i=0
    params.each do |param|
      param_value = param.VALUE.to_s
      if param_value == "NULL" || param_value.match(/CURDATE()/) || param.EVALUATOR == "IS"
        value = param_value
      elsif param.VALUE.class == Array
        param.EVALUATOR = "IN"
        value = "('#{param.VALUE.join("','")}')"
      else
        value = "'#{Mysql.quote(param_value)}'"
      end
      
      param_one   = "#{param.FIELD} #{param.EVALUATOR} #{value}"
      more_params = "#{multi_operator} #{param.FIELD} #{param.EVALUATOR} #{value}"
      param_statement = i == 0 ? param_one : more_params
      where_clause = "#{where_clause} #{param_statement}"
      i+=1
    end
    return where_clause
  end 

end