class ChangeSentryErrorLogsErrors < ActiveRecord::Migration[5.1]
  def change
    remove_column :sentry_error_logs, :errors
    add_column :sentry_error_logs, :events, :integer
  end

  def down
    remove_column :reports, :events
    add_column :reports, :errors, :integer
  end
end
