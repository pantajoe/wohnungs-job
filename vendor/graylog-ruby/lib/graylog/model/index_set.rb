module Graylog
  class IndexSet
    include Virtus.model

    attribute :id, String
    attribute :default, Boolean

    def self.build(data = {})
      new(data)
    end
  end
end
