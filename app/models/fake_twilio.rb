class FakeTwilio
  Message = Struct.new(:to, :body)
  Verification = Struct.new(:status)

  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token); end

  def verify(_number = nil)
    self
  end

  alias v2 verify
  alias services verify
  alias verifications verify
  alias verification_checks verify

  def create(to:, channel: nil, code: nil)
    verifying = code.present?
    if verifying && code == messages.last.body
      Verification.new('approved')
    elsif verifying
      Verification.new('denied')
    else
      messages << Message.new(to, rand(1000..9999).to_s)
    end
  end
end
