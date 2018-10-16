class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.binary :file
      t.datetime :created_on
      t.date :month
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
