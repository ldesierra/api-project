class Pack < ApplicationRecord
  belongs_to :restaurant
  has_many :pack_categories
  has_many :categories, through: :pack_categories
  accepts_nested_attributes_for :pack_categories, allow_destroy: true

  validates_presence_of :name, :stock, :price
end
