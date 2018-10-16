class IncidentLog < ApplicationRecord
  belongs_to :incident, inverse_of: :incident_logs
end
