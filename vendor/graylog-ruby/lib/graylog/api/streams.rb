module Graylog
  class API::Streams < Endpoint
    def all
      http.
      get('/api/streams')[:streams].
      map {|attrs| Stream.build(attrs) }
    end

    def create(stream)
      http.
      post('/api/streams', payload: stream.create_params)[:stream_id]
    end

    def resume(id)
      http.
      post("/api/streams/#{id}/resume")
    end

    def destroy(id)
      http.
      delete("/api/streams/#{id}")
    end
  end
end
