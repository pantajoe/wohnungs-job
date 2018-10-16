class SentryError < ApplicationRecord
  belongs_to :project, inverse_of: :sentry_errors
  has_many :sentry_error_logs, inverse_of: :sentry_error, dependent: :destroy
end
