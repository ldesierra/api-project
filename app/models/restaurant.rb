class Restaurant < ApplicationRecord
  has_many :restaurant_users
  acts_as_paranoid

  accepts_nested_attributes_for :restaurant_users

  validates_presence_of :name

  scope :pending, -> { where(active: false) }
end
