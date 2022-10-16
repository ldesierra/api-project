class CartPack < ApplicationRecord
  belongs_to :pack
  belongs_to :cart

  validates_presence_of :quantity

  before_save :calculate_cart_total

  private

  def calculate_cart_total
    cart.cart_pack_changed
  end
end
