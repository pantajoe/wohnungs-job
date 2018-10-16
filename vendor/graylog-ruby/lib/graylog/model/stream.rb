module Graylog
  class Stream
    include Virtus.model

    attribute :id, String
    attribute :title, String
    attribute :description, String
    attribute :index_set_id, String
    attribute :rules, Array[StreamRule]

    def self.build(data = {})
      new(data)
    end

    def create_params
      {
        title: title,
        description: description,
        index_set_id: index_set_id,
        rules: rules.map(&:create_params)
      }
    end
  end
end
