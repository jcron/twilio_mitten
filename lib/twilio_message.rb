require 'twilio-ruby'
require_relative 'domain_helper'

class TwilioMessage

  def initialize params, settings
    @params = params
    @settings = settings
    @client = Twilio::REST::Client.new @settings.account_sid, @settings.auth_token
  end

  def forward_sms
    to_number = @params[:To]
    from_number = @params[:From]
    if authenticate(from_number)
      client_code = lookup_client to_number
      send_twilio_sms client_code, from_number unless client_code.nil?
    end
    Twilio::TwiML::Response.new do |response|
    end.text
  end

  def voice_reject_message
    Twilio::TwiML::Response.new do |response|
      response.Reject :reason => "busy"
    end.text
  end

  private

  def authenticate from_number
    @client.account.incoming_phone_numbers.list.each do |number|
      if number.phone_number == from_number
        return true
      end
    end
  end

  def send_twilio_sms client_code, from_number
    sms_body = "#{client_code}: #{@params[:Body]}"
    @settings.to_numbers.each do |to_number|
      log "#{to_number}: #{from_number} #{sms_body}"
      @client.account.messages.create(:body => sms_body, :to => to_number, :from => from_number)
    end
  end

  def lookup_client from_number
    @settings.client_mapping.each do |client|
      if client["client_number"] == from_number
        return client["client_code"]
      end
    end
    nil
  end
end