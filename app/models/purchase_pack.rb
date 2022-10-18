class PurchasePack < ApplicationRecord
  belongs_to :pack
  belongs_to :purchase

  validates_presence_of :quantity

  after_save :calculate_purchase_total

  private

  def calculate_purchase_total
    purchase.purchase_pack_changed
  end
end
