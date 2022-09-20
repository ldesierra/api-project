class RestaurantUser < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  belongs_to :restaurant

  validates :email, :phone_number, presence: true, uniqueness: true
  validates_presence_of :name, :role
  validates_presence_of :password, if: :confirmed?
  validates_length_of :password, minimum: 8, if: :confirmed?
  validates_confirmation_of :password
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_format_of :phone_number, with: /\A\+598\d{8}\z/

  enum role: { manager: 0, employee: 1 }

  before_create :skip_confirmation_notification!

  def no_errors?
    errors.empty?
  end

  def full_messages_for_errors
    errors.full_messages
  end

  def jwt_payload
    super.merge(user_kind: role.capitalize)
  end
end
