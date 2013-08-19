#!/usr/local/bin/ruby

class Web_DD

    #---------------------------------------------------------------------------
    def initialize()
        @structure = structure
        
    end
    #---------------------------------------------------------------------------
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def bool
        
        return [
            {:name=>"Yes",      :value=>"1"        },
            {:name=>"No",       :value=>"0"        }
        ]
        
    end
    
    def departments
        
        return $tables.attach("DEPARTMENT").dd_choices(
            "name",
            "primary_id",
            " ORDER BY name ASC "
        )
        
    end
    
    def department_categories
        
        return from_array(
            
            [
                "Academic",
                "Engagement",
                "Software"
            ]
            
        )
        
    end
    
    def department_focus
        
        return from_array(
            
            [
                "Elementary School",
                "Middle School",
                "High School",
                "Learning Center",
                "Operations",
                "Elementary School|Middle School|High School",
                "Elementary School|Middle School"
            ]
            
        )
        
    end
    
    def gender
        
        return from_array(
            
            [
                "Male",
                "Female"
            ]
            
        )
        
    end
    
    def range(from, to)
        this_range = Array.new
        i = from
        until i > to
            this_range.push(i.to_s)
            i+=1
        end
        return from_array(this_range)
    end
    
    def peer_group_id
        
        return range(1, 20)
        
    end
    
    def positions
        
        return from_array(
            
            [
             
                "Classroom Coach",
                "Director",
                "Family Coach",
                "Principal",
                "Support",
                "Teacher"
               
            ]
            
        )
        
    end
    
    def team_members(a={})
        
        where_clause = "WHERE"
        
        where_clause << " team.department_id = '#{a[:department_id]}'"              if a[:department_id]
        where_clause << " team.department_category = '#{a[:department_category]}'"  if a[:department_category]
        
        return $tables.attach("TEAM").dd_choices(
            "CONCAT(legal_first_name,' ',legal_last_name,' ID: ',primary_id)",
            "primary_id",
            "#{where_clause.length > 5 ? where_clause : ""} ORDER BY legal_first_name, legal_last_name, primary_id ASC "
        )
        
    end
    
    def from_array(dd_array) #returns dd array where the name an value are the same.
        
        output = Array.new
        dd_array.each{|element|
            
            output.push({:name=>element,:value=>element})
            
        }
        return output
        
    end
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DD_OBJECTS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

   def test_events
    if !structure.has_key?("test_events")
      require "#{$paths.base_path}web_dd_test_events"
      structure["test_events"] = WEB_DD_TEST_EVENTS.new
    end
    return structure["test_events"]
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
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

end