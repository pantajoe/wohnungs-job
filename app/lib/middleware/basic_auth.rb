module Middleware
  class BasicAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      if credentials.present? && !api_request?(env)
        auth = Rack::Auth::Basic.new(@app) do |username, password|
          credentials == [username, password]
        end
        auth.call(env)
      else
        @app.call(env)
      end
    end

    private

    def credentials
      ENV.values_at('HTTP_BASIC_AUTH_USER', 'HTTP_BASIC_AUTH_PASS').compact
    end

    def api_request?(env)
      request_path(env).start_with?('/api/v1/github_security_webhooks', '/.well-known/health_check')
    end

    def request_path(env)
      env.fetch('PATH_INFO')
    end
  end
end
