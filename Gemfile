# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

gem 'activeadmin'
gem 'cancancan'
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'devise-jwt'
gem 'paranoia', '~> 2.2'
gem 'rack-cors'
gem 'solidservice'

gem 'sprockets-rails', require: 'sprockets/railtie'

gem 'sass-rails'

gem 'jbuilder'

gem 'carrierwave'
gem 'carrierwave-base64'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'twilio-ruby', '~> 5.70.0'

gem 'figaro'

gem 'rails-i18n', '~> 7.0.0'

gem 'pagy', '~> 5.10'

# Use Sass to process CSS
# gem "sassc-rails"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'pry'

  gem 'pry-nav'

  gem 'dotenv-rails'

  # Testing framework
  gem 'rspec-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'

  # Git hooks for pre-commit and pre-push
  gem 'lefthook'

  # Ruby static code analyzers
  gem 'brakeman'
  gem 'rails_best_practices'
  gem 'reek'

  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  # Adds support for Capybara system testing and Selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :production do
  gem 'fog-aws'
end
