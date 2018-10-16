require 'rails_helper'

RSpec.describe PerformanceData do
  describe '.for_month' do
    before :each do
      @project = Project.create(title: 'test', customer: 'Herr Test', repo_name: 'test', appsignal_id: '1A2B3C4D5C6E7F', email: 'test@test.de')
      @project.performances.create(date: Date.parse('2017-01-01'), requests: 50, error_rate: 20, response_time: 500)
      @project.sentry_errors.create(day: Date.parse('2017-01-01'), number_of_events: 10)
      @project.performances.create(date: Date.parse('2017-01-15'), requests: 80, error_rate: 6.25, response_time: 555)
      @project.sentry_errors.create(day: Date.parse('2017-01-15'), number_of_events: 5)
    end

    it "january" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.length).to eq(31)
    end
    it "february" do
      date = Date.parse('2017-02-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.length).to eq(28)
    end
    it "first January" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.first.date).to eq(Date.parse('2017-01-01'))
      expect(performance_with_errors.performances.last.date).to eq(Date.parse('2017-01-31'))
    end
    it "requests first day" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.first.requests).to eq(50)
      expect(performance_with_errors.performances.last.requests).to eq(0)
    end
    it "response_time first day" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.first.response_time).to eq(500)
      expect(performance_with_errors.performances.last.response_time).to eq(0)
    end
    it "error_rate first day" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      expect(performance_with_errors.performances.first.error_rate).to eq(20)
      expect(performance_with_errors.performances.last.error_rate).to eq(0)
    end
    it "get error_rates of one month" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      error_rates = performance_with_errors.error_rates
      expect(error_rates).to eq([20] + [0] * 13 + [6.25] + [0] * 16)
    end
    it "get response_times of one month" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      response_times = performance_with_errors.response_times
      expect(response_times).to eq([500] + [0] * 13 + [555] + [0] * 16)
    end
    it "get requests of one month" do
      date = Date.parse('2017-01-01')
      performance_with_errors = PerformanceData.new(@project.id, date)
      requests = performance_with_errors.requests
      expect(requests).to eq([50] + [0] * 13 + [80] + [0] * 16)
    end
  end
end
