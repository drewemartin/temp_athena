#!/usr/local/bin/ruby
require "#{File.expand_path(File.dirname(__FILE__))}/system/base/base"
require "csv"
class Athena_Commands < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    #puts "#{File.expand_path(File.dirname(__FILE__))}"
    puts $config.school_year
    #grade_hash = {
    #        :grade_k => true, :grade_1st=>true,     :grade_2nd=>true,   :grade_3rd=>true, :grade_4th=>true, :grade_5th=>true,
    #        :grade_6th=>true, :grade_7th=>true,     :grade_8th=>true,
    #        :grade_9th=>true, :grade_10th=>true,    :grade_11th=>true,  :grade_12th=>true,
    #    }
    #x = {:name=>"mcap_read_to_student"                  }.merge(grade_hash)
    #x
    #$tables.attach("SAPPHIRE_STUDENTS").after_load_k12_withdrawal
    
    #$tables.attach("K12_STAFF").one_to_one_setup
    
    #MAKE SURE THAT ALL ACTIVE STUDENTS HAVE ALL ONE TO ONE RELATIONSHIP RECORDS
    #$tables.attach("student").re_initialize(:backup_only=>true)
    
    #test = $tables.attach("TEST_EVENTS").new_row
    #test.fields["name"      ].value = "test"
    #test.fields["test_id"   ].value = "1"
    #test.fields["start_date"].value = "2013-02-20"
    #test.fields["end_date"  ].value = "2013-05-23"
    #test.save
    
    #$base.email
    
    #$tables.attach("STUDENT_COMMUNICATIONS").after_load_k12_omnibus
    #require 'github_api'
    #commit_path = 'https://api.github.com/repos/jeniferhalverson/k12/commits/73b5a6bb3f2e5406aaa2f83b230689879f9a329d'
    #github = Github.new :user => 'jeniferhalverson', :repo => 'k12'
    #github.repos.commits.all 'jeniferhalverson', 'k12'
    #test = Net::HTTP.new.get(commit_path)
    #http = Net::HTTP.new('https://api.github.com/repos/jeniferhalverson/k12/commits/73b5a6bb3f2e5406aaa2f83b230689879f9a329d', 443)
    #http.use_ssl = true
    #
    #http.start do |http|
    #  
    #  request = Net::HTTP::Get.new(source_address)
    #  request.basic_auth 'jhalverson', 'dxo84tbw'
    #  response = http.request(request)
    #  
    #end
    #before_load_team_evaluation_summary_snapshot(nil, "state_test_participation")
    
  end
  #---------------------------------------------------------------------------
  
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


end

Athena_Commands.new(ARGV)