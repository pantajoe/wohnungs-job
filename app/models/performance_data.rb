class PerformanceData
  class PerformanceWithError
    attr_reader :date, :requests, :response_time, :error_rate, :total_errors, :clean_errors

    def initialize(date, requests, response_time, error_rate, total_errors, clean_errors)
      @date = date
      @requests = requests
      @response_time = response_time
      @error_rate = error_rate
      @total_errors = total_errors
      @clean_errors = clean_errors
    end
  end

  attr_reader :performances

  def initialize(project_id, any_day_in_month)
    @performances = PerformanceData.for_month(project_id, any_day_in_month)
  end

  def error_rates
    @performances.map(&:error_rate)
  end

  def requests
    @performances.map(&:requests)
  end

  def response_times
    @performances.map(&:response_time)
  end

  def errors
    @performances.map(&:total_errors)
  end

  def clean_errors
    @performances.map(&:clean_errors)
  end

  def weighted_response_avg
    sum = 0
    reqsum = 0
    @performances.each do |performance|
      sum += performance.requests * performance.response_time
      reqsum += performance.requests
    end
    if sum != 0 && reqsum != 0
      sum / reqsum
    else
      0
    end
  end

  def self.for_month(project_id, any_day_in_month)
    any_day_in_month.all_month.map do |day|
      PerformanceWithError.new(day,
                               Performance.where(project_id: project_id, date: day).first.try(:requests)        || 0,
                               Performance.where(project_id: project_id, date: day).first.try(:response_time)   || 0,
                               Performance.where(project_id: project_id, date: day).first.try(:error_rate)      || 0.0,
                               SentryError.where(project_id: project_id, day: day).first.try(:number_of_events) || 0,
                               Performance.where(project_id: project_id, date: day).first.try(:clean_errors)    || 0)
    end
  end
end
