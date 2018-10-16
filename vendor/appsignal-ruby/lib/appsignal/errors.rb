module Appsignal
  class AppsignalError < RuntimeError; end

  class HTTPConnectionError < AppsignalError
    attr_reader :request, :original

    def initialize(request, original)
      @request = request
      @original = original
    end
  end

  class HTTPError < AppsignalError
    attr_reader :request, :response, :errors

    def initialize(request, response, errors = [])
      @request, @response, @errors = request, response, errors
      super("#{request.method} #{response.code} '#{request.path}'")
    end

    def code
      response.code.to_i
    end
  end

  class HTTPClientError < HTTPError; end
  class HTTPServerError < HTTPError; end
end
