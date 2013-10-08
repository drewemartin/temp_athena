#!/usr/local/bin/ruby

class Paths

    def initialize()
        
        @structure = nil
        
        api_path
        backup_path
        base_path
        commands_path
        conversion_path
        htdocs_path
        imported_path
        imports_path
        restore_path
        reports_path
        #student_path
        system_path
        tables_path
        #team_member_path
        templates_path
        web_interfaces_path
        
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________PATHS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def api_path
        if !structure.has_key?(:api_path)
            structure[:api_path] = $config.init_path("#{system_path}apis")
        end
        return structure[:api_path]    
    end
    
    def backup_path
        if !structure.has_key?(:backup_path)
            structure[:backup_path] = $config.init_path("#{$config.storage_root}backup")
        end
        return structure[:backup_path]    
    end
    
    def base_path
        if !structure.has_key?(:base_path)
            structure[:base_path] = $config.init_path("#{system_path}base")
        end
        return structure[:base_path]    
    end
    
    def commands_path
        if !structure.has_key?(:commands_path)
            structure[:commands_path] = $config.init_path("#{system_path}commands")
        end
        return structure[:commands_path]    
    end
    
    def conversion_path
        if !structure.has_key?(:conversion_path)
            structure[:conversion_path] = $config.init_path("#{commands_path}conversion_scripts")
        end
        return structure[:conversion_path]    
    end
    
    def data_processing_path
        if !structure.has_key?(:data_processing_path)
            structure[:data_processing_path] = $config.init_path("#{system_path}data_processing")
        end
        return structure[:data_processing_path]    
    end
    
    def documents_path
        if !structure.has_key?(:documents_path)
            
            if !File.directory?( "A:/" )
                
                require 'win32ole'
                net = WIN32OLE.new('WScript.Network')
                user_name = "Athena"
                password  = "YEree77d3ysPQhYE"
                net.MapNetworkDrive( 'A:', "\\\\10.1.10.254\\a", nil,  user_name, password )
                
            end
            
            structure[:documents_path] = $config.init_path("A:/documents")
            
        end
        return structure[:documents_path]
    end
    
    def document_error_path
        if !structure.has_key?(:document_error_path)
            
            #if ENV["COMPUTERNAME"] == "ATHENA"
                structure[:document_error_path] = $config.init_path("A:/document_error")
            #else
                #structure[:document_error_path] = $config.init_path("#{htdocs_path}document_error")
            #end
            
        end
        return structure[:document_error_path]
    end
    
    def htdocs_path
        if !structure.has_key?(:htdocs_path)
            path_array = $config.system_root.split("/")
            path_array.delete($config.code_set_name)
            new_path = path_array.join("/")+"/"
            structure[:htdocs_path] = new_path
        end
        return structure[:htdocs_path]    
    end
    
    def imported_path
        if !structure.has_key?(:imported_path)
            structure[:imported_path] = $config.init_path("#{$config.storage_root}imports/imported")
        end
        return structure[:imported_path]    
    end
    
    def imports_path
        if !structure.has_key?(:imports_path)
            structure[:imports_path] = $config.init_path("#{$config.storage_root}imports")
        end
        return structure[:imports_path]    
    end
    
    def restore_path
        if !structure.has_key?(:restore_path)
            structure[:restore_path] = $config.init_path("#{$config.storage_root}restore")
        end
        return structure[:restore_path]    
    end
    
    def restore_path=(arg)
        structure[:restore_path] = $config.init_path(arg)   
    end
    
    def reports_path
        if !structure.has_key?(:reports_path)
            structure[:reports_path] = $config.init_path("#{$config.storage_root}reports")
        end
        return structure[:reports_path]    
    end
    
    #def student_path(sid)
        #$config.init_path("#{$config.system_root.gsub(@code_set_name,"Student_Records/StudentID_#{sid}/SY_#{$school.current_school_year.value}#{sub_directory}")}")  
    #end
    
    def student_path(sid, sub_directory = nil)
        sub_directory = "/" + sub_directory if sub_directory
        $config.init_path("#{htdocs_path}Student_Records/StudentID_#{sid}/SY_#{$school.current_school_year.value}#{sub_directory}")  
    end
    
    def system_path
        if !structure.has_key?(:system_path)
            structure[:system_path] = $config.init_path("#{$config.system_root}system")
        end
        return structure[:system_path]    
    end
    
    def tables_path
        if !structure.has_key?(:tables_path)
            structure[:tables_path] = $config.init_path("#{system_path}tables")
        end
        return structure[:tables_path]    
    end
    
    def team_member_path(tid, sub_directory = nil)
        sub_directory = "/" + sub_directory if sub_directory
        $config.init_path("#{htdocs_path}Team_Member_Records/TeamID_#{tid}/SY_#{$school.current_school_year.value}#{sub_directory}")    
    end
    
    def temp_path
        if !structure.has_key?(:temp_path)
            structure[:temp_path] = $config.init_path("#{htdocs_path}temp")
        end
        return structure[:temp_path]
    end
    
    def templates_path
        if !structure.has_key?(:templates_path)
            structure[:templates_path] = $config.init_path("#{system_path}templates")
        end
        return structure[:templates_path]    
    end
    
    def web_interfaces_path
        if !structure.has_key?(:web_interfaces_path)
            structure[:web_interfaces_path] = $config.init_path("#{system_path}web_interfaces")
        end
        return structure[:web_interfaces_path]    
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
end