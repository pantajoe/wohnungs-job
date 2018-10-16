module Graylog
  class Endpoint
    def self.build(address:, token:)
      http_client = Http.new(address: address, token: token)
      new(http_client)
    end

    attr_reader :http
    def initialize(http)
      @http = http
    end

    def build_params(*args, from: {})
      from.select {|key, value| args.include?(key) }
    end

    def with_retries(retries: 3, wait_time: 2, &block)
      self.class.with_retries(retries: retries, wait_time: wait_time, &block)
    end

    def when_status(codes = {})
      yield
    rescue HTTPClientError => e
      return codes[e.code] if codes.key?(e.code)
      raise
    end

    def self.with_retries(retries: 3, wait_time: 2)
      yield
    rescue StandardError
      retries -= 1
      if retries > 0
        sleep(wait_time) and retry
      else
        raise
      end
    end
  end
end
