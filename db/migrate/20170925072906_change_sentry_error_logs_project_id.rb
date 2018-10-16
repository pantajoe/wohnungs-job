class ChangeSentryErrorLogsProjectId < ActiveRecord::Migration[5.1]
  def change
    remove_column :sentry_error_logs, :project_id
    add_reference :sentry_error_logs, :sentry_errors, foreign_key: true
  end

  def down
    remove_reference :sentry_error_logs, :sentry_errors
    add_column :sentry_error_logs, :project_id
  end
end
