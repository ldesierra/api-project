class Pack < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :categories

  validates_presence_of :name, :stock, :price
end
