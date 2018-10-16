module Appsignal
  class Exception
    include Virtus.model

    attribute :message, String
    attribute :name, String
    attribute :backtrace, Array

    def self.build(data = {})
      custom_fields = data.each_with_object({}) do |(key, value), hsh|
        hsh[key] = value
      end

      new(
        message: data[:message],
        name: data[:name],
        backtrace: data[:backtrace]
      )
    end
  end
end
