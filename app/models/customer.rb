class Customer < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  validates_presence_of :password, :first_name, :last_name, :phone
  validates :email, :username, presence: true, uniqueness: true
end
