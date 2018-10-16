class RenameTechNameSentryErrors < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :sentry_errors, :tech_name, :repo_name
    rename_column :sentry_error_logs, :tech_name, :repo_name
  end

  def self.down
    rename_column :sentry_errors, :repo_name, :tech_name
    rename_column :sentry_error_logs, :repo_name, :tech_name
  end
end
