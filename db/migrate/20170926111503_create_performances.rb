class CreatePerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :performances do |t|
      t.datetime :date
      t.integer :requests
      t.integer :response_time
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
