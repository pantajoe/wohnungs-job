require 'date'

module Graylog
  class Message
    include Virtus.model

    attribute :id, String
    attribute :timestamp, DateTime
    attribute :source, String
    attribute :level, Integer
    attribute :streams, Array[String]
    attribute :message, String
    attribute :custom_fields, Hash

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        next if [:_id, :timestamp, :source, :level, :streams, :message].include?(key)
        hsh[key] = value
      end

      new(
        id: data[:_id],
        timestamp: DateTime.parse(data[:timestamp]),
        source: data[:source],
        level: data[:level],
        streams: data[:streams],
        message: data[:message],
        custom_fields: custom_fields
      )
    end
  end
end
