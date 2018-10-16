module Graylog
  class API::AlarmCallbacks < Endpoint
    def create(stream_id, alarm_callback)
      http.
      post("/api/streams/#{stream_id}/alarmcallbacks",
           payload: alarm_callback.create_params)
    end
  end
end
