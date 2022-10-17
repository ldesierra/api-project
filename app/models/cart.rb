class Cart < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :restaurant, optional: true

  has_many :cart_packs
  has_many :packs, through: :cart_packs

  def pack?(pack)
    cart_packs.any? { |cart_pack| cart_pack.pack = pack }
  end

  def clean_cart_packs
    cart_packs.each(&:destroy!)
  end

  def cart_pack_changed
    calculate_total
  end

  private

  def calculate_total
    self.total = cart_packs.reduce(0) do |total, cart_pack|
      total + cart_pack.quantity * cart_pack.pack.price
    end

    save!
  end
end