class RestaurantUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  belongs_to :restaurant

  validates :email, :phone_number, presence: true, uniqueness: true

  validates_presence_of :name, :role

  validates_length_of :password, minimum: 8

  enum role: { manager: 0, employee: 1 }

  def no_errors?
    errors.empty?
  end

  def full_messages_for_errors
    errors.full_messages
  end
end
