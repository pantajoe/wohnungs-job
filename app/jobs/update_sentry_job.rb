class UpdateSentryJob < ApplicationJob
  class WrongSentryIdOrToken < StandardError; end

  queue_as :default
  require 'date'

  def perform(*_args)
    fetch_sentry_error_logs
    fetch_sentry_errors
  end

  def fetch_sentry_error_logs
    messages = nil
    Project.not_archived.find_each do |project|
      if AvailabilityLog.exists?(status: 'successful', log_type: 'sentry')
        log = AvailabilityLog.where(status: 'successful', log_type: 'sentry').last
        messages = SentryApi.project_stats(project.repo_name, since: (log.timestamp.to_i - 3600).to_s)
      else
        messages = SentryApi.project_stats(project.repo_name, since: (Time.now.to_i - 2_678_400).to_s)
      end

      AvailabilityLog.create(status: 'successful', timestamp: Time.now, log_type: 'sentry')

      messages.each_index do |m|
        unless SentryErrorLog.exists?(timestamp: messages[m][0])
          sentry_error_log = SentryErrorLog.new(timestamp: messages[m][0], events: messages[m][1], repo_name: ENV.fetch('SENTRY_API_PROJECT_SLUG'))
          sentry_error_log.save(validate: false)
        end
      end
    rescue SentryApi::Error::NotFound
      raise WrongSentryIdOrToken, "wrong project slug or token for sentry for project '#{project.title}'"
    end
  rescue StandardError
    AvailabilityLog.create(status: 'failed', timestamp: Time.now, log_type: 'sentry')
  end

  def fetch_sentry_errors
    projects = Project.not_archived
    projects.find_each do |project|
      errors = SentryErrorLog.where(repo_name: project.repo_name, sentry_errors_id: nil)
      errors.each do |error|
        timestamp = Time.at(error.timestamp).to_datetime
        if !SentryError.exists?(day: timestamp)
          sentry_error = project.sentry_errors.new(day: timestamp, number_of_events: error.events)
        else
          sentry_error = SentryError.where(day: timestamp).last
          sentry_error.number_of_events = sentry_error.number_of_events + error.events
        end
        sentry_error.save
        error.sentry_errors_id = sentry_error.id
        error.save(validate: false)
      end
    end
  end
end
