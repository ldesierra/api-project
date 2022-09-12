class DeviseMailer < Devise::Mailer
  default from: 'default@gmail.com'

  def reset_password_instructions(record, token, opts = {})
    @user_kind = record.class_name
    super
  end
end
