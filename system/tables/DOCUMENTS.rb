#!/usr/local/bin/ruby
require "#{$paths.base_path}athena_table"

class DOCUMENTS < Athena_Table
    
    #---------------------------------------------------------------------------
    def initialize()
        super()
        @table_structure = nil
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def document_exists_by_time(type_id, created_date)
        $db.get_data(
            "SELECT documents.primary_id FROM #{data_base}.documents
            WHERE documents.type_id = '#{type_id}'
            AND created_date = '#{created_date}'"
        )
    end
    
    def document_pids(type_id, table=nil, key_field=nil, key_field_value=nil, created_date=nil, sort="DESC") 
        
        check_doc_relate = (table && key_field && key_field_value) ? true : false
        sy_string = $config.school_year
        sql_str =  "SELECT #{data_base}.documents.primary_id FROM #{data_base}.documents "
        if check_doc_relate
            sql_str << "LEFT JOIN #{data_base}.document_relate
                ON #{data_base}.documents.primary_id = #{data_base}.document_relate.document_id
                WHERE #{data_base}.document_relate.table_name = '#{table}'
                AND #{data_base}.document_relate.key_field = '#{key_field}'
                AND #{data_base}.document_relate.key_field_value = '#{key_field_value}'
                AND #{data_base}.documents.type_id = '#{type_id}' 
                AND #{data_base}.documents.school_year = '#{sy_string}' "
        else
            sql_str << "WHERE #{data_base}.documents.type_id = '#{type_id}' "
        end
        
        sql_str << "AND #{data_base}.documents.created_date = '#{created_date}' " if created_date
        
        sql_str << "ORDER BY #{data_base}.documents.created_date #{sort}" 
        
        $db.get_data(sql_str)
    end
    #change
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________TRIGGER_EVENTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________VALIDATION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def table
        if !@table_structure
            structure_hash = {
                :data_base          => "#{$config.school_name}_master",
                "name"              => "documents",
                "file_name"         => "documents.csv",
                "file_location"     => "documents",
                "source_address"    => nil,
                "source_type"       => nil,
                "audit"             => true#,
                #:relationship       => :one_to_many
            }
            @table_structure = set_fields(structure_hash)
        end
        return @table_structure
    end
    
    def set_fields(structure_hash)
        field_order = Array.new
        structure_hash["fields"] = Hash.new
            
            structure_hash["fields"]["category_id"  ] = {"data_type"=>"int",  "file_field"=>"category_id"    } if field_order.push("category_id" )
            structure_hash["fields"]["type_id"      ] = {"data_type"=>"int",  "file_field"=>"type_id"        } if field_order.push("type_id"     )
            structure_hash["fields"]["school_year"  ] = {"data_type"=>"text", "file_field"=>"school_year"    } if field_order.push("school_year" )
            
        structure_hash["field_order"] = field_order
        return structure_hash
    end

end