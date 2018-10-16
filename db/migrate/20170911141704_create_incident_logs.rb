class CreateIncidentLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :incident_logs do |t|
      t.string :metric_value
      t.string :project_name
      t.datetime :timestamp
      t.string :graylog_id

      t.timestamps
    end
  end
end
