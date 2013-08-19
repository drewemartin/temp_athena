#!/usr/local/bin/ruby

class Change_Field_By_Pid
    
    def bulk_change(table_name, authorizor, reason, fileName)
        $tables.attach(table_name).bulk_field_by_pid("#{$paths.documents_path}/#{fileName}", reason, authorizor)
    end

end