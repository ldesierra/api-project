class RestaurantUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  belongs_to :restaurant

  validates :email, :phone_number, presence: true, uniqueness: true
  validates_presence_of :name, :role

  enum role: { manager: 0, employee: 1 }
end
