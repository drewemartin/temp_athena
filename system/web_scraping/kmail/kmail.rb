#!/usr/local/bin/ruby
require File.dirname(__FILE__).gsub("web_scraping/kmail","base/base")

class KMAIL_EXECUTE < Base
  
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  #|I|n|i|t|i|a|l|i|z|a|t|i|o|n|
  #+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  
  #---------------------------------------------------------------------------
  def initialize()
    super()
    
    require "#{File.dirname(__FILE__)}/TV_Kmail_Agent"
    agent = TV_Kmail_Agent.new('agent_one')
    
  end
  
end

KMAIL_EXECUTE.new