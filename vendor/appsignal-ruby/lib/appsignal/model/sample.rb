module Appsignal
  class Sample
    include Virtus.model

    attribute :id, String
    attribute :action, String
    attribute :path, String
    attribute :duration, Float
    attribute :status, Numeric
    attribute :time, DateTime
    attribute :exception, String, default: nil

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        next if [:id, :action, :path, :duration, :status, :time, :is_exception, :exception].include?(key)
        hsh[key] = value
      end

      new(
        id: data[:id],
        action: data[:action],
        path: data[:path],
        duration: data[:duration],
        status: data[:status],
        time: Time.at(data[:time]).to_datetime,
        exception: (data[:exception])[:name]
      )
    end
  end
end
