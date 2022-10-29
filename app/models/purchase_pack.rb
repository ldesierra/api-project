class PurchasePack < ApplicationRecord
  belongs_to :pack
  belongs_to :purchase

  validates_presence_of :quantity
  validates :quantity, comparison: { greater_than: 0 }

  after_create :calculate_purchase_total

  delegate :stock, to: :pack
  delegate :name, to: :pack, prefix: :pack

  private

  def calculate_purchase_total
    purchase.purchase_pack_quantity_changed(id) if saved_change_to_quantity?
  end
end
