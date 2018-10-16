module Chartable
  protected

  def set_chart_variables
    gon.last_day_of_month = Date.today.end_of_month.day
    gon.month_name = ". #{l(Date.today, format: :month)}"
    gon.requests = @performances.requests
    gon.error_rates = @performances.error_rates
    gon.response_times = @performances.response_times
  end
end
