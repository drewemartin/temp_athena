#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class TEAM_DISTRICTS_INITIAL_SETUP < Base
    
    def initialize()
        
        super()
        
        CSV.foreach("#{$paths.imports_path}team_districts.csv")do|row|
          
          if team_member = $team.find(:full_name=>row[0])
            if aun = $tables.attach("DISTRICTS_AUN").field_value("aun", "WHERE name = '#{row[1].gsub("  "," ")}'")
              record = team_member.districts.new_record
              record.fields["aun"    ].value = aun
              record.fields["role"   ].value = 'Truancy Prevention Coordinator'
              record.fields["active" ].value = true
              record.save
            else
              puts row[1]
            end
          else
            puts row[0]
          end
          
        end
        
        $tables.attach("STUDENT_RELATE").truancy_prevention_coordinator
        
    end
    
end

TEAM_DISTRICTS_INITIAL_SETUP.new()