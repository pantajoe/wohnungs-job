# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read('.ruby-version').strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'httparty'
gem 'nokogiri'
gem 'rake'
gem 'colorize'
gem 'dotenv', github: 'bkeepers/dotenv'
gem 'mail'

group :linux do
  gem 'libnotify'
end

group :mac do
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'
end

# Debugging
group :development, :test do
  gem 'pry-byebug'
  gem 'pry-doc'
end
