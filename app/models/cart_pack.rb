class CartPack < ApplicationRecord
  belongs_to :pack
  belongs_to :cart

  validates_presence_of :quantity

  after_create :calculate_cart_total
  after_destroy :cart_total_after_destroy
  after_save :calculate_cart_total

  delegate :stock, to: :pack

  private

  def cart_total_after_destroy
    cart.cart_pack_removed(self)
  end

  def calculate_cart_total
    cart.cart_pack_quantity_changed if saved_change_to_quantity?
  end
end
