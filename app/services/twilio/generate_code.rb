module Twilio
  class GenerateCode
    VERIFICATION_METHOD = 'sms'.freeze

    def self.call(phone_number)
      Twilio::Client.call.verify
                    .v2
                    .services(ENV.fetch('TWILIO_VERIFY_SERVICE_NUMBER', nil))
                    .verifications
                    .create(to: phone_number, channel: 'whatsapp')
    end
  end
end
