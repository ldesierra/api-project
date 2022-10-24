class Pack < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :categories
  has_many :pictures, as: :imageable, dependent: :destroy

  acts_as_paranoid

  validates :price, comparison: { greater_than: 0 }
  validates :stock, comparison: { greater_than_or_equal_to: 0 }

  validates_presence_of :name, :stock, :price, :full_description, :short_description
  accepts_nested_attributes_for :categories, :pictures, allow_destroy: true

  def select_string_for_purchase
    "Pack ( Name: #{name}, Stock: #{stock} ) | Restaurant ( Name: #{restaurant.name} )"
  end
end
