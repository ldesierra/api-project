class RestaurantMailer < ApplicationMailer
  default from: 'from@example.com'

  def accept_restaurant
    @restaurant = params[:restaurant]
    email = params[:owner_email]
    subject = 'Restaurante aceptado'

    mail(to: email, subject: subject)
  end

  def reject_restaurant
    email = params[:owner_email]
    @restaurant = params[:restaurant]
    @reject_reason = params[:reject_reason]

    subject = 'Restaurante rechazado'
    mail(to: email, subject: subject)
  end
end
