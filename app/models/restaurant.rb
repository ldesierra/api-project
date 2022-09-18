class Restaurant < ApplicationRecord
  has_many :restaurant_users, dependent: :destroy
  has_many :open_hours, dependent: :destroy

  acts_as_paranoid

  accepts_nested_attributes_for :restaurant_users, :open_hours

  validates_presence_of :name

  validate :manager_present

  enum status: [:pending, :incomplete, :inactive, :active]

  def complete?
    inactive? || active?
  end

  private

  def manager_present
    restaurant_users.each do |user|
      return true if user.manager?
    end

    errors.add(:restaurant, 'Debe existir algun usuario manager')
  end
end
