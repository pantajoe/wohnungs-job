# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read('.ruby-version').strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.0'

gem 'bcrypt'
gem 'bcrypt-ruby'
gem 'bootsnap'
gem 'bulma-rails'
gem 'clockwork'
gem 'font-awesome-rails'
gem 'friendly_id'
gem 'gon'
gem 'hamlit-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg', '~> 1.0'
gem 'premailer-rails'
gem 'puma'
gem 'rails-i18n'
gem 'responders'
gem 'sassc-rails'
gem 'time_difference'
gem 'turbolinks'
gem 'twitter-bootstrap-rails'
gem 'uglifier'
gem 'validates_email_format_of'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '0.12.3.1'

# Javascript
source 'https://rails-assets.org' do
  gem 'rails-assets-moment'
  gem 'rails-assets-underscore'
end

gem 'coffee-rails'

# Deployment
gem 'dotenv-rails'
gem 'therubyracer', platforms: :ruby

# Documentation
group :development do
  gem 'license_finder', require: false
  gem 'rails-erd', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'sdoc', group: :doc
end

# External APIs
gem 'appsignal', path: 'vendor/appsignal-ruby'
gem 'bundler-audit'
gem 'graylog', path: 'vendor/graylog-ruby'
gem 'sentry-api'

# Authentication / Authorization
gem 'omniauth-google-oauth2'
gem 'pundit'

gem 'terminal-notifier'
gem 'terminal-notifier-guard'
gem 'nokogiri'
gem 'httparty'
gem 'rake'

# Testing
group :development, :test do
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-rails'
end

group :development do
  gem 'guard-livereload', require: false
  gem 'guard-rspec', require: false
  gem 'rack-livereload'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-screenshot'
  gem 'clockwork-test'
  gem 'database_cleaner'
  gem 'faker'
  gem 'pdf-reader', '~> 2.0'
  gem 'poltergeist'
  gem 'rails-controller-testing'
end

# Debugging
group :development, :test do
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
end

group :development do
  gem 'awesome_print'
  gem 'coffee-rails-source-maps'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console'
end

# Monitoring
gem 'newrelic_rpm'
gem 'sentry-raven'

# Misc
group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
