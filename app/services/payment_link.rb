require 'mercadopago'

class PaymentLink < SolidService::Base
  def call
    purchase = params[:purchase]

    preference_data = {
      external_reference: purchase.id,
      items: items_hash(purchase)
    }

    preference_data.merge!(default_preference_data)
    preference_response = mercado_pago.preference.create(preference_data)
    preference = preference_response[:response]

    if preference['sandbox_init_point'].present? && preference_response[:status] == 201
      success!(payment_link: preference['sandbox_init_point'])
    else
      fail!(error: preference['back_urls']['failure'])
    end
  end

  private

  # move to purchase_pack
  def items_hash(purchase)
    purchase.purchase_packs.map do |purchase_pack|
      {
        id: purchase.id,
        title: purchase_pack.pack_name,
        currency_id: 'UY',
        quantity: purchase_pack.quantity,
        unit_price: purchase_pack.pack.price.to_i
      }
    end
  end

  def default_preference_data
    {
      payment_methods: {
        excluded_payment_types: [
          {
            id: 'ticket'
          }
        ],
        installments: 1
      },
      back_urls: {
        success: ENV['MERCADOPAGO_SUCCESS_URL'],
        failure: ENV['MERCADOPAGO_FAILURE_URL']
      },
      auto_return: 'approved',
      binary_mode: true
    }
  end

  def mercado_pago
    Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'].to_s)
  end
end
