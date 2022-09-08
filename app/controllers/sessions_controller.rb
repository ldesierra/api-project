class SessionsController < Devise::SessionsController
  respond_to :json

  after_action :skip_session

  def skip_session
    request.session_options[:skip] = true
  end

  private

  def respond_with(_resource, _opts = {})
    render json: { message: 'Logged in successfuly' }, status: :ok if current_customer.present?
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfuly' }, status: :ok
  end
end
