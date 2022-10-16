module Restaurants
  class PurchasesController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    include Pagy::Backend
    after_action { pagy_headers_merge(@pagy) if @pagy }

    load_and_authorize_resource

    def index
      page = params[:page] || Pagy::DEFAULT[:page]
      items = params[:items] || Pagy::DEFAULT[:items]

      begin
        @pagy, @purchases = pagy(@purchases, page: page, items: items)
      rescue Pagy::OverflowError
        @purchases = @pagy
      end
    end

    def show; end
  end
end
