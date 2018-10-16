class CreateSentryErrorLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :sentry_error_logs do |t|
      t.integer :timestamp
      t.integer :errors
      t.string :tech_name
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
