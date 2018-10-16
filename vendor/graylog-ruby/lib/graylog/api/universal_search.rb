module Graylog
  class API::UniversalSearch < Endpoint
    def relative(query:, range:)
      http.
      get('/api/search/universal/relative', params: {query: query, range: range})[:messages].
      map {|raw_message| Message.build(raw_message[:message]) }
    end
  end
end
