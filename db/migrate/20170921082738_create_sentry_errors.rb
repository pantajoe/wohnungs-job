class CreateSentryErrors < ActiveRecord::Migration[5.1]
  def change
    create_table :sentry_errors do |t|
      t.date :day
      t.integer :number_of_events
      t.string :tech_name

      t.timestamps
    end
  end
end
