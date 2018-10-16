module Graylog
  class AlertCondition
    include Virtus.model

    attribute :id, String
    attribute :title, String
    attribute :type, String # one of field_content_value, field_value, message_count
    attribute :time, Integer
    attribute :threshold_type, String # one of MORE, LESS
    attribute :threshold, Integer
    attribute :grace, Integer
    attribute :backlog, Integer
    attribute :repeat_notifications, Boolean, default: false

    def self.build(data = {})
      new(data)
    end

    def create_params
      {
        title: title,
        type: type,
        parameters: {
          time: time,
          threshold_type: threshold_type,
          threshold: threshold,
          grace: grace,
          backlog: backlog,
          repeat_notifications: repeat_notifications
        }
      }
    end
  end
end
