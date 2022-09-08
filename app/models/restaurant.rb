class Restaurant < ApplicationRecord
  has_many :restaurant_users
  has_many :open_hours

  acts_as_paranoid

  accepts_nested_attributes_for :restaurant_users, :open_hours

  # validates_presence_of :name, :restaurant_users
  validates_presence_of :name

  enum status: [:pending, :inactive, :active]
end
