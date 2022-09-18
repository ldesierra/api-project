# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all

    return if user.blank?

    if user.is_a?(Customer)
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
end
