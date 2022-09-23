class Restaurant < ApplicationRecord
  has_many :restaurant_users, dependent: :destroy
  has_many :open_hours, dependent: :destroy
  has_many :packs, dependent: :destroy

  acts_as_paranoid

  accepts_nested_attributes_for :restaurant_users, :open_hours, :packs, allow_destroy: true

  validates_presence_of :name, :phone_number, :status
  validates_format_of :phone_number, with: /\A\+598\d{8}\z/

  validate :just_one_manager, if: -> { pending? || incomplete? }
  validate :manager_present_on_create, on: :create
  validate :manager_present_on_update, on: :update

  enum status: [:pending, :incomplete, :inactive, :active]

  mount_base64_uploader :logo, ImageUploader

  def complete?
    inactive? || active?
  end

  private

  def manager_present_on_update
    managers = restaurant_users.select(&:manager?)

    return true unless managers.all?(&:marked_for_destruction?)

    errors.add(:restaurant, 'Debe existir algun usuario manager')
  end

  def manager_present_on_create
    return true if restaurant_users.any?(&:manager?)

    errors.add(:restaurant, 'Debe existir algun usuario manager')
  end

  def just_one_manager
    return true if restaurant_users.size == 1

    errors.add(:restaurant, 'Solo puede haber un usuario en un restaurante no activo')
  end
end
