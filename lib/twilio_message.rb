require 'twilio-ruby'
require_relative 'domain_helper'

class TwilioMessage

  def initialize params, settings
    @params = params
    @settings = settings
    @client = Twilio::REST::Client.new @settings.account_sid, @settings.auth_token
  end

  def forward_sms
    send_twilio_sms
  end

  def voice_reject_message
    twilio_response = Twilio::TwiML::Response.new do |response|
      response.Reject :reason => "busy"
    end.text
    twilio_response
  end

  private

  def send_twilio_sms
    sms_body = "#{@params[:Body]}"
    @settings.to_numbers.each do |to_number|
      @client.account.messages.create(:body => sms_body, :to => to_number, :from => @settings.sms_from_number)
    end
  end

  def get_sms_messages message
    messages = []
    while message.length > 0
      if message.length > 160
        messages << message[0..159]
        message = message[160..message.length]
      else
        messages << message
        break
      end
    end
    messages
  end
end