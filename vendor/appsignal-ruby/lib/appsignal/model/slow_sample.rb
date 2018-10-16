module Appsignal
  class SlowSample
    include Virtus.model

    attribute :id, String
    attribute :action, String
    attribute :db_runtime, Float
    attribute :duration, Float
    attribute :environment, Hash
    attribute :hostname, String
    attribute :kind, String
    attribute :params, Hash
    attribute :path, String
    attribute :request_format, String
    attribute :request_method, String
    attribute :session_data, Hash
    attribute :status, String
    attribute :view_runtime, Float
    attribute :time, DateTime
    attribute :end, Integer
    attribute :allocation_count, Numeric
    attribute :events, Array
    attribute :exception, String, default: nil

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        hsh[key] = value
      end

      new(
        id: data[:id],
        action: data[:action],
        db_runtime: Time.at(data[:db_runtime]).utc.strftime("%H:%M:%S"),
        duration: Time.at(data[:duration]).utc.strftime("%H:%M:%S"),
        environment: data[:environment],
        hostname: data[:hostname],
        kind: data[:kind],
        params: data[:params],
        path: data[:path],
        request_format: data[:request_format],
        request_method: data[:request_method],
        session_data: data[:session_data],
        status: data[:status],
        view_runtime: Time.at(data[:view_runtime]).utc.strftime("%H:%M:%S"),
        time: Time.at(data[:time]).to_datetime,
        end: data[:end],
        allocation_count: data[:allocation_count],
        events: data[:events].map {|event| Event.build(event) },
        exception: data[:exception]
      )
    end
  end
end
