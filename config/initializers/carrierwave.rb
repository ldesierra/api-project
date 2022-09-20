CarrierWave.configure do |config|
  if Rails.env.development? || ENV['DISABLE_S3_STORAGE'].present?
    config.storage = :file
    config.asset_host = 'http://localhost:3000'
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_KEY'],
      aws_secret_access_key: ENV['S3_SECRET'],
      region: ENV['S3_REGION']
    }
    config.storage = :fog
    config.fog_directory = ENV['S3_BUCKET']
  end
end
