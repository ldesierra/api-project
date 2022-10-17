class Purchase < ApplicationRecord
  has_many :purchase_packs
  has_many :packs, through: :purchase_packs

  validates_presence_of :code, :status

  validates_format_of :code, with: /\A\w{6}\z/

  enum status: { waiting_for_payment: 0, completed: 1, delivered: 2 }

  belongs_to :customer

  def purchase_pack_changed
    calculate_total
  end

  private

  def calculate_total
    self.total = purchase_packs.reduce(0) do |total, purchase_pack|
      total + purchase_pack.quantity * purchase_pack.pack.price
    end

    save!
  end
end
