require 'uri'

module Graylog
  class Client < Endpoint
    def index_sets
      @index_sets ||= API::IndexSets.new(http)
    end

    def streams
      @streams ||= API::Streams.new(http)
    end

    def alert_conditions
      @alert_conditions ||= API::AlertConditions.new(http)
    end

    def alarm_callbacks
      @alarm_callbacks ||= API::AlarmCallbacks.new(http)
    end

    def universal_search
      @universal_search ||= API::UniversalSearch.new(http)
    end
  end
end
