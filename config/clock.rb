require 'rubygems'
require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  handler do |job, time|
    Rails.logger.info "Running #{job}, at #{time}"
  end

  every(10.minutes, 'update_graylog') do
    UpdateGraylogJob.perform_now
  end
  every(30.minutes, 'update_sentry') do
    UpdateSentryJob.perform_now
  end
  every(10.minutes, 'update_appsignal') do
    UpdateAppsignalJob.perform_now
  end
  every(1.week, 'generate_reports') do
    GenerateReportsJob.perform_now(Date.new(Date.today.year, Date.today.month - 1, 1))
  end
end
