module Graylog
  class SlackAlarmCallback
    include Virtus.model

    attribute :id, String

    # important attributes
    attribute :title, String
    attribute :graylog2_url, String
    attribute :channel, String, default: '#infrastructure'
    attribute :notify_channel, Boolean, default: false
    attribute :webhook_url, String

    # those can be left with their default values
    attribute :type, String, default: 'org.graylog2.plugins.slack.callback.SlackAlarmCallback'
    attribute :add_attachment, Boolean, default: true
    attribute :backlog_items, Integer, default: 5
    attribute :color, String, default: '#FF0000'
    attribute :custom_fields, String
    attribute :icon_emoji, String
    attribute :icon_url, String
    attribute :link_names, Boolean, default: true
    attribute :proxy_address, String
    attribute :short_mode, Boolean, default: false
    attribute :user_name, String, default: 'Graylog'

    def self.build(data = {})
      new(data)
    end

    def create_params
      {
        title: title,
        type: type,
        configuration: {
          add_attachment: add_attachment,
          backlog_items: backlog_items,
          channel: channel,
          color: color,
          custom_fields: custom_fields,
          graylog2_url: graylog2_url,
          icon_emoji: icon_emoji,
          icon_url: icon_url,
          link_names: link_names,
          notify_channel: notify_channel,
          proxy_address: proxy_address,
          short_mode: short_mode,
          user_name: user_name,
          webhook_url: webhook_url
        }
      }
    end
  end
end
