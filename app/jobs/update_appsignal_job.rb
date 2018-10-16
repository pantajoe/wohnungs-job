class UpdateAppsignalJob < ApplicationJob
  class WrongAppsignalIdError < StandardError; end

  queue_as :default

  def perform(*_args)
    fetch_appsignal
  end

  def fetch_appsignal
    projects = Project.not_archived.where.not(appsignal_id: nil)
    projects.find_each do |project|
      appsignal = Appsignal::Client.build(app_id: project.appsignal_id, token: ENV.fetch('APPSIGNAL_TOKEN'))
      data = nil
      begin
        if AvailabilityLog.appsignal.exists?
          log = AvailabilityLog.appsignal.last
          data = appsignal.graphs.data(from: log.timestamp)
        else
          data = appsignal.graphs.data
        end

        AvailabilityLog.create(status: 'successful', timestamp: Time.now, log_type: 'appsignal')

        data.each do |datum|
          if !project.performances.exists?(date: datum.timestamp.to_date)
            project.performances.create(date: datum.timestamp.to_date, response_time: datum.mean, requests: datum.count, error_rate: datum.ex_rate.round(2), clean_errors: datum.ex)
          else
            performance = project.performances.where(date: datum.timestamp.to_date).last
            performance.update(response_time: (performance.try(:response_time) || 0) + datum.mean, requests: (performance.try(:requests) || 0) + datum.count, error_rate: (performance.try(:error_rate) || 0) + datum.ex_rate.round(2), clean_errors: (performance.try(:clean_errors) || 0) + datum.ex)
          end
        end
      rescue Appsignal::HTTPClientError
        raise WrongAppsignalIdError, "wrong appsignal id for project '#{project.title}'"
      rescue Appsignal::HTTPConnectionError
        AvailabilityLog.create(status: 'failed', timestamp: Time.now, log_type: 'appsignal')
      end
    end
  end
end
