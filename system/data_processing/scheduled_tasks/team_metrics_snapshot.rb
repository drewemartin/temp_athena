#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("data_processing/scheduled_tasks","base/base")
require File.dirname(__FILE__).gsub("scheduled_tasks","Team_Metrics")

class Evaluation_Snapshot < Base
  
  #TRY THIS AS A BATCH FILE
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    roles = $team.student_base_evaluation_roles
    if roles
      roles.each{|role|
        
        eligible_team_members      = $team.members_by_role(role)     
        
        if eligible_team_members
          #REMOVE INELLIGIBLE TEAM MEMBERS
          ineligible_team_members = $team.student_based_evaluation_exempt(role)
          ineligible_team_members.each{|samsid| eligible_team_members.delete(samsid) if eligible_team_members.include?(samsid)} if ineligible_team_members
          
          eligible_team_members.shift(2).each{|samsid|
               if !$tables.attach("TEAM_METRICS_STUDENT_BASED").by_samsid_role(samsid, role, @reporting_period)
                    task = Thread.new{
                         metrics = Team_Metrics.new
                         puts "3"
                         metrics.team_member_snapshot(samsid, role)
                         puts "4"
                    }
                    i=1
                    #task.join
               end 
          }
          i = 0
        end
      }
    end
    
  end
  #---------------------------------------------------------------------------
  
end

Evaluation_Snapshot.new(ARGV)