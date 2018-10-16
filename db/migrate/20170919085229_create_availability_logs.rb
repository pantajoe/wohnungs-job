class CreateAvailabilityLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :availability_logs do |t|
      t.string :status
      t.datetime :timestamp

      t.timestamps
    end
  end
end
