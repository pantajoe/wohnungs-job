class AvailabilityLog < ApplicationRecord
  scope :sentry, -> { where(status: 'successful', log_type: 'sentry') }
  scope :graylog, -> { where(status: 'successful', log_type: 'graylog') }
  scope :appsignal, -> { where(status: 'successful', log_type: 'appsignal') }
end
