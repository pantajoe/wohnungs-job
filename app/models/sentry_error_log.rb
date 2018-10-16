class SentryErrorLog < ApplicationRecord
  belongs_to :sentry_error, inverse_of: :sentry_error_logs
end
