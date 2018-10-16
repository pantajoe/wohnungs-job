module Appsignal
  class Event
    include Virtus.model

    attribute :action, String
    attribute :duration, Float
    attribute :group, String
    attribute :name, String
    attribute :paylod, Hash
    attribute :time, DateTime
    attribute :end, DateTime
    attribute :digest, Numeric
    attribute :allocation_count, Numeric

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        next if [:action, :duration, :group, :name, :payload, :time, :end, :digest, :allocation_count].include?(key)
        hsh[key] = value
      end

      new(
        action: data[:action],
        duration: Time.at(data[:duration]).utc.strftime("%H:%M:%S"),
        group: data[:group],
        name: data[:name],
        payload: data[:payload],
        time: data[:time],
        end: data[:end],
        digest: data[:digest],
        allocation_count: data[:allocation_count]
      )
    end
  end
end
