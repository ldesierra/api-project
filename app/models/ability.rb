# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    non_logged_user_abilities(user)

    return if user.blank?

    if user.is_a?(AdminUser)
      admin_abilities
    elsif user.is_a?(Customer)
      customer_abilities(user)
    elsif user.employee?
      employee_abilities
    else
      manager_abilities(user)
    end
  end

  def non_logged_user_abilities(_user)
    can :read, Category
    can :create, Restaurant
    can :read, Pack
    can :read, Restaurant, status: :active
    can :manage, Cart
  end

  def manager_abilities(user)
    can :create, Pack
    can [:read, :delivered, :by_code], Purchase, restaurant_id: user.restaurant_id
    can [:read], RestaurantUser, restaurant_id: user.restaurant_id
    can [:destroy, :update], Pack do |pack|
      pack.restaurant.restaurant_users.include?(user)
    end
    can :update, Restaurant do |restaurant|
      restaurant.restaurant_users.include?(user)
    end
  end

  def employee_abilities
    can :create, Pack
    can [:read], RestaurantUser, restaurant_id: user.restaurant_id
    can [:read, :delivered, :by_code], Purchase, restaurant_id: user.restaurant_id
    can [:destroy, :update], Pack do |pack|
      pack.restaurant.restaurant_users.include?(user)
    end
  end

  def customer_abilities(user)
    can [:read, :create, :success, :payment_link], Purchase, customer_id: user.id
  end

  def admin_abilities
    can :manage, :all
  end
end
