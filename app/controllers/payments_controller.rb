class PaymentsController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def success
    @purchase = Purchase.find(params[:external_reference])

    return render json: { error: 'Compra inexistente' } if @purchase.blank?

    if params[:status] == 'approved'
      @purchase.completed!
      PaymentMailer.with(mailer_params).confirm_payment.deliver_now

      render json: { message: 'Compra realizada', purchase_id: @purchase.id }, status: 200
    else
      render json: { error: 'Problema con la compra' }, status: 500
    end
  end

  def failure
    render json: { message: 'Error al realizar la compra' }, status: 500
  end

  private

  def mailer_params
    {
      purchase: @purchase,
      customer: @purchase.customer
    }
  end
end
