class RestaurantMailer < ApplicationMailer
  default from: 'from@example.com'

  def reject_restaurant
    email = params[:manager_email]
    @restaurant = params[:restaurant]
    @reject_reason = params[:reject_reason]

    subject = 'Restaurante rechazado'
    mail(to: email, subject: subject)
  end
end
