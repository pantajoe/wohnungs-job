require "cgi"
require "json"
require "net/http"
require "net/https"
require "uri"
require "uri/http"
require "openssl"

require_relative "errors"

module Appsignal
  class Http
    USER_AGENT = 'AppsignalRuby'

    DEFAULT_HEADERS = {
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => USER_AGENT,
    }.freeze

    JSON_PARSE_OPTIONS = {
      max_nesting:      false,
      create_additions: false,
      symbolize_names:  true,
    }.freeze

    RESCUED_EXCEPTIONS = [].tap do |a|
      # Failure to even open the socket (usually permissions)
      a << SocketError

      # Failed to reach the server (aka bad URL)
      a << Errno::ECONNREFUSED

      # Failed to read body or no response body given
      a << EOFError

      # Timeout
      a << Net::ReadTimeout
      a << Net::OpenTimeout
    end.freeze

    attr_reader :app_id, :token
    def initialize(app_id:, token:)
      @app_id = app_id
      @token = token
      @adress = "https://appsignal.com"
    end

    def get(path, params: {})
      request(:get, path, params: params.merge(token: @token))
    end

    def post(path, payload: nil, params: {})
      request(:post, path, params: params.merge(token: @token), payload: payload)
    end

    def put(path, payload: nil, params: {})
      request(:put, path, params: params.merge(token: @token), payload: payload)
    end

    def delete(path, params: {})
      request(:delete, path, params: params.merge(token: @token))
    end

    private

    def request(verb, path, params: {}, payload: nil)
      uri = build_uri(path, params.merge(token: @token))
      request = build_request(verb, uri, payload: payload)
      connection = build_connection(uri)

      begin
        # Create a connection using the block form, which will ensure the socket
        # is properly closed in the event of an error.
        connection.start do |http|
          response = http.request(request)

          case response
          when Net::HTTPSuccess
            success(response)
          else
            error(request, response)
          end
        end
      rescue *RESCUED_EXCEPTIONS => e
        raise HTTPConnectionError.new(request, e)
      end
    end

    def build_uri(path, params = {})
      URI.parse(@adress).tap do |uri|
        uri.path = "/api/#{@app_id}" + path
        uri.query = URI.encode_www_form(params.merge(token: @token)).gsub! "%5B", "["
        uri.query.gsub! "%5D", "]"
        uri.query.gsub! "%3A", ":"
        uri.query.gsub! "%7C", "|"
        uri.query.gsub! "%2B", "+"
      end
    end

    def build_request(verb, uri, payload: nil)
      class_for_request(verb).new(uri.request_uri).tap do |request|
        # set headers
        DEFAULT_HEADERS.each do |key, value|
          request.add_field(key, value)
        end

        # set basic auth
        # username = Appsignal token, password = "token"
        request.basic_auth token, 'token'

        # set payload
        request.body = JSON.generate(payload) if payload
      end
    end

    def build_connection(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |connection|
        if uri.scheme == "https"
          connection.use_ssl = true
          connection.ssl_version = "TLSv1_2"
          connection.ciphers = "TLSv1.2:!aNULL:!eNULL"
          connection.open_timeout = 5
          connection.read_timeout = 5
        end
      end
    end

    def class_for_request(verb)
      Net::HTTP.const_get(verb.to_s.capitalize)
    end

    def success(response)
      if response.body && (response.content_type || '').include?("json")
        JSON.parse(response.body, JSON_PARSE_OPTIONS)
      else
        response.body
      end
    rescue StandardError
      response.body
    end

    def error(request, response)
      # Use the correct exception class
      klass = case response
              when Net::HTTPClientError
                HTTPClientError
              when Net::HTTPServerError
                HTTPServerError
              else
                HTTPError
              end

      if (response.content_type || '').include?("json")
        # Attempt to parse the error as JSON
        begin
          json = JSON.parse(response.body, JSON_PARSE_OPTIONS)

          raise klass.new(request, response, json[:errors]) if json[:errors]
        rescue JSON::ParserError; end
      end

      raise klass.new(request, response, [response.body])
    end
  end
end
