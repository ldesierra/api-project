class Purchase < ApplicationRecord
  belongs_to :customer
  belongs_to :restaurant
  has_many :purchase_packs, dependent: :destroy
  has_many :packs, through: :purchase_packs

  validates_presence_of :status
  validates_format_of :code, with: /\A\w{6}\z/, allow_blank: true
  validate :packs_from_restaurant, on: :create, if: -> { packs.present? }
  validate :packs_from_restaurant, on: :update, if: -> { packs.present? }
  validate :packs_uniqueness, on: :create
  validate :packs_uniqueness, on: :update
  validate :unchanged_customer_and_restaurant, on: :update
  validate :available_quantities, on: :create

  before_create :add_code

  enum status: { waiting_for_payment: 0, completed: 1, delivered: 2 }
  accepts_nested_attributes_for :purchase_packs, allow_destroy: true

  def purchase_pack_quantity_changed(purchase_pack_id)
    purchase_packs.each(&:reload)

    purchase_packs.each do |purchase_pack|
      if purchase_pack_id == purchase_pack.id
        purchase_pack.pack.stock -= purchase_pack.quantity
        purchase_pack.pack.save
      end
    end

    self.total = if purchase_packs.empty?
                   0
                 else
                   purchase_packs.reduce(0) do |total, purchase_pack|
                     total + purchase_pack.quantity * purchase_pack.pack.price
                   end
                 end

    save
  end

  private

  def packs_from_restaurant
    rts = purchase_packs.map(&:pack).map(&:restaurant)

    return true unless rts.exclude?(restaurant) || rts.detect { |rt| rts.count(rt) < rts.length }

    errors.add(:purchase, 'Los packs añadidos deben corresponder al resturante seleccionado')
  end

  def packs_uniqueness
    packs = purchase_packs.map(&:pack)
    return true unless packs.detect { |pack| packs.count(pack) > 1 }

    errors.add(:purchase, 'Los packs añadidos no deben repetirse')
  end

  def unchanged_customer_and_restaurant
    if customer_changed?
      errors.add(:purchase, 'No puedes cambiar el customer luego de creada la compra')
    elsif restaurant_changed?
      errors.add(:purchase, 'No puedes cambiar el restaurant luego de creada la compra')
    end
  end

  def available_quantities
    return true unless purchase_packs.detect { |pp| pp.quantity > pp.pack.stock }

    errors.add(:purchase, 'La cantidad de los packs no debe superar el stock disponible')
  end

  def add_code
    code = Random.hex.first(6)

    code = Random.hex.first(6) while Purchase.find_by(code: code).present?

    self.code = code.upcase
  end
end
