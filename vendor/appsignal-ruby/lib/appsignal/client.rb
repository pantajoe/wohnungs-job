require 'uri'

module Appsignal
  class Client < Endpoint
    def graphs
      @graphs ||= API::Graphs.new(http)
    end

    def samples
      @samples ||= API::Samples.new(http)
    end
  end
end
