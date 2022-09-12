class Customer < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  validates_presence_of :email, :password, :first_name, :last_name, :phone
  validates_uniqueness_of :email, :username
end
