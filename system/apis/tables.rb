#!/usr/local/bin/ruby

class Tables

    #---------------------------------------------------------------------------
    def initialize()
        @structure = nil
        #init_pre_reqs
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attach(table_name)
        if structure.has_key?(table_name)
            return structure[table_name]
        else
            
            begin
                instantiate_table(table_name)
            rescue LoadError
                return false
            end
            
            return structure[table_name]
            
        end  
    end

    def table(table_name)
        if structure.has_key?(table_name)
            return structure[table_name]
        else
            #Check Status of the tables
            #If the table is up to date
            #   instantiate it
            #Else
            #   send system notification
            #   attempt the import
            #   If the import attempt succeeds
            #       attach
            #   Else
            #       send system notification
            #       throw and error
            #   End
            #End
            instantiate_table(table_name)
            return structure[table_name]
        end  
    end
    
    def table_names
        names = Array.new
        Dir["#{File.dirname(__FILE__).gsub("apis","tables/*.rb")}"].each {|file|
            names.push(file.split("/").last.split(".").first)
        }
        return names
    end
    
    def k12_table_names
        names = Array.new
        Dir["#{File.dirname(__FILE__).gsub("apis","tables/*.rb")}"].each {|file|
            table_name = file.split("/").last.split(".").first
            names.push(table_name) if table_name.split("_")[0] == "K12"
        }
        return names
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def instantiate_table(table_name)
        require "#{$paths.tables_path}#{table_name.downcase}"
        set_structure( {table_name=>Object.const_get(table_name.upcase).new} )
    end
    
    #def pre_reqs
    #    ["Db_Config","SYSTEM_LOG","School_Year_Detail"]
    #end
    #
    #def init_pre_reqs
    #    pre_reqs.each{|req|
    #        req_table = attach(req)
    #        if !req_table.exists?
    #            req_table.init
    #            req_table.load if req_table.import_file_exists?
    #        end
    #    }
    #end
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def set_structure(arg)
        if arg.is_a? Hash
            arg.each_pair{|k, v|
                @structure[k] = v
            }
        end
    end
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end
    
end