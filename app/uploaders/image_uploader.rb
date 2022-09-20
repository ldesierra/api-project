class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [200, 200]
  end

  version :medium do
    process resize_to_fit: [900, 900]
  end

  version :large do
    process resize_to_fit: [1200, 1200]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
