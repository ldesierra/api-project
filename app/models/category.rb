class Category < ApplicationRecord
  has_and_belongs_to_many :packs

  validates :name, presence: true, uniqueness: true
end
