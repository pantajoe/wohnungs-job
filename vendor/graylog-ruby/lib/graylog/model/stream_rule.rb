module Graylog
  class StreamRule
    include Virtus.model

    attribute :description, String
    attribute :field, String
    attribute :inverted, Boolean, default: false
    attribute :value, String

    # 1 = match exactly
    # 2 = match regular expression
    # 3 = greater than
    # 4 = smaller than
    # 5 = field presence
    # 6 = contain
    # 7 = always match
    attribute :type, Integer

    def self.build(data = {})
      new(data)
    end

    def create_params
      attributes
    end
  end
end
