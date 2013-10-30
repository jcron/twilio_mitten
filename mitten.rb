require 'rubygems'
require 'sinatra/base'
require 'sinatra/config_file'
require_relative 'lib/domain_helper'
require_relative 'lib/twilio_message'

class Mitten < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config.yml'

  def initialize
    begin
      super
      log "Three little kittens they lost their mittens"
    rescue Exception => err
      log_exception err
    end
  end
  
  before do
    log_request "Before", request, status
  end

  get '/test' do
    message = "The three little kittens they found their mittens"
    log message
    body message
  end

  get '/mitten/accept' do
    begin
      twilio_message = TwilioMessage.new params, settings
      twilio_message.forward_sms
    rescue Exception => err
      log_exception err
    end
  end

  get '/mitten/reject' do
    begin
      twilio_message = TwilioMessage.new params, settings
      twilio_message.voice_reject_message
    rescue Exception => err
      log_exception err
    end
  end
  
  after do
    log_request "After", request, status
  end
end