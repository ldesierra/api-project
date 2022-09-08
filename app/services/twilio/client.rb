module Twilio
  class Client
    def self.call
      account_sid = ENV.fetch('TWILIO_ACCOUNT_SID', nil)
      auth_token = ENV.fetch('TWILIO_AUTH_TOKEN', nil)

      Twilio::REST::Client.new(account_sid, auth_token)
    end
  end
end
