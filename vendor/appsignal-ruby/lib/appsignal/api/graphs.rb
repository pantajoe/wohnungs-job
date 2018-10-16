module Appsignal
  class API::Graphs < Endpoint
    def data(action_name: nil, exception: nil, from: nil, to: nil, timeframe: "month", fields: ["mean", "count", "ex", "ex_rate"])
      params = {}
      tf = true
      if from
        params = params.merge(from: from.to_time.iso8601)
        tf = false
      end
      if to
        params = params.merge(to: to.to_time.iso8601)
        tf = false
      end
      if action_name
        params = if exception
                   params.merge(action_name: (action_name.gsub '#', '-hash-') + ":|:" + exception)
                 else
                   params.merge(action_name: action_name)
                 end
      end
      if tf
        params = params.merge(timeframe: timeframe) if timeframe
      end

      http.
        get("/graphs.json", params: params.merge("fields[]" => fields))[:data].
      map {|data| Graph.build(data) }
    end
  end
end
