require 'mercadopago'

class PaymentInformation < SolidService::Base
  def call
    external_payment_id = params[:external_payment_id]

    response = mercado_pago.payment.get(external_payment_id)

    success!(response: response[:response])
  end

  private

  def mercado_pago
    Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'].to_s)
  end
end
