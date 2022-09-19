class Category < ApplicationRecord
  has_many :pack_categories
  has_many :packs, through: :pack_categories
  accepts_nested_attributes_for :pack_categories, allow_destroy: true

  validates :name, presence: true, uniqueness: true
end
