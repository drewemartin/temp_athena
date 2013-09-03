#!/usr/local/bin/ruby

class Athena_Config
    
    #---------------------------------------------------------------------------
    def initialize(school_year = nil) 
        @structure       = nil
        
        @code_set_name   = "athena"
        
        self.school_name = "agora"
        
        $sys_admin_email    = "jhalverson@agora.org"
        self.offsite_root   = "ftp.athena-sis.com"
        
        self.storage_root   = File.exists?("Q:/athena_files") ? "Q:/athena_files" :"#{File.dirname(__FILE__)}/athena_files"
        self.system_root    = "#{File.dirname(__FILE__)}/#{@code_set_name}"
     
        #LOCAL
        self.db_domain      = "localhost"
        self.db_pass        = "Lemodie"
        self.db_user        = "root"
        
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
    
    def offsite_root
        structure[:offsite_root]
    end
    
    def school_name
        structure[:school_name]
    end
    
    def school_year
        structure[:school_year]
    end
    
    def storage_root
        structure[:storage_root]
    end
    
    def system_root
        structure[:system_root]
    end
    
    def db_domain
        structure[:db_domain]
    end
    
    def db_name
        structure[:db_name]
    end
    
    def db_pass
        structure[:db_pass]
    end
    
    def db_user
        structure[:db_user]
    end
    
    def code_set_name
        return @code_set_name
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________MODIFIERS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def offsite_root=(arg)
        structure[:offsite_root] = init_path(arg)
    end
    
    def school_name=(arg)
        structure[:school_name] = arg
    end
    
    def school_year=(arg)
        self.db_name = "#{self.school_name}_#{arg.gsub("-","")}"
        structure[:school_year] = arg
    end
    
    def storage_root=(arg)
        structure[:storage_root] = init_path(arg)
    end
    
    def system_root=(arg)
        structure[:system_root] = init_path(arg)
    end
    
    def db_domain=(arg)
        structure[:db_domain] = arg
    end
    
    def db_name=(arg)
        structure[:db_name] = arg
    end
    
    def db_pass=(arg)
        structure[:db_pass] = arg
    end
    
    def db_user=(arg)
        structure[:db_user] = arg
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________FUNCTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def init_path( path )
        #path    = clean_path(path)
        paths   = path.split('/')
        index   = 0
        while index < paths.length
            thispath = "#{ thispath }#{paths[ index ]}/"
            if !File.directory?( thispath ) 
                Dir.mkdir( thispath )
            end
            index += 1
        end
        return thispath
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

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