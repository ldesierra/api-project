class PaymentMailer < ApplicationMailer
  default from: 'from@example.com'

  def confirm_payment
    @customer = params[:customer]
    @purchase = params[:purchase]
    email = @customer.email

    subject = 'Pago confirmado'
    mail(to: email, subject: subject)
  end
end
