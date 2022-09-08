module Twilio
  class Authenticate
    APPROVED_STATUS = 'approved'.freeze

    def self.authenticate(phone_number, code)
      verification = Twilio::Client.call.verify
                                   .v2
                                   .services(ENV.fetch('TWILIO_VERIFY_SERVICE_NUMBER', nil))
                                   .verification_checks
                                   .create(to: phone_number, code: code)

      verification.status == APPROVED_STATUS
    end
  end
end
