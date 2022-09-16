class CustomFailure < Devise::FailureApp
  def respond
    return redirect_to new_admin_user_session_path if params[:controller].start_with?('admin')

    self.status = 401
    self.content_type = 'json'
    self.response_body = '{"error" : "authentication error"}'
  end
end
