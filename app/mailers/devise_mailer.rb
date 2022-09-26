class DeviseMailer < Devise::Mailer
  default from: 'default@gmail.com'

  def reset_password_instructions(record, token, opts = {})
    @user_kind = record.class.name
    super
  end

  def invitation_instructions(record, token, opts = {})
    @query = user_attributes(record) + restaurant_attributes(record)
    super
  end

  private

  def user_attributes(record)
    record.attributes
          .slice('name', 'email', 'phone_number')
          .map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def restaurant_attributes(record)
    return unless record.restaurant.incomplete?

    first_manager = 'first_time=true'

    restaurant_attributes = record.restaurant
                                  .attributes
                                  .slice('name', 'phone_number', 'address')
                                  .map { |key, value| "restaurant_#{key}=#{value}" }.join('&')

    "&#{first_manager}&#{restaurant_attributes}"
  end
end
