SentryApi.configure do |config|
  config.endpoint = ENV.fetch('SENTRY_API_ENDPOINT')
  config.auth_token = ENV.fetch('SENTRY_API_AUTH_TOKEN')
  config.default_org_slug = ENV.fetch('SENTRY_API_DEFAULT_ORG_SLUG')
end
