class PurchasePack < ApplicationRecord
  belongs_to :pack
  belongs_to :purchase

  validates_presence_of :quantity
  validates :quantity, comparison: { greater_than: 0 }
end
