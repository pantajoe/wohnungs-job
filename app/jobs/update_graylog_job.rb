class UpdateGraylogJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    fetch_logs
    fetch_incidents
  end

  def fetch_incidents
    projects = Project.not_archived
    projects.find_each do |project|
      logs = IncidentLog.where(project_name: project.repo_name, incident_id: nil).order(timestamp: :asc)
      logs.find_each do |log|
        if log.metric_value.eql? 'failing'
          if !Incident.exists?(time_to: nil, project_id: project.id) # only closed incidents
            incident = project.incidents.new(time_from: log.timestamp)
            incident.save(validate: false)
          else # open incident -> no new incident
            incident = Incident.where(time_to: nil).last
          end
          log.incident_id = incident.id
          log.save
        elsif Incident.exists?(project_id: project.id) # healthy
          if !Incident.exists?(time_to: nil, project_id: project.id) # only closed incidents
            incident = Incident.all.last
          else # open incident -> add time_to
            incident = Incident.where(time_to: nil).last
            incident.time_to = log.timestamp
            incident.save(validate: false)
          end
          log.incident_id = incident.id
          log.save
        else
          log.incident_id = 1.0 / 0
          log.save(validate: false)
        end
      end
    end
  end

  def fetch_logs
    graylog = Graylog::Client.build(address: ENV.fetch('GRAYLOG_ADDRESS'), token: ENV.fetch('GRAYLOG_TOKEN'))
    messages = nil

    if AvailabilityLog.exists?
      log = AvailabilityLog.graylog.last
      messages = graylog.universal_search.relative(query: 'ZWTG_METRIC_KIND:http_check', range: (TimeDifference.between(log.timestamp, Time.now).in_seconds.round(0) + 1800).to_s)
    else
      messages = graylog.universal_search.relative(query: 'ZWTG_METRIC_KIND:http_check', range: '1000600')
    end

    AvailabilityLog.create(status: 'successful', timestamp: Time.now, log_type: 'graylog')

    messages.reverse_each do |m|
      unless IncidentLog.exists?(graylog_id: m.id)
        incident_log = IncidentLog.new(metric_value: m.custom_fields[:ZWTG_METRIC_VALUE], project_name: m.custom_fields[:ZWTG_PROJECT], timestamp: m.timestamp, graylog_id: m.id)
        incident_log.save(validate: false)
      end
    end
  rescue StandardError
    AvailabilityLog.create(status: 'failed', timestamp: Time.now, log_type: 'graylog')
  end
end
