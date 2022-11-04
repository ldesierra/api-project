module Restaurants
  class StatisticsController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    def show
      authorize! :view, :statistics

      return render json: { message: 'No autorizado' }, status: 401 if not_manager_from_restaurant

      kind = params[:kind]

      if kind == 'qualification'
        @results = qualification_statistics
      else

        begin
          start_date = params[:start_date].to_date
          end_date = params[:end_date].to_date
        rescue StandardError
          return render json: { message: 'Wrong date format' }, status: 422
        end

        if start_date > end_date
          return render json: { message: 'Dates in wrong order' }, status: 422
        end

        unless kind.in?(%w[packs earnings])
          return render json: { message: 'Not found statistic kind' }, status: 404
        end

        @results = statistics(start_date, end_date, kind)
      end

      render json: @results, status: 200
    end

    private

    def not_manager_from_restaurant
      restaurant = Restaurant.find(params[:restaurant_id])

      restaurant.blank? || current_restaurant_user.restaurant_id != restaurant.id
    end

    def qualification_statistics
      restaurant_id = params[:restaurant_id]

      return if Restaurant.find(restaurant_id).blank?

      results = { '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 }

      purchases = Purchase.where(restaurant_id: restaurant_id, status: 2)

      purchases.each do |purchase|
        next if purchase.qualification.zero?

        results[:"#{purchase.qualification}"] = results[:"#{purchase.qualification}"].to_i + 1
      end

      results
    end

    def statistics(start_date, end_date, kind)
      restaurant_id = params[:restaurant_id]

      return if Restaurant.find(restaurant_id).blank?

      purchases = Purchase.where(restaurant_id: restaurant_id, status: [1, 2])
                          .where('purchases.created_at BETWEEN ? AND ?', start_date, end_date)

      separate_by_days(kind, purchases, start_date, end_date)
    end

    def separate_by_days(kind, collection, start_date, end_date)
      results = {}
      date_range = start_date..end_date

      date_range.each do |date|
        purchases_by_date = collection.where(
          'purchases.created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day
        )

        amounts = if kind == 'earnings'
                    purchases_by_date.pluck(:total) - [nil]
                  else
                    purchases_by_date.joins(:purchase_packs)
                                     .pluck('purchase_packs.quantity') - [nil]
                  end

        results[date.to_s] = amounts.blank? ? 0 : amounts.sum
      end

      results
    end
  end
end
