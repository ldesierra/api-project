class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  mount_base64_uploader :image, ImageUploader
end
