# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Restaurant

    return if user.blank?

    if user.is_a?(AdminUser)
      admin_abilities
    elsif user.is_a?(Customer)
      customer_abilities
    elsif user.employee?
      employee_abilities
    else
      manager_abilities
    end
  end

  def manager_abilities; end

  def employee_abilities; end

  def customer_abilities; end

  def admin_abilities
    can :manage, :all
  end
end
