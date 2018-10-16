module Graylog
  class API::AlertConditions < Endpoint
    def create(stream_id, alert_condition)
      http.
      post("/api/streams/#{stream_id}/alerts/conditions",
           payload: alert_condition.create_params)[:alert_condition_id]
    end
  end
end
