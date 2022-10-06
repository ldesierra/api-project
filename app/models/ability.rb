# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Restaurant
    can :read, Pack
    can :read, Restaurant, status: :active

    return if user.blank?

    if user.is_a?(AdminUser)
      admin_abilities
    elsif user.is_a?(Customer)
      customer_abilities
    elsif user.employee?
      employee_abilities
    else
      manager_abilities(user)
    end
  end

  def manager_abilities(user)
    can :create, Pack
    can [:destroy, :update], Pack do |pack|
      pack.restaurant.restaurant_users.include?(user)
    end
    can :update, Restaurant do |restaurant|
      restaurant.restaurant_users.include?(user)
    end
  end

  def employee_abilities
    can :create, Pack
    can [:destroy, :update], Pack do |pack|
      pack.restaurant.restaurant_users.include?(user)
    end
  end

  def customer_abilities; end

  def admin_abilities
    can :manage, :all
  end
end
