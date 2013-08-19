#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("web_scraping","base/base")

class Scantron_receive_extended < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize(args)
    super()
    
    #require "#{$paths.base_path}scantron_performance_interface"
    #i = Scantron_Performance_Interface.new
    #success = i.email_checking
    
    
    require "#{$paths.base_path}scantron_performance_interface"
    i = Scantron_Performance_Interface.new
    i.importing_ordered_file_scantron_performance_extended
    
    
    
    
  end
  #---------------------------------------------------------------------------
  
  

end

Scantron_receive_extended.new(ARGV)