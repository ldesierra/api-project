class RestaurantUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  belongs_to :restaurant

  validates_presence_of :email, :password, :name, :phone_number, :role
  validates_uniqueness_of :email

  enum role: { Manager: 0, Employee: 1 }
end
