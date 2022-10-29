require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NoLoTiresBack
  class Application < Rails::Application
    config.load_defaults 7.0

    config.before_configuration do
      I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
      I18n.default_locale = :es
      I18n.reload!
    end

    config.middleware.use ActionDispatch::Flash
    config.session_store :cookie_store, key: 'nolotiresSession', httponly: false, same_site: :none, secure: true
    config.action_dispatch.cookies_same_site_protection = :none
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
  end
end
