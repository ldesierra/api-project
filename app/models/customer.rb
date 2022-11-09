class Customer < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :purchases
  has_one :cart

  devise :database_authenticatable, :registerable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  validates_presence_of :password, :first_name, :last_name, :phone
  validates :email, :username, presence: true, uniqueness: true

  validates_length_of :password, minimum: 8
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_format_of :phone, with: /\A\+598\d{8}\z/

  mount_base64_uploader :avatar, ImageUploader

  before_restore :restore_if_unique_email, :restore_if_unique_username

  def jwt_payload
    super.merge(user_kind: 'Customer', id: id, username: username)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def restore_if_unique_email
    return if Customer.without_deleted.where(email: email).size.zero?

    errors.add(:customer, 'No se puede restaurar usuarios con email duplicado')
    throw :abort
  end

  def restore_if_unique_username
    return if Customer.without_deleted.where(username: username).size.zero?

    errors.add(:customer, 'No se puede restaurar usuarios con username duplicado')
    throw :abort
  end
end
