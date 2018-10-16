module Graylog
  class API::IndexSets < Endpoint
    def all
      http.
      get('/api/system/indices/index_sets')[:index_sets].
      map {|attrs| IndexSet.new(attrs) }
    end
  end
end
