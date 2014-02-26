#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__)}/datamat"
require "#{File.dirname(__FILE__)}/web"

class Field < Datamat

    #---------------------------------------------------------------------------
    def initialize(params = {})
        super()
        @structure = nil
       
        self.datatype   = params["type"]        if params["type"]
        self.field_name = params["field"]       if params["field"]
        self.table      = params["table"]       if params["table"]
        self.value      = params["value"]       if params["value"]
        self.primary_id = params["primary_id"]  if params["primary_id"]
        self.file_data_type = params[:file_data_type] if params[:file_data_type]
    end
    #---------------------------------------------------------------------------

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ACCESSORS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def datatype
        structure["datatype"]
    end
    
    def field_name
        structure["field_name"]
    end
    
    def file_data_type
        structure[:file_data_type]
    end
    
    def primary_id
        structure["primary_id"]
    end
    
    def table
        structure["table"]
    end
    
    def table_class
        table.class.to_s
    end
    
    def table_name
        table.table_name
    end
    
    def updated
        structure[:updated]
    end
    
    def valid
        structure["valid"]
    end
    
    def value
        structure["value"]
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def gsub(arg1,arg2)
        value.gsub(arg1,arg2)
    end
    
    def gsub!(arg1,arg2)
        value = value.gsub(arg1,arg2) if !value.nil?
        self
    end
    
    def is_schoolday?
        if datatype == "date" || datatype == "datetime"
            this_date = to_db.split(" ")[0]
            if s = $school.school_days
                return $school.school_days.include?(this_date) ? true : false
            else
                return false
            end
            
        else
            false
        end
    end
    
    def match(expr)
        
        if !value.nil?
            return value.match(expr)
        else
            return false
        end
        
    end
    
    def save
        record = table.by_primary_id(primary_id)
        record.fields[field_name].value = value
        record.save
    end
    
    def set(arg)
        self.value=(arg)
        return self
    end
    
    #def set(new_field_value)
    #    record = table.by_primary_id(primary_id)
    #    record.fields[field_name].value = new_field_value
    #    record.save
    #end
    
    def validate
        #Currently there is no global validation.
        table.special_validation(self) if table.respond_to?("special_validation")
    end
    
    def validation_failed(failed_reason)
        valid = false
        row = $tables.attach("Data_Validation").new_row
        row.fields["table_name"     ].value = table.class.to_s
        row.fields["field_name"     ].value = field_name
        row.fields["row_id"         ].value = primary_id 
        row.fields["data_type"      ].value = datatype   
        row.fields["failed_value"   ].value = to_db
        row.fields["failed_reason"  ].value = failed_reason
        row.save
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def field_name=(arg)
        structure["field_name"] = arg
    end
    
    def primary_id=(arg)
        structure["primary_id"] = arg
    end
    
    def updated=(arg)
        structure[:updated] = arg
    end
    
    def valid=(arg)
        structure["valid"] = false
    end

    def value=(arg)
        structure["value"] = arg
    end
  
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
def x______________OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def web
        if !structure.has_key?("web")
            structure["web"] = Web.new(self)
        end
        structure["web"]
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def datatype=(arg)
        structure["datatype"] = arg
    end
    
    def file_data_type=(arg)
        structure[:file_data_type] = arg
    end
    
    def table=(arg)
        structure["table"] = arg
    end
    
end