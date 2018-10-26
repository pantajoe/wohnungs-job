# In the beginning, require function Dotenv#require_keys
require_relative './initializers/dotenv_require_keys'
# First, require all environment variables
require_relative './initializers/dotenv'
# Then, require the switch method
require_relative './initializers/switch'
# Then, require #present? and #blank? methods.
require_relative './initializers/present'

# Then, require all gems
require 'mail'
require 'rake'
require 'pry-byebug'
require 'httparty'
require 'nokogiri'
require 'colorize'
require 'base64'

# Then, require the mail defaults
require_relative './initializers/mail_defaults'

# Then, require all helpers
require_relative './modules/os'
require_relative './modules/icon_helper'
require_relative './modules/email_helper'

# Then, require the notification libraries
OS.switch(
  mac?:     -> {
    require 'terminal-notifier'
    require 'terminal-notifier-guard'
    require_relative './initializers/terminal_notifier_guard'
  },
  linux?:   -> {
    require 'libnotify'
  },
  windows?: -> {
    require_relative './modules/burnt_toast_notification'
  }
)

# Then, require the job
require_relative './jobs/wohnungs_job'
