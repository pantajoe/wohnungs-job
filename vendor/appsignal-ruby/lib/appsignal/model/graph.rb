module Appsignal
  class Graph
    include Virtus.model

    attribute :mean, Float
    attribute :count, Numeric
    attribute :timestamp, DateTime
    attribute :ex, Numeric
    attribute :ex_rate, Float
    attribute :pct, Numeric

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        next if [:mean, :timestamp, :count, :ex, :ex_rate, :pct].include?(key)
        hsh[key] = value
      end

      new(
        timestamp: Time.at(data[:timestamp]).to_datetime,
        mean: data[:mean],
        count: data[:count],
        ex: data[:ex],
        ex_rate: data[:ex_rate],
        pct: data[:pct]
      )
    end
  end
end
