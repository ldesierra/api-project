class Customer < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_paranoid

  validates_presence_of :password, :first_name, :last_name, :phone
  validates :email, :username, presence: true, uniqueness: true

  validates_length_of :password, minimum: 8
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_format_of :phone, with: /\A\+598\d{8}\z/

  mount_base64_uploader :avatar, ImageUploader

  def jwt_payload
    super.merge(user_kind: 'Customer')
  end
end
