#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/field"

class Row

    #---------------------------------------------------------------------------
    def initialize(table_object, primary_id = nil)
        @structure      = nil
        self.table      = table_object
        set_fields
        self.primary_id = primary_id if primary_id
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def batch_checkbox(arg = nil)
        $field.new(
            {
                "type"      => "bool",
                "field"     => "selected__#{self.primary_id}"
            }
        ).web.checkbox(:add_class  => "no_save")
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def fields
        structure["fields"]
    end
    
    def field_values
        values = Array.new
        fields.each_value{|v| values.push(v.value)}
        return values
    end
    
    def primary_id
        fields["primary_id"].value
    end
    
    def table
        structure["table"]
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def add_field(fieldname, datatype)
        fields[fieldname] = Field.new(datatype, table)
    end
    
    def clear
        fields.each_value{|field| field.value = nil}
    end
    
    def delete
        @structure.each_key{|key|
         @structure.delete(key)    
        }
    end
    
    def header_string
        results = String.new
        i = 0
        table.field_order.each.each{|field_name|
            field_str = i == 0 ? "#{field_name}" : ",#{field_name}"
            results << field_str
            i+=1}
        return results
    end
    
    def insert
        
        proceed_with_insert = table.find_and_trigger_event(event_type = :before_insert, args = self)
        
        if proceed_with_insert
            
            field_str   = nil
            values_str  = nil
            user = $user.class == Team_Member ? $user.email_address_k12.value : $user
            fields["created_by"].value = $base.created_by ? $base.created_by : user
            fields.each_pair do |field_name, field_obj|
                unless field_name == "created_date" || field_name == "primary_id"
                    field = "`#{field_name}`"
                    value = field_obj.to_db == "NULL" ? field_obj.to_db : "'#{field_obj.to_db}'"
                    field_str   = field_str.nil?  ? "#{field}" : "#{field_str},#{field}"
                    values_str  = values_str.nil? ? "#{value}" : "#{values_str},#{value}"
                end
            end
            
            tstamp_mod           = $base.created_date   ? ",`created_date`"             : ""
            tstamp_mod_value     = $base.created_date   ? ",'#{$base.created_date}'"    : ""
            
            insert_sql =
                "INSERT INTO #{table.table_name}
                (#{field_str}#{tstamp_mod})
                VALUES(#{values_str}#{tstamp_mod_value})"
            self.primary_id = $db.insert(insert_sql, table.data_base)
            table.find_and_trigger_event(event_type = :after_insert, args = self)
            validate
            
            return primary_id
            
        else
            
            return false
            
        end
        
    end
    
    def record_exists?
        $db.get_data_single("SELECT primary_id FROM #{table.table_name} WHERE primary_id = '#{fields["primary_id"].value}'", table.data_base)
    end
    
    def save(audit_trail = true)
#        table.find_and_trigger_event(event_type = :before_save)
        if record_exists?
            update(audit_trail)
        else
            insert
        end
        #table.find_and_trigger_event(event_type = :after_save_field, args = field)
        table.find_and_trigger_event(event_type = :after_save, args = self)
        return primary_id
    end
    
    def string_with_fieldnames
        results = String.new
        i = 0
        table.field_order.each{|field_name|
            value = Mysql.quote("#{field_name.upcase}: #{fields[field_name].value}")
            field_str = i == 0 ? "#{value}" : ",#{value}"
            results << field_str
            i+=1
        }
        return results
    end
    
    def string
        results = String.new
        i = 0
        table.field_order.each{|field_name|
            field_value = fields[field_name].value
            value       = field_value ? field_value.gsub('"','""') : nil
            field_str   = i == 0 ? "\"#{value}\"" : ",\"#{value}\""
            results << field_str
            i+=1
        }
        return results
    end
  
    def to_db
        fields.each_value{|field| field.to_db}
    end
    
    def to_db!
        fields.each_value{|field| field.to_db!}
    end
    
    def to_user
        fields.each_value{|field| field.to_user}
    end
    
    def to_user!
        fields.each_value{|field| field.to_user!}
    end
    
    def trim_fields_not_listed(field_list)
        fields.each_pair{|field_name, details|
            fields.delete(field_name) if !field_list.include?(field_name)    
        }
    end
 
    def validate
        fields.each_pair{|field_name, field_object| field_object.validate}
    end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure(struct_hash = nil)
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def audit_trail(field, new_value)
        table_fields    = "`#{field}`,`modified_pid`,`modified_field`,`modified_by`,`modified_value`"
        user            = $user.class == Team_Member ? $user.email_address_k12.value : $user
        previous        = get_field(field)
        table_values    = "'#{previous ? Mysql.quote(get_field(field)) : ""}','#{fields["primary_id"].value}','#{field}','#{user}',#{new_value}"
        
        tstamp_mod          = $base.created_date ? ",`modified_date`"           : ""
        tstamp_mod_value    = $base.created_date ? ",'#{$base.created_date}'"   : ""
        
        insert_sql =
            "INSERT INTO zz_#{table.name}
            (#{table_fields}#{tstamp_mod})
            VALUES(#{table_values}#{tstamp_mod_value})"
        return $db.insert(insert_sql, table.data_base)
    end
    
    def get_field(field)
        $db.get_field(table.name, fields["primary_id"].value, field, table.data_base)
    end
    
    def set_fields()
        fields_hash = Hash.new
        self.table.fields.each_pair do |fieldname, details|
            params = {
                "type"  =>  details["data_type"],
                "table" =>  self.table,
                "field" =>  fieldname
            }
            params[:file_data_type] = details[:file_data_type] if details.has_key?(:file_data_type)
            fields_hash[fieldname] = $field.new(params)
            #fields_hash[fieldname] = Field.new(details["data_type"], self.table, fieldname)
        end
        user = $user.class == Team_Member ? $user.email_address_k12.value : $user
        fields_hash["created_by"].value = user
        structure["fields"] = fields_hash
    end
    
    def update(create_audit_trail)
        
        if table.find_and_trigger_event(event_type = :before_change,  args = self)
            
            pre_update_record = table.by_primary_id(primary_id)
            
            fields.each_pair do |field_name, field|
                
                unless field_name == "primary_id" || field_name == "created_by" || field_name == "created_date"
                    
                    current_value = pre_update_record.fields[field_name].value
                    current_value = current_value && current_value.length > 0 ? current_value : "NULL"
                    
                    if $base.to_db(field.datatype, current_value).to_s != field.to_db.to_s
                        
                        if table.find_and_trigger_event(event_type = :before_change_field,  args = field)
                            
                            new_value = field.to_db == "NULL" ? field.to_db : "'#{field.to_db}'"
                            if table.audit
                                audit_trail(field_name, new_value)
                            end
                            update_sql = 
                                "UPDATE `#{table.name}`
                                SET `#{field_name}` = #{new_value}
                                WHERE `primary_id` = '#{fields["primary_id"].value}'"
                            $db.query(update_sql, table.data_base)
                            
                            table.find_and_trigger_event(event_type = :after_change_field,  args = field)
                            table.find_and_trigger_event(event_type = :after_change,        args = self)
                            
                            field.updated = true
                            
                        else
                            
                            field.updated = false
                            
                        end
                        
                    end
                    
                end
                
            end
            
            validate
            
        end
        
        return primary_id
        
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def table=(arg)
        structure["table"] = arg
    end
    
    def primary_id=(arg)
        self.fields["primary_id"].value = arg
        self.fields.each_pair{|field_name, field_object| field_object.primary_id = arg}
    end
end