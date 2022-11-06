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
          .to_query
  end

  def restaurant_attributes(record)
    return '' unless record.restaurant.incomplete?

    restaurant_attributes = record.restaurant
                                  .attributes
                                  .slice('name', 'phone_number', 'address')
                                  .deep_transform_keys { |key| "restaurant_#{key}" }
                                  .to_query

    "&first_time=true&#{restaurant_attributes}"
  end
end
