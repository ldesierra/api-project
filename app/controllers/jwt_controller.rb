class JwtController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def check_token
    begin
      token_payload = JWT.decode user_params[:jwt], Rails.application.credentials.jwt_secret
    rescue StandardError
      return render json: { message: 'Token inválido' }, status: 401
    end

    user_model = if token_payload[0]['user_kind'] == 'Customer'
                   Customer
                 else
                   RestaurantUser
                 end

    user = user_model.find(user_params[:id])

    if user.present? && token_payload[0]['jti'] == user.jti
      render json: { message: 'Token válido' }, status: 200
    else
      render json: { message: 'Token inválido' }, status: 401
    end
  end

  private

  def user_params
    params.permit(:id, :jwt)
  end
end
