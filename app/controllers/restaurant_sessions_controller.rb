class RestaurantSessionsController < Devise::SessionsController
  respond_to :json

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :skip_session

  def skip_session
    request.session_options[:skip] = true
  end

  def two_factor
    token = decrypt_param_token(params[:access_token])

    if token.present?
      user = user_by_token(token)
      user_otp_access_token = (JSON.parse token)['access_token']

      error = 'Invalid request' unless user_otp_access_token == user.otp_access_token
    else
      error = 'Invalid request'
    end

    if error.present?
      render json: { message: error }, status: 401
    else
      verification_success = Twilio::Authenticate.authenticate(user.phone_number,
                                                               params[:two_factor_code].presence ||
                                                               'empty_code')

      if verification_success
        warden.set_user(user, scope: :restaurant_user)
        respond_with resource
      else
        render json: { message: 'Invalid code, try again' }, status: 401
      end
    end
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    return render json: { message: 'Wrong email or password' } unless resource.present?

    if ENV['DISABLE_2FA'].blank?
      encrypted_token = start_2fa_authentication(params[:restaurant_user][:email])

      render json: { access_token: encrypted_token }, status: 200
    else
      respond_with resource
    end
  end

  private

  def start_2fa_authentication(user_email)
    restaurant_user = RestaurantUser.find_by(email: user_email)
    restaurant_user.update_column(:otp_access_token, SecureRandom.hex)

    Twilio::GenerateCode.call(restaurant_user.phone_number)

    crypt = ActiveSupport::MessageEncryptor.new(
      Rails.application.credentials[:secret_key_base][0..31]
    )
    crypt.encrypt_and_sign("{\"id\":\"#{restaurant_user.id}\",
                           \"access_token\":\"#{restaurant_user.otp_access_token}\"}")
  end

  def respond_with(_resource, _opts = {})
    return unless current_restaurant_user.present?

    render json: { message: 'Logged in successfully' }, status: 200
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfully' }, status: 200
  end

  def decrypt_param_token(_token)
    crypt = ActiveSupport::MessageEncryptor.new(
      Rails.application.credentials[:secret_key_base][0..31]
    )

    return unless params[:access_token].present?

    begin
      crypt.decrypt_and_verify(params[:access_token])
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      nil
    end
  end

  def user_by_token(token)
    RestaurantUser.find((JSON.parse token)['id'])
  end
end
